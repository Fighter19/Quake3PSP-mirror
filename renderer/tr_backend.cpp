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
extern "C"
{
#include "tr_local.h"
}

backEndData_t	*backEndData[SMP_FRAMES];
backEndState_t	backEnd;

#include "clipping.hpp"

static float	s_flipMatrix[16] =
{
	// convert from our coordinate system (looking down X)
	// to OpenGL's coordinate system (looking down -Z)
	0, 0, -1, 0,
	-1, 0, 0, 0,
	0, 1, 0, 0,
	0, 0, 0, 1
};


/*
** GL_Bind
*/
#include <vramalloc.h>

typedef struct
{
	int	min, max;
} textureMode_t;

//Crow_bar. fixed for psp
textureMode_t modes[] =
{
    {GU_LINEAR_MIPMAP_LINEAR,   GU_LINEAR_MIPMAP_LINEAR},
	{GU_NEAREST_MIPMAP_NEAREST, GU_NEAREST_MIPMAP_NEAREST},
	{GU_LINEAR_MIPMAP_NEAREST,  GU_LINEAR_MIPMAP_NEAREST},
	{GU_NEAREST_MIPMAP_LINEAR,  GU_NEAREST_MIPMAP_LINEAR},
	{GU_NEAREST_MIPMAP_LINEAR,  GU_LINEAR_MIPMAP_NEAREST},
	{GU_LINEAR_MIPMAP_NEAREST,  GU_NEAREST_MIPMAP_LINEAR},
	{GU_NEAREST_MIPMAP_LINEAR,  GU_LINEAR_MIPMAP_LINEAR},
	{GU_LINEAR_MIPMAP_NEAREST,  GU_NEAREST_MIPMAP_NEAREST},
	{GU_NEAREST_MIPMAP_NEAREST, GU_LINEAR_MIPMAP_LINEAR},
	{GU_LINEAR_MIPMAP_LINEAR,   GU_NEAREST_MIPMAP_NEAREST}
};

void GL_Bind( image_t *image ) 
{
    if (!image)
	{
		ri.Printf( PRINT_WARNING, "GL_Bind: NULL image\n" );
		return;
    }

  	if ( r_nobind->integer && tr.dlightImage )
	{
	  image = tr.dlightImage;
 	}

 	int texnum = image->texnum;

    if ( glState.currenttextures[glState.currenttmu] != texnum )
	{
        image->frameUsed = tr.frameCount;
		glState.currenttextures[glState.currenttmu] = texnum;
		// Set the texture mode.
	    sceGuTexMode(image->format, image->mipmaps, 0 /* set 1 for clut uploading */, image->swizzle);

	   	if (image->mipmaps > 0)
		{
	        float slope = 0.4f;
			sceGuTexSlope(slope); // the near from 0 slope is the lower (=best detailed) mipmap it uses
			sceGuTexFilter(modes[r_mipmaps_mode->integer].min, modes[r_mipmaps_mode->integer].max);
		    sceGuTexLevelMode(r_mipmaps_func->integer, r_mipmaps_bias->integer); // manual slope setting
		}
		else
	        sceGuTexFilter(image->filter, image->filter);

		// Set the texture image.
		const void* const texture_memory = image->vram ? image->vram : image->ram;
		sceGuTexImage(0, image->uploadWidth, image->uploadHeight, image->uploadWidth, texture_memory);

		if (image->mipmaps > 0 && r_mipmaps->integer)
		{
			int size = 0;
	        switch(image->format)
			{
	          case GU_PSM_DXT1:
	           size = image->uploadWidth * image->uploadHeight / 2;
	           break;
			  case GU_PSM_8888:
	          case GU_PSM_T32:
	           size = image->uploadWidth * image->uploadHeight * 4;
			   break;
			  case GU_PSM_5650:
			  case GU_PSM_5551:
			  case GU_PSM_4444:
	          case GU_PSM_T16:
	           size = image->uploadWidth * image->uploadHeight * 2;
	           break;
	          case GU_PSM_T8:
		      case GU_PSM_DXT3:
			  case GU_PSM_DXT5:
			   size = image->uploadWidth * image->uploadHeight;
	           break;
			}

			int offset = size;
			int div = 2;

			for (int i = 1; i <= image->mipmaps; i++)
			{

	            void* const texture_memory2 = ((byte*) texture_memory)+offset;
	            sceGuTexImage(i, image->uploadWidth/div, image->uploadHeight/div, image->uploadWidth/div, texture_memory2);
				offset += size/(div*div);
				div *=2;
			}
		}

		sceGuTexWrap(image->wrapClampMode, image->wrapClampMode);
    }
}


/*
** GL_SelectTexture
*/
void GL_SelectTexture( int unit )
{

	if ( glState.currenttmu == unit )
	{
		return;
	}

/*
	if ( unit == 0 )
	{
		qglActiveTextureARB( GL_TEXTURE0_ARB );
		GLimp_LogComment( "glActiveTextureARB( GL_TEXTURE0_ARB )\n" );
		qglClientActiveTextureARB( GL_TEXTURE0_ARB );
		GLimp_LogComment( "glClientActiveTextureARB( GL_TEXTURE0_ARB )\n" );
	}
	else if ( unit == 1 )
	{
		qglActiveTextureARB( GL_TEXTURE1_ARB );
		GLimp_LogComment( "glActiveTextureARB( GL_TEXTURE1_ARB )\n" );
		qglClientActiveTextureARB( GL_TEXTURE1_ARB );
		GLimp_LogComment( "glClientActiveTextureARB( GL_TEXTURE1_ARB )\n" );
	} else {
		ri.Error( ERR_DROP, "GL_SelectTexture: unit = %i", unit );
	}
*/
	glState.currenttmu = unit;

}


