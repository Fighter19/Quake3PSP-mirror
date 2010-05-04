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
#include <algorithm>
#include <cstddef>

#include "pspkernel.h"

extern "C"
{
#include <pthread.h>
#include "../renderer/tr_local.h"
#include "keyboard/danzeff.h"
}

#define DP565



#ifdef _WIN32
# define ALIGNED(x)
#else
# define ALIGNED(x) __attribute__((aligned(x)))
#endif

#include <vram.h>

namespace quake3
{
	namespace video
	{

		// Types.
#ifdef DP565
		typedef ScePspRGB565	pixel;
#else
		typedef ScePspRGBA8888	pixel;
#endif
		typedef u8				texel;
		typedef u16				depth_value;

		// Constants.
		static const std::size_t	screen_width	= 480;
		static const std::size_t	screen_height	= 272;
		static const std::size_t	palette_size	= 256;
		static pixel* 				display_buffer	= 0;
        static pixel*				draw_buffer	    = 0;
		static depth_value*			depth_buffer	= 0;

		//! The GU display list.
		//! @note	Aligned to 64 bytes so it doesn't share a cache line with anything.
		unsigned int ALIGNED(64)	display_list[262144];

	}
}
using namespace quake3;
using namespace quake3::video;

extern "C" int net_connected;

void GLimp_EndFrame (void)
{
    // Keyboard update.
    if (danzeff_isinitialized())
    {
	  danzeff_render();
	} 

	// Finish rendering.
	sceGuFinish();
	sceGuSync(0, 0);

	// At the moment only do this if we are in network mode, once we get above
	// 60fps we might as well leave it on for all games
	if(net_connected)
	   sceDisplayWaitVblankStart();

    // Switch the buffers.
	sceGuSwapBuffers();
	std::swap(draw_buffer, display_buffer);
	
	// Start a new render.
	sceGuStart(GU_DIRECT, display_list);
}

int gpu_init;
void GLimp_Init (void)
{
	// Allocate the buffers.
	display_buffer	= static_cast<pixel*>(valloc(screen_height * 512 * sizeof(pixel)));
	if (!display_buffer)
	{
		ri.Error( ERR_DROP, "Couldn't allocate display buffer");
	}

	draw_buffer	= static_cast<pixel*>(valloc(screen_height * 512 * sizeof(pixel)));
	if (!draw_buffer)
	{
		ri.Error( ERR_DROP, "Couldn't allocate draw buffer");
	}

	depth_buffer	= static_cast<depth_value*>(valloc(screen_height * 512 * sizeof(depth_value)));
	if (!depth_buffer)
	{
		ri.Error( ERR_DROP, "Couldn't allocate depth buffer");
	}

	// Initialise the GU.
	sceGuInit();

	// Set up the GU.
	sceGuStart(GU_DIRECT, display_list);
	{
		// Set the draw and display buffers.
#ifdef DP565
        sceGuDrawBuffer(GU_PSM_5650, vrelptr(draw_buffer), 512);
#else
	    sceGuDrawBuffer(GU_PSM_8888, vrelptr(draw_buffer), 512);
#endif
		sceGuDispBuffer(screen_width, screen_height, vrelptr(display_buffer), 512);
		sceGuDepthBuffer(vrelptr(depth_buffer), 512);

		// Set the rendering offset and viewport.
		sceGuOffset(2048 - (screen_width / 2), 2048 - (screen_height / 2));
		sceGuViewport(2048, 2048, screen_width, screen_height);

		// Set up scissoring.
		sceGuEnable(GU_SCISSOR_TEST);
		sceGuScissor(0, 0, screen_width, screen_height);

		// Set up texturing.
		sceGuEnable(GU_TEXTURE_2D);

		// Set up clearing.
		sceGuClearDepth(65535);
		sceGuClearColor(GU_RGBA(0x10,0x20,0x40,0xff));

		// Set up depth.
		sceGuDepthRange(0, 65535);
		sceGuDepthFunc(GU_LEQUAL);
		sceGuEnable(GU_DEPTH_TEST);

		// Set the matrices.
		sceGumMatrixMode(GU_PROJECTION);
		sceGumLoadIdentity();
		sceGumUpdateMatrix();
		sceGumMatrixMode(GU_VIEW);
		sceGumLoadIdentity();
		sceGumUpdateMatrix();
		sceGumMatrixMode(GU_MODEL);
		sceGumLoadIdentity();
		sceGumUpdateMatrix();

		// Set up culling.
		sceGuFrontFace(GU_CCW);
		sceGuEnable(GU_CULL_FACE);
		sceGuEnable(GU_CLIP_PLANES);
		
		// Set up blending.
		sceGuBlendFunc(GU_ADD, GU_SRC_ALPHA, GU_ONE_MINUS_SRC_ALPHA, 0, 0);

	}

	sceGuFinish();
	sceGuSync(0,0);

	// Turn on the display.
	sceDisplayWaitVblankStart();
	sceGuDisplay(GU_TRUE);

	// Start a render.
	sceGuStart(GU_DIRECT, display_list);

    if ( !R_GetModeInfo( &glConfig.vidWidth, &glConfig.vidHeight, &glConfig.windowAspect, 0 ) )
    {
      ri.Printf( PRINT_ALL, " invalid mode\n" );
    }

	ri.Printf( PRINT_ALL, " %d %d\n", glConfig.vidWidth, glConfig.vidHeight);

	glConfig.textureCompression     = TC_NONE;
    glConfig.textureEnvAddAvailable = qfalse;
	glConfig.colorBits              = 32;
    glConfig.depthBits              = 16;
    glConfig.stencilBits            = 0;
    glConfig.displayFrequency       = 60;
    glConfig.deviceSupportsGamma    = qfalse;
    glConfig.driverType             = GLDRV_ICD;
	glConfig.hardwareType           = GLHW_GENERIC;

	ri.Cvar_Set( "r_lastValidRenderer","PSPGU");

    gpu_init = 1;
}

