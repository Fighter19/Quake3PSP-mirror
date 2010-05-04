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
// tr_image.c
#include <valarray>
#include <vector>
#include <pspkernel.h>
#include <malloc.h>
#include <reent.h>
#include <vram.h>

//fast memcpy
#define FAST_MEMCPY

//full flush data cache
#define FULL_FLUSH

#define JPEG_INTERNALS

extern "C"
{
#include "tr_local.h"
#include "../jpeg-6/jpeglib.h"
#include "tr_dxtn.h"
}

#ifdef FAST_MEMCPY
#include "../unix/pspdmac.h"
#endif

/*
 * Include file for users of JPEG library.
 * You will need to have included system headers that define at least
 * the typedefs FILE and size_t before you can include jpeglib.h.
 * (stdio.h is sufficient on ANSI-conforming systems.)
 * You may also wish to include "jerror.h".
 */

static void LoadBMP( const char *name, byte **pic, int *width, int *height );
static void LoadTGA( const char *name, byte **pic, int *width, int *height );
static void LoadJPG( const char *name, byte **pic, int *width, int *height );

static byte			 s_intensitytable[256];
static unsigned char s_gammatable[256];

int		gl_filter_min = 0;//GL_LINEAR_MIPMAP_NEAREST;
int		gl_filter_max = 0;//GL_LINEAR;

#define FILE_HASH_SIZE		1024
static	image_t*		hashTable[FILE_HASH_SIZE];

qboolean 		texused[1024];
int alltexsize    = 0;

/*
** R_GammaCorrect
*/
void R_GammaCorrect( byte *buffer, int bufSize ) {
	int i;

	for ( i = 0; i < bufSize; i++ ) {
		buffer[i] = s_gammatable[buffer[i]];
	}
}


/*
================
return a hash value for the filename
================
*/
static long generateHashValue( const char *fname )
{
	int		i;
	long	hash;
	char	letter;

	hash = 0;
	i = 0;
	while (fname[i] != '\0') {
		letter = tolower(fname[i]);
		if (letter =='.') break;				// don't include extension
		if (letter =='\\') letter = '/';		// damn path names
		hash+=(long)(letter)*(i+119);
		i++;
	}
	hash &= (FILE_HASH_SIZE-1);
	return hash;
}

/*
===============
GL_TextureMode
===============
*/
void GL_TextureMode( const char *string )
{
/*
	int		i;
	image_t	*glt;

	for ( i=0 ; i< 6 ; i++ ) {
		if ( !Q_stricmp( modes[i].name, string ) ) {
			break;
		}
	}

	// hack to prevent trilinear from being set on voodoo,
	// because their driver freaks...
	if ( i == 5 && glConfig.hardwareType == GLHW_3DFX_2D3D ) {
		ri.Printf( PRINT_ALL, "Refusing to set trilinear on a voodoo.\n" );
		i = 3;
	}


	if ( i == 6 ) {
		ri.Printf (PRINT_ALL, "bad filter name\n");
		return;
	}

	gl_filter_min = modes[i].minimize;
	gl_filter_max = modes[i].maximize;

	// change all the existing mipmap texture objects
	for ( i = 0 ; i < tr.numImages ; i++ ) {
		glt = tr.images[ i ];
		if ( glt->mipmap ) {
			GL_Bind (glt);
			qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, gl_filter_min);
			qglTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, gl_filter_max);
		}
	}
*/
}

/*
===============
R_SumOfUsedImages
===============
*/
int R_SumOfUsedImages( void )
{
	int	total;
	int i;

	total = 0;
	for ( i = 0; i < tr.numImages; i++ )
	{
		if ( tr.images[i]->frameUsed == tr.frameCount )
		{
			total += tr.images[i]->uploadWidth * tr.images[i]->uploadHeight;
		}
	}

	return total;
}

/*
===============
R_ImageList_f
===============
*/
void R_ImageList_f( void )
{
	int		i;
	image_t	*image;
	int		texels;
	int     pixels;

	const char *yesno[] =
	{
		"no ", "yes"
	};

	ri.Printf (PRINT_ALL, "\n      -w-- -h-- -mm- -TMU- -if-- wrap --name-------\n");
	texels = 0;
	pixels = 0;

	for ( i = 0 ; i < tr.numImages ; i++ )
	{
		image = tr.images[ i ];
	
		texels += image->uploadWidth*image->uploadHeight;
   		ri.Printf (PRINT_ALL,  "%4i: %4i %4i  %s   %d   ",
			i, image->uploadWidth, image->uploadHeight, yesno[image->mipmap], image->TMU );
		switch ( image->format )
		{
		case GU_PSM_8888:
			ri.Printf( PRINT_ALL, "GU_PSM_8888 " );
            pixels += image->uploadWidth*image->uploadHeight * 4;
			break;
		case GU_PSM_T32:
			ri.Printf( PRINT_ALL, "GU_PSM_T32 " );
            pixels += image->uploadWidth*image->uploadHeight * 4;
			break;
        case GU_PSM_5650:
            ri.Printf( PRINT_ALL, "GU_PSM_5650 " );
            pixels += image->uploadWidth*image->uploadHeight * 2;
			break;
	    case GU_PSM_5551:
            ri.Printf( PRINT_ALL, "GU_PSM_5551 " );
            pixels += image->uploadWidth*image->uploadHeight * 2;
			break;
		case GU_PSM_4444:
            ri.Printf( PRINT_ALL, "GU_PSM_4444 " );
            pixels += image->uploadWidth*image->uploadHeight * 2;
			break;
		case GU_PSM_T16:
            ri.Printf( PRINT_ALL, "GU_PSM_T16 " );
            pixels += image->uploadWidth*image->uploadHeight * 2;
			break;
		case GU_PSM_T8:
            ri.Printf( PRINT_ALL, "GU_PSM_T8 " );
            pixels += image->uploadWidth*image->uploadHeight;
			break;
        case GU_PSM_DXT5:
			ri.Printf( PRINT_ALL, "GU_PSM_DXT5 " );
            pixels += image->uploadWidth*image->uploadHeight;
			break;
        case GU_PSM_DXT3:
			ri.Printf( PRINT_ALL, "GU_PSM_DXT3 " );
            pixels += image->uploadWidth*image->uploadHeight;
			break;
		case GU_PSM_DXT1:
			ri.Printf( PRINT_ALL, "GU_PSM_DXT1 " );
            pixels += image->uploadWidth*image->uploadHeight / 2;
			break;
		default:
			ri.Printf( PRINT_ALL, "???? " );
			break;
		}

		switch ( image->wrapClampMode )
		{
		case GU_REPEAT:
			ri.Printf( PRINT_ALL, "rept " );
			break;
		case GU_CLAMP:
			ri.Printf( PRINT_ALL, "clmp " );
			break;
		default:
			ri.Printf( PRINT_ALL, "%4i ", image->wrapClampMode );
			break;
		}
		
		ri.Printf( PRINT_ALL, " %s\n", image->imgName );
	}
	ri.Printf (PRINT_ALL,   " ---------\n");
	ri.Printf (PRINT_ALL,   " %i total texels (not including mipmaps)\n",   texels);
    ri.Printf (PRINT_ALL,   " %i total pixels (not including mipmaps)\n",   pixels);
    ri.Printf (PRINT_ALL,   " %i total pixels (with mipmaps)\n",        alltexsize);
	ri.Printf (PRINT_ALL,   " %i total images\n\n",                  tr.numImages );
}

//=======================================================================

/*
================
ResampleTexture

Used to resample images in a more general than quartering fashion.

This will only be filtered properly if the resampled size
is greater than half the original size.

If a larger shrinking is needed, use the mipmap function 
before or after.
================
*/
static void ResampleTexture( unsigned *in, int inwidth, int inheight, unsigned *out,  
							int outwidth, int outheight )
							{
	int		i, j;
	unsigned	*inrow, *inrow2;
	unsigned	frac, fracstep;
	unsigned	p1[2048], p2[2048];
	byte		*pix1, *pix2, *pix3, *pix4;

	if (outwidth>2048)
		ri.Error(ERR_DROP, "ResampleTexture: max width");
								
	fracstep = inwidth*0x10000/outwidth;

	frac = fracstep>>2;
	for ( i=0 ; i<outwidth ; i++ )
	{
		p1[i] = 4*(frac>>16);
		frac += fracstep;
	}
	frac = 3*(fracstep>>2);
	for ( i=0 ; i<outwidth ; i++ )
	{
		p2[i] = 4*(frac>>16);
		frac += fracstep;
	}

	for (i=0 ; i<outheight ; i++, out += outwidth)
	{
		inrow = in + inwidth*(int)((i+0.25)*inheight/outheight);
		inrow2 = in + inwidth*(int)((i+0.75)*inheight/outheight);
		frac = fracstep >> 1;
		for (j=0 ; j<outwidth ; j++)
		{
			pix1 = (byte *)inrow + p1[j];
			pix2 = (byte *)inrow + p2[j];
			pix3 = (byte *)inrow2 + p1[j];
			pix4 = (byte *)inrow2 + p2[j];
			((byte *)(out+j))[0] = (pix1[0] + pix2[0] + pix3[0] + pix4[0])>>2;
			((byte *)(out+j))[1] = (pix1[1] + pix2[1] + pix3[1] + pix4[1])>>2;
			((byte *)(out+j))[2] = (pix1[2] + pix2[2] + pix3[2] + pix4[2])>>2;
			((byte *)(out+j))[3] = (pix1[3] + pix2[3] + pix3[3] + pix4[3])>>2;
		}
	}
}

static void ResampleTexture8(const byte *in, int inwidth, int inheight, unsigned char *out,  int outwidth, int outheight)
{
	const unsigned int fracstep = inwidth * 0x10000 / outwidth;
	for (int i = 0; i < outheight ; ++i, out += outwidth)
	{
		const byte*		inrow	= in + inwidth * (int)(i * inheight / outheight);
		unsigned int	frac	= fracstep >> 1;
		for (int j = 0; j < outwidth; ++j, frac += fracstep)
		{
			out[j] = inrow[frac >> 16];
		}
	}
}

static void swizzle_fast(u8* out, const u8* in, unsigned int width, unsigned int height)
{
	unsigned int blockx, blocky;
	unsigned int j;

	unsigned int width_blocks = (width / 16);
	unsigned int height_blocks = (height / 8);

	unsigned int src_pitch = ((width)-16)/4;
	unsigned int src_row = (width) * 8;

	const u8* ysrc = in;
	u32* dst = (u32*)out;

	for (blocky = 0; blocky < height_blocks; ++blocky)
	{
		const u8* xsrc = ysrc;
		for (blockx = 0; blockx < width_blocks; ++blockx)
		{
			const u32* src = (u32*)xsrc;
			for (j = 0; j < 8; ++j)
			{
				*(dst++) = *(src++);
				*(dst++) = *(src++);
				*(dst++) = *(src++);
				*(dst++) = *(src++);
				src += src_pitch;
			}
			xsrc += 16;
		}
		ysrc += src_row;
	}
}

/*
================
R_LightScaleTexture

Scale up the pixel values in a texture to increase the
lighting range
================
*/
void R_LightScaleTexture (unsigned *in, int inwidth, int inheight, qboolean only_gamma )
{
	if ( only_gamma )
	{
		if ( !glConfig.deviceSupportsGamma )
		{
			int		i, c;
			byte	*p;

			p = (byte *)in;

			c = inwidth*inheight;
			for (i=0 ; i<c ; i++, p+=4)
			{
				p[0] = s_gammatable[p[0]];
				p[1] = s_gammatable[p[1]];
				p[2] = s_gammatable[p[2]];
			}
		}
	}
	else
	{
		int		i, c;
		byte	*p;

		p = (byte *)in;

		c = inwidth*inheight;

		if ( glConfig.deviceSupportsGamma )
		{
			for (i=0 ; i<c ; i++, p+=4)
			{
				p[0] = s_intensitytable[p[0]];
				p[1] = s_intensitytable[p[1]];
				p[2] = s_intensitytable[p[2]];
			}
		}
		else
		{
			for (i=0 ; i<c ; i++, p+=4)
			{
				p[0] = s_gammatable[s_intensitytable[p[0]]];
				p[1] = s_gammatable[s_intensitytable[p[1]]];
				p[2] = s_gammatable[s_intensitytable[p[2]]];
			}
		}
	}
}