/*
** GL_BindMultitexture
*/
void GL_BindMultitexture( image_t *image0, int env0, image_t *image1, int env1 ) 
{
	/*
	int		texnum0, texnum1;

	texnum0 = image0->texnum;
	texnum1 = image1->texnum;

	if ( r_nobind->integer && tr.dlightImage ) {		// performance evaluation option
		texnum0 = texnum1 = tr.dlightImage->texnum;
	}

	if ( glState.currenttextures[1] != texnum1 ) {
		GL_SelectTexture( 1 );
		image1->frameUsed = tr.frameCount;
		glState.currenttextures[1] = texnum1;
		qglBindTexture( GL_TEXTURE_2D, texnum1 );
	}
	if ( glState.currenttextures[0] != texnum0 ) {
		GL_SelectTexture( 0 );
		image0->frameUsed = tr.frameCount;
		glState.currenttextures[0] = texnum0;
		qglBindTexture( GL_TEXTURE_2D, texnum0 );
	}
  */
}


/*
** GL_Cull
*/
void GL_Cull( int cullType ) 
{
	if ( glState.faceCulling == cullType ) 
	{
		return;
	}

	glState.faceCulling = cullType;

	if ( cullType == CT_TWO_SIDED ) 
	{
		sceGuDisable( GU_CULL_FACE );
	} 
	else 
	{
		sceGuEnable( GU_CULL_FACE );

		if ( cullType == CT_BACK_SIDED )
		{

			if ( backEnd.viewParms.isMirror )
			{
                sceGuFrontFace(GU_CW); //FRONT
			}
			else
			{
                sceGuFrontFace(GU_CCW); //BACK
			}

		}
		else
		{

			if ( backEnd.viewParms.isMirror )
			{
                sceGuFrontFace(GU_CCW); //BACK
			}
			else
			{
                sceGuFrontFace(GU_CW); //FRONT
			}

		}
	}
}

/*
** GL_TexEnv
*/
void GL_TexEnv( int env )
{
	if ( env == glState.texEnv[glState.currenttmu] )
	{
		return;
	}

	glState.texEnv[glState.currenttmu] = env;

	switch ( env )
	{
	case GU_TFX_MODULATE:
		sceGuTexFunc(GU_TFX_MODULATE, GU_TCC_RGBA);
		break;
	case GU_TFX_REPLACE:
		sceGuTexFunc(GU_TFX_REPLACE, GU_TCC_RGBA);
		break;
	case GU_TFX_DECAL:
		sceGuTexFunc(GU_TFX_DECAL, GU_TCC_RGBA);
		break;
	case GU_TFX_ADD:
		sceGuTexFunc(GU_TFX_ADD, GU_TCC_RGBA);
		break;
	default:
		ri.Error( ERR_DROP, "GL_TexEnv: invalid env '%d' passed\n", env );
		break;
	}
}