void GetPixelsBGR(byte *buffer, int width, int height, int i)
{
    for (int y = 0; y < height; ++y)
	{
		const pixel* src = display_buffer + ((height - y - 1) * 512);
		for (int x = 0; x < width; ++x)
		{
			const pixel argb = *src++;
#ifdef DP565
            buffer[i++]	= ((argb >> 11) & 0x1f) << 3; //B
			buffer[i++]	= ((argb >> 5 ) & 0x3f) << 2; //G
			buffer[i++]	= (argb & 0x1f)         << 3; //R
#else
			buffer[i++]	= (argb >> 16) & 0xff;//B
			buffer[i++]	= (argb >> 8) & 0xff; //G
			buffer[i++]	= argb & 0xff;        //R
#endif
		}
	}

}

void GetPixelsRGB(byte *buffer, int width, int height, int i)
{
    for (int y = 0; y < height; ++y)
	{
		const pixel* src = display_buffer + ((height - y - 1) * 512);
		for (int x = 0; x < width; ++x)
		{
			const pixel argb = *src++;
#ifdef DP565
            buffer[i++]	= (argb & 0x1f)         << 3; //R
			buffer[i++]	= ((argb >> 5 ) & 0x3f) << 2; //G
			buffer[i++]	= ((argb >> 11) & 0x1f) << 3; //B
#else
			buffer[i++]	= ((argb)& 0xff);       //R
            buffer[i++]	= ((argb >> 8)& 0xff);  //G
			buffer[i++]	= ((argb >> 16)& 0xff); //B
#endif
		}
	}

}

void GetPixelsRGBA(byte *buffer, int width, int height, int i)
{
    for (int y = 0; y < height; ++y)
	{
		const pixel* src = display_buffer + ((height - y - 1) * 512);
		for (int x = 0; x < width; ++x)
		{
			const pixel argb = *src++;
#ifdef DP565
            buffer[i++]	= (argb & 0x1f)         << 3; //R
			buffer[i++]	= ((argb >> 5 ) & 0x3f) << 2; //G
			buffer[i++]	= ((argb >> 11) & 0x1f) << 3; //B
            buffer[i++]	= 0xff;                       //A
#else
			buffer[i++]	= ((argb)& 0xff);       //R
            buffer[i++]	= ((argb >> 8)& 0xff);  //G
			buffer[i++]	= ((argb >> 16)& 0xff); //B
            buffer[i++]	= ((argb >> 24)& 0xff); //A
#endif
		}
	}

}