/*
================
R_MipMap2

Operates in place, quartering the size of the texture
Proper linear filter
================
*/
static void R_MipMap2( unsigned *in, int inWidth, int inHeight, int outWidth, int outHeight)
{
	int			i, j, k;
	byte		*outpix;
	int			inWidthMask, inHeightMask;
	int			total;
	//int			outWidth, outHeight;
	unsigned	*temp;

	//outWidth = inWidth >> 1;
	//outHeight = inHeight >> 1;
	temp = (unsigned*)ri.Hunk_AllocateTempMemory( outWidth * outHeight * 4 );

	inWidthMask = inWidth - 1;
	inHeightMask = inHeight - 1;

	for ( i = 0 ; i < outHeight ; i++ ) {
		for ( j = 0 ; j < outWidth ; j++ ) {
			outpix = (byte *) ( temp + i * outWidth + j );
			for ( k = 0 ; k < 4 ; k++ ) {
				total = 
					1 * ((byte *)&in[ ((i*2-1)&inHeightMask)*inWidth + ((j*2-1)&inWidthMask) ])[k] +
					2 * ((byte *)&in[ ((i*2-1)&inHeightMask)*inWidth + ((j*2)&inWidthMask) ])[k] +
					2 * ((byte *)&in[ ((i*2-1)&inHeightMask)*inWidth + ((j*2+1)&inWidthMask) ])[k] +
					1 * ((byte *)&in[ ((i*2-1)&inHeightMask)*inWidth + ((j*2+2)&inWidthMask) ])[k] +

					2 * ((byte *)&in[ ((i*2)&inHeightMask)*inWidth + ((j*2-1)&inWidthMask) ])[k] +
					4 * ((byte *)&in[ ((i*2)&inHeightMask)*inWidth + ((j*2)&inWidthMask) ])[k] +
					4 * ((byte *)&in[ ((i*2)&inHeightMask)*inWidth + ((j*2+1)&inWidthMask) ])[k] +
					2 * ((byte *)&in[ ((i*2)&inHeightMask)*inWidth + ((j*2+2)&inWidthMask) ])[k] +

					2 * ((byte *)&in[ ((i*2+1)&inHeightMask)*inWidth + ((j*2-1)&inWidthMask) ])[k] +
					4 * ((byte *)&in[ ((i*2+1)&inHeightMask)*inWidth + ((j*2)&inWidthMask) ])[k] +
					4 * ((byte *)&in[ ((i*2+1)&inHeightMask)*inWidth + ((j*2+1)&inWidthMask) ])[k] +
					2 * ((byte *)&in[ ((i*2+1)&inHeightMask)*inWidth + ((j*2+2)&inWidthMask) ])[k] +

					1 * ((byte *)&in[ ((i*2+2)&inHeightMask)*inWidth + ((j*2-1)&inWidthMask) ])[k] +
					2 * ((byte *)&in[ ((i*2+2)&inHeightMask)*inWidth + ((j*2)&inWidthMask) ])[k] +
					2 * ((byte *)&in[ ((i*2+2)&inHeightMask)*inWidth + ((j*2+1)&inWidthMask) ])[k] +
					1 * ((byte *)&in[ ((i*2+2)&inHeightMask)*inWidth + ((j*2+2)&inWidthMask) ])[k];
				outpix[k] = total / 36;
			}
		}
	}

	Com_Memcpy( in, temp, outWidth * outHeight * 4 );
	ri.Hunk_FreeTempMemory( temp );
}

/*
================
R_MipMap

Operates in place, quartering the size of the texture
================
*/
static void R_MipMap (byte *in, int width, int height, int outWidth, int outHeight)
{
	int		i, j;
	byte	*out;
	int		row;

	if ( !r_simpleMipMaps->integer )
	{
		R_MipMap2( (unsigned *)in, width, height, outWidth, outHeight );
		return;
	}

	if ( width == 1 && height == 1 )
	{
		return;
	}

	row = width * 4;
	out = in;

	width  = outWidth;  //>>= 1;
	height = outHeight; // >>= 1;

	if ( width == 0 || height == 0 ) {
		width += height;	// get largest
		for (i=0 ; i<width ; i++, out+=4, in+=8 ) {
			out[0] = ( in[0] + in[4] )>>1;
			out[1] = ( in[1] + in[5] )>>1;
			out[2] = ( in[2] + in[6] )>>1;
			out[3] = ( in[3] + in[7] )>>1;
		}
		return;
	}

	for (i=0 ; i<height ; i++, in+=row) {
		for (j=0 ; j<width ; j++, out+=4, in+=8) {
			out[0] = (in[0] + in[4] + in[row+0] + in[row+4])>>2;
			out[1] = (in[1] + in[5] + in[row+1] + in[row+5])>>2;
			out[2] = (in[2] + in[6] + in[row+2] + in[row+6])>>2;
			out[3] = (in[3] + in[7] + in[row+3] + in[row+7])>>2;
		}
	}
}


/*
==================
R_BlendOverTexture

Apply a color blend over a set of pixels
==================
*/
static void R_BlendOverTexture( byte *data, int pixelCount, byte blend[4] )
{
	int		i;
	int		inverseAlpha;
	int		premult[3];

	inverseAlpha = 255 - blend[3];
	premult[0] = blend[0] * blend[3];
	premult[1] = blend[1] * blend[3];
	premult[2] = blend[2] * blend[3];

	for ( i = 0 ; i < pixelCount ; i++, data+=4 ) {
		data[0] = ( data[0] * inverseAlpha + premult[0] ) >> 9;
		data[1] = ( data[1] * inverseAlpha + premult[1] ) >> 9;
		data[2] = ( data[2] * inverseAlpha + premult[2] ) >> 9;
	}
}

byte	mipBlendColors[16][4] =
{
	{0,0,0,0},
	{255,0,0,128},
	{0,255,0,128},
	{0,0,255,128},
	{255,0,0,128},
	{0,255,0,128},
	{0,0,255,128},
	{255,0,0,128},
	{0,255,0,128},
	{0,0,255,128},
	{255,0,0,128},
	{0,255,0,128},
	{0,0,255,128},
	{255,0,0,128},
	{0,255,0,128},
	{0,0,255,128},
};

/*
=======================================
TextureConvector

From DE2 by Christoph Arnold "charnold"
modify by Crow_bar
=======================================
*/
void TextureConvector(unsigned char *in32, unsigned char *out16, int w, int h, int format)
{
	switch(format)
	{
	 case GU_PSM_4444:
		for(int i = 0; i < w * h ; i++)
		{
            *(out16)    = (*in32>>4) & 0x0f; in32++; // r
			*(out16++) |= (*in32)    & 0xf0; in32++; // g
			*(out16)    = (*in32>>4) & 0x0f; in32++; // b
			*(out16++) |= (*in32)    & 0xf0; in32++; // a
		}
		break;
	 case GU_PSM_5650:
        for(int i = 0; i < w * h ; i++)
		{
       		unsigned char r,g,b;

			r = (*in32>>3) & 0x1f; in32++;	// r = 5 bit
			g = (*in32>>2) & 0x3f; in32++;	// g = 6 bit
			b = (*in32>>3) & 0x1f; in32++;	// b = 5 bit
								   in32++;	// a = 0 bit

			*(out16)	= r;				// alle   5 bits von r auf lower  5 bits von out16
			*(out16++) |= (g<<5) & 0xe0;	// lower  3 bits von g auf higher 3 bits von out16
			*(out16)	= (g>>3) & 0x07;	// higher 3 bits von g auf lower  3 bits von out16
			*(out16++) |= (b<<3) & 0xf8;    // alle   5 bits von b auf higher 5 bits von out16
		}
		break;
	 case GU_PSM_5551:
	    for(int i = 0; i < w * h ; i++)
		{
            unsigned char r,g,b,a;

			r = (*in32>>3) & 0x1f; in32++;	// r = 5 bit
			g = (*in32>>3) & 0x1f; in32++;	// g = 5 bit
			b = (*in32>>3) & 0x1f; in32++;	// b = 5 bit
			a = (*in32>>7) & 0x01; in32++;	// a = 1 bit

			*(out16)	= r;				// alle   5 bits von r auf lower  5 bits von out16
			*(out16++) |= (g<<5) & 0xe0;	// lower  3 bits von g auf higher 3 bits von out16
			*(out16)	= (g>>3) & 0x03;	// higher 2 bits von g auf lower  2 bits von out16
			*(out16)   |= (b<<2) & 0x7c;    // alle   5 bits von b auf bits 3-7      von out16
			*(out16++) |= (a<<7) & 0x80;    //        1 bit  von a auf bit    8      von out16
	    }
	    break;
	  default:
		Sys_Error("TextureConvector: format not 16bpp\n");
		break; //if Sys_Error will be continue while!
	}
}

void GL_Upload8(int texnum, const byte *data, int width, int height)
{
    image_t		*image = tr.images[texnum];

	// Check that the texture matches.
	if ((width != image->width) != (height != image->height))
	{
		ri.Error (ERR_DROP, "Attempting to upload a texture which doesn't match the destination");
	}

	// Create a temporary buffer to use as a source for swizzling.
	std::size_t buffer_sizesrc = image->uploadWidth * image->uploadHeight * 4;
	std::vector<byte> unswizzled(buffer_sizesrc);

	std::size_t buffer_sizedst = image->uploadWidth * image->uploadHeight;
	std::vector<byte> bpp(buffer_sizedst);

    if (image->stretch_to_power_of_two)
	{
		ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&unswizzled[0], image->uploadWidth, image->uploadHeight);
	}
	else
	{
		// Straight copy.
		for (int y = 0; y < height; ++y)
		{
			const byte* const	src	= data + (y * width * 4);
			byte* const			dst = &unswizzled[y * image->uploadWidth * 4];
#ifdef FAST_MEMCPY

		    #ifdef FULL_FLUSH
			    sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
			    sceKernelDcacheWritebackInvalidateRange(src, width * 4);
	        #else
                sceKernelDcacheWritebackRange(dst, width * 4);
                sceKernelDcacheWritebackRange(src, width * 4);
            #endif
            
		    sceDmacMemcpy(dst, src, width * 4); //fast memcpy

            #ifdef FULL_FLUSH
	            sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
            #else
			    sceKernelDcacheWritebackRange(dst, width * 4);
            #endif
#else
			memcpy(dst, src, width * 4);
#endif
		}
	}

    R_LightScaleTexture ((unsigned*)&unswizzled[0], image->uploadWidth, image->uploadHeight, image->mipmap ? qfalse : qtrue );

	//32 -> 8
	for(int i = 0 ; i < image->uploadWidth * image->uploadHeight ; i++)
	{
      bpp[i+0] = unswizzled[i*4+0];
      bpp[i+1] = unswizzled[i*4+1];
      bpp[i+2] = unswizzled[i*4+2];
      bpp[i+3] = unswizzled[i*4+3];
	}
/*
	for(int i = 0 ; i < 256 ; i++)
	{
	  unsigned int r = unswizzled[..];
	  unsigned int g = unswizzled[..];
	  unsigned int b = unswizzled[..];
	  image->pallete[i] = GU_RGBA(r, g, b, 255);
	}
 	image->use_pallete = 1;
*/
	unswizzled.clear();
    // Swizzle to system RAM.
    swizzle_fast(image->ram, &bpp[0], image->uploadWidth, image->uploadHeight);
    bpp.clear();

  	// Copy to VRAM?
	if (image->vram)
	{
		// Copy.
#ifdef FAST_MEMCPY
	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_sizedst);
		    sceKernelDcacheWritebackInvalidateRange(image->ram,  buffer_sizedst);
	#else
			sceKernelDcacheWritebackRange(image->vram, buffer_sizedst);
			sceKernelDcacheWritebackRange(image->ram,  buffer_sizedst);
	#endif
	
	    sceDmacMemcpy(image->vram, image->ram, buffer_sizedst); //fast memcpy