/*
** GL_State
**
** This routine is responsible for setting the most commonly changed state
** in Q3.
*/
void GL_State( unsigned long stateBits )
{
	unsigned long diff = stateBits ^ glState.glStateBits;

	if ( !diff )
	{
		return;
	}

	//
	// check depthFunc bits
	//
	if ( diff & GLS_DEPTHFUNC_EQUAL )
	{
		if ( stateBits & GLS_DEPTHFUNC_EQUAL )
		{
			sceGuDepthFunc( GU_EQUAL );
		}
		else
		{
			sceGuDepthFunc( GU_LEQUAL );
		}
	}

	//
	// check blend bits
	//
	if ( diff & ( GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS ) )
	{
		int srcFactor, dstFactor;

		if ( stateBits & ( GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS ) )
		{
			switch ( stateBits & GLS_SRCBLEND_BITS )
			{
			case GLS_SRCBLEND_ZERO:
                srcFactor = GU_DST_ALPHA;
				break;
			case GLS_SRCBLEND_ONE:
				srcFactor = GU_ONE_MINUS_DST_ALPHA;
				break;
			case GLS_SRCBLEND_DST_COLOR:
				srcFactor = GU_DST_COLOR;
				break;
			case GLS_SRCBLEND_ONE_MINUS_DST_COLOR:
				srcFactor = GU_ONE_MINUS_DST_COLOR;
				break;
			case GLS_SRCBLEND_SRC_ALPHA:
				srcFactor = GU_SRC_ALPHA;
				break;
			case GLS_SRCBLEND_ONE_MINUS_SRC_ALPHA:
				srcFactor = GU_ONE_MINUS_SRC_ALPHA;
				break;
			case GLS_SRCBLEND_DST_ALPHA:
				srcFactor = GU_DST_ALPHA;
				break;
			case GLS_SRCBLEND_ONE_MINUS_DST_ALPHA:
				srcFactor = GU_ONE_MINUS_DST_ALPHA;
				break;
			case GLS_SRCBLEND_ALPHA_SATURATE:
				srcFactor = GU_ONE_MINUS_SRC_ALPHA;
				break;
			default:
				srcFactor = GU_ONE_MINUS_DST_ALPHA;		// to get warning to shut up
				ri.Error( ERR_DROP, "GL_State: invalid src blend state bits\n" );
				break;
			}

			switch ( stateBits & GLS_DSTBLEND_BITS )
			{
			case GLS_DSTBLEND_ZERO:
				dstFactor = GU_DST_ALPHA;
				break;
			case GLS_DSTBLEND_ONE:
				dstFactor = GU_ONE_MINUS_DST_ALPHA;
				break;
			case GLS_DSTBLEND_SRC_COLOR:
				dstFactor = GU_SRC_COLOR;
				break;
			case GLS_DSTBLEND_ONE_MINUS_SRC_COLOR:
				dstFactor = GU_ONE_MINUS_SRC_COLOR;
				break;
			case GLS_DSTBLEND_SRC_ALPHA:
				dstFactor = GU_SRC_ALPHA;
				break;
			case GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA:
				dstFactor = GU_ONE_MINUS_SRC_ALPHA;
				break;
			case GLS_DSTBLEND_DST_ALPHA:
				dstFactor = GU_DST_ALPHA;
				break;
			case GLS_DSTBLEND_ONE_MINUS_DST_ALPHA:
				dstFactor = GU_ONE_MINUS_DST_ALPHA;
				break;
			default:
				dstFactor = GU_ONE_MINUS_DST_ALPHA;		// to get warning to shut up
				ri.Error( ERR_DROP, "GL_State: invalid dst blend state bits\n" );
				break;
			}

			sceGuEnable( GU_BLEND );
			sceGuBlendFunc(GU_ADD, srcFactor, dstFactor, 0, 0);
		
		}
		else
		{
            sceGuBlendFunc(GU_ADD, GU_SRC_ALPHA, GU_ONE_MINUS_SRC_ALPHA, 0, 0);
			sceGuDisable( GU_BLEND );
		}
	}

	//
	// check depthmask
	//
	if ( diff & GLS_DEPTHMASK_TRUE )
	{
		if ( stateBits & GLS_DEPTHMASK_TRUE )
		{
			sceGuDepthMask( GU_FALSE );
		}
		else
		{
			sceGuDepthMask( GU_TRUE );
		}
	}
/*
	//
	// fill/line mode
	//
	if ( diff & GLS_POLYMODE_LINE )
	{
		if ( stateBits & GLS_POLYMODE_LINE )
		{
			qglPolygonMode( GL_FRONT_AND_BACK, GL_LINE );
		}
		else
		{
			qglPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
		}
	}
*/
    //
	// depthtest
	//
	if ( diff & GLS_DEPTHTEST_DISABLE )
	{
		if ( stateBits & GLS_DEPTHTEST_DISABLE )
		{
			sceGuDisable( GU_DEPTH_TEST );
		}
		else
		{
			sceGuEnable( GU_DEPTH_TEST );
		}
	}

	//
	// alpha test
	//
	if ( diff & GLS_ATEST_BITS )
	{
		switch ( stateBits & GLS_ATEST_BITS )
		{
		case 0:
			sceGuDisable( GU_ALPHA_TEST );
            sceGuAlphaFunc(GU_GREATER, 0, 0xff);
			break;
		case GLS_ATEST_GT_0:
			sceGuEnable( GU_ALPHA_TEST );
            sceGuAlphaFunc(GU_GREATER, 0x88, 0xff);
			break;
		case GLS_ATEST_LT_80:
			sceGuEnable( GU_ALPHA_TEST );
			sceGuAlphaFunc( GU_LESS, 0x88, 0xff);
			break;
		case GLS_ATEST_GE_80:
			sceGuEnable( GU_ALPHA_TEST );
			sceGuAlphaFunc( GU_GEQUAL, 0x88, 0xff);
			break;
		default:
			assert( 0 );
			break;
		}
	}

	glState.glStateBits = stateBits;
}



/*
================
RB_Hyperspace

A player has predicted a teleport, but hasn't arrived yet
================
*/
static void RB_Hyperspace( void )
{
	float		c;

	if ( !backEnd.isHyperspace ) 
	{
		// do initialization shit
	}

	c = ( backEnd.refdef.time & 255 ) / 255.0f;
	sceGuClearColor(GU_COLOR( c, c, c, 1 ));
	sceGuClear( GU_COLOR_BUFFER_BIT );

	backEnd.isHyperspace = qtrue;
}


static void SetViewportAndScissor( void ) 
{
	sceGumMatrixMode(GU_PROJECTION);
	sceGumLoadMatrix((ScePspFMatrix4*)&backEnd.viewParms.projectionMatrix );
    sceGumUpdateMatrix();
    sceGumMatrixMode(GU_VIEW);
	sceGumLoadIdentity();
	sceGumMatrixMode(GU_MODEL);



    // set the window clipping
	sceGuViewport(2048 - backEnd.viewParms.viewportX, 2048 - backEnd.viewParms.viewportY,
    backEnd.viewParms.viewportWidth, backEnd.viewParms.viewportHeight);
	sceGuScissor(backEnd.viewParms.viewportX, backEnd.viewParms.viewportY,
		backEnd.viewParms.viewportWidth, backEnd.viewParms.viewportHeight );

	quake::clipping::begin_frame();
}

