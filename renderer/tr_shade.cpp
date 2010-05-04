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
// tr_shade.c

#include <valarray>
#include <vector>

#include <pspkernel.h>

extern "C"
{
#include "tr_local.h"
}

#include "clipping.hpp"
using namespace quake;

/*

  THIS ENTIRE FILE IS BACK END

  This file deals with applying shaders to surface data in the tess struct.
*/


/*
================
R_ArrayElementDiscrete

This is just for OpenGL conformance testing, it should never be the fastest
================
*/

//PSP for draw
glvert_t	    current_vertices;

static void R_ArrayElementDiscrete( int index )
{

	current_vertices.c = GU_RGBA(tess.svars.colors[ index ][0],
	                     tess.svars.colors[ index ][1],
					     tess.svars.colors[ index ][2],
					     tess.svars.colors[ index ][3]);
					  
    current_vertices.st[0] = tess.svars.texcoords[ 0 ][ index ][0];
    current_vertices.st[1] = tess.svars.texcoords[ 0 ][ index ][1];

	current_vertices.xyz[0] = tess.xyz[ index ][0];
	current_vertices.xyz[1] = tess.xyz[ index ][1];
	current_vertices.xyz[2] = tess.xyz[ index ][2];
}



/*
===================
R_DrawStripElements

===================
*/
static int		c_vertexes;		// for seeing how long our average strips are
static int		c_begins;
static void R_DrawStripElements( int numIndexes, const glIndex_t *indexes, void ( *element )(int) )
{
	int i;
/*
	int last[3] = { -1, -1, -1 };
	qboolean even;

	int first_draw = 1;

	c_begins++;
*/
	if ( numIndexes <= 0 )
    {
		return;
	}

	//
	// prime the strip
	//

    glvert_t *vertices = static_cast<glvert_t *>(sceGuGetMemory(sizeof(glvert_t) * numIndexes));
	// prime the strip
	element( indexes[0] );
	vertices[0] = current_vertices;
	element( indexes[1] );
	vertices[1] = current_vertices;
	element( indexes[2] );
	vertices[2] = current_vertices;
/*
	c_vertexes += 3;

	last[0] = indexes[0];
	last[1] = indexes[1];
	last[2] = indexes[2];

	even = qfalse;
*/
	for ( i = 3; i < numIndexes; i += 3 )
	{
/*
        // odd numbered triangle in potential strip
		if ( !even )
		{
			// check previous triangle to see if we're continuing a strip
			if ( ( indexes[i+0] == last[2] ) && ( indexes[i+1] == last[1] ) )
			{
				element( indexes[i+2] );
                vertices[i+2] = current_vertices;
   			    c_vertexes++;
				assert( indexes[i+2] < tess.numVertexes );
				even = qtrue;
			}
			// otherwise we're done with this strip so finish it and start
			// a new one
			else
			{
  			    c_begins++;
*/
				element( indexes[i+0] );
                vertices[i+0] = current_vertices;
				element( indexes[i+1] );
                vertices[i+1] = current_vertices;
				element( indexes[i+2] );
                vertices[i+2] = current_vertices;
/*
				c_vertexes += 3;

				even = qfalse;
			}
		}
		else
		{
			// check previous triangle to see if we're continuing a strip
			if ( ( last[2] == indexes[i+1] ) && ( last[0] == indexes[i+0] ) )
			{
				element( indexes[i+2] );
                vertices[i+2] = current_vertices;
			    c_vertexes++;

				even = qfalse;
			}
			// otherwise we're done with this strip so finish it and start
			// a new one
			else
			{
		        c_begins++;

				element( indexes[i+0] );
                vertices[i+0] = current_vertices;
				element( indexes[i+1] );
                vertices[i+1] = current_vertices;
				element( indexes[i+2] );
                vertices[i+2] = current_vertices;
 			    c_vertexes += 3;

				even = qfalse;
			}
		}

		// cache the last three vertices
		last[0] = indexes[i+0];
		last[1] = indexes[i+1];
		last[2] = indexes[i+2];
*/
	}

    sceGuDrawArray(GU_TRIANGLES,GU_TEXTURE_32BITF | GU_COLOR_8888 | GU_INDEX_16BIT | GU_VERTEX_32BITF | tess.transType, numIndexes, indexes, vertices);

}

/*
===================
R_DrawSingleTriangles
===================
*/
void R_DrawSingleTriangles(int numIndexes, const glIndex_t *indexes)
{
    for(int i = 0 ; i < numIndexes ; i+=3)
	{
		// Allocate memory for this polygon.
		const int		unclipped_vertex_count	= 3;
		glvert_t* const	unclipped_vertices		=
			static_cast<glvert_t*>(sceGuGetMemory(sizeof(glvert_t) * unclipped_vertex_count));

		R_ArrayElementDiscrete( indexes[i+0] );
        unclipped_vertices[0] = current_vertices;
	    R_ArrayElementDiscrete( indexes[i+1] );
        unclipped_vertices[1] = current_vertices;
		R_ArrayElementDiscrete( indexes[i+2] );
        unclipped_vertices[2] = current_vertices;

    	if (clipping::is_clipping_required(unclipped_vertices,unclipped_vertex_count) && tess.transType != GU_TRANSFORM_2D && tess.clipping)
        {
	        // Clip the polygon.
            const glvert_t*	clipped_vertices;
            std::size_t		clipped_vertex_count;
            clipping::clip(unclipped_vertices,unclipped_vertex_count,&clipped_vertices,&clipped_vertex_count);
            // Did we have any vertices left?
            if (clipped_vertex_count)
            {
                // Copy the vertices to the display list.
                const std::size_t buffer_size = clipped_vertex_count * sizeof(glvert_t);
                glvert_t* const display_list_vertices = static_cast<glvert_t*>(sceGuGetMemory(buffer_size));
                memcpy(display_list_vertices, clipped_vertices, buffer_size);
                // Draw the clipped vertices.
                sceGuDrawArray(GU_TRIANGLE_FAN, GU_TEXTURE_32BITF | GU_COLOR_8888 | GU_VERTEX_32BITF | tess.transType,
                                            clipped_vertex_count, 0, display_list_vertices);
            }
		}
        else
        {
            // Draw the poly directly.
            sceGuDrawArray(GU_TRIANGLE_FAN,GU_TEXTURE_32BITF | GU_COLOR_8888 | GU_VERTEX_32BITF | tess.transType,
                                         unclipped_vertex_count, 0, unclipped_vertices);
        }
	}
	sceGuColor(0xFFFFFFFF);
}