#else
		memcpy(image->vram, image->ram, buffer_sizedst);
#endif
		// Flush the data cache.
	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_sizedst);
	#else
			sceKernelDcacheWritebackRange(image->vram, buffer_sizedst);
	#endif
	}

	// Flush the data cache.
#ifdef FULL_FLUSH
	sceKernelDcacheWritebackInvalidateRange(image->ram, buffer_sizedst);
#else
	sceKernelDcacheWritebackRange(image->ram, buffer_sizedst);
#endif
}

void GL_Upload16(int texnum, const byte *data, int width, int height)
{
    image_t		*image = tr.images[texnum];

	// Check that the texture matches.
	if ((width != image->width) != (height != image->height))
	{
		ri.Error (ERR_DROP, "Attempting to upload a texture which doesn't match the destination");
	}

	// Create a temporary buffer to use as a source for swizzling.
	std::size_t buffer_sizesrc = image->uploadWidth * image->uploadHeight * 4;
	std::vector<byte> unswizzled(buffer_sizesrc);
  
	std::size_t buffer_sizedst = image->uploadWidth * image->uploadHeight * 2;
	std::vector<byte> bpp(buffer_sizedst);

    if (image->mipmaps > 0)
	{
		int size_incr = buffer_sizedst/4;
		for (int i= 1;i <= image->mipmaps;i++)
		{
			buffer_sizedst += size_incr;
			size_incr = size_incr/4;
		}
	}

    if (image->stretch_to_power_of_two)
	{
		ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&unswizzled[0], image->uploadWidth, image->uploadHeight);
	}
	else
	{
		// Straight copy.
		for (int y = 0; y < height; ++y)
		{
			const byte* const	src	= data + (y * width * 4);
			byte* const			dst = &unswizzled[y * image->uploadWidth * 4];
#ifdef FAST_MEMCPY

		    #ifdef FULL_FLUSH
			    sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
			    sceKernelDcacheWritebackInvalidateRange(src, width * 4);
	        #else
                sceKernelDcacheWritebackRange(dst, width * 4);
                sceKernelDcacheWritebackRange(src, width * 4);
            #endif

		    sceDmacMemcpy(dst, src, width * 4); //fast memcpy

            #ifdef FULL_FLUSH
	            sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
            #else
			    sceKernelDcacheWritebackRange(dst, width * 4);
            #endif
#else
			memcpy(dst, src, width * 4);
#endif
		}
	}

    R_LightScaleTexture ((unsigned*)&unswizzled[0], image->uploadWidth, image->uploadHeight, image->mipmap ? qfalse : qtrue );

	//32 -> 16
    TextureConvector((unsigned char*)&unswizzled[0],
	                 (unsigned char*)&bpp[0],
					 image->uploadWidth, image->uploadHeight,
					 image->format);
	
	// Swizzle to system RAM.
    swizzle_fast(image->ram, &bpp[0], image->uploadWidth*2, image->uploadHeight);

    if (image->mipmaps > 0)
	{
		int size = (image->uploadWidth * image->uploadHeight * 2);
		int offset = size;
		int div = 2;

		for (int i = 1; i <= image->mipmaps;i++)
		{
			ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&unswizzled[0], image->uploadWidth/div, image->uploadHeight/div);
/*
			R_MipMap( (byte*)data, image->width, image->height,
			image->uploadWidth/div, image->uploadHeight/div);
*/
			TextureConvector((unsigned char*)&unswizzled[0],
	                         (unsigned char*)&bpp[0],
					          image->uploadWidth, image->uploadHeight,
					          image->format);

			swizzle_fast(image->ram+offset, &bpp[0], (image->uploadWidth/div) * 2, image->uploadHeight/div);
			offset += size/(div*div);
			div *=2;
		}
	}

    bpp.clear();
    unswizzled.clear();
    
  	// Copy to VRAM?
	if (image->vram)
	{
		// Copy.
#ifdef FAST_MEMCPY

	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_sizedst);
		    sceKernelDcacheWritebackInvalidateRange(image->ram,  buffer_sizedst);
	#else
			sceKernelDcacheWritebackRange(image->vram, buffer_sizedst);
			sceKernelDcacheWritebackRange(image->ram,  buffer_sizedst);
	#endif
        sceDmacMemcpy(image->vram, image->ram, buffer_sizedst);

#else
		memcpy(image->vram, image->ram, buffer_sizedst);
#endif
		// Flush the data cache.
	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_sizedst);
	#else
			sceKernelDcacheWritebackRange(image->vram, buffer_sizedst);
	#endif
	}

	// Flush the data cache.
#ifdef FULL_FLUSH
	sceKernelDcacheWritebackInvalidateRange(image->ram, buffer_sizedst);
#else
	sceKernelDcacheWritebackRange(image->ram, buffer_sizedst);
#endif
}

void GL_Upload32(int texnum, const byte *data, int width, int height)
{
    image_t		*image = tr.images[texnum];

	// Check that the texture matches.
	if ((width != image->width) != (height != image->height))
	{
		ri.Error (ERR_DROP, "Attempting to upload a texture which doesn't match the destination");
	}

	// Create a temporary buffer to use as a source for swizzling.
	std::size_t buffer_size = image->uploadWidth * image->uploadHeight * 4;
	std::vector<byte> unswizzled(buffer_size);

    if (image->mipmaps > 0)
	{
		int size_incr = buffer_size/4;
		for (int i= 1;i <= image->mipmaps;i++)
		{
			buffer_size += size_incr;
			size_incr = size_incr/4;
		}
	}

	if (image->stretch_to_power_of_two)
	{
		ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&unswizzled[0], image->uploadWidth, image->uploadHeight);
	}
	else
	{
		// Straight copy.
		for (int y = 0; y < height; ++y)
		{
			const byte* const	src	= data + (y * width * 4);
			byte* const			dst = &unswizzled[y * image->uploadWidth * 4];
#ifdef FAST_MEMCPY

		    #ifdef FULL_FLUSH
			    sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
			    sceKernelDcacheWritebackInvalidateRange(src, width * 4);
	        #else
                sceKernelDcacheWritebackRange(dst, width * 4);
                sceKernelDcacheWritebackRange(src, width * 4);
            #endif

		    sceDmacMemcpy(dst, src, width * 4); //fast memcpy

            #ifdef FULL_FLUSH
	            sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
            #else
			    sceKernelDcacheWritebackRange(dst, width * 4);
            #endif
#else
			memcpy(dst, src, width * 4);
#endif
		}
	}

	R_LightScaleTexture ((unsigned*)&unswizzled[0], image->uploadWidth, image->uploadHeight, image->mipmap ? qfalse : qtrue );
    
	// Swizzle to system RAM.
	swizzle_fast(image->ram, &unswizzled[0], image->uploadWidth * 4, image->uploadHeight);
	
    if (image->mipmaps > 0)
	{
		int size = (image->uploadWidth * image->uploadHeight * 4);
		int offset = size;
		int div = 2;

		for (int i = 1; i <= image->mipmaps;i++)
		{
			ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&unswizzled[0], image->uploadWidth/div, image->uploadHeight/div);
			//R_MipMap( (byte *)&unswizzled[0], image->uploadWidth/div, image->uploadHeight/div);
			swizzle_fast(image->ram+offset, &unswizzled[0], (image->uploadWidth/div) * 4, image->uploadHeight/div);
			offset += size/(div*div);
			div *=2;
		}
	}

    unswizzled.clear();

	// Copy to VRAM?
	if (image->vram)
	{
		// Copy.
#ifdef FAST_MEMCPY

	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_size);
		    sceKernelDcacheWritebackInvalidateRange(image->ram,  buffer_size);
	#else
		    sceKernelDcacheWritebackRange(image->vram, buffer_size);
		    sceKernelDcacheWritebackRange(image->ram,  buffer_size);
	#endif
	    sceDmacMemcpy(image->vram, image->ram, buffer_size);

#else
		memcpy(image->vram, image->ram, buffer_size);
#endif
	    // Flush the data cache.
	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_size);
	#else
		    sceKernelDcacheWritebackRange(image->vram, buffer_size);
	#endif
	}

	// Flush the data cache.
#ifdef FULL_FLUSH
	sceKernelDcacheWritebackInvalidateRange(image->ram, buffer_size);
#else
	sceKernelDcacheWritebackRange(image->ram, buffer_size);
#endif
}

void GL_UploadDXT(int texnum, const byte *data, int width, int height)
{
    image_t		*image = tr.images[texnum];
	// Check that the texture matches.
	if ((width != image->width) != (height != image->height))
	{
		ri.Error (ERR_DROP, "Attempting to upload a texture which doesn't match the destination");
	}

	// Create a temporary buffer to use as a source for swizzling.
	// Original texture buffer
	std::size_t buffer_sizesrc = image->uploadWidth * image->uploadHeight * 4;
    std::vector<byte> unswizzled(buffer_sizesrc);
    
	// New compressed texture
	std::size_t buffer_sizedst = 0;
    switch (image->format)
	{
     case GU_PSM_DXT5:
	 case GU_PSM_DXT3:
	  buffer_sizedst = image->uploadWidth * image->uploadHeight;
	  break;
     case GU_PSM_DXT1:
	  buffer_sizedst = image->uploadWidth * image->uploadHeight /  2;
	  break;
	}

	if (image->mipmaps > 0)
	{
        int size_incr = buffer_sizedst/4;
		for (int i= 1;i <= image->mipmaps;i++)
		{
			buffer_sizedst += size_incr;
			size_incr = size_incr/4;
		}
	}
	
    if (image->stretch_to_power_of_two)
	{
		ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&unswizzled[0], image->uploadWidth, image->uploadHeight);
	}
	else
	{
        // Straight copy.
		for (int y = 0; y < height; ++y)
		{
			const byte* const	src	= data + (y * width * 4);
			byte* const			dst = &unswizzled[y * image->uploadWidth * 4];
#ifdef FAST_MEMCPY

		    #ifdef FULL_FLUSH
			    sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
			    sceKernelDcacheWritebackInvalidateRange(src, width * 4);
	        #else
                sceKernelDcacheWritebackRange(dst, width * 4);
                sceKernelDcacheWritebackRange(src, width * 4);
            #endif

		    sceDmacMemcpy(dst, src, width * 4); //fast memcpy

            #ifdef FULL_FLUSH
	            sceKernelDcacheWritebackInvalidateRange(dst, width * 4);
            #else
			    sceKernelDcacheWritebackRange(dst, width * 4);
            #endif
#else
			memcpy(dst, src, width * 4);
#endif
		}
	}

    R_LightScaleTexture ((unsigned*)&unswizzled[0], image->uploadWidth, image->uploadHeight, image->mipmap ? qfalse : qtrue );

	// Compressed to system RAM.
	tx_compress_dxtn(4, image->uploadWidth, image->uploadHeight,(const unsigned char *)&unswizzled[0], image->format, (unsigned char *)image->ram);

	unswizzled.clear();
	

	if (image->mipmaps > 0)
	{
        int size = 0;

	    switch (image->format)
		{
		     case GU_PSM_DXT5:
			 case GU_PSM_DXT3:
				  size = image->uploadWidth * image->uploadHeight;
				  break;
			 case GU_PSM_DXT1:
				  size = image->uploadWidth * image->uploadHeight /  2;
				  break;
		}

		int offset = size;
		int div = 2;

		for (int i = 1; i <= image->mipmaps;i++)
		{

		   std::vector<byte> temp_mip((image->uploadWidth/div) * (image->uploadHeight/div) * (4));

		   ResampleTexture((unsigned int*)data, image->width, image->height, (unsigned int*)&temp_mip[0], image->uploadWidth/div, image->uploadHeight/div);

		   tx_compress_dxtn(4, image->uploadWidth/div, image->uploadHeight/div,(const unsigned char *)&temp_mip[0], image->format, (unsigned char *)image->ram+offset);

		   offset += size/(div*div);

		   div *=2;

		   temp_mip.clear();
		}
	}
    
	// Copy to VRAM?
	if (image->vram)
	{
		// Copy.
#ifdef FAST_MEMCPY

	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_sizedst);
		    sceKernelDcacheWritebackInvalidateRange(image->ram,  buffer_sizedst);
	#else
		    sceKernelDcacheWritebackRange(image->vram, buffer_sizedst);
		    sceKernelDcacheWritebackRange(image->ram,  buffer_sizedst);
	#endif
        sceDmacMemcpy(image->vram, image->ram, buffer_sizedst);