/*
=================
RB_BeginDrawingView

Any mirrored or portaled views have already been drawn, so prepare
to actually render the visible surfaces for this view
=================
*/
void RB_BeginDrawingView (void) 
{
	int clearBits = 0;
/*
	// sync with gl if needed
	if ( r_finish->integer == 1 && !glState.finishCalled ) 
	{
		sceGuFinish();
		glState.finishCalled = qtrue;
	}
	if ( r_finish->integer == 0 )
	{
		glState.finishCalled = qtrue;
	}
*/
	// we will need to change the projection matrix before drawing
	// 2D images again
	backEnd.projection2D = qfalse;

	//
	// set the modelview matrix for the viewer
	//
	SetViewportAndScissor();

	// ensures that depth writes are enabled for the depth clear
	GL_State( GLS_DEFAULT );
	// clear relevant buffers
	clearBits = GU_DEPTH_BUFFER_BIT;

	if ( r_measureOverdraw->integer || r_shadows->integer == 2 )
	{
		clearBits |= GU_STENCIL_BUFFER_BIT;
	}
	if ( r_fastsky->integer && !( backEnd.refdef.rdflags & RDF_NOWORLDMODEL ) )
	{
		clearBits |= GU_COLOR_BUFFER_BIT;	// FIXME: only if sky shaders have been used
#ifdef _DEBUG
		sceGuClearColor(GU_COLOR( 0.8f, 0.7f, 0.4f, 1.0f));	// FIXME: get color of sky
#else
		sceGuClearColor(GU_COLOR(0.0f, 0.0f, 0.0f, 1.0f ));	// FIXME: get color of sky
#endif
	}
	sceGuClear( clearBits );

	if ( ( backEnd.refdef.rdflags & RDF_HYPERSPACE ) )
	{
		RB_Hyperspace();
		return;
	}
	else
	{
		backEnd.isHyperspace = qfalse;
	}

	glState.faceCulling = -1;		// force face culling to set next time

	// we will only draw a sun if there was sky rendered in this view
	backEnd.skyRenderedThisView = qfalse;

	// clip to the plane of the portal
	if ( backEnd.viewParms.isPortal ) 
	{
		float	plane[4];
		double	plane2[4];

		plane[0] = backEnd.viewParms.portalPlane.normal[0];
		plane[1] = backEnd.viewParms.portalPlane.normal[1];
		plane[2] = backEnd.viewParms.portalPlane.normal[2];
		plane[3] = backEnd.viewParms.portalPlane.dist;

		plane2[0] = DotProduct (backEnd.viewParms.por.axis[0], plane);
		plane2[1] = DotProduct (backEnd.viewParms.por.axis[1], plane);
		plane2[2] = DotProduct (backEnd.viewParms.por.axis[2], plane);
		plane2[3] = DotProduct (plane, backEnd.viewParms.por.origin) - plane[3];

		sceGumLoadMatrix((ScePspFMatrix4*)&s_flipMatrix );
        sceGumUpdateMatrix();

		//qglClipPlane (GL_CLIP_PLANE0, plane2);
		//qglEnable (GL_CLIP_PLANE0);
	} 
	//else
	//{
	//	//qglDisable (GL_CLIP_PLANE0);
	//}
}


#define	MAC_EVENT_PUMP_MSEC		5

