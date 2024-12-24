/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.
Copyright (C) 2009-2010 Crow_bar.

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
#include <stdexcept>
#include <vector>
#include <sys/unistd.h>

#include <pspkernel.h>
#include <psppower.h>
#include <pspctrl.h>
#include <kubridge.h>

#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <sys/wait.h>
#include <errno.h>
#include <setjmp.h>
#include <sys/stat.h>
#include <sys/time.h>
#include "system.h"

#define PSPINI
//#define USE_EXT_MEM

extern "C"
{
#include "../game/q_shared.h"
#include "../qcommon/qcommon.h"
#include "linux_local.h" // bk001204
#include "exception.h"
extern jmp_buf abortframe;
}

/* Define the module info section */
PSP_MODULE_INFO("Quake 3", 0, 1, 1);
PSP_MAIN_THREAD_ATTR(PSP_THREAD_ATTR_USER | PSP_THREAD_ATTR_VFPU);
//PSP_HEAP_SIZE_KB(-30 * 1024); // 30 mb free for hunk and modules
PSP_HEAP_SIZE_KB(-8 * 1024); //8mb for modules

void disableFloatingPointExceptions()
{

 asm(
	".set push\n"
	".set noreorder\n"
	"cfc1    $2, $31\n"		// Get the FP Status Register.
	"lui     $8, 0x80\n"	// (?)
	"and     $8, $2, $8\n"	// Mask off all bits except for 23 of FCR. (? - where does the 0x80 come in?)
	"ctc1    $8, $31\n"		// Set the FP Status Register.
	".set pop\n"
	:						// No inputs.
	:						// No outputs.
	: "$2", "$8"			// Clobbered registers.
	);
}

static int running = 1;
/* Exit callback */
int exitCallback(int arg1, int arg2, void *common)
{
	running = 0;
	return 0;
}

/* Callback thread */
int callbackThread(SceSize args, void *argp)
{
	const SceUID cbid = sceKernelCreateCallback("Exit Callback", exitCallback, NULL);
	sceKernelRegisterExitCallback(cbid);
	sceKernelSleepThreadCB();

	return 0;
}

/* Sets up the callback thread and returns its thread id */
int setupCallbacks(void)
{
	int thid = 0;

	thid = sceKernelCreateThread("update_thread", callbackThread, 0x11, 0xFA0, 0, 0);
	if (thid >= 0) 
	{
		sceKernelStartThread(thid, 0, 0);
	}
	return thid;
}

// Structure containing functions exported from refresh DLL
//refexport_t re;

unsigned  sys_frame_time;

uid_t saved_euid;
qboolean stdin_active = qtrue;

// =============================================================
// tty console variables
// =============================================================

// enable/disabled tty input mode
// NOTE TTimo this is used during startup, cannot be changed during run
//static cvar_t *ttycon = NULL;
// general flag to tell about tty console mode
//static qboolean ttycon_on = qfalse;
// when printing general stuff to stdout stderr (Sys_Printf)
//   we need to disable the tty console stuff
// this increments so we can recursively disable
//static int ttycon_hide = 0;
// some key codes that the terminal may be using
// TTimo NOTE: I'm not sure how relevant this is//
//static int tty_erase;
//static int tty_eof;

//static struct termios tty_tc;

//static field_t tty_con;

// history
// NOTE TTimo this is a bit duplicate of the graphical console history
//   but it's safer and faster to write our own here
//#define TTY_HISTORY 32
//static field_t ttyEditLines[TTY_HISTORY];
//static int hist_current = -1, hist_count = 0;

// =======================================================================
// General routines
// =======================================================================

// bk001207 
#define MEM_THRESHOLD 96*1024*1024

/*
==================
Sys_LowPhysicalMemory()
==================
*/
qboolean Sys_LowPhysicalMemory() 
{
  //MEMORYSTATUS stat;
  //GlobalMemoryStatus (&stat);
  //return (stat.dwTotalPhys <= MEM_THRESHOLD) ? qtrue : qfalse;
  return qfalse; // bk001207 - FIXME
}

/*
==================
Sys_FunctionCmp
==================
*/
int Sys_FunctionCmp(void *f1, void *f2) 
{
  return qtrue;
}

/*
==================
Sys_FunctionCheckSum
==================
*/
int Sys_FunctionCheckSum(void *f1) 
{
  return 0;
}