#else
		memcpy(image->vram, image->ram, buffer_sizedst);
#endif
		// Flush the data cache.
	#ifdef FULL_FLUSH
		    sceKernelDcacheWritebackInvalidateRange(image->vram, buffer_sizedst);
	#else
		    sceKernelDcacheWritebackRange(image->vram, buffer_sizedst);
	#endif
	}

	// Flush the data cache.
#ifdef FULL_FLUSH
	    sceKernelDcacheWritebackInvalidateRange(image->ram, buffer_sizedst);
#else
	    sceKernelDcacheWritebackRange(image->ram, buffer_sizedst);
#endif
}

static std::size_t round_up(std::size_t size)
{
	static const float	denom	= 1.0f / logf(2.0f);
	const float			logged	= logf(size) * denom;
	const float			ceiling	= ceilf(logged);
	return 1 << static_cast<int>(ceiling);
}

static std::size_t round_down(std::size_t size)
{
	static const float	denom	= 1.0f / logf(2.0f);
	const float			logged	= logf(size) * denom;
	const float			floor	= floorf(logged);
	return 1 << static_cast<int>(floor);
}

/*
================
HACK for Level shots
Crow_bar
================
*/
int IS_LS(const char *name)
{
  if((name[0] == 'l') && 
     (name[1] == 'e') &&
     (name[2] == 'v') &&
     (name[3] == 'e') &&
     (name[4] == 'l') &&
     (name[5] == 's') &&
     (name[6] == 'h') &&
     (name[7] == 'o') &&
     (name[8] == 't') &&
     (name[9] == 's'))
  { 
     return r_levelShotsSize->integer;
  }

   return 0;
} 

/*
================
R_CreateImage

This is the only way any image_t are created

Crow_bar 2009(c).
Based on PSP Quake 1 by
Peter Mackay and Chris Swindle.
================
*/

image_t *R_CreateImage( const char *name, const byte *pic, int width, int height, 
					   qboolean mipmap, qboolean allowPicmip, int glWrapClampMode )
					   {
	image_t		*image;
	qboolean	isUpdate = qfalse;
	long		hash;
	int         texindex = -1;
	int         mipmap_level = r_mipmaps->integer;

	if (strlen(name) >= MAX_QPATH )
	{
		ri.Error (ERR_DROP, "R_CreateImage: \"%s\" is too long\n", name);
	}

    if (!strncmp( name, "*updtex", 7 ))
	{
		isUpdate = qtrue;
	}

	// See if the texture is already present.
	if (name[0])
	{
		for (int i = 0; i < MAX_DRAWIMAGES; ++i)
		{
            if (texused[i] == qtrue)
			{
				if (!strcmp (name, tr.images[i]->imgName))
				{
					if(isUpdate == qfalse)
					{
					   return tr.images[i];
					}
					else
					{
					   texindex = i;
					   break;
				    }
				}
			}
		}
	}

    if (isUpdate == qfalse || texindex == -1)
	{
		tr.numImages++;
	    texindex = tr.numImages;

		if ( tr.numImages == MAX_DRAWIMAGES )
		{
			ri.Error( ERR_DROP, "R_CreateImage: MAX_DRAWIMAGES hit\n");
		}

		for (int i = 0; i < MAX_DRAWIMAGES; ++i)
		{
			if (texused[i] == qfalse)
			{
				texindex = i;
				break;
			}
		}
	
		image = tr.images[texindex] = (image_t*)ri.Hunk_Alloc( sizeof( image_t ), h_low );
		texused[texindex] = qtrue;
		image->texnum = texindex;
		strcpy (image->imgName, name);

        if(!isUpdate)
        {
		    switch (r_texturebits->integer)
			{
			 case 16:
	           image->format = GU_PSM_DXT1;
	           break;
	         case 24:
	           image->format = GU_PSM_DXT3;
	           break;
	         default:
	           image->format = GU_PSM_DXT5;
	           break;
			}
		}
		else
		{
            image->format = GU_PSM_4444; //8888
		}
#ifdef DEBUG_FAST
	    image->format = GU_PSM_4444;
#endif
	    image->mipmap = mipmap;
		image->allowPicmip = allowPicmip;

		if(r_mipmaps->integer && mipmap == qtrue)
		{
		  image->mipmaps = mipmap_level;
	    }
	    else
	    {
          image->mipmaps = 0;
	    }

		image->filter = GU_LINEAR;
		image->width  = width;
		image->height = height;
		image->wrapClampMode = glWrapClampMode;
		image->TMU    = 0;
	    image->stretch_to_power_of_two = qtrue;

		if (r_roundImagesDown->integer && image->stretch_to_power_of_two == true)
		{
			image->uploadWidth			= std::max(round_down(width), 32U);
			image->uploadHeight			= std::max(round_down(height),32U);
		}
		else
		{
			image->uploadWidth			= std::max(round_up(width), 32U);
			image->uploadHeight			= std::max(round_up(height),32U);
		}

	 	if (allowPicmip && r_picmip->integer)
		{
            int pic_width  = image->uploadWidth / (r_picmip->integer * 2);
		    int pic_height = image->uploadHeight / (r_picmip->integer * 2);
			image->uploadWidth  = std::max(round_down(pic_width), 16U);
			image->uploadHeight = std::max(round_down(pic_height),16U);
	    }
	    else if(int lss = IS_LS(name))
	    {
			if((image->uploadWidth > lss) && (image->uploadHeight > lss))
			{
		       image->uploadWidth  = lss;
			   image->uploadHeight = lss;
			}
		}

#ifdef DEBUG_FAST
        image->uploadWidth  = 16;
        image->uploadHeight = 16;
#endif
		if(image->mipmaps > 0)
	    {
			for (int i=0; i <= mipmap_level;i++)
			{
				int div = (int) powf(2,i);
				if ((image->uploadWidth / div) > 16 && (image->uploadHeight / div) > 16 )
				{
					image->mipmaps = i;
				}
			}
		}

		// Do we really need to resize the texture?
		if (image->stretch_to_power_of_two)
		{
			// Not if the size hasn't changed.
			if(image->uploadWidth != width || image->uploadHeight != height)
			    image->stretch_to_power_of_two = qtrue;
			else
	            image->stretch_to_power_of_two = qfalse;
		}

	    std::size_t buffer_size = 0;
		switch (image->format)
		{
	     case GU_PSM_T32:
	     case GU_PSM_8888:
	       buffer_size = image->uploadWidth * image->uploadHeight * 4;
	       image->swizzle = GU_TRUE;
		   break;
	     case GU_PSM_T16:
	     case GU_PSM_5650:
		 case GU_PSM_5551:
		 case GU_PSM_4444:
	       buffer_size = image->uploadWidth * image->uploadHeight * 2;
	       image->swizzle = GU_TRUE;
	       break;
         case GU_PSM_T8:
           buffer_size = image->uploadWidth * image->uploadHeight;
		   image->swizzle = GU_TRUE;
	     case GU_PSM_DXT5:
		 case GU_PSM_DXT3:
	       buffer_size = image->uploadWidth * image->uploadHeight;
		   image->swizzle = GU_FALSE;
		   break;
	     case GU_PSM_DXT1:
	       buffer_size = image->uploadWidth * image->uploadHeight / 2;
	       image->swizzle = GU_FALSE;
	       break;
		}

		if (image->mipmaps > 0)
		{
			int size_incr = buffer_size/4;
			for (int i = 1;i <= image->mipmaps;i++)
			{
				buffer_size += size_incr;
				size_incr = size_incr/4;
			}
		}

		ri.Printf(PRINT_DEVELOPER,"Load image: %s f:%dx%d %dB\n",name,image->uploadWidth,image->uploadHeight, buffer_size);

	    alltexsize += buffer_size; //check size

		image->ram	= static_cast<texel*>(memalign(16, buffer_size));

		if (!image->ram)
		{
			ri.Error (ERR_DROP, "Out of RAM for textures.");
		}
		image->vram = static_cast<texel*>(valloc(buffer_size));

	    switch (image->format)
		{
		  case GU_PSM_T32:
		  case GU_PSM_8888:
		    GL_Upload32(image->texnum, pic, image->width, image->height);
	        break;
	      case GU_PSM_T16:
	      case GU_PSM_5650:
		  case GU_PSM_5551:
		  case GU_PSM_4444:
	        GL_Upload16(image->texnum, pic, image->width, image->height);
	        break;
          case GU_PSM_T8:
            GL_Upload8(image->texnum, pic, image->width, image->height);
	        break;
		  case GU_PSM_DXT5:
		  case GU_PSM_DXT3:
		  case GU_PSM_DXT1:
	        GL_UploadDXT(image->texnum, pic, image->width, image->height);
	        break;
		 }

		if (image->vram && image->ram)
		{
			free(image->ram);
			image->ram = NULL;
		}

		hash = generateHashValue(name);
		image->next = hashTable[hash];
		hashTable[hash] = image;
	}
	else //for update tex(cinematic)
	{
        image = tr.images[texindex];

		if ((width == image->width) && (height == image->height))
		{

			switch (image->format)
			{
			  case GU_PSM_T32:
			  case GU_PSM_8888:
			    GL_Upload32(image->texnum, pic, image->width, image->height);
		        break;
		      case GU_PSM_T16:
		      case GU_PSM_5650:
			  case GU_PSM_5551:
			  case GU_PSM_4444:
		        GL_Upload16(image->texnum, pic, image->width, image->height);
		        break;
              case GU_PSM_T8:
                GL_Upload8(image->texnum, pic, image->width, image->height);
	            break;
			  case GU_PSM_DXT5:
			  case GU_PSM_DXT3:
			  case GU_PSM_DXT1:
		        GL_UploadDXT(image->texnum, pic, image->width, image->height);
		        break;
			 }
	  	}

		image->texnum = texindex;

		if (image->vram && image->ram)
		{
			free(image->ram);
			image->ram = NULL;
		}

	}
    
	return image;
}


/*
=========================================================

BMP LOADING

=========================================================
*/
typedef struct
{
	char id[2];
	unsigned long fileSize;
	unsigned long reserved0;
	unsigned long bitmapDataOffset;
	unsigned long bitmapHeaderSize;
	unsigned long width;
	unsigned long height;
	unsigned short planes;
	unsigned short bitsPerPixel;
	unsigned long compression;
	unsigned long bitmapDataSize;
	unsigned long hRes;
	unsigned long vRes;
	unsigned long colors;
	unsigned long importantColors;
	unsigned char palette[256][4];
} BMPHeader_t;