/*
==================
RB_RenderDrawSurfList
==================
*/
void R_SetupProjection(viewParms_t *dest, float zProj, qboolean computeFrustum);
void RB_RenderDrawSurfList( drawSurf_t *drawSurfs, int numDrawSurfs ) {
	shader_t		*shader, *oldShader;
	int				fogNum, oldFogNum;
	int				entityNum, oldEntityNum;
	int				dlighted, oldDlighted;
	qboolean		depthRange, oldDepthRange, isCrosshair, wasCrosshair;
	int				i;
	drawSurf_t		*drawSurf;
	int				oldSort;
	float			originalTime;
#ifdef __MACOS__
	int				macEventTime;

	Sys_PumpEvents();		// crutch up the mac's limited buffer queue size

	// we don't want to pump the event loop too often and waste time, so
	// we are going to check every shader change
	macEventTime = ri.Milliseconds() + MAC_EVENT_PUMP_MSEC;
#endif
/*
    int oldtime = ri.Milliseconds();
*/
	// save original time for entity shader offsets
	originalTime = backEnd.refdef.floatTime;

	// clear the z buffer, set the modelview, etc
	RB_BeginDrawingView ();

	// draw everything
	oldEntityNum = -1;
	backEnd.currentEntity = &tr.worldEntity;
	oldShader = NULL;
	oldFogNum = -1;
	oldDepthRange = qfalse;
	oldDlighted = qfalse;
	oldSort = -1;
	depthRange = qfalse;

	backEnd.pc.c_surfaces += numDrawSurfs;

	for (i = 0, drawSurf = drawSurfs ; i < numDrawSurfs ; i++, drawSurf++)
    {
		if ( drawSurf->sort == oldSort )
        {
			// fast path, same as previous sort
			rb_surfaceTable[ *drawSurf->surface ]( drawSurf->surface );
			continue;
		}
		oldSort = drawSurf->sort;
        
		R_DecomposeSort( drawSurf->sort, &entityNum, &shader, &fogNum, &dlighted );
		//
		// change the tess parameters if needed
		// a "entityMergable" shader is a shader that can have surfaces from seperate
		// entities merged into a single batch, like smoke and blood puff sprites
		if (shader != oldShader || fogNum != oldFogNum || dlighted != oldDlighted 
			|| ( entityNum != oldEntityNum && !shader->entityMergable ) )
			{
			if (oldShader != NULL)
			{
#ifdef __MACOS__	// crutch up the mac's limited buffer queue size
				int		t;

				t = ri.Milliseconds();
				if ( t > macEventTime ) {
					macEventTime = t + MAC_EVENT_PUMP_MSEC;
					Sys_PumpEvents();
				}
#endif
				RB_EndSurface();
			}
			RB_BeginSurface( shader, fogNum );
			oldShader = shader;
			oldFogNum = fogNum;
			oldDlighted = dlighted;
		}

		//
		// change the modelview matrix if needed
		//
		if ( entityNum != oldEntityNum )
		{
			depthRange = isCrosshair = qfalse;

			if ( entityNum != ENTITYNUM_WORLD )
			{
				backEnd.currentEntity = &backEnd.refdef.entities[entityNum];
				backEnd.refdef.floatTime = originalTime - backEnd.currentEntity->e.shaderTime;
				// we have to reset the shaderTime as well otherwise image animations start
				// from the wrong frame
				tess.shaderTime = backEnd.refdef.floatTime - tess.shader->timeOffset;

				// set up the transformation matrix
				R_RotateForEntity( backEnd.currentEntity, &backEnd.viewParms, &backEnd.por );

				// set up the dynamic lighting if needed
				if ( backEnd.currentEntity->needDlights )
				{
					R_TransformDlights( backEnd.refdef.num_dlights, backEnd.refdef.dlights, &backEnd.por );
				}

				if ( backEnd.currentEntity->e.renderfx & RF_DEPTHHACK )
				{
					// hack the depth range to prevent view model from poking into walls
					depthRange = qtrue;
					if(backEnd.currentEntity->e.renderfx & RF_CROSSHAIR)
						isCrosshair = qtrue;
				}
			}
			else
			{
				backEnd.currentEntity = &tr.worldEntity;
				backEnd.refdef.floatTime = originalTime;
				backEnd.por = backEnd.viewParms.world;
				// we have to reset the shaderTime as well otherwise image animations on
				// the world (like water) continue with the wrong frame
				tess.shaderTime = backEnd.refdef.floatTime - tess.shader->timeOffset;

				R_TransformDlights( backEnd.refdef.num_dlights, backEnd.refdef.dlights, &backEnd.por );

			}

			sceGumLoadMatrix((ScePspFMatrix4*)&backEnd.por.modelMatrix );
            sceGumUpdateMatrix();
#if 0
			//
			// change depthrange if needed
			//
			if ( oldDepthRange != depthRange )
			{
				if ( depthRange )
				{
					sceGuDepthRange(0, 19660);
				}
				else
				{
					sceGuDepthRange(0, 65535);
				}
				oldDepthRange = depthRange;
			}
#else
            if (oldDepthRange != depthRange || wasCrosshair != isCrosshair)
			{
				if (depthRange)
				{
						if(isCrosshair)
						{
							if(oldDepthRange)
							{
								// was not a crosshair but now is, change back proj matrix
								sceGumMatrixMode(GU_PROJECTION);
								sceGumLoadMatrix((ScePspFMatrix4*)&backEnd.viewParms.projectionMatrix);
								sceGumUpdateMatrix();
								sceGumMatrixMode(GU_VIEW);
	                            sceGumUpdateMatrix();
	                            sceGumMatrixMode(GU_MODEL);
	                            sceGumUpdateMatrix();

							}
						}
						else
						{
							viewParms_t temp = backEnd.viewParms;

							R_SetupProjection(&temp, r_znear->value, qfalse);

							sceGumMatrixMode(GU_PROJECTION);
							sceGumLoadMatrix((ScePspFMatrix4*)&temp.projectionMatrix);
							sceGumUpdateMatrix();
							sceGumMatrixMode(GU_VIEW);
	                        sceGumUpdateMatrix();
	                        sceGumMatrixMode(GU_MODEL);
	                        sceGumUpdateMatrix();
						}

						if(!oldDepthRange)
							sceGuDepthRange(0, 19660);
				}
				else
				{
					if(!wasCrosshair)
					{
						sceGumMatrixMode(GU_PROJECTION);
						sceGumLoadMatrix((ScePspFMatrix4*)&backEnd.viewParms.projectionMatrix);
						sceGumUpdateMatrix();
						sceGumMatrixMode(GU_VIEW);
	                    sceGumUpdateMatrix();
	                    sceGumMatrixMode(GU_MODEL);
	                    sceGumUpdateMatrix();
					}

					sceGuDepthRange(0, 65535);
				}

				oldDepthRange = depthRange;
				wasCrosshair = isCrosshair;
			}
#endif
			oldEntityNum = entityNum;
		}

		// add the triangles for this surface
		rb_surfaceTable[ *drawSurf->surface ]( drawSurf->surface );
	}

	backEnd.refdef.floatTime = originalTime;

	// draw the contents of the last shader batch
	if (oldShader != NULL)
	{
		RB_EndSurface();
	}

	// go back to the world modelview matrix
	sceGumLoadMatrix((ScePspFMatrix4*) &backEnd.viewParms.world.modelMatrix );
    sceGumUpdateMatrix();

	if ( depthRange )
	{
		sceGuDepthRange(0, 65535);
	}
/*
	int lasttime = ri.Milliseconds();
	int statt = lasttime - oldtime;

	if(statt > 25)
	{
	 printf("result: %i\n", lasttime - oldtime);
    }
*/
#if 0
	RB_DrawSun();
#endif

	// darken down any stencil shadows
	RB_ShadowFinish();

	// add light flares on lights that aren't obscured
	RB_RenderFlares();


#ifdef __MACOS__
	Sys_PumpEvents();		// crutch up the mac's limited buffer queue size
#endif
}