void GLimp_Shutdown (void) 
{ 
    // Finish rendering.
	sceGuFinish();
	sceGuSync(0,0);

	// Shut down the display.
	sceGuTerm();

	// Free the buffers.
	vfree(depth_buffer);
	depth_buffer = 0;
	vfree(draw_buffer);
	draw_buffer = 0;
	vfree(display_buffer);
	display_buffer = 0;

	memset( &glConfig, 0, sizeof( glConfig ) );
    memset( &glState, 0, sizeof( glState ) );
    gpu_init = 0;
}

void GLimp_EnableLogging (qboolean enable) { printf("%s (%d):\n", __FUNCTION__, __LINE__); }

void GLimp_LogComment (char *comment) { /* printf("%s", comment); */ }

/*
===========================================================

SMP acceleration

===========================================================
defines SMP SCESMP SDLSMP MCSMP
*/

//#define SCESMP

#if defined(SDLSMP)

#include "SDL/SDL.h"
#include "SDL/SDL_thread.h"

static SDL_mutex *smpMutex = NULL;
static SDL_cond *renderCommandsEvent = NULL;
static SDL_cond *renderCompletedEvent = NULL;
static void (*glimpRenderThread)( void ) = NULL;
static SDL_Thread *renderThread = NULL;

/*
===============
GLimp_ShutdownRenderThread
===============
*/
static void GLimp_ShutdownRenderThread(void)
{
	if (smpMutex != NULL)
	{
		SDL_DestroyMutex(smpMutex);
		smpMutex = NULL;
	}

	if (renderCommandsEvent != NULL)
	{
		SDL_DestroyCond(renderCommandsEvent);
		renderCommandsEvent = NULL;
	}

	if (renderCompletedEvent != NULL)
	{
		SDL_DestroyCond(renderCompletedEvent);
		renderCompletedEvent = NULL;
	}

	glimpRenderThread = NULL;
}

/*
===============
GLimp_RenderThreadWrapper
===============
*/
static int GLimp_RenderThreadWrapper( void *arg )
{
	printf( "Render thread starting\n" );

	glimpRenderThread();

	Com_Printf( "Render thread terminating\n" );

	return 0;
}

/*
===============
GLimp_SpawnRenderThread
===============
*/
qboolean GLimp_SpawnRenderThread( void (*function)( void ) )
{
	static qboolean warned = qfalse;
	if (!warned)
	{
		Com_Printf("WARNING: You enable r_smp at your own risk!\n");
		warned = qtrue;
	}

	if (renderThread != NULL)  /* hopefully just a zombie at this point... */
	{
		Com_Printf("Already a render thread? Trying to clean it up...\n");
		SDL_WaitThread(renderThread, NULL);
		renderThread = NULL;
		GLimp_ShutdownRenderThread();
	}

	smpMutex = SDL_CreateMutex();
	if (smpMutex == NULL)
	{
		Com_Printf( "smpMutex creation failed: %s\n", SDL_GetError() );
		GLimp_ShutdownRenderThread();
		return qfalse;
	}

	renderCommandsEvent = SDL_CreateCond();
	if (renderCommandsEvent == NULL)
	{
		Com_Printf( "renderCommandsEvent creation failed: %s\n", SDL_GetError() );
		GLimp_ShutdownRenderThread();
		return qfalse;
	}

	renderCompletedEvent = SDL_CreateCond();
	if (renderCompletedEvent == NULL)
	{
		Com_Printf( "renderCompletedEvent creation failed: %s\n", SDL_GetError() );
		GLimp_ShutdownRenderThread();
		return qfalse;
	}

	glimpRenderThread = function;
	renderThread = SDL_CreateThread(GLimp_RenderThreadWrapper, NULL);
	if ( renderThread == NULL )
	{
		ri.Printf( PRINT_ALL, "SDL_CreateThread() returned %s", SDL_GetError() );
		GLimp_ShutdownRenderThread();
		return qfalse;
	}
	else
	{
		// tma 01/09/07: don't think this is necessary anyway?
		//
		// !!! FIXME: No detach API available in SDL!
		//ret = pthread_detach( renderThread );
		//if ( ret ) {
		//ri.Printf( PRINT_ALL, "pthread_detach returned %d: %s", ret, strerror( ret ) );
		//}
	}

	return qtrue;
}