static void LoadBMP( const char *name, byte **pic, int *width, int *height )
{
	int		columns, rows, numPixels;
	byte	*pixbuf;
	int		row, column;
	byte	*buf_p;
	byte	*buffer;
	int		length;
	BMPHeader_t bmpHeader;
	byte		*bmpRGBA;

	*pic = NULL;

	//
	// load the file
	//
	length = ri.FS_ReadFile( ( char * ) name, (void **)&buffer);
	if (!buffer) {
		return;
	}

	buf_p = buffer;

	bmpHeader.id[0] = *buf_p++;
	bmpHeader.id[1] = *buf_p++;
	bmpHeader.fileSize = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.reserved0 = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.bitmapDataOffset = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.bitmapHeaderSize = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.width = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.height = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.planes = LittleShort( * ( short * ) buf_p );
	buf_p += 2;
	bmpHeader.bitsPerPixel = LittleShort( * ( short * ) buf_p );
	buf_p += 2;
	bmpHeader.compression = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.bitmapDataSize = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.hRes = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.vRes = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.colors = LittleLong( * ( long * ) buf_p );
	buf_p += 4;
	bmpHeader.importantColors = LittleLong( * ( long * ) buf_p );
	buf_p += 4;

	Com_Memcpy( bmpHeader.palette, buf_p, sizeof( bmpHeader.palette ) );

	if ( bmpHeader.bitsPerPixel == 8 )
		buf_p += 1024;

	if ( bmpHeader.id[0] != 'B' && bmpHeader.id[1] != 'M' ) 
	{
		ri.Error( ERR_DROP, "LoadBMP: only Windows-style BMP files supported (%s)\n", name );
	}
	if ( bmpHeader.fileSize != length )
	{
		ri.Error( ERR_DROP, "LoadBMP: header size does not match file size (%d vs. %d) (%s)\n", bmpHeader.fileSize, length, name );
	}
	if ( bmpHeader.compression != 0 )
	{
		ri.Error( ERR_DROP, "LoadBMP: only uncompressed BMP files supported (%s)\n", name );
	}
	if ( bmpHeader.bitsPerPixel < 8 )
	{
		ri.Error( ERR_DROP, "LoadBMP: monochrome and 4-bit BMP files not supported (%s)\n", name );
	}

	columns = bmpHeader.width;
	rows = bmpHeader.height;
	if ( rows < 0 )
		rows = -rows;
	numPixels = columns * rows;

	if ( width ) 
		*width = columns;
	if ( height )
		*height = rows;

	bmpRGBA = (byte*)ri.Malloc( numPixels * 4 );
	*pic = bmpRGBA;


	for ( row = rows-1; row >= 0; row-- )
	{
		pixbuf = bmpRGBA + row*columns*4;

		for ( column = 0; column < columns; column++ )
		{
			unsigned char red, green, blue, alpha;
			int palIndex;
			unsigned short shortPixel;

			switch ( bmpHeader.bitsPerPixel )
			{
			case 8:
				palIndex = *buf_p++;
				*pixbuf++ = bmpHeader.palette[palIndex][2];
				*pixbuf++ = bmpHeader.palette[palIndex][1];
				*pixbuf++ = bmpHeader.palette[palIndex][0];
				*pixbuf++ = 0xff;
				break;

			case 16:
				shortPixel = * ( unsigned short * ) pixbuf;
				pixbuf += 2;
				*pixbuf++ = ( shortPixel & ( 31 << 10 ) ) >> 7;
				*pixbuf++ = ( shortPixel & ( 31 << 5 ) ) >> 2;
				*pixbuf++ = ( shortPixel & ( 31 ) ) << 3;
				*pixbuf++ = 0xff;
				break;

			case 24:
				blue = *buf_p++;
				green = *buf_p++;
				red = *buf_p++;
				*pixbuf++ = red;
				*pixbuf++ = green;
				*pixbuf++ = blue;
				*pixbuf++ = 255;
				break;
			case 32:
				blue = *buf_p++;
				green = *buf_p++;
				red = *buf_p++;
				alpha = *buf_p++;
				*pixbuf++ = red;
				*pixbuf++ = green;
				*pixbuf++ = blue;
				*pixbuf++ = alpha;
				break;
			default:
				ri.Error( ERR_DROP, "LoadBMP: illegal pixel_size '%d' in file '%s'\n", bmpHeader.bitsPerPixel, name );
				break;
			}
		}
	}

	ri.FS_FreeFile( buffer );

}


/*
=================================================================

PCX LOADING

=================================================================
*/


/*
==============
LoadPCX
==============
*/
static void LoadPCX ( const char *filename, byte **pic, byte **palette, int *width, int *height)
{
	byte	*raw;
	pcx_t	*pcx;
	int		x, y;
	int		len;
	int		dataByte, runLength;
	byte	*out, *pix;
	int		xmax, ymax;

	*pic = NULL;
	*palette = NULL;

	//
	// load the file
	//
	len = ri.FS_ReadFile( ( char * ) filename, (void **)&raw);
	if (!raw) {
		return;
	}

	//
	// parse the PCX file
	//
	pcx = (pcx_t *)raw;
	raw = &pcx->data;

  	xmax = LittleShort(pcx->xmax);
    ymax = LittleShort(pcx->ymax);

	if (pcx->manufacturer != 0x0a
		|| pcx->version != 5
		|| pcx->encoding != 1
		|| pcx->bits_per_pixel != 8
		|| xmax >= 1024
		|| ymax >= 1024)
	{
		ri.Printf (PRINT_ALL, "Bad pcx file %s (%i x %i) (%i x %i)\n", filename, xmax+1, ymax+1, pcx->xmax, pcx->ymax);
		return;
	}

	out = (byte*)ri.Malloc ( (ymax+1) * (xmax+1) );

	*pic = out;

	pix = out;

	if (palette)
	{
		*palette = (byte*)ri.Malloc(768);
		Com_Memcpy (*palette, (byte *)pcx + len - 768, 768);
	}

	if (width)
		*width = xmax+1;
	if (height)
		*height = ymax+1;
// FIXME: use bytes_per_line here?

	for (y=0 ; y<=ymax ; y++, pix += xmax+1)
	{
		for (x=0 ; x<=xmax ; )
		{
			dataByte = *raw++;

			if((dataByte & 0xC0) == 0xC0)
			{
				runLength = dataByte & 0x3F;
				dataByte = *raw++;
			}
			else
				runLength = 1;

			while(runLength-- > 0)
				pix[x++] = dataByte;
		}

	}

	if ( raw - (byte *)pcx > len)
	{
		ri.Printf (PRINT_DEVELOPER, "PCX file %s was malformed", filename);
		ri.Free (*pic);
		*pic = NULL;
	}

	ri.FS_FreeFile (pcx);
}


/*
==============
LoadPCX32
==============
*/
static void LoadPCX32 ( const char *filename, byte **pic, int *width, int *height) {
	byte	*palette;
	byte	*pic8;
	int		i, c, p;
	byte	*pic32;

	LoadPCX (filename, &pic8, &palette, width, height);
	if (!pic8) {
		*pic = NULL;
		return;
	}

	c = (*width) * (*height);
	pic32 = *pic = (byte*)ri.Malloc(4 * c );
	for (i = 0 ; i < c ; i++) {
		p = pic8[i];
		pic32[0] = palette[p*3];
		pic32[1] = palette[p*3 + 1];
		pic32[2] = palette[p*3 + 2];
		pic32[3] = 255;
		pic32 += 4;
	}

	ri.Free (pic8);
	ri.Free (palette);
}

/*
=========================================================

TARGA LOADING

=========================================================
*/

/*
=============
LoadTGA
=============
*/
static void LoadTGA ( const char *name, byte **pic, int *width, int *height)
{
	int		columns, rows, numPixels;
	byte	*pixbuf;
	int		row, column;
	byte	*buf_p;
	byte	*buffer;
	TargaHeader	targa_header;
	byte		*targa_rgba;

	*pic = NULL;

	//
	// load the file
	//
	ri.FS_ReadFile ( ( char * ) name, (void **)&buffer);
	if (!buffer) {
		return;
	}

	buf_p = buffer;

	targa_header.id_length = *buf_p++;
	targa_header.colormap_type = *buf_p++;
	targa_header.image_type = *buf_p++;
	
	targa_header.colormap_index = LittleShort ( *(short *)buf_p );
	buf_p += 2;
	targa_header.colormap_length = LittleShort ( *(short *)buf_p );
	buf_p += 2;
	targa_header.colormap_size = *buf_p++;
	targa_header.x_origin = LittleShort ( *(short *)buf_p );
	buf_p += 2;
	targa_header.y_origin = LittleShort ( *(short *)buf_p );
	buf_p += 2;
	targa_header.width = LittleShort ( *(short *)buf_p );
	buf_p += 2;
	targa_header.height = LittleShort ( *(short *)buf_p );
	buf_p += 2;
	targa_header.pixel_size = *buf_p++;
	targa_header.attributes = *buf_p++;

	if (targa_header.image_type!=2 
		&& targa_header.image_type!=10
		&& targa_header.image_type != 3 ) 
	{
		ri.Error (ERR_DROP, "LoadTGA: Only type 2 (RGB), 3 (gray), and 10 (RGB) TGA images supported\n");
	}

	if ( targa_header.colormap_type != 0 )
	{
		ri.Error( ERR_DROP, "LoadTGA: colormaps not supported\n" );
	}

	if ( ( targa_header.pixel_size != 32 && targa_header.pixel_size != 24 ) && targa_header.image_type != 3 )
	{
		ri.Error (ERR_DROP, "LoadTGA: Only 32 or 24 bit images supported (no colormaps)\n");
	}

	columns = targa_header.width;
	rows = targa_header.height;
	numPixels = columns * rows;

	if (width)
		*width = columns;
	if (height)
		*height = rows;

	targa_rgba = (byte*)ri.Malloc (numPixels*4);
	*pic = targa_rgba;

	if (targa_header.id_length != 0)
		buf_p += targa_header.id_length;  // skip TARGA image comment
	
	if ( targa_header.image_type==2 || targa_header.image_type == 3 )
	{ 
		// Uncompressed RGB or gray scale image
		for(row=rows-1; row>=0; row--) 
		{
			pixbuf = targa_rgba + row*columns*4;
			for(column=0; column<columns; column++) 
			{
				unsigned char red,green,blue,alphabyte;
				switch (targa_header.pixel_size) 
				{
					
				case 8:
					blue = *buf_p++;
					green = blue;
					red = blue;
					*pixbuf++ = red;
					*pixbuf++ = green;
					*pixbuf++ = blue;
					*pixbuf++ = 255;
					break;

				case 24:
					blue = *buf_p++;
					green = *buf_p++;
					red = *buf_p++;
					*pixbuf++ = red;
					*pixbuf++ = green;
					*pixbuf++ = blue;
					*pixbuf++ = 255;
					break;
				case 32:
					blue = *buf_p++;
					green = *buf_p++;
					red = *buf_p++;
					alphabyte = *buf_p++;
					*pixbuf++ = red;
					*pixbuf++ = green;
					*pixbuf++ = blue;
					*pixbuf++ = alphabyte;
					break;
				default:
					ri.Error( ERR_DROP, "LoadTGA: illegal pixel_size '%d' in file '%s'\n", targa_header.pixel_size, name );
					break;
				}
			}
		}
	}
	else if (targa_header.image_type==10) {   // Runlength encoded RGB images
		unsigned char red,green,blue,alphabyte,packetHeader,packetSize,j;

		red = 0;
		green = 0;
		blue = 0;
		alphabyte = 0xff;

		for(row=rows-1; row>=0; row--) {
			pixbuf = targa_rgba + row*columns*4;
			for(column=0; column<columns; ) {
				packetHeader= *buf_p++;
				packetSize = 1 + (packetHeader & 0x7f);
				if (packetHeader & 0x80) {        // run-length packet
					switch (targa_header.pixel_size) {
						case 24:
								blue = *buf_p++;
								green = *buf_p++;
								red = *buf_p++;
								alphabyte = 255;
								break;
						case 32:
								blue = *buf_p++;
								green = *buf_p++;
								red = *buf_p++;
								alphabyte = *buf_p++;
								break;
						default:
							ri.Error( ERR_DROP, "LoadTGA: illegal pixel_size '%d' in file '%s'\n", targa_header.pixel_size, name );
							break;
					}
	
					for(j=0;j<packetSize;j++) {
						*pixbuf++=red;
						*pixbuf++=green;
						*pixbuf++=blue;
						*pixbuf++=alphabyte;
						column++;
						if (column==columns) { // run spans across rows
							column=0;
							if (row>0)
								row--;
							else
								goto breakOut;
							pixbuf = targa_rgba + row*columns*4;
						}
					}
				}
				else {                            // non run-length packet
					for(j=0;j<packetSize;j++) {
						switch (targa_header.pixel_size) {
							case 24:
									blue = *buf_p++;
									green = *buf_p++;
									red = *buf_p++;
									*pixbuf++ = red;
									*pixbuf++ = green;
									*pixbuf++ = blue;
									*pixbuf++ = 255;
									break;
							case 32:
									blue = *buf_p++;
									green = *buf_p++;
									red = *buf_p++;
									alphabyte = *buf_p++;
									*pixbuf++ = red;
									*pixbuf++ = green;
									*pixbuf++ = blue;
									*pixbuf++ = alphabyte;
									break;
							default:
								ri.Error( ERR_DROP, "LoadTGA: illegal pixel_size '%d' in file '%s'\n", targa_header.pixel_size, name );
								break;
						}
						column++;
						if (column==columns) { // pixel packet run spans across rows
							column=0;
							if (row>0)
								row--;
							else
								goto breakOut;
							pixbuf = targa_rgba + row*columns*4;
						}						
					}
				}
			}
			breakOut:;
		}
	}

#if 0 
  // TTimo: this is the chunk of code to ensure a behavior that meets TGA specs 
  // bk0101024 - fix from Leonardo
  // bit 5 set => top-down
  if (targa_header.attributes & 0x20) {
    unsigned char *flip = (unsigned char*)malloc (columns*4);
    unsigned char *src, *dst;

    for (row = 0; row < rows/2; row++) {
      src = targa_rgba + row * 4 * columns;
      dst = targa_rgba + (rows - row - 1) * 4 * columns;

      memcpy (flip, src, columns*4);
      memcpy (src, dst, columns*4);
      memcpy (dst, flip, columns*4);
    }
    free (flip);
  }
#endif
  // instead we just print a warning
  if (targa_header.attributes & 0x20) {
    ri.Printf( PRINT_WARNING, "WARNING: '%s' TGA file header declares top-down image, ignoring\n", name);
  }

  ri.FS_FreeFile (buffer);
}