/*
============================================================================

RENDER BACK END THREAD FUNCTIONS

============================================================================
*/

/*
================
RB_SetGL2D

================
*/
void	RB_SetGL2D (void) 
{
	backEnd.projection2D = qtrue;

	// set 2D virtual screen size
	sceGuViewport( 2048, 2048, glConfig.vidWidth, glConfig.vidHeight );
	sceGuScissor( 0, 0, glConfig.vidWidth, glConfig.vidHeight );

	sceGumMatrixMode(GU_PROJECTION);
	sceGumLoadIdentity();

	sceGumOrtho(0.0f, glConfig.vidWidth, glConfig.vidHeight, 0.0f, -1000.0f, 1000.0f);
	
	sceGumMatrixMode(GU_VIEW);
	sceGumLoadIdentity();
	
	sceGumMatrixMode(GU_MODEL);
	sceGumLoadIdentity();

	GL_State( GLS_DEPTHTEST_DISABLE |GLS_SRCBLEND_SRC_ALPHA | GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA);
	sceGuDisable( GU_CULL_FACE );

	// set time for 2D shaders
	backEnd.refdef.time = ri.Milliseconds();
	backEnd.refdef.floatTime = backEnd.refdef.time * 0.001f;
}

void DelTexture(int texture_index);
/*
=============
RE_StretchRaw

FIXME: not exactly backend
Stretches a raw 32 bit power of 2 bitmap image over the given screen rectangle.
Used for cinematics.
=============
*/
int numindexes;
extern int novertices;
void RE_StretchRaw (int x, int y, int w, int h, int cols, int rows, const byte *data, int client, qboolean dirty) 
{
	int			i, j;
	int			start, end;

	if ( !tr.registered )
	{
		return;
	}
	R_SyncRenderThread();

	start = end = 0;

	if ( r_speeds->integer )
	{
		start = ri.Milliseconds();
	}

	tr.scratchImage[client] = R_CreateImage("*updtex", data, cols, rows, qfalse, qfalse, GU_REPEAT);
    GL_Bind( tr.scratchImage[client]);

    numindexes = client;

	if ( r_speeds->integer )
	{
		end = ri.Milliseconds();
		ri.Printf( PRINT_ALL, "R_CreateImage(updated): %i, %i: %i msec\n", cols, rows, end - start );
	}

    //sceGuTexFunc(GU_TFX_REPLACE, GU_TCC_RGB);

    if ( !backEnd.projection2D )
	{
		RB_SetGL2D();
	}

	sceGuColor(GU_COLOR(tr.identityLight, tr.identityLight, tr.identityLight, 1));
	
    struct vertex
	{
		short			u, v;
		short			x, y, z;
	};
	vertex* const vertices = static_cast<vertex*>(sceGuGetMemory(sizeof(vertex) * 2));

	vertices[0].u = 0;
	vertices[0].v = 0;
	vertices[0].x = x;
	vertices[0].y = y;
    vertices[0].z = 0;

	vertices[1].u = tr.scratchImage[client]->uploadWidth;
	vertices[1].v = tr.scratchImage[client]->uploadHeight;
	vertices[1].x = x+w;
	vertices[1].y = y+h;
	vertices[1].z = 0;
	
	sceGumDrawArray(GU_SPRITES, GU_TEXTURE_16BIT | GU_VERTEX_16BIT | GU_TRANSFORM_2D, 2, 0, vertices);
    //novertices = 0;
}

void RE_UploadCinematic (int w, int h, int cols, int rows, const byte *data, int client, qboolean dirty) 
{ 
    tr.scratchImage[client] = R_CreateImage("*updtex", data, cols, rows, qfalse, qfalse, GU_CLAMP);
/*
	GL_Bind( tr.scratchImage[client] );

	// if the scratchImage isn't in the format we want, specify it as a new texture
	if ( cols != tr.scratchImage[client]->width || rows != tr.scratchImage[client]->height )
	{
		tr.scratchImage[client]->width = tr.scratchImage[client]->uploadWidth = cols;
		tr.scratchImage[client]->height = tr.scratchImage[client]->uploadHeight = rows;
		qglTexImage2D( GL_TEXTURE_2D, 0, GL_RGB8, cols, rows, 0, GL_RGBA, GL_UNSIGNED_BYTE, data );
		qglTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
		qglTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
		qglTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP );
		qglTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP );	
	}
	else 
	{
		if (dirty) 
		{
			// otherwise, just subimage upload it so that drivers can tell we are going to be changing
			// it and don't try and do a texture compression
			qglTexSubImage2D( GL_TEXTURE_2D, 0, 0, 0, cols, rows, GL_RGBA, GL_UNSIGNED_BYTE, data );
		}
	}
*/
}

void RemoveCINImages( void ) //Crow_bar. clear memory
{ 
  for(int i = 0; i < numindexes; i++)
  {
	 DelTexture(tr.scratchImage[i]->texnum);
  }
}