/*
===================
R_DrawMultipleTriangles
===================
*/
void R_DrawMultipleTriangles(int numIndexes, const glIndex_t *indexes)
{
    static std::vector<glvert_t>		outvertices;
	
    for(int i = 0 ; i < numIndexes ; i+=3)
	{
		// Allocate memory for this polygon.
		const int		unclipped_vertex_count	= 3;
        glvert_t	    unclipped_vertices[3];

		R_ArrayElementDiscrete( indexes[i+0] );
        unclipped_vertices[0] = current_vertices;
	    R_ArrayElementDiscrete( indexes[i+1] );
        unclipped_vertices[1] = current_vertices;
		R_ArrayElementDiscrete( indexes[i+2] );
        unclipped_vertices[2] = current_vertices;

    	if (clipping::is_clipping_required(unclipped_vertices,unclipped_vertex_count) && tess.transType != GU_TRANSFORM_2D && tess.clipping)
        {
	        // Clip the polygon.
            const glvert_t*	clipped_vertices;
            std::size_t		clipped_vertex_count;
            clipping::clip(unclipped_vertices,unclipped_vertex_count,&clipped_vertices,&clipped_vertex_count);
            // Did we have any vertices left?
            if (clipped_vertex_count)
            {
                for( int ai = 0; ai <= clipped_vertex_count-3; ai++ )
			    {
				    outvertices.push_back( clipped_vertices[ 0 ] );
					outvertices.push_back( clipped_vertices[ ai + 1 ] );
					outvertices.push_back( clipped_vertices[ ai + 2 ] );
				}
            }
		}
        else
        {
            for(int ai = 0; ai < unclipped_vertex_count; ai++)
            {
                outvertices.push_back( unclipped_vertices[ai] );
			}
        }
	}

    int num_vertices(outvertices.size());
	glvert_t *	vertices( (glvert_t*)sceGuGetMemory(num_vertices*sizeof(glvert_t)) );

	for( u32 i = 0; i < num_vertices; i++ )
	{
        vertices[ i ]  = outvertices[ i ];
	}
	sceGuDrawArray(GU_TRIANGLES, GU_TEXTURE_32BITF | GU_COLOR_8888 | GU_VERTEX_32BITF | tess.transType, num_vertices, 0, vertices);

	outvertices.erase( outvertices.begin(), outvertices.end());

	sceGuColor(0xFFFFFFFF);
}

/*
==================
R_DrawElements

Optionally performs our own glDrawElements that looks for strip conditions
instead of using the single glDrawElements call that may be inefficient
without compiled vertex arrays.
==================
*/
int novertices = 0;
static void R_DrawElements( int numIndexes, const glIndex_t *indexes )
{
	int		primitives;
	primitives = r_primitives->integer;

	if(novertices)
	   return;
	   
    if ( primitives == 1 || primitives == 2 )
	{
        GL_TexEnv( GU_TFX_MODULATE );

		if(tess.transType != GU_TRANSFORM_2D && tess.clipping)
		   clipping::begin_brush_model();

	    if ( primitives == 1 )
		  R_DrawMultipleTriangles(numIndexes, indexes);
		else
		  R_DrawSingleTriangles(numIndexes, indexes); //slow draw
		  
		if(tess.transType != GU_TRANSFORM_2D && tess.clipping)
           clipping::end_brush_model();

		GL_TexEnv( GU_TFX_REPLACE );
	}
	else
	{
		R_DrawStripElements( numIndexes,  indexes, R_ArrayElementDiscrete ); //without clipping
		return;
	}

}


/*
=============================================================

SURFACE SHADERS

=============================================================
*/

shaderCommands_t __attribute__((aligned(16))) tess;
static qboolean	setArraysOnce;

/*
=================
R_BindAnimatedImage

=================
*/
static void R_BindAnimatedImage( textureBundle_t *bundle )
{
	int		index;

	if ( bundle->isVideoMap )
	{
		ri.CIN_RunCinematic(bundle->videoMapHandle);
		ri.CIN_UploadCinematic(bundle->videoMapHandle);
		return;
	}

	if ( bundle->numImageAnimations <= 1 )
	{
		GL_Bind( bundle->image[0] );
		return;
	}

	// it is necessary to do this messy calc to make sure animations line up
	// exactly with waveforms of the same frequency
	index = myftol( tess.shaderTime * bundle->imageAnimationSpeed * FUNCTABLE_SIZE );
	index >>= FUNCTABLE_SIZE2;

	if ( index < 0 )
	{
		index = 0;	// may happen with shader time offsets
	}

	index %= bundle->numImageAnimations;

	GL_Bind( bundle->image[ index ] );
}

/*
================
DrawTris

Draws triangle outlines for debugging
================
*/
static void DrawTris (shaderCommands_t *input)
{
    //GL_Bind( tr.whiteImage );
	sceGuColor(GU_COLOR(1,1,1,1));
	
	GL_State( GLS_POLYMODE_LINE | GLS_DEPTHMASK_TRUE );
    sceGuDepthRange(0, 0);
/*
	qglDisableClientState (GL_COLOR_ARRAY);
	qglDisableClientState (GL_TEXTURE_COORD_ARRAY);

	qglVertexPointer (3, GL_FLOAT, 16, input->xyz);	// padded for SIMD
*/
/*
	if (qglLockArraysEXT)
	{
		qglLockArraysEXT(0, input->numVertexes);
		GLimp_LogComment( "glLockArraysEXT\n" );
	}
*/
   	R_DrawElements( input->numIndexes, input->indexes );
/*
	if (qglUnlockArraysEXT)
	{
		qglUnlockArraysEXT();
		GLimp_LogComment( "glUnlockArraysEXT\n" );
	}
*/
	sceGuDepthRange(0, 65535);

}