static volatile void    *smpData = NULL;
static volatile qboolean smpDataReady;

/*
===============
GLimp_RendererSleep
===============
*/
void *GLimp_RendererSleep( void )
{
	void  *data = NULL;

	SDL_LockMutex(smpMutex);
	{
		smpData = NULL;
		smpDataReady = qfalse;

		// after this, the front end can exit GLimp_FrontEndSleep
		SDL_CondSignal(renderCompletedEvent);

		while ( !smpDataReady )
			SDL_CondWait(renderCommandsEvent, smpMutex);

		data = (void *)smpData;
	}
	SDL_UnlockMutex(smpMutex);

	return data;
}

/*
===============
GLimp_FrontEndSleep
===============
*/
void GLimp_FrontEndSleep( void )
{
	SDL_LockMutex(smpMutex);
	{
		while ( smpData )
			SDL_CondWait(renderCompletedEvent, smpMutex);
	}
	SDL_UnlockMutex(smpMutex);

}

/*
===============
GLimp_WakeRenderer
===============
*/
void GLimp_WakeRenderer( void *data )
{
	SDL_LockMutex(smpMutex);
	{
		assert( smpData == NULL );
		smpData = data;
		smpDataReady = qtrue;

		// after this, the renderer can continue through GLimp_RendererSleep
		SDL_CondSignal(renderCommandsEvent);
	}
	SDL_UnlockMutex(smpMutex);
}


#elif defined(SCESMP)

#include "pspmutex.h"

static SceUID smpMutex = -1;
static int smpEvent = -1;
void (*glimpRenderThread)( void );

int GLimp_RenderThreadWrapper(SceSize argc, void *argv)
{
	//while(1)
	//{
		glimpRenderThread();
    //}
	return 0;
}

/*
=======================
GLimp_SpawnRenderThread
=======================
*/
SceUID 	renderThreadHandle;

qboolean GLimp_SpawnRenderThread( void (*function)( void ) )
{
	smpMutex = sceKernelCreateMutex("smpMutex", 0, 1, 0);
	smpEvent = sceKernelCreateEventFlag("smpEvent", 0, 0, 0);
	glimpRenderThread = function;

	renderThreadHandle = sceKernelCreateThread("q3thread", GLimp_RenderThreadWrapper, 30, 0x2000, 0, 0);
	if (renderThreadHandle < 0)
	{
        printf("Create Thread - ERROR\n");
		return qfalse;
	}
	sceKernelStartThread(renderThreadHandle, 0, 0);
	printf("Create Thread - OK\n");
	return qtrue;
}

static  volatile qboolean  smpDataChanged;
static	volatile void     *smpData;

// Called in the rendering thread to wait until a command buffer is ready.
// The command buffer returned might be NULL, indicating that the rendering thread should exit.
void *GLimp_RendererSleep(void)
{
    void *data;

    sceKernelLockMutex(smpMutex, 1, 0);
	{
        // Clear out any data we had and signal the main thread that we are no longer busy
        smpData = NULL;
        smpDataChanged = qfalse;

        sceKernelSetEventFlag(smpEvent, 1);

		// Wait until we get something new to work on
        while (!smpDataChanged)
          sceKernelWaitEventFlag(smpEvent, 1, 0, 0, 0);

        // Record the data (if any).
        data = (void*)smpData;
    }
	sceKernelUnlockMutex(smpMutex, 0);

    return (void *)data;
}

// Called from the main thread to wait until the rendering thread is done with the command buffer.
void GLimp_FrontEndSleep(void)
{
    sceKernelLockMutex(smpMutex, 1, 0);
	{
	    while (smpData)
		{
            sceKernelWaitEventFlag(smpEvent, 1, 0, 0, 0);
        }
    }
	sceKernelUnlockMutex(smpMutex, 0);
}

// This is called in the main thread to issue another command
// buffer to the rendering thread.  This is always called AFTER
// GLimp_FrontEndSleep, so we know that there is no command
// pending in 'smpData'.
void GLimp_WakeRenderer( void *data )
{
    sceKernelLockMutex(smpMutex, 1, 0);
	{
        // Store the new data pointer and wake up the rendering thread
        assert(smpData == NULL);
        smpData = data;
        smpDataChanged = qtrue;
        sceKernelSetEventFlag(smpEvent, 1);
    }
	sceKernelUnlockMutex(smpMutex, 0);
}