/*
=============
RB_SetColor

=============
*/
const void	*RB_SetColor( const void *data ) 
{
	const setColorCommand_t	*cmd;

	cmd = (const setColorCommand_t *)data;

	backEnd.color2D[0] = cmd->color[0] * 255;
	backEnd.color2D[1] = cmd->color[1] * 255;
	backEnd.color2D[2] = cmd->color[2] * 255;
	backEnd.color2D[3] = cmd->color[3] * 255;

	return (const void *)(cmd + 1);
}

/*
=============
RB_StretchPic
=============
*/
const void *RB_StretchPic ( const void *data ) 
{
	const stretchPicCommand_t	*cmd;
	shader_t *shader;
	int		numVerts, numIndexes;

	cmd = (const stretchPicCommand_t *)data;

	if ( !backEnd.projection2D ) 
	{
		RB_SetGL2D();
	}

	shader = cmd->shader;
	if ( shader != tess.shader )
	{
		if ( tess.numIndexes )
		{
			RB_EndSurface();
		}
		backEnd.currentEntity = &backEnd.entity2D;
		RB_BeginSurface( shader, 0 );
	}

	RB_CHECKOVERFLOW( 4, 6 );
	numVerts = tess.numVertexes;
	numIndexes = tess.numIndexes;

	tess.numVertexes += 4;
	tess.numIndexes += 6;

	tess.indexes[ numIndexes ] = numVerts + 3;
	tess.indexes[ numIndexes + 1 ] = numVerts + 0;
	tess.indexes[ numIndexes + 2 ] = numVerts + 2;
	tess.indexes[ numIndexes + 3 ] = numVerts + 2;
	tess.indexes[ numIndexes + 4 ] = numVerts + 0;
	tess.indexes[ numIndexes + 5 ] = numVerts + 1;

	*(int *)tess.vertexColors[ numVerts ] =
		*(int *)tess.vertexColors[ numVerts + 1 ] =
		*(int *)tess.vertexColors[ numVerts + 2 ] =
		*(int *)tess.vertexColors[ numVerts + 3 ] = *(int *)backEnd.color2D;

	tess.xyz[ numVerts ][0] = cmd->x;
	tess.xyz[ numVerts ][1] = cmd->y;
	tess.xyz[ numVerts ][2] = 0;

	//Crow_Bar. fixed for 2d transformation
	tess.texCoords[ numVerts ][0][0] = cmd->s1 * shader->stages[0]->bundle[0].image[0]->uploadWidth;
	tess.texCoords[ numVerts ][0][1] = cmd->t1 * shader->stages[0]->bundle[0].image[0]->uploadHeight;

	tess.xyz[ numVerts + 1 ][0] = cmd->x + cmd->w;
	tess.xyz[ numVerts + 1 ][1] = cmd->y;
	tess.xyz[ numVerts + 1 ][2] = 0;

	tess.texCoords[ numVerts + 1 ][0][0] = cmd->s2 * shader->stages[0]->bundle[0].image[0]->uploadWidth;
	tess.texCoords[ numVerts + 1 ][0][1] = cmd->t1 * shader->stages[0]->bundle[0].image[0]->uploadHeight;

	tess.xyz[ numVerts + 2 ][0] = cmd->x + cmd->w;
	tess.xyz[ numVerts + 2 ][1] = cmd->y + cmd->h;
	tess.xyz[ numVerts + 2 ][2] = 0;

	tess.texCoords[ numVerts + 2 ][0][0] = cmd->s2 * shader->stages[0]->bundle[0].image[0]->uploadWidth;
	tess.texCoords[ numVerts + 2 ][0][1] = cmd->t2 * shader->stages[0]->bundle[0].image[0]->uploadHeight;

	tess.xyz[ numVerts + 3 ][0] = cmd->x;
	tess.xyz[ numVerts + 3 ][1] = cmd->y + cmd->h;
	tess.xyz[ numVerts + 3 ][2] = 0;

	tess.texCoords[ numVerts + 3 ][0][0] = cmd->s1 * shader->stages[0]->bundle[0].image[0]->uploadWidth;
	tess.texCoords[ numVerts + 3 ][0][1] = cmd->t2 * shader->stages[0]->bundle[0].image[0]->uploadHeight;

	tess.transType = GU_TRANSFORM_2D;
	
	return (const void *)(cmd + 1);
}


/*
=============
RB_DrawSurfs

=============
*/
const void	*RB_DrawSurfs( const void *data ) 
{
	const drawSurfsCommand_t	*cmd;

	// finish any 2D drawing if needed
	if ( tess.numIndexes ) 
	{
		RB_EndSurface();
	}

	cmd = (const drawSurfsCommand_t *)data;

	backEnd.refdef = cmd->refdef;
	backEnd.viewParms = cmd->viewParms;

	RB_RenderDrawSurfList( cmd->drawSurfs, cmd->numDrawSurfs );

	return (const void *)(cmd + 1);
}


/*
=============
RB_DrawBuffer

=============
*/
const void	*RB_DrawBuffer( const void *data ) 
{
	const drawBufferCommand_t	*cmd;

	cmd = (const drawBufferCommand_t *)data;

    //SetBuffer (cmd->buffer);
    
	// clear screen for debugging
	if ( r_clear->integer ) 
	{
		//sceGuClearColor(GU_COLOR(1, 0, 0.5, 1));
		sceGuClearColor(GU_COLOR(0, 0, 0, 1)); //black color for clear screen
		sceGuClear( GU_COLOR_BUFFER_BIT | GU_DEPTH_BUFFER_BIT );
	}

	return (const void *)(cmd + 1);
}