/*
================
DrawNormals

Draws vertex normals for debugging
================
*/
static void DrawNormals (shaderCommands_t *input)
{
	int		i;
	vec3_t	temp;

	GL_Bind( tr.whiteImage );
	sceGuColor (GU_COLOR(1,1,1,1));
	sceGuDepthRange( 0, 0 );	// never occluded
	GL_State( GLS_POLYMODE_LINE | GLS_DEPTHMASK_TRUE );

	// Allocate the vertices.
	struct vertex
	{
		float x, y, z;
	};


	vertex * out = static_cast<vertex*>(sceGuGetMemory(sizeof(vertex) * input->numVertexes * 2));
	int index = 0;
    for (i = 0 ; i < input->numVertexes ; i++)
	{
		out[index].x = input->xyz[i][0];
		out[index].y = input->xyz[i][1];
		out[index].z = input->xyz[i][2];
        index++;
		VectorMA (input->xyz[i], 2, input->normal[i], temp);
		out[index].x = temp[0];
		out[index].y = temp[1];
		out[index].z = temp[2];
		index++;
	}
	sceGuDrawArray(GU_LINES,GU_VERTEX_32BITF | GU_TRANSFORM_3D, index, 0, out);

	sceGuDepthRange(0, 65535);
}

/*
==============
RB_BeginSurface

We must set some things up before beginning any tesselation,
because a surface may be forced to perform a RB_End due
to overflow.
==============
*/
void RB_BeginSurface( shader_t *shader, int fogNum )
{

	shader_t *state = (shader->remappedShader) ? shader->remappedShader : shader;

	tess.numIndexes  = 0;
	tess.numVertexes = 0;
    tess.transType   = GU_TRANSFORM_3D;
    tess.clipping    = 0;
	tess.shader      = state;
	tess.fogNum      = fogNum;
	tess.dlightBits  = 0;		// will be OR'd in by surface functions
	tess.xstages     = state->stages;
	tess.numPasses   = state->numUnfoggedPasses;
	tess.currentStageIteratorFunc = state->optimalStageIteratorFunc;

	tess.shaderTime = backEnd.refdef.floatTime - tess.shader->timeOffset;
	if (tess.shader->clampTime && tess.shaderTime >= tess.shader->clampTime)
	{
		tess.shaderTime = tess.shader->clampTime;
	}

}

/*
===================
DrawMultitextured

output = t0 * t1 or t0 + t1

t0 = most upstream according to spec
t1 = most downstream according to spec
===================
*/
static void DrawMultitextured( shaderCommands_t *input, int stage )
{
	return;
	shaderStage_t	*pStage;

	pStage = tess.xstages[stage];

	GL_State( pStage->stateBits );

	//
	// base
	//

	R_BindAnimatedImage( &pStage->bundle[0] );
      R_DrawElements( input->numIndexes, input->indexes );

	//
	// lightmap/secondary pass
	//
/*
	if ( r_lightmap->integer )
	{
		GL_TexEnv( GU_TFX_REPLACE );
	}
	else
	{
		GL_TexEnv( tess.shader->multitextureEnv );
	}
*/
	R_BindAnimatedImage( &pStage->bundle[1] );
	R_DrawElements( input->numIndexes, input->indexes );

}