#elif defined(SMP)

static pthread_mutex_t  smpMutex;
static pthread_cond_t   mainThreadCondition;
static pthread_cond_t   renderThreadCondition;

static  volatile qboolean  smpDataChanged;
static	volatile void     *smpData;

static void *GLimp_RenderThreadWrapper(void *arg)
{
    printf("Render thread starting\n");

	((void (*)())arg)();
	
    printf("Render thread terminating\n");

    return arg;
}

qboolean GLimp_SpawnRenderThread( void (*function)( void ) )
{
    pthread_t renderThread;
    int       rc;

    pthread_init ();
    pthread_mutex_init(&smpMutex, NULL);
    pthread_cond_init(&mainThreadCondition, NULL);
    pthread_cond_init(&renderThreadCondition, NULL);
 
    rc = pthread_create(&renderThread, NULL, GLimp_RenderThreadWrapper, (byte*)function);
    if (rc)
	{
        ri.Printf(PRINT_ALL, "pthread_create returned %d: %s", rc, strerror(rc));
        return qfalse;
    }
	else
	{
        rc = pthread_detach(renderThread);
        if (rc)
		{
            ri.Printf(PRINT_ALL, "pthread_detach returned %d: %s", rc, strerror(rc));
        }
    }

    return qtrue;
}

// Called in the rendering thread to wait until a command buffer is ready.
// The command buffer returned might be NULL, indicating that the rendering thread should exit.
void *GLimp_RendererSleep(void)
{
    void *data;

    pthread_mutex_lock(&smpMutex);
	{
        // Clear out any data we had and signal the main thread that we are no longer busy
        smpData = NULL;
        smpDataChanged = qfalse;
        pthread_cond_signal(&mainThreadCondition);

        // Wait until we get something new to work on
        while (!smpDataChanged)
            pthread_cond_wait(&renderThreadCondition, &smpMutex);

        // Record the data (if any).
        data = (void*)smpData;
    }
	pthread_mutex_unlock(&smpMutex);

    return (void *)data;
}

// Called from the main thread to wait until the rendering thread is done with the command buffer.
void GLimp_FrontEndSleep(void)
{
    pthread_mutex_lock(&smpMutex);
	{
        while (smpData)
		{
            pthread_cond_wait(&mainThreadCondition, &smpMutex);
        }
    }
	pthread_mutex_unlock(&smpMutex);
}

// This is called in the main thread to issue another command
// buffer to the rendering thread.  This is always called AFTER
// GLimp_FrontEndSleep, so we know that there is no command
// pending in 'smpData'.
void GLimp_WakeRenderer( void *data )
{
    pthread_mutex_lock(&smpMutex);
	{
        // Store the new data pointer and wake up the rendering thread
        assert(smpData == NULL);
        smpData = data;
        smpDataChanged = qtrue;
        pthread_cond_signal(&renderThreadCondition);
    }
	pthread_mutex_unlock(&smpMutex);
}

#elif defined(MCSMP)

// This is a small cover layer that makes for easier calling
typedef struct _MsgPort
{

    pthread_mutex_t mutex;
    pthread_cond_t condition;
    volatile unsigned int   status;
    unsigned int   msgCode;
    void          *msgData;

} MsgPort;

static bool portsInited = false;
static pthread_mutex_t logMutex;

static unsigned int renderMsgOutstanding;
static unsigned int rendererProcessingCommand;

static MsgPort rendererMsgPort;
static MsgPort frontEndMsgPort;

enum {
    MsgNone,
    MsgPending,
};

enum {
    MsgCodeInvalid = 0,
    RenderCommandMsg = 1,
    RenderCompletedMsg = 2,
};

static void MsgPortInit(MsgPort *port)
{
    int rc;
    rc = pthread_mutex_init(&port->mutex, NULL);
    if (rc)
	{
        ri.Printf(PRINT_ALL, "MsgPortInit: pthread_mutex_init returned: %d: %s\n", rc, strerror(rc));
    }
    rc = pthread_cond_init(&port->condition, NULL);
    if (rc)
	{
        ri.Printf(PRINT_ALL, "EventInit: pthread_cond_init returned %d: %s\n", rc, strerror(rc));
    }
    port->status = MsgNone;
    port->msgCode = MsgCodeInvalid;
    port->msgData = NULL;
}

