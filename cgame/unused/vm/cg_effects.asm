export CG_BubbleTrail
code
proc CG_BubbleTrail 96 4
file "../cg_effects.c"
line 36
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
;23:// cg_effects.c -- these functions generate localentities, usually as a result
;24:// of event processing
;25:
;26:#include "cg_local.h"
;27:
;28:
;29:/*
;30:==================
;31:CG_BubbleTrail
;32:
;33:Bullets shot underwater
;34:==================
;35:*/
;36:void CG_BubbleTrail( vec3_t start, vec3_t end, float spacing ) {
line 42
;37:	vec3_t		move;
;38:	vec3_t		vec;
;39:	float		len;
;40:	int			i;
;41:
;42:	if ( cg_noProjectileTrail.integer ) {
ADDRGP4 cg_noProjectileTrail+12
INDIRI4
CNSTI4 0
EQI4 $71
line 43
;43:		return;
ADDRGP4 $70
JUMPV
LABELV $71
line 46
;44:	}
;45:
;46:	VectorCopy (start, move);
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 47
;47:	VectorSubtract (end, start, vec);
ADDRLP4 32
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 36
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 32
INDIRP4
INDIRF4
ADDRLP4 36
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 40
CNSTI4 4
ASGNI4
ADDRLP4 12+4
ADDRLP4 32
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRF4
ADDRLP4 36
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 44
CNSTI4 8
ASGNI4
ADDRLP4 12+8
ADDRFP4 4
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
line 48
;48:	len = VectorNormalize (vec);
ADDRLP4 12
ARGP4
ADDRLP4 48
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 28
ADDRLP4 48
INDIRF4
ASGNF4
line 51
;49:
;50:	// advance a random amount first
;51:	i = rand() % (int)spacing;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 24
ADDRLP4 52
INDIRI4
ADDRFP4 8
INDIRF4
CVFI4 4
MODI4
ASGNI4
line 52
;52:	VectorMA( move, i, vec, move );
ADDRLP4 56
ADDRLP4 24
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 12
INDIRF4
ADDRLP4 56
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 12+4
INDIRF4
ADDRLP4 56
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 12+8
INDIRF4
ADDRLP4 24
INDIRI4
CVIF4 4
MULF4
ADDF4
ASGNF4
line 54
;53:
;54:	VectorScale (vec, spacing, vec);
ADDRLP4 60
ADDRFP4 8
INDIRF4
ASGNF4
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRLP4 60
INDIRF4
MULF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
ADDRLP4 60
INDIRF4
MULF4
ASGNF4
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
ADDRFP4 8
INDIRF4
MULF4
ASGNF4
line 56
;55:
;56:	for ( ; i < len; i += spacing ) {
ADDRGP4 $89
JUMPV
LABELV $86
line 60
;57:		localEntity_t	*le;
;58:		refEntity_t		*re;
;59:
;60:		le = CG_AllocLocalEntity();
ADDRLP4 72
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 72
INDIRP4
ASGNP4
line 61
;61:		le->leFlags = LEF_PUFF_DONT_SCALE;
ADDRLP4 64
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 1
ASGNI4
line 62
;62:		le->leType = LE_MOVE_SCALE_FADE;
ADDRLP4 64
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 4
ASGNI4
line 63
;63:		le->startTime = cg.time;
ADDRLP4 64
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 64
;64:		le->endTime = cg.time + 1000 + random() * 250;
ADDRLP4 76
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 64
INDIRP4
CNSTI4 20
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 1000
ADDI4
CVIF4 4
CNSTF4 1132068864
ADDRLP4 76
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 65
;65:		le->lifeRate = 1.0 / ( le->endTime - le->startTime );
ADDRLP4 64
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1065353216
ADDRLP4 64
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 64
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 67
;66:
;67:		re = &le->refEntity;
ADDRLP4 68
ADDRLP4 64
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 68
;68:		re->shaderTime = cg.time / 1000.0f;
ADDRLP4 68
INDIRP4
CNSTI4 128
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 70
;69:
;70:		re->reType = RT_SPRITE;
ADDRLP4 68
INDIRP4
CNSTI4 2
ASGNI4
line 71
;71:		re->rotation = 0;
ADDRLP4 68
INDIRP4
CNSTI4 136
ADDP4
CNSTF4 0
ASGNF4
line 72
;72:		re->radius = 3;
ADDRLP4 68
INDIRP4
CNSTI4 132
ADDP4
CNSTF4 1077936128
ASGNF4
line 73
;73:		re->customShader = cgs.media.waterBubbleShader;
ADDRLP4 68
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+292
INDIRI4
ASGNI4
line 74
;74:		re->shaderRGBA[0] = 0xff;
ADDRLP4 68
INDIRP4
CNSTI4 116
ADDP4
CNSTU1 255
ASGNU1
line 75
;75:		re->shaderRGBA[1] = 0xff;
ADDRLP4 68
INDIRP4
CNSTI4 117
ADDP4
CNSTU1 255
ASGNU1
line 76
;76:		re->shaderRGBA[2] = 0xff;
ADDRLP4 68
INDIRP4
CNSTI4 118
ADDP4
CNSTU1 255
ASGNU1
line 77
;77:		re->shaderRGBA[3] = 0xff;
ADDRLP4 68
INDIRP4
CNSTI4 119
ADDP4
CNSTU1 255
ASGNU1
line 79
;78:
;79:		le->color[3] = 1.0;
ADDRLP4 64
INDIRP4
CNSTI4 120
ADDP4
CNSTF4 1065353216
ASGNF4
line 81
;80:
;81:		le->pos.trType = TR_LINEAR;
ADDRLP4 64
INDIRP4
CNSTI4 32
ADDP4
CNSTI4 2
ASGNI4
line 82
;82:		le->pos.trTime = cg.time;
ADDRLP4 64
INDIRP4
CNSTI4 36
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 83
;83:		VectorCopy( move, le->pos.trBase );
ADDRLP4 64
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 84
;84:		le->pos.trDelta[0] = crandom()*5;
ADDRLP4 84
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 64
INDIRP4
CNSTI4 56
ADDP4
CNSTF4 1084227584
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
ASGNF4
line 85
;85:		le->pos.trDelta[1] = crandom()*5;
ADDRLP4 88
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 64
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 1084227584
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
line 86
;86:		le->pos.trDelta[2] = crandom()*5 + 6;
ADDRLP4 92
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 64
INDIRP4
CNSTI4 64
ADDP4
CNSTF4 1084227584
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
CNSTF4 1086324736
ADDF4
ASGNF4
line 88
;87:
;88:		VectorAdd (move, vec, move);
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 12+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 12+8
INDIRF4
ADDF4
ASGNF4
line 89
;89:	}
LABELV $87
line 56
ADDRLP4 24
ADDRLP4 24
INDIRI4
CVIF4 4
ADDRFP4 8
INDIRF4
ADDF4
CVFI4 4
ASGNI4
LABELV $89
ADDRLP4 24
INDIRI4
CVIF4 4
ADDRLP4 28
INDIRF4
LTF4 $86
line 90
;90:}
LABELV $70
endproc CG_BubbleTrail 96 4
data
align 4
LABELV $103
byte 4 146
export CG_SmokePuff
code
proc CG_SmokePuff 52 4
line 106
;91:
;92:/*
;93:=====================
;94:CG_SmokePuff
;95:
;96:Adds a smoke puff or blood trail localEntity.
;97:=====================
;98:*/
;99:localEntity_t *CG_SmokePuff( const vec3_t p, const vec3_t vel, 
;100:				   float radius,
;101:				   float r, float g, float b, float a,
;102:				   float duration,
;103:				   int startTime,
;104:				   int fadeInTime,
;105:				   int leFlags,
;106:				   qhandle_t hShader ) {
line 112
;107:	static int	seed = 0x92;
;108:	localEntity_t	*le;
;109:	refEntity_t		*re;
;110://	int fadeInTime = startTime + duration / 2;
;111:
;112:	le = CG_AllocLocalEntity();
ADDRLP4 8
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 113
;113:	le->leFlags = leFlags;
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ADDRFP4 40
INDIRI4
ASGNI4
line 114
;114:	le->radius = radius;
ADDRLP4 0
INDIRP4
CNSTI4 124
ADDP4
ADDRFP4 8
INDIRF4
ASGNF4
line 116
;115:
;116:	re = &le->refEntity;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 117
;117:	re->rotation = Q_random( &seed ) * 360;
ADDRGP4 $103
ARGP4
ADDRLP4 12
ADDRGP4 Q_random
CALLF4
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 136
ADDP4
CNSTF4 1135869952
ADDRLP4 12
INDIRF4
MULF4
ASGNF4
line 118
;118:	re->radius = radius;
ADDRLP4 4
INDIRP4
CNSTI4 132
ADDP4
ADDRFP4 8
INDIRF4
ASGNF4
line 119
;119:	re->shaderTime = startTime / 1000.0f;
ADDRLP4 4
INDIRP4
CNSTI4 128
ADDP4
ADDRFP4 32
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 121
;120:
;121:	le->leType = LE_MOVE_SCALE_FADE;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 4
ASGNI4
line 122
;122:	le->startTime = startTime;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRFP4 32
INDIRI4
ASGNI4
line 123
;123:	le->fadeInTime = fadeInTime;
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 36
INDIRI4
ASGNI4
line 124
;124:	le->endTime = startTime + duration;
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRFP4 32
INDIRI4
CVIF4 4
ADDRFP4 28
INDIRF4
ADDF4
CVFI4 4
ASGNI4
line 125
;125:	if ( fadeInTime > startTime ) {
ADDRFP4 36
INDIRI4
ADDRFP4 32
INDIRI4
LEI4 $104
line 126
;126:		le->lifeRate = 1.0 / ( le->endTime - le->fadeInTime );
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1065353216
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 127
;127:	}
ADDRGP4 $105
JUMPV
LABELV $104
line 128
;128:	else {
line 129
;129:		le->lifeRate = 1.0 / ( le->endTime - le->startTime );
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1065353216
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 130
;130:	}
LABELV $105
line 131
;131:	le->color[0] = r;
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
ADDRFP4 12
INDIRF4
ASGNF4
line 132
;132:	le->color[1] = g; 
ADDRLP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRFP4 16
INDIRF4
ASGNF4
line 133
;133:	le->color[2] = b;
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRFP4 20
INDIRF4
ASGNF4
line 134
;134:	le->color[3] = a;
ADDRLP4 0
INDIRP4
CNSTI4 120
ADDP4
ADDRFP4 24
INDIRF4
ASGNF4
line 137
;135:
;136:
;137:	le->pos.trType = TR_LINEAR;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTI4 2
ASGNI4
line 138
;138:	le->pos.trTime = startTime;
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 32
INDIRI4
ASGNI4
line 139
;139:	VectorCopy( vel, le->pos.trDelta );
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 140
;140:	VectorCopy( p, le->pos.trBase );
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 142
;141:
;142:	VectorCopy( p, re->origin );
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 143
;143:	re->customShader = hShader;
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
ADDRFP4 44
INDIRI4
ASGNI4
line 146
;144:
;145:	// rage pro can't alpha fade, so use a different shader
;146:	if ( cgs.glconfig.hardwareType == GLHW_RAGEPRO ) {
ADDRGP4 cgs+20100+11288
INDIRI4
CNSTI4 3
NEI4 $106
line 147
;147:		re->customShader = cgs.media.smokePuffRageProShader;
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+280
INDIRI4
ASGNI4
line 148
;148:		re->shaderRGBA[0] = 0xff;
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
CNSTU1 255
ASGNU1
line 149
;149:		re->shaderRGBA[1] = 0xff;
ADDRLP4 4
INDIRP4
CNSTI4 117
ADDP4
CNSTU1 255
ASGNU1
line 150
;150:		re->shaderRGBA[2] = 0xff;
ADDRLP4 4
INDIRP4
CNSTI4 118
ADDP4
CNSTU1 255
ASGNU1
line 151
;151:		re->shaderRGBA[3] = 0xff;
ADDRLP4 4
INDIRP4
CNSTI4 119
ADDP4
CNSTU1 255
ASGNU1
line 152
;152:	} else {
ADDRGP4 $107
JUMPV
LABELV $106
line 153
;153:		re->shaderRGBA[0] = le->color[0] * 0xff;
ADDRLP4 20
CNSTF4 1132396544
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 24
CNSTF4 1325400064
ASGNF4
ADDRLP4 20
INDIRF4
ADDRLP4 24
INDIRF4
LTF4 $113
ADDRLP4 16
ADDRLP4 20
INDIRF4
ADDRLP4 24
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $114
JUMPV
LABELV $113
ADDRLP4 16
ADDRLP4 20
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $114
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 16
INDIRU4
CVUU1 4
ASGNU1
line 154
;154:		re->shaderRGBA[1] = le->color[1] * 0xff;
ADDRLP4 32
CNSTF4 1132396544
ADDRLP4 0
INDIRP4
CNSTI4 112
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
LTF4 $116
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
ADDRGP4 $117
JUMPV
LABELV $116
ADDRLP4 28
ADDRLP4 32
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $117
ADDRLP4 4
INDIRP4
CNSTI4 117
ADDP4
ADDRLP4 28
INDIRU4
CVUU1 4
ASGNU1
line 155
;155:		re->shaderRGBA[2] = le->color[2] * 0xff;
ADDRLP4 44
CNSTF4 1132396544
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 48
CNSTF4 1325400064
ASGNF4
ADDRLP4 44
INDIRF4
ADDRLP4 48
INDIRF4
LTF4 $119
ADDRLP4 40
ADDRLP4 44
INDIRF4
ADDRLP4 48
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $120
JUMPV
LABELV $119
ADDRLP4 40
ADDRLP4 44
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $120
ADDRLP4 4
INDIRP4
CNSTI4 118
ADDP4
ADDRLP4 40
INDIRU4
CVUU1 4
ASGNU1
line 156
;156:		re->shaderRGBA[3] = 0xff;
ADDRLP4 4
INDIRP4
CNSTI4 119
ADDP4
CNSTU1 255
ASGNU1
line 157
;157:	}
LABELV $107
line 159
;158:
;159:	re->reType = RT_SPRITE;
ADDRLP4 4
INDIRP4
CNSTI4 2
ASGNI4
line 160
;160:	re->radius = le->radius;
ADDRLP4 4
INDIRP4
CNSTI4 132
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRF4
ASGNF4
line 162
;161:
;162:	return le;
ADDRLP4 0
INDIRP4
RETP4
LABELV $102
endproc CG_SmokePuff 52 4
export CG_SpawnEffect
proc CG_SpawnEffect 28 4
line 172
;163:}
;164:
;165:/*
;166:==================
;167:CG_SpawnEffect
;168:
;169:Player teleporting in or out
;170:==================
;171:*/
;172:void CG_SpawnEffect( vec3_t org ) {
line 176
;173:	localEntity_t	*le;
;174:	refEntity_t		*re;
;175:
;176:	le = CG_AllocLocalEntity();
ADDRLP4 8
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 177
;177:	le->leFlags = 0;
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 0
ASGNI4
line 178
;178:	le->leType = LE_FADE_RGB;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 6
ASGNI4
line 179
;179:	le->startTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 180
;180:	le->endTime = cg.time + 500;
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 181
;181:	le->lifeRate = 1.0 / ( le->endTime - le->startTime );
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1065353216
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 183
;182:
;183:	le->color[0] = le->color[1] = le->color[2] = le->color[3] = 1.0;
ADDRLP4 20
CNSTF4 1065353216
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 120
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
line 185
;184:
;185:	re = &le->refEntity;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 187
;186:
;187:	re->reType = RT_MODEL;
ADDRLP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 188
;188:	re->shaderTime = cg.time / 1000.0f;
ADDRLP4 4
INDIRP4
CNSTI4 128
ADDP4
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 191
;189:
;190:#ifndef MISSIONPACK
;191:	re->customShader = cgs.media.teleportEffectShader;
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
ADDRGP4 cgs+152340+480
INDIRI4
ASGNI4
line 193
;192:#endif
;193:	re->hModel = cgs.media.teleportEffectModel;
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 cgs+152340+476
INDIRI4
ASGNI4
line 194
;194:	AxisClear( re->axis );
ADDRLP4 4
INDIRP4
CNSTI4 28
ADDP4
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 196
;195:
;196:	VectorCopy( org, re->origin );
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 200
;197:#ifdef MISSIONPACK
;198:	re->origin[2] += 16;
;199:#else
;200:	re->origin[2] -= 24;
ADDRLP4 24
ADDRLP4 4
INDIRP4
CNSTI4 76
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRF4
CNSTF4 1103101952
SUBF4
ASGNF4
line 202
;201:#endif
;202:}
LABELV $121
endproc CG_SpawnEffect 28 4
bss
align 4
LABELV $130
skip 12
export CG_ScorePlum
code
proc CG_ScorePlum 52 8
line 387
;203:
;204:
;205:#ifdef MISSIONPACK
;206:/*
;207:===============
;208:CG_LightningBoltBeam
;209:===============
;210:*/
;211:void CG_LightningBoltBeam( vec3_t start, vec3_t end ) {
;212:	localEntity_t	*le;
;213:	refEntity_t		*beam;
;214:
;215:	le = CG_AllocLocalEntity();
;216:	le->leFlags = 0;
;217:	le->leType = LE_SHOWREFENTITY;
;218:	le->startTime = cg.time;
;219:	le->endTime = cg.time + 50;
;220:
;221:	beam = &le->refEntity;
;222:
;223:	VectorCopy( start, beam->origin );
;224:	// this is the end point
;225:	VectorCopy( end, beam->oldorigin );
;226:
;227:	beam->reType = RT_LIGHTNING;
;228:	beam->customShader = cgs.media.lightningShader;
;229:}
;230:
;231:/*
;232:==================
;233:CG_KamikazeEffect
;234:==================
;235:*/
;236:void CG_KamikazeEffect( vec3_t org ) {
;237:	localEntity_t	*le;
;238:	refEntity_t		*re;
;239:
;240:	le = CG_AllocLocalEntity();
;241:	le->leFlags = 0;
;242:	le->leType = LE_KAMIKAZE;
;243:	le->startTime = cg.time;
;244:	le->endTime = cg.time + 3000;//2250;
;245:	le->lifeRate = 1.0 / ( le->endTime - le->startTime );
;246:
;247:	le->color[0] = le->color[1] = le->color[2] = le->color[3] = 1.0;
;248:
;249:	VectorClear(le->angles.trBase);
;250:
;251:	re = &le->refEntity;
;252:
;253:	re->reType = RT_MODEL;
;254:	re->shaderTime = cg.time / 1000.0f;
;255:
;256:	re->hModel = cgs.media.kamikazeEffectModel;
;257:
;258:	VectorCopy( org, re->origin );
;259:
;260:}
;261:
;262:/*
;263:==================
;264:CG_ObeliskExplode
;265:==================
;266:*/
;267:void CG_ObeliskExplode( vec3_t org, int entityNum ) {
;268:	localEntity_t	*le;
;269:	vec3_t origin;
;270:
;271:	// create an explosion
;272:	VectorCopy( org, origin );
;273:	origin[2] += 64;
;274:	le = CG_MakeExplosion( origin, vec3_origin,
;275:						   cgs.media.dishFlashModel,
;276:						   cgs.media.rocketExplosionShader,
;277:						   600, qtrue );
;278:	le->light = 300;
;279:	le->lightColor[0] = 1;
;280:	le->lightColor[1] = 0.75;
;281:	le->lightColor[2] = 0.0;
;282:}
;283:
;284:/*
;285:==================
;286:CG_ObeliskPain
;287:==================
;288:*/
;289:void CG_ObeliskPain( vec3_t org ) {
;290:	float r;
;291:	sfxHandle_t sfx;
;292:
;293:	// hit sound
;294:	r = rand() & 3;
;295:	if ( r < 2 ) {
;296:		sfx = cgs.media.obeliskHitSound1;
;297:	} else if ( r == 2 ) {
;298:		sfx = cgs.media.obeliskHitSound2;
;299:	} else {
;300:		sfx = cgs.media.obeliskHitSound3;
;301:	}
;302:	trap_S_StartSound ( org, ENTITYNUM_NONE, CHAN_BODY, sfx );
;303:}
;304:
;305:
;306:/*
;307:==================
;308:CG_InvulnerabilityImpact
;309:==================
;310:*/
;311:void CG_InvulnerabilityImpact( vec3_t org, vec3_t angles ) {
;312:	localEntity_t	*le;
;313:	refEntity_t		*re;
;314:	int				r;
;315:	sfxHandle_t		sfx;
;316:
;317:	le = CG_AllocLocalEntity();
;318:	le->leFlags = 0;
;319:	le->leType = LE_INVULIMPACT;
;320:	le->startTime = cg.time;
;321:	le->endTime = cg.time + 1000;
;322:	le->lifeRate = 1.0 / ( le->endTime - le->startTime );
;323:
;324:	le->color[0] = le->color[1] = le->color[2] = le->color[3] = 1.0;
;325:
;326:	re = &le->refEntity;
;327:
;328:	re->reType = RT_MODEL;
;329:	re->shaderTime = cg.time / 1000.0f;
;330:
;331:	re->hModel = cgs.media.invulnerabilityImpactModel;
;332:
;333:	VectorCopy( org, re->origin );
;334:	AnglesToAxis( angles, re->axis );
;335:
;336:	r = rand() & 3;
;337:	if ( r < 2 ) {
;338:		sfx = cgs.media.invulnerabilityImpactSound1;
;339:	} else if ( r == 2 ) {
;340:		sfx = cgs.media.invulnerabilityImpactSound2;
;341:	} else {
;342:		sfx = cgs.media.invulnerabilityImpactSound3;
;343:	}
;344:	trap_S_StartSound (org, ENTITYNUM_NONE, CHAN_BODY, sfx );
;345:}
;346:
;347:/*
;348:==================
;349:CG_InvulnerabilityJuiced
;350:==================
;351:*/
;352:void CG_InvulnerabilityJuiced( vec3_t org ) {
;353:	localEntity_t	*le;
;354:	refEntity_t		*re;
;355:	vec3_t			angles;
;356:
;357:	le = CG_AllocLocalEntity();
;358:	le->leFlags = 0;
;359:	le->leType = LE_INVULJUICED;
;360:	le->startTime = cg.time;
;361:	le->endTime = cg.time + 10000;
;362:	le->lifeRate = 1.0 / ( le->endTime - le->startTime );
;363:
;364:	le->color[0] = le->color[1] = le->color[2] = le->color[3] = 1.0;
;365:
;366:	re = &le->refEntity;
;367:
;368:	re->reType = RT_MODEL;
;369:	re->shaderTime = cg.time / 1000.0f;
;370:
;371:	re->hModel = cgs.media.invulnerabilityJuicedModel;
;372:
;373:	VectorCopy( org, re->origin );
;374:	VectorClear(angles);
;375:	AnglesToAxis( angles, re->axis );
;376:
;377:	trap_S_StartSound (org, ENTITYNUM_NONE, CHAN_BODY, cgs.media.invulnerabilityJuicedSound );
;378:}
;379:
;380:#endif
;381:
;382:/*
;383:==================
;384:CG_ScorePlum
;385:==================
;386:*/
;387:void CG_ScorePlum( int client, vec3_t org, int score ) {
line 394
;388:	localEntity_t	*le;
;389:	refEntity_t		*re;
;390:	vec3_t			angles;
;391:	static vec3_t lastPos;
;392:
;393:	// only visualize for the client that scored
;394:	if (client != cg.predictedPlayerState.clientNum || cg_scorePlum.integer == 0) {
ADDRFP4 0
INDIRI4
ADDRGP4 cg+107636+140
INDIRI4
NEI4 $136
ADDRGP4 cg_scorePlum+12
INDIRI4
CNSTI4 0
NEI4 $131
LABELV $136
line 395
;395:		return;
ADDRGP4 $129
JUMPV
LABELV $131
line 398
;396:	}
;397:
;398:	le = CG_AllocLocalEntity();
ADDRLP4 20
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20
INDIRP4
ASGNP4
line 399
;399:	le->leFlags = 0;
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 0
ASGNI4
line 400
;400:	le->leType = LE_SCOREPLUM;
ADDRLP4 24
CNSTI4 8
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
ADDRLP4 24
INDIRI4
ASGNI4
line 401
;401:	le->startTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 402
;402:	le->endTime = cg.time + 4000;
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRGP4 cg+107604
INDIRI4
CNSTI4 4000
ADDI4
ASGNI4
line 403
;403:	le->lifeRate = 1.0 / ( le->endTime - le->startTime );
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1065353216
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 406
;404:
;405:	
;406:	le->color[0] = le->color[1] = le->color[2] = le->color[3] = 1.0;
ADDRLP4 36
CNSTF4 1065353216
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 120
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
ADDRLP4 36
INDIRF4
ASGNF4
line 407
;407:	le->radius = score;
ADDRLP4 0
INDIRP4
CNSTI4 124
ADDP4
ADDRFP4 8
INDIRI4
CVIF4 4
ASGNF4
line 409
;408:	
;409:	VectorCopy( org, le->pos.trBase );
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 410
;410:	if (org[2] >= lastPos[2] - 20 && org[2] <= lastPos[2] + 20) {
ADDRLP4 40
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ASGNF4
ADDRLP4 44
CNSTF4 1101004800
ASGNF4
ADDRLP4 40
INDIRF4
ADDRGP4 $130+8
INDIRF4
ADDRLP4 44
INDIRF4
SUBF4
LTF4 $139
ADDRLP4 40
INDIRF4
ADDRGP4 $130+8
INDIRF4
ADDRLP4 44
INDIRF4
ADDF4
GTF4 $139
line 411
;411:		le->pos.trBase[2] -= 20;
ADDRLP4 48
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRF4
CNSTF4 1101004800
SUBF4
ASGNF4
line 412
;412:	}
LABELV $139
line 415
;413:
;414:	//CG_Printf( "Plum origin %i %i %i -- %i\n", (int)org[0], (int)org[1], (int)org[2], (int)Distance(org, lastPos));
;415:	VectorCopy(org, lastPos);
ADDRGP4 $130
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 418
;416:
;417:
;418:	re = &le->refEntity;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 420
;419:
;420:	re->reType = RT_SPRITE;
ADDRLP4 4
INDIRP4
CNSTI4 2
ASGNI4
line 421
;421:	re->radius = 16;
ADDRLP4 4
INDIRP4
CNSTI4 132
ADDP4
CNSTF4 1098907648
ASGNF4
line 423
;422:
;423:	VectorClear(angles);
ADDRLP4 48
CNSTF4 0
ASGNF4
ADDRLP4 8+8
ADDRLP4 48
INDIRF4
ASGNF4
ADDRLP4 8+4
ADDRLP4 48
INDIRF4
ASGNF4
ADDRLP4 8
ADDRLP4 48
INDIRF4
ASGNF4
line 424
;424:	AnglesToAxis( angles, re->axis );
ADDRLP4 8
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 28
ADDP4
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 425
;425:}
LABELV $129
endproc CG_ScorePlum 52 8
export CG_MakeExplosion
proc CG_MakeExplosion 60 8
line 435
;426:
;427:
;428:/*
;429:====================
;430:CG_MakeExplosion
;431:====================
;432:*/
;433:localEntity_t *CG_MakeExplosion( vec3_t origin, vec3_t dir, 
;434:								qhandle_t hModel, qhandle_t shader,
;435:								int msec, qboolean isSprite ) {
line 441
;436:	float			ang;
;437:	localEntity_t	*ex;
;438:	int				offset;
;439:	vec3_t			tmpVec, newOrigin;
;440:
;441:	if ( msec <= 0 ) {
ADDRFP4 16
INDIRI4
CNSTI4 0
GTI4 $146
line 442
;442:		CG_Error( "CG_MakeExplosion: msec = %i", msec );
ADDRGP4 $148
ARGP4
ADDRFP4 16
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 443
;443:	}
LABELV $146
line 446
;444:
;445:	// skew the time a bit so they aren't all in sync
;446:	offset = rand() & 63;
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 28
ADDRLP4 36
INDIRI4
CNSTI4 63
BANDI4
ASGNI4
line 448
;447:
;448:	ex = CG_AllocLocalEntity();
ADDRLP4 40
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 40
INDIRP4
ASGNP4
line 449
;449:	if ( isSprite ) {
ADDRFP4 20
INDIRI4
CNSTI4 0
EQI4 $149
line 450
;450:		ex->leType = LE_SPRITE_EXPLOSION;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 2
ASGNI4
line 453
;451:
;452:		// randomly rotate sprite orientation
;453:		ex->refEntity.rotation = rand() % 360;
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 288
ADDP4
ADDRLP4 44
INDIRI4
CNSTI4 360
MODI4
CVIF4 4
ASGNF4
line 454
;454:		VectorScale( dir, 16, tmpVec );
ADDRLP4 48
CNSTF4 1098907648
ASGNF4
ADDRLP4 52
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 16
ADDRLP4 48
INDIRF4
ADDRLP4 52
INDIRP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 48
INDIRF4
ADDRLP4 52
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 16+8
CNSTF4 1098907648
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
MULF4
ASGNF4
line 455
;455:		VectorAdd( tmpVec, origin, newOrigin );
ADDRLP4 56
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 16
INDIRF4
ADDRLP4 56
INDIRP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 16+4
INDIRF4
ADDRLP4 56
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 16+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDF4
ASGNF4
line 456
;456:	} else {
ADDRGP4 $150
JUMPV
LABELV $149
line 457
;457:		ex->leType = LE_EXPLOSION;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 1
ASGNI4
line 458
;458:		VectorCopy( origin, newOrigin );
ADDRLP4 4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 461
;459:
;460:		// set axis with random rotate
;461:		if ( !dir ) {
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $157
line 462
;462:			AxisClear( ex->refEntity.axis );
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 463
;463:		} else {
ADDRGP4 $158
JUMPV
LABELV $157
line 464
;464:			ang = rand() % 360;
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 44
INDIRI4
CNSTI4 360
MODI4
CVIF4 4
ASGNF4
line 465
;465:			VectorCopy( dir, ex->refEntity.axis[0] );
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 466
;466:			RotateAroundDirection( ex->refEntity.axis, ang );
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
ARGP4
ADDRLP4 32
INDIRF4
ARGF4
ADDRGP4 RotateAroundDirection
CALLV
pop
line 467
;467:		}
LABELV $158
line 468
;468:	}
LABELV $150
line 470
;469:
;470:	ex->startTime = cg.time - offset;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 28
INDIRI4
SUBI4
ASGNI4
line 471
;471:	ex->endTime = ex->startTime + msec;
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ADDRFP4 16
INDIRI4
ADDI4
ASGNI4
line 474
;472:
;473:	// bias the time so all shader effects start correctly
;474:	ex->refEntity.shaderTime = ex->startTime / 1000.0f;
ADDRLP4 0
INDIRP4
CNSTI4 280
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 476
;475:
;476:	ex->refEntity.hModel = hModel;
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 477
;477:	ex->refEntity.customShader = shader;
ADDRLP4 0
INDIRP4
CNSTI4 264
ADDP4
ADDRFP4 12
INDIRI4
ASGNI4
line 480
;478:
;479:	// set origin
;480:	VectorCopy( newOrigin, ex->refEntity.origin );
ADDRLP4 0
INDIRP4
CNSTI4 220
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 481
;481:	VectorCopy( newOrigin, ex->refEntity.oldorigin );
ADDRLP4 0
INDIRP4
CNSTI4 236
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 483
;482:
;483:	ex->color[0] = ex->color[1] = ex->color[2] = 1.0;
ADDRLP4 56
CNSTF4 1065353216
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 108
ADDP4
ADDRLP4 56
INDIRF4
ASGNF4
line 485
;484:
;485:	return ex;
ADDRLP4 0
INDIRP4
RETP4
LABELV $145
endproc CG_MakeExplosion 60 8
export CG_Bleed
proc CG_Bleed 20 0
line 496
;486:}
;487:
;488:
;489:/*
;490:=================
;491:CG_Bleed
;492:
;493:This is the spurt of blood when a character gets hit
;494:=================
;495:*/
;496:void CG_Bleed( vec3_t origin, int entityNum ) {
line 499
;497:	localEntity_t	*ex;
;498:
;499:	if ( !cg_blood.integer ) {
ADDRGP4 cg_blood+12
INDIRI4
CNSTI4 0
NEI4 $161
line 500
;500:		return;
ADDRGP4 $160
JUMPV
LABELV $161
line 503
;501:	}
;502:
;503:	ex = CG_AllocLocalEntity();
ADDRLP4 4
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 504
;504:	ex->leType = LE_EXPLOSION;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 1
ASGNI4
line 506
;505:
;506:	ex->startTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 507
;507:	ex->endTime = ex->startTime + 500;
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 500
ADDI4
ASGNI4
line 509
;508:	
;509:	VectorCopy ( origin, ex->refEntity.origin);
ADDRLP4 0
INDIRP4
CNSTI4 220
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 510
;510:	ex->refEntity.reType = RT_SPRITE;
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
CNSTI4 2
ASGNI4
line 511
;511:	ex->refEntity.rotation = rand() % 360;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 288
ADDP4
ADDRLP4 12
INDIRI4
CNSTI4 360
MODI4
CVIF4 4
ASGNF4
line 512
;512:	ex->refEntity.radius = 24;
ADDRLP4 0
INDIRP4
CNSTI4 284
ADDP4
CNSTF4 1103101952
ASGNF4
line 514
;513:
;514:	ex->refEntity.customShader = cgs.media.bloodExplosionShader;
ADDRLP4 0
INDIRP4
CNSTI4 264
ADDP4
ADDRGP4 cgs+152340+472
INDIRI4
ASGNI4
line 517
;515:
;516:	// don't show player's own blood in view
;517:	if ( entityNum == cg.snap->ps.clientNum ) {
ADDRFP4 4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $167
line 518
;518:		ex->refEntity.renderfx |= RF_THIRD_PERSON;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 156
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
line 519
;519:	}
LABELV $167
line 520
;520:}
LABELV $160
endproc CG_Bleed 20 0
export CG_LaunchGib
proc CG_LaunchGib 20 8
line 529
;521:
;522:
;523:
;524:/*
;525:==================
;526:CG_LaunchGib
;527:==================
;528:*/
;529:void CG_LaunchGib( vec3_t origin, vec3_t velocity, qhandle_t hModel ) {
line 533
;530:	localEntity_t	*le;
;531:	refEntity_t		*re;
;532:
;533:	le = CG_AllocLocalEntity();
ADDRLP4 8
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 534
;534:	re = &le->refEntity;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 536
;535:
;536:	le->leType = LE_FRAGMENT;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 3
ASGNI4
line 537
;537:	le->startTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 538
;538:	le->endTime = le->startTime + 5000 + random() * 3000;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 5000
ADDI4
CVIF4 4
CNSTF4 1161527296
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 540
;539:
;540:	VectorCopy( origin, re->origin );
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 541
;541:	AxisCopy( axisDefault, re->axis );
ADDRGP4 axisDefault
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 28
ADDP4
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 542
;542:	re->hModel = hModel;
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 544
;543:
;544:	le->pos.trType = TR_GRAVITY;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTI4 5
ASGNI4
line 545
;545:	VectorCopy( origin, le->pos.trBase );
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 546
;546:	VectorCopy( velocity, le->pos.trDelta );
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 547
;547:	le->pos.trTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 549
;548:
;549:	le->bounceFactor = 0.6f;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
CNSTF4 1058642330
ASGNF4
line 551
;550:
;551:	le->leBounceSoundType = LEBS_BLOOD;
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 1
ASGNI4
line 552
;552:	le->leMarkType = LEMT_BLOOD;
ADDRLP4 0
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 2
ASGNI4
line 553
;553:}
LABELV $170
endproc CG_LaunchGib 20 8
export CG_GibPlayer
proc CG_GibPlayer 148 12
line 564
;554:
;555:/*
;556:===================
;557:CG_GibPlayer
;558:
;559:Generated a bunch of gibs launching out from the bodies location
;560:===================
;561:*/
;562:#define	GIB_VELOCITY	250
;563:#define	GIB_JUMP		250
;564:void CG_GibPlayer( vec3_t playerOrigin ) {
line 567
;565:	vec3_t	origin, velocity;
;566:
;567:	if ( !cg_blood.integer ) {
ADDRGP4 cg_blood+12
INDIRI4
CNSTI4 0
NEI4 $174
line 568
;568:		return;
ADDRGP4 $173
JUMPV
LABELV $174
line 571
;569:	}
;570:
;571:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 572
;572:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
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
ASGNF4
line 573
;573:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
ASGNF4
line 574
;574:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
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
MULF4
CNSTF4 1132068864
ADDF4
ASGNF4
line 575
;575:	if ( rand() & 1 ) {
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $179
line 576
;576:		CG_LaunchGib( origin, velocity, cgs.media.gibSkull );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+168
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 577
;577:	} else {
ADDRGP4 $180
JUMPV
LABELV $179
line 578
;578:		CG_LaunchGib( origin, velocity, cgs.media.gibBrain );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+172
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 579
;579:	}
LABELV $180
line 582
;580:
;581:	// allow gibs to be turned off for speed
;582:	if ( !cg_gibs.integer ) {
ADDRGP4 cg_gibs+12
INDIRI4
CNSTI4 0
NEI4 $185
line 583
;583:		return;
ADDRGP4 $173
JUMPV
LABELV $185
line 586
;584:	}
;585:
;586:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 587
;587:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
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
ASGNF4
line 588
;588:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
ASGNF4
line 589
;589:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 48
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 590
;590:	CG_LaunchGib( origin, velocity, cgs.media.gibAbdomen );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+136
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 592
;591:
;592:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 593
;593:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
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
line 594
;594:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 56
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
line 595
;595:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 60
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 596
;596:	CG_LaunchGib( origin, velocity, cgs.media.gibArm );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+140
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 598
;597:
;598:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 599
;599:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 64
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
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
line 600
;600:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 68
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
ASGNF4
line 601
;601:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 72
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 72
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 602
;602:	CG_LaunchGib( origin, velocity, cgs.media.gibChest );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+144
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 604
;603:
;604:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 605
;605:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 76
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 76
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
line 606
;606:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 80
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
ASGNF4
line 607
;607:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 84
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 608
;608:	CG_LaunchGib( origin, velocity, cgs.media.gibFist );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+148
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 610
;609:
;610:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 611
;611:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 88
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
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
line 612
;612:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 92
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
line 613
;613:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 96
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 96
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 614
;614:	CG_LaunchGib( origin, velocity, cgs.media.gibFoot );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+152
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 616
;615:
;616:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 617
;617:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 100
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
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
line 618
;618:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 104
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
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
line 619
;619:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 108
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 108
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 620
;620:	CG_LaunchGib( origin, velocity, cgs.media.gibForearm );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+156
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 622
;621:
;622:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 623
;623:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 112
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 112
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
line 624
;624:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 116
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 116
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
line 625
;625:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 120
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 120
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 626
;626:	CG_LaunchGib( origin, velocity, cgs.media.gibIntestine );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+160
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 628
;627:
;628:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 629
;629:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 124
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 124
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
line 630
;630:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 128
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 128
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
line 631
;631:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 132
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 132
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 632
;632:	CG_LaunchGib( origin, velocity, cgs.media.gibLeg );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+164
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 634
;633:
;634:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 635
;635:	velocity[0] = crandom()*GIB_VELOCITY;
ADDRLP4 136
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 136
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
line 636
;636:	velocity[1] = crandom()*GIB_VELOCITY;
ADDRLP4 140
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 140
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
line 637
;637:	velocity[2] = GIB_JUMP + crandom()*GIB_VELOCITY;
ADDRLP4 144
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1132068864
CNSTF4 1073741824
ADDRLP4 144
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
CNSTF4 1132068864
ADDF4
ASGNF4
line 638
;638:	CG_LaunchGib( origin, velocity, cgs.media.gibLeg );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+164
INDIRI4
ARGI4
ADDRGP4 CG_LaunchGib
CALLV
pop
line 639
;639:}
LABELV $173
endproc CG_GibPlayer 148 12
export CG_LaunchExplode
proc CG_LaunchExplode 20 8
line 646
;640:
;641:/*
;642:==================
;643:CG_LaunchGib
;644:==================
;645:*/
;646:void CG_LaunchExplode( vec3_t origin, vec3_t velocity, qhandle_t hModel ) {
line 650
;647:	localEntity_t	*le;
;648:	refEntity_t		*re;
;649:
;650:	le = CG_AllocLocalEntity();
ADDRLP4 8
ADDRGP4 CG_AllocLocalEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 651
;651:	re = &le->refEntity;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
ASGNP4
line 653
;652:
;653:	le->leType = LE_FRAGMENT;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
CNSTI4 3
ASGNI4
line 654
;654:	le->startTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 655
;655:	le->endTime = le->startTime + 10000 + random() * 6000;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CNSTI4 10000
ADDI4
CVIF4 4
CNSTF4 1169915904
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 657
;656:
;657:	VectorCopy( origin, re->origin );
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 658
;658:	AxisCopy( axisDefault, re->axis );
ADDRGP4 axisDefault
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 28
ADDP4
ARGP4
ADDRGP4 AxisCopy
CALLV
pop
line 659
;659:	re->hModel = hModel;
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 661
;660:
;661:	le->pos.trType = TR_GRAVITY;
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTI4 5
ASGNI4
line 662
;662:	VectorCopy( origin, le->pos.trBase );
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 663
;663:	VectorCopy( velocity, le->pos.trDelta );
ADDRLP4 0
INDIRP4
CNSTI4 56
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 664
;664:	le->pos.trTime = cg.time;
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 666
;665:
;666:	le->bounceFactor = 0.1f;
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
CNSTF4 1036831949
ASGNF4
line 668
;667:
;668:	le->leBounceSoundType = LEBS_BRASS;
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
CNSTI4 2
ASGNI4
line 669
;669:	le->leMarkType = LEMT_NONE;
ADDRLP4 0
INDIRP4
CNSTI4 144
ADDP4
CNSTI4 0
ASGNI4
line 670
;670:}
LABELV $224
endproc CG_LaunchExplode 20 8
export CG_BigExplode
proc CG_BigExplode 92 12
line 681
;671:
;672:#define	EXP_VELOCITY	100
;673:#define	EXP_JUMP		150
;674:/*
;675:===================
;676:CG_GibPlayer
;677:
;678:Generated a bunch of gibs launching out from the bodies location
;679:===================
;680:*/
;681:void CG_BigExplode( vec3_t playerOrigin ) {
line 684
;682:	vec3_t	origin, velocity;
;683:
;684:	if ( !cg_blood.integer ) {
ADDRGP4 cg_blood+12
INDIRI4
CNSTI4 0
NEI4 $228
line 685
;685:		return;
ADDRGP4 $227
JUMPV
LABELV $228
line 688
;686:	}
;687:
;688:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 689
;689:	velocity[0] = crandom()*EXP_VELOCITY;
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1120403456
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
ASGNF4
line 690
;690:	velocity[1] = crandom()*EXP_VELOCITY;
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1120403456
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
ASGNF4
line 691
;691:	velocity[2] = EXP_JUMP + crandom()*EXP_VELOCITY;
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1120403456
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
MULF4
CNSTF4 1125515264
ADDF4
ASGNF4
line 692
;692:	CG_LaunchExplode( origin, velocity, cgs.media.smoke2 );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+176
INDIRI4
ARGI4
ADDRGP4 CG_LaunchExplode
CALLV
pop
line 694
;693:
;694:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 695
;695:	velocity[0] = crandom()*EXP_VELOCITY;
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1120403456
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
ASGNF4
line 696
;696:	velocity[1] = crandom()*EXP_VELOCITY;
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1120403456
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
ASGNF4
line 697
;697:	velocity[2] = EXP_JUMP + crandom()*EXP_VELOCITY;
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1120403456
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
CNSTF4 1125515264
ADDF4
ASGNF4
line 698
;698:	CG_LaunchExplode( origin, velocity, cgs.media.smoke2 );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+176
INDIRI4
ARGI4
ADDRGP4 CG_LaunchExplode
CALLV
pop
line 700
;699:
;700:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 701
;701:	velocity[0] = crandom()*EXP_VELOCITY*1.5;
ADDRLP4 48
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1069547520
CNSTF4 1120403456
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
MULF4
ASGNF4
line 702
;702:	velocity[1] = crandom()*EXP_VELOCITY*1.5;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1069547520
CNSTF4 1120403456
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
MULF4
ASGNF4
line 703
;703:	velocity[2] = EXP_JUMP + crandom()*EXP_VELOCITY;
ADDRLP4 56
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1120403456
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
CNSTF4 1125515264
ADDF4
ASGNF4
line 704
;704:	CG_LaunchExplode( origin, velocity, cgs.media.smoke2 );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+176
INDIRI4
ARGI4
ADDRGP4 CG_LaunchExplode
CALLV
pop
line 706
;705:
;706:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 707
;707:	velocity[0] = crandom()*EXP_VELOCITY*2.0;
ADDRLP4 60
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 64
CNSTF4 1073741824
ASGNF4
ADDRLP4 0
ADDRLP4 64
INDIRF4
CNSTF4 1120403456
ADDRLP4 64
INDIRF4
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
MULF4
ASGNF4
line 708
;708:	velocity[1] = crandom()*EXP_VELOCITY*2.0;
ADDRLP4 68
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 72
CNSTF4 1073741824
ASGNF4
ADDRLP4 0+4
ADDRLP4 72
INDIRF4
CNSTF4 1120403456
ADDRLP4 72
INDIRF4
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
MULF4
ASGNF4
line 709
;709:	velocity[2] = EXP_JUMP + crandom()*EXP_VELOCITY;
ADDRLP4 76
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1120403456
CNSTF4 1073741824
ADDRLP4 76
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
CNSTF4 1125515264
ADDF4
ASGNF4
line 710
;710:	CG_LaunchExplode( origin, velocity, cgs.media.smoke2 );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+176
INDIRI4
ARGI4
ADDRGP4 CG_LaunchExplode
CALLV
pop
line 712
;711:
;712:	VectorCopy( playerOrigin, origin );
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 713
;713:	velocity[0] = crandom()*EXP_VELOCITY*2.5;
ADDRLP4 80
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0
CNSTF4 1075838976
CNSTF4 1120403456
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
MULF4
ASGNF4
line 714
;714:	velocity[1] = crandom()*EXP_VELOCITY*2.5;
ADDRLP4 84
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1075838976
CNSTF4 1120403456
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
MULF4
ASGNF4
line 715
;715:	velocity[2] = EXP_JUMP + crandom()*EXP_VELOCITY;
ADDRLP4 88
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+8
CNSTF4 1120403456
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
CNSTF4 1125515264
ADDF4
ASGNF4
line 716
;716:	CG_LaunchExplode( origin, velocity, cgs.media.smoke2 );
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cgs+152340+176
INDIRI4
ARGI4
ADDRGP4 CG_LaunchExplode
CALLV
pop
line 717
;717:}
LABELV $227
endproc CG_BigExplode 92 12
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
import CG_AddLocalEntities
import CG_AllocLocalEntity
import CG_InitLocalEntities
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
LABELV $148
byte 1 67
byte 1 71
byte 1 95
byte 1 77
byte 1 97
byte 1 107
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
byte 1 109
byte 1 115
byte 1 101
byte 1 99
byte 1 32
byte 1 61
byte 1 32
byte 1 37
byte 1 105
byte 1 0