/*
===================
ProjectDlightTexture

Perform dynamic lighting with another rendering pass
===================
*/
static void ProjectDlightTexture( void )
{
	int		i, l;
#if idppc_altivec
	vec_t	origin0, origin1, origin2;
	float   texCoords0, texCoords1;
	vector float floatColorVec0, floatColorVec1;
	vector float modulateVec, colorVec, zero;
	vector short colorShort;
	vector signed int colorInt;
	vector unsigned char floatColorVecPerm, modulatePerm, colorChar;
	vector unsigned char vSel = (vector unsigned char)(0x00, 0x00, 0x00, 0xff,
							   0x00, 0x00, 0x00, 0xff,
							   0x00, 0x00, 0x00, 0xff,
							   0x00, 0x00, 0x00, 0xff);
#else
	vec3_t	origin;
#endif
	float	*texCoords;
	byte	*colors;
	byte	clipBits[SHADER_MAX_VERTEXES];
	float	texCoordsArray[SHADER_MAX_VERTEXES][2];
	byte	colorArray[SHADER_MAX_VERTEXES][4];
	unsigned	hitIndexes[SHADER_MAX_INDEXES];
	int		numIndexes;
	float	scale;
	float	radius;
	vec3_t	floatColor;
	float	modulate;

	if ( !backEnd.refdef.num_dlights )
	{
		return;
	}

#if idppc_altivec
	// There has to be a better way to do this so that floatColor 
	// and/or modulate are already 16-byte aligned.
	floatColorVecPerm = vec_lvsl(0,(float *)floatColor);
	modulatePerm = vec_lvsl(0,(float *)&modulate);
	modulatePerm = (vector unsigned char)vec_splat((vector unsigned int)modulatePerm,0);
	zero = (vector float)vec_splat_s8(0);
#endif

	for ( l = 0 ; l < backEnd.refdef.num_dlights ; l++ ) {
		dlight_t	*dl;

		if ( !( tess.dlightBits & ( 1 << l ) ) ) {
			continue;	// this surface definately doesn't have any of this light
		}
		texCoords = texCoordsArray[0];
		colors = colorArray[0];

		dl = &backEnd.refdef.dlights[l];
#if idppc_altivec
		origin0 = dl->transformed[0];
		origin1 = dl->transformed[1];
		origin2 = dl->transformed[2];
#else
		VectorCopy( dl->transformed, origin );
#endif
		radius = dl->radius;
		scale = 1.0f / radius;

		floatColor[0] = dl->color[0] * 255.0f;
		floatColor[1] = dl->color[1] * 255.0f;
		floatColor[2] = dl->color[2] * 255.0f;
#if idppc_altivec
		floatColorVec0 = vec_ld(0, floatColor);
		floatColorVec1 = vec_ld(11, floatColor);
		floatColorVec0 = vec_perm(floatColorVec0,floatColorVec0,floatColorVecPerm);
#endif
		for ( i = 0 ; i < tess.numVertexes ; i++, texCoords += 2, colors += 4 ) {
#if idppc_altivec
			vec_t dist0, dist1, dist2;
#else
			vec3_t	dist;
#endif
			int		clip;

			backEnd.pc.c_dlightVertexes++;

#if idppc_altivec
			//VectorSubtract( origin, tess.xyz[i], dist );
			dist0 = origin0 - tess.xyz[i][0];
			dist1 = origin1 - tess.xyz[i][1];
			dist2 = origin2 - tess.xyz[i][2];
			texCoords0 = 0.5f + dist0 * scale;
			texCoords1 = 0.5f + dist1 * scale;

			clip = 0;
			if ( texCoords0 < 0.0f ) {
				clip |= 1;
			} else if ( texCoords0 > 1.0f ) {
				clip |= 2;
			}
			if ( texCoords1 < 0.0f ) {
				clip |= 4;
			} else if ( texCoords1 > 1.0f ) {
				clip |= 8;
			}
			texCoords[0] = texCoords0;
			texCoords[1] = texCoords1;
			
			// modulate the strength based on the height and color
			if ( dist2 > radius ) {
				clip |= 16;
				modulate = 0.0f;
			} else if ( dist2 < -radius ) {
				clip |= 32;
				modulate = 0.0f;
			} else {
				dist2 = Q_fabs(dist2);
				if ( dist2 < radius * 0.5f ) {
					modulate = 1.0f;
				} else {
					modulate = 2.0f * (radius - dist2) * scale;
				}
			}
			clipBits[i] = clip;

			modulateVec = vec_ld(0,(float *)&modulate);
			modulateVec = vec_perm(modulateVec,modulateVec,modulatePerm);
			colorVec = vec_madd(floatColorVec0,modulateVec,zero);
			colorInt = vec_cts(colorVec,0);	// RGBx
			colorShort = vec_pack(colorInt,colorInt);		// RGBxRGBx
			colorChar = vec_packsu(colorShort,colorShort);	// RGBxRGBxRGBxRGBx
			colorChar = vec_sel(colorChar,vSel,vSel);		// RGBARGBARGBARGBA replace alpha with 255
			vec_ste((vector unsigned int)colorChar,0,(unsigned int *)colors);	// store color
#else
			VectorSubtract( origin, tess.xyz[i], dist );
			texCoords[0] = 0.5f + dist[0] * scale;
			texCoords[1] = 0.5f + dist[1] * scale;

			clip = 0;
			if ( texCoords[0] < 0.0f ) {
				clip |= 1;
			} else if ( texCoords[0] > 1.0f ) {
				clip |= 2;
			}
			if ( texCoords[1] < 0.0f ) {
				clip |= 4;
			} else if ( texCoords[1] > 1.0f ) {
				clip |= 8;
			}
			// modulate the strength based on the height and color
			if ( dist[2] > radius ) {
				clip |= 16;
				modulate = 0.0f;
			} else if ( dist[2] < -radius ) {
				clip |= 32;
				modulate = 0.0f;
			} else {
				dist[2] = Q_fabs(dist[2]);
				if ( dist[2] < radius * 0.5f ) {
					modulate = 1.0f;
				} else {
					modulate = 2.0f * (radius - dist[2]) * scale;
				}
			}
			clipBits[i] = clip;

			colors[0] = myftol(floatColor[0] * modulate);
			colors[1] = myftol(floatColor[1] * modulate);
			colors[2] = myftol(floatColor[2] * modulate);
			colors[3] = 255;

			//Crow_bar.
			tess.svars.colors[ i ][0] = colors[0];
	        tess.svars.colors[ i ][1] = colors[1];
			tess.svars.colors[ i ][2] = colors[2];
		    tess.svars.colors[ i ][3] = colors[3];
            tess.svars.texcoords[ 0 ][ i ][0] = texCoords[0];
            tess.svars.texcoords[ 0 ][ i ][1] = texCoords[1];
#endif
		}

		// build a list of triangles that need light
		numIndexes = 0;
		for ( i = 0 ; i < tess.numIndexes ; i += 3 ) {
			int		a, b, c;

			a = tess.indexes[i];
			b = tess.indexes[i+1];
			c = tess.indexes[i+2];
			if ( clipBits[a] & clipBits[b] & clipBits[c] ) {
				continue;	// not lighted
			}
			hitIndexes[numIndexes] = a;
			hitIndexes[numIndexes+1] = b;
			hitIndexes[numIndexes+2] = c;
			numIndexes += 3;
		}

		if ( !numIndexes )
		{
			continue;
		}

		GL_Bind( tr.dlightImage );
		// include GLS_DEPTHFUNC_EQUAL so alpha tested surfaces don't add light
		// where they aren't rendered
		if ( dl->additive )
		{
			GL_State( GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE | GLS_DEPTHFUNC_EQUAL );
		}
		else
		{
			GL_State( GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ONE | GLS_DEPTHFUNC_EQUAL );
		}

	    tess.transType = GU_TRANSFORM_3D;
		tess.clipping = 1;
		
		R_DrawElements( numIndexes, hitIndexes );
		backEnd.pc.c_totalIndexes += numIndexes;
		backEnd.pc.c_dlightIndexes += numIndexes;
	}
}