static  void _SendMsg(MsgPort *port, unsigned int msgCode, void *msgData,
                         const char *functionName, const char *portName, const char *msgName)
{
    int rc;

    //printf("SendMsg: %s %s %s (%d %08lx)\n",functionName, portName, msgName, msgCode, msgData);
    rc = pthread_mutex_lock(&port->mutex);
    if(rc)
	{
        fprintf(stderr,"SendMsg: pthread_mutex_lock returned %d: %s\n", rc, strerror(rc));
    }

    /* Block until port is empty */
    while(port->status != MsgNone)
	{
      //fprintf(stderr, "SendMsg: %s blocking until port %s is empty\n", functionName, portName);
      rc = pthread_cond_wait(&port->condition, &port->mutex);
      if(rc)
	  {
        printf("SendMsg: pthread_cond_wait returned %d: %s\n", rc, strerror(rc));
      }
    }

    /* Queue msg */
    port->msgCode = msgCode;
    port->msgData = msgData;
    port->status = MsgPending;

    /* Unlock port */
    rc = pthread_mutex_unlock(&port->mutex);
    if(rc)
	{
        printf("SendMsg: pthread_mutex_unlock returned %d: %s\n", rc, strerror(rc));
    }

    /* Wake up any threads blocked waiting for a message */
    rc = pthread_cond_broadcast(&port->condition);
    if(rc)
	{
       printf("SendMsg: pthread_cond_broadcast returned %d: %s\n", rc, strerror(rc));
    }
}

static void _WaitMsg(MsgPort *port, unsigned int *msgCode, void **msgData,
                                const char *functionName, const char *portName)
{
    int rc;

    //printf("WaitMsg: %s %s\n",functionName, portName);

    rc = pthread_mutex_lock(&port->mutex);
    if(rc)
	{
        printf("WaitMsg: pthread_mutex_lock returned %d: %s\n", rc, strerror(rc));
    }

    /* Block until port is empty */
    while(port->status != MsgPending)
	{
      rc = pthread_cond_wait(&port->condition, &port->mutex);
      if(rc)
	  {
        printf("WaitMsg: pthread_cond_wait returned %d: %s\n", rc, strerror(rc));
      }
    }

    /* Remove msg */
    *msgCode = port->msgCode;
    *msgData = port->msgData;

    //printf("WaitMsg: %s %s got %d %08lx\n",functionName, portName, *msgCode, *msgData);

    port->status = MsgNone;
    port->msgCode = 0;
    port->msgData = NULL;

    rc = pthread_mutex_unlock(&port->mutex);
    if(rc)
	{
        printf("WaitMsg: pthread_mutex_unlock returned %d: %s\n", rc, strerror(rc));
    }

    /* Wake up any threads blocked waiting for port to be empty. */
    rc = pthread_cond_broadcast(&port->condition);
    if(rc)
	{
       printf("SendMsg: pthread_cond_broadcast returned %d: %s\n", rc, strerror(rc));
    }
}


#define SendMsg(p, c, d) _SendMsg(p, c, d, __PRETTY_FUNCTION__, #p, #c)
#define WaitMsg(p, c, d) _WaitMsg(p, c, d, __PRETTY_FUNCTION__, #p)


//
// The main Q3 SMP API
//

static void (*glimpRenderThread)( void ) = NULL;

static void *GLimp_RenderThreadWrapper(void *arg)
{
    Com_Printf("Render thread starting\n");

    glimpRenderThread();

    // Send one last message back to front end before we die...
    // This is somewhat of a hack.. fixme.
    if (rendererProcessingCommand)
	{
        SendMsg(&frontEndMsgPort, RenderCompletedMsg, NULL);
        rendererProcessingCommand = false;
    }

    Com_Printf("Render thread terminating\n");

    return arg;
}

