export CG_InitLocalEntities
code
proc CG_InitLocalEntities 12 12
file "../cg_localents.c"
line 41
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
;23:
;24:// cg_localents.c -- every frame, generate renderer commands for locally
;25:// processed entities, like smoke puffs, gibs, shells, etc.
;26:
;27:#include "cg_local.h"
;28:
;29:#define	MAX_LOCAL_ENTITIES	512
;30:localEntity_t	cg_localEntities[MAX_LOCAL_ENTITIES];
;31:localEntity_t	cg_activeLocalEntities;		// double linked list
;32:localEntity_t	*cg_freeLocalEntities;		// single linked list
;33:
;34:/*
;35:===================
;36:CG_InitLocalEntities
;37:
;38:This is called at startup and for tournement restarts
;39:===================
;40:*/
;41:void	CG_InitLocalEntities( void ) {
line 44
;42:	int		i;
;43:
;44:	memset( cg_localEntities, 0, sizeof( cg_localEntities ) );
ADDRGP4 cg_localEntities
ARGP4
CNSTI4 0
ARGI4
CNSTI4 149504
ARGI4
ADDRGP4 memset
CALLP4
pop
line 45
;45:	cg_activeLocalEntities.next = &cg_activeLocalEntities;
ADDRGP4 cg_activeLocalEntities+4
ADDRGP4 cg_activeLocalEntities
ASGNP4
line 46
;46:	cg_activeLocalEntities.prev = &cg_activeLocalEntities;
ADDRLP4 4
ADDRGP4 cg_activeLocalEntities
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
ASGNP4
line 47
;47:	cg_freeLocalEntities = cg_localEntities;
ADDRGP4 cg_freeLocalEntities
ADDRGP4 cg_localEntities
ASGNP4
line 48
;48:	for ( i = 0 ; i < MAX_LOCAL_ENTITIES - 1 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $72
line 49
;49:		cg_localEntities[i].next = &cg_localEntities[i+1];
ADDRLP4 8
CNSTI4 292
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 8
INDIRI4
ADDRGP4 cg_localEntities+4
ADDP4
ADDRLP4 8
INDIRI4
ADDRGP4 cg_localEntities+292
ADDP4
ASGNP4
line 50
;50:	}
LABELV $73
line 48
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 511
LTI4 $72
line 51
;51:}
LABELV $70
endproc CG_InitLocalEntities 12 12
export CG_FreeLocalEntity
proc CG_FreeLocalEntity 12 4
line 59
;52:
;53:
;54:/*
;55:==================
;56:CG_FreeLocalEntity
;57:==================
;58:*/
;59:void CG_FreeLocalEntity( localEntity_t *le ) {
line 60
;60:	if ( !le->prev ) {
ADDRFP4 0
INDIRP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $79
line 61
;61:		CG_Error( "CG_FreeLocalEntity: not active" );
ADDRGP4 $81
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 62
;62:	}
LABELV $79
line 65
;63:
;64:	// remove from the doubly linked active list
;65:	le->prev->next = le->next;
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
line 66
;66:	le->next->prev = le->prev;
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
line 69
;67:
;68:	// the free list is only singly linked
;69:	le->next = cg_freeLocalEntities;
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg_freeLocalEntities
INDIRP4
ASGNP4
line 70
;70:	cg_freeLocalEntities = le;
ADDRGP4 cg_freeLocalEntities
ADDRFP4 0
INDIRP4
ASGNP4
line 71
;71:}
LABELV $78
endproc CG_FreeLocalEntity 12 4
export CG_AllocLocalEntity
proc CG_AllocLocalEntity 8 12
line 80
;72:
;73:/*
;74:===================
;75:CG_AllocLocalEntity
;76:
;77:Will allways succeed, even if it requires freeing an old active entity
;78:===================
;79:*/
;80:localEntity_t	*CG_AllocLocalEntity( void ) {
line 83
;81:	localEntity_t	*le;
;82:
;83:	if ( !cg_freeLocalEntities ) {
ADDRGP4 cg_freeLocalEntities
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $83
line 86
;84:		// no free entities, so free the one at the end of the chain
;85:		// remove the oldest active entity
;86:		CG_FreeLocalEntity( cg_activeLocalEntities.prev );
ADDRGP4 cg_activeLocalEntities
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 87
;87:	}
LABELV $83
line 89
;88:
;89:	le = cg_freeLocalEntities;
ADDRLP4 0
ADDRGP4 cg_freeLocalEntities
INDIRP4
ASGNP4
line 90
;90:	cg_freeLocalEntities = cg_freeLocalEntities->next;
ADDRLP4 4
ADDRGP4 cg_freeLocalEntities
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ASGNP4
line 92
;91:
;92:	memset( le, 0, sizeof( *le ) );
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 292
ARGI4
ADDRGP4 memset
CALLP4
pop
line 95
;93:
;94:	// link into the active list
;95:	le->next = cg_activeLocalEntities.next;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg_activeLocalEntities+4
INDIRP4
ASGNP4
line 96
;96:	le->prev = &cg_activeLocalEntities;
ADDRLP4 0
INDIRP4
ADDRGP4 cg_activeLocalEntities
ASGNP4
line 97
;97:	cg_activeLocalEntities.next->prev = le;
ADDRGP4 cg_activeLocalEntities+4
INDIRP4
ADDRLP4 0
INDIRP4
ASGNP4
line 98
;98:	cg_activeLocalEntities.next = le;
ADDRGP4 cg_activeLocalEntities+4
ADDRLP4 0
INDIRP4
ASGNP4
line 99
;99:	return le;
ADDRLP4 0
INDIRP4
RETP4
LABELV $82
endproc CG_AllocLocalEntity 8 12
export CG_BloodTrail
proc CG_BloodTrail 48 48
line 121
;100:}
;101:
;102:
;103:/*
;104:====================================================================================
;105:
;106:FRAGMENT PROCESSING
;107:
;108:A fragment localentity interacts with the environment in some way (hitting walls),
;109:or generates more localentities along a trail.
;110:
;111:====================================================================================
;112:*/
;113:
;114:/*
;115:================
;116:CG_BloodTrail
;117:
;118:Leave expanding blood puffs behind gibs
;119:================
;120:*/
;121:void CG_BloodTrail( localEntity_t *le ) {
line 128
;122:	int		t;
;123:	int		t2;
;124:	int		step;
;125:	vec3_t	newOrigin;
;126:	localEntity_t	*blood;
;127:
;128:	step = 150;
ADDRLP4 20
CNSTI4 150
ASGNI4
line 129
;129:	t = step * ( (cg.time - cg.frametime + step ) / step );
ADDRLP4 0
ADDRLP4 20
INDIRI4
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+107600
INDIRI4
SUBI4
ADDRLP4 20
INDIRI4
ADDI4
ADDRLP4 20
INDIRI4
DIVI4
MULI4
ASGNI4
line 130
;130:	t2 = step * ( cg.time / step );
ADDRLP4 24
ADDRLP4 20
INDIRI4
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 20
INDIRI4
DIVI4
MULI4
ASGNI4
line 132
;131:
;132:	for ( ; t <= t2; t += step ) {
ADDRGP4 $95
JUMPV
LABELV $92
line 133
;133:		BG_EvaluateTrajectory( &le->pos, t, newOrigin );
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 135
;134:
;135:		blood = CG_SmokePuff( newOrigin, vec3_origin, 
ADDRLP4 8
ARGP4
ADDRGP4 vec3_origin
ARGP4
CNSTF4 1101004800
ARGF4
ADDRLP4 36
CNSTF4 1065353216
ASGNF4
ADDRLP4 36
INDIRF4
ARGF4
ADDRLP4 36
INDIRF4
ARGF4
ADDRLP4 36
INDIRF4
ARGF4
ADDRLP4 36
INDIRF4
ARGF4
CNSTF4 1157234688
ARGF4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 40
CNSTI4 0
ASGNI4
ADDRLP4 40
INDIRI4
ARGI4
ADDRLP4 40
INDIRI4
ARGI4
ADDRGP4 cgs+152340+296
INDIRI4
ARGI4
ADDRLP4 44
ADDRGP4 CG_SmokePuff
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 44
INDIRP4
ASGNP4
line 144
;136:					  20,		// radius
;137:					  1, 1, 1, 1,	// color
;138:					  2000,		// trailTime
;139:					  t,		// startTime
;140:					  0,		// fadeInTime
;141:					  0,		// flags
;142:					  cgs.media.bloodTrailShader );
;143:		// use the optimized version
;144:		blood->leType = LE_FALL_SCALE_FADE;
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 5
ASGNI4
line 146
;145:		// drop a total of 40 units over its lifetime
;146:		blood->pos.trDelta[2] = 40;
ADDRLP4 4
INDIRP4
CNSTI4 64
ADDP4
CNSTF4 1109393408
ASGNF4
line 147
;147:	}
LABELV $93
line 132
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
ADDI4
ASGNI4
LABELV $95
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
LEI4 $92
line 148
;148:}
LABELV $88
endproc CG_BloodTrail 48 48
export CG_FragmentBounceMark
proc CG_FragmentBounceMark 20 44
line 156
;149:
;150:
;151:/*
;152:================
;153:CG_FragmentBounceMark
;154:================
;155:*/
;156:void CG_FragmentBounceMark( localEntity_t *le, trace_t *trace ) {
line 159
;157:	int			radius;
;158:
;159:	if ( le->leMarkType == LEMT_BLOOD ) {
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
CNSTI4 2
NEI4 $99
line 161
;160:
;161:		radius = 16 + (rand()&31);
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
CNSTI4 31
BANDI4
CNSTI4 16
ADDI4
ASGNI4
line 162
;162:		CG_ImpactMark( cgs.media.bloodMarkShader, trace->endpos, trace->plane.normal, random()*360,
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRGP4 cgs+152340+372
INDIRI4
ARGI4
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTF4 1135869952
ADDRLP4 8
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ARGF4
ADDRLP4 16
CNSTF4 1065353216
ASGNF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
CNSTI4 1
ARGI4
ADDRLP4 0
INDIRI4
CVIF4 4
ARGF4
CNSTI4 0
ARGI4
ADDRGP4 CG_ImpactMark
CALLV
pop
line 164
;163:			1,1,1,1, qtrue, radius, qfalse );
;164:	} else if ( le->leMarkType == LEMT_BURN ) {
ADDRGP4 $100
JUMPV
LABELV $99
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
CNSTI4 1
NEI4 $103
line 166
;165:
;166:		radius = 8 + (rand()&15);
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
CNSTI4 15
BANDI4
CNSTI4 8
ADDI4
ASGNI4
line 167
;167:		CG_ImpactMark( cgs.media.burnMarkShader, trace->endpos, trace->plane.normal, random()*360,
ADDRLP4 8
ADDRGP4 rand
CALLI4
ASGNI4
ADDRGP4 cgs+152340+380
INDIRI4
ARGI4
ADDRLP4 12
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTF4 1135869952
ADDRLP4 8
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ARGF4
ADDRLP4 16
CNSTF4 1065353216
ASGNF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
CNSTI4 1
ARGI4
ADDRLP4 0
INDIRI4
CVIF4 4
ARGF4
CNSTI4 0
ARGI4
ADDRGP4 CG_ImpactMark
CALLV
pop
line 169
;168:			1,1,1,1, qtrue, radius, qfalse );
;169:	}
LABELV $103
LABELV $100
line 174
;170:
;171:
;172:	// don't allow a fragment to make multiple marks, or they
;173:	// pile up while settling
;174:	le->leMarkType = LEMT_NONE;
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 0
ASGNI4
line 175
;175:}
LABELV $98
endproc CG_FragmentBounceMark 20 44
export CG_FragmentBounceSound
proc CG_FragmentBounceSound 16 16
line 182
;176:
;177:/*
;178:================
;179:CG_FragmentBounceSound
;180:================
;181:*/
;182:void CG_FragmentBounceSound( localEntity_t *le, trace_t *trace ) {
line 183
;183:	if ( le->leBounceSoundType == LEBS_BLOOD ) {
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
CNSTI4 1
NEI4 $108
line 185
;184:		// half the gibs will make splat sounds
;185:		if ( rand() & 1 ) {
ADDRLP4 0
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $109
line 186
;186:			int r = rand()&3;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
CNSTI4 3
BANDI4
ASGNI4
line 189
;187:			sfxHandle_t	s;
;188:
;189:			if ( r == 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $112
line 190
;190:				s = cgs.media.gibBounce1Sound;
ADDRLP4 8
ADDRGP4 cgs+152340+700
INDIRI4
ASGNI4
line 191
;191:			} else if ( r == 1 ) {
ADDRGP4 $113
JUMPV
LABELV $112
ADDRLP4 4
INDIRI4
CNSTI4 1
NEI4 $116
line 192
;192:				s = cgs.media.gibBounce2Sound;
ADDRLP4 8
ADDRGP4 cgs+152340+704
INDIRI4
ASGNI4
line 193
;193:			} else {
ADDRGP4 $117
JUMPV
LABELV $116
line 194
;194:				s = cgs.media.gibBounce3Sound;
ADDRLP4 8
ADDRGP4 cgs+152340+708
INDIRI4
ASGNI4
line 195
;195:			}
LABELV $117
LABELV $113
line 196
;196:			trap_S_StartSound( trace->endpos, ENTITYNUM_WORLD, CHAN_AUTO, s );
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ARGP4
CNSTI4 1022
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 197
;197:		}
line 198
;198:	} else if ( le->leBounceSoundType == LEBS_BRASS ) {
ADDRGP4 $109
JUMPV
LABELV $108
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
CNSTI4 2
NEI4 $122
line 200
;199:
;200:	}
LABELV $122
LABELV $109
line 204
;201:
;202:	// don't allow a fragment to make multiple bounce sounds,
;203:	// or it gets too noisy as they settle
;204:	le->leBounceSoundType = LEBS_NONE;
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 0
ASGNI4
line 205
;205:}
LABELV $107
endproc CG_FragmentBounceSound 16 16
export CG_ReflectVelocity
proc CG_ReflectVelocity 56 12
line 213
;206:
;207:
;208:/*
;209:================
;210:CG_ReflectVelocity
;211:================
;212:*/
;213:void CG_ReflectVelocity( localEntity_t *le, trace_t *trace ) {
line 219
;214:	vec3_t	velocity;
;215:	float	dot;
;216:	int		hitTime;
;217:
;218:	// reflect the velocity on the trace plane
;219:	hitTime = cg.time - cg.frametime + cg.frametime * trace->fraction;
ADDRLP4 16
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+107600
INDIRI4
SUBI4
CVIF4 4
ADDRGP4 cg+107600
INDIRI4
CVIF4 4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 220
;220:	BG_EvaluateTrajectoryDelta( &le->pos, hitTime, velocity );
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BG_EvaluateTrajectoryDelta
CALLV
pop
line 221
;221:	dot = DotProduct( velocity, trace->plane.normal );
ADDRLP4 20
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 0
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
MULF4
ADDRLP4 0+4
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+8
INDIRF4
ADDRLP4 20
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
MULF4
ADDF4
ASGNF4
line 222
;222:	VectorMA( velocity, -2*dot, trace->plane.normal, le->pos.trDelta );
ADDRFP4 0
INDIRP4
CNSTI4 56
ADDP4
ADDRLP4 0
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
CNSTF4 3221225472
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRLP4 0+4
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
CNSTF4 3221225472
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
ADDRLP4 0+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
CNSTF4 3221225472
ADDRLP4 12
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 224
;223:
;224:	VectorScale( le->pos.trDelta, le->bounceFactor, le->pos.trDelta );
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
ADDRLP4 24
INDIRP4
CNSTI4 56
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRF4
ADDRLP4 24
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
ADDRLP4 32
INDIRP4
CNSTI4 60
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRF4
ADDRLP4 32
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 44
ADDRLP4 40
INDIRP4
CNSTI4 64
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRF4
ADDRLP4 40
INDIRP4
CNSTI4 104
ADDP4
INDIRF4
MULF4
ASGNF4
line 226
;225:
;226:	VectorCopy( trace->endpos, le->pos.trBase );
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRB
ASGNB 12
line 227
;227:	le->pos.trTime = cg.time;
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 231
;228:
;229:
;230:	// check for stop, making sure that even on low FPS systems it doesn't bobble
;231:	if ( trace->allsolid || 
ADDRLP4 48
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 48
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $137
ADDRLP4 48
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
CNSTF4 0
LEF4 $133
ADDRLP4 52
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 1109393408
LTF4 $137
ADDRLP4 52
INDIRF4
ADDRGP4 cg+107600
INDIRI4
NEGI4
CVIF4 4
ADDRLP4 52
INDIRF4
MULF4
GEF4 $133
LABELV $137
line 233
;232:		( trace->plane.normal[2] > 0 && 
;233:		( le->pos.trDelta[2] < 40 || le->pos.trDelta[2] < -cg.frametime * le->pos.trDelta[2] ) ) ) {
line 234
;234:		le->pos.trType = TR_STATIONARY;
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTI4 0
ASGNI4
line 235
;235:	} else {
LABELV $133
line 237
;236:
;237:	}
LABELV $134
line 238
;238:}
LABELV $124
endproc CG_ReflectVelocity 56 12
export CG_AddFragment
proc CG_AddFragment 88 28
line 245
;239:
;240:/*
;241:================
;242:CG_AddFragment
;243:================
;244:*/
;245:void CG_AddFragment( localEntity_t *le ) {
line 249
;246:	vec3_t	newOrigin;
;247:	trace_t	trace;
;248:
;249:	if ( le->pos.trType == TR_STATIONARY ) {
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
CNSTI4 0
NEI4 $139
line 254
;250:		// sink into the ground if near the removal time
;251:		int		t;
;252:		float	oldZ;
;253:		
;254:		t = le->endTime - cg.time;
ADDRLP4 68
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
ASGNI4
line 255
;255:		if ( t < SINK_TIME ) {
ADDRLP4 68
INDIRI4
CNSTI4 1000
GEI4 $142
line 259
;256:			// we must use an explicit lighting origin, otherwise the
;257:			// lighting would be lost as soon as the origin went
;258:			// into the ground
;259:			VectorCopy( le->refEntity.origin, le->refEntity.lightingOrigin );
ADDRLP4 76
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 76
INDIRP4
CNSTI4 164
ADDP4
ADDRLP4 76
INDIRP4
CNSTI4 220
ADDP4
INDIRB
ASGNB 12
line 260
;260:			le->refEntity.renderfx |= RF_LIGHTING_ORIGIN;
ADDRLP4 80
ADDRFP4 0
INDIRP4
CNSTI4 156
ADDP4
ASGNP4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 261
;261:			oldZ = le->refEntity.origin[2];
ADDRLP4 72
ADDRFP4 0
INDIRP4
CNSTI4 228
ADDP4
INDIRF4
ASGNF4
line 262
;262:			le->refEntity.origin[2] -= 16 * ( 1.0 - (float)t / SINK_TIME );
ADDRLP4 84
ADDRFP4 0
INDIRP4
CNSTI4 228
ADDP4
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRF4
CNSTF4 1098907648
CNSTF4 1065353216
ADDRLP4 68
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
SUBF4
MULF4
SUBF4
ASGNF4
line 263
;263:			trap_R_AddRefEntityToScene( &le->refEntity );
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 264
;264:			le->refEntity.origin[2] = oldZ;
ADDRFP4 0
INDIRP4
CNSTI4 228
ADDP4
ADDRLP4 72
INDIRF4
ASGNF4
line 265
;265:		} else {
ADDRGP4 $138
JUMPV
LABELV $142
line 266
;266:			trap_R_AddRefEntityToScene( &le->refEntity );
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 267
;267:		}
line 269
;268:
;269:		return;
ADDRGP4 $138
JUMPV
LABELV $139
line 273
;270:	}
;271:
;272:	// calculate new position
;273:	BG_EvaluateTrajectory( &le->pos, cg.time, newOrigin );
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 56
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 276
;274:
;275:	// trace a line from previous position to new position
;276:	CG_Trace( &trace, le->refEntity.origin, NULL, NULL, newOrigin, -1, CONTENTS_SOLID );
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
ARGP4
ADDRLP4 68
CNSTP4 0
ASGNP4
ADDRLP4 68
INDIRP4
ARGP4
ADDRLP4 68
INDIRP4
ARGP4
ADDRLP4 56
ARGP4
CNSTI4 -1
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 CG_Trace
CALLV
pop
line 277
;277:	if ( trace.fraction == 1.0 ) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
NEF4 $145
line 279
;278:		// still in free fall
;279:		VectorCopy( newOrigin, le->refEntity.origin );
ADDRFP4 0
INDIRP4
CNSTI4 220
ADDP4
ADDRLP4 56
INDIRB
ASGNB 12
line 281
;280:
;281:		if ( le->leFlags & LEF_TUMBLE ) {
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $148
line 284
;282:			vec3_t angles;
;283:
;284:			BG_EvaluateTrajectory( &le->angles, cg.time, angles );
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 72
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 285
;285:			AnglesToAxis( angles, le->refEntity.axis );
ADDRLP4 72
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 286
;286:		}
LABELV $148
line 288
;287:
;288:		trap_R_AddRefEntityToScene( &le->refEntity );
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 291
;289:
;290:		// add a blood trail
;291:		if ( le->leBounceSoundType == LEBS_BLOOD ) {
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
CNSTI4 1
NEI4 $138
line 292
;292:			CG_BloodTrail( le );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_BloodTrail
CALLV
pop
line 293
;293:		}
line 295
;294:
;295:		return;
ADDRGP4 $138
JUMPV
LABELV $145
line 301
;296:	}
;297:
;298:	// if it is in a nodrop zone, remove it
;299:	// this keeps gibs from waiting at the bottom of pits of death
;300:	// and floating levels
;301:	if ( trap_CM_PointContents( trace.endpos, 0 ) & CONTENTS_NODROP ) {
ADDRLP4 0+12
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 72
ADDRGP4 trap_CM_PointContents
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CVIU4 4
CNSTU4 2147483648
BANDU4
CNSTU4 0
EQU4 $153
line 302
;302:		CG_FreeLocalEntity( le );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 303
;303:		return;
ADDRGP4 $138
JUMPV
LABELV $153
line 307
;304:	}
;305:
;306:	// leave a mark
;307:	CG_FragmentBounceMark( le, &trace );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FragmentBounceMark
CALLV
pop
line 310
;308:
;309:	// do a bouncy sound
;310:	CG_FragmentBounceSound( le, &trace );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FragmentBounceSound
CALLV
pop
line 313
;311:
;312:	// reflect the velocity on the trace plane
;313:	CG_ReflectVelocity( le, &trace );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CG_ReflectVelocity
CALLV
pop
line 315
;314:
;315:	trap_R_AddRefEntityToScene( &le->refEntity );
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 316
;316:}
LABELV $138
endproc CG_AddFragment 88 28
export CG_AddFadeRGB
proc CG_AddFadeRGB 60 4
line 332
;317:
;318:/*
;319:=====================================================================
;320:
;321:TRIVIAL LOCAL ENTITIES
;322:
;323:These only do simple scaling or modulation before passing to the renderer
;324:=====================================================================
;325:*/
;326:
;327:/*
;328:====================
;329:CG_AddFadeRGB
;330:====================
;331:*/
;332:void CG_AddFadeRGB( localEntity_t *le ) {
line 336
;333:	refEntity_t *re;
;334:	float c;
;335:
;336:	re = &le->refEntity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 338
;337:
;338:	c = ( le->endTime - cg.time ) * le->lifeRate;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 8
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ASGNF4
line 339
;339:	c *= 0xff;
ADDRLP4 4
CNSTF4 1132396544
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 341
;340:
;341:	re->shaderRGBA[0] = le->color[0] * c;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
ADDRLP4 20
CNSTF4 1325400064
ASGNF4
ADDRLP4 16
INDIRF4
ADDRLP4 20
INDIRF4
LTF4 $159
ADDRLP4 12
ADDRLP4 16
INDIRF4
ADDRLP4 20
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $160
JUMPV
LABELV $159
ADDRLP4 12
ADDRLP4 16
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $160
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 12
INDIRU4
CVUU1 4
ASGNU1
line 342
;342:	re->shaderRGBA[1] = le->color[1] * c;
ADDRLP4 28
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
ADDRLP4 32
CNSTF4 1325400064
ASGNF4
ADDRLP4 28
INDIRF4
ADDRLP4 32
INDIRF4
LTF4 $162
ADDRLP4 24
ADDRLP4 28
INDIRF4
ADDRLP4 32
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $163
JUMPV
LABELV $162
ADDRLP4 24
ADDRLP4 28
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $163
ADDRLP4 0
INDIRP4
CNSTI4 117
ADDP4
ADDRLP4 24
INDIRU4
CVUU1 4
ASGNU1
line 343
;343:	re->shaderRGBA[2] = le->color[2] * c;
ADDRLP4 40
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
ADDRLP4 44
CNSTF4 1325400064
ASGNF4
ADDRLP4 40
INDIRF4
ADDRLP4 44
INDIRF4
LTF4 $165
ADDRLP4 36
ADDRLP4 40
INDIRF4
ADDRLP4 44
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $166
JUMPV
LABELV $165
ADDRLP4 36
ADDRLP4 40
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $166
ADDRLP4 0
INDIRP4
CNSTI4 118
ADDP4
ADDRLP4 36
INDIRU4
CVUU1 4
ASGNU1
line 344
;344:	re->shaderRGBA[3] = le->color[3] * c;
ADDRLP4 52
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
ADDRLP4 56
CNSTF4 1325400064
ASGNF4
ADDRLP4 52
INDIRF4
ADDRLP4 56
INDIRF4
LTF4 $168
ADDRLP4 48
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
ADDRGP4 $169
JUMPV
LABELV $168
ADDRLP4 48
ADDRLP4 52
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $169
ADDRLP4 0
INDIRP4
CNSTI4 119
ADDP4
ADDRLP4 48
INDIRU4
CVUU1 4
ASGNU1
line 346
;345:
;346:	trap_R_AddRefEntityToScene( re );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 347
;347:}
LABELV $156
endproc CG_AddFadeRGB 60 4
proc CG_AddMoveScaleFade 52 12
line 354
;348:
;349:/*
;350:==================
;351:CG_AddMoveScaleFade
;352:==================
;353:*/
;354:static void CG_AddMoveScaleFade( localEntity_t *le ) {
line 360
;355:	refEntity_t	*re;
;356:	float		c;
;357:	vec3_t		delta;
;358:	float		len;
;359:
;360:	re = &le->refEntity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 362
;361:
;362:	if ( le->fadeInTime > le->startTime && cg.time < le->fadeInTime ) {
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
ADDRLP4 24
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
ADDRLP4 24
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
LEI4 $171
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 28
INDIRI4
GEI4 $171
line 364
;363:		// fade / grow time
;364:		c = 1.0 - (float) ( le->fadeInTime - cg.time ) / ( le->fadeInTime - le->startTime );
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
ADDRLP4 32
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
CNSTF4 1065353216
ADDRLP4 36
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 36
INDIRI4
ADDRLP4 32
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
SUBF4
ASGNF4
line 365
;365:	}
ADDRGP4 $172
JUMPV
LABELV $171
line 366
;366:	else {
line 368
;367:		// fade / grow time
;368:		c = ( le->endTime - cg.time ) * le->lifeRate;
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 32
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ASGNF4
line 369
;369:	}
LABELV $172
line 371
;370:
;371:	re->shaderRGBA[3] = 0xff * c * le->color[3];
ADDRLP4 36
CNSTF4 1132396544
ADDRLP4 16
INDIRF4
MULF4
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 40
CNSTF4 1325400064
ASGNF4
ADDRLP4 36
INDIRF4
ADDRLP4 40
INDIRF4
LTF4 $177
ADDRLP4 32
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
ADDRGP4 $178
JUMPV
LABELV $177
ADDRLP4 32
ADDRLP4 36
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $178
ADDRLP4 0
INDIRP4
CNSTI4 119
ADDP4
ADDRLP4 32
INDIRU4
CVUU1 4
ASGNU1
line 373
;372:
;373:	if ( !( le->leFlags & LEF_PUFF_DONT_SCALE ) ) {
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $179
line 374
;374:		re->radius = le->radius * ( 1.0 - c ) + 8;
ADDRLP4 0
INDIRP4
CNSTI4 132
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
CNSTF4 1065353216
ADDRLP4 16
INDIRF4
SUBF4
MULF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 375
;375:	}
LABELV $179
line 377
;376:
;377:	BG_EvaluateTrajectory( &le->pos, cg.time, re->origin );
ADDRFP4 0
INDIRP4
CNSTI4 32
ADDP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 381
;378:
;379:	// if the view would be "inside" the sprite, kill the sprite
;380:	// so it doesn't add too much overdraw
;381:	VectorSubtract( re->origin, cg.refdef.vieworg, delta );
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRF4
ADDRGP4 cg+109044+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ADDRGP4 cg+109044+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ADDRGP4 cg+109044+24+8
INDIRF4
SUBF4
ASGNF4
line 382
;382:	len = VectorLength( delta );
ADDRLP4 4
ARGP4
ADDRLP4 48
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 20
ADDRLP4 48
INDIRF4
ASGNF4
line 383
;383:	if ( len < le->radius ) {
ADDRLP4 20
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
GEF4 $192
line 384
;384:		CG_FreeLocalEntity( le );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 385
;385:		return;
ADDRGP4 $170
JUMPV
LABELV $192
line 388
;386:	}
;387:
;388:	trap_R_AddRefEntityToScene( re );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 389
;389:}
LABELV $170
endproc CG_AddMoveScaleFade 52 12
proc CG_AddScaleFade 48 4
line 401
;390:
;391:
;392:/*
;393:===================
;394:CG_AddScaleFade
;395:
;396:For rocket smokes that hang in place, fade out, and are
;397:removed if the view passes through them.
;398:There are often many of these, so it needs to be simple.
;399:===================
;400:*/
;401:static void CG_AddScaleFade( localEntity_t *le ) {
line 407
;402:	refEntity_t	*re;
;403:	float		c;
;404:	vec3_t		delta;
;405:	float		len;
;406:
;407:	re = &le->refEntity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 410
;408:
;409:	// fade / grow time
;410:	c = ( le->endTime - cg.time ) * le->lifeRate;
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
ADDRLP4 24
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 24
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ASGNF4
line 412
;411:
;412:	re->shaderRGBA[3] = 0xff * c * le->color[3];
ADDRLP4 32
CNSTF4 1132396544
ADDRLP4 16
INDIRF4
MULF4
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 36
CNSTF4 1325400064
ASGNF4
ADDRLP4 32
INDIRF4
ADDRLP4 36
INDIRF4
LTF4 $197
ADDRLP4 28
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
ADDRGP4 $198
JUMPV
LABELV $197
ADDRLP4 28
ADDRLP4 32
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $198
ADDRLP4 0
INDIRP4
CNSTI4 119
ADDP4
ADDRLP4 28
INDIRU4
CVUU1 4
ASGNU1
line 413
;413:	re->radius = le->radius * ( 1.0 - c ) + 8;
ADDRLP4 0
INDIRP4
CNSTI4 132
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
CNSTF4 1065353216
ADDRLP4 16
INDIRF4
SUBF4
MULF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 417
;414:
;415:	// if the view would be "inside" the sprite, kill the sprite
;416:	// so it doesn't add too much overdraw
;417:	VectorSubtract( re->origin, cg.refdef.vieworg, delta );
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRF4
ADDRGP4 cg+109044+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ADDRGP4 cg+109044+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ADDRGP4 cg+109044+24+8
INDIRF4
SUBF4
ASGNF4
line 418
;418:	len = VectorLength( delta );
ADDRLP4 4
ARGP4
ADDRLP4 44
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 20
ADDRLP4 44
INDIRF4
ASGNF4
line 419
;419:	if ( len < le->radius ) {
ADDRLP4 20
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
GEF4 $209
line 420
;420:		CG_FreeLocalEntity( le );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 421
;421:		return;
ADDRGP4 $194
JUMPV
LABELV $209
line 424
;422:	}
;423:
;424:	trap_R_AddRefEntityToScene( re );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 425
;425:}
LABELV $194
endproc CG_AddScaleFade 48 4
proc CG_AddFallScaleFade 52 4
line 438
;426:
;427:
;428:/*
;429:=================
;430:CG_AddFallScaleFade
;431:
;432:This is just an optimized CG_AddMoveScaleFade
;433:For blood mists that drift down, fade out, and are
;434:removed if the view passes through them.
;435:There are often 100+ of these, so it needs to be simple.
;436:=================
;437:*/
;438:static void CG_AddFallScaleFade( localEntity_t *le ) {
line 444
;439:	refEntity_t	*re;
;440:	float		c;
;441:	vec3_t		delta;
;442:	float		len;
;443:
;444:	re = &le->refEntity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 447
;445:
;446:	// fade time
;447:	c = ( le->endTime - cg.time ) * le->lifeRate;
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 24
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 24
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ASGNF4
line 449
;448:
;449:	re->shaderRGBA[3] = 0xff * c * le->color[3];
ADDRLP4 32
CNSTF4 1132396544
ADDRLP4 4
INDIRF4
MULF4
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 36
CNSTF4 1325400064
ASGNF4
ADDRLP4 32
INDIRF4
ADDRLP4 36
INDIRF4
LTF4 $214
ADDRLP4 28
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
ADDRGP4 $215
JUMPV
LABELV $214
ADDRLP4 28
ADDRLP4 32
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $215
ADDRLP4 0
INDIRP4
CNSTI4 119
ADDP4
ADDRLP4 28
INDIRU4
CVUU1 4
ASGNU1
line 451
;450:
;451:	re->origin[2] = le->pos.trBase[2] - ( 1.0 - c ) * le->pos.trDelta[2];
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
ADDRLP4 40
INDIRP4
CNSTI4 52
ADDP4
INDIRF4
CNSTF4 1065353216
ADDRLP4 4
INDIRF4
SUBF4
ADDRLP4 40
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
MULF4
SUBF4
ASGNF4
line 453
;452:
;453:	re->radius = le->radius * ( 1.0 - c ) + 16;
ADDRLP4 0
INDIRP4
CNSTI4 132
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
CNSTF4 1065353216
ADDRLP4 4
INDIRF4
SUBF4
MULF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 457
;454:
;455:	// if the view would be "inside" the sprite, kill the sprite
;456:	// so it doesn't add too much overdraw
;457:	VectorSubtract( re->origin, cg.refdef.vieworg, delta );
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRF4
ADDRGP4 cg+109044+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 8+4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRF4
ADDRGP4 cg+109044+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 8+8
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRF4
ADDRGP4 cg+109044+24+8
INDIRF4
SUBF4
ASGNF4
line 458
;458:	len = VectorLength( delta );
ADDRLP4 8
ARGP4
ADDRLP4 48
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 20
ADDRLP4 48
INDIRF4
ASGNF4
line 459
;459:	if ( len < le->radius ) {
ADDRLP4 20
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
GEF4 $226
line 460
;460:		CG_FreeLocalEntity( le );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 461
;461:		return;
ADDRGP4 $211
JUMPV
LABELV $226
line 464
;462:	}
;463:
;464:	trap_R_AddRefEntityToScene( re );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 465
;465:}
LABELV $211
endproc CG_AddFallScaleFade 52 4
proc CG_AddExplosion 20 20
line 474
;466:
;467:
;468:
;469:/*
;470:================
;471:CG_AddExplosion
;472:================
;473:*/
;474:static void CG_AddExplosion( localEntity_t *ex ) {
line 477
;475:	refEntity_t	*ent;
;476:
;477:	ent = &ex->refEntity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 480
;478:
;479:	// add the entity
;480:	trap_R_AddRefEntityToScene(ent);
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 483
;481:
;482:	// add the dlight
;483:	if ( ex->light ) {
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
CNSTF4 0
EQF4 $229
line 486
;484:		float		light;
;485:
;486:		light = (float)( cg.time - ex->startTime ) / ( ex->endTime - ex->startTime );
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 8
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 12
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 8
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 487
;487:		if ( light < 0.5 ) {
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
GEF4 $232
line 488
;488:			light = 1.0;
ADDRLP4 4
CNSTF4 1065353216
ASGNF4
line 489
;489:		} else {
ADDRGP4 $233
JUMPV
LABELV $232
line 490
;490:			light = 1.0 - ( light - 0.5 ) * 2;
ADDRLP4 4
CNSTF4 1065353216
CNSTF4 1073741824
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
SUBF4
MULF4
SUBF4
ASGNF4
line 491
;491:		}
LABELV $233
line 492
;492:		light = ex->light * light;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
line 493
;493:		trap_R_AddLightToScene(ent->origin, light, ex->lightColor[0], ex->lightColor[1], ex->lightColor[2] );
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ARGP4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 132
ADDP4
INDIRF4
ARGF4
ADDRLP4 16
INDIRP4
CNSTI4 136
ADDP4
INDIRF4
ARGF4
ADDRLP4 16
INDIRP4
CNSTI4 140
ADDP4
INDIRF4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 494
;494:	}
LABELV $229
line 495
;495:}
LABELV $228
endproc CG_AddExplosion 20 20
proc CG_AddSpriteExplosion 180 20
line 502
;496:
;497:/*
;498:================
;499:CG_AddSpriteExplosion
;500:================
;501:*/
;502:static void CG_AddSpriteExplosion( localEntity_t *le ) {
line 506
;503:	refEntity_t	re;
;504:	float c;
;505:
;506:	re = le->refEntity;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
INDIRB
ASGNB 140
line 508
;507:
;508:	c = ( le->endTime - cg.time ) / ( float ) ( le->endTime - le->startTime );
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 148
ADDRLP4 144
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ASGNI4
ADDRLP4 140
ADDRLP4 148
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 148
INDIRI4
ADDRLP4 144
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 509
;509:	if ( c > 1 ) {
ADDRLP4 140
INDIRF4
CNSTF4 1065353216
LEF4 $236
line 510
;510:		c = 1.0;	// can happen during connection problems
ADDRLP4 140
CNSTF4 1065353216
ASGNF4
line 511
;511:	}
LABELV $236
line 513
;512:
;513:	re.shaderRGBA[0] = 0xff;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 514
;514:	re.shaderRGBA[1] = 0xff;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 515
;515:	re.shaderRGBA[2] = 0xff;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 516
;516:	re.shaderRGBA[3] = 0xff * c * 0.33;
ADDRLP4 156
CNSTF4 1051260355
CNSTF4 1132396544
ADDRLP4 140
INDIRF4
MULF4
MULF4
ASGNF4
ADDRLP4 160
CNSTF4 1325400064
ASGNF4
ADDRLP4 156
INDIRF4
ADDRLP4 160
INDIRF4
LTF4 $246
ADDRLP4 152
ADDRLP4 156
INDIRF4
ADDRLP4 160
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $247
JUMPV
LABELV $246
ADDRLP4 152
ADDRLP4 156
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $247
ADDRLP4 0+116+3
ADDRLP4 152
INDIRU4
CVUU1 4
ASGNU1
line 518
;517:
;518:	re.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 519
;519:	re.radius = 42 * ( 1.0 - c ) + 30;
ADDRLP4 0+132
CNSTF4 1109917696
CNSTF4 1065353216
ADDRLP4 140
INDIRF4
SUBF4
MULF4
CNSTF4 1106247680
ADDF4
ASGNF4
line 521
;520:
;521:	trap_R_AddRefEntityToScene( &re );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 524
;522:
;523:	// add the dlight
;524:	if ( le->light ) {
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
CNSTF4 0
EQF4 $249
line 527
;525:		float		light;
;526:
;527:		light = (float)( cg.time - le->startTime ) / ( le->endTime - le->startTime );
ADDRLP4 168
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 172
ADDRLP4 168
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
ADDRLP4 164
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 172
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 168
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 172
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 528
;528:		if ( light < 0.5 ) {
ADDRLP4 164
INDIRF4
CNSTF4 1056964608
GEF4 $252
line 529
;529:			light = 1.0;
ADDRLP4 164
CNSTF4 1065353216
ASGNF4
line 530
;530:		} else {
ADDRGP4 $253
JUMPV
LABELV $252
line 531
;531:			light = 1.0 - ( light - 0.5 ) * 2;
ADDRLP4 164
CNSTF4 1065353216
CNSTF4 1073741824
ADDRLP4 164
INDIRF4
CNSTF4 1056964608
SUBF4
MULF4
SUBF4
ASGNF4
line 532
;532:		}
LABELV $253
line 533
;533:		light = le->light * light;
ADDRLP4 164
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
INDIRF4
ADDRLP4 164
INDIRF4
MULF4
ASGNF4
line 534
;534:		trap_R_AddLightToScene(re.origin, light, le->lightColor[0], le->lightColor[1], le->lightColor[2] );
ADDRLP4 0+68
ARGP4
ADDRLP4 164
INDIRF4
ARGF4
ADDRLP4 176
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
INDIRP4
CNSTI4 132
ADDP4
INDIRF4
ARGF4
ADDRLP4 176
INDIRP4
CNSTI4 136
ADDP4
INDIRF4
ARGF4
ADDRLP4 176
INDIRP4
CNSTI4 140
ADDP4
INDIRF4
ARGF4
ADDRGP4 trap_R_AddLightToScene
CALLV
pop
line 535
;535:	}
LABELV $249
line 536
;536:}
LABELV $234
endproc CG_AddSpriteExplosion 180 20
lit
align 4
LABELV $256
byte 4 0
byte 4 0
byte 4 1065353216
export CG_AddScorePlum
code
proc CG_AddScorePlum 168 12
line 721
;537:
;538:
;539:#ifdef MISSIONPACK
;540:/*
;541:====================
;542:CG_AddKamikaze
;543:====================
;544:*/
;545:void CG_AddKamikaze( localEntity_t *le ) {
;546:	refEntity_t	*re;
;547:	refEntity_t shockwave;
;548:	float		c;
;549:	vec3_t		test, axis[3];
;550:	int			t;
;551:
;552:	re = &le->refEntity;
;553:
;554:	t = cg.time - le->startTime;
;555:	VectorClear( test );
;556:	AnglesToAxis( test, axis );
;557:
;558:	if (t > KAMI_SHOCKWAVE_STARTTIME && t < KAMI_SHOCKWAVE_ENDTIME) {
;559:
;560:		if (!(le->leFlags & LEF_SOUND1)) {
;561://			trap_S_StartSound (re->origin, ENTITYNUM_WORLD, CHAN_AUTO, cgs.media.kamikazeExplodeSound );
;562:			trap_S_StartLocalSound(cgs.media.kamikazeExplodeSound, CHAN_AUTO);
;563:			le->leFlags |= LEF_SOUND1;
;564:		}
;565:		// 1st kamikaze shockwave
;566:		memset(&shockwave, 0, sizeof(shockwave));
;567:		shockwave.hModel = cgs.media.kamikazeShockWave;
;568:		shockwave.reType = RT_MODEL;
;569:		shockwave.shaderTime = re->shaderTime;
;570:		VectorCopy(re->origin, shockwave.origin);
;571:
;572:		c = (float)(t - KAMI_SHOCKWAVE_STARTTIME) / (float)(KAMI_SHOCKWAVE_ENDTIME - KAMI_SHOCKWAVE_STARTTIME);
;573:		VectorScale( axis[0], c * KAMI_SHOCKWAVE_MAXRADIUS / KAMI_SHOCKWAVEMODEL_RADIUS, shockwave.axis[0] );
;574:		VectorScale( axis[1], c * KAMI_SHOCKWAVE_MAXRADIUS / KAMI_SHOCKWAVEMODEL_RADIUS, shockwave.axis[1] );
;575:		VectorScale( axis[2], c * KAMI_SHOCKWAVE_MAXRADIUS / KAMI_SHOCKWAVEMODEL_RADIUS, shockwave.axis[2] );
;576:		shockwave.nonNormalizedAxes = qtrue;
;577:
;578:		if (t > KAMI_SHOCKWAVEFADE_STARTTIME) {
;579:			c = (float)(t - KAMI_SHOCKWAVEFADE_STARTTIME) / (float)(KAMI_SHOCKWAVE_ENDTIME - KAMI_SHOCKWAVEFADE_STARTTIME);
;580:		}
;581:		else {
;582:			c = 0;
;583:		}
;584:		c *= 0xff;
;585:		shockwave.shaderRGBA[0] = 0xff - c;
;586:		shockwave.shaderRGBA[1] = 0xff - c;
;587:		shockwave.shaderRGBA[2] = 0xff - c;
;588:		shockwave.shaderRGBA[3] = 0xff - c;
;589:
;590:		trap_R_AddRefEntityToScene( &shockwave );
;591:	}
;592:
;593:	if (t > KAMI_EXPLODE_STARTTIME && t < KAMI_IMPLODE_ENDTIME) {
;594:		// explosion and implosion
;595:		c = ( le->endTime - cg.time ) * le->lifeRate;
;596:		c *= 0xff;
;597:		re->shaderRGBA[0] = le->color[0] * c;
;598:		re->shaderRGBA[1] = le->color[1] * c;
;599:		re->shaderRGBA[2] = le->color[2] * c;
;600:		re->shaderRGBA[3] = le->color[3] * c;
;601:
;602:		if( t < KAMI_IMPLODE_STARTTIME ) {
;603:			c = (float)(t - KAMI_EXPLODE_STARTTIME) / (float)(KAMI_IMPLODE_STARTTIME - KAMI_EXPLODE_STARTTIME);
;604:		}
;605:		else {
;606:			if (!(le->leFlags & LEF_SOUND2)) {
;607://				trap_S_StartSound (re->origin, ENTITYNUM_WORLD, CHAN_AUTO, cgs.media.kamikazeImplodeSound );
;608:				trap_S_StartLocalSound(cgs.media.kamikazeImplodeSound, CHAN_AUTO);
;609:				le->leFlags |= LEF_SOUND2;
;610:			}
;611:			c = (float)(KAMI_IMPLODE_ENDTIME - t) / (float) (KAMI_IMPLODE_ENDTIME - KAMI_IMPLODE_STARTTIME);
;612:		}
;613:		VectorScale( axis[0], c * KAMI_BOOMSPHERE_MAXRADIUS / KAMI_BOOMSPHEREMODEL_RADIUS, re->axis[0] );
;614:		VectorScale( axis[1], c * KAMI_BOOMSPHERE_MAXRADIUS / KAMI_BOOMSPHEREMODEL_RADIUS, re->axis[1] );
;615:		VectorScale( axis[2], c * KAMI_BOOMSPHERE_MAXRADIUS / KAMI_BOOMSPHEREMODEL_RADIUS, re->axis[2] );
;616:		re->nonNormalizedAxes = qtrue;
;617:
;618:		trap_R_AddRefEntityToScene( re );
;619:		// add the dlight
;620:		trap_R_AddLightToScene( re->origin, c * 1000.0, 1.0, 1.0, c );
;621:	}
;622:
;623:	if (t > KAMI_SHOCKWAVE2_STARTTIME && t < KAMI_SHOCKWAVE2_ENDTIME) {
;624:		// 2nd kamikaze shockwave
;625:		if (le->angles.trBase[0] == 0 &&
;626:			le->angles.trBase[1] == 0 &&
;627:			le->angles.trBase[2] == 0) {
;628:			le->angles.trBase[0] = random() * 360;
;629:			le->angles.trBase[1] = random() * 360;
;630:			le->angles.trBase[2] = random() * 360;
;631:		}
;632:		else {
;633:			c = 0;
;634:		}
;635:		memset(&shockwave, 0, sizeof(shockwave));
;636:		shockwave.hModel = cgs.media.kamikazeShockWave;
;637:		shockwave.reType = RT_MODEL;
;638:		shockwave.shaderTime = re->shaderTime;
;639:		VectorCopy(re->origin, shockwave.origin);
;640:
;641:		test[0] = le->angles.trBase[0];
;642:		test[1] = le->angles.trBase[1];
;643:		test[2] = le->angles.trBase[2];
;644:		AnglesToAxis( test, axis );
;645:
;646:		c = (float)(t - KAMI_SHOCKWAVE2_STARTTIME) / (float)(KAMI_SHOCKWAVE2_ENDTIME - KAMI_SHOCKWAVE2_STARTTIME);
;647:		VectorScale( axis[0], c * KAMI_SHOCKWAVE2_MAXRADIUS / KAMI_SHOCKWAVEMODEL_RADIUS, shockwave.axis[0] );
;648:		VectorScale( axis[1], c * KAMI_SHOCKWAVE2_MAXRADIUS / KAMI_SHOCKWAVEMODEL_RADIUS, shockwave.axis[1] );
;649:		VectorScale( axis[2], c * KAMI_SHOCKWAVE2_MAXRADIUS / KAMI_SHOCKWAVEMODEL_RADIUS, shockwave.axis[2] );
;650:		shockwave.nonNormalizedAxes = qtrue;
;651:
;652:		if (t > KAMI_SHOCKWAVE2FADE_STARTTIME) {
;653:			c = (float)(t - KAMI_SHOCKWAVE2FADE_STARTTIME) / (float)(KAMI_SHOCKWAVE2_ENDTIME - KAMI_SHOCKWAVE2FADE_STARTTIME);
;654:		}
;655:		else {
;656:			c = 0;
;657:		}
;658:		c *= 0xff;
;659:		shockwave.shaderRGBA[0] = 0xff - c;
;660:		shockwave.shaderRGBA[1] = 0xff - c;
;661:		shockwave.shaderRGBA[2] = 0xff - c;
;662:		shockwave.shaderRGBA[3] = 0xff - c;
;663:
;664:		trap_R_AddRefEntityToScene( &shockwave );
;665:	}
;666:}
;667:
;668:/*
;669:===================
;670:CG_AddInvulnerabilityImpact
;671:===================
;672:*/
;673:void CG_AddInvulnerabilityImpact( localEntity_t *le ) {
;674:	trap_R_AddRefEntityToScene( &le->refEntity );
;675:}
;676:
;677:/*
;678:===================
;679:CG_AddInvulnerabilityJuiced
;680:===================
;681:*/
;682:void CG_AddInvulnerabilityJuiced( localEntity_t *le ) {
;683:	int t;
;684:
;685:	t = cg.time - le->startTime;
;686:	if ( t > 3000 ) {
;687:		le->refEntity.axis[0][0] = (float) 1.0 + 0.3 * (t - 3000) / 2000;
;688:		le->refEntity.axis[1][1] = (float) 1.0 + 0.3 * (t - 3000) / 2000;
;689:		le->refEntity.axis[2][2] = (float) 0.7 + 0.3 * (2000 - (t - 3000)) / 2000;
;690:	}
;691:	if ( t > 5000 ) {
;692:		le->endTime = 0;
;693:		CG_GibPlayer( le->refEntity.origin );
;694:	}
;695:	else {
;696:		trap_R_AddRefEntityToScene( &le->refEntity );
;697:	}
;698:}
;699:
;700:/*
;701:===================
;702:CG_AddRefEntity
;703:===================
;704:*/
;705:void CG_AddRefEntity( localEntity_t *le ) {
;706:	if (le->endTime < cg.time) {
;707:		CG_FreeLocalEntity( le );
;708:		return;
;709:	}
;710:	trap_R_AddRefEntityToScene( &le->refEntity );
;711:}
;712:
;713:#endif
;714:/*
;715:===================
;716:CG_AddScorePlum
;717:===================
;718:*/
;719:#define NUMBER_SIZE		8
;720:
;721:void CG_AddScorePlum( localEntity_t *le ) {
line 723
;722:	refEntity_t	*re;
;723:	vec3_t		origin, delta, dir, vec, up = {0, 0, 1};
ADDRLP4 112
ADDRGP4 $256
INDIRB
ASGNB 12
line 727
;724:	float		c, len;
;725:	int			i, score, digits[10], numdigits, negative;
;726:
;727:	re = &le->refEntity;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 729
;728:
;729:	c = ( le->endTime - cg.time ) * le->lifeRate;
ADDRLP4 128
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 80
ADDRLP4 128
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 128
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
MULF4
ASGNF4
line 731
;730:
;731:	score = le->radius;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
CVFI4 4
ASGNI4
line 732
;732:	if (score < 0) {
ADDRLP4 12
INDIRI4
CNSTI4 0
GEI4 $258
line 733
;733:		re->shaderRGBA[0] = 0xff;
ADDRLP4 8
INDIRP4
CNSTI4 116
ADDP4
CNSTU1 255
ASGNU1
line 734
;734:		re->shaderRGBA[1] = 0x11;
ADDRLP4 8
INDIRP4
CNSTI4 117
ADDP4
CNSTU1 17
ASGNU1
line 735
;735:		re->shaderRGBA[2] = 0x11;
ADDRLP4 8
INDIRP4
CNSTI4 118
ADDP4
CNSTU1 17
ASGNU1
line 736
;736:	}
ADDRGP4 $259
JUMPV
LABELV $258
line 737
;737:	else {
line 738
;738:		re->shaderRGBA[0] = 0xff;
ADDRLP4 8
INDIRP4
CNSTI4 116
ADDP4
CNSTU1 255
ASGNU1
line 739
;739:		re->shaderRGBA[1] = 0xff;
ADDRLP4 8
INDIRP4
CNSTI4 117
ADDP4
CNSTU1 255
ASGNU1
line 740
;740:		re->shaderRGBA[2] = 0xff;
ADDRLP4 8
INDIRP4
CNSTI4 118
ADDP4
CNSTU1 255
ASGNU1
line 741
;741:		if (score >= 50) {
ADDRLP4 12
INDIRI4
CNSTI4 50
LTI4 $260
line 742
;742:			re->shaderRGBA[1] = 0;
ADDRLP4 8
INDIRP4
CNSTI4 117
ADDP4
CNSTU1 0
ASGNU1
line 743
;743:		} else if (score >= 20) {
ADDRGP4 $261
JUMPV
LABELV $260
ADDRLP4 12
INDIRI4
CNSTI4 20
LTI4 $262
line 744
;744:			re->shaderRGBA[0] = re->shaderRGBA[1] = 0;
ADDRLP4 136
CNSTU1 0
ASGNU1
ADDRLP4 8
INDIRP4
CNSTI4 117
ADDP4
ADDRLP4 136
INDIRU1
ASGNU1
ADDRLP4 8
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 136
INDIRU1
ASGNU1
line 745
;745:		} else if (score >= 10) {
ADDRGP4 $263
JUMPV
LABELV $262
ADDRLP4 12
INDIRI4
CNSTI4 10
LTI4 $264
line 746
;746:			re->shaderRGBA[2] = 0;
ADDRLP4 8
INDIRP4
CNSTI4 118
ADDP4
CNSTU1 0
ASGNU1
line 747
;747:		} else if (score >= 2) {
ADDRGP4 $265
JUMPV
LABELV $264
ADDRLP4 12
INDIRI4
CNSTI4 2
LTI4 $266
line 748
;748:			re->shaderRGBA[0] = re->shaderRGBA[2] = 0;
ADDRLP4 136
CNSTU1 0
ASGNU1
ADDRLP4 8
INDIRP4
CNSTI4 118
ADDP4
ADDRLP4 136
INDIRU1
ASGNU1
ADDRLP4 8
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 136
INDIRU1
ASGNU1
line 749
;749:		}
LABELV $266
LABELV $265
LABELV $263
LABELV $261
line 751
;750:
;751:	}
LABELV $259
line 752
;752:	if (c < 0.25)
ADDRLP4 80
INDIRF4
CNSTF4 1048576000
GEF4 $268
line 753
;753:		re->shaderRGBA[3] = 0xff * 4 * c;
ADDRLP4 136
CNSTF4 1149173760
ADDRLP4 80
INDIRF4
MULF4
ASGNF4
ADDRLP4 140
CNSTF4 1325400064
ASGNF4
ADDRLP4 136
INDIRF4
ADDRLP4 140
INDIRF4
LTF4 $271
ADDRLP4 132
ADDRLP4 136
INDIRF4
ADDRLP4 140
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $272
JUMPV
LABELV $271
ADDRLP4 132
ADDRLP4 136
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $272
ADDRLP4 8
INDIRP4
CNSTI4 119
ADDP4
ADDRLP4 132
INDIRU4
CVUU1 4
ASGNU1
ADDRGP4 $269
JUMPV
LABELV $268
line 755
;754:	else
;755:		re->shaderRGBA[3] = 0xff;
ADDRLP4 8
INDIRP4
CNSTI4 119
ADDP4
CNSTU1 255
ASGNU1
LABELV $269
line 757
;756:
;757:	re->radius = NUMBER_SIZE / 2;
ADDRLP4 8
INDIRP4
CNSTI4 132
ADDP4
CNSTF4 1082130432
ASGNF4
line 759
;758:
;759:	VectorCopy(le->pos.trBase, origin);
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRB
ASGNB 12
line 760
;760:	origin[2] += 110 - c * 100;
ADDRLP4 16+8
ADDRLP4 16+8
INDIRF4
CNSTF4 1121714176
CNSTF4 1120403456
ADDRLP4 80
INDIRF4
MULF4
SUBF4
ADDF4
ASGNF4
line 762
;761:
;762:	VectorSubtract(cg.refdef.vieworg, origin, dir);
ADDRLP4 96
ADDRGP4 cg+109044+24
INDIRF4
ADDRLP4 16
INDIRF4
SUBF4
ASGNF4
ADDRLP4 96+4
ADDRGP4 cg+109044+24+4
INDIRF4
ADDRLP4 16+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 96+8
ADDRGP4 cg+109044+24+8
INDIRF4
ADDRLP4 16+8
INDIRF4
SUBF4
ASGNF4
line 763
;763:	CrossProduct(dir, up, vec);
ADDRLP4 96
ARGP4
ADDRLP4 112
ARGP4
ADDRLP4 28
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 764
;764:	VectorNormalize(vec);
ADDRLP4 28
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 766
;765:
;766:	VectorMA(origin, -10 + 20 * sin(c * 2 * M_PI), vec, origin);
CNSTF4 1078530011
CNSTF4 1073741824
ADDRLP4 80
INDIRF4
MULF4
MULF4
ARGF4
ADDRLP4 144
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 16
ADDRLP4 16
INDIRF4
ADDRLP4 28
INDIRF4
CNSTF4 1101004800
ADDRLP4 144
INDIRF4
MULF4
CNSTF4 3240099840
ADDF4
MULF4
ADDF4
ASGNF4
CNSTF4 1078530011
CNSTF4 1073741824
ADDRLP4 80
INDIRF4
MULF4
MULF4
ARGF4
ADDRLP4 148
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 16+4
INDIRF4
ADDRLP4 28+4
INDIRF4
CNSTF4 1101004800
ADDRLP4 148
INDIRF4
MULF4
CNSTF4 3240099840
ADDF4
MULF4
ADDF4
ASGNF4
CNSTF4 1078530011
CNSTF4 1073741824
ADDRLP4 80
INDIRF4
MULF4
MULF4
ARGF4
ADDRLP4 152
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 16+8
ADDRLP4 16+8
INDIRF4
ADDRLP4 28+8
INDIRF4
CNSTF4 1101004800
ADDRLP4 152
INDIRF4
MULF4
CNSTF4 3240099840
ADDF4
MULF4
ADDF4
ASGNF4
line 770
;767:
;768:	// if the view would be "inside" the sprite, kill the sprite
;769:	// so it doesn't add too much overdraw
;770:	VectorSubtract( origin, cg.refdef.vieworg, delta );
ADDRLP4 84
ADDRLP4 16
INDIRF4
ADDRGP4 cg+109044+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 84+4
ADDRLP4 16+4
INDIRF4
ADDRGP4 cg+109044+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 84+8
ADDRLP4 16+8
INDIRF4
ADDRGP4 cg+109044+24+8
INDIRF4
SUBF4
ASGNF4
line 771
;771:	len = VectorLength( delta );
ADDRLP4 84
ARGP4
ADDRLP4 156
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 124
ADDRLP4 156
INDIRF4
ASGNF4
line 772
;772:	if ( len < 20 ) {
ADDRLP4 124
INDIRF4
CNSTF4 1101004800
GEF4 $304
line 773
;773:		CG_FreeLocalEntity( le );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 774
;774:		return;
ADDRGP4 $255
JUMPV
LABELV $304
line 777
;775:	}
;776:
;777:	negative = qfalse;
ADDRLP4 108
CNSTI4 0
ASGNI4
line 778
;778:	if (score < 0) {
ADDRLP4 12
INDIRI4
CNSTI4 0
GEI4 $306
line 779
;779:		negative = qtrue;
ADDRLP4 108
CNSTI4 1
ASGNI4
line 780
;780:		score = -score;
ADDRLP4 12
ADDRLP4 12
INDIRI4
NEGI4
ASGNI4
line 781
;781:	}
LABELV $306
line 783
;782:
;783:	for (numdigits = 0; !(numdigits && !score); numdigits++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $311
JUMPV
LABELV $308
line 784
;784:		digits[numdigits] = score % 10;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 40
ADDP4
ADDRLP4 12
INDIRI4
CNSTI4 10
MODI4
ASGNI4
line 785
;785:		score = score / 10;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 10
DIVI4
ASGNI4
line 786
;786:	}
LABELV $309
line 783
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $311
ADDRLP4 160
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 160
INDIRI4
EQI4 $308
ADDRLP4 12
INDIRI4
ADDRLP4 160
INDIRI4
NEI4 $308
line 788
;787:
;788:	if (negative) {
ADDRLP4 108
INDIRI4
CNSTI4 0
EQI4 $312
line 789
;789:		digits[numdigits] = 10;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 40
ADDP4
CNSTI4 10
ASGNI4
line 790
;790:		numdigits++;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 791
;791:	}
LABELV $312
line 793
;792:
;793:	for (i = 0; i < numdigits; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $317
JUMPV
LABELV $314
line 794
;794:		VectorMA(origin, (float) (((float) numdigits / 2) - i) * NUMBER_SIZE, vec, re->origin);
ADDRLP4 8
INDIRP4
CNSTI4 68
ADDP4
ADDRLP4 16
INDIRF4
ADDRLP4 28
INDIRF4
CNSTF4 1090519040
ADDRLP4 0
INDIRI4
CVIF4 4
CNSTF4 1073741824
DIVF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 72
ADDP4
ADDRLP4 16+4
INDIRF4
ADDRLP4 28+4
INDIRF4
CNSTF4 1090519040
ADDRLP4 0
INDIRI4
CVIF4 4
CNSTF4 1073741824
DIVF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 76
ADDP4
ADDRLP4 16+8
INDIRF4
ADDRLP4 28+8
INDIRF4
CNSTF4 1090519040
ADDRLP4 0
INDIRI4
CVIF4 4
CNSTF4 1073741824
DIVF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 795
;795:		re->customShader = cgs.media.numberShaders[digits[numdigits-1-i]];
ADDRLP4 164
CNSTI4 2
ASGNI4
ADDRLP4 8
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
SUBI4
ADDRLP4 164
INDIRI4
LSHI4
ADDRLP4 40
ADDP4
INDIRI4
ADDRLP4 164
INDIRI4
LSHI4
ADDRGP4 cgs+152340+300
ADDP4
INDIRI4
ASGNI4
line 796
;796:		trap_R_AddRefEntityToScene( re );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 797
;797:	}
LABELV $315
line 793
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $317
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
LTI4 $314
line 798
;798:}
LABELV $255
endproc CG_AddScorePlum 168 12
export CG_AddLocalEntities
proc CG_AddLocalEntities 16 8
line 811
;799:
;800:
;801:
;802:
;803://==============================================================================
;804:
;805:/*
;806:===================
;807:CG_AddLocalEntities
;808:
;809:===================
;810:*/
;811:void CG_AddLocalEntities( void ) {
line 816
;812:	localEntity_t	*le, *next;
;813:
;814:	// walk the list backwards, so any new local entities generated
;815:	// (trails, marks, etc) will be present this frame
;816:	le = cg_activeLocalEntities.prev;
ADDRLP4 0
ADDRGP4 cg_activeLocalEntities
INDIRP4
ASGNP4
line 817
;817:	for ( ; le != &cg_activeLocalEntities ; le = next ) {
ADDRGP4 $328
JUMPV
LABELV $325
line 820
;818:		// grab next now, so if the local entity is freed we
;819:		// still have it
;820:		next = le->prev;
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRP4
ASGNP4
line 822
;821:
;822:		if ( cg.time >= le->endTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
LTI4 $329
line 823
;823:			CG_FreeLocalEntity( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FreeLocalEntity
CALLV
pop
line 824
;824:			continue;
ADDRGP4 $326
JUMPV
LABELV $329
line 826
;825:		}
;826:		switch ( le->leType ) {
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
LTI4 $332
ADDRLP4 8
INDIRI4
CNSTI4 8
GTI4 $332
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $345
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $345
address $333
address $338
address $337
address $339
address $340
address $342
address $341
address $343
address $344
code
LABELV $332
line 828
;827:		default:
;828:			CG_Error( "Bad leType: %i", le->leType );
ADDRGP4 $335
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 829
;829:			break;
ADDRGP4 $333
JUMPV
line 832
;830:
;831:		case LE_MARK:
;832:			break;
LABELV $337
line 835
;833:
;834:		case LE_SPRITE_EXPLOSION:
;835:			CG_AddSpriteExplosion( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddSpriteExplosion
CALLV
pop
line 836
;836:			break;
ADDRGP4 $333
JUMPV
LABELV $338
line 839
;837:
;838:		case LE_EXPLOSION:
;839:			CG_AddExplosion( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddExplosion
CALLV
pop
line 840
;840:			break;
ADDRGP4 $333
JUMPV
LABELV $339
line 843
;841:
;842:		case LE_FRAGMENT:			// gibs and brass
;843:			CG_AddFragment( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddFragment
CALLV
pop
line 844
;844:			break;
ADDRGP4 $333
JUMPV
LABELV $340
line 847
;845:
;846:		case LE_MOVE_SCALE_FADE:		// water bubbles
;847:			CG_AddMoveScaleFade( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddMoveScaleFade
CALLV
pop
line 848
;848:			break;
ADDRGP4 $333
JUMPV
LABELV $341
line 851
;849:
;850:		case LE_FADE_RGB:				// teleporters, railtrails
;851:			CG_AddFadeRGB( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddFadeRGB
CALLV
pop
line 852
;852:			break;
ADDRGP4 $333
JUMPV
LABELV $342
line 855
;853:
;854:		case LE_FALL_SCALE_FADE: // gib blood trails
;855:			CG_AddFallScaleFade( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddFallScaleFade
CALLV
pop
line 856
;856:			break;
ADDRGP4 $333
JUMPV
LABELV $343
line 859
;857:
;858:		case LE_SCALE_FADE:		// rocket trails
;859:			CG_AddScaleFade( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddScaleFade
CALLV
pop
line 860
;860:			break;
ADDRGP4 $333
JUMPV
LABELV $344
line 863
;861:
;862:		case LE_SCOREPLUM:
;863:			CG_AddScorePlum( le );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_AddScorePlum
CALLV
pop
line 864
;864:			break;
LABELV $333
line 881
;865:
;866:#ifdef MISSIONPACK
;867:		case LE_KAMIKAZE:
;868:			CG_AddKamikaze( le );
;869:			break;
;870:		case LE_INVULIMPACT:
;871:			CG_AddInvulnerabilityImpact( le );
;872:			break;
;873:		case LE_INVULJUICED:
;874:			CG_AddInvulnerabilityJuiced( le );
;875:			break;
;876:		case LE_SHOWREFENTITY:
;877:			CG_AddRefEntity( le );
;878:			break;
;879:#endif
;880:		}
;881:	}
LABELV $326
line 817
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
LABELV $328
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRGP4 cg_activeLocalEntities
CVPU4 4
NEU4 $325
line 882
;882:}
LABELV $324
endproc CG_AddLocalEntities 16 8
bss
export cg_freeLocalEntities
align 4
LABELV cg_freeLocalEntities
skip 4
export cg_activeLocalEntities
align 4
LABELV cg_activeLocalEntities
skip 292
export cg_localEntities
align 4
LABELV cg_localEntities
skip 149504
import CG_NewParticleArea
import initparticles
import CG_ParticleExplosion
import CG_ParticleMisc
import CG_ParticleDust
import CG_ParticleSparks
import CG_ParticleBulletDebris
import CG_ParticleSnowFlurry
import CG_AddParticleShrapnel
import CG_ParticleSmoke
import CG_ParticleSnow
import CG_AddParticles
import CG_ClearParticles
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
import CG_ImpactMark
import CG_AddMarks
import CG_InitMarkPolys
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
import cg_markPolys
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
LABELV $335
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 108
byte 1 101
byte 1 84
byte 1 121
byte 1 112
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 105
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