/*
===================
RB_FogPass

Blends a fog texture on top of everything else
===================
*/
static void RB_FogPass( void )
{
	fog_t		*fog;
	int			i;

	fog = tr.world->fogs + tess.fogNum;

	for ( i = 0; i < tess.numVertexes; i++ ) {
		* ( int * )&tess.svars.colors[i] = fog->colorInt;
	}
	RB_CalcFogTexCoords( ( float * ) tess.svars.texcoords[0] );

	GL_Bind( tr.fogImage );

	if ( tess.shader->fogPass == FP_EQUAL )
	{
		GL_State( GLS_SRCBLEND_SRC_ALPHA | GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA | GLS_DEPTHFUNC_EQUAL );
	}
	else
	{
	   	GL_State( GLS_SRCBLEND_SRC_ALPHA | GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA );
	}

	R_DrawElements( tess.numIndexes, tess.indexes );
}

/*
===============
ComputeColors
===============
*/
static void ComputeColors( shaderStage_t *pStage )
{
	int		i;

	//
	// rgbGen
	//
	switch ( pStage->rgbGen )
	{
		case CGEN_IDENTITY:
			Com_Memset( tess.svars.colors, 0xff, tess.numVertexes * 4 );
			break;
		default:
		case CGEN_IDENTITY_LIGHTING:
			Com_Memset( tess.svars.colors, tr.identityLightByte, tess.numVertexes * 4 );
			break;
		case CGEN_LIGHTING_DIFFUSE:
			RB_CalcDiffuseColor( ( unsigned char * ) tess.svars.colors );
			break;
		case CGEN_EXACT_VERTEX:
			Com_Memcpy( tess.svars.colors, tess.vertexColors, tess.numVertexes * sizeof( tess.vertexColors[0] ) );
			break;
		case CGEN_CONST:
			for ( i = 0; i < tess.numVertexes; i++ ) {
				*(int *)tess.svars.colors[i] = *(int *)pStage->constantColor;
			}
			break;
		case CGEN_VERTEX:
			if ( tr.identityLight == 1 )
			{
				Com_Memcpy( tess.svars.colors, tess.vertexColors, tess.numVertexes * sizeof( tess.vertexColors[0] ) );
			}
			else
			{
				for ( i = 0; i < tess.numVertexes; i++ )
				{
					tess.svars.colors[i][0] = tess.vertexColors[i][0] * tr.identityLight;
					tess.svars.colors[i][1] = tess.vertexColors[i][1] * tr.identityLight;
					tess.svars.colors[i][2] = tess.vertexColors[i][2] * tr.identityLight;
					tess.svars.colors[i][3] = tess.vertexColors[i][3];
				}
			}
			break;
		case CGEN_ONE_MINUS_VERTEX:
			if ( tr.identityLight == 1 )
			{
				for ( i = 0; i < tess.numVertexes; i++ )
				{
					tess.svars.colors[i][0] = 255 - tess.vertexColors[i][0];
					tess.svars.colors[i][1] = 255 - tess.vertexColors[i][1];
					tess.svars.colors[i][2] = 255 - tess.vertexColors[i][2];
				}
			}
			else
			{
				for ( i = 0; i < tess.numVertexes; i++ )
				{
					tess.svars.colors[i][0] = ( 255 - tess.vertexColors[i][0] ) * tr.identityLight;
					tess.svars.colors[i][1] = ( 255 - tess.vertexColors[i][1] ) * tr.identityLight;
					tess.svars.colors[i][2] = ( 255 - tess.vertexColors[i][2] ) * tr.identityLight;
				}
			}
			break;
		case CGEN_FOG:
			{
				fog_t		*fog;

				fog = tr.world->fogs + tess.fogNum;

				for ( i = 0; i < tess.numVertexes; i++ ) {
					* ( int * )&tess.svars.colors[i] = fog->colorInt;
				}
			}
			break;
		case CGEN_WAVEFORM:
			RB_CalcWaveColor( &pStage->rgbWave, ( unsigned char * ) tess.svars.colors );
			break;
		case CGEN_ENTITY:
			RB_CalcColorFromEntity( ( unsigned char * ) tess.svars.colors );
			break;
		case CGEN_ONE_MINUS_ENTITY:
			RB_CalcColorFromOneMinusEntity( ( unsigned char * ) tess.svars.colors );
			break;
	}

	//
	// alphaGen
	//
	switch ( pStage->alphaGen )
	{
	case AGEN_SKIP:
		break;
	case AGEN_IDENTITY:
		if ( pStage->rgbGen != CGEN_IDENTITY ) {
			if ( ( pStage->rgbGen == CGEN_VERTEX && tr.identityLight != 1 ) ||
				 pStage->rgbGen != CGEN_VERTEX ) {
				for ( i = 0; i < tess.numVertexes; i++ ) {
					tess.svars.colors[i][3] = 0xff;
				}
			}
		}
		break;
	case AGEN_CONST:
		if ( pStage->rgbGen != CGEN_CONST ) {
			for ( i = 0; i < tess.numVertexes; i++ ) {
				tess.svars.colors[i][3] = pStage->constantColor[3];
			}
		}
		break;
	case AGEN_WAVEFORM:
		RB_CalcWaveAlpha( &pStage->alphaWave, ( unsigned char * ) tess.svars.colors );
		break;
	case AGEN_LIGHTING_SPECULAR:
		RB_CalcSpecularAlpha( ( unsigned char * ) tess.svars.colors );
		break;
	case AGEN_ENTITY:
		RB_CalcAlphaFromEntity( ( unsigned char * ) tess.svars.colors );
		break;
	case AGEN_ONE_MINUS_ENTITY:
		RB_CalcAlphaFromOneMinusEntity( ( unsigned char * ) tess.svars.colors );
		break;
    case AGEN_VERTEX:
		if ( pStage->rgbGen != CGEN_VERTEX ) {
			for ( i = 0; i < tess.numVertexes; i++ ) {
				tess.svars.colors[i][3] = tess.vertexColors[i][3];
			}
		}
        break;
    case AGEN_ONE_MINUS_VERTEX:
        for ( i = 0; i < tess.numVertexes; i++ )
        {
			tess.svars.colors[i][3] = 255 - tess.vertexColors[i][3];
        }
        break;
	case AGEN_PORTAL:
		{
			unsigned char alpha;

			for ( i = 0; i < tess.numVertexes; i++ )
			{
				float len;
				vec3_t v;

				VectorSubtract( tess.xyz[i], backEnd.viewParms.por.origin, v );
				len = VectorLength( v );

				len /= tess.shader->portalRange;

				if ( len < 0 )
				{
					alpha = 0;
				}
				else if ( len > 1 )
				{
					alpha = 0xff;
				}
				else
				{
					alpha = len * 0xff;
				}

				tess.svars.colors[i][3] = alpha;
			}
		}
		break;
	}

	//
	// fog adjustment for colors to fade out as fog increases
	//
	if ( tess.fogNum )
	{
		switch ( pStage->adjustColorsForFog )
		{
		case ACFF_MODULATE_RGB:
			RB_CalcModulateColorsByFog( ( unsigned char * ) tess.svars.colors );
			break;
		case ACFF_MODULATE_ALPHA:
			RB_CalcModulateAlphasByFog( ( unsigned char * ) tess.svars.colors );
			break;
		case ACFF_MODULATE_RGBA:
			RB_CalcModulateRGBAsByFog( ( unsigned char * ) tess.svars.colors );
			break;
		case ACFF_NONE:
			break;
		}
	}
}

