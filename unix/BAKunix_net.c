/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Foobar; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/
// unix_net.c
#include "../game/q_shared.h"
#include "../qcommon/qcommon.h"

#include "net_adhoc.h"

#ifdef WITH_NET

#include <pspkernel.h>
#include <psputility.h>
#include <pspnet.h>
#include <pspnet_apctl.h>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/fcntl.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <unistd.h>
#include <netdb.h>
#include <errno.h>


#include "gethost.hpp"

#include <pspsdk.h>


static cvar_t	*noudp;

netadr_t	net_local_adr;

int			ip_socket;
int			ipx_socket;

#define	MAX_IPS		16

static	int		numIP;
static	byte	localIP[MAX_IPS][4];

int NET_Socket (char *net_interface, int port);
char *NET_ErrorString (void);

int net_init = 0;

//=============================================================================

void NetadrToSockadr (netadr_t *a, struct sockaddr_in *s)
{
	memset (s, 0, sizeof(*s));

	if (a->type == NA_BROADCAST)
	{
		s->sin_family = AF_INET;

		s->sin_port = a->port;
		*(int *)&s->sin_addr = -1;
	}
	else if (a->type == NA_IP)
	{
		s->sin_family = AF_INET;

		*(int *)&s->sin_addr = *(int *)&a->ip;
		s->sin_port = a->port;
	}
}

void SockadrToNetadr (struct sockaddr_in *s, netadr_t *a)
{
	*(int *)&a->ip = *(int *)&s->sin_addr;
	a->port = s->sin_port;
	a->type = NA_IP;
}

char	*NET_BaseAdrToString (netadr_t a)
{
	static	char	s[64];
	Com_sprintf (s, sizeof(s), "%i.%i.%i.%i", a.ip[0], a.ip[1], a.ip[2], a.ip[3]);
	return s;
}

/*
=============
Sys_StringToAdr

idnewt
192.246.40.70
=============
*/
qboolean	Sys_StringToSockaddr (const char *s, struct sockaddr *sadr)
{
	memset (sadr, 0, sizeof(*sadr));

	((struct sockaddr_in *)sadr)->sin_family = AF_INET;
	((struct sockaddr_in *)sadr)->sin_port = 0;
	//((struct sockaddr_in *)sadr)->sin_addr = NULL;
	
	return qtrue;
}

/*
=============
Sys_StringToAdr

localhost
idnewt
idnewt:28000
192.246.40.70
192.246.40.70:28000
=============
*/
qboolean	Sys_StringToAdr (const char *s, netadr_t *a)
{
	struct sockaddr_in sadr;
	
	if (!Sys_StringToSockaddr (s, (struct sockaddr *)&sadr))
		return qfalse;
	
	SockadrToNetadr (&sadr, a);

	return qtrue;
}


//=============================================================================

qboolean	Sys_GetPacket (netadr_t *net_from, msg_t *net_message)
{
	if(!net_init)
	   return qfalse;
	   
	if(NET_GetLoopPacket(ip_socket, net_from, net_message))
	{
        return qtrue;
    }

	int 	ret;
	struct sockaddr_in	from;
	int		fromlen;
	int		net_socket;
	int		err;
	
	
	net_socket = ip_socket;

	fromlen = sizeof(from);
	
    ret = ADHOC_recv(net_socket, net_message->data, net_message->maxsize, (struct psp_sockaddr *)&from);

	//SockadrToNetadr (&from, net_from);

	// bk000305: was missing
	net_message->readcount = 0;
	
	if (ret == net_message->maxsize)
	{
		Com_Printf ("Oversize packet from %s\n", NET_AdrToString (*net_from));
		return qfalse;
	}

	net_message->cursize = ret;

	return qtrue;
}

//=============================================================================