static void LoadJPG( const char *filename, unsigned char **pic, int *width, int *height ) {
  /* This struct contains the JPEG decompression parameters and pointers to
   * working space (which is allocated as needed by the JPEG library).
   */
  struct jpeg_decompress_struct cinfo;
  /* We use our private extension JPEG error handler.
   * Note that this struct must live as long as the main JPEG parameter
   * struct, to avoid dangling-pointer problems.
   */
  /* This struct represents a JPEG error handler.  It is declared separately
   * because applications often want to supply a specialized error handler
   * (see the second half of this file for an example).  But here we just
   * take the easy way out and use the standard error handler, which will
   * print a message on stderr and call exit() if compression fails.
   * Note that this struct must live as long as the main JPEG parameter
   * struct, to avoid dangling-pointer problems.
   */
  struct jpeg_error_mgr jerr;
  /* More stuff */
  JSAMPARRAY buffer;		/* Output row buffer */
  int row_stride;		/* physical row width in output buffer */
  unsigned char *out;
  byte	*fbuffer;
  byte  *bbuf;

  /* In this example we want to open the input file before doing anything else,
   * so that the setjmp() error recovery below can assume the file is open.
   * VERY IMPORTANT: use "b" option to fopen() if you are on a machine that
   * requires it in order to read binary files.
   */

  ri.FS_ReadFile ( ( char * ) filename, (void **)&fbuffer);
  if (!fbuffer) {
	return;
  }

  /* Step 1: allocate and initialize JPEG decompression object */

  /* We have to set up the error handler first, in case the initialization
   * step fails.  (Unlikely, but it could happen if you are out of memory.)
   * This routine fills in the contents of struct jerr, and returns jerr's
   * address which we place into the link field in cinfo.
   */
  cinfo.err = jpeg_std_error(&jerr);

  /* Now we can initialize the JPEG decompression object. */
  jpeg_create_decompress(&cinfo);

  /* Step 2: specify data source (eg, a file) */

  jpeg_stdio_src(&cinfo, fbuffer);

  /* Step 3: read file parameters with jpeg_read_header() */

  (void) jpeg_read_header(&cinfo, TRUE);
  /* We can ignore the return value from jpeg_read_header since
   *   (a) suspension is not possible with the stdio data source, and
   *   (b) we passed TRUE to reject a tables-only JPEG file as an error.
   * See libjpeg.doc for more info.
   */

  /* Step 4: set parameters for decompression */

  /* In this example, we don't need to change any of the defaults set by
   * jpeg_read_header(), so we do nothing here.
   */

  /* Step 5: Start decompressor */

  (void) jpeg_start_decompress(&cinfo);
  /* We can ignore the return value since suspension is not possible
   * with the stdio data source.
   */

  /* We may need to do some setup of our own at this point before reading
   * the data.  After jpeg_start_decompress() we have the correct scaled
   * output image dimensions available, as well as the output colormap
   * if we asked for color quantization.
   * In this example, we need to make an output work buffer of the right size.
   */
  /* JSAMPLEs per row in output buffer */
  row_stride = cinfo.output_width * cinfo.output_components;

  out = (unsigned char*)ri.Malloc(cinfo.output_width*cinfo.output_height*cinfo.output_components);

  *pic = out;
  *width = cinfo.output_width;
  *height = cinfo.output_height;

  /* Step 6: while (scan lines remain to be read) */
  /*           jpeg_read_scanlines(...); */

  /* Here we use the library's state variable cinfo.output_scanline as the
   * loop counter, so that we don't have to keep track ourselves.
   */
  while (cinfo.output_scanline < cinfo.output_height) {
    /* jpeg_read_scanlines expects an array of pointers to scanlines.
     * Here the array is only one element long, but you could ask for
     * more than one scanline at a time if that's more convenient.
     */
	bbuf = ((out+(row_stride*cinfo.output_scanline)));
	buffer = &bbuf;
    (void) jpeg_read_scanlines(&cinfo, buffer, 1);
  }

  // clear all the alphas to 255
  {
	  int	i, j;
		byte	*buf;

		buf = *pic;

	  j = cinfo.output_width * cinfo.output_height * 4;
	  for ( i = 3 ; i < j ; i+=4 ) {
		  buf[i] = 255;
	  }
  }

  /* Step 7: Finish decompression */

  (void) jpeg_finish_decompress(&cinfo);
  /* We can ignore the return value since suspension is not possible
   * with the stdio data source.
   */

  /* Step 8: Release JPEG decompression object */

  /* This is an important step since it will release a good deal of memory. */
  jpeg_destroy_decompress(&cinfo);

  /* After finish_decompress, we can close the input file.
   * Here we postpone it until after no more JPEG errors are possible,
   * so as to simplify the setjmp error logic above.  (Actually, I don't
   * think that jpeg_destroy can do an error exit, but why assume anything...)
   */
  ri.FS_FreeFile (fbuffer);

  /* At this point you may want to check to see whether any corrupt-data
   * warnings occurred (test whether jerr.pub.num_warnings is nonzero).
   */

  /* And we're done! */
}

/* Expanded data destination object for stdio output */

typedef struct {
  struct jpeg_destination_mgr pub; /* public fields */

  byte* outfile;		/* target stream */
  int	size;
} my_destination_mgr;

typedef my_destination_mgr * my_dest_ptr;


/*
 * Initialize destination --- called by jpeg_start_compress
 * before any data is actually written.
 */

void init_destination (j_compress_ptr cinfo)
{
  my_dest_ptr dest = (my_dest_ptr) cinfo->dest;

  dest->pub.next_output_byte = dest->outfile;
  dest->pub.free_in_buffer = dest->size;
}


/*
 * Empty the output buffer --- called whenever buffer fills up.
 *
 * In typical applications, this should write the entire output buffer
 * (ignoring the current state of next_output_byte & free_in_buffer),
 * reset the pointer & count to the start of the buffer, and return TRUE
 * indicating that the buffer has been dumped.
 *
 * In applications that need to be able to suspend compression due to output
 * overrun, a FALSE return indicates that the buffer cannot be emptied now.
 * In this situation, the compressor will return to its caller (possibly with
 * an indication that it has not accepted all the supplied scanlines).  The
 * application should resume compression after it has made more room in the
 * output buffer.  Note that there are substantial restrictions on the use of
 * suspension --- see the documentation.
 *
 * When suspending, the compressor will back up to a convenient restart point
 * (typically the start of the current MCU). next_output_byte & free_in_buffer
 * indicate where the restart point will be if the current call returns FALSE.
 * Data beyond this point will be regenerated after resumption, so do not
 * write it out when emptying the buffer externally.
 */

boolean empty_output_buffer (j_compress_ptr cinfo)
{
  return TRUE;
}


/*
 * Compression initialization.
 * Before calling this, all parameters and a data destination must be set up.
 *
 * We require a write_all_tables parameter as a failsafe check when writing
 * multiple datastreams from the same compression object.  Since prior runs
 * will have left all the tables marked sent_table=TRUE, a subsequent run
 * would emit an abbreviated stream (no tables) by default.  This may be what
 * is wanted, but for safety's sake it should not be the default behavior:
 * programmers should have to make a deliberate choice to emit abbreviated
 * images.  Therefore the documentation and examples should encourage people
 * to pass write_all_tables=TRUE; then it will take active thought to do the
 * wrong thing.
 */

void jpeg_start_compress (j_compress_ptr cinfo, boolean write_all_tables)
{
  if (cinfo->global_state != CSTATE_START)
    ERREXIT1(cinfo, JERR_BAD_STATE, cinfo->global_state);

  if (write_all_tables)
    jpeg_suppress_tables(cinfo, FALSE);

  (*cinfo->err->reset_error_mgr) ((j_common_ptr) cinfo);
  (*cinfo->dest->init_destination) (cinfo);

  jinit_compress_master(cinfo);

  (*cinfo->master->prepare_for_pass) (cinfo);

  cinfo->next_scanline = 0;
  cinfo->global_state = (cinfo->raw_data_in ? CSTATE_RAW_OK : CSTATE_SCANNING);

}


/*
 * Write some scanlines of data to the JPEG compressor.
 *
 * The return value will be the number of lines actually written.
 * This should be less than the supplied num_lines only in case that
 * the data destination module has requested suspension of the compressor,
 * or if more than image_height scanlines are passed in.
 *
 * Note: we warn about excess calls to jpeg_write_scanlines() since
 * this likely signals an application programmer error.  However,
 * excess scanlines passed in the last valid call are *silently* ignored,
 * so that the application need not adjust num_lines for end-of-image
 * when using a multiple-scanline buffer.
 */

JDIMENSION jpeg_write_scanlines (j_compress_ptr cinfo, JSAMPARRAY scanlines, JDIMENSION num_lines)
{
  JDIMENSION row_ctr, rows_left;

  if (cinfo->global_state != CSTATE_SCANNING)
    ERREXIT1(cinfo, JERR_BAD_STATE, cinfo->global_state);
  if (cinfo->next_scanline >= cinfo->image_height)
    WARNMS(cinfo, JWRN_TOO_MUCH_DATA);

  if (cinfo->progress != NULL) {
    cinfo->progress->pass_counter = (long) cinfo->next_scanline;
    cinfo->progress->pass_limit = (long) cinfo->image_height;
    (*cinfo->progress->progress_monitor) ((j_common_ptr) cinfo);
  }

  if (cinfo->master->call_pass_startup)
    (*cinfo->master->pass_startup) (cinfo);

  rows_left = cinfo->image_height - cinfo->next_scanline;
  if (num_lines > rows_left)
    num_lines = rows_left;

  row_ctr = 0;
  (*cinfo->main->process_data) (cinfo, scanlines, &row_ctr, num_lines);
  cinfo->next_scanline += row_ctr;
  return row_ctr;
}

/*
 * Terminate destination --- called by jpeg_finish_compress
 * after all data has been written.  Usually needs to flush buffer.
 *
 * NB: *not* called by jpeg_abort or jpeg_destroy; surrounding
 * application must deal with any cleanup that should happen even
 * for error exit.
 */