/*
===============
ComputeTexCoords
===============
*/
static void ComputeTexCoords( shaderStage_t *pStage )
{
	int		i;
	int		b;

	for ( b = 0; b < NUM_TEXTURE_BUNDLES; b++ )
	{
		int tm;

		//
		// generate the texture coordinates
		//
		switch ( pStage->bundle[b].tcGen )
		{
		case TCGEN_IDENTITY:
			Com_Memset( tess.svars.texcoords[b], 0, sizeof( float ) * 2 * tess.numVertexes );
			break;
		case TCGEN_TEXTURE:
			for ( i = 0 ; i < tess.numVertexes ; i++ )
			{
				tess.svars.texcoords[b][i][0] = tess.texCoords[i][0][0];
				tess.svars.texcoords[b][i][1] = tess.texCoords[i][0][1];
			}
			break;
		case TCGEN_LIGHTMAP:
			for ( i = 0 ; i < tess.numVertexes ; i++ )
			{
				tess.svars.texcoords[b][i][0] = tess.texCoords[i][1][0];
				tess.svars.texcoords[b][i][1] = tess.texCoords[i][1][1];
			}
			break;
		case TCGEN_VECTOR:
			for ( i = 0 ; i < tess.numVertexes ; i++ )
			{
				tess.svars.texcoords[b][i][0] = DotProduct( tess.xyz[i], pStage->bundle[b].tcGenVectors[0] );
				tess.svars.texcoords[b][i][1] = DotProduct( tess.xyz[i], pStage->bundle[b].tcGenVectors[1] );
			}
			break;
		case TCGEN_FOG:
			RB_CalcFogTexCoords( ( float * ) tess.svars.texcoords[b] );
			break;
		case TCGEN_ENVIRONMENT_MAPPED:
			RB_CalcEnvironmentTexCoords( ( float * ) tess.svars.texcoords[b] );
			break;
		case TCGEN_BAD:
			return;
		}

		//
		// alter texture coordinates
		//
		for ( tm = 0; tm < pStage->bundle[b].numTexMods ; tm++ )
		{
			switch ( pStage->bundle[b].texMods[tm].type )
			{
			case TMOD_NONE:
				tm = TR_MAX_TEXMODS;		// break out of for loop
				break;

			case TMOD_TURBULENT:
				RB_CalcTurbulentTexCoords( &pStage->bundle[b].texMods[tm].wave, 
						                 ( float * ) tess.svars.texcoords[b] );
				break;

			case TMOD_ENTITY_TRANSLATE:
				RB_CalcScrollTexCoords( backEnd.currentEntity->e.shaderTexCoord,
									 ( float * ) tess.svars.texcoords[b] );
				break;

			case TMOD_SCROLL:
				RB_CalcScrollTexCoords( pStage->bundle[b].texMods[tm].scroll,
										 ( float * ) tess.svars.texcoords[b] );
				break;

			case TMOD_SCALE:
				RB_CalcScaleTexCoords( pStage->bundle[b].texMods[tm].scale,
									 ( float * ) tess.svars.texcoords[b] );
				break;
			
			case TMOD_STRETCH:
				RB_CalcStretchTexCoords( &pStage->bundle[b].texMods[tm].wave, 
						               ( float * ) tess.svars.texcoords[b] );
				break;

			case TMOD_TRANSFORM:
				RB_CalcTransformTexCoords( &pStage->bundle[b].texMods[tm],
						                 ( float * ) tess.svars.texcoords[b] );
				break;

			case TMOD_ROTATE:
				RB_CalcRotateTexCoords( pStage->bundle[b].texMods[tm].rotateSpeed,
										( float * ) tess.svars.texcoords[b] );
				break;

			default:
				ri.Error( ERR_DROP, "ERROR: unknown texmod '%d' in shader '%s'\n", pStage->bundle[b].texMods[tm].type, tess.shader->name );
				break;
			}
		}
	}
}