/*
===============
RB_ShowImages

Draw all the images to the screen, on top of whatever
was there.  This is used to test for texture thrashing.

Also called by RE_EndRegistration
===============
*/
void RB_ShowImages( void ) 
{
	int		i;
	image_t	*image;
	float	x, y, w, h;
	int		start, end;

	if ( !backEnd.projection2D ) 
	{
		RB_SetGL2D();
	}

	sceGuClear( GU_COLOR_BUFFER_BIT );

	start = ri.Milliseconds();

	for ( i=0 ; i<tr.numImages ; i++ ) 
	{
		image = tr.images[i];

		w = glConfig.vidWidth / 20;
		h = glConfig.vidHeight / 15;
		x = i % 20 * w;
		y = i / 20 * h;

		// show in proportional size in mode 2
		if ( r_showImages->integer == 2 ) 
		{
			w *= image->uploadWidth / 512.0f;
			h *= image->uploadHeight / 512.0f;
		}
   
		GL_Bind( image );

		struct vertex
		{
			short			u, v;
			short			x, y, z;
		};
	
		vertex* const vertices = static_cast<vertex*>(sceGuGetMemory(sizeof(vertex) * 2));
		
		vertices[0].u = 0; 
		vertices[0].v = 0;
	    vertices[0].x = x;
		vertices[0].y = y;
		vertices[0].z = 0;
		
		vertices[1].u = image->uploadWidth;
		vertices[1].v = image->uploadHeight;
		vertices[1].x = x + w; 
		vertices[1].y = y + h;
		vertices[1].z = 0;
		
		sceGuDrawArray(GU_SPRITES, GU_TEXTURE_16BIT | GU_VERTEX_16BIT | GU_TRANSFORM_2D, 2, 0, vertices);
	}

	end = ri.Milliseconds();
	ri.Printf( PRINT_ALL, "%i msec to draw all images\n", end - start );

}


/*
=============
RB_SwapBuffers

=============
*/
const void	*RB_SwapBuffers( const void *data ) 
{
	const swapBuffersCommand_t	*cmd;

	// finish any 2D drawing if needed
	if ( tess.numIndexes ) 
	{
		RB_EndSurface();
	}

	// texture swapping test
	if ( r_showImages->integer ) 
	{
		RB_ShowImages();
	}

	cmd = (const swapBuffersCommand_t *)data;

	// we measure overdraw by reading back the stencil buffer and
	// counting up the number of increments that have happened
/*
	if ( r_measureOverdraw->integer ) 
	{
		int i;
		long sum = 0;
		unsigned char *stencilReadback;

		stencilReadback = ri.Hunk_AllocateTempMemory( glConfig.vidWidth * glConfig.vidHeight );
		qglReadPixels( 0, 0, glConfig.vidWidth, glConfig.vidHeight, GL_STENCIL_INDEX, GL_UNSIGNED_BYTE, stencilReadback );

		for ( i = 0; i < glConfig.vidWidth * glConfig.vidHeight; i++ ) {
			sum += stencilReadback[i];
		}

		backEnd.pc.c_overDraw += sum;
		ri.Hunk_FreeTempMemory( stencilReadback );
	}
*/
/*
	if ( !glState.finishCalled )
	{
		sceGuFinish();
	}
*/
	GLimp_LogComment( "***************** RB_SwapBuffers *****************\n\n\n" );

	GLimp_EndFrame();

	backEnd.projection2D = qfalse;

	return (const void *)(cmd + 1);
}

/*
====================
RB_ExecuteRenderCommands

This function will be called synchronously if running without
smp extensions, or asynchronously by another thread.
====================
*/
void RB_ExecuteRenderCommands( const void *data ) 
{
	int		t1, t2;

	t1 = ri.Milliseconds ();

	if ( !r_smp->integer || data == backEndData[0]->commands.cmds ) 
	{
		backEnd.smpFrame = 0;
	} 
	else 
	{
		backEnd.smpFrame = 1;
	}

	while ( 1 ) {
		switch ( *(const int *)data ) {
		case RC_SET_COLOR:
			data = RB_SetColor( data );
			break;
		case RC_STRETCH_PIC:
			data = RB_StretchPic( data );
			break;
		case RC_DRAW_SURFS:
			data = RB_DrawSurfs( data );
			break;
		case RC_DRAW_BUFFER:
			data = RB_DrawBuffer( data );
			break;
		case RC_SWAP_BUFFERS:
			data = RB_SwapBuffers( data );
			break;
		case RC_SCREENSHOT:
			data = RB_TakeScreenshotCmd( data );
			break;

		case RC_END_OF_LIST:
		default:
			// stop rendering on this thread
			t2 = ri.Milliseconds ();
			backEnd.pc.msec = t2 - t1;
			return;
		}
	}

}


/*
================
RB_RenderThread
================
*/
void RB_RenderThread( void ) 
{
	const void	*data;

	// wait for either a rendering command or a quit command
	while ( 1 )
	{
		// sleep until we have work to do
		data = GLimp_RendererSleep();

		if ( !data )
		{
			return;	// all done, renderer is shutting down
		}

		renderThreadActive = qtrue;

		RB_ExecuteRenderCommands( data );

		renderThreadActive = qfalse;
	}
}

