#include "../game/q_shared.h"
#include "../qcommon/qcommon.h"

#include "net_adhoc.h"

int loaded = 0;

int pspSdkLoadAdhocModules()
{
	if(!loaded) 
      {
		loaded = 1;
	
       	if(sceUtilityLoadNetModule(PSP_NET_MODULE_ADHOC)<0)
		{
			printf("Error loading AD HOC module\n");
			return -1;
		} 
            else 
                  printf("WLAN: AD HOC Module loaded\n");
	
        	if(sceUtilityLoadNetModule(PSP_NET_MODULE_COMMON)<0)
		{
			printf("Error loading COMMON module\n");
			return -1;
		} 
            else 
                  printf("WLAN: COMMON Module loaded\n");
		
            if(sceUtilityLoadNetModule(PSP_NET_MODULE_INET)<0)
	      {
			printf("Error loading INET module");
			return -1;
		} 
            else 
                  printf("WLAN: INET Module loaded\n"); 
	
      	return 0;
	}
}

int pspSdkAdhocInit(char *product)
{
	u32 retVal;
	struct productStruct temp;

    retVal = sceNetInit(0x20000, 0x20, 0x1000, 0x20, 0x1000);
    if (retVal != 0)
        return retVal;

    retVal = sceNetAdhocInit();
    if (retVal != 0)
        return retVal;

	strcpy(temp.product, product);
	temp.unknown = 0;
	
    retVal = sceNetAdhocctlInit(0x2000, 0x20, &temp);
    if (retVal != 0)
        return retVal;

	return 0;
}

void pspSdkAdhocTerm()
{
	sceNetAdhocctlTerm();
	sceNetAdhocTerm();
	sceNetTerm();
}
int OpenSocket(int port)
{
	char mac[8];
	sceWlanGetEtherAddr(mac);
	int rc = sceNetAdhocPdpCreate(mac, port, 0x2000, 0);
	return rc;
}

int CloseSocket(int socket)
{
	sceNetAdhocPdpDelete(socket, 0);
	return -1;
}

int ADHOC_recv(int socket, char *buf, int len, psp_sockaddr *addr)
{
	int port;
	int ret;
	sceKernelDelayThread(1);
	ret = sceNetAdhocPdpRecv(socket, addr->mac, &port, buf, &len, 0, 1);
	if(ret == 0x80410709) return 0; // neblokujici sokety
	if(ret < -1) 
         Sys_Error("WLAN: error recv 0x%08X",ret);
	
    addr->port = port;
	return len;
}

int ADHOC_send(int socket, char *buf, int len, psp_sockaddr *addr)
{
	int ret = -1;
	sceKernelDelayThread(1);
	ret = sceNetAdhocPdpSend(socket, addr->mac, addr->port, buf, len, 0, 1);
	if(ret < 0) 
         Sys_Error("WLAN: error send 0x%08X MAC: %02X:%02X:%02X:%02X:%02X:%02X \n",ret,addr->mac[0],addr->mac[1],addr->mac[2],addr->mac[3],addr->mac[4],addr->mac[5]);
	return ret;
}

char *AddrToString(psp_sockaddr *addr)
{
	static char buffer[22];
	sceNetEtherNtostr((unsigned char *)addr->mac, buffer);
	// sprintf(buffer + strlen(buffer)+1, ":%d", addr->port);
	return buffer;
}

int StringToAddr(char *string, psp_sockaddr *addr)
{
	int ha1, ha2, ha3, ha4, ha5, ha6, hp;

	sscanf(string, "%x:%x:%x:%x:%x:%x", &ha1, &ha2, &ha3, &ha4, &ha5, &ha6);

	addr->mac[0] = ha1 & 0xFF;
	addr->mac[1] = ha2 & 0xFF;
	addr->mac[2] = ha3 & 0xFF;
	addr->mac[3] = ha4 & 0xFF;
	addr->mac[4] = ha5 & 0xFF;
	addr->mac[5] = ha6 & 0xFF;
	addr->port = ADHOC_PORT;

	return 0;
}

int AddrCompare(psp_sockaddr *addr1, psp_sockaddr *addr2)
{
	//if((addr1->port != ADHOC_PORT) || (addr2->port != ADHOC_PORT)) return 0;
	if(memcmp(addr1->mac, addr2->mac, 6) != 0) return 0;
	return 1;
}

int Adhoc_Init()
{
	int i,rc;

	if(pspSdkLoadAdhocModules() < 0) 
         return -1;
//	unsigned char mac[6];
//	int stateLast = -1;

	if(!sceWlanGetSwitchState()) 
          return 0x80002991;

//	sceWlanGetEtherAddr((char *)mac);
	rc = pspSdkAdhocInit("ULUS40037");
	if(rc < 0)
	{
		printf("AdHoc: pspSdkAdhocInit failed: 0X%08X\n", rc);
		return rc;
	}

	rc = sceNetAdhocctlConnect("PSPQuake3");
	if(rc < 0)
	{
		printf("AdHoc: AdhocctlConnect failed: 0X%08X\n", rc);
		return rc;
	}

	while (1) 
      {
		int state;
		rc = sceNetAdhocctlGetState(&state);
		if (rc != 0) 
            {
			printf("AdHoc: sceNetApctlGetState failed: 0X%08X\n", rc);
			return rc;
		}

	      if (state == 1) 
                break;
	      sceKernelDelayThread(50*1000); // 50ms
	}

	printf("AdHoc: Initialized\n");
	return 0;
}