/*
** RB_IterateStagesGeneric
*/
static void RB_IterateStagesGeneric( shaderCommands_t *input )
{
	int stage;

	for ( stage = 0; stage < MAX_SHADER_STAGES; stage++ )
	{
		shaderStage_t *pStage = tess.xstages[stage];

		if ( !pStage )
		{
			break;
		}

		ComputeColors( pStage );
		ComputeTexCoords( pStage );

		//if ( pStage->bundle[1].image[0] != 0 )
		//{
		//	DrawMultitextured( input, stage );
		//}
		//else
		{
			//
			// set state
			//
			if ( pStage->bundle[0].vertexLightmap && ( (r_vertexLight->integer && !r_uiFullScreen->integer) || glConfig.hardwareType == GLHW_PERMEDIA2 ) && r_lightmap->integer )
			{
				 GL_Bind( tr.whiteImage );
			}
			else
			     R_BindAnimatedImage( &pStage->bundle[0] );

     		      GL_State( pStage->stateBits );

			//
			// draw
			//
			R_DrawElements( input->numIndexes, input->indexes );
		}
		// allow skipping out to show just lightmaps during development
		if ( r_lightmap->integer && ( pStage->bundle[0].isLightmap || pStage->bundle[1].isLightmap || pStage->bundle[0].vertexLightmap ) )
		{
			break;
		}
	}
}


/*
** RB_StageIteratorGeneric
*/
void RB_StageIteratorGeneric( void )
{
	shaderCommands_t *input;

	input = &tess;

	RB_DeformTessGeometry();

	//
	// log this call
	//
	if ( r_logFile->integer ) 
	{
		// don't just call LogComment, or we will get
		// a call to va() every frame!
		GLimp_LogComment( va("--- RB_StageIteratorGeneric( %s ) ---\n", tess.shader->name) );
	}

	//
	// set face culling appropriately
	//
	GL_Cull( input->shader->cullType );

	// set polygon offset if necessary
	if ( input->shader->polygonOffset )
	{
		//qglEnable( GL_POLYGON_OFFSET_FILL );
		//qglPolygonOffset( r_offsetFactor->value, r_offsetUnits->value );
		//sceGuDepthMask(GU_TRUE);//don't use it
	    sceGuDepthOffset(-256);
	}

	//
	// if there is only a single pass then we can enable color
	// and texture arrays before we compile, otherwise we need
	// to avoid compiling those arrays since they will change
	// during multipass rendering
	//

	if ( tess.numPasses > 1 || input->shader->multitextureEnv )
	{
		setArraysOnce = qfalse;
/*
		qglDisableClientState (GL_COLOR_ARRAY);
		qglDisableClientState (GL_TEXTURE_COORD_ARRAY);
*/
	}
	else
	{
		setArraysOnce = qtrue;
/*
		qglEnableClientState( GL_COLOR_ARRAY);
		qglColorPointer( 4, GL_UNSIGNED_BYTE, 0, tess.svars.colors );

		qglEnableClientState( GL_TEXTURE_COORD_ARRAY);
		qglTexCoordPointer( 2, GL_FLOAT, 0, tess.svars.texcoords[0] );
*/
	}

	//
	// lock XYZ
	//
/*
	qglVertexPointer (3, GL_FLOAT, 16, input->xyz);	// padded for SIMD
	if (qglLockArraysEXT)
	{
		qglLockArraysEXT(0, input->numVertexes);
		GLimp_LogComment( "glLockArraysEXT\n" );
	}
*/
	//
	// enable color and texcoord arrays after the lock if necessary
	//
/*
	if ( !setArraysOnce )
	{
		qglEnableClientState( GL_TEXTURE_COORD_ARRAY );
		qglEnableClientState( GL_COLOR_ARRAY );
	}
*/
	//
	// call shader function
	//
	RB_IterateStagesGeneric( input );

	// 
	// now do any dynamic lighting needed
	//
	if ( tess.dlightBits && tess.shader->sort <= SS_OPAQUE
		&& !(tess.shader->surfaceFlags & (SURF_NODLIGHT | SURF_SKY) ) ) 
      {
		ProjectDlightTexture();
	}

	//
	// now do fog
	//
	if ( tess.fogNum && tess.shader->fogPass ) 
      {
		RB_FogPass();
	}

	// 
	// unlock arrays
	//
/*
	if (qglUnlockArraysEXT) 
	{
		qglUnlockArraysEXT();
		GLimp_LogComment( "glUnlockArraysEXT\n" );
	}
*/
	//
	// reset polygon offset
	//
    if ( input->shader->polygonOffset )
	{
	  //qglDisable( GL_POLYGON_OFFSET_FILL );
        sceGuDepthOffset(0);
        //sceGuDepthMask(GU_FALSE); //don't use it
	}

}


/*
** RB_StageIteratorVertexLitTexture
*/
void RB_StageIteratorVertexLitTexture( void )
{
	shaderCommands_t *input;
	shader_t		*shader;

	input = &tess;

	shader = input->shader;

	//
	// compute colors
	//
	RB_CalcDiffuseColor( ( unsigned char * ) tess.svars.colors );

	//
	// log this call
	//
	if ( r_logFile->integer ) 
	{
		// don't just call LogComment, or we will get
		// a call to va() every frame!
		GLimp_LogComment( va("--- RB_StageIteratorVertexLitTexturedUnfogged( %s ) ---\n", tess.shader->name) );
	}

	//
	// set face culling appropriately
	//
	GL_Cull( input->shader->cullType );

	//
	// set arrays and lock
	//
/*
	qglEnableClientState( GL_COLOR_ARRAY);
	qglEnableClientState( GL_TEXTURE_COORD_ARRAY);

	qglColorPointer( 4, GL_UNSIGNED_BYTE, 0, tess.svars.colors );
	qglTexCoordPointer( 2, GL_FLOAT, 16, tess.texCoords[0][0] );
	qglVertexPointer (3, GL_FLOAT, 16, input->xyz);

	if ( qglLockArraysEXT )
	{
		qglLockArraysEXT(0, input->numVertexes);
		GLimp_LogComment( "glLockArraysEXT\n" );
	}
*/
	//
	// call special shade routine
	//
	R_BindAnimatedImage( &tess.xstages[0]->bundle[0] );
	GL_State( tess.xstages[0]->stateBits );
	R_DrawElements( input->numIndexes, input->indexes );

	// 
	// now do any dynamic lighting needed
	//
	if ( tess.dlightBits && tess.shader->sort <= SS_OPAQUE )
	{
		ProjectDlightTexture();
	}

	//
	// now do fog
	//
	if ( tess.fogNum && tess.shader->fogPass ) {
		RB_FogPass();
	}

	// 
	// unlock arrays
	//
/*
	if (qglUnlockArraysEXT) 
	{
		qglUnlockArraysEXT();
		GLimp_LogComment( "glUnlockArraysEXT\n" );
	}
*/
}