/*
==================
Sys_MonkeyShouldBeSpanked
==================
*/
int Sys_MonkeyShouldBeSpanked( void ) 
{
  return 0;
}

void Sys_BeginProfiling( void ) 
{
}

/*
=================
Sys_In_Restart_f

Restart the input subsystem
=================
*/
void Sys_In_Restart_f( void ) 
{
  IN_Shutdown();
  IN_Init();
}


// never exit without calling this, or your terminal will be left in a pretty bad state
void Sys_ConsoleInputShutdown()
{
    Com_Printf("Shutdown tty console\n");
}



void Hist_Add(field_t *field)
{

}

field_t *Hist_Prev()
{
	return NULL;
}

field_t *Hist_Next()
{
	return NULL;
}



// =============================================================
// general sys routines
// =============================================================

#if 0
// NOTE TTimo this is not used .. looks interesting though? protection against buffer overflow kind of stuff?
void Sys_Printf (char *fmt, ...)
{
  va_list   argptr;
  char    text[1024];
  unsigned char   *p;

  va_start (argptr,fmt);
  vsprintf (text,fmt,argptr);
  va_end (argptr);

  if (strlen(text) > sizeof(text))
    Sys_Error("memory overwrite in Sys_Printf");

  for (p = (unsigned char *)text; *p; p++)
  {
    *p &= 0x7f;
    if ((*p > 128 || *p < 32) && *p != 10 && *p != 13 && *p != 9)
      printf("[%02x]", *p);
    else
      printf("%c",*p);
    
  }
}
#endif

// single exit point (regular exit or in case of signal fault)
void Sys_Exit( int ex )
{
  Sys_ConsoleInputShutdown();
  running = 0;
}


void Sys_Quit (void)
{
  CL_Shutdown ();
  //NET_Shutdown ();
  Sys_Exit(0);
}

void Sys_Init(void)
{
  Cmd_AddCommand ("in_restart", Sys_In_Restart_f);
  Cvar_Set( "arch", "mips" );
  Cvar_Set( "username", Sys_GetCurrentUser() );

  IN_Init();
}

void Sys_Error (const char *error, ...)
{
    CL_Shutdown ();

	// Put the error message in a buffer.
	va_list args;
	va_start(args, error);
	char buffer[1024];
	memset(buffer, 0, sizeof(buffer));
	vsnprintf(buffer, sizeof(buffer) - 1, error, args);
	va_end(args);

	Com_Printf(buffer);
	// Print the error message to the debug screen.
	pspDebugScreenInit();
	pspDebugScreenSetBackColor(0xA0602000);
    pspDebugScreenClear();
	pspDebugScreenSetTextColor(0xffffff);
	pspDebugScreenPrintf("The following error occurred:\n");
	pspDebugScreenSetTextColor(0xffffff00);
	pspDebugScreenPrintData(buffer, strlen(buffer));
	pspDebugScreenSetTextColor(0xffffff);
	pspDebugScreenPrintf("\n\nPress CROSS to quit.\n");

	// Wait for a button press.
	sceCtrlSetSamplingCycle(0);
	sceCtrlSetSamplingMode(PSP_CTRL_MODE_ANALOG);
	SceCtrlData pad;
	do
	{
		sceCtrlReadBufferPositive(&pad, 1);
	}
	while (pad.Buttons & PSP_CTRL_CROSS);
	do
	{
		sceCtrlReadBufferPositive(&pad, 1);
	}
	while ((pad.Buttons & PSP_CTRL_CROSS) == 0);
	do
	{
		sceCtrlReadBufferPositive(&pad, 1);
	}
	while (pad.Buttons & PSP_CTRL_CROSS);

	// Quit.
    pspDebugScreenSetTextColor(0xffff33);
	pspDebugScreenPrintf("Shutting down...\n");

	running = 0;
	sceKernelExitGame();
}

void Sys_Warn (char *warning, ...)
{ 
  va_list     argptr;
  char        string[1024];

  va_start (argptr,warning);
  vsprintf (string,warning,argptr);
  va_end (argptr);

  printf("Warning: %s", string);

}

/*
============
Sys_FileTime

returns -1 if not present
============
*/
int Sys_FileTime (char *path)
{
  struct  stat  buf;

  if (stat (path,&buf) == -1)
    return -1;

  return buf.st_mtime;
}

void floating_point_exception_handler(int whatever)
{

}

