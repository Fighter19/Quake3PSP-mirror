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
/** 
 * GAS syntax equivalents of the MSVC asm memory calls in common.c
 *
 * The following changes have been made to the asm:
 * 1. Registers are loaded by the inline asm arguments when possible
 * 2. Labels have been changed to local label format (0,1,etc.) to allow inlining
 *
 * HISTORY:
 *	AH - Created on 08 Dec 2000
 */

#include <unistd.h>   // AH - for size_t
#include <string.h>
#include <psptypes.h>


void Com_Memcpy (void* dest, const void* src, const size_t count) 
{
   memcpy(dest, src, count);
}

void Com_Memset (void* dest, const int val, const size_t count) 
{
   memset(dest, val, count);
}