//define	REPLACE_MODE

void RB_StageIteratorLightmappedMultitexture( void )
{
	shaderCommands_t *input;

	input = &tess;

	//
	// log this call
	//
	if ( r_logFile->integer ) {
		// don't just call LogComment, or we will get
		// a call to va() every frame!
		GLimp_LogComment( va("--- RB_StageIteratorLightmappedMultitexture( %s ) ---\n", tess.shader->name) );
	}

	//
	// set face culling appropriately
	//
	GL_Cull( input->shader->cullType );

	//
	// set color, pointers, and lock
	//
    ri.Printf( PRINT_ALL, "RB_StageIteratorLightmappedMultitexture\n" );
	GL_State( GLS_DEFAULT );
/*
	qglVertexPointer( 3, GL_FLOAT, 16, input->xyz );

#ifdef REPLACE_MODE
	qglDisableClientState( GL_COLOR_ARRAY );
	qglColor3f( 1, 1, 1 );
	qglShadeModel( GL_FLAT );
#else
	qglEnableClientState( GL_COLOR_ARRAY );
	qglColorPointer( 4, GL_UNSIGNED_BYTE, 0, tess.constantColor255 );
#endif
*/
	//
	// select base stage
	//
	GL_SelectTexture( 0 );
/*
	qglEnableClientState( GL_TEXTURE_COORD_ARRAY );
*/
	R_BindAnimatedImage( &tess.xstages[0]->bundle[0] );
/*
	qglTexCoordPointer( 2, GL_FLOAT, 16, tess.texCoords[0][0] );
*/
	//
	// configure second stage
	//

	//GL_SelectTexture( 1 );
	sceGuEnable( GU_TEXTURE_2D );
	if ( r_lightmap->integer )
	{
		GL_TexEnv( GU_TFX_REPLACE );
	}
	else
	{
		GL_TexEnv( GU_TFX_MODULATE );
	}

	R_BindAnimatedImage( &tess.xstages[0]->bundle[1] );
/*
	qglEnableClientState( GL_TEXTURE_COORD_ARRAY );
	qglTexCoordPointer( 2, GL_FLOAT, 16, tess.texCoords[0][1] );
*/
	//
	// lock arrays
	//
/*
	if ( qglLockArraysEXT ) {
		qglLockArraysEXT(0, input->numVertexes);
		GLimp_LogComment( "glLockArraysEXT\n" );
	}
*/
	R_DrawElements( input->numIndexes, input->indexes );

	//
	// disable texturing on TEXTURE1, then select TEXTURE0
	//

	//sceGuDisable( GU_TEXTURE_2D );
	//qglDisableClientState( GL_TEXTURE_COORD_ARRAY );

//	GL_SelectTexture( 0 );
#ifdef REPLACE_MODE
	GL_TexEnv( GL_MODULATE );
	qglShadeModel( GL_SMOOTH );
#endif

	// 
	// now do any dynamic lighting needed
	//
	if ( tess.dlightBits && tess.shader->sort <= SS_OPAQUE )
	{
		ProjectDlightTexture();
	}

	//
	// now do fog
	//
	if ( tess.fogNum && tess.shader->fogPass ) {
		RB_FogPass();
	}

	//
	// unlock arrays
	//
/*
	if ( qglUnlockArraysEXT ) {
		qglUnlockArraysEXT();
		GLimp_LogComment( "glUnlockArraysEXT\n" );
	}
*/
}

/*
** RB_EndSurface
*/
void RB_EndSurface( void )
{
	shaderCommands_t *input;

	input = &tess;

	if (input->numIndexes == 0)
	{
		return;
	}

	if (input->indexes[SHADER_MAX_INDEXES-1] != 0)
	{
		ri.Error (ERR_DROP, "RB_EndSurface() - SHADER_MAX_INDEXES hit");
	}	
	if (input->xyz[SHADER_MAX_VERTEXES-1][0] != 0)
	{
		ri.Error (ERR_DROP, "RB_EndSurface() - SHADER_MAX_VERTEXES hit");
	}

	if ( tess.shader == tr.shadowShader )
	{
		RB_ShadowTessEnd();
		return;
	}

	// for debugging of sort order issues, stop rendering after a given sort value
	if ( r_debugSort->integer && r_debugSort->integer < tess.shader->sort )
	{
		return;
	}

	//
	// update performance counters
	//
	backEnd.pc.c_shaders++;
	backEnd.pc.c_vertexes += tess.numVertexes;
	backEnd.pc.c_indexes += tess.numIndexes;
	backEnd.pc.c_totalIndexes += tess.numIndexes * tess.numPasses;

	//
	// call off to shader specific tess end function
	//
	tess.currentStageIteratorFunc();

	//
	// draw debugging stuff
	//
	if ( r_showtris->integer )
	{
		DrawTris (input);
	}
	if ( r_shownormals->integer )
	{
		DrawNormals (input);
	}
	// clear shader so we can tell we don't have any unclosed surfaces
	tess.numIndexes = 0;

	GLimp_LogComment( "----------\n" );
}