// initialize the console input (tty mode if wanted and possible)
void Sys_ConsoleInputInit()
{

}

char *Sys_ConsoleInput(void)
{
    return NULL;
}

/*****************************************************************************/

#define PSP_MODULE_SUPPORT

/*****************************************************************************/
SceUID INDEXtoUID[3];

/*
=================
Sys_UnloadDll

=================
*/
void Sys_UnloadDll( SceUID dllHandle )
{
#ifdef PSP_MODULE_SUPPORT

  printf("unload\n");
  if ( !dllHandle )
  {
    Com_Printf("Sys_UnloadDll(NULL)\n");
    return;
  }

  int m1 = sceKernelTotalFreeMemSize();
  int m2 = sceKernelMaxFreeMemSize();

  SceUID mod = INDEXtoUID[dllHandle - 1];
  int status;
  int ret = sceKernelStopModule(mod, 0, 0, &status, NULL);
  if(ret < 0)
	 Sys_Error("Sys_UnloadDll: Error stop module (%08x)", ret);

  ret = sceKernelUnloadModule(mod);
  if(ret < 0)
	 Sys_Error("Sys_UnloadDll: Error unload module (%08x)", ret);

  int n1 = sceKernelTotalFreeMemSize();
  int n2 = sceKernelMaxFreeMemSize();
  
  if(n1 == m1 && n2 == m2)
  {
	 Com_Printf("Sys_UnloadDll: mem leak\n");
	 printf("Sys_UnloadDll: mem leak\n");
  }

  Com_Printf("Heap Stat: (%i)kb : (%i)kb\n", n1, n2);
  printf("Heap Stat: (%i)kb : (%i)kb\n", n1, n2);

  INDEXtoUID[dllHandle - 1] = 0;
  dllHandle = -1;
#else
  dllHandle = 0;
#endif
}

/*
=================
Sys_LoadDll

Used to load a development dll instead of a virtual machine
TTimo:
changed the load procedure to match VFS logic, and allow developer use
#1 look down current path
#2 look in fs_homepath
#3 look in fs_basepath
=================
*/
extern "C"
{
#ifndef __PSP__
#include <systemctrl.h>
#endif
char   *FS_BuildOSPath( const char *base, const char *game, const char *qpath );

void dllEntryUI( int (*syscallptr)(int, ...) );
int vmMainUI ( int callNum, ... );

void dllEntryCG( int (*syscallptr)(int, ...) );
int vmMainCG ( int callNum, ... );

void dllEntryQAG( int (*syscallptr)(int, ...) );
int vmMainQAG ( int callNum, ... );
}

//============================== Lib Detect ==========================

static int is_module(const char *name)
{
  if(name[0] == 'q' && name[1] == 'a' && name[2] == 'g' && name[3] == 'a' && name[4] == 'm' && name[5] == 'e')
  {
     return 1;
  }
  else if(name[0] == 'c' && name[1] == 'g' && name[2] == 'a' && name[3] == 'm' && name[4] == 'e' )
  {
	 return 2;
  }
  else if(name[0] == 'u' && name[1] == 'i')
  {
	 return 3;
  }
  return 0;
}

//======================================================================


