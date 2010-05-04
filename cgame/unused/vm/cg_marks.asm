export CG_InitMarkPolys
code
proc CG_InitMarkPolys 12 12
file "../cg_marks.c"
line 48
;1:/*
;2:===========================================================================
;3:Copyright (C) 1999-2005 Id Software, Inc.
;4:
;5:This file is part of Quake III Arena source code.
;6:
;7:Quake III Arena source code is free software; you can redistribute it
;8:and/or modify it under the terms of the GNU General Public License as
;9:published by the Free Software Foundation; either version 2 of the License,
;10:or (at your option) any later version.
;11:
;12:Quake III Arena source code is distributed in the hope that it will be
;13:useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
;14:MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;15:GNU General Public License for more details.
;16:
;17:You should have received a copy of the GNU General Public License
;18:along with Foobar; if not, write to the Free Software
;19:Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;20:===========================================================================
;21:*/
;22://
;23:// cg_marks.c -- wall marks
;24:
;25:#include "cg_local.h"
;26:
;27:/*
;28:===================================================================
;29:
;30:MARK POLYS
;31:
;32:===================================================================
;33:*/
;34:
;35:
;36:markPoly_t	cg_activeMarkPolys;			// double linked list
;37:markPoly_t	*cg_freeMarkPolys;			// single linked list
;38:markPoly_t	cg_markPolys[MAX_MARK_POLYS];
;39:static		int	markTotal;
;40:
;41:/*
;42:===================
;43:CG_InitMarkPolys
;44:
;45:This is called at startup and for tournement restarts
;46:===================
;47:*/
;48:void	CG_InitMarkPolys( void ) {
line 51
;49:	int		i;
;50:
;51:	memset( cg_markPolys, 0, sizeof(cg_markPolys) );
ADDRGP4 cg_markPolys
ARGP4
CNSTI4 0
ARGI4
CNSTI4 73728
ARGI4
ADDRGP4 memset
CALLP4
pop
line 53
;52:
;53:	cg_activeMarkPolys.nextMark = &cg_activeMarkPolys;
ADDRGP4 cg_activeMarkPolys+4
ADDRGP4 cg_activeMarkPolys
ASGNP4
line 54
;54:	cg_activeMarkPolys.prevMark = &cg_activeMarkPolys;
ADDRLP4 4
ADDRGP4 cg_activeMarkPolys
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
ASGNP4
line 55
;55:	cg_freeMarkPolys = cg_markPolys;
ADDRGP4 cg_freeMarkPolys
ADDRGP4 cg_markPolys
ASGNP4
line 56
;56:	for ( i = 0 ; i < MAX_MARK_POLYS - 1 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $72
line 57
;57:		cg_markPolys[i].nextMark = &cg_markPolys[i+1];
ADDRLP4 8
CNSTI4 288
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 8
INDIRI4
ADDRGP4 cg_markPolys+4
ADDP4
ADDRLP4 8
INDIRI4
ADDRGP4 cg_markPolys+288
ADDP4
ASGNP4
line 58
;58:	}
LABELV $73
line 56
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 255
LTI4 $72
line 59
;59:}
LABELV $70
endproc CG_InitMarkPolys 12 12
export CG_FreeMarkPoly
proc CG_FreeMarkPoly 12 4
line 67
;60:
;61:
;62:/*
;63:==================
;64:CG_FreeMarkPoly
;65:==================
;66:*/
;67:void CG_FreeMarkPoly( markPoly_t *le ) {
line 68
;68:	if ( !le->prevMark ) {
ADDRFP4 0
INDIRP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $79
line 69
;69:		CG_Error( "CG_FreeLocalEntity: not active" );
ADDRGP4 $81
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 70
;70:	}
LABELV $79
line 73
;71:
;72:	// remove from the doubly linked active list
;73:	le->prevMark->nextMark = le->nextMark;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 4
ASGNI4
ADDRLP4 0
INDIRP4
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
ADDRLP4 0
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
INDIRP4
ASGNP4
line 74
;74:	le->nextMark->prevMark = le->prevMark;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ADDRLP4 8
INDIRP4
INDIRP4
ASGNP4
line 77
;75:
;76:	// the free list is only singly linked
;77:	le->nextMark = cg_freeMarkPolys;
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg_freeMarkPolys
INDIRP4
ASGNP4
line 78
;78:	cg_freeMarkPolys = le;
ADDRGP4 cg_freeMarkPolys
ADDRFP4 0
INDIRP4
ASGNP4
line 79
;79:}
LABELV $78
endproc CG_FreeMarkPoly 12 4
export CG_AllocMark
proc CG_AllocMark 12 12
line 88
;80:
;81:/*
;82:===================
;83:CG_AllocMark
;84:
;85:Will allways succeed, even if it requires freeing an old active mark
;86:===================
;87:*/
;88:markPoly_t	*CG_AllocMark( void ) {
line 92
;89:	markPoly_t	*le;
;90:	int time;
;91:
;92:	if ( !cg_freeMarkPolys ) {
ADDRGP4 cg_freeMarkPolys
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $83
line 95
;93:		// no free entities, so free the one at the end of the chain
;94:		// remove the oldest active entity
;95:		time = cg_activeMarkPolys.prevMark->time;
ADDRLP4 4
ADDRGP4 cg_activeMarkPolys
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $86
JUMPV
LABELV $85
line 96
;96:		while (cg_activeMarkPolys.prevMark && time == cg_activeMarkPolys.prevMark->time) {
line 97
;97:			CG_FreeMarkPoly( cg_activeMarkPolys.prevMark );
ADDRGP4 cg_activeMarkPolys
INDIRP4
ARGP4
ADDRGP4 CG_FreeMarkPoly
CALLV
pop
line 98
;98:		}
LABELV $86
line 96
ADDRLP4 8
ADDRGP4 cg_activeMarkPolys
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $88
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
EQI4 $85
LABELV $88
line 99
;99:	}
LABELV $83
line 101
;100:
;101:	le = cg_freeMarkPolys;
ADDRLP4 0
ADDRGP4 cg_freeMarkPolys
INDIRP4
ASGNP4
line 102
;102:	cg_freeMarkPolys = cg_freeMarkPolys->nextMark;
ADDRLP4 8
ADDRGP4 cg_freeMarkPolys
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ASGNP4
line 104
;103:
;104:	memset( le, 0, sizeof( *le ) );
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 288
ARGI4
ADDRGP4 memset
CALLP4
pop
line 107
;105:
;106:	// link into the active list
;107:	le->nextMark = cg_activeMarkPolys.nextMark;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg_activeMarkPolys+4
INDIRP4
ASGNP4
line 108
;108:	le->prevMark = &cg_activeMarkPolys;
ADDRLP4 0
INDIRP4
ADDRGP4 cg_activeMarkPolys
ASGNP4
line 109
;109:	cg_activeMarkPolys.nextMark->prevMark = le;
ADDRGP4 cg_activeMarkPolys+4
INDIRP4
ADDRLP4 0
INDIRP4
ASGNP4
line 110
;110:	cg_activeMarkPolys.nextMark = le;
ADDRGP4 cg_activeMarkPolys+4
ADDRLP4 0
INDIRP4
ASGNP4
line 111
;111:	return le;
ADDRLP4 0
INDIRP4
RETP4
LABELV $82
endproc CG_AllocMark 12 12
export CG_ImpactMark
proc CG_ImpactMark 6088 28
line 132
;112:}
;113:
;114:
;115:
;116:/*
;117:=================
;118:CG_ImpactMark
;119:
;120:origin should be a point within a unit of the plane
;121:dir should be the plane normal
;122:
;123:temporary marks will not be stored or randomly oriented, but immediately
;124:passed to the renderer.
;125:=================
;126:*/
;127:#define	MAX_MARK_FRAGMENTS	128
;128:#define	MAX_MARK_POINTS		384
;129:
;130:void CG_ImpactMark( qhandle_t markShader, const vec3_t origin, const vec3_t dir, 
;131:				   float orientation, float red, float green, float blue, float alpha,
;132:				   qboolean alphaFade, float radius, qboolean temporary ) {
line 143
;133:	vec3_t			axis[3];
;134:	float			texCoordScale;
;135:	vec3_t			originalPoints[4];
;136:	byte			colors[4];
;137:	int				i, j;
;138:	int				numFragments;
;139:	markFragment_t	markFragments[MAX_MARK_FRAGMENTS], *mf;
;140:	vec3_t			markPoints[MAX_MARK_POINTS];
;141:	vec3_t			projection;
;142:
;143:	if ( !cg_addMarks.integer ) {
ADDRGP4 cg_addMarks+12
INDIRI4
CNSTI4 0
NEI4 $93
line 144
;144:		return;
ADDRGP4 $92
JUMPV
LABELV $93
line 147
;145:	}
;146:
;147:	if ( radius <= 0 ) {
ADDRFP4 36
INDIRF4
CNSTF4 0
GTF4 $96
line 148
;148:		CG_Error( "CG_ImpactMark called with <= 0 radius" );
ADDRGP4 $98
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 149
;149:	}
LABELV $96
line 156
;150:
;151:	//if ( markTotal >= MAX_MARK_POLYS ) {
;152:	//	return;
;153:	//}
;154:
;155:	// create the texture axis
;156:	VectorNormalize2( dir, axis[0] );
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 VectorNormalize2
CALLF4
pop
line 157
;157:	PerpendicularVector( axis[1], axis[0] );
ADDRLP4 0+12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 PerpendicularVector
CALLV
pop
line 158
;158:	RotatePointAroundVector( axis[2], axis[0], axis[1], orientation );
ADDRLP4 0+24
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 0+12
ARGP4
ADDRFP4 12
INDIRF4
ARGF4
ADDRGP4 RotatePointAroundVector
CALLV
pop
line 159
;159:	CrossProduct( axis[0], axis[2], axis[1] );
ADDRLP4 0
ARGP4
ADDRLP4 0+24
ARGP4
ADDRLP4 0+12
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 161
;160:
;161:	texCoordScale = 0.5 * 1.0 / radius;
ADDRLP4 48
CNSTF4 1056964608
ADDRFP4 36
INDIRF4
DIVF4
ASGNF4
line 164
;162:
;163:	// create the full polygon
;164:	for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 44
CNSTI4 0
ASGNI4
LABELV $104
line 165
;165:		originalPoints[0][i] = origin[i] - radius * axis[1][i] - radius * axis[2][i];
ADDRLP4 5752
ADDRLP4 44
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 5756
ADDRFP4 36
INDIRF4
ASGNF4
ADDRLP4 5752
INDIRI4
ADDRLP4 4664
ADDP4
ADDRLP4 5752
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRF4
ADDRLP4 5756
INDIRF4
ADDRLP4 5752
INDIRI4
ADDRLP4 0+12
ADDP4
INDIRF4
MULF4
SUBF4
ADDRLP4 5756
INDIRF4
ADDRLP4 5752
INDIRI4
ADDRLP4 0+24
ADDP4
INDIRF4
MULF4
SUBF4
ASGNF4
line 166
;166:		originalPoints[1][i] = origin[i] + radius * axis[1][i] - radius * axis[2][i];
ADDRLP4 5760
ADDRLP4 44
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 5764
ADDRFP4 36
INDIRF4
ASGNF4
ADDRLP4 5760
INDIRI4
ADDRLP4 4664+12
ADDP4
ADDRLP4 5760
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRF4
ADDRLP4 5764
INDIRF4
ADDRLP4 5760
INDIRI4
ADDRLP4 0+12
ADDP4
INDIRF4
MULF4
ADDF4
ADDRLP4 5764
INDIRF4
ADDRLP4 5760
INDIRI4
ADDRLP4 0+24
ADDP4
INDIRF4
MULF4
SUBF4
ASGNF4
line 167
;167:		originalPoints[2][i] = origin[i] + radius * axis[1][i] + radius * axis[2][i];
ADDRLP4 5768
ADDRLP4 44
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 5772
ADDRFP4 36
INDIRF4
ASGNF4
ADDRLP4 5768
INDIRI4
ADDRLP4 4664+24
ADDP4
ADDRLP4 5768
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRF4
ADDRLP4 5772
INDIRF4
ADDRLP4 5768
INDIRI4
ADDRLP4 0+12
ADDP4
INDIRF4
MULF4
ADDF4
ADDRLP4 5772
INDIRF4
ADDRLP4 5768
INDIRI4
ADDRLP4 0+24
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 168
;168:		originalPoints[3][i] = origin[i] - radius * axis[1][i] + radius * axis[2][i];
ADDRLP4 5776
ADDRLP4 44
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 5780
ADDRFP4 36
INDIRF4
ASGNF4
ADDRLP4 5776
INDIRI4
ADDRLP4 4664+36
ADDP4
ADDRLP4 5776
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRF4
ADDRLP4 5780
INDIRF4
ADDRLP4 5776
INDIRI4
ADDRLP4 0+12
ADDP4
INDIRF4
MULF4
SUBF4
ADDRLP4 5780
INDIRF4
ADDRLP4 5776
INDIRI4
ADDRLP4 0+24
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 169
;169:	}
LABELV $105
line 164
ADDRLP4 44
ADDRLP4 44
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 3
LTI4 $104
line 172
;170:
;171:	// get the fragments
;172:	VectorScale( dir, -20, projection );
ADDRLP4 5752
CNSTF4 3248488448
ASGNF4
ADDRLP4 5756
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 4716
ADDRLP4 5752
INDIRF4
ADDRLP4 5756
INDIRP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 4716+4
ADDRLP4 5752
INDIRF4
ADDRLP4 5756
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 4716+8
CNSTF4 3248488448
ADDRFP4 8
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
MULF4
ASGNF4
line 173
;173:	numFragments = trap_CM_MarkFragments( 4, (void *)originalPoints,
CNSTI4 4
ARGI4
ADDRLP4 4664
ARGP4
ADDRLP4 4716
ARGP4
CNSTI4 384
ARGI4
ADDRLP4 56
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 4728
ARGP4
ADDRLP4 5760
ADDRGP4 trap_CM_MarkFragments
CALLI4
ASGNI4
ADDRLP4 4712
ADDRLP4 5760
INDIRI4
ASGNI4
line 177
;174:					projection, MAX_MARK_POINTS, markPoints[0],
;175:					MAX_MARK_FRAGMENTS, markFragments );
;176:
;177:	colors[0] = red * 255;
ADDRLP4 5768
CNSTF4 1132396544
ADDRFP4 16
INDIRF4
MULF4
ASGNF4
ADDRLP4 5772
CNSTF4 1325400064
ASGNF4
ADDRLP4 5768
INDIRF4
ADDRLP4 5772
INDIRF4
LTF4 $122
ADDRLP4 5764
ADDRLP4 5768
INDIRF4
ADDRLP4 5772
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $123
JUMPV
LABELV $122
ADDRLP4 5764
ADDRLP4 5768
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $123
ADDRLP4 52
ADDRLP4 5764
INDIRU4
CVUU1 4
ASGNU1
line 178
;178:	colors[1] = green * 255;
ADDRLP4 5780
CNSTF4 1132396544
ADDRFP4 20
INDIRF4
MULF4
ASGNF4
ADDRLP4 5784
CNSTF4 1325400064
ASGNF4
ADDRLP4 5780
INDIRF4
ADDRLP4 5784
INDIRF4
LTF4 $126
ADDRLP4 5776
ADDRLP4 5780
INDIRF4
ADDRLP4 5784
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $127
JUMPV
LABELV $126
ADDRLP4 5776
ADDRLP4 5780
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $127
ADDRLP4 52+1
ADDRLP4 5776
INDIRU4
CVUU1 4
ASGNU1
line 179
;179:	colors[2] = blue * 255;
ADDRLP4 5792
CNSTF4 1132396544
ADDRFP4 24
INDIRF4
MULF4
ASGNF4
ADDRLP4 5796
CNSTF4 1325400064
ASGNF4
ADDRLP4 5792
INDIRF4
ADDRLP4 5796
INDIRF4
LTF4 $130
ADDRLP4 5788
ADDRLP4 5792
INDIRF4
ADDRLP4 5796
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $131
JUMPV
LABELV $130
ADDRLP4 5788
ADDRLP4 5792
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $131
ADDRLP4 52+2
ADDRLP4 5788
INDIRU4
CVUU1 4
ASGNU1
line 180
;180:	colors[3] = alpha * 255;
ADDRLP4 5804
CNSTF4 1132396544
ADDRFP4 28
INDIRF4
MULF4
ASGNF4
ADDRLP4 5808
CNSTF4 1325400064
ASGNF4
ADDRLP4 5804
INDIRF4
ADDRLP4 5808
INDIRF4
LTF4 $134
ADDRLP4 5800
ADDRLP4 5804
INDIRF4
ADDRLP4 5808
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $135
JUMPV
LABELV $134
ADDRLP4 5800
ADDRLP4 5804
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $135
ADDRLP4 52+3
ADDRLP4 5800
INDIRU4
CVUU1 4
ASGNU1
line 182
;181:
;182:	for ( i = 0, mf = markFragments ; i < numFragments ; i++, mf++ ) {
ADDRLP4 44
CNSTI4 0
ASGNI4
ADDRLP4 40
ADDRLP4 4728
ASGNP4
ADDRGP4 $139
JUMPV
LABELV $136
line 189
;183:		polyVert_t	*v;
;184:		polyVert_t	verts[MAX_VERTS_ON_POLY];
;185:		markPoly_t	*mark;
;186:
;187:		// we have an upper limit on the complexity of polygons
;188:		// that we store persistantly
;189:		if ( mf->numPoints > MAX_VERTS_ON_POLY ) {
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 10
LEI4 $140
line 190
;190:			mf->numPoints = MAX_VERTS_ON_POLY;
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 10
ASGNI4
line 191
;191:		}
LABELV $140
line 192
;192:		for ( j = 0, v = verts ; j < mf->numPoints ; j++, v++ ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 5812
ADDRLP4 5820
ASGNP4
ADDRGP4 $145
JUMPV
LABELV $142
line 195
;193:			vec3_t		delta;
;194:
;195:			VectorCopy( markPoints[mf->firstPoint + j], v->xyz );
ADDRLP4 5812
INDIRP4
CNSTI4 12
ADDRLP4 40
INDIRP4
INDIRI4
ADDRLP4 36
INDIRI4
ADDI4
MULI4
ADDRLP4 56
ADDP4
INDIRB
ASGNB 12
line 197
;196:
;197:			VectorSubtract( v->xyz, origin, delta );
ADDRLP4 6076
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 6060
ADDRLP4 5812
INDIRP4
INDIRF4
ADDRLP4 6076
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 6080
CNSTI4 4
ASGNI4
ADDRLP4 6060+4
ADDRLP4 5812
INDIRP4
ADDRLP4 6080
INDIRI4
ADDP4
INDIRF4
ADDRLP4 6076
INDIRP4
ADDRLP4 6080
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 6084
CNSTI4 8
ASGNI4
ADDRLP4 6060+8
ADDRLP4 5812
INDIRP4
ADDRLP4 6084
INDIRI4
ADDP4
INDIRF4
ADDRFP4 4
INDIRP4
ADDRLP4 6084
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 198
;198:			v->st[0] = 0.5 + DotProduct( delta, axis[1] ) * texCoordScale;
ADDRLP4 5812
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 6060
INDIRF4
ADDRLP4 0+12
INDIRF4
MULF4
ADDRLP4 6060+4
INDIRF4
ADDRLP4 0+12+4
INDIRF4
MULF4
ADDF4
ADDRLP4 6060+8
INDIRF4
ADDRLP4 0+12+8
INDIRF4
MULF4
ADDF4
ADDRLP4 48
INDIRF4
MULF4
CNSTF4 1056964608
ADDF4
ASGNF4
line 199
;199:			v->st[1] = 0.5 + DotProduct( delta, axis[2] ) * texCoordScale;
ADDRLP4 5812
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 6060
INDIRF4
ADDRLP4 0+24
INDIRF4
MULF4
ADDRLP4 6060+4
INDIRF4
ADDRLP4 0+24+4
INDIRF4
MULF4
ADDF4
ADDRLP4 6060+8
INDIRF4
ADDRLP4 0+24+8
INDIRF4
MULF4
ADDF4
ADDRLP4 48
INDIRF4
MULF4
CNSTF4 1056964608
ADDF4
ASGNF4
line 200
;200:			*(int *)v->modulate = *(int *)colors;
ADDRLP4 5812
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 52
INDIRI4
ASGNI4
line 201
;201:		}
LABELV $143
line 192
ADDRLP4 36
ADDRLP4 36
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 5812
ADDRLP4 5812
INDIRP4
CNSTI4 24
ADDP4
ASGNP4
LABELV $145
ADDRLP4 36
INDIRI4
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
LTI4 $142
line 204
;202:
;203:		// if it is a temporary (shadow) mark, add it immediately and forget about it
;204:		if ( temporary ) {
ADDRFP4 40
INDIRI4
CNSTI4 0
EQI4 $162
line 205
;205:			trap_R_AddPolyToScene( markShader, mf->numPoints, verts );
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ARGI4
ADDRLP4 5820
ARGP4
ADDRGP4 trap_R_AddPolyToScene
CALLV
pop
line 206
;206:			continue;
ADDRGP4 $137
JUMPV
LABELV $162
line 210
;207:		}
;208:
;209:		// otherwise save it persistantly
;210:		mark = CG_AllocMark();
ADDRLP4 6060
ADDRGP4 CG_AllocMark
CALLP4
ASGNP4
ADDRLP4 5816
ADDRLP4 6060
INDIRP4
ASGNP4
line 211
;211:		mark->time = cg.time;
ADDRLP4 5816
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 212
;212:		mark->alphaFade = alphaFade;
ADDRLP4 5816
INDIRP4
CNSTI4 16
ADDP4
ADDRFP4 32
INDIRI4
ASGNI4
line 213
;213:		mark->markShader = markShader;
ADDRLP4 5816
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 214
;214:		mark->poly.numVerts = mf->numPoints;
ADDRLP4 5816
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
line 215
;215:		mark->color[0] = red;
ADDRLP4 5816
INDIRP4
CNSTI4 20
ADDP4
ADDRFP4 16
INDIRF4
ASGNF4
line 216
;216:		mark->color[1] = green;
ADDRLP4 5816
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 20
INDIRF4
ASGNF4
line 217
;217:		mark->color[2] = blue;
ADDRLP4 5816
INDIRP4
CNSTI4 28
ADDP4
ADDRFP4 24
INDIRF4
ASGNF4
line 218
;218:		mark->color[3] = alpha;
ADDRLP4 5816
INDIRP4
CNSTI4 32
ADDP4
ADDRFP4 28
INDIRF4
ASGNF4
line 219
;219:		memcpy( mark->verts, verts, mf->numPoints * sizeof( verts[0] ) );
ADDRLP4 5816
INDIRP4
CNSTI4 48
ADDP4
ARGP4
ADDRLP4 5820
ARGP4
CNSTU4 24
ADDRLP4 40
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CVIU4 4
MULU4
CVUI4 4
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 220
;220:		markTotal++;
ADDRLP4 6064
ADDRGP4 markTotal
ASGNP4
ADDRLP4 6064
INDIRP4
ADDRLP4 6064
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 221
;221:	}
LABELV $137
line 182
ADDRLP4 44
ADDRLP4 44
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 40
ADDRLP4 40
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
LABELV $139
ADDRLP4 44
INDIRI4
ADDRLP4 4712
INDIRI4
LTI4 $136
line 222
;222:}
LABELV $92
endproc CG_ImpactMark 6088 28
export CG_AddMarks
proc CG_AddMarks 80 12
line 233
;223:
;224:
;225:/*
;226:===============
;227:CG_AddMarks
;228:===============
;229:*/
;230:#define	MARK_TOTAL_TIME		10000
;231:#define	MARK_FADE_TIME		1000
;232:
;233:void CG_AddMarks( void ) {
line 239
;234:	int			j;
;235:	markPoly_t	*mp, *next;
;236:	int			t;
;237:	int			fade;
;238:
;239:	if ( !cg_addMarks.integer ) {
ADDRGP4 cg_addMarks+12
INDIRI4
CNSTI4 0
NEI4 $166
line 240
;240:		return;
ADDRGP4 $165
JUMPV
LABELV $166
line 243
;241:	}
;242:
;243:	mp = cg_activeMarkPolys.nextMark;
ADDRLP4 0
ADDRGP4 cg_activeMarkPolys+4
INDIRP4
ASGNP4
line 244
;244:	for ( ; mp != &cg_activeMarkPolys ; mp = next ) {
ADDRGP4 $173
JUMPV
LABELV $170
line 247
;245:		// grab next now, so if the local entity is freed we
;246:		// still have it
;247:		next = mp->nextMark;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ASGNP4
line 250
;248:
;249:		// see if it is time to completely remove it
;250:		if ( cg.time > mp->time + MARK_TOTAL_TIME ) {
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 10000
ADDI4
LEI4 $174
line 251
;251:			CG_FreeMarkPoly( mp );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeMarkPoly
CALLV
pop
line 252
;252:			continue;
ADDRGP4 $171
JUMPV
LABELV $174
line 256
;253:		}
;254:
;255:		// fade out the energy bursts
;256:		if ( mp->markShader == cgs.media.energyMarkShader ) {
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ADDRGP4 cgs+152340+388
INDIRI4
NEI4 $177
line 258
;257:
;258:			fade = 450 - 450 * ( (cg.time - mp->time ) / 3000.0 );
ADDRLP4 20
CNSTF4 1138819072
ASGNF4
ADDRLP4 8
ADDRLP4 20
INDIRF4
ADDRLP4 20
INDIRF4
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
SUBI4
CVIF4 4
CNSTF4 1161527296
DIVF4
MULF4
SUBF4
CVFI4 4
ASGNI4
line 259
;259:			if ( fade < 255 ) {
ADDRLP4 8
INDIRI4
CNSTI4 255
GEI4 $182
line 260
;260:				if ( fade < 0 ) {
ADDRLP4 8
INDIRI4
CNSTI4 0
GEI4 $184
line 261
;261:					fade = 0;
ADDRLP4 8
CNSTI4 0
ASGNI4
line 262
;262:				}
LABELV $184
line 263
;263:				if ( mp->verts[0].modulate[0] != 0 ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRU1
CVUI4 1
CNSTI4 0
EQI4 $186
line 264
;264:					for ( j = 0 ; j < mp->poly.numVerts ; j++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $191
JUMPV
LABELV $188
line 265
;265:						mp->verts[j].modulate[0] = mp->color[0] * fade;
ADDRLP4 32
CNSTI4 20
ASGNI4
ADDRLP4 36
ADDRLP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRF4
ADDRLP4 8
INDIRI4
CVIF4 4
MULF4
ASGNF4
ADDRLP4 40
CNSTF4 1325400064
ASGNF4
ADDRLP4 36
INDIRF4
ADDRLP4 40
INDIRF4
LTF4 $193
ADDRLP4 24
ADDRLP4 36
INDIRF4
ADDRLP4 40
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $194
JUMPV
LABELV $193
ADDRLP4 24
ADDRLP4 36
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $194
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
ADDRLP4 32
INDIRI4
ADDP4
ADDRLP4 24
INDIRU4
CVUU1 4
ASGNU1
line 266
;266:						mp->verts[j].modulate[1] = mp->color[1] * fade;
ADDRLP4 52
CNSTI4 24
ASGNI4
ADDRLP4 56
ADDRLP4 0
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRF4
ADDRLP4 8
INDIRI4
CVIF4 4
MULF4
ASGNF4
ADDRLP4 60
CNSTF4 1325400064
ASGNF4
ADDRLP4 56
INDIRF4
ADDRLP4 60
INDIRF4
LTF4 $196
ADDRLP4 44
ADDRLP4 56
INDIRF4
ADDRLP4 60
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $197
JUMPV
LABELV $196
ADDRLP4 44
ADDRLP4 56
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $197
ADDRLP4 52
INDIRI4
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
CNSTI4 21
ADDP4
ADDRLP4 44
INDIRU4
CVUU1 4
ASGNU1
line 267
;267:						mp->verts[j].modulate[2] = mp->color[2] * fade;
ADDRLP4 72
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 8
INDIRI4
CVIF4 4
MULF4
ASGNF4
ADDRLP4 76
CNSTF4 1325400064
ASGNF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
LTF4 $199
ADDRLP4 64
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $200
JUMPV
LABELV $199
ADDRLP4 64
ADDRLP4 72
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $200
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
CNSTI4 22
ADDP4
ADDRLP4 64
INDIRU4
CVUU1 4
ASGNU1
line 268
;268:					}
LABELV $189
line 264
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $191
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
LTI4 $188
line 269
;269:				}
LABELV $186
line 270
;270:			}
LABELV $182
line 271
;271:		}
LABELV $177
line 274
;272:
;273:		// fade all marks out with time
;274:		t = mp->time + MARK_TOTAL_TIME - cg.time;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 10000
ADDI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
ASGNI4
line 275
;275:		if ( t < MARK_FADE_TIME ) {
ADDRLP4 12
INDIRI4
CNSTI4 1000
GEI4 $202
line 276
;276:			fade = 255 * t / MARK_FADE_TIME;
ADDRLP4 8
CNSTI4 255
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 1000
DIVI4
ASGNI4
line 277
;277:			if ( mp->alphaFade ) {
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 0
EQI4 $204
line 278
;278:				for ( j = 0 ; j < mp->poly.numVerts ; j++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $209
JUMPV
LABELV $206
line 279
;279:					mp->verts[j].modulate[3] = fade;
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
CNSTI4 23
ADDP4
ADDRLP4 8
INDIRI4
CVIU4 4
CVUU1 4
ASGNU1
line 280
;280:				}
LABELV $207
line 278
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $209
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
LTI4 $206
line 281
;281:			} else {
ADDRGP4 $205
JUMPV
LABELV $204
line 282
;282:				for ( j = 0 ; j < mp->poly.numVerts ; j++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $213
JUMPV
LABELV $210
line 283
;283:					mp->verts[j].modulate[0] = mp->color[0] * fade;
ADDRLP4 28
CNSTI4 20
ASGNI4
ADDRLP4 32
ADDRLP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRF4
ADDRLP4 8
INDIRI4
CVIF4 4
MULF4
ASGNF4
ADDRLP4 36
CNSTF4 1325400064
ASGNF4
ADDRLP4 32
INDIRF4
ADDRLP4 36
INDIRF4
LTF4 $215
ADDRLP4 20
ADDRLP4 32
INDIRF4
ADDRLP4 36
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $216
JUMPV
LABELV $215
ADDRLP4 20
ADDRLP4 32
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $216
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
ADDRLP4 28
INDIRI4
ADDP4
ADDRLP4 20
INDIRU4
CVUU1 4
ASGNU1
line 284
;284:					mp->verts[j].modulate[1] = mp->color[1] * fade;
ADDRLP4 48
CNSTI4 24
ASGNI4
ADDRLP4 52
ADDRLP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
ADDRLP4 8
INDIRI4
CVIF4 4
MULF4
ASGNF4
ADDRLP4 56
CNSTF4 1325400064
ASGNF4
ADDRLP4 52
INDIRF4
ADDRLP4 56
INDIRF4
LTF4 $218
ADDRLP4 40
ADDRLP4 52
INDIRF4
ADDRLP4 56
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $219
JUMPV
LABELV $218
ADDRLP4 40
ADDRLP4 52
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $219
ADDRLP4 48
INDIRI4
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
CNSTI4 21
ADDP4
ADDRLP4 40
INDIRU4
CVUU1 4
ASGNU1
line 285
;285:					mp->verts[j].modulate[2] = mp->color[2] * fade;
ADDRLP4 68
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 8
INDIRI4
CVIF4 4
MULF4
ASGNF4
ADDRLP4 72
CNSTF4 1325400064
ASGNF4
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
LTF4 $221
ADDRLP4 60
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $222
JUMPV
LABELV $221
ADDRLP4 60
ADDRLP4 68
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $222
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDP4
CNSTI4 22
ADDP4
ADDRLP4 60
INDIRU4
CVUU1 4
ASGNU1
line 286
;286:				}
LABELV $211
line 282
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $213
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
LTI4 $210
line 287
;287:			}
LABELV $205
line 288
;288:		}
LABELV $202
line 291
;289:
;290:
;291:		trap_R_AddPolyToScene( mp->markShader, mp->poly.numVerts, mp->verts );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ARGP4
ADDRGP4 trap_R_AddPolyToScene
CALLV
pop
line 292
;292:	}
LABELV $171
line 244
ADDRLP4 0
ADDRLP4 16
INDIRP4
ASGNP4
LABELV $173
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg_activeMarkPolys
CVPU4 4
NEU4 $170
line 293
;293:}
LABELV $165
endproc CG_AddMarks 80 12
data
align 4
LABELV shaderAnimNames
address $224
byte 4 0
skip 120
align 4
LABELV shaderAnimCounts
byte 4 23
skip 124
align 4
LABELV shaderAnimSTRatio
byte 4 1065353216
skip 124
export cl_numparticles
align 4
LABELV cl_numparticles
byte 4 1024
export initparticles
align 4
LABELV initparticles
byte 4 0
export CG_ClearParticles
code
proc CG_ClearParticles 28 12
line 397
;294:
;295:// cg_particles.c  
;296:
;297:#define BLOODRED	2
;298:#define EMISIVEFADE	3
;299:#define GREY75		4
;300:
;301:typedef struct particle_s
;302:{
;303:	struct particle_s	*next;
;304:
;305:	float		time;
;306:	float		endtime;
;307:
;308:	vec3_t		org;
;309:	vec3_t		vel;
;310:	vec3_t		accel;
;311:	int			color;
;312:	float		colorvel;
;313:	float		alpha;
;314:	float		alphavel;
;315:	int			type;
;316:	qhandle_t	pshader;
;317:	
;318:	float		height;
;319:	float		width;
;320:				
;321:	float		endheight;
;322:	float		endwidth;
;323:	
;324:	float		start;
;325:	float		end;
;326:
;327:	float		startfade;
;328:	qboolean	rotate;
;329:	int			snum;
;330:	
;331:	qboolean	link;
;332:
;333:	// Ridah
;334:	int			shaderAnim;
;335:	int			roll;
;336:
;337:	int			accumroll;
;338:
;339:} cparticle_t;
;340:
;341:typedef enum
;342:{
;343:	P_NONE,
;344:	P_WEATHER,
;345:	P_FLAT,
;346:	P_SMOKE,
;347:	P_ROTATE,
;348:	P_WEATHER_TURBULENT,
;349:	P_ANIM,	// Ridah
;350:	P_BAT,
;351:	P_BLEED,
;352:	P_FLAT_SCALEUP,
;353:	P_FLAT_SCALEUP_FADE,
;354:	P_WEATHER_FLURRY,
;355:	P_SMOKE_IMPACT,
;356:	P_BUBBLE,
;357:	P_BUBBLE_TURBULENT,
;358:	P_SPRITE
;359:} particle_type_t;
;360:
;361:#define	MAX_SHADER_ANIMS		32
;362:#define	MAX_SHADER_ANIM_FRAMES	64
;363:
;364:static char *shaderAnimNames[MAX_SHADER_ANIMS] = {
;365:	"explode1",
;366:	NULL
;367:};
;368:static qhandle_t shaderAnims[MAX_SHADER_ANIMS][MAX_SHADER_ANIM_FRAMES];
;369:static int	shaderAnimCounts[MAX_SHADER_ANIMS] = {
;370:	23
;371:};
;372:static float	shaderAnimSTRatio[MAX_SHADER_ANIMS] = {
;373:	1.0f
;374:};
;375:static int	numShaderAnims;
;376:// done.
;377:
;378:#define		PARTICLE_GRAVITY	40
;379:#define		MAX_PARTICLES	1024
;380:
;381:cparticle_t	*active_particles, *free_particles;
;382:cparticle_t	particles[MAX_PARTICLES];
;383:int		cl_numparticles = MAX_PARTICLES;
;384:
;385:qboolean		initparticles = qfalse;
;386:vec3_t			pvforward, pvright, pvup;
;387:vec3_t			rforward, rright, rup;
;388:
;389:float			oldtime;
;390:
;391:/*
;392:===============
;393:CL_ClearParticles
;394:===============
;395:*/
;396:void CG_ClearParticles (void)
;397:{
line 400
;398:	int		i;
;399:
;400:	memset( particles, 0, sizeof(particles) );
ADDRGP4 particles
ARGP4
CNSTI4 0
ARGI4
CNSTI4 126976
ARGI4
ADDRGP4 memset
CALLP4
pop
line 402
;401:
;402:	free_particles = &particles[0];
ADDRGP4 free_particles
ADDRGP4 particles
ASGNP4
line 403
;403:	active_particles = NULL;
ADDRGP4 active_particles
CNSTP4 0
ASGNP4
line 405
;404:
;405:	for (i=0 ;i<cl_numparticles ; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $229
JUMPV
LABELV $226
line 406
;406:	{
line 407
;407:		particles[i].next = &particles[i+1];
ADDRLP4 4
CNSTI4 124
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 4
INDIRI4
ADDRGP4 particles
ADDP4
ADDRLP4 4
INDIRI4
ADDRGP4 particles+124
ADDP4
ASGNP4
line 408
;408:		particles[i].type = 0;
CNSTI4 124
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 particles+64
ADDP4
CNSTI4 0
ASGNI4
line 409
;409:	}
LABELV $227
line 405
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $229
ADDRLP4 0
INDIRI4
ADDRGP4 cl_numparticles
INDIRI4
LTI4 $226
line 410
;410:	particles[cl_numparticles-1].next = NULL;
CNSTI4 124
ADDRGP4 cl_numparticles
INDIRI4
MULI4
ADDRGP4 particles-124
ADDP4
CNSTP4 0
ASGNP4
line 412
;411:
;412:	oldtime = cg.time;
ADDRGP4 oldtime
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 415
;413:
;414:	// Ridah, init the shaderAnims
;415:	for (i=0; shaderAnimNames[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $237
JUMPV
LABELV $234
line 418
;416:		int j;
;417:
;418:		for (j=0; j<shaderAnimCounts[i]; j++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $241
JUMPV
LABELV $238
line 419
;419:			shaderAnims[i][j] = trap_R_RegisterShader( va("%s%i", shaderAnimNames[i], j+1) );
ADDRGP4 $242
ARGP4
ADDRLP4 12
CNSTI4 2
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
LSHI4
ADDRGP4 shaderAnimNames
ADDP4
INDIRP4
ARGP4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 12
INDIRI4
LSHI4
ADDRLP4 0
INDIRI4
CNSTI4 8
LSHI4
ADDRGP4 shaderAnims
ADDP4
ADDP4
ADDRLP4 24
INDIRI4
ASGNI4
line 420
;420:		}
LABELV $239
line 418
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $241
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimCounts
ADDP4
INDIRI4
LTI4 $238
line 421
;421:	}
LABELV $235
line 415
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $237
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimNames
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $234
line 422
;422:	numShaderAnims = i;
ADDRGP4 numShaderAnims
ADDRLP4 0
INDIRI4
ASGNI4
line 425
;423:	// done.
;424:
;425:	initparticles = qtrue;
ADDRGP4 initparticles
CNSTI4 1
ASGNI4
line 426
;426:}
LABELV $225
endproc CG_ClearParticles 28 12
export CG_AddParticleToScene
proc CG_AddParticleToScene 472 16
line 435
;427:
;428:
;429:/*
;430:=====================
;431:CG_AddParticleToScene
;432:=====================
;433:*/
;434:void CG_AddParticleToScene (cparticle_t *p, vec3_t org, float alpha)
;435:{
line 448
;436:
;437:	vec3_t		point;
;438:	polyVert_t	verts[4];
;439:	float		width;
;440:	float		height;
;441:	float		time, time2;
;442:	float		ratio;
;443:	float		invratio;
;444:	vec3_t		color;
;445:	polyVert_t	TRIverts[3];
;446:	vec3_t		rright2, rup2;
;447:
;448:	if (p->type == P_WEATHER || p->type == P_WEATHER_TURBULENT || p->type == P_WEATHER_FLURRY
ADDRLP4 240
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 240
INDIRI4
CNSTI4 1
EQI4 $249
ADDRLP4 240
INDIRI4
CNSTI4 5
EQI4 $249
ADDRLP4 240
INDIRI4
CNSTI4 11
EQI4 $249
ADDRLP4 240
INDIRI4
CNSTI4 13
EQI4 $249
ADDRLP4 240
INDIRI4
CNSTI4 14
NEI4 $244
LABELV $249
line 450
;449:		|| p->type == P_BUBBLE || p->type == P_BUBBLE_TURBULENT)
;450:	{// create a front facing polygon
line 452
;451:			
;452:		if (p->type != P_WEATHER_FLURRY)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 11
EQI4 $250
line 453
;453:		{
line 454
;454:			if (p->type == P_BUBBLE || p->type == P_BUBBLE_TURBULENT)
ADDRLP4 244
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 244
INDIRI4
CNSTI4 13
EQI4 $254
ADDRLP4 244
INDIRI4
CNSTI4 14
NEI4 $252
LABELV $254
line 455
;455:			{
line 456
;456:				if (org[2] > p->end)			
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
LEF4 $253
line 457
;457:				{	
line 458
;458:					p->time = cg.time;	
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 459
;459:					VectorCopy (org, p->org); // Ridah, fixes rare snow flakes that flicker on the ground
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 461
;460:									
;461:					p->org[2] = ( p->start + crandom () * 4 );
ADDRLP4 248
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 252
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 252
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 252
INDIRP4
CNSTI4 88
ADDP4
INDIRF4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 248
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 464
;462:					
;463:					
;464:					if (p->type == P_BUBBLE_TURBULENT)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 14
NEI4 $253
line 465
;465:					{
line 466
;466:						p->vel[0] = crandom() * 4;
ADDRLP4 256
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 256
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 467
;467:						p->vel[1] = crandom() * 4;
ADDRLP4 260
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 260
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 468
;468:					}
line 470
;469:				
;470:				}
line 471
;471:			}
ADDRGP4 $253
JUMPV
LABELV $252
line 473
;472:			else
;473:			{
line 474
;474:				if (org[2] < p->end)			
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
GEF4 $260
line 475
;475:				{	
line 476
;476:					p->time = cg.time;	
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 477
;477:					VectorCopy (org, p->org); // Ridah, fixes rare snow flakes that flicker on the ground
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
ADDRGP4 $264
JUMPV
LABELV $263
line 480
;478:									
;479:					while (p->org[2] < p->end) 
;480:					{
line 481
;481:						p->org[2] += (p->start - p->end); 
ADDRLP4 248
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 252
ADDRLP4 248
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 252
INDIRP4
ADDRLP4 252
INDIRP4
INDIRF4
ADDRLP4 248
INDIRP4
CNSTI4 88
ADDP4
INDIRF4
ADDRLP4 248
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
ADDF4
ASGNF4
line 482
;482:					}
LABELV $264
line 479
ADDRLP4 248
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 248
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRLP4 248
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
LTF4 $263
line 485
;483:					
;484:					
;485:					if (p->type == P_WEATHER_TURBULENT)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 5
NEI4 $266
line 486
;486:					{
line 487
;487:						p->vel[0] = crandom() * 16;
ADDRLP4 252
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 252
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 488
;488:						p->vel[1] = crandom() * 16;
ADDRLP4 256
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 256
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 489
;489:					}
LABELV $266
line 491
;490:				
;491:				}
LABELV $260
line 492
;492:			}
LABELV $253
line 496
;493:			
;494:
;495:			// Rafael snow pvs check
;496:			if (!p->link)
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 0
NEI4 $268
line 497
;497:				return;
ADDRGP4 $243
JUMPV
LABELV $268
line 499
;498:
;499:			p->alpha = 1;
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 500
;500:		}
LABELV $250
line 503
;501:		
;502:		// Ridah, had to do this or MAX_POLYS is being exceeded in village1.bsp
;503:		if (Distance( cg.snap->ps.origin, org ) > 1024) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 64
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 244
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 244
INDIRF4
CNSTF4 1149239296
LEF4 $270
line 504
;504:			return;
ADDRGP4 $243
JUMPV
LABELV $270
line 508
;505:		}
;506:		// done.
;507:	
;508:		if (p->type == P_BUBBLE || p->type == P_BUBBLE_TURBULENT)
ADDRLP4 248
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 248
INDIRI4
CNSTI4 13
EQI4 $275
ADDRLP4 248
INDIRI4
CNSTI4 14
NEI4 $273
LABELV $275
line 509
;509:		{
line 510
;510:			VectorMA (org, -p->height, pvup, point);	
ADDRLP4 252
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 256
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 252
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 256
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 252
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 256
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 511
;511:			VectorMA (point, -p->width, pvright, point);	
ADDRLP4 260
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 260
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 260
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 512
;512:			VectorCopy (point, verts[0].xyz);	
ADDRLP4 12
ADDRLP4 0
INDIRB
ASGNB 12
line 513
;513:			verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 514
;514:			verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 515
;515:			verts[0].modulate[0] = 255;	
ADDRLP4 12+20
CNSTU1 255
ASGNU1
line 516
;516:			verts[0].modulate[1] = 255;	
ADDRLP4 12+20+1
CNSTU1 255
ASGNU1
line 517
;517:			verts[0].modulate[2] = 255;	
ADDRLP4 12+20+2
CNSTU1 255
ASGNU1
line 518
;518:			verts[0].modulate[3] = 255 * p->alpha;	
ADDRLP4 268
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 272
CNSTF4 1325400064
ASGNF4
ADDRLP4 268
INDIRF4
ADDRLP4 272
INDIRF4
LTF4 $297
ADDRLP4 264
ADDRLP4 268
INDIRF4
ADDRLP4 272
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $298
JUMPV
LABELV $297
ADDRLP4 264
ADDRLP4 268
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $298
ADDRLP4 12+20+3
ADDRLP4 264
INDIRU4
CVUU1 4
ASGNU1
line 520
;519:
;520:			VectorMA (org, -p->height, pvup, point);	
ADDRLP4 276
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 280
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 276
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 280
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 276
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 280
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 521
;521:			VectorMA (point, p->width, pvright, point);	
ADDRLP4 284
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 284
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 284
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 522
;522:			VectorCopy (point, verts[1].xyz);	
ADDRLP4 12+24
ADDRLP4 0
INDIRB
ASGNB 12
line 523
;523:			verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 524
;524:			verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 525
;525:			verts[1].modulate[0] = 255;	
ADDRLP4 12+24+20
CNSTU1 255
ASGNU1
line 526
;526:			verts[1].modulate[1] = 255;	
ADDRLP4 12+24+20+1
CNSTU1 255
ASGNU1
line 527
;527:			verts[1].modulate[2] = 255;	
ADDRLP4 12+24+20+2
CNSTU1 255
ASGNU1
line 528
;528:			verts[1].modulate[3] = 255 * p->alpha;	
ADDRLP4 292
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 296
CNSTF4 1325400064
ASGNF4
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
LTF4 $327
ADDRLP4 288
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $328
JUMPV
LABELV $327
ADDRLP4 288
ADDRLP4 292
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $328
ADDRLP4 12+24+20+3
ADDRLP4 288
INDIRU4
CVUU1 4
ASGNU1
line 530
;529:
;530:			VectorMA (org, p->height, pvup, point);	
ADDRLP4 300
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 304
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 300
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 304
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 300
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 304
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 531
;531:			VectorMA (point, p->width, pvright, point);	
ADDRLP4 308
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 308
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 308
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 532
;532:			VectorCopy (point, verts[2].xyz);	
ADDRLP4 12+48
ADDRLP4 0
INDIRB
ASGNB 12
line 533
;533:			verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 534
;534:			verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 535
;535:			verts[2].modulate[0] = 255;	
ADDRLP4 12+48+20
CNSTU1 255
ASGNU1
line 536
;536:			verts[2].modulate[1] = 255;	
ADDRLP4 12+48+20+1
CNSTU1 255
ASGNU1
line 537
;537:			verts[2].modulate[2] = 255;	
ADDRLP4 12+48+20+2
CNSTU1 255
ASGNU1
line 538
;538:			verts[2].modulate[3] = 255 * p->alpha;	
ADDRLP4 316
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 320
CNSTF4 1325400064
ASGNF4
ADDRLP4 316
INDIRF4
ADDRLP4 320
INDIRF4
LTF4 $357
ADDRLP4 312
ADDRLP4 316
INDIRF4
ADDRLP4 320
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $358
JUMPV
LABELV $357
ADDRLP4 312
ADDRLP4 316
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $358
ADDRLP4 12+48+20+3
ADDRLP4 312
INDIRU4
CVUU1 4
ASGNU1
line 540
;539:
;540:			VectorMA (org, p->height, pvup, point);	
ADDRLP4 324
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 328
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 324
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 328
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 324
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 328
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 541
;541:			VectorMA (point, -p->width, pvright, point);	
ADDRLP4 332
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 332
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 332
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 542
;542:			VectorCopy (point, verts[3].xyz);	
ADDRLP4 12+72
ADDRLP4 0
INDIRB
ASGNB 12
line 543
;543:			verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 544
;544:			verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 545
;545:			verts[3].modulate[0] = 255;	
ADDRLP4 12+72+20
CNSTU1 255
ASGNU1
line 546
;546:			verts[3].modulate[1] = 255;	
ADDRLP4 12+72+20+1
CNSTU1 255
ASGNU1
line 547
;547:			verts[3].modulate[2] = 255;	
ADDRLP4 12+72+20+2
CNSTU1 255
ASGNU1
line 548
;548:			verts[3].modulate[3] = 255 * p->alpha;	
ADDRLP4 340
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 344
CNSTF4 1325400064
ASGNF4
ADDRLP4 340
INDIRF4
ADDRLP4 344
INDIRF4
LTF4 $387
ADDRLP4 336
ADDRLP4 340
INDIRF4
ADDRLP4 344
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $388
JUMPV
LABELV $387
ADDRLP4 336
ADDRLP4 340
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $388
ADDRLP4 12+72+20+3
ADDRLP4 336
INDIRU4
CVUU1 4
ASGNU1
line 549
;549:		}
ADDRGP4 $245
JUMPV
LABELV $273
line 551
;550:		else
;551:		{
line 552
;552:			VectorMA (org, -p->height, pvup, point);	
ADDRLP4 252
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 256
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 252
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 256
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 252
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 256
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 553
;553:			VectorMA (point, -p->width, pvright, point);	
ADDRLP4 260
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 260
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 260
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 554
;554:			VectorCopy( point, TRIverts[0].xyz );
ADDRLP4 108
ADDRLP4 0
INDIRB
ASGNB 12
line 555
;555:			TRIverts[0].st[0] = 1;
ADDRLP4 108+12
CNSTF4 1065353216
ASGNF4
line 556
;556:			TRIverts[0].st[1] = 0;
ADDRLP4 108+12+4
CNSTF4 0
ASGNF4
line 557
;557:			TRIverts[0].modulate[0] = 255;
ADDRLP4 108+20
CNSTU1 255
ASGNU1
line 558
;558:			TRIverts[0].modulate[1] = 255;
ADDRLP4 108+20+1
CNSTU1 255
ASGNU1
line 559
;559:			TRIverts[0].modulate[2] = 255;
ADDRLP4 108+20+2
CNSTU1 255
ASGNU1
line 560
;560:			TRIverts[0].modulate[3] = 255 * p->alpha;	
ADDRLP4 268
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 272
CNSTF4 1325400064
ASGNF4
ADDRLP4 268
INDIRF4
ADDRLP4 272
INDIRF4
LTF4 $410
ADDRLP4 264
ADDRLP4 268
INDIRF4
ADDRLP4 272
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $411
JUMPV
LABELV $410
ADDRLP4 264
ADDRLP4 268
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $411
ADDRLP4 108+20+3
ADDRLP4 264
INDIRU4
CVUU1 4
ASGNU1
line 562
;561:
;562:			VectorMA (org, p->height, pvup, point);	
ADDRLP4 276
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 280
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 276
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 280
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 276
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 280
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 563
;563:			VectorMA (point, -p->width, pvright, point);	
ADDRLP4 284
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 284
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 284
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 564
;564:			VectorCopy (point, TRIverts[1].xyz);	
ADDRLP4 108+24
ADDRLP4 0
INDIRB
ASGNB 12
line 565
;565:			TRIverts[1].st[0] = 0;
ADDRLP4 108+24+12
CNSTF4 0
ASGNF4
line 566
;566:			TRIverts[1].st[1] = 0;
ADDRLP4 108+24+12+4
CNSTF4 0
ASGNF4
line 567
;567:			TRIverts[1].modulate[0] = 255;
ADDRLP4 108+24+20
CNSTU1 255
ASGNU1
line 568
;568:			TRIverts[1].modulate[1] = 255;
ADDRLP4 108+24+20+1
CNSTU1 255
ASGNU1
line 569
;569:			TRIverts[1].modulate[2] = 255;
ADDRLP4 108+24+20+2
CNSTU1 255
ASGNU1
line 570
;570:			TRIverts[1].modulate[3] = 255 * p->alpha;	
ADDRLP4 292
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 296
CNSTF4 1325400064
ASGNF4
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
LTF4 $440
ADDRLP4 288
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $441
JUMPV
LABELV $440
ADDRLP4 288
ADDRLP4 292
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $441
ADDRLP4 108+24+20+3
ADDRLP4 288
INDIRU4
CVUU1 4
ASGNU1
line 572
;571:
;572:			VectorMA (org, p->height, pvup, point);	
ADDRLP4 300
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 304
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 300
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 304
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 300
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 304
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 573
;573:			VectorMA (point, p->width, pvright, point);	
ADDRLP4 308
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 308
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 308
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 574
;574:			VectorCopy (point, TRIverts[2].xyz);	
ADDRLP4 108+48
ADDRLP4 0
INDIRB
ASGNB 12
line 575
;575:			TRIverts[2].st[0] = 0;
ADDRLP4 108+48+12
CNSTF4 0
ASGNF4
line 576
;576:			TRIverts[2].st[1] = 1;
ADDRLP4 108+48+12+4
CNSTF4 1065353216
ASGNF4
line 577
;577:			TRIverts[2].modulate[0] = 255;
ADDRLP4 108+48+20
CNSTU1 255
ASGNU1
line 578
;578:			TRIverts[2].modulate[1] = 255;
ADDRLP4 108+48+20+1
CNSTU1 255
ASGNU1
line 579
;579:			TRIverts[2].modulate[2] = 255;
ADDRLP4 108+48+20+2
CNSTU1 255
ASGNU1
line 580
;580:			TRIverts[2].modulate[3] = 255 * p->alpha;	
ADDRLP4 316
CNSTF4 1132396544
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 320
CNSTF4 1325400064
ASGNF4
ADDRLP4 316
INDIRF4
ADDRLP4 320
INDIRF4
LTF4 $470
ADDRLP4 312
ADDRLP4 316
INDIRF4
ADDRLP4 320
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $471
JUMPV
LABELV $470
ADDRLP4 312
ADDRLP4 316
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $471
ADDRLP4 108+48+20+3
ADDRLP4 312
INDIRU4
CVUU1 4
ASGNU1
line 581
;581:		}
line 583
;582:	
;583:	}
ADDRGP4 $245
JUMPV
LABELV $244
line 584
;584:	else if (p->type == P_SPRITE)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 15
NEI4 $472
line 585
;585:	{
line 589
;586:		vec3_t	rr, ru;
;587:		vec3_t	rotate_ang;
;588:
;589:		VectorSet (color, 1.0, 1.0, 0.5);
ADDRLP4 280
CNSTF4 1065353216
ASGNF4
ADDRLP4 184
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 184+8
CNSTF4 1056964608
ASGNF4
line 590
;590:		time = cg.time - p->time;
ADDRLP4 232
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 591
;591:		time2 = p->endtime - p->time;
ADDRLP4 284
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 236
ADDRLP4 284
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 284
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 592
;592:		ratio = time / time2;
ADDRLP4 200
ADDRLP4 232
INDIRF4
ADDRLP4 236
INDIRF4
DIVF4
ASGNF4
line 594
;593:
;594:		width = p->width + ( ratio * ( p->endwidth - p->width) );
ADDRLP4 288
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 292
ADDRLP4 288
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ASGNF4
ADDRLP4 196
ADDRLP4 292
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 288
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ADDRLP4 292
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 595
;595:		height = p->height + ( ratio * ( p->endheight - p->height) );
ADDRLP4 296
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 300
ADDRLP4 296
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ASGNF4
ADDRLP4 180
ADDRLP4 300
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 296
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ADDRLP4 300
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 597
;596:
;597:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $477
line 598
;598:			vectoangles( cg.refdef.viewaxis[0], rotate_ang );
ADDRGP4 cg+109044+36
ARGP4
ADDRLP4 268
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 599
;599:			rotate_ang[ROLL] += p->roll;
ADDRLP4 268+8
ADDRLP4 268+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 600
;600:			AngleVectors ( rotate_ang, NULL, rr, ru);
ADDRLP4 268
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 256
ARGP4
ADDRLP4 244
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 601
;601:		}
LABELV $477
line 603
;602:
;603:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $482
line 604
;604:			VectorMA (org, -height, ru, point);	
ADDRLP4 304
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 308
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 304
INDIRP4
INDIRF4
ADDRLP4 244
INDIRF4
ADDRLP4 308
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 304
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 244+4
INDIRF4
ADDRLP4 308
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 244+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 605
;605:			VectorMA (point, -width, rr, point);	
ADDRLP4 312
ADDRLP4 196
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 256
INDIRF4
ADDRLP4 312
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 256+4
INDIRF4
ADDRLP4 312
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 256+8
INDIRF4
ADDRLP4 196
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 606
;606:		} else {
ADDRGP4 $483
JUMPV
LABELV $482
line 607
;607:			VectorMA (org, -height, pvup, point);	
ADDRLP4 304
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 308
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 304
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 308
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 304
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 308
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 608
;608:			VectorMA (point, -width, pvright, point);	
ADDRLP4 312
ADDRLP4 196
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 312
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 312
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRLP4 196
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 609
;609:		}
LABELV $483
line 610
;610:		VectorCopy (point, verts[0].xyz);	
ADDRLP4 12
ADDRLP4 0
INDIRB
ASGNB 12
line 611
;611:		verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 612
;612:		verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 613
;613:		verts[0].modulate[0] = 255;	
ADDRLP4 12+20
CNSTU1 255
ASGNU1
line 614
;614:		verts[0].modulate[1] = 255;	
ADDRLP4 12+20+1
CNSTU1 255
ASGNU1
line 615
;615:		verts[0].modulate[2] = 255;	
ADDRLP4 12+20+2
CNSTU1 255
ASGNU1
line 616
;616:		verts[0].modulate[3] = 255;
ADDRLP4 12+20+3
CNSTU1 255
ASGNU1
line 618
;617:
;618:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $514
line 619
;619:			VectorMA (point, 2*height, ru, point);	
ADDRLP4 304
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 244
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 244+4
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 244+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 620
;620:		} else {
ADDRGP4 $515
JUMPV
LABELV $514
line 621
;621:			VectorMA (point, 2*height, pvup, point);	
ADDRLP4 304
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvup+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 622
;622:		}
LABELV $515
line 623
;623:		VectorCopy (point, verts[1].xyz);	
ADDRLP4 12+24
ADDRLP4 0
INDIRB
ASGNB 12
line 624
;624:		verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 625
;625:		verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 626
;626:		verts[1].modulate[0] = 255;	
ADDRLP4 12+24+20
CNSTU1 255
ASGNU1
line 627
;627:		verts[1].modulate[1] = 255;	
ADDRLP4 12+24+20+1
CNSTU1 255
ASGNU1
line 628
;628:		verts[1].modulate[2] = 255;	
ADDRLP4 12+24+20+2
CNSTU1 255
ASGNU1
line 629
;629:		verts[1].modulate[3] = 255;	
ADDRLP4 12+24+20+3
CNSTU1 255
ASGNU1
line 631
;630:
;631:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $545
line 632
;632:			VectorMA (point, 2*width, rr, point);	
ADDRLP4 304
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 256
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 256+4
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 256+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 633
;633:		} else {
ADDRGP4 $546
JUMPV
LABELV $545
line 634
;634:			VectorMA (point, 2*width, pvright, point);	
ADDRLP4 304
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 635
;635:		}
LABELV $546
line 636
;636:		VectorCopy (point, verts[2].xyz);	
ADDRLP4 12+48
ADDRLP4 0
INDIRB
ASGNB 12
line 637
;637:		verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 638
;638:		verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 639
;639:		verts[2].modulate[0] = 255;	
ADDRLP4 12+48+20
CNSTU1 255
ASGNU1
line 640
;640:		verts[2].modulate[1] = 255;	
ADDRLP4 12+48+20+1
CNSTU1 255
ASGNU1
line 641
;641:		verts[2].modulate[2] = 255;	
ADDRLP4 12+48+20+2
CNSTU1 255
ASGNU1
line 642
;642:		verts[2].modulate[3] = 255;	
ADDRLP4 12+48+20+3
CNSTU1 255
ASGNU1
line 644
;643:
;644:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $576
line 645
;645:			VectorMA (point, -2*height, ru, point);	
ADDRLP4 304
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 244
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 244+4
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 244+8
INDIRF4
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 646
;646:		} else {
ADDRGP4 $577
JUMPV
LABELV $576
line 647
;647:			VectorMA (point, -2*height, pvup, point);	
ADDRLP4 304
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 304
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvup+8
INDIRF4
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 648
;648:		}
LABELV $577
line 649
;649:		VectorCopy (point, verts[3].xyz);	
ADDRLP4 12+72
ADDRLP4 0
INDIRB
ASGNB 12
line 650
;650:		verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 651
;651:		verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 652
;652:		verts[3].modulate[0] = 255;	
ADDRLP4 12+72+20
CNSTU1 255
ASGNU1
line 653
;653:		verts[3].modulate[1] = 255;	
ADDRLP4 12+72+20+1
CNSTU1 255
ASGNU1
line 654
;654:		verts[3].modulate[2] = 255;	
ADDRLP4 12+72+20+2
CNSTU1 255
ASGNU1
line 655
;655:		verts[3].modulate[3] = 255;	
ADDRLP4 12+72+20+3
CNSTU1 255
ASGNU1
line 656
;656:	}
ADDRGP4 $473
JUMPV
LABELV $472
line 657
;657:	else if (p->type == P_SMOKE || p->type == P_SMOKE_IMPACT)
ADDRLP4 244
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 244
INDIRI4
CNSTI4 3
EQI4 $609
ADDRLP4 244
INDIRI4
CNSTI4 12
NEI4 $607
LABELV $609
line 658
;658:	{// create a front rotating facing polygon
line 660
;659:
;660:		if ( p->type == P_SMOKE_IMPACT && Distance( cg.snap->ps.origin, org ) > 1024) {
ADDRLP4 248
CNSTI4 64
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 248
INDIRI4
ADDP4
INDIRI4
CNSTI4 12
NEI4 $610
ADDRGP4 cg+36
INDIRP4
ADDRLP4 248
INDIRI4
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 252
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 252
INDIRF4
CNSTF4 1149239296
LEF4 $610
line 661
;661:			return;
ADDRGP4 $243
JUMPV
LABELV $610
line 664
;662:		}
;663:
;664:		if (p->color == BLOODRED)
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 2
NEI4 $613
line 665
;665:			VectorSet (color, 0.22f, 0.0f, 0.0f);
ADDRLP4 184
CNSTF4 1046562734
ASGNF4
ADDRLP4 184+4
CNSTF4 0
ASGNF4
ADDRLP4 184+8
CNSTF4 0
ASGNF4
ADDRGP4 $614
JUMPV
LABELV $613
line 666
;666:		else if (p->color == GREY75)
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 4
NEI4 $617
line 667
;667:		{
line 671
;668:			float	len;
;669:			float	greyit;
;670:			float	val;
;671:			len = Distance (cg.snap->ps.origin, org);
ADDRGP4 cg+36
INDIRP4
CNSTI4 64
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 268
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 260
ADDRLP4 268
INDIRF4
ASGNF4
line 672
;672:			if (!len)
ADDRLP4 260
INDIRF4
CNSTF4 0
NEF4 $620
line 673
;673:				len = 1;
ADDRLP4 260
CNSTF4 1065353216
ASGNF4
LABELV $620
line 675
;674:
;675:			val = 4096/len;
ADDRLP4 264
CNSTF4 1166016512
ADDRLP4 260
INDIRF4
DIVF4
ASGNF4
line 676
;676:			greyit = 0.25 * val;
ADDRLP4 256
CNSTF4 1048576000
ADDRLP4 264
INDIRF4
MULF4
ASGNF4
line 677
;677:			if (greyit > 0.5)
ADDRLP4 256
INDIRF4
CNSTF4 1056964608
LEF4 $622
line 678
;678:				greyit = 0.5;
ADDRLP4 256
CNSTF4 1056964608
ASGNF4
LABELV $622
line 680
;679:
;680:			VectorSet (color, greyit, greyit, greyit);
ADDRLP4 272
ADDRLP4 256
INDIRF4
ASGNF4
ADDRLP4 184
ADDRLP4 272
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 272
INDIRF4
ASGNF4
ADDRLP4 184+8
ADDRLP4 256
INDIRF4
ASGNF4
line 681
;681:		}
ADDRGP4 $618
JUMPV
LABELV $617
line 683
;682:		else
;683:			VectorSet (color, 1.0, 1.0, 1.0);
ADDRLP4 256
CNSTF4 1065353216
ASGNF4
ADDRLP4 184
ADDRLP4 256
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 256
INDIRF4
ASGNF4
ADDRLP4 184+8
CNSTF4 1065353216
ASGNF4
LABELV $618
LABELV $614
line 685
;684:
;685:		time = cg.time - p->time;
ADDRLP4 232
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 686
;686:		time2 = p->endtime - p->time;
ADDRLP4 260
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 236
ADDRLP4 260
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 260
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 687
;687:		ratio = time / time2;
ADDRLP4 200
ADDRLP4 232
INDIRF4
ADDRLP4 236
INDIRF4
DIVF4
ASGNF4
line 689
;688:		
;689:		if (cg.time > p->startfade)
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRFP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
LEF4 $629
line 690
;690:		{
line 691
;691:			invratio = 1 - ( (cg.time - p->startfade) / (p->endtime - p->startfade) );
ADDRLP4 264
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 268
ADDRLP4 264
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ASGNF4
ADDRLP4 204
CNSTF4 1065353216
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRLP4 268
INDIRF4
SUBF4
ADDRLP4 264
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 268
INDIRF4
SUBF4
DIVF4
SUBF4
ASGNF4
line 693
;692:
;693:			if (p->color == EMISIVEFADE)
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 3
NEI4 $633
line 694
;694:			{
line 696
;695:				float fval;
;696:				fval = (invratio * invratio);
ADDRLP4 276
ADDRLP4 204
INDIRF4
ASGNF4
ADDRLP4 272
ADDRLP4 276
INDIRF4
ADDRLP4 276
INDIRF4
MULF4
ASGNF4
line 697
;697:				if (fval < 0)
ADDRLP4 272
INDIRF4
CNSTF4 0
GEF4 $635
line 698
;698:					fval = 0;
ADDRLP4 272
CNSTF4 0
ASGNF4
LABELV $635
line 699
;699:				VectorSet (color, fval , fval , fval );
ADDRLP4 280
ADDRLP4 272
INDIRF4
ASGNF4
ADDRLP4 184
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 184+8
ADDRLP4 272
INDIRF4
ASGNF4
line 700
;700:			}
LABELV $633
line 701
;701:			invratio *= p->alpha;
ADDRLP4 204
ADDRLP4 204
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
line 702
;702:		}
ADDRGP4 $630
JUMPV
LABELV $629
line 704
;703:		else 
;704:			invratio = 1 * p->alpha;
ADDRLP4 204
CNSTF4 1065353216
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
MULF4
ASGNF4
LABELV $630
line 706
;705:
;706:		if ( cgs.glconfig.hardwareType == GLHW_RAGEPRO )
ADDRGP4 cgs+20100+11288
INDIRI4
CNSTI4 3
NEI4 $639
line 707
;707:			invratio = 1;
ADDRLP4 204
CNSTF4 1065353216
ASGNF4
LABELV $639
line 709
;708:
;709:		if (invratio > 1)
ADDRLP4 204
INDIRF4
CNSTF4 1065353216
LEF4 $643
line 710
;710:			invratio = 1;
ADDRLP4 204
CNSTF4 1065353216
ASGNF4
LABELV $643
line 712
;711:	
;712:		width = p->width + ( ratio * ( p->endwidth - p->width) );
ADDRLP4 264
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 268
ADDRLP4 264
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ASGNF4
ADDRLP4 196
ADDRLP4 268
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 264
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ADDRLP4 268
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 713
;713:		height = p->height + ( ratio * ( p->endheight - p->height) );
ADDRLP4 272
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 276
ADDRLP4 272
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ASGNF4
ADDRLP4 180
ADDRLP4 276
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 272
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ADDRLP4 276
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 715
;714:
;715:		if (p->type != P_SMOKE_IMPACT)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 12
EQI4 $645
line 716
;716:		{
line 719
;717:			vec3_t temp;
;718:
;719:			vectoangles (rforward, temp);
ADDRGP4 rforward
ARGP4
ADDRLP4 280
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 720
;720:			p->accumroll += p->roll;
ADDRLP4 292
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 296
ADDRLP4 292
INDIRP4
CNSTI4 120
ADDP4
ASGNP4
ADDRLP4 296
INDIRP4
ADDRLP4 296
INDIRP4
INDIRI4
ADDRLP4 292
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
ADDI4
ASGNI4
line 721
;721:			temp[ROLL] += p->accumroll * 0.1;
ADDRLP4 280+8
ADDRLP4 280+8
INDIRF4
CNSTF4 1036831949
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
CVIF4 4
MULF4
ADDF4
ASGNF4
line 722
;722:			AngleVectors ( temp, NULL, rright2, rup2);
ADDRLP4 280
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 208
ARGP4
ADDRLP4 220
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 723
;723:		}
ADDRGP4 $646
JUMPV
LABELV $645
line 725
;724:		else
;725:		{
line 726
;726:			VectorCopy (rright, rright2);
ADDRLP4 208
ADDRGP4 rright
INDIRB
ASGNB 12
line 727
;727:			VectorCopy (rup, rup2);
ADDRLP4 220
ADDRGP4 rup
INDIRB
ASGNB 12
line 728
;728:		}
LABELV $646
line 730
;729:		
;730:		if (p->rotate)
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRI4
CNSTI4 0
EQI4 $648
line 731
;731:		{
line 732
;732:			VectorMA (org, -height, rup2, point);	
ADDRLP4 280
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 284
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 280
INDIRP4
INDIRF4
ADDRLP4 220
INDIRF4
ADDRLP4 284
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 280
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 220+4
INDIRF4
ADDRLP4 284
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 220+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 733
;733:			VectorMA (point, -width, rright2, point);	
ADDRLP4 288
ADDRLP4 196
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 208
INDIRF4
ADDRLP4 288
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 208+4
INDIRF4
ADDRLP4 288
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 208+8
INDIRF4
ADDRLP4 196
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 734
;734:		}
ADDRGP4 $649
JUMPV
LABELV $648
line 736
;735:		else
;736:		{
line 737
;737:			VectorMA (org, -p->height, pvup, point);	
ADDRLP4 280
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 284
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 280
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 284
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 280
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 284
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 738
;738:			VectorMA (point, -p->width, pvright, point);	
ADDRLP4 288
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 288
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 739
;739:		}
LABELV $649
line 740
;740:		VectorCopy (point, verts[0].xyz);	
ADDRLP4 12
ADDRLP4 0
INDIRB
ASGNB 12
line 741
;741:		verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 742
;742:		verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 743
;743:		verts[0].modulate[0] = 255 * color[0];	
ADDRLP4 284
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 288
CNSTF4 1325400064
ASGNF4
ADDRLP4 284
INDIRF4
ADDRLP4 288
INDIRF4
LTF4 $675
ADDRLP4 280
ADDRLP4 284
INDIRF4
ADDRLP4 288
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $676
JUMPV
LABELV $675
ADDRLP4 280
ADDRLP4 284
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $676
ADDRLP4 12+20
ADDRLP4 280
INDIRU4
CVUU1 4
ASGNU1
line 744
;744:		verts[0].modulate[1] = 255 * color[1];	
ADDRLP4 296
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 300
CNSTF4 1325400064
ASGNF4
ADDRLP4 296
INDIRF4
ADDRLP4 300
INDIRF4
LTF4 $681
ADDRLP4 292
ADDRLP4 296
INDIRF4
ADDRLP4 300
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $682
JUMPV
LABELV $681
ADDRLP4 292
ADDRLP4 296
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $682
ADDRLP4 12+20+1
ADDRLP4 292
INDIRU4
CVUU1 4
ASGNU1
line 745
;745:		verts[0].modulate[2] = 255 * color[2];	
ADDRLP4 308
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 312
CNSTF4 1325400064
ASGNF4
ADDRLP4 308
INDIRF4
ADDRLP4 312
INDIRF4
LTF4 $687
ADDRLP4 304
ADDRLP4 308
INDIRF4
ADDRLP4 312
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $688
JUMPV
LABELV $687
ADDRLP4 304
ADDRLP4 308
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $688
ADDRLP4 12+20+2
ADDRLP4 304
INDIRU4
CVUU1 4
ASGNU1
line 746
;746:		verts[0].modulate[3] = 255 * invratio;	
ADDRLP4 320
CNSTF4 1132396544
ADDRLP4 204
INDIRF4
MULF4
ASGNF4
ADDRLP4 324
CNSTF4 1325400064
ASGNF4
ADDRLP4 320
INDIRF4
ADDRLP4 324
INDIRF4
LTF4 $692
ADDRLP4 316
ADDRLP4 320
INDIRF4
ADDRLP4 324
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $693
JUMPV
LABELV $692
ADDRLP4 316
ADDRLP4 320
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $693
ADDRLP4 12+20+3
ADDRLP4 316
INDIRU4
CVUU1 4
ASGNU1
line 748
;747:
;748:		if (p->rotate)
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRI4
CNSTI4 0
EQI4 $694
line 749
;749:		{
line 750
;750:			VectorMA (org, -height, rup2, point);	
ADDRLP4 328
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 332
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 328
INDIRP4
INDIRF4
ADDRLP4 220
INDIRF4
ADDRLP4 332
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 328
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 220+4
INDIRF4
ADDRLP4 332
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 220+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 751
;751:			VectorMA (point, width, rright2, point);	
ADDRLP4 336
ADDRLP4 196
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 208
INDIRF4
ADDRLP4 336
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 208+4
INDIRF4
ADDRLP4 336
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 208+8
INDIRF4
ADDRLP4 196
INDIRF4
MULF4
ADDF4
ASGNF4
line 752
;752:		}
ADDRGP4 $695
JUMPV
LABELV $694
line 754
;753:		else
;754:		{
line 755
;755:			VectorMA (org, -p->height, pvup, point);	
ADDRLP4 328
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 332
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 328
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 332
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 328
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 332
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 756
;756:			VectorMA (point, p->width, pvright, point);	
ADDRLP4 336
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 336
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 336
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 757
;757:		}
LABELV $695
line 758
;758:		VectorCopy (point, verts[1].xyz);	
ADDRLP4 12+24
ADDRLP4 0
INDIRB
ASGNB 12
line 759
;759:		verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 760
;760:		verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 761
;761:		verts[1].modulate[0] = 255 * color[0];	
ADDRLP4 332
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 336
CNSTF4 1325400064
ASGNF4
ADDRLP4 332
INDIRF4
ADDRLP4 336
INDIRF4
LTF4 $725
ADDRLP4 328
ADDRLP4 332
INDIRF4
ADDRLP4 336
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $726
JUMPV
LABELV $725
ADDRLP4 328
ADDRLP4 332
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $726
ADDRLP4 12+24+20
ADDRLP4 328
INDIRU4
CVUU1 4
ASGNU1
line 762
;762:		verts[1].modulate[1] = 255 * color[1];	
ADDRLP4 344
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 348
CNSTF4 1325400064
ASGNF4
ADDRLP4 344
INDIRF4
ADDRLP4 348
INDIRF4
LTF4 $732
ADDRLP4 340
ADDRLP4 344
INDIRF4
ADDRLP4 348
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $733
JUMPV
LABELV $732
ADDRLP4 340
ADDRLP4 344
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $733
ADDRLP4 12+24+20+1
ADDRLP4 340
INDIRU4
CVUU1 4
ASGNU1
line 763
;763:		verts[1].modulate[2] = 255 * color[2];	
ADDRLP4 356
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 360
CNSTF4 1325400064
ASGNF4
ADDRLP4 356
INDIRF4
ADDRLP4 360
INDIRF4
LTF4 $739
ADDRLP4 352
ADDRLP4 356
INDIRF4
ADDRLP4 360
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $740
JUMPV
LABELV $739
ADDRLP4 352
ADDRLP4 356
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $740
ADDRLP4 12+24+20+2
ADDRLP4 352
INDIRU4
CVUU1 4
ASGNU1
line 764
;764:		verts[1].modulate[3] = 255 * invratio;	
ADDRLP4 368
CNSTF4 1132396544
ADDRLP4 204
INDIRF4
MULF4
ASGNF4
ADDRLP4 372
CNSTF4 1325400064
ASGNF4
ADDRLP4 368
INDIRF4
ADDRLP4 372
INDIRF4
LTF4 $745
ADDRLP4 364
ADDRLP4 368
INDIRF4
ADDRLP4 372
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $746
JUMPV
LABELV $745
ADDRLP4 364
ADDRLP4 368
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $746
ADDRLP4 12+24+20+3
ADDRLP4 364
INDIRU4
CVUU1 4
ASGNU1
line 766
;765:
;766:		if (p->rotate)
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRI4
CNSTI4 0
EQI4 $747
line 767
;767:		{
line 768
;768:			VectorMA (org, height, rup2, point);	
ADDRLP4 376
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 376
INDIRP4
INDIRF4
ADDRLP4 220
INDIRF4
ADDRLP4 180
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 376
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 220+4
INDIRF4
ADDRLP4 180
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 220+8
INDIRF4
ADDRLP4 180
INDIRF4
MULF4
ADDF4
ASGNF4
line 769
;769:			VectorMA (point, width, rright2, point);	
ADDRLP4 384
ADDRLP4 196
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 208
INDIRF4
ADDRLP4 384
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 208+4
INDIRF4
ADDRLP4 384
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 208+8
INDIRF4
ADDRLP4 196
INDIRF4
MULF4
ADDF4
ASGNF4
line 770
;770:		}
ADDRGP4 $748
JUMPV
LABELV $747
line 772
;771:		else
;772:		{
line 773
;773:			VectorMA (org, p->height, pvup, point);	
ADDRLP4 376
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 380
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 376
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 380
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 376
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 380
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 774
;774:			VectorMA (point, p->width, pvright, point);	
ADDRLP4 384
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 384
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 384
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 775
;775:		}
LABELV $748
line 776
;776:		VectorCopy (point, verts[2].xyz);	
ADDRLP4 12+48
ADDRLP4 0
INDIRB
ASGNB 12
line 777
;777:		verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 778
;778:		verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 779
;779:		verts[2].modulate[0] = 255 * color[0];	
ADDRLP4 380
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 384
CNSTF4 1325400064
ASGNF4
ADDRLP4 380
INDIRF4
ADDRLP4 384
INDIRF4
LTF4 $778
ADDRLP4 376
ADDRLP4 380
INDIRF4
ADDRLP4 384
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $779
JUMPV
LABELV $778
ADDRLP4 376
ADDRLP4 380
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $779
ADDRLP4 12+48+20
ADDRLP4 376
INDIRU4
CVUU1 4
ASGNU1
line 780
;780:		verts[2].modulate[1] = 255 * color[1];	
ADDRLP4 392
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 396
CNSTF4 1325400064
ASGNF4
ADDRLP4 392
INDIRF4
ADDRLP4 396
INDIRF4
LTF4 $785
ADDRLP4 388
ADDRLP4 392
INDIRF4
ADDRLP4 396
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $786
JUMPV
LABELV $785
ADDRLP4 388
ADDRLP4 392
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $786
ADDRLP4 12+48+20+1
ADDRLP4 388
INDIRU4
CVUU1 4
ASGNU1
line 781
;781:		verts[2].modulate[2] = 255 * color[2];	
ADDRLP4 404
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 408
CNSTF4 1325400064
ASGNF4
ADDRLP4 404
INDIRF4
ADDRLP4 408
INDIRF4
LTF4 $792
ADDRLP4 400
ADDRLP4 404
INDIRF4
ADDRLP4 408
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $793
JUMPV
LABELV $792
ADDRLP4 400
ADDRLP4 404
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $793
ADDRLP4 12+48+20+2
ADDRLP4 400
INDIRU4
CVUU1 4
ASGNU1
line 782
;782:		verts[2].modulate[3] = 255 * invratio;	
ADDRLP4 416
CNSTF4 1132396544
ADDRLP4 204
INDIRF4
MULF4
ASGNF4
ADDRLP4 420
CNSTF4 1325400064
ASGNF4
ADDRLP4 416
INDIRF4
ADDRLP4 420
INDIRF4
LTF4 $798
ADDRLP4 412
ADDRLP4 416
INDIRF4
ADDRLP4 420
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $799
JUMPV
LABELV $798
ADDRLP4 412
ADDRLP4 416
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $799
ADDRLP4 12+48+20+3
ADDRLP4 412
INDIRU4
CVUU1 4
ASGNU1
line 784
;783:
;784:		if (p->rotate)
ADDRFP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRI4
CNSTI4 0
EQI4 $800
line 785
;785:		{
line 786
;786:			VectorMA (org, height, rup2, point);	
ADDRLP4 424
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 424
INDIRP4
INDIRF4
ADDRLP4 220
INDIRF4
ADDRLP4 180
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 424
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 220+4
INDIRF4
ADDRLP4 180
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 220+8
INDIRF4
ADDRLP4 180
INDIRF4
MULF4
ADDF4
ASGNF4
line 787
;787:			VectorMA (point, -width, rright2, point);	
ADDRLP4 432
ADDRLP4 196
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 208
INDIRF4
ADDRLP4 432
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 208+4
INDIRF4
ADDRLP4 432
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 208+8
INDIRF4
ADDRLP4 196
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 788
;788:		}
ADDRGP4 $801
JUMPV
LABELV $800
line 790
;789:		else
;790:		{
line 791
;791:			VectorMA (org, p->height, pvup, point);	
ADDRLP4 424
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 428
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 424
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 428
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 424
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 428
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 792
;792:			VectorMA (point, -p->width, pvright, point);	
ADDRLP4 432
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 432
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 432
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 793
;793:		}
LABELV $801
line 794
;794:		VectorCopy (point, verts[3].xyz);	
ADDRLP4 12+72
ADDRLP4 0
INDIRB
ASGNB 12
line 795
;795:		verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 796
;796:		verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 797
;797:		verts[3].modulate[0] = 255 * color[0];	
ADDRLP4 428
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 432
CNSTF4 1325400064
ASGNF4
ADDRLP4 428
INDIRF4
ADDRLP4 432
INDIRF4
LTF4 $831
ADDRLP4 424
ADDRLP4 428
INDIRF4
ADDRLP4 432
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $832
JUMPV
LABELV $831
ADDRLP4 424
ADDRLP4 428
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $832
ADDRLP4 12+72+20
ADDRLP4 424
INDIRU4
CVUU1 4
ASGNU1
line 798
;798:		verts[3].modulate[1] = 255 * color[1];	
ADDRLP4 440
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 444
CNSTF4 1325400064
ASGNF4
ADDRLP4 440
INDIRF4
ADDRLP4 444
INDIRF4
LTF4 $838
ADDRLP4 436
ADDRLP4 440
INDIRF4
ADDRLP4 444
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $839
JUMPV
LABELV $838
ADDRLP4 436
ADDRLP4 440
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $839
ADDRLP4 12+72+20+1
ADDRLP4 436
INDIRU4
CVUU1 4
ASGNU1
line 799
;799:		verts[3].modulate[2] = 255 * color[2];	
ADDRLP4 452
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 456
CNSTF4 1325400064
ASGNF4
ADDRLP4 452
INDIRF4
ADDRLP4 456
INDIRF4
LTF4 $845
ADDRLP4 448
ADDRLP4 452
INDIRF4
ADDRLP4 456
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $846
JUMPV
LABELV $845
ADDRLP4 448
ADDRLP4 452
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $846
ADDRLP4 12+72+20+2
ADDRLP4 448
INDIRU4
CVUU1 4
ASGNU1
line 800
;800:		verts[3].modulate[3] = 255  * invratio;	
ADDRLP4 464
CNSTF4 1132396544
ADDRLP4 204
INDIRF4
MULF4
ASGNF4
ADDRLP4 468
CNSTF4 1325400064
ASGNF4
ADDRLP4 464
INDIRF4
ADDRLP4 468
INDIRF4
LTF4 $851
ADDRLP4 460
ADDRLP4 464
INDIRF4
ADDRLP4 468
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $852
JUMPV
LABELV $851
ADDRLP4 460
ADDRLP4 464
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $852
ADDRLP4 12+72+20+3
ADDRLP4 460
INDIRU4
CVUU1 4
ASGNU1
line 802
;801:		
;802:	}
ADDRGP4 $608
JUMPV
LABELV $607
line 803
;803:	else if (p->type == P_BLEED)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 8
NEI4 $853
line 804
;804:	{
line 809
;805:		vec3_t	rr, ru;
;806:		vec3_t	rotate_ang;
;807:		float	alpha;
;808:
;809:		alpha = p->alpha;
ADDRLP4 272
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
ASGNF4
line 811
;810:		
;811:		if ( cgs.glconfig.hardwareType == GLHW_RAGEPRO )
ADDRGP4 cgs+20100+11288
INDIRI4
CNSTI4 3
NEI4 $855
line 812
;812:			alpha = 1;
ADDRLP4 272
CNSTF4 1065353216
ASGNF4
LABELV $855
line 814
;813:
;814:		if (p->roll) 
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $859
line 815
;815:		{
line 816
;816:			vectoangles( cg.refdef.viewaxis[0], rotate_ang );
ADDRGP4 cg+109044+36
ARGP4
ADDRLP4 276
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 817
;817:			rotate_ang[ROLL] += p->roll;
ADDRLP4 276+8
ADDRLP4 276+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 818
;818:			AngleVectors ( rotate_ang, NULL, rr, ru);
ADDRLP4 276
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 248
ARGP4
ADDRLP4 260
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 819
;819:		}
ADDRGP4 $860
JUMPV
LABELV $859
line 821
;820:		else
;821:		{
line 822
;822:			VectorCopy (pvup, ru);
ADDRLP4 260
ADDRGP4 pvup
INDIRB
ASGNB 12
line 823
;823:			VectorCopy (pvright, rr);
ADDRLP4 248
ADDRGP4 pvright
INDIRB
ASGNB 12
line 824
;824:		}
LABELV $860
line 826
;825:
;826:		VectorMA (org, -p->height, ru, point);	
ADDRLP4 288
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 292
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 288
INDIRP4
INDIRF4
ADDRLP4 260
INDIRF4
ADDRLP4 292
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 288
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 292
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 260+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 827
;827:		VectorMA (point, -p->width, rr, point);	
ADDRLP4 296
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 296
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 296
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 248+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 828
;828:		VectorCopy (point, verts[0].xyz);	
ADDRLP4 12
ADDRLP4 0
INDIRB
ASGNB 12
line 829
;829:		verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 830
;830:		verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 831
;831:		verts[0].modulate[0] = 111;	
ADDRLP4 12+20
CNSTU1 111
ASGNU1
line 832
;832:		verts[0].modulate[1] = 19;	
ADDRLP4 12+20+1
CNSTU1 19
ASGNU1
line 833
;833:		verts[0].modulate[2] = 9;	
ADDRLP4 12+20+2
CNSTU1 9
ASGNU1
line 834
;834:		verts[0].modulate[3] = 255 * alpha;	
ADDRLP4 304
CNSTF4 1132396544
ADDRLP4 272
INDIRF4
MULF4
ASGNF4
ADDRLP4 308
CNSTF4 1325400064
ASGNF4
ADDRLP4 304
INDIRF4
ADDRLP4 308
INDIRF4
LTF4 $885
ADDRLP4 300
ADDRLP4 304
INDIRF4
ADDRLP4 308
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $886
JUMPV
LABELV $885
ADDRLP4 300
ADDRLP4 304
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $886
ADDRLP4 12+20+3
ADDRLP4 300
INDIRU4
CVUU1 4
ASGNU1
line 836
;835:
;836:		VectorMA (org, -p->height, ru, point);	
ADDRLP4 312
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 316
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 312
INDIRP4
INDIRF4
ADDRLP4 260
INDIRF4
ADDRLP4 316
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 312
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 316
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 260+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 837
;837:		VectorMA (point, p->width, rr, point);	
ADDRLP4 320
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 320
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 320
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 248+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 838
;838:		VectorCopy (point, verts[1].xyz);	
ADDRLP4 12+24
ADDRLP4 0
INDIRB
ASGNB 12
line 839
;839:		verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 840
;840:		verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 841
;841:		verts[1].modulate[0] = 111;	
ADDRLP4 12+24+20
CNSTU1 111
ASGNU1
line 842
;842:		verts[1].modulate[1] = 19;	
ADDRLP4 12+24+20+1
CNSTU1 19
ASGNU1
line 843
;843:		verts[1].modulate[2] = 9;	
ADDRLP4 12+24+20+2
CNSTU1 9
ASGNU1
line 844
;844:		verts[1].modulate[3] = 255 * alpha;	
ADDRLP4 328
CNSTF4 1132396544
ADDRLP4 272
INDIRF4
MULF4
ASGNF4
ADDRLP4 332
CNSTF4 1325400064
ASGNF4
ADDRLP4 328
INDIRF4
ADDRLP4 332
INDIRF4
LTF4 $915
ADDRLP4 324
ADDRLP4 328
INDIRF4
ADDRLP4 332
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $916
JUMPV
LABELV $915
ADDRLP4 324
ADDRLP4 328
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $916
ADDRLP4 12+24+20+3
ADDRLP4 324
INDIRU4
CVUU1 4
ASGNU1
line 846
;845:
;846:		VectorMA (org, p->height, ru, point);	
ADDRLP4 336
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 340
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 336
INDIRP4
INDIRF4
ADDRLP4 260
INDIRF4
ADDRLP4 340
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 336
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 340
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 260+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 847
;847:		VectorMA (point, p->width, rr, point);	
ADDRLP4 344
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 344
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 344
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 248+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 848
;848:		VectorCopy (point, verts[2].xyz);	
ADDRLP4 12+48
ADDRLP4 0
INDIRB
ASGNB 12
line 849
;849:		verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 850
;850:		verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 851
;851:		verts[2].modulate[0] = 111;	
ADDRLP4 12+48+20
CNSTU1 111
ASGNU1
line 852
;852:		verts[2].modulate[1] = 19;	
ADDRLP4 12+48+20+1
CNSTU1 19
ASGNU1
line 853
;853:		verts[2].modulate[2] = 9;	
ADDRLP4 12+48+20+2
CNSTU1 9
ASGNU1
line 854
;854:		verts[2].modulate[3] = 255 * alpha;	
ADDRLP4 352
CNSTF4 1132396544
ADDRLP4 272
INDIRF4
MULF4
ASGNF4
ADDRLP4 356
CNSTF4 1325400064
ASGNF4
ADDRLP4 352
INDIRF4
ADDRLP4 356
INDIRF4
LTF4 $945
ADDRLP4 348
ADDRLP4 352
INDIRF4
ADDRLP4 356
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $946
JUMPV
LABELV $945
ADDRLP4 348
ADDRLP4 352
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $946
ADDRLP4 12+48+20+3
ADDRLP4 348
INDIRU4
CVUU1 4
ASGNU1
line 856
;855:
;856:		VectorMA (org, p->height, ru, point);	
ADDRLP4 360
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 364
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 360
INDIRP4
INDIRF4
ADDRLP4 260
INDIRF4
ADDRLP4 364
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 360
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 364
INDIRP4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 260+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 857
;857:		VectorMA (point, -p->width, rr, point);	
ADDRLP4 368
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 368
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 368
INDIRP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 248+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 858
;858:		VectorCopy (point, verts[3].xyz);	
ADDRLP4 12+72
ADDRLP4 0
INDIRB
ASGNB 12
line 859
;859:		verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 860
;860:		verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 861
;861:		verts[3].modulate[0] = 111;	
ADDRLP4 12+72+20
CNSTU1 111
ASGNU1
line 862
;862:		verts[3].modulate[1] = 19;	
ADDRLP4 12+72+20+1
CNSTU1 19
ASGNU1
line 863
;863:		verts[3].modulate[2] = 9;	
ADDRLP4 12+72+20+2
CNSTU1 9
ASGNU1
line 864
;864:		verts[3].modulate[3] = 255 * alpha;	
ADDRLP4 376
CNSTF4 1132396544
ADDRLP4 272
INDIRF4
MULF4
ASGNF4
ADDRLP4 380
CNSTF4 1325400064
ASGNF4
ADDRLP4 376
INDIRF4
ADDRLP4 380
INDIRF4
LTF4 $975
ADDRLP4 372
ADDRLP4 376
INDIRF4
ADDRLP4 380
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $976
JUMPV
LABELV $975
ADDRLP4 372
ADDRLP4 376
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $976
ADDRLP4 12+72+20+3
ADDRLP4 372
INDIRU4
CVUU1 4
ASGNU1
line 866
;865:
;866:	}
ADDRGP4 $854
JUMPV
LABELV $853
line 867
;867:	else if (p->type == P_FLAT_SCALEUP)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 9
NEI4 $977
line 868
;868:	{
line 872
;869:		float width, height;
;870:		float sinR, cosR;
;871:
;872:		if (p->color == BLOODRED)
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 2
NEI4 $979
line 873
;873:			VectorSet (color, 1, 1, 1);
ADDRLP4 264
CNSTF4 1065353216
ASGNF4
ADDRLP4 184
ADDRLP4 264
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 264
INDIRF4
ASGNF4
ADDRLP4 184+8
CNSTF4 1065353216
ASGNF4
ADDRGP4 $980
JUMPV
LABELV $979
line 875
;874:		else
;875:			VectorSet (color, 0.5, 0.5, 0.5);
ADDRLP4 268
CNSTF4 1056964608
ASGNF4
ADDRLP4 184
ADDRLP4 268
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 268
INDIRF4
ASGNF4
ADDRLP4 184+8
CNSTF4 1056964608
ASGNF4
LABELV $980
line 877
;876:		
;877:		time = cg.time - p->time;
ADDRLP4 232
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 878
;878:		time2 = p->endtime - p->time;
ADDRLP4 272
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 236
ADDRLP4 272
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 272
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 879
;879:		ratio = time / time2;
ADDRLP4 200
ADDRLP4 232
INDIRF4
ADDRLP4 236
INDIRF4
DIVF4
ASGNF4
line 881
;880:
;881:		width = p->width + ( ratio * ( p->endwidth - p->width) );
ADDRLP4 276
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 280
ADDRLP4 276
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ASGNF4
ADDRLP4 256
ADDRLP4 280
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 276
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ADDRLP4 280
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 882
;882:		height = p->height + ( ratio * ( p->endheight - p->height) );
ADDRLP4 284
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 288
ADDRLP4 284
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ASGNF4
ADDRLP4 260
ADDRLP4 288
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 284
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ADDRLP4 288
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 884
;883:
;884:		if (width > p->endwidth)
ADDRLP4 256
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
LEF4 $986
line 885
;885:			width = p->endwidth;
ADDRLP4 256
ADDRFP4 0
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ASGNF4
LABELV $986
line 887
;886:
;887:		if (height > p->endheight)
ADDRLP4 260
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
LEF4 $988
line 888
;888:			height = p->endheight;
ADDRLP4 260
ADDRFP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ASGNF4
LABELV $988
line 890
;889:
;890:		sinR = height * sin(DEG2RAD(p->roll)) * sqrt(2);
CNSTF4 1078530011
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CVIF4 4
MULF4
CNSTF4 1127481344
DIVF4
ARGF4
ADDRLP4 292
ADDRGP4 sin
CALLF4
ASGNF4
CNSTF4 1073741824
ARGF4
ADDRLP4 296
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRLP4 248
ADDRLP4 260
INDIRF4
ADDRLP4 292
INDIRF4
MULF4
ADDRLP4 296
INDIRF4
MULF4
ASGNF4
line 891
;891:		cosR = width * cos(DEG2RAD(p->roll)) * sqrt(2);
CNSTF4 1078530011
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CVIF4 4
MULF4
CNSTF4 1127481344
DIVF4
ARGF4
ADDRLP4 300
ADDRGP4 cos
CALLF4
ASGNF4
CNSTF4 1073741824
ARGF4
ADDRLP4 304
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRLP4 252
ADDRLP4 256
INDIRF4
ADDRLP4 300
INDIRF4
MULF4
ADDRLP4 304
INDIRF4
MULF4
ASGNF4
line 893
;892:
;893:		VectorCopy (org, verts[0].xyz);	
ADDRLP4 12
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 894
;894:		verts[0].xyz[0] -= sinR;
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRLP4 248
INDIRF4
SUBF4
ASGNF4
line 895
;895:		verts[0].xyz[1] -= cosR;
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
ADDRLP4 252
INDIRF4
SUBF4
ASGNF4
line 896
;896:		verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 897
;897:		verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 898
;898:		verts[0].modulate[0] = 255 * color[0];	
ADDRLP4 312
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 316
CNSTF4 1325400064
ASGNF4
ADDRLP4 312
INDIRF4
ADDRLP4 316
INDIRF4
LTF4 $996
ADDRLP4 308
ADDRLP4 312
INDIRF4
ADDRLP4 316
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $997
JUMPV
LABELV $996
ADDRLP4 308
ADDRLP4 312
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $997
ADDRLP4 12+20
ADDRLP4 308
INDIRU4
CVUU1 4
ASGNU1
line 899
;899:		verts[0].modulate[1] = 255 * color[1];	
ADDRLP4 324
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 328
CNSTF4 1325400064
ASGNF4
ADDRLP4 324
INDIRF4
ADDRLP4 328
INDIRF4
LTF4 $1002
ADDRLP4 320
ADDRLP4 324
INDIRF4
ADDRLP4 328
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1003
JUMPV
LABELV $1002
ADDRLP4 320
ADDRLP4 324
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1003
ADDRLP4 12+20+1
ADDRLP4 320
INDIRU4
CVUU1 4
ASGNU1
line 900
;900:		verts[0].modulate[2] = 255 * color[2];	
ADDRLP4 336
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 340
CNSTF4 1325400064
ASGNF4
ADDRLP4 336
INDIRF4
ADDRLP4 340
INDIRF4
LTF4 $1008
ADDRLP4 332
ADDRLP4 336
INDIRF4
ADDRLP4 340
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1009
JUMPV
LABELV $1008
ADDRLP4 332
ADDRLP4 336
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1009
ADDRLP4 12+20+2
ADDRLP4 332
INDIRU4
CVUU1 4
ASGNU1
line 901
;901:		verts[0].modulate[3] = 255;	
ADDRLP4 12+20+3
CNSTU1 255
ASGNU1
line 903
;902:
;903:		VectorCopy (org, verts[1].xyz);	
ADDRLP4 12+24
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 904
;904:		verts[1].xyz[0] -= cosR;	
ADDRLP4 12+24
ADDRLP4 12+24
INDIRF4
ADDRLP4 252
INDIRF4
SUBF4
ASGNF4
line 905
;905:		verts[1].xyz[1] += sinR;	
ADDRLP4 12+24+4
ADDRLP4 12+24+4
INDIRF4
ADDRLP4 248
INDIRF4
ADDF4
ASGNF4
line 906
;906:		verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 907
;907:		verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 908
;908:		verts[1].modulate[0] = 255 * color[0];	
ADDRLP4 348
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 352
CNSTF4 1325400064
ASGNF4
ADDRLP4 348
INDIRF4
ADDRLP4 352
INDIRF4
LTF4 $1024
ADDRLP4 344
ADDRLP4 348
INDIRF4
ADDRLP4 352
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1025
JUMPV
LABELV $1024
ADDRLP4 344
ADDRLP4 348
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1025
ADDRLP4 12+24+20
ADDRLP4 344
INDIRU4
CVUU1 4
ASGNU1
line 909
;909:		verts[1].modulate[1] = 255 * color[1];	
ADDRLP4 360
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 364
CNSTF4 1325400064
ASGNF4
ADDRLP4 360
INDIRF4
ADDRLP4 364
INDIRF4
LTF4 $1031
ADDRLP4 356
ADDRLP4 360
INDIRF4
ADDRLP4 364
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1032
JUMPV
LABELV $1031
ADDRLP4 356
ADDRLP4 360
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1032
ADDRLP4 12+24+20+1
ADDRLP4 356
INDIRU4
CVUU1 4
ASGNU1
line 910
;910:		verts[1].modulate[2] = 255 * color[2];	
ADDRLP4 372
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 376
CNSTF4 1325400064
ASGNF4
ADDRLP4 372
INDIRF4
ADDRLP4 376
INDIRF4
LTF4 $1038
ADDRLP4 368
ADDRLP4 372
INDIRF4
ADDRLP4 376
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1039
JUMPV
LABELV $1038
ADDRLP4 368
ADDRLP4 372
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1039
ADDRLP4 12+24+20+2
ADDRLP4 368
INDIRU4
CVUU1 4
ASGNU1
line 911
;911:		verts[1].modulate[3] = 255;	
ADDRLP4 12+24+20+3
CNSTU1 255
ASGNU1
line 913
;912:
;913:		VectorCopy (org, verts[2].xyz);	
ADDRLP4 12+48
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 914
;914:		verts[2].xyz[0] += sinR;	
ADDRLP4 12+48
ADDRLP4 12+48
INDIRF4
ADDRLP4 248
INDIRF4
ADDF4
ASGNF4
line 915
;915:		verts[2].xyz[1] += cosR;	
ADDRLP4 12+48+4
ADDRLP4 12+48+4
INDIRF4
ADDRLP4 252
INDIRF4
ADDF4
ASGNF4
line 916
;916:		verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 917
;917:		verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 918
;918:		verts[2].modulate[0] = 255 * color[0];	
ADDRLP4 384
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 388
CNSTF4 1325400064
ASGNF4
ADDRLP4 384
INDIRF4
ADDRLP4 388
INDIRF4
LTF4 $1055
ADDRLP4 380
ADDRLP4 384
INDIRF4
ADDRLP4 388
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1056
JUMPV
LABELV $1055
ADDRLP4 380
ADDRLP4 384
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1056
ADDRLP4 12+48+20
ADDRLP4 380
INDIRU4
CVUU1 4
ASGNU1
line 919
;919:		verts[2].modulate[1] = 255 * color[1];	
ADDRLP4 396
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 400
CNSTF4 1325400064
ASGNF4
ADDRLP4 396
INDIRF4
ADDRLP4 400
INDIRF4
LTF4 $1062
ADDRLP4 392
ADDRLP4 396
INDIRF4
ADDRLP4 400
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1063
JUMPV
LABELV $1062
ADDRLP4 392
ADDRLP4 396
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1063
ADDRLP4 12+48+20+1
ADDRLP4 392
INDIRU4
CVUU1 4
ASGNU1
line 920
;920:		verts[2].modulate[2] = 255 * color[2];	
ADDRLP4 408
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 412
CNSTF4 1325400064
ASGNF4
ADDRLP4 408
INDIRF4
ADDRLP4 412
INDIRF4
LTF4 $1069
ADDRLP4 404
ADDRLP4 408
INDIRF4
ADDRLP4 412
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1070
JUMPV
LABELV $1069
ADDRLP4 404
ADDRLP4 408
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1070
ADDRLP4 12+48+20+2
ADDRLP4 404
INDIRU4
CVUU1 4
ASGNU1
line 921
;921:		verts[2].modulate[3] = 255;	
ADDRLP4 12+48+20+3
CNSTU1 255
ASGNU1
line 923
;922:
;923:		VectorCopy (org, verts[3].xyz);	
ADDRLP4 12+72
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 924
;924:		verts[3].xyz[0] += cosR;	
ADDRLP4 12+72
ADDRLP4 12+72
INDIRF4
ADDRLP4 252
INDIRF4
ADDF4
ASGNF4
line 925
;925:		verts[3].xyz[1] -= sinR;	
ADDRLP4 12+72+4
ADDRLP4 12+72+4
INDIRF4
ADDRLP4 248
INDIRF4
SUBF4
ASGNF4
line 926
;926:		verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 927
;927:		verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 928
;928:		verts[3].modulate[0] = 255 * color[0];	
ADDRLP4 420
CNSTF4 1132396544
ADDRLP4 184
INDIRF4
MULF4
ASGNF4
ADDRLP4 424
CNSTF4 1325400064
ASGNF4
ADDRLP4 420
INDIRF4
ADDRLP4 424
INDIRF4
LTF4 $1086
ADDRLP4 416
ADDRLP4 420
INDIRF4
ADDRLP4 424
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1087
JUMPV
LABELV $1086
ADDRLP4 416
ADDRLP4 420
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1087
ADDRLP4 12+72+20
ADDRLP4 416
INDIRU4
CVUU1 4
ASGNU1
line 929
;929:		verts[3].modulate[1] = 255 * color[1];	
ADDRLP4 432
CNSTF4 1132396544
ADDRLP4 184+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 436
CNSTF4 1325400064
ASGNF4
ADDRLP4 432
INDIRF4
ADDRLP4 436
INDIRF4
LTF4 $1093
ADDRLP4 428
ADDRLP4 432
INDIRF4
ADDRLP4 436
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1094
JUMPV
LABELV $1093
ADDRLP4 428
ADDRLP4 432
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1094
ADDRLP4 12+72+20+1
ADDRLP4 428
INDIRU4
CVUU1 4
ASGNU1
line 930
;930:		verts[3].modulate[2] = 255 * color[2];	
ADDRLP4 444
CNSTF4 1132396544
ADDRLP4 184+8
INDIRF4
MULF4
ASGNF4
ADDRLP4 448
CNSTF4 1325400064
ASGNF4
ADDRLP4 444
INDIRF4
ADDRLP4 448
INDIRF4
LTF4 $1100
ADDRLP4 440
ADDRLP4 444
INDIRF4
ADDRLP4 448
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $1101
JUMPV
LABELV $1100
ADDRLP4 440
ADDRLP4 444
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $1101
ADDRLP4 12+72+20+2
ADDRLP4 440
INDIRU4
CVUU1 4
ASGNU1
line 931
;931:		verts[3].modulate[3] = 255;		
ADDRLP4 12+72+20+3
CNSTU1 255
ASGNU1
line 932
;932:	}
ADDRGP4 $978
JUMPV
LABELV $977
line 933
;933:	else if (p->type == P_FLAT)
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $1105
line 934
;934:	{
line 936
;935:
;936:		VectorCopy (org, verts[0].xyz);	
ADDRLP4 12
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 937
;937:		verts[0].xyz[0] -= p->height;	
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
SUBF4
ASGNF4
line 938
;938:		verts[0].xyz[1] -= p->width;	
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
SUBF4
ASGNF4
line 939
;939:		verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 940
;940:		verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 941
;941:		verts[0].modulate[0] = 255;	
ADDRLP4 12+20
CNSTU1 255
ASGNU1
line 942
;942:		verts[0].modulate[1] = 255;	
ADDRLP4 12+20+1
CNSTU1 255
ASGNU1
line 943
;943:		verts[0].modulate[2] = 255;	
ADDRLP4 12+20+2
CNSTU1 255
ASGNU1
line 944
;944:		verts[0].modulate[3] = 255;	
ADDRLP4 12+20+3
CNSTU1 255
ASGNU1
line 946
;945:
;946:		VectorCopy (org, verts[1].xyz);	
ADDRLP4 12+24
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 947
;947:		verts[1].xyz[0] -= p->height;	
ADDRLP4 12+24
ADDRLP4 12+24
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
SUBF4
ASGNF4
line 948
;948:		verts[1].xyz[1] += p->width;	
ADDRLP4 12+24+4
ADDRLP4 12+24+4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ADDF4
ASGNF4
line 949
;949:		verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 950
;950:		verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 951
;951:		verts[1].modulate[0] = 255;	
ADDRLP4 12+24+20
CNSTU1 255
ASGNU1
line 952
;952:		verts[1].modulate[1] = 255;	
ADDRLP4 12+24+20+1
CNSTU1 255
ASGNU1
line 953
;953:		verts[1].modulate[2] = 255;	
ADDRLP4 12+24+20+2
CNSTU1 255
ASGNU1
line 954
;954:		verts[1].modulate[3] = 255;	
ADDRLP4 12+24+20+3
CNSTU1 255
ASGNU1
line 956
;955:
;956:		VectorCopy (org, verts[2].xyz);	
ADDRLP4 12+48
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 957
;957:		verts[2].xyz[0] += p->height;	
ADDRLP4 12+48
ADDRLP4 12+48
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ADDF4
ASGNF4
line 958
;958:		verts[2].xyz[1] += p->width;	
ADDRLP4 12+48+4
ADDRLP4 12+48+4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ADDF4
ASGNF4
line 959
;959:		verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 960
;960:		verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 961
;961:		verts[2].modulate[0] = 255;	
ADDRLP4 12+48+20
CNSTU1 255
ASGNU1
line 962
;962:		verts[2].modulate[1] = 255;	
ADDRLP4 12+48+20+1
CNSTU1 255
ASGNU1
line 963
;963:		verts[2].modulate[2] = 255;	
ADDRLP4 12+48+20+2
CNSTU1 255
ASGNU1
line 964
;964:		verts[2].modulate[3] = 255;	
ADDRLP4 12+48+20+3
CNSTU1 255
ASGNU1
line 966
;965:
;966:		VectorCopy (org, verts[3].xyz);	
ADDRLP4 12+72
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 967
;967:		verts[3].xyz[0] += p->height;	
ADDRLP4 12+72
ADDRLP4 12+72
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ADDF4
ASGNF4
line 968
;968:		verts[3].xyz[1] -= p->width;	
ADDRLP4 12+72+4
ADDRLP4 12+72+4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
SUBF4
ASGNF4
line 969
;969:		verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 970
;970:		verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 971
;971:		verts[3].modulate[0] = 255;	
ADDRLP4 12+72+20
CNSTU1 255
ASGNU1
line 972
;972:		verts[3].modulate[1] = 255;	
ADDRLP4 12+72+20+1
CNSTU1 255
ASGNU1
line 973
;973:		verts[3].modulate[2] = 255;	
ADDRLP4 12+72+20+2
CNSTU1 255
ASGNU1
line 974
;974:		verts[3].modulate[3] = 255;	
ADDRLP4 12+72+20+3
CNSTU1 255
ASGNU1
line 976
;975:
;976:	}
ADDRGP4 $1106
JUMPV
LABELV $1105
line 978
;977:	// Ridah
;978:	else if (p->type == P_ANIM) {
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 6
NEI4 $1178
line 983
;979:		vec3_t	rr, ru;
;980:		vec3_t	rotate_ang;
;981:		int i, j;
;982:
;983:		time = cg.time - p->time;
ADDRLP4 232
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 984
;984:		time2 = p->endtime - p->time;
ADDRLP4 292
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 236
ADDRLP4 292
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 292
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 985
;985:		ratio = time / time2;
ADDRLP4 200
ADDRLP4 232
INDIRF4
ADDRLP4 236
INDIRF4
DIVF4
ASGNF4
line 986
;986:		if (ratio >= 1.0f) {
ADDRLP4 200
INDIRF4
CNSTF4 1065353216
LTF4 $1181
line 987
;987:			ratio = 0.9999f;
ADDRLP4 200
CNSTF4 1065351538
ASGNF4
line 988
;988:		}
LABELV $1181
line 990
;989:
;990:		width = p->width + ( ratio * ( p->endwidth - p->width) );
ADDRLP4 296
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 300
ADDRLP4 296
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ASGNF4
ADDRLP4 196
ADDRLP4 300
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 296
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ADDRLP4 300
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 991
;991:		height = p->height + ( ratio * ( p->endheight - p->height) );
ADDRLP4 304
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 308
ADDRLP4 304
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ASGNF4
ADDRLP4 180
ADDRLP4 308
INDIRF4
ADDRLP4 200
INDIRF4
ADDRLP4 304
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ADDRLP4 308
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 994
;992:
;993:		// if we are "inside" this sprite, don't draw
;994:		if (Distance( cg.snap->ps.origin, org ) < width/1.5) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 64
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 312
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 312
INDIRF4
ADDRLP4 196
INDIRF4
CNSTF4 1069547520
DIVF4
GEF4 $1183
line 995
;995:			return;
ADDRGP4 $243
JUMPV
LABELV $1183
line 998
;996:		}
;997:
;998:		i = p->shaderAnim;
ADDRLP4 272
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
ASGNI4
line 999
;999:		j = (int)floor(ratio * shaderAnimCounts[p->shaderAnim]);
ADDRLP4 200
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimCounts
ADDP4
INDIRI4
CVIF4 4
MULF4
ARGF4
ADDRLP4 316
ADDRGP4 floor
CALLF4
ASGNF4
ADDRLP4 276
ADDRLP4 316
INDIRF4
CVFI4 4
ASGNI4
line 1000
;1000:		p->pshader = shaderAnims[i][j];
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRLP4 276
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 272
INDIRI4
CNSTI4 8
LSHI4
ADDRGP4 shaderAnims
ADDP4
ADDP4
INDIRI4
ASGNI4
line 1002
;1001:
;1002:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1186
line 1003
;1003:			vectoangles( cg.refdef.viewaxis[0], rotate_ang );
ADDRGP4 cg+109044+36
ARGP4
ADDRLP4 280
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1004
;1004:			rotate_ang[ROLL] += p->roll;
ADDRLP4 280+8
ADDRLP4 280+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 1005
;1005:			AngleVectors ( rotate_ang, NULL, rr, ru);
ADDRLP4 280
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 260
ARGP4
ADDRLP4 248
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 1006
;1006:		}
LABELV $1186
line 1008
;1007:
;1008:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1191
line 1009
;1009:			VectorMA (org, -height, ru, point);	
ADDRLP4 320
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 324
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 320
INDIRP4
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 324
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 320
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 324
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 248+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 1010
;1010:			VectorMA (point, -width, rr, point);	
ADDRLP4 328
ADDRLP4 196
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 260
INDIRF4
ADDRLP4 328
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 328
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 260+8
INDIRF4
ADDRLP4 196
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 1011
;1011:		} else {
ADDRGP4 $1192
JUMPV
LABELV $1191
line 1012
;1012:			VectorMA (org, -height, pvup, point);	
ADDRLP4 320
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 324
ADDRLP4 180
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 320
INDIRP4
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 324
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 320
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 324
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 pvup+8
INDIRF4
ADDRLP4 180
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 1013
;1013:			VectorMA (point, -width, pvright, point);	
ADDRLP4 328
ADDRLP4 196
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 328
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 328
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
ADDRLP4 196
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 1014
;1014:		}
LABELV $1192
line 1015
;1015:		VectorCopy (point, verts[0].xyz);	
ADDRLP4 12
ADDRLP4 0
INDIRB
ASGNB 12
line 1016
;1016:		verts[0].st[0] = 0;	
ADDRLP4 12+12
CNSTF4 0
ASGNF4
line 1017
;1017:		verts[0].st[1] = 0;	
ADDRLP4 12+12+4
CNSTF4 0
ASGNF4
line 1018
;1018:		verts[0].modulate[0] = 255;	
ADDRLP4 12+20
CNSTU1 255
ASGNU1
line 1019
;1019:		verts[0].modulate[1] = 255;	
ADDRLP4 12+20+1
CNSTU1 255
ASGNU1
line 1020
;1020:		verts[0].modulate[2] = 255;	
ADDRLP4 12+20+2
CNSTU1 255
ASGNU1
line 1021
;1021:		verts[0].modulate[3] = 255;
ADDRLP4 12+20+3
CNSTU1 255
ASGNU1
line 1023
;1022:
;1023:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1223
line 1024
;1024:			VectorMA (point, 2*height, ru, point);	
ADDRLP4 320
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 248+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1025
;1025:		} else {
ADDRGP4 $1224
JUMPV
LABELV $1223
line 1026
;1026:			VectorMA (point, 2*height, pvup, point);	
ADDRLP4 320
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvup+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1027
;1027:		}
LABELV $1224
line 1028
;1028:		VectorCopy (point, verts[1].xyz);	
ADDRLP4 12+24
ADDRLP4 0
INDIRB
ASGNB 12
line 1029
;1029:		verts[1].st[0] = 0;	
ADDRLP4 12+24+12
CNSTF4 0
ASGNF4
line 1030
;1030:		verts[1].st[1] = 1;	
ADDRLP4 12+24+12+4
CNSTF4 1065353216
ASGNF4
line 1031
;1031:		verts[1].modulate[0] = 255;	
ADDRLP4 12+24+20
CNSTU1 255
ASGNU1
line 1032
;1032:		verts[1].modulate[1] = 255;	
ADDRLP4 12+24+20+1
CNSTU1 255
ASGNU1
line 1033
;1033:		verts[1].modulate[2] = 255;	
ADDRLP4 12+24+20+2
CNSTU1 255
ASGNU1
line 1034
;1034:		verts[1].modulate[3] = 255;	
ADDRLP4 12+24+20+3
CNSTU1 255
ASGNU1
line 1036
;1035:
;1036:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1254
line 1037
;1037:			VectorMA (point, 2*width, rr, point);	
ADDRLP4 320
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 260
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 260+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1038
;1038:		} else {
ADDRGP4 $1255
JUMPV
LABELV $1254
line 1039
;1039:			VectorMA (point, 2*width, pvright, point);	
ADDRLP4 320
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvright
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvright+4
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvright+8
INDIRF4
CNSTF4 1073741824
ADDRLP4 196
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1040
;1040:		}
LABELV $1255
line 1041
;1041:		VectorCopy (point, verts[2].xyz);	
ADDRLP4 12+48
ADDRLP4 0
INDIRB
ASGNB 12
line 1042
;1042:		verts[2].st[0] = 1;	
ADDRLP4 12+48+12
CNSTF4 1065353216
ASGNF4
line 1043
;1043:		verts[2].st[1] = 1;	
ADDRLP4 12+48+12+4
CNSTF4 1065353216
ASGNF4
line 1044
;1044:		verts[2].modulate[0] = 255;	
ADDRLP4 12+48+20
CNSTU1 255
ASGNU1
line 1045
;1045:		verts[2].modulate[1] = 255;	
ADDRLP4 12+48+20+1
CNSTU1 255
ASGNU1
line 1046
;1046:		verts[2].modulate[2] = 255;	
ADDRLP4 12+48+20+2
CNSTU1 255
ASGNU1
line 1047
;1047:		verts[2].modulate[3] = 255;	
ADDRLP4 12+48+20+3
CNSTU1 255
ASGNU1
line 1049
;1048:
;1049:		if (p->roll) {
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1285
line 1050
;1050:			VectorMA (point, -2*height, ru, point);	
ADDRLP4 320
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 248
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 248+4
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 248+8
INDIRF4
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1051
;1051:		} else {
ADDRGP4 $1286
JUMPV
LABELV $1285
line 1052
;1052:			VectorMA (point, -2*height, pvup, point);	
ADDRLP4 320
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRGP4 pvup
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRGP4 pvup+4
INDIRF4
ADDRLP4 320
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRGP4 pvup+8
INDIRF4
CNSTF4 3221225472
ADDRLP4 180
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 1053
;1053:		}
LABELV $1286
line 1054
;1054:		VectorCopy (point, verts[3].xyz);	
ADDRLP4 12+72
ADDRLP4 0
INDIRB
ASGNB 12
line 1055
;1055:		verts[3].st[0] = 1;	
ADDRLP4 12+72+12
CNSTF4 1065353216
ASGNF4
line 1056
;1056:		verts[3].st[1] = 0;	
ADDRLP4 12+72+12+4
CNSTF4 0
ASGNF4
line 1057
;1057:		verts[3].modulate[0] = 255;	
ADDRLP4 12+72+20
CNSTU1 255
ASGNU1
line 1058
;1058:		verts[3].modulate[1] = 255;	
ADDRLP4 12+72+20+1
CNSTU1 255
ASGNU1
line 1059
;1059:		verts[3].modulate[2] = 255;	
ADDRLP4 12+72+20+2
CNSTU1 255
ASGNU1
line 1060
;1060:		verts[3].modulate[3] = 255;	
ADDRLP4 12+72+20+3
CNSTU1 255
ASGNU1
line 1061
;1061:	}
LABELV $1178
LABELV $1106
LABELV $978
LABELV $854
LABELV $608
LABELV $473
LABELV $245
line 1064
;1062:	// done.
;1063:	
;1064:	if (!p->pshader) {
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1316
line 1067
;1065:// (SA) temp commented out for DM
;1066://		CG_Printf ("CG_AddParticleToScene type %d p->pshader == ZERO\n", p->type);
;1067:		return;
ADDRGP4 $243
JUMPV
LABELV $1316
line 1070
;1068:	}
;1069:
;1070:	if (p->type == P_WEATHER || p->type == P_WEATHER_TURBULENT || p->type == P_WEATHER_FLURRY)
ADDRLP4 248
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 248
INDIRI4
CNSTI4 1
EQI4 $1321
ADDRLP4 248
INDIRI4
CNSTI4 5
EQI4 $1321
ADDRLP4 248
INDIRI4
CNSTI4 11
NEI4 $1318
LABELV $1321
line 1071
;1071:		trap_R_AddPolyToScene( p->pshader, 3, TRIverts );
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 108
ARGP4
ADDRGP4 trap_R_AddPolyToScene
CALLV
pop
ADDRGP4 $1319
JUMPV
LABELV $1318
line 1073
;1072:	else
;1073:		trap_R_AddPolyToScene( p->pshader, 4, verts );
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 trap_R_AddPolyToScene
CALLV
pop
LABELV $1319
line 1075
;1074:
;1075:}
LABELV $243
endproc CG_AddParticleToScene 472 16
data
align 4
LABELV roll
byte 4 0
export CG_AddParticles
code
proc CG_AddParticles 96 16
line 1086
;1076:
;1077:// Ridah, made this static so it doesn't interfere with other files
;1078:static float roll = 0.0;
;1079:
;1080:/*
;1081:===============
;1082:CG_AddParticles
;1083:===============
;1084:*/
;1085:void CG_AddParticles (void)
;1086:{
line 1096
;1087:	cparticle_t		*p, *next;
;1088:	float			alpha;
;1089:	float			time, time2;
;1090:	vec3_t			org;
;1091:	int				color;
;1092:	cparticle_t		*active, *tail;
;1093:	int				type;
;1094:	vec3_t			rotate_ang;
;1095:
;1096:	if (!initparticles)
ADDRGP4 initparticles
INDIRI4
CNSTI4 0
NEI4 $1323
line 1097
;1097:		CG_ClearParticles ();
ADDRGP4 CG_ClearParticles
CALLV
pop
LABELV $1323
line 1099
;1098:
;1099:	VectorCopy( cg.refdef.viewaxis[0], pvforward );
ADDRGP4 pvforward
ADDRGP4 cg+109044+36
INDIRB
ASGNB 12
line 1100
;1100:	VectorCopy( cg.refdef.viewaxis[1], pvright );
ADDRGP4 pvright
ADDRGP4 cg+109044+36+12
INDIRB
ASGNB 12
line 1101
;1101:	VectorCopy( cg.refdef.viewaxis[2], pvup );
ADDRGP4 pvup
ADDRGP4 cg+109044+36+24
INDIRB
ASGNB 12
line 1103
;1102:
;1103:	vectoangles( cg.refdef.viewaxis[0], rotate_ang );
ADDRGP4 cg+109044+36
ARGP4
ADDRLP4 48
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1104
;1104:	roll += ((cg.time - oldtime) * 0.1) ;
ADDRLP4 60
ADDRGP4 roll
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
CNSTF4 1036831949
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 oldtime
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1105
;1105:	rotate_ang[ROLL] += (roll*0.9);
ADDRLP4 48+8
ADDRLP4 48+8
INDIRF4
CNSTF4 1063675494
ADDRGP4 roll
INDIRF4
MULF4
ADDF4
ASGNF4
line 1106
;1106:	AngleVectors ( rotate_ang, rforward, rright, rup);
ADDRLP4 48
ARGP4
ADDRGP4 rforward
ARGP4
ADDRGP4 rright
ARGP4
ADDRGP4 rup
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 1108
;1107:	
;1108:	oldtime = cg.time;
ADDRGP4 oldtime
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1110
;1109:
;1110:	active = NULL;
ADDRLP4 44
CNSTP4 0
ASGNP4
line 1111
;1111:	tail = NULL;
ADDRLP4 28
CNSTP4 0
ASGNP4
line 1113
;1112:
;1113:	for (p=active_particles ; p ; p=next)
ADDRLP4 0
ADDRGP4 active_particles
INDIRP4
ASGNP4
ADDRGP4 $1341
JUMPV
LABELV $1338
line 1114
;1114:	{
line 1116
;1115:
;1116:		next = p->next;
ADDRLP4 32
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1118
;1117:
;1118:		time = (cg.time - p->time)*0.001;
ADDRLP4 4
CNSTF4 981668463
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
MULF4
ASGNF4
line 1120
;1119:
;1120:		alpha = p->alpha + time*p->alphavel;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 1121
;1121:		if (alpha <= 0)
ADDRLP4 8
INDIRF4
CNSTF4 0
GTF4 $1343
line 1122
;1122:		{	// faded out
line 1123
;1123:			p->next = free_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1124
;1124:			free_particles = p;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1125
;1125:			p->type = 0;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
line 1126
;1126:			p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1127
;1127:			p->alpha = 0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 0
ASGNF4
line 1128
;1128:			continue;
ADDRGP4 $1339
JUMPV
LABELV $1343
line 1131
;1129:		}
;1130:
;1131:		if (p->type == P_SMOKE || p->type == P_ANIM || p->type == P_BLEED || p->type == P_SMOKE_IMPACT)
ADDRLP4 68
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 3
EQI4 $1349
ADDRLP4 68
INDIRI4
CNSTI4 6
EQI4 $1349
ADDRLP4 68
INDIRI4
CNSTI4 8
EQI4 $1349
ADDRLP4 68
INDIRI4
CNSTI4 12
NEI4 $1345
LABELV $1349
line 1132
;1132:		{
line 1133
;1133:			if (cg.time > p->endtime)
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
LEF4 $1350
line 1134
;1134:			{
line 1135
;1135:				p->next = free_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1136
;1136:				free_particles = p;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1137
;1137:				p->type = 0;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
line 1138
;1138:				p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1139
;1139:				p->alpha = 0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 0
ASGNF4
line 1141
;1140:			
;1141:				continue;
ADDRGP4 $1339
JUMPV
LABELV $1350
line 1144
;1142:			}
;1143:
;1144:		}
LABELV $1345
line 1146
;1145:
;1146:		if (p->type == P_WEATHER_FLURRY)
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 11
NEI4 $1353
line 1147
;1147:		{
line 1148
;1148:			if (cg.time > p->endtime)
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
LEF4 $1355
line 1149
;1149:			{
line 1150
;1150:				p->next = free_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1151
;1151:				free_particles = p;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1152
;1152:				p->type = 0;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
line 1153
;1153:				p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1154
;1154:				p->alpha = 0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 0
ASGNF4
line 1156
;1155:			
;1156:				continue;
ADDRGP4 $1339
JUMPV
LABELV $1355
line 1158
;1157:			}
;1158:		}
LABELV $1353
line 1161
;1159:
;1160:
;1161:		if (p->type == P_FLAT_SCALEUP_FADE)
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 10
NEI4 $1358
line 1162
;1162:		{
line 1163
;1163:			if (cg.time > p->endtime)
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
LEF4 $1360
line 1164
;1164:			{
line 1165
;1165:				p->next = free_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1166
;1166:				free_particles = p;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1167
;1167:				p->type = 0;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
line 1168
;1168:				p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1169
;1169:				p->alpha = 0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 0
ASGNF4
line 1170
;1170:				continue;
ADDRGP4 $1339
JUMPV
LABELV $1360
line 1173
;1171:			}
;1172:
;1173:		}
LABELV $1358
line 1175
;1174:
;1175:		if ((p->type == P_BAT || p->type == P_SPRITE) && p->endtime < 0) {
ADDRLP4 72
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 7
EQI4 $1365
ADDRLP4 72
INDIRI4
CNSTI4 15
NEI4 $1363
LABELV $1365
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1363
line 1177
;1176:			// temporary sprite
;1177:			CG_AddParticleToScene (p, p->org, alpha);
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRLP4 8
INDIRF4
ARGF4
ADDRGP4 CG_AddParticleToScene
CALLV
pop
line 1178
;1178:			p->next = free_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1179
;1179:			free_particles = p;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1180
;1180:			p->type = 0;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
line 1181
;1181:			p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1182
;1182:			p->alpha = 0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 0
ASGNF4
line 1183
;1183:			continue;
ADDRGP4 $1339
JUMPV
LABELV $1363
line 1186
;1184:		}
;1185:
;1186:		p->next = NULL;
ADDRLP4 0
INDIRP4
CNSTP4 0
ASGNP4
line 1187
;1187:		if (!tail)
ADDRLP4 28
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1366
line 1188
;1188:			active = tail = p;
ADDRLP4 28
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 44
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $1367
JUMPV
LABELV $1366
line 1190
;1189:		else
;1190:		{
line 1191
;1191:			tail->next = p;
ADDRLP4 28
INDIRP4
ADDRLP4 0
INDIRP4
ASGNP4
line 1192
;1192:			tail = p;
ADDRLP4 28
ADDRLP4 0
INDIRP4
ASGNP4
line 1193
;1193:		}
LABELV $1367
line 1195
;1194:
;1195:		if (alpha > 1.0)
ADDRLP4 8
INDIRF4
CNSTF4 1065353216
LEF4 $1368
line 1196
;1196:			alpha = 1;
ADDRLP4 8
CNSTF4 1065353216
ASGNF4
LABELV $1368
line 1198
;1197:
;1198:		color = p->color;
ADDRLP4 36
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
ASGNI4
line 1200
;1199:
;1200:		time2 = time*time;
ADDRLP4 12
ADDRLP4 4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 1202
;1201:
;1202:		org[0] = p->org[0] + p->vel[0]*time + p->accel[0]*time2;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ADDF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
line 1203
;1203:		org[1] = p->org[1] + p->vel[1]*time + p->accel[1]*time2;
ADDRLP4 16+4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ADDF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
line 1204
;1204:		org[2] = p->org[2] + p->vel[2]*time + p->accel[2]*time2;
ADDRLP4 16+8
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ADDF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
line 1206
;1205:
;1206:		type = p->type;
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
line 1208
;1207:
;1208:		CG_AddParticleToScene (p, org, alpha);
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 8
INDIRF4
ARGF4
ADDRGP4 CG_AddParticleToScene
CALLV
pop
line 1209
;1209:	}
LABELV $1339
line 1113
ADDRLP4 0
ADDRLP4 32
INDIRP4
ASGNP4
LABELV $1341
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1338
line 1211
;1210:
;1211:	active_particles = active;
ADDRGP4 active_particles
ADDRLP4 44
INDIRP4
ASGNP4
line 1212
;1212:}
LABELV $1322
endproc CG_AddParticles 96 16
export CG_ParticleSnowFlurry
proc CG_ParticleSnowFlurry 68 4
line 1220
;1213:
;1214:/*
;1215:======================
;1216:CG_AddParticles
;1217:======================
;1218:*/
;1219:void CG_ParticleSnowFlurry (qhandle_t pshader, centity_t *cent)
;1220:{
line 1222
;1221:	cparticle_t	*p;
;1222:	qboolean turb = qtrue;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1224
;1223:
;1224:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1373
line 1225
;1225:		CG_Printf ("CG_ParticleSnowFlurry pshader == ZERO!\n");
ADDRGP4 $1375
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1373
line 1227
;1226:
;1227:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1376
line 1228
;1228:		return;
ADDRGP4 $1372
JUMPV
LABELV $1376
line 1229
;1229:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1230
;1230:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1231
;1231:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1232
;1232:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1233
;1233:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1234
;1234:	p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1235
;1235:	p->alpha = 0.90f;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1063675494
ASGNF4
line 1236
;1236:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1238
;1237:
;1238:	p->start = cent->currentState.origin2[0];
ADDRLP4 0
INDIRP4
CNSTI4 88
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
ASGNF4
line 1239
;1239:	p->end = cent->currentState.origin2[1];
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRF4
ASGNF4
line 1241
;1240:	
;1241:	p->endtime = cg.time + cent->currentState.time;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1242
;1242:	p->startfade = cg.time + cent->currentState.time2;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 88
ADDP4
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1244
;1243:	
;1244:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1246
;1245:	
;1246:	if (rand()%100 > 90)
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 100
MODI4
CNSTI4 90
LEI4 $1381
line 1247
;1247:	{
line 1248
;1248:		p->height = 32;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1107296256
ASGNF4
line 1249
;1249:		p->width = 32;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1107296256
ASGNF4
line 1250
;1250:		p->alpha = 0.10f;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1036831949
ASGNF4
line 1251
;1251:	}
ADDRGP4 $1382
JUMPV
LABELV $1381
line 1253
;1252:	else
;1253:	{
line 1254
;1254:		p->height = 1;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1065353216
ASGNF4
line 1255
;1255:		p->width = 1;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1065353216
ASGNF4
line 1256
;1256:	}
LABELV $1382
line 1258
;1257:
;1258:	p->vel[2] = -20;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3248488448
ASGNF4
line 1260
;1259:
;1260:	p->type = P_WEATHER_FLURRY;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 11
ASGNI4
line 1262
;1261:	
;1262:	if (turb)
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $1383
line 1263
;1263:		p->vel[2] = -10;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3240099840
ASGNF4
LABELV $1383
line 1265
;1264:	
;1265:	VectorCopy(cent->currentState.origin, p->org);
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1267
;1266:
;1267:	p->org[0] = p->org[0];
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRF4
ASGNF4
line 1268
;1268:	p->org[1] = p->org[1];
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRF4
ASGNF4
line 1269
;1269:	p->org[2] = p->org[2];
ADDRLP4 20
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRF4
ASGNF4
line 1271
;1270:
;1271:	p->vel[0] = p->vel[1] = 0;
ADDRLP4 28
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
line 1273
;1272:	
;1273:	p->accel[0] = p->accel[1] = p->accel[2] = 0;
ADDRLP4 36
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
line 1275
;1274:
;1275:	p->vel[0] += cent->currentState.angles[0] * 32 + (crandom() * 16);
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRF4
CNSTF4 1107296256
ADDRFP4 4
INDIRP4
CNSTI4 116
ADDP4
INDIRF4
MULF4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 40
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ADDF4
ASGNF4
line 1276
;1276:	p->vel[1] += cent->currentState.angles[1] * 32 + (crandom() * 16);
ADDRLP4 48
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 52
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRF4
CNSTF4 1107296256
ADDRFP4 4
INDIRP4
CNSTI4 120
ADDP4
INDIRF4
MULF4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 48
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ADDF4
ASGNF4
line 1277
;1277:	p->vel[2] += cent->currentState.angles[2];
ADDRLP4 56
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
ADDF4
ASGNF4
line 1279
;1278:
;1279:	if (turb)
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $1385
line 1280
;1280:	{
line 1281
;1281:		p->accel[0] = crandom () * 16;
ADDRLP4 60
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 60
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 1282
;1282:		p->accel[1] = crandom () * 16;
ADDRLP4 64
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 64
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 1283
;1283:	}
LABELV $1385
line 1285
;1284:
;1285:}
LABELV $1372
endproc CG_ParticleSnowFlurry 68 4
export CG_ParticleSnow
proc CG_ParticleSnow 56 4
line 1288
;1286:
;1287:void CG_ParticleSnow (qhandle_t pshader, vec3_t origin, vec3_t origin2, int turb, float range, int snum)
;1288:{
line 1291
;1289:	cparticle_t	*p;
;1290:
;1291:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1388
line 1292
;1292:		CG_Printf ("CG_ParticleSnow pshader == ZERO!\n");
ADDRGP4 $1390
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1388
line 1294
;1293:
;1294:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1391
line 1295
;1295:		return;
ADDRGP4 $1387
JUMPV
LABELV $1391
line 1296
;1296:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1297
;1297:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1298
;1298:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1299
;1299:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1300
;1300:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1301
;1301:	p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1302
;1302:	p->alpha = 0.40f;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1053609165
ASGNF4
line 1303
;1303:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1304
;1304:	p->start = origin[2];
ADDRLP4 0
INDIRP4
CNSTI4 88
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1305
;1305:	p->end = origin2[2];
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRFP4 8
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1306
;1306:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1307
;1307:	p->height = 1;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1065353216
ASGNF4
line 1308
;1308:	p->width = 1;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1065353216
ASGNF4
line 1310
;1309:	
;1310:	p->vel[2] = -50;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3259498496
ASGNF4
line 1312
;1311:
;1312:	if (turb)
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $1394
line 1313
;1313:	{
line 1314
;1314:		p->type = P_WEATHER_TURBULENT;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 5
ASGNI4
line 1315
;1315:		p->vel[2] = -50 * 1.3;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3263299584
ASGNF4
line 1316
;1316:	}
ADDRGP4 $1395
JUMPV
LABELV $1394
line 1318
;1317:	else
;1318:	{
line 1319
;1319:		p->type = P_WEATHER;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 1
ASGNI4
line 1320
;1320:	}
LABELV $1395
line 1322
;1321:	
;1322:	VectorCopy(origin, p->org);
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 1324
;1323:
;1324:	p->org[0] = p->org[0] + ( crandom() * range);
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 4
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 1325
;1325:	p->org[1] = p->org[1] + ( crandom() * range);
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 1326
;1326:	p->org[2] = p->org[2] + ( crandom() * (p->start - p->end)); 
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 24
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 20
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 0
INDIRP4
CNSTI4 88
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1328
;1327:
;1328:	p->vel[0] = p->vel[1] = 0;
ADDRLP4 36
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
line 1330
;1329:	
;1330:	p->accel[0] = p->accel[1] = p->accel[2] = 0;
ADDRLP4 44
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 44
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 44
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 44
INDIRF4
ASGNF4
line 1332
;1331:
;1332:	if (turb)
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $1396
line 1333
;1333:	{
line 1334
;1334:		p->vel[0] = crandom() * 16;
ADDRLP4 48
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 48
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 1335
;1335:		p->vel[1] = crandom() * 16;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1098907648
CNSTF4 1073741824
ADDRLP4 52
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 1336
;1336:	}
LABELV $1396
line 1339
;1337:
;1338:	// Rafael snow pvs check
;1339:	p->snum = snum;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 1340
;1340:	p->link = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
CNSTI4 1
ASGNI4
line 1342
;1341:
;1342:}
LABELV $1387
endproc CG_ParticleSnow 56 4
export CG_ParticleBubble
proc CG_ParticleBubble 68 4
line 1345
;1343:
;1344:void CG_ParticleBubble (qhandle_t pshader, vec3_t origin, vec3_t origin2, int turb, float range, int snum)
;1345:{
line 1349
;1346:	cparticle_t	*p;
;1347:	float		randsize;
;1348:
;1349:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1399
line 1350
;1350:		CG_Printf ("CG_ParticleSnow pshader == ZERO!\n");
ADDRGP4 $1390
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1399
line 1352
;1351:
;1352:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1401
line 1353
;1353:		return;
ADDRGP4 $1398
JUMPV
LABELV $1401
line 1354
;1354:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1355
;1355:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1356
;1356:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1357
;1357:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1358
;1358:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1359
;1359:	p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1360
;1360:	p->alpha = 0.40f;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1053609165
ASGNF4
line 1361
;1361:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1362
;1362:	p->start = origin[2];
ADDRLP4 0
INDIRP4
CNSTI4 88
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1363
;1363:	p->end = origin2[2];
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRFP4 8
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1364
;1364:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1366
;1365:	
;1366:	randsize = 1 + (crandom() * 0.5);
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
CNSTF4 1056964608
CNSTF4 1073741824
ADDRLP4 8
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 1368
;1367:	
;1368:	p->height = randsize;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDRLP4 4
INDIRF4
ASGNF4
line 1369
;1369:	p->width = randsize;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
ADDRLP4 4
INDIRF4
ASGNF4
line 1371
;1370:	
;1371:	p->vel[2] = 50 + ( crandom() * 10 );
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1092616192
CNSTF4 1073741824
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1112014848
ADDF4
ASGNF4
line 1373
;1372:
;1373:	if (turb)
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $1404
line 1374
;1374:	{
line 1375
;1375:		p->type = P_BUBBLE_TURBULENT;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 14
ASGNI4
line 1376
;1376:		p->vel[2] = 50 * 1.3;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1115815936
ASGNF4
line 1377
;1377:	}
ADDRGP4 $1405
JUMPV
LABELV $1404
line 1379
;1378:	else
;1379:	{
line 1380
;1380:		p->type = P_BUBBLE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 13
ASGNI4
line 1381
;1381:	}
LABELV $1405
line 1383
;1382:	
;1383:	VectorCopy(origin, p->org);
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 1385
;1384:
;1385:	p->org[0] = p->org[0] + ( crandom() * range);
ADDRLP4 16
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 16
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 1386
;1386:	p->org[1] = p->org[1] + ( crandom() * range);
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 28
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 24
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 1387
;1387:	p->org[2] = p->org[2] + ( crandom() * (p->start - p->end)); 
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 36
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 32
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRLP4 0
INDIRP4
CNSTI4 88
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1389
;1388:
;1389:	p->vel[0] = p->vel[1] = 0;
ADDRLP4 48
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 48
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 48
INDIRF4
ASGNF4
line 1391
;1390:	
;1391:	p->accel[0] = p->accel[1] = p->accel[2] = 0;
ADDRLP4 56
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 56
INDIRF4
ASGNF4
line 1393
;1392:
;1393:	if (turb)
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $1406
line 1394
;1394:	{
line 1395
;1395:		p->vel[0] = crandom() * 4;
ADDRLP4 60
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 60
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 1396
;1396:		p->vel[1] = crandom() * 4;
ADDRLP4 64
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 64
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 1397
;1397:	}
LABELV $1406
line 1400
;1398:
;1399:	// Rafael snow pvs check
;1400:	p->snum = snum;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
ADDRFP4 20
INDIRI4
ASGNI4
line 1401
;1401:	p->link = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
CNSTI4 1
ASGNI4
line 1403
;1402:
;1403:}
LABELV $1398
endproc CG_ParticleBubble 68 4
export CG_ParticleSmoke
proc CG_ParticleSmoke 28 4
line 1406
;1404:
;1405:void CG_ParticleSmoke (qhandle_t pshader, centity_t *cent)
;1406:{
line 1412
;1407:
;1408:	// using cent->density = enttime
;1409:	//		 cent->frame = startfade
;1410:	cparticle_t	*p;
;1411:
;1412:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1409
line 1413
;1413:		CG_Printf ("CG_ParticleSmoke == ZERO!\n");
ADDRGP4 $1411
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1409
line 1415
;1414:
;1415:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1412
line 1416
;1416:		return;
ADDRGP4 $1408
JUMPV
LABELV $1412
line 1417
;1417:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1418
;1418:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1419
;1419:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1420
;1420:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1421
;1421:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1423
;1422:	
;1423:	p->endtime = cg.time + cent->currentState.time;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1424
;1424:	p->startfade = cg.time + cent->currentState.time2;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 88
ADDP4
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1426
;1425:	
;1426:	p->color = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 1427
;1427:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 1428
;1428:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1429
;1429:	p->start = cent->currentState.origin[2];
ADDRLP4 0
INDIRP4
CNSTI4 88
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ASGNF4
line 1430
;1430:	p->end = cent->currentState.origin2[2];
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 112
ADDP4
INDIRF4
ASGNF4
line 1431
;1431:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1432
;1432:	p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 1433
;1433:	p->height = 8;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1090519040
ASGNF4
line 1434
;1434:	p->width = 8;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1090519040
ASGNF4
line 1435
;1435:	p->endheight = 32;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1107296256
ASGNF4
line 1436
;1436:	p->endwidth = 32;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1107296256
ASGNF4
line 1437
;1437:	p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 1439
;1438:	
;1439:	VectorCopy(cent->currentState.origin, p->org);
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1441
;1440:
;1441:	p->vel[0] = p->vel[1] = 0;
ADDRLP4 8
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
line 1442
;1442:	p->accel[0] = p->accel[1] = p->accel[2] = 0;
ADDRLP4 16
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
line 1444
;1443:
;1444:	p->vel[2] = 5;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1084227584
ASGNF4
line 1446
;1445:
;1446:	if (cent->currentState.frame == 1)// reverse gravity	
ADDRFP4 4
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
CNSTI4 1
NEI4 $1417
line 1447
;1447:		p->vel[2] *= -1;
ADDRLP4 20
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTF4 3212836864
ADDRLP4 20
INDIRP4
INDIRF4
MULF4
ASGNF4
LABELV $1417
line 1449
;1448:
;1449:	p->roll = 8 + (crandom() * 4);
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 24
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1090519040
ADDF4
CVFI4 4
ASGNI4
line 1450
;1450:}
LABELV $1408
endproc CG_ParticleSmoke 28 4
export CG_ParticleBulletDebris
proc CG_ParticleBulletDebris 16 0
line 1454
;1451:
;1452:
;1453:void CG_ParticleBulletDebris (vec3_t org, vec3_t vel, int duration)
;1454:{
line 1458
;1455:
;1456:	cparticle_t	*p;
;1457:
;1458:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1420
line 1459
;1459:		return;
ADDRGP4 $1419
JUMPV
LABELV $1420
line 1460
;1460:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1461
;1461:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1462
;1462:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1463
;1463:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1464
;1464:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1466
;1465:	
;1466:	p->endtime = cg.time + duration;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1467
;1467:	p->startfade = cg.time + duration/2;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 8
INDIRI4
CNSTI4 2
DIVI4
ADDI4
CVIF4 4
ASGNF4
line 1469
;1468:	
;1469:	p->color = EMISIVEFADE;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 3
ASGNI4
line 1470
;1470:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 1471
;1471:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1473
;1472:
;1473:	p->height = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1056964608
ASGNF4
line 1474
;1474:	p->width = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1056964608
ASGNF4
line 1475
;1475:	p->endheight = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1056964608
ASGNF4
line 1476
;1476:	p->endwidth = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1056964608
ASGNF4
line 1478
;1477:
;1478:	p->pshader = cgs.media.tracerShader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRGP4 cgs+152340+220
INDIRI4
ASGNI4
line 1480
;1479:
;1480:	p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 1482
;1481:	
;1482:	VectorCopy(org, p->org);
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1484
;1483:
;1484:	p->vel[0] = vel[0];
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 4
INDIRP4
INDIRF4
ASGNF4
line 1485
;1485:	p->vel[1] = vel[1];
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ASGNF4
line 1486
;1486:	p->vel[2] = vel[2];
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1487
;1487:	p->accel[0] = p->accel[1] = p->accel[2] = 0;
ADDRLP4 8
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
line 1489
;1488:
;1489:	p->accel[2] = -60;
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTF4 3262119936
ASGNF4
line 1490
;1490:	p->vel[2] += -20;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRF4
CNSTF4 3248488448
ADDF4
ASGNF4
line 1492
;1491:	
;1492:}
LABELV $1419
endproc CG_ParticleBulletDebris 16 0
export CG_ParticleExplosion
proc CG_ParticleExplosion 16 8
line 1501
;1493:
;1494:/*
;1495:======================
;1496:CG_ParticleExplosion
;1497:======================
;1498:*/
;1499:
;1500:void CG_ParticleExplosion (char *animStr, vec3_t origin, vec3_t vel, int duration, int sizeStart, int sizeEnd)
;1501:{
line 1505
;1502:	cparticle_t	*p;
;1503:	int anim;
;1504:
;1505:	if (animStr < (char *)10)
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 10
GEU4 $1428
line 1506
;1506:		CG_Error( "CG_ParticleExplosion: animStr is probably an index rather than a string" );
ADDRGP4 $1430
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $1428
line 1509
;1507:
;1508:	// find the animation string
;1509:	for (anim=0; shaderAnimNames[anim]; anim++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1434
JUMPV
LABELV $1431
line 1510
;1510:		if (!Q_stricmp( animStr, shaderAnimNames[anim] ))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimNames
ADDP4
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $1435
line 1511
;1511:			break;
ADDRGP4 $1433
JUMPV
LABELV $1435
line 1512
;1512:	}
LABELV $1432
line 1509
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1434
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimNames
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1431
LABELV $1433
line 1513
;1513:	if (!shaderAnimNames[anim]) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimNames
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1437
line 1514
;1514:		CG_Error("CG_ParticleExplosion: unknown animation string: %s\n", animStr);
ADDRGP4 $1439
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1515
;1515:		return;
ADDRGP4 $1427
JUMPV
LABELV $1437
line 1518
;1516:	}
;1517:
;1518:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1440
line 1519
;1519:		return;
ADDRGP4 $1427
JUMPV
LABELV $1440
line 1520
;1520:	p = free_particles;
ADDRLP4 4
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1521
;1521:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 4
INDIRP4
INDIRP4
ASGNP4
line 1522
;1522:	p->next = active_particles;
ADDRLP4 4
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1523
;1523:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 4
INDIRP4
ASGNP4
line 1524
;1524:	p->time = cg.time;
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1525
;1525:	p->alpha = 0.5;
ADDRLP4 4
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1056964608
ASGNF4
line 1526
;1526:	p->alphavel = 0;
ADDRLP4 4
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1528
;1527:
;1528:	if (duration < 0) {
ADDRFP4 12
INDIRI4
CNSTI4 0
GEI4 $1443
line 1529
;1529:		duration *= -1;
ADDRFP4 12
CNSTI4 -1
ADDRFP4 12
INDIRI4
MULI4
ASGNI4
line 1530
;1530:		p->roll = 0;
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 1531
;1531:	} else {
ADDRGP4 $1444
JUMPV
LABELV $1443
line 1532
;1532:		p->roll = crandom()*179;
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
CNSTF4 1127415808
CNSTF4 1073741824
ADDRLP4 8
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CVFI4 4
ASGNI4
line 1533
;1533:	}
LABELV $1444
line 1535
;1534:
;1535:	p->shaderAnim = anim;
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1537
;1536:
;1537:	p->width = sizeStart;
ADDRLP4 4
INDIRP4
CNSTI4 76
ADDP4
ADDRFP4 16
INDIRI4
CVIF4 4
ASGNF4
line 1538
;1538:	p->height = sizeStart*shaderAnimSTRatio[anim];	// for sprites that are stretch in either direction
ADDRLP4 4
INDIRP4
CNSTI4 72
ADDP4
ADDRFP4 16
INDIRI4
CVIF4 4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimSTRatio
ADDP4
INDIRF4
MULF4
ASGNF4
line 1540
;1539:
;1540:	p->endheight = sizeEnd;
ADDRLP4 4
INDIRP4
CNSTI4 80
ADDP4
ADDRFP4 20
INDIRI4
CVIF4 4
ASGNF4
line 1541
;1541:	p->endwidth = sizeEnd*shaderAnimSTRatio[anim];
ADDRLP4 4
INDIRP4
CNSTI4 84
ADDP4
ADDRFP4 20
INDIRI4
CVIF4 4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 shaderAnimSTRatio
ADDP4
INDIRF4
MULF4
ASGNF4
line 1543
;1542:
;1543:	p->endtime = cg.time + duration;
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 12
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1545
;1544:
;1545:	p->type = P_ANIM;
ADDRLP4 4
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 6
ASGNI4
line 1547
;1546:
;1547:	VectorCopy( origin, p->org );
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 1548
;1548:	VectorCopy( vel, p->vel );
ADDRLP4 4
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 8
INDIRP4
INDIRB
ASGNB 12
line 1549
;1549:	VectorClear( p->accel );
ADDRLP4 12
CNSTF4 0
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 12
INDIRF4
ASGNF4
line 1551
;1550:
;1551:}
LABELV $1427
endproc CG_ParticleExplosion 16 8
export CG_AddParticleShrapnel
proc CG_AddParticleShrapnel 0 0
line 1555
;1552:
;1553:// Rafael Shrapnel
;1554:void CG_AddParticleShrapnel (localEntity_t *le)
;1555:{
line 1556
;1556:	return;
LABELV $1446
endproc CG_AddParticleShrapnel 0 0
export CG_NewParticleArea
proc CG_NewParticleArea 92 24
line 1561
;1557:}
;1558:// done.
;1559:
;1560:int CG_NewParticleArea (int num)
;1561:{
line 1568
;1562:	// const char *str;
;1563:	char *str;
;1564:	char *token;
;1565:	int type;
;1566:	vec3_t origin, origin2;
;1567:	int		i;
;1568:	float range = 0;
ADDRLP4 40
CNSTF4 0
ASGNF4
line 1573
;1569:	int turb;
;1570:	int	numparticles;
;1571:	int	snum;
;1572:	
;1573:	str = (char *) CG_ConfigString (num);
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 56
INDIRP4
ASGNP4
line 1574
;1574:	if (!str[0])
ADDRLP4 8
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1448
line 1575
;1575:		return (0);
CNSTI4 0
RETI4
ADDRGP4 $1447
JUMPV
LABELV $1448
line 1578
;1576:	
;1577:	// returns type 128 64 or 32
;1578:	token = COM_Parse (&str);
ADDRLP4 8
ARGP4
ADDRLP4 60
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 60
INDIRP4
ASGNP4
line 1579
;1579:	type = atoi (token);
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 36
ADDRLP4 64
INDIRI4
ASGNI4
line 1581
;1580:	
;1581:	if (type == 1)
ADDRLP4 36
INDIRI4
CNSTI4 1
NEI4 $1450
line 1582
;1582:		range = 128;
ADDRLP4 40
CNSTF4 1124073472
ASGNF4
ADDRGP4 $1451
JUMPV
LABELV $1450
line 1583
;1583:	else if (type == 2)
ADDRLP4 36
INDIRI4
CNSTI4 2
NEI4 $1452
line 1584
;1584:		range = 64;
ADDRLP4 40
CNSTF4 1115684864
ASGNF4
ADDRGP4 $1453
JUMPV
LABELV $1452
line 1585
;1585:	else if (type == 3)
ADDRLP4 36
INDIRI4
CNSTI4 3
NEI4 $1454
line 1586
;1586:		range = 32;
ADDRLP4 40
CNSTF4 1107296256
ASGNF4
ADDRGP4 $1455
JUMPV
LABELV $1454
line 1587
;1587:	else if (type == 0)
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $1456
line 1588
;1588:		range = 256;
ADDRLP4 40
CNSTF4 1132462080
ASGNF4
ADDRGP4 $1457
JUMPV
LABELV $1456
line 1589
;1589:	else if (type == 4)
ADDRLP4 36
INDIRI4
CNSTI4 4
NEI4 $1458
line 1590
;1590:		range = 8;
ADDRLP4 40
CNSTF4 1090519040
ASGNF4
ADDRGP4 $1459
JUMPV
LABELV $1458
line 1591
;1591:	else if (type == 5)
ADDRLP4 36
INDIRI4
CNSTI4 5
NEI4 $1460
line 1592
;1592:		range = 16;
ADDRLP4 40
CNSTF4 1098907648
ASGNF4
ADDRGP4 $1461
JUMPV
LABELV $1460
line 1593
;1593:	else if (type == 6)
ADDRLP4 36
INDIRI4
CNSTI4 6
NEI4 $1462
line 1594
;1594:		range = 32;
ADDRLP4 40
CNSTF4 1107296256
ASGNF4
ADDRGP4 $1463
JUMPV
LABELV $1462
line 1595
;1595:	else if (type == 7)
ADDRLP4 36
INDIRI4
CNSTI4 7
NEI4 $1464
line 1596
;1596:		range = 64;
ADDRLP4 40
CNSTF4 1115684864
ASGNF4
LABELV $1464
LABELV $1463
LABELV $1461
LABELV $1459
LABELV $1457
LABELV $1455
LABELV $1453
LABELV $1451
line 1599
;1597:
;1598:
;1599:	for (i=0; i<3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1466
line 1600
;1600:	{
line 1601
;1601:		token = COM_Parse (&str);
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 68
INDIRP4
ASGNP4
line 1602
;1602:		origin[i] = atof (token);
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 atof
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 12
ADDP4
ADDRLP4 72
INDIRF4
ASGNF4
line 1603
;1603:	}
LABELV $1467
line 1599
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1466
line 1605
;1604:
;1605:	for (i=0; i<3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1470
line 1606
;1606:	{
line 1607
;1607:		token = COM_Parse (&str);
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 68
INDIRP4
ASGNP4
line 1608
;1608:		origin2[i] = atof (token);
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 atof
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 24
ADDP4
ADDRLP4 72
INDIRF4
ASGNF4
line 1609
;1609:	}
LABELV $1471
line 1605
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1470
line 1611
;1610:		
;1611:	token = COM_Parse (&str);
ADDRLP4 8
ARGP4
ADDRLP4 68
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 68
INDIRP4
ASGNP4
line 1612
;1612:	numparticles = atoi (token);
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 48
ADDRLP4 72
INDIRI4
ASGNI4
line 1614
;1613:	
;1614:	token = COM_Parse (&str);
ADDRLP4 8
ARGP4
ADDRLP4 76
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 76
INDIRP4
ASGNP4
line 1615
;1615:	turb = atoi (token);
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 80
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 80
INDIRI4
ASGNI4
line 1617
;1616:
;1617:	token = COM_Parse (&str);
ADDRLP4 8
ARGP4
ADDRLP4 84
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 84
INDIRP4
ASGNP4
line 1618
;1618:	snum = atoi (token);
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 88
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 52
ADDRLP4 88
INDIRI4
ASGNI4
line 1620
;1619:	
;1620:	for (i=0; i<numparticles; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1477
JUMPV
LABELV $1474
line 1621
;1621:	{
line 1622
;1622:		if (type >= 4)
ADDRLP4 36
INDIRI4
CNSTI4 4
LTI4 $1478
line 1623
;1623:			CG_ParticleBubble (cgs.media.waterBubbleShader, origin, origin2, turb, range, snum);
ADDRGP4 cgs+152340+292
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 40
INDIRF4
ARGF4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 CG_ParticleBubble
CALLV
pop
ADDRGP4 $1479
JUMPV
LABELV $1478
line 1625
;1624:		else
;1625:			CG_ParticleSnow (cgs.media.waterBubbleShader, origin, origin2, turb, range, snum);
ADDRGP4 cgs+152340+292
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 40
INDIRF4
ARGF4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 CG_ParticleSnow
CALLV
pop
LABELV $1479
line 1626
;1626:	}
LABELV $1475
line 1620
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1477
ADDRLP4 0
INDIRI4
ADDRLP4 48
INDIRI4
LTI4 $1474
line 1628
;1627:
;1628:	return (1);
CNSTI4 1
RETI4
LABELV $1447
endproc CG_NewParticleArea 92 24
export CG_SnowLink
proc CG_SnowLink 16 0
line 1632
;1629:}
;1630:
;1631:void	CG_SnowLink (centity_t *cent, qboolean particleOn)
;1632:{
line 1636
;1633:	cparticle_t		*p, *next;
;1634:	int id;
;1635:
;1636:	id = cent->currentState.frame;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ASGNI4
line 1638
;1637:
;1638:	for (p=active_particles ; p ; p=next)
ADDRLP4 0
ADDRGP4 active_particles
INDIRP4
ASGNP4
ADDRGP4 $1488
JUMPV
LABELV $1485
line 1639
;1639:	{
line 1640
;1640:		next = p->next;
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1642
;1641:		
;1642:		if (p->type == P_WEATHER || p->type == P_WEATHER_TURBULENT)
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 1
EQI4 $1491
ADDRLP4 12
INDIRI4
CNSTI4 5
NEI4 $1489
LABELV $1491
line 1643
;1643:		{
line 1644
;1644:			if (p->snum == id)
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $1492
line 1645
;1645:			{
line 1646
;1646:				if (particleOn)
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $1494
line 1647
;1647:					p->link = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
CNSTI4 1
ASGNI4
ADDRGP4 $1495
JUMPV
LABELV $1494
line 1649
;1648:				else
;1649:					p->link = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
CNSTI4 0
ASGNI4
LABELV $1495
line 1650
;1650:			}
LABELV $1492
line 1651
;1651:		}
LABELV $1489
line 1653
;1652:
;1653:	}
LABELV $1486
line 1638
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
LABELV $1488
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1485
line 1654
;1654:}
LABELV $1484
endproc CG_SnowLink 16 0
export CG_ParticleImpactSmokePuff
proc CG_ParticleImpactSmokePuff 24 4
line 1657
;1655:
;1656:void CG_ParticleImpactSmokePuff (qhandle_t pshader, vec3_t origin)
;1657:{
line 1660
;1658:	cparticle_t	*p;
;1659:
;1660:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1497
line 1661
;1661:		CG_Printf ("CG_ParticleImpactSmokePuff pshader == ZERO!\n");
ADDRGP4 $1499
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1497
line 1663
;1662:
;1663:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1500
line 1664
;1664:		return;
ADDRGP4 $1496
JUMPV
LABELV $1500
line 1665
;1665:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1666
;1666:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1667
;1667:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1668
;1668:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1669
;1669:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1670
;1670:	p->alpha = 0.25;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1048576000
ASGNF4
line 1671
;1671:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1672
;1672:	p->roll = crandom()*179;
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTF4 1127415808
CNSTF4 1073741824
ADDRLP4 4
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CVFI4 4
ASGNI4
line 1674
;1673:
;1674:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1676
;1675:
;1676:	p->endtime = cg.time + 1000;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 1000
ADDI4
CVIF4 4
ASGNF4
line 1677
;1677:	p->startfade = cg.time + 100;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
ASGNF4
line 1679
;1678:
;1679:	p->width = rand()%4 + 8;
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
ADDRLP4 8
INDIRI4
CNSTI4 4
MODI4
CNSTI4 8
ADDI4
CVIF4 4
ASGNF4
line 1680
;1680:	p->height = rand()%4 + 8;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDRLP4 12
INDIRI4
CNSTI4 4
MODI4
CNSTI4 8
ADDI4
CVIF4 4
ASGNF4
line 1682
;1681:
;1682:	p->endheight = p->height *2;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1073741824
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
MULF4
ASGNF4
line 1683
;1683:	p->endwidth = p->width * 2;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1073741824
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
MULF4
ASGNF4
line 1685
;1684:
;1685:	p->endtime = cg.time + 500;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 500
ADDI4
CVIF4 4
ASGNF4
line 1687
;1686:
;1687:	p->type = P_SMOKE_IMPACT;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 12
ASGNI4
line 1689
;1688:
;1689:	VectorCopy( origin, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 1690
;1690:	VectorSet(p->vel, 0, 0, 20);
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1101004800
ASGNF4
line 1691
;1691:	VectorSet(p->accel, 0, 0, 20);
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTF4 1101004800
ASGNF4
line 1693
;1692:
;1693:	p->rotate = qtrue;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 1
ASGNI4
line 1694
;1694:}
LABELV $1496
endproc CG_ParticleImpactSmokePuff 24 4
export CG_Particle_Bleed
proc CG_Particle_Bleed 24 4
line 1697
;1695:
;1696:void CG_Particle_Bleed (qhandle_t pshader, vec3_t start, vec3_t dir, int fleshEntityNum, int duration)
;1697:{
line 1700
;1698:	cparticle_t	*p;
;1699:
;1700:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1507
line 1701
;1701:		CG_Printf ("CG_Particle_Bleed pshader == ZERO!\n");
ADDRGP4 $1509
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1507
line 1703
;1702:
;1703:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1510
line 1704
;1704:		return;
ADDRGP4 $1506
JUMPV
LABELV $1510
line 1705
;1705:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1706
;1706:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1707
;1707:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1708
;1708:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1709
;1709:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1710
;1710:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 1711
;1711:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1712
;1712:	p->roll = 0;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 1714
;1713:
;1714:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1716
;1715:
;1716:	p->endtime = cg.time + duration;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 16
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 1718
;1717:	
;1718:	if (fleshEntityNum)
ADDRFP4 12
INDIRI4
CNSTI4 0
EQI4 $1514
line 1719
;1719:		p->startfade = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
ADDRGP4 $1515
JUMPV
LABELV $1514
line 1721
;1720:	else
;1721:		p->startfade = cg.time + 100;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
ASGNF4
LABELV $1515
line 1723
;1722:
;1723:	p->width = 4;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1082130432
ASGNF4
line 1724
;1724:	p->height = 4;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1082130432
ASGNF4
line 1726
;1725:
;1726:	p->endheight = 4+rand()%3;
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 3
MODI4
CNSTI4 4
ADDI4
CVIF4 4
ASGNF4
line 1727
;1727:	p->endwidth = p->endheight;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ASGNF4
line 1729
;1728:
;1729:	p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 1731
;1730:
;1731:	VectorCopy( start, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 1732
;1732:	p->vel[0] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 0
ASGNF4
line 1733
;1733:	p->vel[1] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 0
ASGNF4
line 1734
;1734:	p->vel[2] = -20;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3248488448
ASGNF4
line 1735
;1735:	VectorClear( p->accel );
ADDRLP4 16
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
line 1737
;1736:
;1737:	p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 1739
;1738:
;1739:	p->roll = rand()%179;
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 20
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 1741
;1740:	
;1741:	p->color = BLOODRED;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 1742
;1742:	p->alpha = 0.75;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1061158912
ASGNF4
line 1744
;1743:
;1744:}
LABELV $1506
endproc CG_Particle_Bleed 24 4
export CG_Particle_OilParticle
proc CG_Particle_OilParticle 36 4
line 1747
;1745:
;1746:void CG_Particle_OilParticle (qhandle_t pshader, centity_t *cent)
;1747:{
line 1754
;1748:	cparticle_t	*p;
;1749:
;1750:	int			time;
;1751:	int			time2;
;1752:	float		ratio;
;1753:
;1754:	float	duration = 1500;
ADDRLP4 16
CNSTF4 1153138688
ASGNF4
line 1756
;1755:
;1756:	time = cg.time;
ADDRLP4 8
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1757
;1757:	time2 = cg.time + cent->currentState.time;
ADDRLP4 12
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ADDI4
ASGNI4
line 1759
;1758:
;1759:	ratio =(float)1 - ((float)time / (float)time2);
ADDRLP4 4
CNSTF4 1065353216
ADDRLP4 8
INDIRI4
CVIF4 4
ADDRLP4 12
INDIRI4
CVIF4 4
DIVF4
SUBF4
ASGNF4
line 1761
;1760:
;1761:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1521
line 1762
;1762:		CG_Printf ("CG_Particle_OilParticle == ZERO!\n");
ADDRGP4 $1523
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1521
line 1764
;1763:
;1764:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1524
line 1765
;1765:		return;
ADDRGP4 $1518
JUMPV
LABELV $1524
line 1766
;1766:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1767
;1767:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1768
;1768:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1769
;1769:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1770
;1770:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1771
;1771:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 1772
;1772:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1773
;1773:	p->roll = 0;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 1775
;1774:
;1775:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1777
;1776:
;1777:	p->endtime = cg.time + duration;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRLP4 16
INDIRF4
ADDF4
ASGNF4
line 1779
;1778:	
;1779:	p->startfade = p->endtime;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1781
;1780:
;1781:	p->width = 1;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1065353216
ASGNF4
line 1782
;1782:	p->height = 3;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1077936128
ASGNF4
line 1784
;1783:
;1784:	p->endheight = 3;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1077936128
ASGNF4
line 1785
;1785:	p->endwidth = 1;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1065353216
ASGNF4
line 1787
;1786:
;1787:	p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 1789
;1788:
;1789:	VectorCopy(cent->currentState.origin, p->org );	
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1791
;1790:	
;1791:	p->vel[0] = (cent->currentState.origin2[0] * (16 * ratio));
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
CNSTF4 1098907648
ADDRLP4 4
INDIRF4
MULF4
MULF4
ASGNF4
line 1792
;1792:	p->vel[1] = (cent->currentState.origin2[1] * (16 * ratio));
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRF4
CNSTF4 1098907648
ADDRLP4 4
INDIRF4
MULF4
MULF4
ASGNF4
line 1793
;1793:	p->vel[2] = (cent->currentState.origin2[2]);
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 112
ADDP4
INDIRF4
ASGNF4
line 1795
;1794:
;1795:	p->snum = 1.0f;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
CNSTI4 1
ASGNI4
line 1797
;1796:
;1797:	VectorClear( p->accel );
ADDRLP4 28
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
line 1799
;1798:
;1799:	p->accel[2] = -20;
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTF4 3248488448
ASGNF4
line 1801
;1800:
;1801:	p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 1803
;1802:
;1803:	p->roll = rand()%179;
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 32
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 1805
;1804:	
;1805:	p->alpha = 0.75;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1061158912
ASGNF4
line 1807
;1806:
;1807:}
LABELV $1518
endproc CG_Particle_OilParticle 36 4
export CG_Particle_OilSlick
proc CG_Particle_OilSlick 36 4
line 1811
;1808:
;1809:
;1810:void CG_Particle_OilSlick (qhandle_t pshader, centity_t *cent)
;1811:{
line 1814
;1812:	cparticle_t	*p;
;1813:	
;1814:  	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1529
line 1815
;1815:		CG_Printf ("CG_Particle_OilSlick == ZERO!\n");
ADDRGP4 $1531
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1529
line 1817
;1816:
;1817:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1532
line 1818
;1818:		return;
ADDRGP4 $1528
JUMPV
LABELV $1532
line 1819
;1819:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1820
;1820:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1821
;1821:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1822
;1822:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1823
;1823:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1825
;1824:	
;1825:	if (cent->currentState.angles2[2])
ADDRFP4 4
INDIRP4
CNSTI4 136
ADDP4
INDIRF4
CNSTF4 0
EQF4 $1535
line 1826
;1826:		p->endtime = cg.time + cent->currentState.angles2[2];
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRFP4 4
INDIRP4
CNSTI4 136
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRGP4 $1536
JUMPV
LABELV $1535
line 1828
;1827:	else
;1828:		p->endtime = cg.time + 60000;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 60000
ADDI4
CVIF4 4
ASGNF4
LABELV $1536
line 1830
;1829:
;1830:	p->startfade = p->endtime;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1832
;1831:
;1832:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 1833
;1833:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1834
;1834:	p->roll = 0;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 1836
;1835:
;1836:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 1838
;1837:
;1838:	if (cent->currentState.angles2[0] || cent->currentState.angles2[1])
ADDRLP4 8
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
CNSTF4 0
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
ADDRLP4 12
INDIRF4
NEF4 $1541
ADDRLP4 8
INDIRP4
CNSTI4 132
ADDP4
INDIRF4
ADDRLP4 12
INDIRF4
EQF4 $1539
LABELV $1541
line 1839
;1839:	{
line 1840
;1840:		p->width = cent->currentState.angles2[0];
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
ASGNF4
line 1841
;1841:		p->height = cent->currentState.angles2[0];
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
ASGNF4
line 1843
;1842:
;1843:		p->endheight = cent->currentState.angles2[1];
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 132
ADDP4
INDIRF4
ASGNF4
line 1844
;1844:		p->endwidth = cent->currentState.angles2[1];
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 132
ADDP4
INDIRF4
ASGNF4
line 1845
;1845:	}
ADDRGP4 $1540
JUMPV
LABELV $1539
line 1847
;1846:	else
;1847:	{
line 1848
;1848:		p->width = 8;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1090519040
ASGNF4
line 1849
;1849:		p->height = 8;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1090519040
ASGNF4
line 1851
;1850:
;1851:		p->endheight = 16;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1098907648
ASGNF4
line 1852
;1852:		p->endwidth = 16;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1098907648
ASGNF4
line 1853
;1853:	}
LABELV $1540
line 1855
;1854:
;1855:	p->type = P_FLAT_SCALEUP;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 9
ASGNI4
line 1857
;1856:
;1857:	p->snum = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
CNSTI4 1
ASGNI4
line 1859
;1858:
;1859:	VectorCopy(cent->currentState.origin, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 1861
;1860:	
;1861:	p->org[2]+= 0.55 + (crandom() * 0.5);
ADDRLP4 16
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRF4
CNSTF4 1056964608
CNSTF4 1073741824
ADDRLP4 16
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1057803469
ADDF4
ADDF4
ASGNF4
line 1863
;1862:
;1863:	p->vel[0] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 0
ASGNF4
line 1864
;1864:	p->vel[1] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 0
ASGNF4
line 1865
;1865:	p->vel[2] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 0
ASGNF4
line 1866
;1866:	VectorClear( p->accel );
ADDRLP4 28
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 28
INDIRF4
ASGNF4
line 1868
;1867:
;1868:	p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 1870
;1869:
;1870:	p->roll = rand()%179;
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 32
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 1872
;1871:	
;1872:	p->alpha = 0.75;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1061158912
ASGNF4
line 1874
;1873:
;1874:}
LABELV $1528
endproc CG_Particle_OilSlick 36 4
export CG_OilSlickRemove
proc CG_OilSlickRemove 16 4
line 1877
;1875:
;1876:void CG_OilSlickRemove (centity_t *cent)
;1877:{
line 1881
;1878:	cparticle_t		*p, *next;
;1879:	int				id;
;1880:
;1881:	id = 1.0f;
ADDRLP4 8
CNSTI4 1
ASGNI4
line 1883
;1882:
;1883:	if (!id)
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $1543
line 1884
;1884:		CG_Printf ("CG_OilSlickRevove NULL id\n");
ADDRGP4 $1545
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1543
line 1886
;1885:
;1886:	for (p=active_particles ; p ; p=next)
ADDRLP4 0
ADDRGP4 active_particles
INDIRP4
ASGNP4
ADDRGP4 $1549
JUMPV
LABELV $1546
line 1887
;1887:	{
line 1888
;1888:		next = p->next;
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1890
;1889:		
;1890:		if (p->type == P_FLAT_SCALEUP)
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 9
NEI4 $1550
line 1891
;1891:		{
line 1892
;1892:			if (p->snum == id)
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $1552
line 1893
;1893:			{
line 1894
;1894:				p->endtime = cg.time + 100;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
ASGNF4
line 1895
;1895:				p->startfade = p->endtime;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1896
;1896:				p->type = P_FLAT_SCALEUP_FADE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 10
ASGNI4
line 1898
;1897:
;1898:			}
LABELV $1552
line 1899
;1899:		}
LABELV $1550
line 1901
;1900:
;1901:	}
LABELV $1547
line 1886
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
LABELV $1549
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1546
line 1902
;1902:}
LABELV $1542
endproc CG_OilSlickRemove 16 4
export ValidBloodPool
proc ValidBloodPool 196 28
line 1905
;1903:
;1904:qboolean ValidBloodPool (vec3_t start)
;1905:{
line 1916
;1906:#define EXTRUDE_DIST	0.5
;1907:
;1908:	vec3_t	angles;
;1909:	vec3_t	right, up;
;1910:	vec3_t	this_pos, x_pos, center_pos, end_pos;
;1911:	float	x, y;
;1912:	float	fwidth, fheight;
;1913:	trace_t	trace;
;1914:	vec3_t	normal;
;1915:
;1916:	fwidth = 16;
ADDRLP4 152
CNSTF4 1098907648
ASGNF4
line 1917
;1917:	fheight = 16;
ADDRLP4 120
CNSTF4 1098907648
ASGNF4
line 1919
;1918:
;1919:	VectorSet (normal, 0, 0, 1);
ADDRLP4 168
CNSTF4 0
ASGNF4
ADDRLP4 96
ADDRLP4 168
INDIRF4
ASGNF4
ADDRLP4 96+4
ADDRLP4 168
INDIRF4
ASGNF4
ADDRLP4 96+8
CNSTF4 1065353216
ASGNF4
line 1921
;1920:
;1921:	vectoangles (normal, angles);
ADDRLP4 96
ARGP4
ADDRLP4 156
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1922
;1922:	AngleVectors (angles, NULL, right, up);
ADDRLP4 156
ARGP4
CNSTP4 0
ARGP4
ADDRLP4 140
ARGP4
ADDRLP4 108
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 1924
;1923:
;1924:	VectorMA (start, EXTRUDE_DIST, normal, center_pos);
ADDRLP4 172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
CNSTF4 1056964608
ASGNF4
ADDRLP4 128
ADDRLP4 172
INDIRP4
INDIRF4
ADDRLP4 176
INDIRF4
ADDRLP4 96
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 128+4
ADDRLP4 172
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 176
INDIRF4
ADDRLP4 96+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 128+8
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
CNSTF4 1056964608
ADDRLP4 96+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1926
;1925:
;1926:	for (x= -fwidth/2; x<fwidth; x+= fwidth)
ADDRLP4 124
ADDRLP4 152
INDIRF4
NEGF4
CNSTF4 1073741824
DIVF4
ASGNF4
ADDRGP4 $1565
JUMPV
LABELV $1562
line 1927
;1927:	{
line 1928
;1928:		VectorMA (center_pos, x, right, x_pos);
ADDRLP4 84
ADDRLP4 128
INDIRF4
ADDRLP4 140
INDIRF4
ADDRLP4 124
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 84+4
ADDRLP4 128+4
INDIRF4
ADDRLP4 140+4
INDIRF4
ADDRLP4 124
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 84+8
ADDRLP4 128+8
INDIRF4
ADDRLP4 140+8
INDIRF4
ADDRLP4 124
INDIRF4
MULF4
ADDF4
ASGNF4
line 1930
;1929:
;1930:		for (y= -fheight/2; y<fheight; y+= fheight)
ADDRLP4 12
ADDRLP4 120
INDIRF4
NEGF4
CNSTF4 1073741824
DIVF4
ASGNF4
ADDRGP4 $1575
JUMPV
LABELV $1572
line 1931
;1931:		{
line 1932
;1932:			VectorMA (x_pos, y, up, this_pos);
ADDRLP4 0
ADDRLP4 84
INDIRF4
ADDRLP4 108
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 84+4
INDIRF4
ADDRLP4 108+4
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 108+8
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
line 1933
;1933:			VectorMA (this_pos, -EXTRUDE_DIST*2, normal, end_pos);
ADDRLP4 188
CNSTF4 3212836864
ASGNF4
ADDRLP4 16
ADDRLP4 0
INDIRF4
ADDRLP4 188
INDIRF4
ADDRLP4 96
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 188
INDIRF4
ADDRLP4 96+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 16+8
ADDRLP4 0+8
INDIRF4
CNSTF4 3212836864
ADDRLP4 96+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1935
;1934:			
;1935:			CG_Trace (&trace, this_pos, NULL, NULL, end_pos, -1, CONTENTS_SOLID);
ADDRLP4 28
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 192
CNSTP4 0
ASGNP4
ADDRLP4 192
INDIRP4
ARGP4
ADDRLP4 192
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
CNSTI4 -1
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 CG_Trace
CALLV
pop
line 1938
;1936:
;1937:			
;1938:			if (trace.entityNum < (MAX_ENTITIES - 1)) // may only land on world
ADDRLP4 28+52
INDIRI4
CNSTI4 1022
GEI4 $1588
line 1939
;1939:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1555
JUMPV
LABELV $1588
line 1941
;1940:
;1941:			if (!(!trace.startsolid && trace.fraction < 1))
ADDRLP4 28+4
INDIRI4
CNSTI4 0
NEI4 $1595
ADDRLP4 28+8
INDIRF4
CNSTF4 1065353216
LTF4 $1591
LABELV $1595
line 1942
;1942:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1555
JUMPV
LABELV $1591
line 1944
;1943:		
;1944:		}
LABELV $1573
line 1930
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRLP4 120
INDIRF4
ADDF4
ASGNF4
LABELV $1575
ADDRLP4 12
INDIRF4
ADDRLP4 120
INDIRF4
LTF4 $1572
line 1945
;1945:	}
LABELV $1563
line 1926
ADDRLP4 124
ADDRLP4 124
INDIRF4
ADDRLP4 152
INDIRF4
ADDF4
ASGNF4
LABELV $1565
ADDRLP4 124
INDIRF4
ADDRLP4 152
INDIRF4
LTF4 $1562
line 1947
;1946:
;1947:	return qtrue;
CNSTI4 1
RETI4
LABELV $1555
endproc ValidBloodPool 196 28
export CG_BloodPool
proc CG_BloodPool 48 4
line 1951
;1948:}
;1949:
;1950:void CG_BloodPool (localEntity_t *le, qhandle_t pshader, trace_t *tr)
;1951:{	
line 1957
;1952:	cparticle_t	*p;
;1953:	qboolean	legit;
;1954:	vec3_t		start;
;1955:	float		rndSize;
;1956:	
;1957:	if (!pshader)
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1597
line 1958
;1958:		CG_Printf ("CG_BloodPool pshader == ZERO!\n");
ADDRGP4 $1599
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1597
line 1960
;1959:
;1960:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1600
line 1961
;1961:		return;
ADDRGP4 $1596
JUMPV
LABELV $1600
line 1963
;1962:	
;1963:	VectorCopy (tr->endpos, start);
ADDRLP4 8
ADDRFP4 8
INDIRP4
CNSTI4 12
ADDP4
INDIRB
ASGNB 12
line 1964
;1964:	legit = ValidBloodPool (start);
ADDRLP4 8
ARGP4
ADDRLP4 24
ADDRGP4 ValidBloodPool
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 1966
;1965:
;1966:	if (!legit) 
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $1602
line 1967
;1967:		return;
ADDRGP4 $1596
JUMPV
LABELV $1602
line 1969
;1968:
;1969:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 1970
;1970:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 1971
;1971:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 1972
;1972:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 1973
;1973:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 1975
;1974:	
;1975:	p->endtime = cg.time + 3000;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 3000
ADDI4
CVIF4 4
ASGNF4
line 1976
;1976:	p->startfade = p->endtime;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 1978
;1977:
;1978:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 1979
;1979:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1980
;1980:	p->roll = 0;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 1982
;1981:
;1982:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 1984
;1983:
;1984:	rndSize = 0.4 + random()*0.6;
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
CNSTF4 1058642330
ADDRLP4 32
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
CNSTF4 1053609165
ADDF4
ASGNF4
line 1986
;1985:
;1986:	p->width = 8*rndSize;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1090519040
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 1987
;1987:	p->height = 8*rndSize;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1090519040
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 1989
;1988:
;1989:	p->endheight = 16*rndSize;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1098907648
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 1990
;1990:	p->endwidth = 16*rndSize;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1098907648
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 1992
;1991:	
;1992:	p->type = P_FLAT_SCALEUP;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 9
ASGNI4
line 1994
;1993:
;1994:	VectorCopy(start, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 8
INDIRB
ASGNB 12
line 1996
;1995:	
;1996:	p->vel[0] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 0
ASGNF4
line 1997
;1997:	p->vel[1] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 0
ASGNF4
line 1998
;1998:	p->vel[2] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 0
ASGNF4
line 1999
;1999:	VectorClear( p->accel );
ADDRLP4 40
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 40
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 40
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 40
INDIRF4
ASGNF4
line 2001
;2000:
;2001:	p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 2003
;2002:
;2003:	p->roll = rand()%179;
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 44
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 2005
;2004:	
;2005:	p->alpha = 0.75;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1061158912
ASGNF4
line 2007
;2006:	
;2007:	p->color = BLOODRED;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 2008
;2008:}
LABELV $1596
endproc CG_BloodPool 48 4
export CG_ParticleBloodCloud
proc CG_ParticleBloodCloud 84 16
line 2014
;2009:
;2010:#define NORMALSIZE	16
;2011:#define LARGESIZE	32
;2012:
;2013:void CG_ParticleBloodCloud (centity_t *cent, vec3_t origin, vec3_t dir)
;2014:{
line 2023
;2015:	float	length;
;2016:	float	dist;
;2017:	float	crittersize;
;2018:	vec3_t	angles, forward;
;2019:	vec3_t	point;
;2020:	cparticle_t	*p;
;2021:	int		i;
;2022:	
;2023:	dist = 0;
ADDRLP4 36
CNSTF4 0
ASGNF4
line 2025
;2024:
;2025:	length = VectorLength (dir);
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 56
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 40
ADDRLP4 56
INDIRF4
ASGNF4
line 2026
;2026:	vectoangles (dir, angles);
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 44
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2027
;2027:	AngleVectors (angles, forward, NULL, NULL);
ADDRLP4 44
ARGP4
ADDRLP4 20
ARGP4
ADDRLP4 60
CNSTP4 0
ASGNP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 2029
;2028:
;2029:	crittersize = LARGESIZE;
ADDRLP4 16
CNSTF4 1107296256
ASGNF4
line 2031
;2030:
;2031:	if (length)
ADDRLP4 40
INDIRF4
CNSTF4 0
EQF4 $1607
line 2032
;2032:		dist = length / crittersize;
ADDRLP4 36
ADDRLP4 40
INDIRF4
ADDRLP4 16
INDIRF4
DIVF4
ASGNF4
LABELV $1607
line 2034
;2033:
;2034:	if (dist < 1)
ADDRLP4 36
INDIRF4
CNSTF4 1065353216
GEF4 $1609
line 2035
;2035:		dist = 1;
ADDRLP4 36
CNSTF4 1065353216
ASGNF4
LABELV $1609
line 2037
;2036:
;2037:	VectorCopy (origin, point);
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2039
;2038:
;2039:	for (i=0; i<dist; i++)
ADDRLP4 32
CNSTI4 0
ASGNI4
ADDRGP4 $1614
JUMPV
LABELV $1611
line 2040
;2040:	{
line 2041
;2041:		VectorMA (point, crittersize, forward, point);	
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 20
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 20+4
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
ADDRLP4 20+8
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 2043
;2042:		
;2043:		if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1621
line 2044
;2044:			return;
ADDRGP4 $1606
JUMPV
LABELV $1621
line 2046
;2045:
;2046:		p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 2047
;2047:		free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 2048
;2048:		p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 2049
;2049:		active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 2051
;2050:
;2051:		p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2052
;2052:		p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 2053
;2053:		p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 2054
;2054:		p->roll = 0;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 2056
;2055:
;2056:		p->pshader = cgs.media.smokePuffShader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRGP4 cgs+152340+276
INDIRI4
ASGNI4
line 2058
;2057:
;2058:		p->endtime = cg.time + 350 + (crandom() * 100);
ADDRLP4 68
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 350
ADDI4
CVIF4 4
CNSTF4 1120403456
CNSTF4 1073741824
ADDRLP4 68
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 2060
;2059:		
;2060:		p->startfade = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2062
;2061:		
;2062:		p->width = LARGESIZE;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1107296256
ASGNF4
line 2063
;2063:		p->height = LARGESIZE;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1107296256
ASGNF4
line 2064
;2064:		p->endheight = LARGESIZE;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1107296256
ASGNF4
line 2065
;2065:		p->endwidth = LARGESIZE;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1107296256
ASGNF4
line 2067
;2066:
;2067:		p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 2069
;2068:
;2069:		VectorCopy( origin, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2071
;2070:		
;2071:		p->vel[0] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 0
ASGNF4
line 2072
;2072:		p->vel[1] = 0;
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 0
ASGNF4
line 2073
;2073:		p->vel[2] = -1;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3212836864
ASGNF4
line 2075
;2074:		
;2075:		VectorClear( p->accel );
ADDRLP4 76
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 76
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 76
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 76
INDIRF4
ASGNF4
line 2077
;2076:
;2077:		p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 2079
;2078:
;2079:		p->roll = rand()%179;
ADDRLP4 80
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 80
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 2081
;2080:		
;2081:		p->color = BLOODRED;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 2083
;2082:		
;2083:		p->alpha = 0.75;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1061158912
ASGNF4
line 2085
;2084:		
;2085:	}
LABELV $1612
line 2039
ADDRLP4 32
ADDRLP4 32
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1614
ADDRLP4 32
INDIRI4
CVIF4 4
ADDRLP4 36
INDIRF4
LTF4 $1611
line 2088
;2086:
;2087:	
;2088:}
LABELV $1606
endproc CG_ParticleBloodCloud 84 16
export CG_ParticleSparks
proc CG_ParticleSparks 60 0
line 2091
;2089:
;2090:void CG_ParticleSparks (vec3_t org, vec3_t vel, int duration, float x, float y, float speed)
;2091:{
line 2094
;2092:	cparticle_t	*p;
;2093:
;2094:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1629
line 2095
;2095:		return;
ADDRGP4 $1628
JUMPV
LABELV $1629
line 2096
;2096:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 2097
;2097:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 2098
;2098:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 2099
;2099:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 2100
;2100:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2102
;2101:	
;2102:	p->endtime = cg.time + duration;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
CVIF4 4
ASGNF4
line 2103
;2103:	p->startfade = cg.time + duration/2;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 8
INDIRI4
CNSTI4 2
DIVI4
ADDI4
CVIF4 4
ASGNF4
line 2105
;2104:	
;2105:	p->color = EMISIVEFADE;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 3
ASGNI4
line 2106
;2106:	p->alpha = 0.4f;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1053609165
ASGNF4
line 2107
;2107:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 2109
;2108:
;2109:	p->height = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1056964608
ASGNF4
line 2110
;2110:	p->width = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1056964608
ASGNF4
line 2111
;2111:	p->endheight = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1056964608
ASGNF4
line 2112
;2112:	p->endwidth = 0.5;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1056964608
ASGNF4
line 2114
;2113:
;2114:	p->pshader = cgs.media.tracerShader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRGP4 cgs+152340+220
INDIRI4
ASGNI4
line 2116
;2115:
;2116:	p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 2118
;2117:	
;2118:	VectorCopy(org, p->org);
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 2120
;2119:
;2120:	p->org[0] += (crandom() * x);
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 4
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
line 2121
;2121:	p->org[1] += (crandom() * y);
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 2123
;2122:
;2123:	p->vel[0] = vel[0];
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 4
INDIRP4
INDIRF4
ASGNF4
line 2124
;2124:	p->vel[1] = vel[1];
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ASGNF4
line 2125
;2125:	p->vel[2] = vel[2];
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
line 2127
;2126:
;2127:	p->accel[0] = p->accel[1] = p->accel[2] = 0;
ADDRLP4 24
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 24
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 24
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 24
INDIRF4
ASGNF4
line 2129
;2128:
;2129:	p->vel[0] += (crandom() * 4);
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRF4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 28
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 2130
;2130:	p->vel[1] += (crandom() * 4);
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRF4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 36
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 2131
;2131:	p->vel[2] += (20 + (crandom() * 10)) * speed;	
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 48
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRF4
CNSTF4 1092616192
CNSTF4 1073741824
ADDRLP4 44
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1101004800
ADDF4
ADDRFP4 20
INDIRF4
MULF4
ADDF4
ASGNF4
line 2133
;2132:
;2133:	p->accel[0] = crandom () * 4;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 52
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 2134
;2134:	p->accel[1] = crandom () * 4;
ADDRLP4 56
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 1082130432
CNSTF4 1073741824
ADDRLP4 56
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 2136
;2135:	
;2136:}
LABELV $1628
endproc CG_ParticleSparks 60 0
export CG_ParticleDust
proc CG_ParticleDust 120 16
line 2139
;2137:
;2138:void CG_ParticleDust (centity_t *cent, vec3_t origin, vec3_t dir)
;2139:{
line 2148
;2140:	float	length;
;2141:	float	dist;
;2142:	float	crittersize;
;2143:	vec3_t	angles, forward;
;2144:	vec3_t	point;
;2145:	cparticle_t	*p;
;2146:	int		i;
;2147:	
;2148:	dist = 0;
ADDRLP4 40
CNSTF4 0
ASGNF4
line 2150
;2149:
;2150:	VectorNegate (dir, dir);
ADDRLP4 56
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRF4
NEGF4
ASGNF4
ADDRLP4 60
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
NEGF4
ASGNF4
ADDRLP4 64
ADDRFP4 8
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 64
INDIRP4
ADDRLP4 64
INDIRP4
INDIRF4
NEGF4
ASGNF4
line 2151
;2151:	length = VectorLength (dir);
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 68
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 32
ADDRLP4 68
INDIRF4
ASGNF4
line 2152
;2152:	vectoangles (dir, angles);
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 44
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2153
;2153:	AngleVectors (angles, forward, NULL, NULL);
ADDRLP4 44
ARGP4
ADDRLP4 20
ARGP4
ADDRLP4 72
CNSTP4 0
ASGNP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 2155
;2154:
;2155:	crittersize = LARGESIZE;
ADDRLP4 16
CNSTF4 1107296256
ASGNF4
line 2157
;2156:
;2157:	if (length)
ADDRLP4 32
INDIRF4
CNSTF4 0
EQF4 $1637
line 2158
;2158:		dist = length / crittersize;
ADDRLP4 40
ADDRLP4 32
INDIRF4
ADDRLP4 16
INDIRF4
DIVF4
ASGNF4
LABELV $1637
line 2160
;2159:
;2160:	if (dist < 1)
ADDRLP4 40
INDIRF4
CNSTF4 1065353216
GEF4 $1639
line 2161
;2161:		dist = 1;
ADDRLP4 40
CNSTF4 1065353216
ASGNF4
LABELV $1639
line 2163
;2162:
;2163:	VectorCopy (origin, point);
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2165
;2164:
;2165:	for (i=0; i<dist; i++)
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRGP4 $1644
JUMPV
LABELV $1641
line 2166
;2166:	{
line 2167
;2167:		VectorMA (point, crittersize, forward, point);	
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 20
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 20+4
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
ADDRLP4 20+8
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDF4
ASGNF4
line 2169
;2168:				
;2169:		if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1651
line 2170
;2170:			return;
ADDRGP4 $1636
JUMPV
LABELV $1651
line 2172
;2171:
;2172:		p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 2173
;2173:		free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 2174
;2174:		p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 2175
;2175:		active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 2177
;2176:
;2177:		p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2178
;2178:		p->alpha = 5.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1084227584
ASGNF4
line 2179
;2179:		p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 2180
;2180:		p->roll = 0;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
CNSTI4 0
ASGNI4
line 2182
;2181:
;2182:		p->pshader = cgs.media.smokePuffShader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRGP4 cgs+152340+276
INDIRI4
ASGNI4
line 2185
;2183:
;2184:		// RF, stay around for long enough to expand and dissipate naturally
;2185:		if (length)
ADDRLP4 32
INDIRF4
CNSTF4 0
EQF4 $1656
line 2186
;2186:			p->endtime = cg.time + 4500 + (crandom() * 3500);
ADDRLP4 80
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 4500
ADDI4
CVIF4 4
CNSTF4 1163575296
CNSTF4 1073741824
ADDRLP4 80
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRGP4 $1657
JUMPV
LABELV $1656
line 2188
;2187:		else
;2188:			p->endtime = cg.time + 750 + (crandom() * 500);
ADDRLP4 84
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 750
ADDI4
CVIF4 4
CNSTF4 1140457472
CNSTF4 1073741824
ADDRLP4 84
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
LABELV $1657
line 2190
;2189:		
;2190:		p->startfade = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2192
;2191:		
;2192:		p->width = LARGESIZE;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1107296256
ASGNF4
line 2193
;2193:		p->height = LARGESIZE;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 1107296256
ASGNF4
line 2196
;2194:
;2195:		// RF, expand while falling
;2196:		p->endheight = LARGESIZE*3.0;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1119879168
ASGNF4
line 2197
;2197:		p->endwidth = LARGESIZE*3.0;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1119879168
ASGNF4
line 2199
;2198:
;2199:		if (!length)
ADDRLP4 32
INDIRF4
CNSTF4 0
NEF4 $1661
line 2200
;2200:		{
line 2201
;2201:			p->width *= 0.2f;
ADDRLP4 88
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
CNSTF4 1045220557
ADDRLP4 88
INDIRP4
INDIRF4
MULF4
ASGNF4
line 2202
;2202:			p->height *= 0.2f;
ADDRLP4 92
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
CNSTF4 1045220557
ADDRLP4 92
INDIRP4
INDIRF4
MULF4
ASGNF4
line 2204
;2203:
;2204:			p->endheight = NORMALSIZE;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 1098907648
ASGNF4
line 2205
;2205:			p->endwidth = NORMALSIZE;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
CNSTF4 1098907648
ASGNF4
line 2206
;2206:		}
LABELV $1661
line 2208
;2207:
;2208:		p->type = P_SMOKE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 3
ASGNI4
line 2210
;2209:
;2210:		VectorCopy( point, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 2212
;2211:		
;2212:		p->vel[0] = crandom()*6;
ADDRLP4 88
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 1086324736
CNSTF4 1073741824
ADDRLP4 88
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 2213
;2213:		p->vel[1] = crandom()*6;
ADDRLP4 92
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1086324736
CNSTF4 1073741824
ADDRLP4 92
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 2214
;2214:		p->vel[2] = random()*20;
ADDRLP4 96
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1101004800
ADDRLP4 96
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ASGNF4
line 2217
;2215:
;2216:		// RF, add some gravity/randomness
;2217:		p->accel[0] = crandom()*3;
ADDRLP4 100
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1077936128
CNSTF4 1073741824
ADDRLP4 100
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 2218
;2218:		p->accel[1] = crandom()*3;
ADDRLP4 104
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 1077936128
CNSTF4 1073741824
ADDRLP4 104
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ASGNF4
line 2219
;2219:		p->accel[2] = -PARTICLE_GRAVITY*0.4;
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTF4 3246391296
ASGNF4
line 2221
;2220:
;2221:		VectorClear( p->accel );
ADDRLP4 112
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 112
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 112
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 112
INDIRF4
ASGNF4
line 2223
;2222:
;2223:		p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 2225
;2224:
;2225:		p->roll = rand()%179;
ADDRLP4 116
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 116
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 2227
;2226:		
;2227:		p->alpha = 0.75;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1061158912
ASGNF4
line 2229
;2228:		
;2229:	}
LABELV $1642
line 2165
ADDRLP4 36
ADDRLP4 36
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1644
ADDRLP4 36
INDIRI4
CVIF4 4
ADDRLP4 40
INDIRF4
LTF4 $1641
line 2232
;2230:
;2231:	
;2232:}
LABELV $1636
endproc CG_ParticleDust 120 16
export CG_ParticleMisc
proc CG_ParticleMisc 8 4
line 2235
;2233:
;2234:void CG_ParticleMisc (qhandle_t pshader, vec3_t origin, int size, int duration, float alpha)
;2235:{
line 2238
;2236:	cparticle_t	*p;
;2237:
;2238:	if (!pshader)
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $1664
line 2239
;2239:		CG_Printf ("CG_ParticleImpactSmokePuff pshader == ZERO!\n");
ADDRGP4 $1499
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $1664
line 2241
;2240:
;2241:	if (!free_particles)
ADDRGP4 free_particles
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1666
line 2242
;2242:		return;
ADDRGP4 $1663
JUMPV
LABELV $1666
line 2244
;2243:
;2244:	p = free_particles;
ADDRLP4 0
ADDRGP4 free_particles
INDIRP4
ASGNP4
line 2245
;2245:	free_particles = p->next;
ADDRGP4 free_particles
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 2246
;2246:	p->next = active_particles;
ADDRLP4 0
INDIRP4
ADDRGP4 active_particles
INDIRP4
ASGNP4
line 2247
;2247:	active_particles = p;
ADDRGP4 active_particles
ADDRLP4 0
INDIRP4
ASGNP4
line 2248
;2248:	p->time = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2249
;2249:	p->alpha = 1.0;
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1065353216
ASGNF4
line 2250
;2250:	p->alphavel = 0;
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 2251
;2251:	p->roll = rand()%179;
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 179
MODI4
ASGNI4
line 2253
;2252:
;2253:	p->pshader = pshader;
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 2255
;2254:
;2255:	if (duration > 0)
ADDRFP4 12
INDIRI4
CNSTI4 0
LEI4 $1669
line 2256
;2256:		p->endtime = cg.time + duration;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 12
INDIRI4
ADDI4
CVIF4 4
ASGNF4
ADDRGP4 $1670
JUMPV
LABELV $1669
line 2258
;2257:	else
;2258:		p->endtime = duration;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRFP4 12
INDIRI4
CVIF4 4
ASGNF4
LABELV $1670
line 2260
;2259:
;2260:	p->startfade = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ASGNF4
line 2262
;2261:
;2262:	p->width = size;
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
ADDRFP4 8
INDIRI4
CVIF4 4
ASGNF4
line 2263
;2263:	p->height = size;
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDRFP4 8
INDIRI4
CVIF4 4
ASGNF4
line 2265
;2264:
;2265:	p->endheight = size;
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
ADDRFP4 8
INDIRI4
CVIF4 4
ASGNF4
line 2266
;2266:	p->endwidth = size;
ADDRLP4 0
INDIRP4
CNSTI4 84
ADDP4
ADDRFP4 8
INDIRI4
CVIF4 4
ASGNF4
line 2268
;2267:
;2268:	p->type = P_SPRITE;
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 15
ASGNI4
line 2270
;2269:
;2270:	VectorCopy( origin, p->org );
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2272
;2271:
;2272:	p->rotate = qfalse;
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
CNSTI4 0
ASGNI4
line 2273
;2273:}
LABELV $1663
endproc CG_ParticleMisc 8 4
bss
export oldtime
align 4
LABELV oldtime
skip 4
export rup
align 4
LABELV rup
skip 12
export rright
align 4
LABELV rright
skip 12
export rforward
align 4
LABELV rforward
skip 12
export pvup
align 4
LABELV pvup
skip 12
export pvright
align 4
LABELV pvright
skip 12
export pvforward
align 4
LABELV pvforward
skip 12
export particles
align 4
LABELV particles
skip 126976
export free_particles
align 4
LABELV free_particles
skip 4
export active_particles
align 4
LABELV active_particles
skip 4
align 4
LABELV numShaderAnims
skip 4
align 4
LABELV shaderAnims
skip 8192
align 4
LABELV markTotal
skip 4
export cg_freeMarkPolys
align 4
LABELV cg_freeMarkPolys
skip 4
export cg_activeMarkPolys
align 4
LABELV cg_activeMarkPolys
skip 288
import trap_GetEntityToken
import trap_getCameraInfo
import trap_startCamera
import trap_loadCamera
import trap_SnapVector
import trap_CIN_SetExtents
import trap_CIN_DrawCinematic
import trap_CIN_RunCinematic
import trap_CIN_StopCinematic
import trap_CIN_PlayCinematic
import trap_Key_GetKey
import trap_Key_SetCatcher
import trap_Key_GetCatcher
import trap_Key_IsDown
import trap_R_RegisterFont
import trap_MemoryRemaining
import testPrintFloat
import testPrintInt
import trap_SetUserCmdValue
import trap_GetUserCmd
import trap_GetCurrentCmdNumber
import trap_GetServerCommand
import trap_GetSnapshot
import trap_GetCurrentSnapshotNumber
import trap_GetGameState
import trap_GetGlconfig
import trap_R_RemapShader
import trap_R_LerpTag
import trap_R_ModelBounds
import trap_R_DrawStretchPic
import trap_R_SetColor
import trap_R_RenderScene
import trap_R_LightForPoint
import trap_R_AddLightToScene
import trap_R_AddPolysToScene
import trap_R_AddPolyToScene
import trap_R_AddRefEntityToScene
import trap_R_ClearScene
import trap_R_RegisterShaderNoMip
import trap_R_RegisterShader
import trap_R_RegisterSkin
import trap_R_RegisterModel
import trap_R_LoadWorldMap
import trap_S_StopBackgroundTrack
import trap_S_StartBackgroundTrack
import trap_S_RegisterSound
import trap_S_Respatialize
import trap_S_UpdateEntityPosition
import trap_S_AddRealLoopingSound
import trap_S_AddLoopingSound
import trap_S_ClearLoopingSounds
import trap_S_StartLocalSound
import trap_S_StopLoopingSound
import trap_S_StartSound
import trap_CM_MarkFragments
import trap_CM_TransformedBoxTrace
import trap_CM_BoxTrace
import trap_CM_TransformedPointContents
import trap_CM_PointContents
import trap_CM_TempBoxModel
import trap_CM_InlineModel
import trap_CM_NumInlineModels
import trap_CM_LoadMap
import trap_UpdateScreen
import trap_SendClientCommand
import trap_AddCommand
import trap_SendConsoleCommand
import trap_FS_Seek
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_Cvar_VariableStringBuffer
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_Milliseconds
import trap_Error
import trap_Print
import CG_CheckChangedPredictableEvents
import CG_TransitionPlayerState
import CG_Respawn
import CG_PlayBufferedVoiceChats
import CG_VoiceChatLocal
import CG_ShaderStateChanged
import CG_LoadVoiceChats
import CG_SetConfigValues
import CG_ParseServerinfo
import CG_ExecuteNewServerCommands
import CG_InitConsoleCommands
import CG_ConsoleCommand
import CG_DrawOldTourneyScoreboard
import CG_DrawOldScoreboard
import CG_DrawInformation
import CG_LoadingClient
import CG_LoadingItem
import CG_LoadingString
import CG_ProcessSnapshots
import CG_MakeExplosion
import CG_Bleed
import CG_BigExplode
import CG_GibPlayer
import CG_ScorePlum
import CG_SpawnEffect
import CG_BubbleTrail
import CG_SmokePuff
import CG_AddLocalEntities
import CG_AllocLocalEntity
import CG_InitLocalEntities
import CG_OutOfAmmoChange
import CG_DrawWeaponSelect
import CG_AddPlayerWeapon
import CG_AddViewWeapon
import CG_GrappleTrail
import CG_RailTrail
import CG_Bullet
import CG_ShotgunFire
import CG_MissileHitPlayer
import CG_MissileHitWall
import CG_FireWeapon
import CG_RegisterItemVisuals
import CG_RegisterWeapon
import CG_Weapon_f
import CG_PrevWeapon_f
import CG_NextWeapon_f
import CG_PositionRotatedEntityOnTag
import CG_PositionEntityOnTag
import CG_AdjustPositionForMover
import CG_Beam
import CG_AddPacketEntities
import CG_SetEntitySoundPosition
import CG_PainEvent
import CG_EntityEvent
import CG_PlaceString
import CG_CheckEvents
import CG_LoadDeferredPlayers
import CG_PredictPlayerState
import CG_Trace
import CG_PointContents
import CG_BuildSolidList
import CG_CustomSound
import CG_NewClientInfo
import CG_AddRefEntityWithPowerups
import CG_ResetPlayerEntity
import CG_Player
import CG_StatusHandle
import CG_OtherTeamHasFlag
import CG_YourTeamHasFlag
import CG_GameTypeString
import CG_CheckOrderPending
import CG_Text_PaintChar
import CG_Draw3DModel
import CG_GetKillerText
import CG_GetGameStatusText
import CG_GetTeamColor
import CG_InitTeamChat
import CG_SetPrintString
import CG_ShowResponseHead
import CG_RunMenuScript
import CG_OwnerDrawVisible
import CG_GetValue
import CG_SelectNextPlayer
import CG_SelectPrevPlayer
import CG_Text_Height
import CG_Text_Width
import CG_Text_Paint
import CG_OwnerDraw
import CG_DrawTeamBackground
import CG_DrawFlagModel
import CG_DrawActive
import CG_DrawHead
import CG_CenterPrint
import CG_AddLagometerSnapshotInfo
import CG_AddLagometerFrameInfo
import teamChat2
import teamChat1
import systemChat
import drawTeamOverlayModificationCount
import numSortedTeamPlayers
import sortedTeamPlayers
import CG_DrawTopBottom
import CG_DrawSides
import CG_DrawRect
import UI_DrawProportionalString
import CG_GetColorForHealth
import CG_ColorForHealth
import CG_TileClear
import CG_TeamColor
import CG_FadeColor
import CG_DrawStrlen
import CG_DrawSmallStringColor
import CG_DrawSmallString
import CG_DrawBigStringColor
import CG_DrawBigString
import CG_DrawStringExt
import CG_DrawString
import CG_DrawPic
import CG_FillRect
import CG_AdjustFrom640
import CG_DrawActiveFrame
import CG_AddBufferedSound
import CG_ZoomUp_f
import CG_ZoomDown_f
import CG_TestModelPrevSkin_f
import CG_TestModelNextSkin_f
import CG_TestModelPrevFrame_f
import CG_TestModelNextFrame_f
import CG_TestGun_f
import CG_TestModel_f
import CG_BuildSpectatorString
import CG_GetSelectedScore
import CG_SetScoreSelection
import CG_RankRunFrame
import CG_EventHandling
import CG_MouseEvent
import CG_KeyEvent
import CG_LoadMenus
import CG_LastAttacker
import CG_CrosshairPlayer
import CG_UpdateCvars
import CG_StartMusic
import CG_Error
import CG_Printf
import CG_Argv
import CG_ConfigString
import cg_trueLightning
import cg_oldPlasma
import cg_oldRocket
import cg_oldRail
import cg_noProjectileTrail
import cg_noTaunt
import cg_bigFont
import cg_smallFont
import cg_cameraMode
import cg_timescale
import cg_timescaleFadeSpeed
import cg_timescaleFadeEnd
import cg_cameraOrbitDelay
import cg_cameraOrbit
import pmove_msec
import pmove_fixed
import cg_smoothClients
import cg_scorePlum
import cg_noVoiceText
import cg_noVoiceChats
import cg_teamChatsOnly
import cg_drawFriend
import cg_deferPlayers
import cg_predictItems
import cg_blood
import cg_paused
import cg_buildScript
import cg_forceModel
import cg_stats
import cg_teamChatHeight
import cg_teamChatTime
import cg_synchronousClients
import cg_drawAttacker
import cg_lagometer
import cg_stereoSeparation
import cg_thirdPerson
import cg_thirdPersonAngle
import cg_thirdPersonRange
import cg_zoomFov
import cg_fov
import cg_simpleItems
import cg_ignore
import cg_autoswitch
import cg_tracerLength
import cg_tracerWidth
import cg_tracerChance
import cg_viewsize
import cg_drawGun
import cg_gun_z
import cg_gun_y
import cg_gun_x
import cg_gun_frame
import cg_brassTime
import cg_addMarks
import cg_footsteps
import cg_showmiss
import cg_noPlayerAnims
import cg_nopredict
import cg_errorDecay
import cg_railTrailTime
import cg_debugEvents
import cg_debugPosition
import cg_debugAnim
import cg_animSpeed
import cg_draw2D
import cg_drawStatus
import cg_crosshairHealth
import cg_crosshairSize
import cg_crosshairY
import cg_crosshairX
import cg_teamOverlayUserinfo
import cg_drawTeamOverlay
import cg_drawRewards
import cg_drawCrosshairNames
import cg_drawCrosshair
import cg_drawAmmoWarning
import cg_drawIcons
import cg_draw3dIcons
import cg_drawSnapshot
import cg_drawFPS
import cg_drawTimer
import cg_gibs
import cg_shadows
import cg_swingSpeed
import cg_bobroll
import cg_bobpitch
import cg_bobup
import cg_runroll
import cg_runpitch
import cg_centertime
export cg_markPolys
align 4
LABELV cg_markPolys
skip 73728
import cg_items
import cg_weapons
import cg_entities
import cg
import cgs
import BG_PlayerTouchesItem
import BG_PlayerStateToEntityStateExtraPolate
import BG_PlayerStateToEntityState
import BG_TouchJumpPad
import BG_AddPredictableEventToPlayerstate
import BG_EvaluateTrajectoryDelta
import BG_EvaluateTrajectory
import BG_CanItemBeGrabbed
import BG_FindItemForHoldable
import BG_FindItemForPowerup
import BG_FindItemForWeapon
import BG_FindItem
import bg_numItems
import bg_itemlist
import Pmove
import PM_UpdateViewAngles
import Com_Printf
import Com_Error
import Info_NextPair
import Info_Validate
import Info_SetValueForKey_Big
import Info_SetValueForKey
import Info_RemoveKey_big
import Info_RemoveKey
import Info_ValueForKey
import va
import Q_CleanStr
import Q_PrintStrlen
import Q_strcat
import Q_strncpyz
import Q_strrchr
import Q_strupr
import Q_strlwr
import Q_stricmpn
import Q_strncmp
import Q_stricmp
import Q_isalpha
import Q_isupper
import Q_islower
import Q_isprint
import Com_sprintf
import Parse3DMatrix
import Parse2DMatrix
import Parse1DMatrix
import SkipRestOfLine
import SkipBracedSection
import COM_MatchToken
import COM_ParseWarning
import COM_ParseError
import COM_Compress
import COM_ParseExt
import COM_Parse
import COM_GetCurrentParseLine
import COM_BeginParseSession
import COM_DefaultExtension
import COM_StripExtension
import COM_SkipPath
import Com_Clamp
import PerpendicularVector
import AngleVectors
import MatrixMultiply
import MakeNormalVectors
import RotateAroundDirection
import RotatePointAroundVector
import ProjectPointOnPlane
import PlaneFromPoints
import AngleDelta
import AngleNormalize180
import AngleNormalize360
import AnglesSubtract
import AngleSubtract
import LerpAngle
import AngleMod
import BoxOnPlaneSide
import SetPlaneSignbits
import AxisCopy
import AxisClear
import AnglesToAxis
import vectoangles
import Q_crandom
import Q_random
import Q_rand
import Q_acos
import Q_log2
import VectorRotate
import Vector4Scale
import VectorNormalize2
import VectorNormalize
import CrossProduct
import VectorInverse
import VectorNormalizeFast
import DistanceSquared
import Distance
import VectorLengthSquared
import VectorLength
import VectorCompare
import AddPointToBounds
import ClearBounds
import RadiusFromBounds
import NormalizeColor
import ColorBytes4
import ColorBytes3
import _VectorMA
import _VectorScale
import _VectorCopy
import _VectorAdd
import _VectorSubtract
import _DotProduct
import ByteToDir
import DirToByte
import ClampShort
import ClampChar
import Q_rsqrt
import Q_fabs
import axisDefault
import vec3_origin
import g_color_table
import colorDkGrey
import colorMdGrey
import colorLtGrey
import colorWhite
import colorCyan
import colorMagenta
import colorYellow
import colorBlue
import colorGreen
import colorRed
import colorBlack
import bytedirs
import Com_Memcpy
import Com_Memset
import Hunk_Alloc
import FloatSwap
import LongSwap
import ShortSwap
import acos
import fabs
import abs
import tan
import atan2
import cos
import sin
import sqrt
import floor
import ceil
import memcpy
import memset
import memmove
import sscanf
import vsprintf
import _atoi
import atoi
import _atof
import atof
import toupper
import tolower
import strncpy
import strstr
import strchr
import strcmp
import strcpy
import strcat
import strlen
import rand
import srand
import qsort
lit
align 1
LABELV $1599
byte 1 67
byte 1 71
byte 1 95
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 80
byte 1 111
byte 1 111
byte 1 108
byte 1 32
byte 1 112
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1545
byte 1 67
byte 1 71
byte 1 95
byte 1 79
byte 1 105
byte 1 108
byte 1 83
byte 1 108
byte 1 105
byte 1 99
byte 1 107
byte 1 82
byte 1 101
byte 1 118
byte 1 111
byte 1 118
byte 1 101
byte 1 32
byte 1 78
byte 1 85
byte 1 76
byte 1 76
byte 1 32
byte 1 105
byte 1 100
byte 1 10
byte 1 0
align 1
LABELV $1531
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 95
byte 1 79
byte 1 105
byte 1 108
byte 1 83
byte 1 108
byte 1 105
byte 1 99
byte 1 107
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1523
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 95
byte 1 79
byte 1 105
byte 1 108
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1509
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 95
byte 1 66
byte 1 108
byte 1 101
byte 1 101
byte 1 100
byte 1 32
byte 1 112
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1499
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 73
byte 1 109
byte 1 112
byte 1 97
byte 1 99
byte 1 116
byte 1 83
byte 1 109
byte 1 111
byte 1 107
byte 1 101
byte 1 80
byte 1 117
byte 1 102
byte 1 102
byte 1 32
byte 1 112
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1439
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 69
byte 1 120
byte 1 112
byte 1 108
byte 1 111
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 115
byte 1 116
byte 1 114
byte 1 105
byte 1 110
byte 1 103
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $1430
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 69
byte 1 120
byte 1 112
byte 1 108
byte 1 111
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 58
byte 1 32
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 83
byte 1 116
byte 1 114
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 112
byte 1 114
byte 1 111
byte 1 98
byte 1 97
byte 1 98
byte 1 108
byte 1 121
byte 1 32
byte 1 97
byte 1 110
byte 1 32
byte 1 105
byte 1 110
byte 1 100
byte 1 101
byte 1 120
byte 1 32
byte 1 114
byte 1 97
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 32
byte 1 116
byte 1 104
byte 1 97
byte 1 110
byte 1 32
byte 1 97
byte 1 32
byte 1 115
byte 1 116
byte 1 114
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $1411
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 83
byte 1 109
byte 1 111
byte 1 107
byte 1 101
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1390
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 83
byte 1 110
byte 1 111
byte 1 119
byte 1 32
byte 1 112
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $1375
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 83
byte 1 110
byte 1 111
byte 1 119
byte 1 70
byte 1 108
byte 1 117
byte 1 114
byte 1 114
byte 1 121
byte 1 32
byte 1 112
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 33
byte 1 10
byte 1 0
align 1
LABELV $242
byte 1 37
byte 1 115
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $224
byte 1 101
byte 1 120
byte 1 112
byte 1 108
byte 1 111
byte 1 100
byte 1 101
byte 1 49
byte 1 0
align 1
LABELV $98
byte 1 67
byte 1 71
byte 1 95
byte 1 73
byte 1 109
byte 1 112
byte 1 97
byte 1 99
byte 1 116
byte 1 77
byte 1 97
byte 1 114
byte 1 107
byte 1 32
byte 1 99
byte 1 97
byte 1 108
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 60
byte 1 61
byte 1 32
byte 1 48
byte 1 32
byte 1 114
byte 1 97
byte 1 100
byte 1 105
byte 1 117
byte 1 115
byte 1 0
align 1
LABELV $81
byte 1 67
byte 1 71
byte 1 95
byte 1 70
byte 1 114
byte 1 101
byte 1 101
byte 1 76
byte 1 111
byte 1 99
byte 1 97
byte 1 108
byte 1 69
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 101
byte 1 0
