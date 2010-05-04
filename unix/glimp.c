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

extern "C"
{
#include "../renderer/tr_local.h"
}

#include <pspdisplay.h>
#include <pspgu.h>
#include <pspgum.h>
#include <pspkernel.h>
#include <pspdebug.h>


qboolean ( * qwglSwapIntervalEXT)( int interval );
void ( * qglMultiTexCoord2fARB )( GLenum texture, float s, float t );
void ( * qglActiveTextureARB )( GLenum texture );
void ( * qglClientActiveTextureARB )( GLenum texture );


void ( * qglLockArraysEXT)( int, int);
void ( * qglUnlockArraysEXT) ( void );

#ifdef _WIN32
# define ALIGNED(x)
#else
# define ALIGNED(x) __attribute__((aligned(x)))
#endif

#include "valloc.h"

namespace quake3
{
	namespace video
	{

		// Types.
		//typedef ScePspRGB565	pixel;
    typedef ScePspRGBA8888	pixel;
		typedef u8				texel;
		typedef u16				depth_value;

		// Constants.
		static const std::size_t	screen_width	= 480;
		static const std::size_t	screen_height	= 272;
		static const std::size_t	palette_size	= 256;
		static pixel* 				display_buffer	= 0;
		static pixel*				draw_buffer		= 0;
		static depth_value*			depth_buffer	= 0;

		//! The GU display list.
		//! @note	Aligned to 64 bytes so it doesn't share a cache line with anything.
		unsigned int ALIGNED(64)	display_list[262144];

	}
}
using namespace quake3;
using namespace quake3::video;

void GLimp_EndFrame (void)
{
  // Finish rendering.
	sceGuFinish();
	sceGuSync(0, 0);

	// At the moment only do this if we are in network mode, once we get above
	// 60fps we might as well leave it on for all games
	//if (tcpipAvailable || r_vsync.value)
	//	sceDisplayWaitVblankStart();

	// Switch the buffers.
	sceGuSwapBuffers();
	std::swap(draw_buffer, display_buffer);

	// Start a new render.
	sceGuStart(GU_DIRECT, display_list);
}


void GLimp_Init (void)
{
  // Allocate the buffers.
	display_buffer	= static_cast<pixel*>(vram::allocate(screen_height * 512 * sizeof(pixel)));
	if (!display_buffer)
	{
		Sys_Error("Couldn't allocate display buffer");
	}
	draw_buffer	= static_cast<pixel*>(vram::allocate(screen_height * 512 * sizeof(pixel)));
	if (!draw_buffer)
	{
		Sys_Error("Couldn't allocate draw buffer");
	}
	depth_buffer	= static_cast<depth_value*>(vram::allocate(screen_height * 512 * sizeof(depth_value)));
	if (!depth_buffer)
	{
		Sys_Error("Couldn't allocate depth buffer");
	}

	// Initialise the GU.
	sceGuInit();

	// Set up the GU.
	sceGuStart(GU_DIRECT, display_list);
	{
		// Set the draw and display buffers.
		void* const	vram_base				= sceGeEdramGetAddr();
		void* const	display_buffer_in_vram	= reinterpret_cast<char*>(display_buffer) - reinterpret_cast<std::size_t>(vram_base);
		void* const draw_buffer_in_vram		= reinterpret_cast<char*>(draw_buffer) - reinterpret_cast<std::size_t>(vram_base);
		void* const depth_buffer_in_vram	= reinterpret_cast<char*>(depth_buffer) - reinterpret_cast<std::size_t>(vram_base);

		//sceGuDrawBuffer(GU_PSM_5650, draw_buffer_in_vram, 512);
    sceGuDrawBuffer(GU_PSM_8888, draw_buffer_in_vram, 512);
		sceGuDispBuffer(screen_width, screen_height, display_buffer_in_vram, 512);
		sceGuDepthBuffer(depth_buffer_in_vram, 512);

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
        //sceGuDepthMask (GU_TRUE); //Z-writing TEST

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
		sceGuFrontFace(GU_CW);
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
}

void GLimp_EnableLogging (qboolean enable) { printf("%s (%d):\n", __FUNCTION__, __LINE__); }

void GLimp_LogComment (char *comment) { /* printf("%s", comment); */ }

void *GLimp_RendererSleep (void) { printf("%s (%d):\n", __FUNCTION__, __LINE__); return NULL; }

void GLimp_FrontEndSleep (void) { printf("%s (%d):\n", __FUNCTION__, __LINE__); }

qboolean GLimp_SpawnRenderThread (void (*function)(void)) { return qfalse; }

void GLimp_WakeRenderer( void *data ) { printf("%s (%d):\n", __FUNCTION__, __LINE__); }

void GLimp_SetGamma (unsigned char red[256], unsigned char green[256], unsigned char blue[256]) { }

qboolean QGL_Init (const char *dllname) { printf("%s (%d):\n", __FUNCTION__, __LINE__); return qtrue; }

void QGL_Shutdown (void) { printf("%s (%d):\n", __FUNCTION__, __LINE__); }