static int hackSize;

void term_destination (j_compress_ptr cinfo)
{
  my_dest_ptr dest = (my_dest_ptr) cinfo->dest;
  size_t datacount = dest->size - dest->pub.free_in_buffer;
  hackSize = datacount;
}


/*
 * Prepare for output to a stdio stream.
 * The caller must have already opened the stream, and is responsible
 * for closing it after finishing compression.
 */

void jpegDest (j_compress_ptr cinfo, byte* outfile, int size)
{
  my_dest_ptr dest;

  if (cinfo->dest == NULL) {
    cinfo->dest = (struct jpeg_destination_mgr *)
      (*cinfo->mem->alloc_small) ((j_common_ptr) cinfo, JPOOL_PERMANENT,
				  sizeof(my_destination_mgr));
  }

  dest = (my_dest_ptr) cinfo->dest;
  dest->pub.init_destination = init_destination;
  dest->pub.empty_output_buffer = empty_output_buffer;
  dest->pub.term_destination = term_destination;
  dest->outfile = outfile;
  dest->size = size;
}

void SaveJPG(char * filename, int quality, int image_width, int image_height, unsigned char *image_buffer)
{

  struct jpeg_compress_struct cinfo;

  struct jpeg_error_mgr jerr;
  JSAMPROW row_pointer[1];	
  int row_stride;		
  unsigned char *out;

  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_compress(&cinfo);

  out = (unsigned char*)ri.Hunk_AllocateTempMemory(image_width*image_height*4);
  jpegDest(&cinfo, out, image_width*image_height*4);

  cinfo.image_width = image_width; 
  cinfo.image_height = image_height;
  cinfo.input_components = 4;		
  cinfo.in_color_space = JCS_RGB;
  
  jpeg_set_defaults(&cinfo);
  jpeg_set_quality(&cinfo, quality, TRUE);
  jpeg_start_compress(&cinfo, TRUE);

  row_stride = image_width * 4;

  while (cinfo.next_scanline < cinfo.image_height) {
    row_pointer[0] = & image_buffer[((cinfo.image_height-1)*row_stride)-cinfo.next_scanline * row_stride];
    (void) jpeg_write_scanlines(&cinfo, row_pointer, 1);
  }

  jpeg_finish_compress(&cinfo);
  ri.FS_WriteFile( filename, out, hackSize );

  ri.Hunk_FreeTempMemory(out);
  jpeg_destroy_compress(&cinfo);
}

//===================================================================

/*
=================
R_LoadImage

Loads any of the supported image types into a cannonical
32 bit format.
=================
*/
void R_LoadImage( const char *name, byte **pic, int *width, int *height )
{
	int		len;

	*pic = NULL;
	*width = 0;
	*height = 0;

	len = strlen(name);
	if (len<5)
	{
		return;
	}

	  if ( !Q_stricmp( name+len-4, ".tga" ) )
	  {
		  LoadTGA( name, pic, width, height );            // try tga first

		if (!*pic)
		{                                    //
		  char altname[MAX_QPATH];                      // try jpg in place of tga
	      strcpy( altname, name );
	      len = strlen( altname );
	      altname[len-3] = 'j';
	      altname[len-2] = 'p';
	      altname[len-1] = 'g';
		  LoadJPG( altname, pic, width, height );
		}
	  }
	  else if ( !Q_stricmp(name+len-4, ".pcx") )
	  {
	    LoadPCX32( name, pic, width, height );
	  }
	  else if ( !Q_stricmp( name+len-4, ".bmp" ) )
	  {
		LoadBMP( name, pic, width, height );
	  }
	  else if ( !Q_stricmp( name+len-4, ".jpg" ) )
	  {
		LoadJPG( name, pic, width, height );
	  }
}


/*
===============
R_FindImageFile

Finds or loads the given image.
Returns NULL if it fails, not a default image.
==============
*/
image_t	*R_FindImageFile( const char *name, qboolean mipmap, qboolean allowPicmip, int glWrapClampMode )
{
	image_t	*image;
	int		width, height;
	byte	*pic;
	long	hash;
	char loadname[MAX_QPATH];

	if (!name)
	{
		return NULL;
	}

	hash = generateHashValue(name);

	//
	// see if the image is already loaded
	//
	for (image=hashTable[hash]; image; image=image->next)
	{
		if ( !strcmp( name, image->imgName ) )
		{
			// the white image can be used with any set of parms, but other mismatches are errors
			if ( strcmp( name, "*white" ) )
			{
				if ( image->mipmap != mipmap )
				{
					ri.Printf( PRINT_DEVELOPER, "WARNING: reused image %s with mixed mipmap parm\n", name );
				}
				if ( image->allowPicmip != allowPicmip )
				{
					ri.Printf( PRINT_DEVELOPER, "WARNING: reused image %s with mixed allowPicmip parm\n", name );
				}
				if ( image->wrapClampMode != glWrapClampMode )
				{
					ri.Printf( PRINT_ALL, "WARNING: reused image %s with mixed glWrapClampMode parm\n", name );
				}
			}
			return image;
		}
	}

	//
	// load the pic from disk
	//
	R_LoadImage( name, &pic, &width, &height );
	if ( pic == NULL )
	{                                    // if we dont get a successful load
	    char altname[MAX_QPATH];                              // copy the name
        int len;                                              //
        strcpy( altname, name );                              //
        len = strlen( altname );                              //
        altname[len-3] = toupper(altname[len-3]);             // and try upper case extension for unix systems
        altname[len-2] = toupper(altname[len-2]);             //
        altname[len-1] = toupper(altname[len-1]);             //
		ri.Printf( PRINT_ALL, "trying %s...\n", altname );    // 
	    R_LoadImage( altname, &pic, &width, &height );        //
	    if (pic == NULL)
		{                                    // if that fails
	      return NULL;                                        // bail
	    }
	    else
	    {
          strcpy( loadname, altname );
        }
	}
	else
	{
		strcpy( loadname, name );
	}

	image = R_CreateImage( ( char * ) loadname, pic, width, height, mipmap, allowPicmip, glWrapClampMode );
	ri.Free( pic );
	return image;
}


/*
================
R_CreateDlightImage
================
*/
#define	DLIGHT_SIZE	16
static void R_CreateDlightImage( void )
{
	int		x,y;
	byte	data[DLIGHT_SIZE][DLIGHT_SIZE][4];
	int		b;

	// make a centered inverse-square falloff blob for dynamic lighting
	for (x=0 ; x<DLIGHT_SIZE ; x++) {
		for (y=0 ; y<DLIGHT_SIZE ; y++) {
			float	d;

			d = ( DLIGHT_SIZE/2 - 0.5f - x ) * ( DLIGHT_SIZE/2 - 0.5f - x ) +
				( DLIGHT_SIZE/2 - 0.5f - y ) * ( DLIGHT_SIZE/2 - 0.5f - y );
			b = 4000 / d;
			if (b > 255) {
				b = 255;
			} else if ( b < 75 ) {
				b = 0;
			}
			data[y][x][0] = 
			data[y][x][1] = 
			data[y][x][2] = b;
			data[y][x][3] = 255;			
		}
	}
	tr.dlightImage = R_CreateImage("*dlight", (byte *)data, DLIGHT_SIZE, DLIGHT_SIZE, qfalse, qfalse, GU_CLAMP );
}


/*
=================
R_InitFogTable
=================
*/
void R_InitFogTable( void )
{
	int		i;
	float	d;
	float	exp;
	
	exp = 0.5;

	for ( i = 0 ; i < FOG_TABLE_SIZE ; i++ ) {
		d = pow ( (float)i/(FOG_TABLE_SIZE-1), exp );

		tr.fogTable[i] = d;
	}
}

/*
================
R_FogFactor

Returns a 0.0 to 1.0 fog density value
This is called for each texel of the fog texture on startup
and for each vertex of transparent shaders in fog dynamically
================
*/
float	R_FogFactor( float s, float t )
{
	float	d;

	s -= 1.0/512;
	if ( s < 0 ) {
		return 0;
	}
	if ( t < 1.0/32 ) {
		return 0;
	}
	if ( t < 31.0/32 ) {
		s *= (t - 1.0f/32.0f) / (30.0f/32.0f);
	}

	// we need to leave a lot of clamp range
	s *= 8;

	if ( s > 1.0 ) {
		s = 1.0;
	}

	d = tr.fogTable[ (int)(s * (FOG_TABLE_SIZE-1)) ];

	return d;
}

/*
================
R_CreateFogImage
================
*/
#define	FOG_S	256
#define	FOG_T	32
static void R_CreateFogImage( void )
{
	int		x,y;
	byte	*data;
	float	g;
	float	d;
/*
	float	borderColor[4];
*/
	data = (byte*)ri.Hunk_AllocateTempMemory( FOG_S * FOG_T * 4 );

	g = 2.0;

	// S is distance, T is depth
	for (x=0 ; x<FOG_S ; x++) {
		for (y=0 ; y<FOG_T ; y++) {
			d = R_FogFactor( ( x + 0.5f ) / FOG_S, ( y + 0.5f ) / FOG_T );

			data[(y*FOG_S+x)*4+0] = 
			data[(y*FOG_S+x)*4+1] = 
			data[(y*FOG_S+x)*4+2] = 255;
			data[(y*FOG_S+x)*4+3] = 255*d;
		}
	}
	// standard openGL clamping doesn't really do what we want -- it includes
	// the border color at the edges.  OpenGL 1.2 has clamp-to-edge, which does
	// what we want.
	tr.fogImage = R_CreateImage("*fog", (byte *)data, FOG_S, FOG_T, qfalse, qfalse, GU_CLAMP );
	ri.Hunk_FreeTempMemory( data );
/*
	borderColor[0] = 1.0;
	borderColor[1] = 1.0;
	borderColor[2] = 1.0;
	borderColor[3] = 1;

	qglTexParameterfv( GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor );
*/
}

/*
==================
R_CreateDefaultImage
==================
*/
#define	DEFAULT_SIZE	16
static void R_CreateDefaultImage( void ) {
	int		x;
	byte	data[DEFAULT_SIZE][DEFAULT_SIZE][4];

	// the default image will be a box, to allow you to see the mapping coordinates
	Com_Memset( data, 32, sizeof( data ) );
	for ( x = 0 ; x < DEFAULT_SIZE ; x++ ) {
		data[0][x][0] =
		data[0][x][1] =
		data[0][x][2] =
		data[0][x][3] = 255;

		data[x][0][0] =
		data[x][0][1] =
		data[x][0][2] =
		data[x][0][3] = 255;

		data[DEFAULT_SIZE-1][x][0] =
		data[DEFAULT_SIZE-1][x][1] =
		data[DEFAULT_SIZE-1][x][2] =
		data[DEFAULT_SIZE-1][x][3] = 255;

		data[x][DEFAULT_SIZE-1][0] =
		data[x][DEFAULT_SIZE-1][1] =
		data[x][DEFAULT_SIZE-1][2] =
		data[x][DEFAULT_SIZE-1][3] = 255;
	}
	tr.defaultImage = R_CreateImage("*default", (byte *)data, DEFAULT_SIZE, DEFAULT_SIZE, qtrue, qfalse, GU_REPEAT );
}

/*
==================
R_CreateBuiltinImages
==================
*/
void R_CreateBuiltinImages( void )
{
	int		x,y;
	byte	data[DEFAULT_SIZE][DEFAULT_SIZE][4];

	R_CreateDefaultImage();

	// we use a solid white image instead of disabling texturing
	Com_Memset( data, 255, sizeof( data ) );
	tr.whiteImage = R_CreateImage("*white", (byte *)data, 8, 8, qfalse, qfalse, GU_REPEAT );

	// with overbright bits active, we need an image which is some fraction of full color,
	// for default lightmaps, etc
	for (x=0 ; x<DEFAULT_SIZE ; x++) {
		for (y=0 ; y<DEFAULT_SIZE ; y++) {
			data[y][x][0] = 
			data[y][x][1] = 
			data[y][x][2] = tr.identityLightByte;
			data[y][x][3] = 255;			
		}
	}

	tr.identityLightImage = R_CreateImage("*identityLight", (byte *)data, 8, 8, qfalse, qfalse, GU_REPEAT );

/*
	for(x=0;x<32;x++)
	{
		// scratchimage is usually used for cinematic drawing
		tr.scratchImage[x] = R_CreateImage("*scratch", (byte *)data, DEFAULT_SIZE, DEFAULT_SIZE, qfalse, qtrue, GU_CLAMP );
	}
*/
	R_CreateDlightImage();
	R_CreateFogImage();
}