SceUID Sys_LoadDll( const char *name, char *fqpath ,
                   int (**entryPoint)(int, ...),
                   int (*systemcalls)(int, ...) ) 
{
#ifdef PSP_MODULE_SUPPORT

  SceUID libHandle;
  void  (*dllEntry)( int (*syscallptr)(int, ...) ) = NULL; //For compiler
  char  curpath[MAX_OSPATH];
  char  fname[MAX_OSPATH];
  char  *basepath;
  char  *homepath;
  char  *pwdpath;
  char  *gamedir;
  char  *fn;
  *fqpath = 0;

  // bk001206 - let's have some paranoia
  assert( name );

  getcwd(curpath, sizeof(curpath));
  snprintf (fname, sizeof(fname), "%s_psp.prx", name);

  pwdpath = Sys_Cwd();
  basepath = Cvar_VariableString( "fs_basepath" );
  homepath = Cvar_VariableString( "fs_homepath" );
  gamedir = Cvar_VariableString( "fs_game" );

  // pwdpath
  fn = FS_BuildOSPath( pwdpath, gamedir, fname );

  Com_Printf( "Sys_LoadDll(%s)... \n", fn );
  printf( "Sys_LoadDll(%s)... \n", fn );

  libHandle = pspSdkLoadStartModule(fn, PSP_MEMORY_PARTITION_USER);
  if (libHandle < 0)
  {
	    Com_Printf("Sys_LoadDll: pspSdkLoadStartModule failed (%08x), trying kuKernelLoadModule\n", libHandle);
	    libHandle = kuKernelLoadModule(name, 0, NULL);
		if (libHandle < 0)
	    {
	        Com_Printf( "Sys_LoadDll(%s) failed: %08x\n", name, libHandle);
	        return 0;
	    }
	    else
	    {
		    int status = 0;
			int ret = sceKernelStartModule(libHandle, 0, NULL, &status, 0);
			if (ret < 0)
			{
			    Com_Printf("Sys_GetGameAPI: Error start module (%08x)", ret);
			    return 0;
            }
		}
  }
  else
  {
     Com_Printf ( "Sys_LoadDll(%s): succeeded ...\n", fn );
     printf ( "Sys_LoadDll(%s): succeeded ...\n", fn );
  }

  SceUID mod_index = 0;
  for(int i = 0; i < 3; i++)
  {
      if(!INDEXtoUID[i])
      {
          INDEXtoUID[i] = libHandle;
		  mod_index = i + 1; //1 <-> 3
		  break;
	  }
  }

  if(mod_index == 0)
	 Sys_Error("No free slots for module\n");
  
  //*entryPoint  =  (int (*)(int, ...))            FindProc(name,   "vmMain",    0x247CB6E7 );
  //dllEntry    =  (void (*)(int (*)(int, ...)))  FindProc(name,   "dllEntry",  0xC53AF4F0 );

  switch(is_module(name))
  {
	case 1:
     dllEntry    =  dllEntryQAG;
     *entryPoint =  vmMainQAG;
	 break;
	case 2:
     dllEntry    =  dllEntryCG;
     *entryPoint =  vmMainCG;
     break;
	case 3:
	 dllEntry    =  dllEntryUI;
     *entryPoint =  vmMainUI;
     break;
    default:
	  Sys_Error("Unknow module %s",name);
	  break;
  }

  if ( !*entryPoint || !dllEntry )
  {
    Com_Printf ( "Sys_LoadDll(%s) failed func not found\n", name);
    printf ( "Sys_LoadDll(%s) failed func not found\n", name);
    return 0;
  }

  Com_Printf ( "Sys_LoadDll(%s) found **vmMain** at  %p  \n", name, *entryPoint ); // bk001212
  printf ( "Sys_LoadDll(%s) found  **vmMain**  at  %p  \n", name, *entryPoint ); // bk001212
  printf ( "Sys_LoadDll(%s) found **dllEntry** at  %p  \n", name, dllEntry );

  dllEntry( systemcalls );

  Com_Printf ( "Sys_LoadDll(%s) succeeded!\n", name );
  printf ( "Sys_LoadDll(%s) succeeded!\n", name );

  Q_strncpyz ( fqpath , fn , MAX_QPATH ) ;		// added 7/20/02 by T.Ray

  return mod_index;

#else //For static build

  void  (*dllEntry)( int (*syscallptr)(int, ...) ) = NULL; //For compiler

  switch(is_module(name))
  {
	case 1:
     dllEntry    =  dllEntryQAG;
     *entryPoint =  vmMainQAG;
	 break;
	case 2:
     dllEntry    =  dllEntryCG;
     *entryPoint =  vmMainCG;
     break;
	case 3:
	 dllEntry    =  dllEntryUI;
     *entryPoint =  vmMainUI;
     break;
     default:
	  Sys_Error("Unknow module %s",name);
	  break;
  }

  Com_Printf ( "Sys_LoadDll(%s) found **vmMain** at  %p  \n", name, *entryPoint ); // bk001212

  dllEntry( systemcalls );

  return 1;
#endif
}


/*
========================================================================

BACKGROUND FILE STREAMING

========================================================================
*/

#if 1

void Sys_InitStreamThread( void ) {
}

void Sys_ShutdownStreamThread( void ) {
}

void Sys_BeginStreamedFile( fileHandle_t f, int readAhead ) {
}

void Sys_EndStreamedFile( fileHandle_t f ) {
}

int Sys_StreamedRead( void *buffer, int size, int count, fileHandle_t f ) {
  return FS_Read( buffer, size * count, f );
}