void	Sys_SendPacket( int length, const void *data, netadr_t to )
{
    if(!net_init)
	   return;
	if(to.type == NA_LOOPBACK)
	{
        NET_SendLoopPacket (ip_socket, length, data, to);
        return;
    }

	int		ret;
	struct sockaddr_in	addr;
	int		net_socket;
	
	net_socket = ip_socket;
	to.type = NA_IP;

	NetadrToSockadr (&to, &addr);

    ret = ADHOC_send(net_socket, (char*)data, length, (struct psp_sockaddr *)&addr);
	if (ret == -1)
	{
		Com_Printf ("NET_SendPacket ERROR: %s to %s\n", NET_ErrorString(),
				NET_AdrToString (to));
	}
}


//=============================================================================

/*
==================
Sys_IsLANAddress

LAN clients will have their rate var ignored
==================
*/
qboolean	Sys_IsLANAddress (netadr_t adr)
{
    if(!net_init)
	   return qfalse;
	//printf("%s\n",__FUNCTION__);
	int		i;

	if( adr.type == NA_LOOPBACK )
	{
		return qtrue;
	}

	if( adr.type == NA_IPX )
	{
		return qtrue;
	}

	if( adr.type != NA_IP )
	{
		return qfalse;
	}

	// choose which comparison to use based on the class of the address being tested
	// any local adresses of a different class than the address being tested will fail based on the first byte

	// Class A
	if( (adr.ip[0] & 0x80) == 0x00 )
	{
		for ( i = 0 ; i < numIP ; i++ )
		{
			if( adr.ip[0] == localIP[i][0] )
			{
				return qtrue;
			}
		}
		// the RFC1918 class a block will pass the above test
		return qfalse;
	}

	// Class B
	if( (adr.ip[0] & 0xc0) == 0x80 )
	{
		for ( i = 0 ; i < numIP ; i++ )
		{
			if( adr.ip[0] == localIP[i][0] && adr.ip[1] == localIP[i][1] )
			{
				return qtrue;
			}
			// also check against the RFC1918 class b blocks
			if( adr.ip[0] == 172 && localIP[i][0] == 172 && (adr.ip[1] & 0xf0) == 16 && (localIP[i][1] & 0xf0) == 16 )
			{
				return qtrue;
			}
		}
		return qfalse;
	}

	// Class C
	for ( i = 0 ; i < numIP ; i++ )
	{
		if( adr.ip[0] == localIP[i][0] && adr.ip[1] == localIP[i][1] && adr.ip[2] == localIP[i][2] )
		{
			return qtrue;
		}
		// also check against the RFC1918 class c blocks
		if( adr.ip[0] == 192 && localIP[i][0] == 192 && adr.ip[1] == 168 && localIP[i][1] == 168 )
		{
			return qtrue;
		}
	}
	return qfalse;
}

/*
==================
Sys_ShowIP
==================
*/
void Sys_ShowIP(void)
{
	int i;

	for (i = 0; i < numIP; i++)
	{
		Com_Printf( "IP: %i.%i.%i.%i\n", localIP[i][0], localIP[i][1], localIP[i][2], localIP[i][3] );
	}
}

/*
=====================
NET_GetLocalAddress
=====================
*/

void NET_GetLocalAddress( void )
{
	return qtrue;
/*
	//char				hostname[256];
	struct hostent		*hostInfo;
	// int					error; // bk001204 - unused
	char				*p;
	int					ip;
	int					n;
    char		buffer[16];

	sceNetApctlGetInfo(8,buffer);
	hostInfo = gethostbyname(buffer);

	if ( !hostInfo )
	{
		printf("Could not find information about hosts\n");
		return;
	}
    printf("gethost hight 2\n");
	printf( "Hostname: %s\n", hostInfo->h_name );
	n = 0;

	printf("gethost hight 3\n");

    printf("gethost hight 4\n");
	if ( hostInfo->h_addrtype != AF_INET )
	{
		return;
	}
    printf("gethost hight 5\n");
	numIP = 0;
	while( ( p = hostInfo->h_addr_list[numIP++] ) != NULL && numIP < MAX_IPS )
	{
		ip = ntohl( *(int *)p );
		localIP[ numIP ][0] = p[0];
		localIP[ numIP ][1] = p[1];
		localIP[ numIP ][2] = p[2];
        localIP[ numIP ][3] = p[3];
		printf( "IP: %i.%i.%i.%i\n", ( ip >> 24 ) & 0xff, ( ip >> 16 ) & 0xff, ( ip >> 8 ) & 0xff, ip & 0xff );
	}
    printf("gethost hight 6\n");
*/
}