/*
===============
R_SetColorMappings
===============
*/
void R_SetColorMappings( void )
{
	int		i, j;
	float	g;
	int		inf;
	int		shift;

	// setup the overbright lighting
	tr.overbrightBits = r_overBrightBits->integer;
	if ( !glConfig.deviceSupportsGamma )
	{
		tr.overbrightBits = 0;		// need hardware gamma for overbright
	}

	// never overbright in windowed mode
	if ( !glConfig.isFullscreen ) 
	{
		tr.overbrightBits = 0;
	}

	// allow 2 overbright bits in 24 bit, but only 1 in 16 bit
	if ( glConfig.colorBits > 16 ) {
		if ( tr.overbrightBits > 2 ) {
			tr.overbrightBits = 2;
		}
	} else {
		if ( tr.overbrightBits > 1 ) {
			tr.overbrightBits = 1;
		}
	}
	if ( tr.overbrightBits < 0 ) {
		tr.overbrightBits = 0;
	}

	tr.identityLight = 1.0f / ( 1 << tr.overbrightBits );
	tr.identityLightByte = 255 * tr.identityLight;


	if ( r_intensity->value <= 1 )
	{
		ri.Cvar_Set( "r_intensity", "1" );
	}

	if ( r_gamma->value < 0.5f )
	{
		ri.Cvar_Set( "r_gamma", "0.5" );
	}
	else if ( r_gamma->value > 3.0f )
	{
		ri.Cvar_Set( "r_gamma", "3.0" );
	}

	g = r_gamma->value;

	shift = tr.overbrightBits;

	for ( i = 0; i < 256; i++ )
	{
		if ( g == 1 )
		{
			inf = i;
		}
		else
		{
			inf = 255 * pow ( i/255.0f, 1.0f / g ) + 0.5f;
		}
		inf <<= shift;
		if (inf < 0)
		{
			inf = 0;
		}
		if (inf > 255)
		{
			inf = 255;
		}
		s_gammatable[i] = inf;
	}

	for (i=0 ; i<256 ; i++)
	{
		j = i * r_intensity->value;
		if (j > 255) {
			j = 255;
		}
		s_intensitytable[i] = j;
	}

	if ( glConfig.deviceSupportsGamma )
	{
		GLimp_SetGamma( s_gammatable, s_gammatable, s_gammatable );
	}
}

/*
===============
R_InitImages
===============
*/
void	R_InitImages( void )
{
	Com_Memset(hashTable, 0, sizeof(hashTable));

	for (int i=0; i<MAX_DRAWIMAGES; i++)
	{
		texused[i] = qfalse;
	}

	// build brightness translation tables
	R_SetColorMappings();

	// create default texture and white texture
	R_CreateBuiltinImages();
}


void DelTexture(int texindex)
{
	if (texused[texindex] == qtrue)
	{
		image_t* image = tr.images[texindex];
    
		ri.Printf(PRINT_DEVELOPER,"Unloading: %s\n",image->imgName);

		// Source.
		strcpy(image->imgName,"");
		image->width = 0;
		image->height = 0;

		//========== Texture description ============//
		image->format                  = GU_PSM_T8;
		image->filter                  = GU_LINEAR;
		image->uploadWidth             = 0;
		image->uploadHeight            = 0;
        image->mipmap                  = qfalse;
		image->mipmaps                 = 0;
		image->texnum                  = 0;
        image->allowPicmip             = qfalse;
        image->wrapClampMode           = GU_CLAMP;
		image->frameUsed               = 0;			// for texture usage in frame statistics
	    image->internalFormat          = 0;
        image->stretch_to_power_of_two = qfalse;
   	    image->TMU                     = 0;

		// Buffers.
		if (image->ram != NULL)
		{
			free(image->ram);
			image->ram = NULL;
		}
		if (image->vram != NULL)
		{
			vfree(image->vram);
			image->vram = NULL;
		}

		//free(image);

	    texused[texindex] = qfalse;
        tr.numImages--;
	}
}

/*
===============
R_DeleteTextures
===============
*/
void R_DeleteTextures( void )
{
	int		i;
	printf("all texturex used: %dKB\n", alltexsize / 1024);
    alltexsize = 0;

	for ( i = 0; i < MAX_DRAWIMAGES ; i++ )
	{
		if(!tr.images[i]) //null pointer skip
         continue;
   		DelTexture(tr.images[i]->texnum);
	}

	Com_Memset( tr.images, 0, sizeof( tr.images ) );
	tr.numImages = 0;
	Com_Memset( glState.currenttextures, 0, sizeof( glState.currenttextures ) );
}

/*
============================================================================

SKINS

============================================================================
*/

/*
==================
CommaParse

This is unfortunate, but the skin files aren't
compatable with our normal parsing rules.
==================
*/
static char *CommaParse( char **data_p ) {
	int c = 0, len;
	char *data;
	static	char	com_token[MAX_TOKEN_CHARS];

	data = *data_p;
	len = 0;
	com_token[0] = 0;

	// make sure incoming data is valid
	if ( !data ) {
		*data_p = NULL;
		return com_token;
	}

	while ( 1 ) {
		// skip whitespace
		while( (c = *data) <= ' ') {
			if( !c ) {
				break;
			}
			data++;
		}


		c = *data;

		// skip double slash comments
		if ( c == '/' && data[1] == '/' )
		{
			while (*data && *data != '\n')
				data++;
		}
		// skip /* */ comments
		else if ( c=='/' && data[1] == '*' ) 
		{
			while ( *data && ( *data != '*' || data[1] != '/' ) ) 
			{
				data++;
			}
			if ( *data ) 
			{
				data += 2;
			}
		}
		else
		{
			break;
		}
	}

	if ( c == 0 ) {
		return "";
	}

	// handle quoted strings
	if (c == '\"')
	{
		data++;
		while (1)
		{
			c = *data++;
			if (c=='\"' || !c)
			{
				com_token[len] = 0;
				*data_p = ( char * ) data;
				return com_token;
			}
			if (len < MAX_TOKEN_CHARS)
			{
				com_token[len] = c;
				len++;
			}
		}
	}

	// parse a regular word
	do
	{
		if (len < MAX_TOKEN_CHARS)
		{
			com_token[len] = c;
			len++;
		}
		data++;
		c = *data;
	} while (c>32 && c != ',' );

	if (len == MAX_TOKEN_CHARS)
	{
//		Com_Printf ("Token exceeded %i chars, discarded.\n", MAX_TOKEN_CHARS);
		len = 0;
	}
	com_token[len] = 0;

	*data_p = ( char * ) data;
	return com_token;
}


/*
===============
RE_RegisterSkin

===============
*/
qhandle_t RE_RegisterSkin( const char *name )
{
	qhandle_t	hSkin;
	skin_t		*skin;
	skinSurface_t	*surf;
	char		*text, *text_p;
	char		*token;
	char		surfName[MAX_QPATH];

	if ( !name || !name[0] ) {
		Com_Printf( "Empty name passed to RE_RegisterSkin\n" );
		return 0;
	}

	if ( strlen( name ) >= MAX_QPATH ) {
		Com_Printf( "Skin name exceeds MAX_QPATH\n" );
		return 0;
	}


	// see if the skin is already loaded
	for ( hSkin = 1; hSkin < tr.numSkins ; hSkin++ ) {
		skin = tr.skins[hSkin];
		if ( !Q_stricmp( skin->name, name ) ) {
			if( skin->numSurfaces == 0 ) {
				return 0;		// default skin
			}
			return hSkin;
		}
	}

	// allocate a new skin
	if ( tr.numSkins == MAX_SKINS ) {
		ri.Printf( PRINT_WARNING, "WARNING: RE_RegisterSkin( '%s' ) MAX_SKINS hit\n", name );
		return 0;
	}
	tr.numSkins++;
	skin = (skin_t*)ri.Hunk_Alloc( sizeof( skin_t ), h_low );
	tr.skins[hSkin] = skin;
	Q_strncpyz( skin->name, name, sizeof( skin->name ) );
	skin->numSurfaces = 0;

	// make sure the render thread is stopped
	R_SyncRenderThread();

	// If not a .skin file, load as a single shader
	if ( strcmp( name + strlen( name ) - 5, ".skin" ) ) {
		skin->numSurfaces = 1;
		skin->surfaces[0] = (skinSurface_t*)ri.Hunk_Alloc( sizeof(skin->surfaces[0]), h_low );
		skin->surfaces[0]->shader = R_FindShader( name, LIGHTMAP_NONE, qtrue );
		return hSkin;
	}

	// load and parse the skin file
    ri.FS_ReadFile( name, (void **)&text );
	if ( !text ) {
		return 0;
	}

	text_p = text;
	while ( text_p && *text_p ) {
		// get surface name
		token = CommaParse( &text_p );
		Q_strncpyz( surfName, token, sizeof( surfName ) );

		if ( !token[0] ) {
			break;
		}
		// lowercase the surface name so skin compares are faster
		Q_strlwr( surfName );

		if ( *text_p == ',' ) {
			text_p++;
		}

		if ( strstr( token, "tag_" ) ) {
			continue;
		}
		
		// parse the shader name
		token = CommaParse( &text_p );

		surf = skin->surfaces[ skin->numSurfaces ] = (skinSurface_t*)ri.Hunk_Alloc( sizeof( *skin->surfaces[0] ), h_low );
		Q_strncpyz( surf->name, surfName, sizeof( surf->name ) );
		surf->shader = R_FindShader( token, LIGHTMAP_NONE, qtrue );
		skin->numSurfaces++;
	}

	ri.FS_FreeFile( text );


	// never let a skin have 0 shaders
	if ( skin->numSurfaces == 0 ) {
		return 0;		// use default skin
	}

	return hSkin;
}


/*
===============
R_InitSkins
===============
*/
void	R_InitSkins( void ) {
	skin_t		*skin;

	tr.numSkins = 1;

	// make the default skin have all default shaders
	skin = tr.skins[0] = (skin_t*)ri.Hunk_Alloc( sizeof( skin_t ), h_low );
	Q_strncpyz( skin->name, "<default skin>", sizeof( skin->name )  );
	skin->numSurfaces = 1;
	skin->surfaces[0] = (skinSurface_t*)ri.Hunk_Alloc( sizeof( *skin->surfaces ), h_low );
	skin->surfaces[0]->shader = tr.defaultShader;
}

/*
===============
R_GetSkinByHandle
===============
*/
skin_t	*R_GetSkinByHandle( qhandle_t hSkin ) {
	if ( hSkin < 1 || hSkin >= tr.numSkins ) {
		return tr.skins[0];
	}
	return tr.skins[ hSkin ];
}

/*
===============
R_SkinList_f
===============
*/
void	R_SkinList_f( void )
{
	int			i, j;
	skin_t		*skin;

	ri.Printf (PRINT_ALL, "------------------\n");

	for ( i = 0 ; i < tr.numSkins ; i++ ) {
		skin = tr.skins[i];

		ri.Printf( PRINT_ALL, "%3i:%s\n", i, skin->name );
		for ( j = 0 ; j < skin->numSurfaces ; j++ ) {
			ri.Printf( PRINT_ALL, "       %s = %s\n", 
				skin->surfaces[j]->name, skin->surfaces[j]->shader->name );
		}
	}
	ri.Printf (PRINT_ALL, "------------------\n");
}