void Sys_StreamSeek( fileHandle_t f, int offset, int origin ) {
  FS_Seek( f, offset, origin );
}

#else

typedef struct
{
  fileHandle_t file;
  byte  *buffer;
  qboolean  eof;
  int   bufferSize;
  int   streamPosition; // next byte to be returned by Sys_StreamRead
  int   threadPosition; // next byte to be read from file
} streamState_t;

streamState_t stream;

/*
===============
Sys_StreamThread

A thread will be sitting in this loop forever
================
*/
void Sys_StreamThread( void ) 
{
  int   buffer;
  int   count;
  int   readCount;
  int   bufferPoint;
  int   r;

  // if there is any space left in the buffer, fill it up
  if ( !stream.eof )
  {
    count = stream.bufferSize - (stream.threadPosition - stream.streamPosition);
    if ( count )
    {
      bufferPoint = stream.threadPosition % stream.bufferSize;
      buffer = stream.bufferSize - bufferPoint;
      readCount = buffer < count ? buffer : count;
      r = FS_Read ( stream.buffer + bufferPoint, readCount, stream.file );
      stream.threadPosition += r;

      if ( r != readCount )
        stream.eof = qtrue;
    }
  }
}

/*
===============
Sys_InitStreamThread

================
*/
void Sys_InitStreamThread( void ) 
{
}

/*
===============
Sys_ShutdownStreamThread

================
*/
void Sys_ShutdownStreamThread( void ) 
{
}


/*
===============
Sys_BeginStreamedFile

================
*/
void Sys_BeginStreamedFile( fileHandle_t f, int readAhead ) 
{
  if ( stream.file )
  {
    Com_Error( ERR_FATAL, "Sys_BeginStreamedFile: unclosed stream");
  }

  stream.file = f;
  stream.buffer = Z_Malloc( readAhead );
  stream.bufferSize = readAhead;
  stream.streamPosition = 0;
  stream.threadPosition = 0;
  stream.eof = qfalse;
}

/*
===============
Sys_EndStreamedFile

================
*/
void Sys_EndStreamedFile( fileHandle_t f ) 
{
  if ( f != stream.file )
  {
    Com_Error( ERR_FATAL, "Sys_EndStreamedFile: wrong file");
  }

  stream.file = 0;
  Z_Free( stream.buffer );
}


/*
===============
Sys_StreamedRead

================
*/
int Sys_StreamedRead( void *buffer, int size, int count, fileHandle_t f ) 
{
  int   available;
  int   remaining;
  int   sleepCount;
  int   copy;
  int   bufferCount;
  int   bufferPoint;
  byte  *dest;

  dest = (byte *)buffer;
  remaining = size * count;

  if ( remaining <= 0 )
  {
    Com_Error( ERR_FATAL, "Streamed read with non-positive size" );
  }

  sleepCount = 0;
  while ( remaining > 0 )
  {
    available = stream.threadPosition - stream.streamPosition;
    if ( !available )
    {
      if (stream.eof)
        break;
      Sys_StreamThread();
      continue;
    }

    bufferPoint = stream.streamPosition % stream.bufferSize;
    bufferCount = stream.bufferSize - bufferPoint;

    copy = available < bufferCount ? available : bufferCount;
    if ( copy > remaining )
    {
      copy = remaining;
    }
    memcpy( dest, stream.buffer + bufferPoint, copy );
    stream.streamPosition += copy;
    dest += copy;
    remaining -= copy;
  }

  return(count * size - remaining) / size;
}

/*
===============
Sys_StreamSeek

================
*/
void Sys_StreamSeek( fileHandle_t f, int offset, int origin ) {
  // clear to that point
  FS_Seek( f, offset, origin );
  stream.streamPosition = 0;
  stream.threadPosition = 0;
  stream.eof = qfalse;
}

#endif

/*
========================================================================

EVENT LOOP

========================================================================
*/

// bk000306: upped this from 64
#define	MAX_QUED_EVENTS		256
#define	MASK_QUED_EVENTS	( MAX_QUED_EVENTS - 1 )

sysEvent_t  eventQue[MAX_QUED_EVENTS];
// bk000306: initialize
int   eventHead = 0;
int             eventTail = 0;
byte    sys_packetReceived[MAX_MSGLEN];
//byte    sys_packetReceived[16384];