/*
====================
NET_OpenIP
====================
*/
// bk001204 - prototype needed
int NET_IPSocket (char *net_interface, int port);
void NET_OpenIP (void)
{
	cvar_t	*ip;
	int		port;
	int		i;

    ip = Cvar_Get ("net_ip", "localhost", 0);
    
	port = Cvar_Get("net_port", va("%i", PORT_SERVER), 0)->value;

	ip_socket = NET_IPSocket (ip->string, port);
	if ( ip_socket )
	{
		//Cvar_SetValue( "net_port", 2209 );
		NET_GetLocalAddress();
		return;
	}
	Com_Error (ERR_FATAL, "Couldn't allocate IP port");
}

/*
====================
NET_Init
====================
*/
void NET_Init (void)
{
  if(Adhoc_Init() != 0)
	 Sys_Error("Adhoc init error\n");

  net_init = 1;

  noudp = Cvar_Get ("net_noudp", "0", 0);
  // open sockets
  if (! noudp->value)
  {
		NET_OpenIP ();
  }
}


/*
====================
NET_IPSocket
====================
*/
int NET_IPSocket (char *net_interface, int port)
{
	int newsocket;
	struct sockaddr_in address;
	int	i = 1;

	if ( net_interface )
	{
		Com_Printf("Opening IP socket: %s:%i\n", net_interface, port );
	}
	else
	{
		Com_Printf("Opening IP socket: localhost:%i\n", port );
	}

    if ((newsocket = OpenSocket(ADHOC_PORT)) == -1)
	{
		Com_Printf ("ERROR: UDP_OpenSocket: socket: %s", NET_ErrorString());
		return 0;
	}

	
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(27960);
	address.sin_family = AF_INET;
    printf("Opened\n");

	return newsocket;
}

/*
====================
NET_Shutdown
====================
*/
void	NET_Shutdown (void)
{
    pspSdkAdhocTerm();
    CloseSocket(ip_socket);
    net_init = 0;
}


/*
====================
NET_ErrorString
====================
*/
char *NET_ErrorString (void)
{
	int		code;

	code = errno;
	return strerror (code);
}

// sleeps msec or until net socket is ready
void NET_Sleep(int msec)
{
#if 0
    //printf("%s\n",__FUNCTION__);
	struct timeval timeout;
	fd_set	fdset;
	//extern qboolean stdin_active;

	//if (!ip_socket || !com_dedicated->integer)
	//	return; // we're not a server, just run full speed

	FD_ZERO(&fdset);
	//if (stdin_active)
	//FD_SET(0, &fdset); // stdin is processed too
	FD_SET(ip_socket, &fdset); // network socket
	timeout.tv_sec = msec/1000;
	timeout.tv_usec = (msec%1000)*1000;
	select(ip_socket+1, &fdset, NULL, NULL, &timeout);
#endif
}

#else // WITH_NET

/*
=============
NET_StringToAdr

localhost
idnewt
idnewt:28000
192.246.40.70
192.246.40.70:28000
=============
*/
qboolean	Sys_StringToAdr (const char *s, netadr_t *a)
{
	if (!strcmp (s, "localhost")) {
		memset (a, 0, sizeof(*a));
		a->type = NA_LOOPBACK;
		return qtrue;
	}

	return qfalse;
}

qboolean	Sys_IsLANAddress (netadr_t adr)
{
  return qtrue;
}

/*
==================
Sys_SendPacket
==================
*/
void Sys_SendPacket( int length, const void *data, netadr_t to )
{
}

void NET_Init (void)
{
}
void	NET_Shutdown (void)
{
}
void NET_Sleep(int msec)
{
}
void Sys_ShowIP(void)
{
}

/*
==================
Sys_GetPacket

Never called by the game logic, just the system event queing
==================
*/
qboolean	Sys_GetPacket (netadr_t *net_from, msg_t *net_message)
{
	return qfalse;
}


#endif // WITH_NET