qboolean GLimp_SpawnRenderThread( void (*function)( void ) )
{
    pthread_t renderThread;
    int       rc;

	pthread_init ();

    if (!portsInited)
	{
        portsInited = true;
        MsgPortInit(&rendererMsgPort);
        MsgPortInit(&frontEndMsgPort);
        renderMsgOutstanding = false;
        rendererProcessingCommand = false;
        pthread_mutex_init(&logMutex, NULL);
    }

    glimpRenderThread = function;

    rc = pthread_create(&renderThread,
                        NULL, // attributes
                        GLimp_RenderThreadWrapper,
                        NULL); // argument
    if (rc) {
        ri.Printf(PRINT_ALL, "pthread_create returned %d: %s", rc, strerror(rc));
        return qfalse;
    } else {
        rc = pthread_detach(renderThread);
        if (rc) {
            ri.Printf(PRINT_ALL, "pthread_detach returned %d: %s", rc, strerror(rc));
        }
    }

    return qtrue;
}

static	volatile void	*smpData;

// TJW - This is calling in the rendering thread to wait until another
// command buffer is ready.  The command buffer returned might be NULL,
// indicating that the rendering thread should exit.
void *GLimp_RendererSleep(void)
{
    unsigned int msgCode;
    void *msgData;

    // Let the main thread we are idle and that no work is queued
    //_Log("rs0\n");
    /* If we actually had some work to do, then tell the front end we completed it. */
    if (rendererProcessingCommand)
	{
        SendMsg(&frontEndMsgPort, RenderCompletedMsg, NULL);
        rendererProcessingCommand = false;
    }

    // Wait for new msg
    for (;;)
	{
        WaitMsg(&rendererMsgPort, &msgCode, &msgData);
        if (1 || msgCode == RenderCommandMsg)
		{
            smpData = msgData;
            break;
        }
		else
		{
            printf("renderer received unknown message: %d\n",msgCode);
        }
    }

    rendererProcessingCommand = true;

    return (void *)smpData;
}


// TJW - This is from the main thread to wait until the rendering thread
// has completed the command buffer that it has
void GLimp_FrontEndSleep(void)
{
    unsigned int msgCode;
    void *msgData;

    if (renderMsgOutstanding)
	{
        for (;;)
		{
            WaitMsg(&frontEndMsgPort, &msgCode, &msgData);
            if(1 || msgCode == RenderCompletedMsg)
			{
                break;
            }
			else
			{
                printf("front end received unknown message: %d\n",msgCode);
            }
        }
        renderMsgOutstanding = false;
    }
}


// TJW - This is called in the main thread to issue another command
// buffer to the rendering thread.  This is always called AFTER
// GLimp_FrontEndSleep, so we know that there is no command
// pending in 'smpData'.
void GLimp_WakeRenderer( void *data )
{
    SendMsg(&rendererMsgPort, RenderCommandMsg, data);

    // Don't set flag saying that the renderer is processing something if it's just
    // being told to exit.
    //if(data != NULL)
    renderMsgOutstanding = true;
}

#else

void GLimp_RenderThreadWrapper( void *stub ) {}
qboolean GLimp_SpawnRenderThread( void (*function)( void ) )
{
	ri.Printf( PRINT_WARNING, "ERROR: SMP support was disabled at compile time\n");
  return qfalse;
}
void *GLimp_RendererSleep( void )
{
  return NULL;
}
void GLimp_FrontEndSleep( void ) {}
void GLimp_WakeRenderer( void *data ) {}

#endif

//ScePspRGBA8888 ALIGNED(16)	psppallete[palette_size];

void GLimp_SetGamma (unsigned char red[256], unsigned char green[256], unsigned char blue[256])
{/*
    for (int i = 0 ; i < 256 ; i++)
	{
		const unsigned int r = red[i];
		const unsigned int g = green[i];
		const unsigned int b = blue[i];
		psppallete[i] = GU_RGBA(r, g, b, 0xff);
	}

	// Upload the palette.
	sceGuClutMode(GU_PSM_8888, 0, palette_size - 1, 0);
	sceKernelDcacheWritebackRange(psppallete, sizeof(psppallete));
	sceGuClutLoad(palette_size / 8, psppallete);
*/}

qboolean QGL_Init (const char *dllname)
{
    printf("%s (%d):\n", __FUNCTION__, __LINE__);
    return qtrue;
}

void QGL_Shutdown (void)
{
    printf("%s (%d):\n", __FUNCTION__, __LINE__);
}