/*
================
Sys_QueEvent

A time of 0 will get the current time
Ptr should either be null, or point to a block of data that can
be freed by the game later.
================
*/
void Sys_QueEvent( int time, sysEventType_t type, int value, int value2, int ptrLength, void *ptr )
{
  sysEvent_t  *ev;

  ev = &eventQue[ eventHead & MASK_QUED_EVENTS ];

  // bk000305 - was missing
  if ( eventHead - eventTail >= MAX_QUED_EVENTS )
  {
    Com_Printf("Sys_QueEvent: overflow\n");
    // we are discarding an event, but don't leak memory
    if ( ev->evPtr )
    {
      Z_Free( ev->evPtr );
    }
    eventTail++;
  }

  eventHead++;

  if ( time == 0 )
  {
    time = Sys_Milliseconds();
  }

  ev->evTime = time;
  ev->evType = type;
  ev->evValue = value;
  ev->evValue2 = value2;
  ev->evPtrLength = ptrLength;
  ev->evPtr = ptr;
}
/*
================
Sys_GetEvent

================
*/
sysEvent_t Sys_GetEvent( void ) 
{
  sysEvent_t  ev;
  char    *s;
  msg_t   netmsg;
  netadr_t  adr;

  // return if we have data
  if ( eventHead > eventTail )
  {
    eventTail++;
    return eventQue[ ( eventTail - 1 ) & MASK_QUED_EVENTS ];
  }

  // pump the message loop
  // in vga this calls KBD_Update, under X, it calls GetEvent
  Sys_SendKeyEvents ();

  // check for console commands
  s = Sys_ConsoleInput();
  if ( s )
  {
    char  *b;
    int   len;

    len = strlen( s ) + 1;
    b = (char*)Z_Malloc( len );
    strcpy( b, s );
    Sys_QueEvent( 0, SE_CONSOLE, 0, 0, len, b );
  }

  // check for other input devices
  IN_Frame();

  // check for network packets
  MSG_Init( &netmsg, sys_packetReceived, sizeof( sys_packetReceived ) );
  if ( Sys_GetPacket ( &adr, &netmsg ) )
  {
    netadr_t    *buf;
    int       len;

    // copy out to a seperate buffer for qeueing
    len = sizeof( netadr_t ) + netmsg.cursize;
    buf = (netadr_t*)Z_Malloc( len );
    *buf = adr;
    memcpy( buf+1, netmsg.data, netmsg.cursize );
    Sys_QueEvent( 0, SE_PACKET, 0, 0, len, buf );
  }

  // return if we have data
  if ( eventHead > eventTail )
  {
    eventTail++;
    return eventQue[ ( eventTail - 1 ) & MASK_QUED_EVENTS ];
  }

  // create an empty event to return

  memset( &ev, 0, sizeof( ev ) );
  ev.evTime = Sys_Milliseconds();

  return ev;
}

/*****************************************************************************/

qboolean Sys_CheckCD( void )
{
  return qtrue;
}

void Sys_AppActivate (void)
{
}

char *Sys_GetClipboardData(void)
{
  return NULL;
}

void  Sys_Print( const char *msg )
{
  //printf("%s",msg);
}


void    Sys_ConfigureFPU() 
{
}

void Sys_PrintBinVersion( const char* name )
{
  char* date = __DATE__;
  char* time = __TIME__;
  char* sep = "==============================================================";
  printf( "\n\n%s\n", sep );
#ifdef DEDICATED
  printf( "Linux Quake3 Dedicated Server [%s %s]\n", date, time );  
#else
  printf( "Linux Quake3 Full Executable  [%s %s]\n", date, time );  
#endif
  printf( " local install: %s\n", name );
  printf( "%s\n\n", sep );
}

void Sys_ParseArgs( int argc, char* argv[] ) {

  if ( argc==2 )
  {
    if ( (!strcmp( argv[1], "--version" ))
         || ( !strcmp( argv[1], "-v" )) )
    {
      Sys_PrintBinVersion( argv[0] );
      Sys_Exit(0);
    }
  }
}

#ifdef PSPINI
char *GetConfig(char *name)
{
  char *cfgline;
  FILE *cfglinef = fopen(name,"rb");
  int len        = 1;

  if(cfglinef)
  {
     fseek (cfglinef, 0, SEEK_END);
	 len = ftell (cfglinef);
	 fseek (cfglinef, 0, SEEK_SET);
  }

  cfgline = (char *) malloc((size_t) len);
  *cfgline = 0;

  if(cfglinef)
  {
	 fread (cfgline, 1, len, cfglinef);
	 fclose(cfglinef);
  }
  return cfgline;
}
#endif



#ifdef USE_GPROF
extern "C"{void gprof_cleanup();}
#endif

/*
int RenderThreadInit(void);
*/

int main ( int argc, char** argv )
{
	  disableFloatingPointExceptions();

	  setupCallbacks();

      memset(INDEXtoUID, 0, sizeof(INDEXtoUID));
      
#ifdef USE_EXT_MEM
	  SceUID sysLib = pspSdkLoadStartModule("system.prx", PSP_MEMORY_PARTITION_KERNEL);
	  if (sysLib < 0)
	  {
		  sceKernelExitGame();
	  }
#endif
#if 0
	  for(int j = 1; j < 9; j++)
	  {
		  int mb = j;
		  printf("TEST KERNEL PARTITIONS\n"); //with kernel partition (1mb)
		  for(int i = 1; i < 10; i++)
		  {
			  SceUID MUID = sysKernelAllocPartitionMemory( i, "test", PSP_SMEM_High, mb * 1024 * 1024, NULL );
	          void *data = (void *)( (uintptr_t)(sysKernelGetBlockHeadAddr( MUID )));
	          if(!data)
				  continue;

			  printf("Alloceted %i meg in partition n:%i \n", mb,i);

			  sysKernelFreePartitionMemory(MUID);

		  }

          printf("\n-----------------------------------------\n\n");

		  printf("TEST USER PARTITIONS\n");
		  for(int i = 1; i < 10; i++)
		  {
			  SceUID MUID = sceKernelAllocPartitionMemory( i, "test", PSP_SMEM_High, mb * 1024 * 1024, NULL );
	          void *data = (void *)( (uintptr_t)(sceKernelGetBlockHeadAddr( MUID )));
	          if(!data)
				  continue;

			  printf("Alloceted %i meg in partition n:%i \n", mb,i);

			  sceKernelFreePartitionMemory(MUID);

		  }
		  printf("\n=========================================\n\n");
	  }
#endif
	  char  *cmdline;

	  void Sys_SetDefaultCDPath(const char *path);

	  // Catch exceptions from here.
#ifdef USE_EXCEPTION
	  try
	  {
#endif

	      // Set the max cpu frequency.
	      scePowerSetClockFrequency(333, 333, 166);

	      int currentCPU = scePowerGetCpuClockFrequency();
	      int currentBUS = scePowerGetBusClockFrequency();

		  printf("CPU is: %i, %i\n",currentCPU, currentBUS);

		  // Get the current working dir.
		  Sys_ParseArgs( argc, argv );  // bk010104 - added this for support

		  Sys_SetDefaultCDPath(argv[0]);
#ifndef PSPINI
		  int   len, i;

		  // merge the command line, this is kinda silly
		  for (len = 1, i = 1; i < argc; i++)
		  {
		    len += strlen(argv[i]) + 1;
		  }

		  cmdline = (char *) malloc((size_t) len);
		  *cmdline = 0;

		  for (i = 1; i < argc; i++)
		  {
		    if (i > 1)
		    {
		      strcat(cmdline, " ");
		    }
			strcat(cmdline, argv[i]);
		  }
#else
		  cmdline = GetConfig("q3cmd.ini");
#endif
		  // bk000306 - clear queues
		  memset( &eventQue[0], 0, MAX_QUED_EVENTS*sizeof(sysEvent_t) );
		  memset( &sys_packetReceived[0], 0, MAX_MSGLEN*sizeof(byte) );

		  Com_Init(cmdline);

		  NET_Init();

		  while (running)
		  {
			 Com_Frame ();
		  }
#ifdef USE_EXCEPTION
	  }
	  catch (const std::exception& e)
	  {
		 // Report the error and quit.
		 Sys_Error("C++ Exception: %s", e.what());
		 return 0;
	  }
#endif
#ifdef USE_GPROF
	  gprof_cleanup();
#endif

#ifdef USE_EXT_MEM
	  sceKernelStopModule(sysLib, 0, 0, 0, 0);
	  sceKernelUnloadModule(sysLib);
#endif

	  sceKernelExitGame();
	  return 0;
}
