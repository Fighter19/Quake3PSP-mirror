export CG_TestModel_f
code
proc CG_TestModel_f 36 12
file "../cg_view.c"
line 71
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
;23:// cg_view.c -- setup all the parameters (position, angle, etc)
;24:// for a 3D rendering
;25:#include "cg_local.h"
;26:
;27:
;28:/*
;29:=============================================================================
;30:
;31:  MODEL TESTING
;32:
;33:The viewthing and gun positioning tools from Q2 have been integrated and
;34:enhanced into a single model testing facility.
;35:
;36:Model viewing can begin with either "testmodel <modelname>" or "testgun <modelname>".
;37:
;38:The names must be the full pathname after the basedir, like 
;39:"models/weapons/v_launch/tris.md3" or "players/male/tris.md3"
;40:
;41:Testmodel will create a fake entity 100 units in front of the current view
;42:position, directly facing the viewer.  It will remain immobile, so you can
;43:move around it to view it from different angles.
;44:
;45:Testgun will cause the model to follow the player around and supress the real
;46:view weapon model.  The default frame 0 of most guns is completely off screen,
;47:so you will probably have to cycle a couple frames to see it.
;48:
;49:"nextframe", "prevframe", "nextskin", and "prevskin" commands will change the
;50:frame or skin of the testmodel.  These are bound to F5, F6, F7, and F8 in
;51:q3default.cfg.
;52:
;53:If a gun is being tested, the "gun_x", "gun_y", and "gun_z" variables will let
;54:you adjust the positioning.
;55:
;56:Note that none of the model testing features update while the game is paused, so
;57:it may be convenient to test with deathmatch set to 1 so that bringing down the
;58:console doesn't pause the game.
;59:
;60:=============================================================================
;61:*/
;62:
;63:/*
;64:=================
;65:CG_TestModel_f
;66:
;67:Creates an entity in front of the current position, which
;68:can then be moved around
;69:=================
;70:*/
;71:void CG_TestModel_f (void) {
line 74
;72:	vec3_t		angles;
;73:
;74:	memset( &cg.testModelEntity, 0, sizeof(cg.testModelEntity) );
ADDRGP4 cg+124784
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 75
;75:	if ( trap_Argc() < 2 ) {
ADDRLP4 12
ADDRGP4 trap_Argc
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 2
GEI4 $73
line 76
;76:		return;
ADDRGP4 $70
JUMPV
LABELV $73
line 79
;77:	}
;78:
;79:	Q_strncpyz (cg.testModelName, CG_Argv( 1 ), MAX_QPATH );
CNSTI4 1
ARGI4
ADDRLP4 16
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRGP4 cg+124924
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 80
;80:	cg.testModelEntity.hModel = trap_R_RegisterModel( cg.testModelName );
ADDRGP4 cg+124924
ARGP4
ADDRLP4 20
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cg+124784+8
ADDRLP4 20
INDIRI4
ASGNI4
line 82
;81:
;82:	if ( trap_Argc() == 3 ) {
ADDRLP4 24
ADDRGP4 trap_Argc
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 3
NEI4 $79
line 83
;83:		cg.testModelEntity.backlerp = atof( CG_Argv( 2 ) );
CNSTI4 2
ARGI4
ADDRLP4 28
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 atof
CALLF4
ASGNF4
ADDRGP4 cg+124784+100
ADDRLP4 32
INDIRF4
ASGNF4
line 84
;84:		cg.testModelEntity.frame = 1;
ADDRGP4 cg+124784+80
CNSTI4 1
ASGNI4
line 85
;85:		cg.testModelEntity.oldframe = 0;
ADDRGP4 cg+124784+96
CNSTI4 0
ASGNI4
line 86
;86:	}
LABELV $79
line 87
;87:	if (! cg.testModelEntity.hModel ) {
ADDRGP4 cg+124784+8
INDIRI4
CNSTI4 0
NEI4 $87
line 88
;88:		CG_Printf( "Can't register model\n" );
ADDRGP4 $91
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 89
;89:		return;
ADDRGP4 $70
JUMPV
LABELV $87
line 92
;90:	}
;91:
;92:	VectorMA( cg.refdef.vieworg, 100, cg.refdef.viewaxis[0], cg.testModelEntity.origin );
ADDRGP4 cg+124784+68
ADDRGP4 cg+109044+24
INDIRF4
CNSTF4 1120403456
ADDRGP4 cg+109044+36
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+124784+68+4
ADDRGP4 cg+109044+24+4
INDIRF4
CNSTF4 1120403456
ADDRGP4 cg+109044+36+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+124784+68+8
ADDRGP4 cg+109044+24+8
INDIRF4
CNSTF4 1120403456
ADDRGP4 cg+109044+36+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 94
;93:
;94:	angles[PITCH] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 95
;95:	angles[YAW] = 180 + cg.refdefViewAngles[1];
ADDRLP4 0+4
ADDRGP4 cg+109412+4
INDIRF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 96
;96:	angles[ROLL] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 98
;97:
;98:	AnglesToAxis( angles, cg.testModelEntity.axis );
ADDRLP4 0
ARGP4
ADDRGP4 cg+124784+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 99
;99:	cg.testGun = qfalse;
ADDRGP4 cg+124988
CNSTI4 0
ASGNI4
line 100
;100:}
LABELV $70
endproc CG_TestModel_f 36 12
export CG_TestGun_f
proc CG_TestGun_f 0 0
line 109
;101:
;102:/*
;103:=================
;104:CG_TestGun_f
;105:
;106:Replaces the current view weapon with the given model
;107:=================
;108:*/
;109:void CG_TestGun_f (void) {
line 110
;110:	CG_TestModel_f();
ADDRGP4 CG_TestModel_f
CALLV
pop
line 111
;111:	cg.testGun = qtrue;
ADDRGP4 cg+124988
CNSTI4 1
ASGNI4
line 112
;112:	cg.testModelEntity.renderfx = RF_MINLIGHT | RF_DEPTHHACK | RF_FIRST_PERSON;
ADDRGP4 cg+124784+4
CNSTI4 13
ASGNI4
line 113
;113:}
LABELV $123
endproc CG_TestGun_f 0 0
export CG_TestModelNextFrame_f
proc CG_TestModelNextFrame_f 4 8
line 116
;114:
;115:
;116:void CG_TestModelNextFrame_f (void) {
line 117
;117:	cg.testModelEntity.frame++;
ADDRLP4 0
ADDRGP4 cg+124784+80
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 118
;118:	CG_Printf( "frame %i\n", cg.testModelEntity.frame );
ADDRGP4 $130
ARGP4
ADDRGP4 cg+124784+80
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 119
;119:}
LABELV $127
endproc CG_TestModelNextFrame_f 4 8
export CG_TestModelPrevFrame_f
proc CG_TestModelPrevFrame_f 4 8
line 121
;120:
;121:void CG_TestModelPrevFrame_f (void) {
line 122
;122:	cg.testModelEntity.frame--;
ADDRLP4 0
ADDRGP4 cg+124784+80
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 123
;123:	if ( cg.testModelEntity.frame < 0 ) {
ADDRGP4 cg+124784+80
INDIRI4
CNSTI4 0
GEI4 $136
line 124
;124:		cg.testModelEntity.frame = 0;
ADDRGP4 cg+124784+80
CNSTI4 0
ASGNI4
line 125
;125:	}
LABELV $136
line 126
;126:	CG_Printf( "frame %i\n", cg.testModelEntity.frame );
ADDRGP4 $130
ARGP4
ADDRGP4 cg+124784+80
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 127
;127:}
LABELV $133
endproc CG_TestModelPrevFrame_f 4 8
export CG_TestModelNextSkin_f
proc CG_TestModelNextSkin_f 4 8
line 129
;128:
;129:void CG_TestModelNextSkin_f (void) {
line 130
;130:	cg.testModelEntity.skinNum++;
ADDRLP4 0
ADDRGP4 cg+124784+104
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 131
;131:	CG_Printf( "skin %i\n", cg.testModelEntity.skinNum );
ADDRGP4 $147
ARGP4
ADDRGP4 cg+124784+104
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 132
;132:}
LABELV $144
endproc CG_TestModelNextSkin_f 4 8
export CG_TestModelPrevSkin_f
proc CG_TestModelPrevSkin_f 4 8
line 134
;133:
;134:void CG_TestModelPrevSkin_f (void) {
line 135
;135:	cg.testModelEntity.skinNum--;
ADDRLP4 0
ADDRGP4 cg+124784+104
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 136
;136:	if ( cg.testModelEntity.skinNum < 0 ) {
ADDRGP4 cg+124784+104
INDIRI4
CNSTI4 0
GEI4 $153
line 137
;137:		cg.testModelEntity.skinNum = 0;
ADDRGP4 cg+124784+104
CNSTI4 0
ASGNI4
line 138
;138:	}
LABELV $153
line 139
;139:	CG_Printf( "skin %i\n", cg.testModelEntity.skinNum );
ADDRGP4 $147
ARGP4
ADDRGP4 cg+124784+104
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 140
;140:}
LABELV $150
endproc CG_TestModelPrevSkin_f 4 8
proc CG_AddTestModel 32 4
line 142
;141:
;142:static void CG_AddTestModel (void) {
line 146
;143:	int		i;
;144:
;145:	// re-register the model, because the level may have changed
;146:	cg.testModelEntity.hModel = trap_R_RegisterModel( cg.testModelName );
ADDRGP4 cg+124924
ARGP4
ADDRLP4 4
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cg+124784+8
ADDRLP4 4
INDIRI4
ASGNI4
line 147
;147:	if (! cg.testModelEntity.hModel ) {
ADDRGP4 cg+124784+8
INDIRI4
CNSTI4 0
NEI4 $165
line 148
;148:		CG_Printf ("Can't register model\n");
ADDRGP4 $91
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 149
;149:		return;
ADDRGP4 $161
JUMPV
LABELV $165
line 153
;150:	}
;151:
;152:	// if testing a gun, set the origin reletive to the view origin
;153:	if ( cg.testGun ) {
ADDRGP4 cg+124988
INDIRI4
CNSTI4 0
EQI4 $169
line 154
;154:		VectorCopy( cg.refdef.vieworg, cg.testModelEntity.origin );
ADDRGP4 cg+124784+68
ADDRGP4 cg+109044+24
INDIRB
ASGNB 12
line 155
;155:		VectorCopy( cg.refdef.viewaxis[0], cg.testModelEntity.axis[0] );
ADDRGP4 cg+124784+28
ADDRGP4 cg+109044+36
INDIRB
ASGNB 12
line 156
;156:		VectorCopy( cg.refdef.viewaxis[1], cg.testModelEntity.axis[1] );
ADDRGP4 cg+124784+28+12
ADDRGP4 cg+109044+36+12
INDIRB
ASGNB 12
line 157
;157:		VectorCopy( cg.refdef.viewaxis[2], cg.testModelEntity.axis[2] );
ADDRGP4 cg+124784+28+24
ADDRGP4 cg+109044+36+24
INDIRB
ASGNB 12
line 160
;158:
;159:		// allow the position to be adjusted
;160:		for (i=0 ; i<3 ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $192
line 161
;161:			cg.testModelEntity.origin[i] += cg.refdef.viewaxis[0][i] * cg_gun_x.value;
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 12
ADDRLP4 8
INDIRI4
ADDRGP4 cg+124784+68
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRF4
ADDRLP4 8
INDIRI4
ADDRGP4 cg+109044+36
ADDP4
INDIRF4
ADDRGP4 cg_gun_x+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 162
;162:			cg.testModelEntity.origin[i] += cg.refdef.viewaxis[1][i] * cg_gun_y.value;
ADDRLP4 16
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 20
ADDRLP4 16
INDIRI4
ADDRGP4 cg+124784+68
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRF4
ADDRLP4 16
INDIRI4
ADDRGP4 cg+109044+36+12
ADDP4
INDIRF4
ADDRGP4 cg_gun_y+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 163
;163:			cg.testModelEntity.origin[i] += cg.refdef.viewaxis[2][i] * cg_gun_z.value;
ADDRLP4 24
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 28
ADDRLP4 24
INDIRI4
ADDRGP4 cg+124784+68
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRF4
ADDRLP4 24
INDIRI4
ADDRGP4 cg+109044+36+24
ADDP4
INDIRF4
ADDRGP4 cg_gun_z+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 164
;164:		}
LABELV $193
line 160
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $192
line 165
;165:	}
LABELV $169
line 167
;166:
;167:	trap_R_AddRefEntityToScene( &cg.testModelEntity );
ADDRGP4 cg+124784
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 168
;168:}
LABELV $161
endproc CG_AddTestModel 32 4
proc CG_CalcVrect 12 8
line 182
;169:
;170:
;171:
;172://============================================================================
;173:
;174:
;175:/*
;176:=================
;177:CG_CalcVrect
;178:
;179:Sets the coordinates of the rendered window
;180:=================
;181:*/
;182:static void CG_CalcVrect (void) {
line 186
;183:	int		size;
;184:
;185:	// the intermission should allways be full screen
;186:	if ( cg.snap->ps.pm_type == PM_INTERMISSION ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 5
NEI4 $215
line 187
;187:		size = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 188
;188:	} else {
ADDRGP4 $216
JUMPV
LABELV $215
line 190
;189:		// bound normal viewsize
;190:		if (cg_viewsize.integer < 30) {
ADDRGP4 cg_viewsize+12
INDIRI4
CNSTI4 30
GEI4 $218
line 191
;191:			trap_Cvar_Set ("cg_viewsize","30");
ADDRGP4 $221
ARGP4
ADDRGP4 $222
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 192
;192:			size = 30;
ADDRLP4 0
CNSTI4 30
ASGNI4
line 193
;193:		} else if (cg_viewsize.integer > 100) {
ADDRGP4 $219
JUMPV
LABELV $218
ADDRGP4 cg_viewsize+12
INDIRI4
CNSTI4 100
LEI4 $223
line 194
;194:			trap_Cvar_Set ("cg_viewsize","100");
ADDRGP4 $221
ARGP4
ADDRGP4 $226
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 195
;195:			size = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 196
;196:		} else {
ADDRGP4 $224
JUMPV
LABELV $223
line 197
;197:			size = cg_viewsize.integer;
ADDRLP4 0
ADDRGP4 cg_viewsize+12
INDIRI4
ASGNI4
line 198
;198:		}
LABELV $224
LABELV $219
line 200
;199:
;200:	}
LABELV $216
line 201
;201:	cg.refdef.width = cgs.glconfig.vidWidth*size/100;
ADDRGP4 cg+109044+8
ADDRGP4 cgs+20100+11304
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 100
DIVI4
ASGNI4
line 202
;202:	cg.refdef.width &= ~1;
ADDRLP4 4
ADDRGP4 cg+109044+8
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 -2
BANDI4
ASGNI4
line 204
;203:
;204:	cg.refdef.height = cgs.glconfig.vidHeight*size/100;
ADDRGP4 cg+109044+12
ADDRGP4 cgs+20100+11308
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 100
DIVI4
ASGNI4
line 205
;205:	cg.refdef.height &= ~1;
ADDRLP4 8
ADDRGP4 cg+109044+12
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 -2
BANDI4
ASGNI4
line 207
;206:
;207:	cg.refdef.x = (cgs.glconfig.vidWidth - cg.refdef.width)/2;
ADDRGP4 cg+109044
ADDRGP4 cgs+20100+11304
INDIRI4
ADDRGP4 cg+109044+8
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 208
;208:	cg.refdef.y = (cgs.glconfig.vidHeight - cg.refdef.height)/2;
ADDRGP4 cg+109044+4
ADDRGP4 cgs+20100+11308
INDIRI4
ADDRGP4 cg+109044+12
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 209
;209:}
LABELV $214
endproc CG_CalcVrect 12 8
data
align 4
LABELV $252
byte 4 3229614080
byte 4 3229614080
byte 4 3229614080
align 4
LABELV $253
byte 4 1082130432
byte 4 1082130432
byte 4 1082130432
code
proc CG_OffsetThirdPersonView 188 28
line 221
;210:
;211://==============================================================================
;212:
;213:
;214:/*
;215:===============
;216:CG_OffsetThirdPersonView
;217:
;218:===============
;219:*/
;220:#define	FOCUS_DISTANCE	512
;221:static void CG_OffsetThirdPersonView( void ) {
line 232
;222:	vec3_t		forward, right, up;
;223:	vec3_t		view;
;224:	vec3_t		focusAngles;
;225:	trace_t		trace;
;226:	static vec3_t	mins = { -4, -4, -4 };
;227:	static vec3_t	maxs = { 4, 4, 4 };
;228:	vec3_t		focusPoint;
;229:	float		focusDist;
;230:	float		forwardScale, sideScale;
;231:
;232:	cg.refdef.vieworg[2] += cg.predictedPlayerState.viewheight;
ADDRLP4 140
ADDRGP4 cg+109044+24+8
ASGNP4
ADDRLP4 140
INDIRP4
ADDRLP4 140
INDIRP4
INDIRF4
ADDRGP4 cg+107636+164
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 234
;233:
;234:	VectorCopy( cg.refdefViewAngles, focusAngles );
ADDRLP4 48
ADDRGP4 cg+109412
INDIRB
ASGNB 12
line 237
;235:
;236:	// if dead, look at killer
;237:	if ( cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+107636+184
INDIRI4
CNSTI4 0
GTI4 $260
line 238
;238:		focusAngles[YAW] = cg.predictedPlayerState.stats[STAT_DEAD_YAW];
ADDRLP4 48+4
ADDRGP4 cg+107636+184+16
INDIRI4
CVIF4 4
ASGNF4
line 239
;239:		cg.refdefViewAngles[YAW] = cg.predictedPlayerState.stats[STAT_DEAD_YAW];
ADDRGP4 cg+109412+4
ADDRGP4 cg+107636+184+16
INDIRI4
CVIF4 4
ASGNF4
line 240
;240:	}
LABELV $260
line 242
;241:
;242:	if ( focusAngles[PITCH] > 45 ) {
ADDRLP4 48
INDIRF4
CNSTF4 1110704128
LEF4 $273
line 243
;243:		focusAngles[PITCH] = 45;		// don't go too far overhead
ADDRLP4 48
CNSTF4 1110704128
ASGNF4
line 244
;244:	}
LABELV $273
line 245
;245:	AngleVectors( focusAngles, forward, NULL, NULL );
ADDRLP4 48
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 144
CNSTP4 0
ASGNP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRLP4 144
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 247
;246:
;247:	VectorMA( cg.refdef.vieworg, FOCUS_DISTANCE, forward, focusPoint );
ADDRLP4 148
CNSTF4 1140850688
ASGNF4
ADDRLP4 12
ADDRGP4 cg+109044+24
INDIRF4
ADDRLP4 148
INDIRF4
ADDRLP4 24
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 12+4
ADDRGP4 cg+109044+24+4
INDIRF4
ADDRLP4 148
INDIRF4
ADDRLP4 24+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 12+8
ADDRGP4 cg+109044+24+8
INDIRF4
CNSTF4 1140850688
ADDRLP4 24+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 249
;248:
;249:	VectorCopy( cg.refdef.vieworg, view );
ADDRLP4 0
ADDRGP4 cg+109044+24
INDIRB
ASGNB 12
line 251
;250:
;251:	view[2] += 8;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 253
;252:
;253:	cg.refdefViewAngles[PITCH] *= 0.5;
ADDRLP4 152
ADDRGP4 cg+109412
ASGNP4
ADDRLP4 152
INDIRP4
CNSTF4 1056964608
ADDRLP4 152
INDIRP4
INDIRF4
MULF4
ASGNF4
line 255
;254:
;255:	AngleVectors( cg.refdefViewAngles, forward, right, up );
ADDRGP4 cg+109412
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 128
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 257
;256:
;257:	forwardScale = cos( cg_thirdPersonAngle.value / 180 * M_PI );
CNSTF4 1078530011
ADDRGP4 cg_thirdPersonAngle+8
INDIRF4
CNSTF4 1127481344
DIVF4
MULF4
ARGF4
ADDRLP4 156
ADDRGP4 cos
CALLF4
ASGNF4
ADDRLP4 60
ADDRLP4 156
INDIRF4
ASGNF4
line 258
;258:	sideScale = sin( cg_thirdPersonAngle.value / 180 * M_PI );
CNSTF4 1078530011
ADDRGP4 cg_thirdPersonAngle+8
INDIRF4
CNSTF4 1127481344
DIVF4
MULF4
ARGF4
ADDRLP4 160
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 64
ADDRLP4 160
INDIRF4
ASGNF4
line 259
;259:	VectorMA( view, -cg_thirdPersonRange.value * forwardScale, forward, view );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 24
INDIRF4
ADDRGP4 cg_thirdPersonRange+8
INDIRF4
NEGF4
ADDRLP4 60
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 24+4
INDIRF4
ADDRGP4 cg_thirdPersonRange+8
INDIRF4
NEGF4
ADDRLP4 60
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 24+8
INDIRF4
ADDRGP4 cg_thirdPersonRange+8
INDIRF4
NEGF4
ADDRLP4 60
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 260
;260:	VectorMA( view, -cg_thirdPersonRange.value * sideScale, right, view );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 36
INDIRF4
ADDRGP4 cg_thirdPersonRange+8
INDIRF4
NEGF4
ADDRLP4 64
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 36+4
INDIRF4
ADDRGP4 cg_thirdPersonRange+8
INDIRF4
NEGF4
ADDRLP4 64
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 36+8
INDIRF4
ADDRGP4 cg_thirdPersonRange+8
INDIRF4
NEGF4
ADDRLP4 64
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 265
;261:
;262:	// trace a ray from the origin to the viewpoint to make sure the view isn't
;263:	// in a solid block.  Use an 8 by 8 block to prevent the view from near clipping anything
;264:
;265:	if (!cg_cameraMode.integer) {
ADDRGP4 cg_cameraMode+12
INDIRI4
CNSTI4 0
NEI4 $312
line 266
;266:		CG_Trace( &trace, cg.refdef.vieworg, mins, maxs, view, cg.predictedPlayerState.clientNum, MASK_SOLID );
ADDRLP4 72
ARGP4
ADDRGP4 cg+109044+24
ARGP4
ADDRGP4 $252
ARGP4
ADDRGP4 $253
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cg+107636+140
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 CG_Trace
CALLV
pop
line 268
;267:
;268:		if ( trace.fraction != 1.0 ) {
ADDRLP4 72+8
INDIRF4
CNSTF4 1065353216
EQF4 $319
line 269
;269:			VectorCopy( trace.endpos, view );
ADDRLP4 0
ADDRLP4 72+12
INDIRB
ASGNB 12
line 270
;270:			view[2] += (1.0 - trace.fraction) * 32;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1107296256
CNSTF4 1065353216
ADDRLP4 72+8
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 274
;271:			// try another trace to this position, because a tunnel may have the ceiling
;272:			// close enogh that this is poking out
;273:
;274:			CG_Trace( &trace, cg.refdef.vieworg, mins, maxs, view, cg.predictedPlayerState.clientNum, MASK_SOLID );
ADDRLP4 72
ARGP4
ADDRGP4 cg+109044+24
ARGP4
ADDRGP4 $252
ARGP4
ADDRGP4 $253
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 cg+107636+140
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 CG_Trace
CALLV
pop
line 275
;275:			VectorCopy( trace.endpos, view );
ADDRLP4 0
ADDRLP4 72+12
INDIRB
ASGNB 12
line 276
;276:		}
LABELV $319
line 277
;277:	}
LABELV $312
line 280
;278:
;279:
;280:	VectorCopy( view, cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRLP4 0
INDIRB
ASGNB 12
line 283
;281:
;282:	// select pitch to look at focus point from vieword
;283:	VectorSubtract( focusPoint, cg.refdef.vieworg, focusPoint );
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRGP4 cg+109044+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
ADDRGP4 cg+109044+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
ADDRGP4 cg+109044+24+8
INDIRF4
SUBF4
ASGNF4
line 284
;284:	focusDist = sqrt( focusPoint[0] * focusPoint[0] + focusPoint[1] * focusPoint[1] );
ADDRLP4 172
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 172
INDIRF4
ADDRLP4 172
INDIRF4
MULF4
ADDRLP4 12+4
INDIRF4
ADDRLP4 12+4
INDIRF4
MULF4
ADDF4
ARGF4
ADDRLP4 176
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRLP4 68
ADDRLP4 176
INDIRF4
ASGNF4
line 285
;285:	if ( focusDist < 1 ) {
ADDRLP4 68
INDIRF4
CNSTF4 1065353216
GEF4 $346
line 286
;286:		focusDist = 1;	// should never happen
ADDRLP4 68
CNSTF4 1065353216
ASGNF4
line 287
;287:	}
LABELV $346
line 288
;288:	cg.refdefViewAngles[PITCH] = -180 / M_PI * atan2( focusPoint[2], focusDist );
ADDRLP4 12+8
INDIRF4
ARGF4
ADDRLP4 68
INDIRF4
ARGF4
ADDRLP4 180
ADDRGP4 atan2
CALLF4
ASGNF4
ADDRGP4 cg+109412
CNSTF4 3261411041
ADDRLP4 180
INDIRF4
MULF4
ASGNF4
line 289
;289:	cg.refdefViewAngles[YAW] -= cg_thirdPersonAngle.value;
ADDRLP4 184
ADDRGP4 cg+109412+4
ASGNP4
ADDRLP4 184
INDIRP4
ADDRLP4 184
INDIRP4
INDIRF4
ADDRGP4 cg_thirdPersonAngle+8
INDIRF4
SUBF4
ASGNF4
line 290
;290:}
LABELV $251
endproc CG_OffsetThirdPersonView 188 28
proc CG_StepOffset 8 0
line 294
;291:
;292:
;293:// this causes a compiler bug on mac MrC compiler
;294:static void CG_StepOffset( void ) {
line 298
;295:	int		timeDelta;
;296:	
;297:	// smooth out stair climbing
;298:	timeDelta = cg.time - cg.stepTime;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+108924
INDIRI4
SUBI4
ASGNI4
line 299
;299:	if ( timeDelta < STEP_TIME ) {
ADDRLP4 0
INDIRI4
CNSTI4 200
GEI4 $356
line 300
;300:		cg.refdef.vieworg[2] -= cg.stepChange 
ADDRLP4 4
ADDRGP4 cg+109044+24+8
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRF4
ADDRGP4 cg+108920
INDIRF4
CNSTI4 200
ADDRLP4 0
INDIRI4
SUBI4
CVIF4 4
MULF4
CNSTF4 1128792064
DIVF4
SUBF4
ASGNF4
line 302
;301:			* (STEP_TIME - timeDelta) / STEP_TIME;
;302:	}
LABELV $356
line 303
;303:}
LABELV $353
endproc CG_StepOffset 8 0
proc CG_OffsetFirstPersonView 96 0
line 311
;304:
;305:/*
;306:===============
;307:CG_OffsetFirstPersonView
;308:
;309:===============
;310:*/
;311:static void CG_OffsetFirstPersonView( void ) {
line 322
;312:	float			*origin;
;313:	float			*angles;
;314:	float			bob;
;315:	float			ratio;
;316:	float			delta;
;317:	float			speed;
;318:	float			f;
;319:	vec3_t			predictedVelocity;
;320:	int				timeDelta;
;321:	
;322:	if ( cg.snap->ps.pm_type == PM_INTERMISSION ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 5
NEI4 $363
line 323
;323:		return;
ADDRGP4 $362
JUMPV
LABELV $363
line 326
;324:	}
;325:
;326:	origin = cg.refdef.vieworg;
ADDRLP4 8
ADDRGP4 cg+109044+24
ASGNP4
line 327
;327:	angles = cg.refdefViewAngles;
ADDRLP4 4
ADDRGP4 cg+109412
ASGNP4
line 330
;328:
;329:	// if dead, fix the angle and don't add any kick
;330:	if ( cg.snap->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
CNSTI4 0
GTI4 $369
line 331
;331:		angles[ROLL] = 40;
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
CNSTF4 1109393408
ASGNF4
line 332
;332:		angles[PITCH] = -15;
ADDRLP4 4
INDIRP4
CNSTF4 3245342720
ASGNF4
line 333
;333:		angles[YAW] = cg.snap->ps.stats[STAT_DEAD_YAW];
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 244
ADDP4
INDIRI4
CVIF4 4
ASGNF4
line 334
;334:		origin[2] += cg.predictedPlayerState.viewheight;
ADDRLP4 44
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRF4
ADDRGP4 cg+107636+164
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 335
;335:		return;
ADDRGP4 $362
JUMPV
LABELV $369
line 339
;336:	}
;337:
;338:	// add angles based on weapon kick
;339:	VectorAdd (angles, cg.kick_angles, angles);
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRF4
ADDRGP4 cg+124744
INDIRF4
ADDF4
ASGNF4
ADDRLP4 48
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRF4
ADDRGP4 cg+124744+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 52
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 52
INDIRP4
ADDRLP4 52
INDIRP4
INDIRF4
ADDRGP4 cg+124744+8
INDIRF4
ADDF4
ASGNF4
line 342
;340:
;341:	// add angles based on damage kick
;342:	if ( cg.damageTime ) {
ADDRGP4 cg+124688
INDIRF4
CNSTF4 0
EQF4 $380
line 343
;343:		ratio = cg.time - cg.damageTime;
ADDRLP4 32
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124688
INDIRF4
SUBF4
ASGNF4
line 344
;344:		if ( ratio < DAMAGE_DEFLECT_TIME ) {
ADDRLP4 32
INDIRF4
CNSTF4 1120403456
GEF4 $385
line 345
;345:			ratio /= DAMAGE_DEFLECT_TIME;
ADDRLP4 32
ADDRLP4 32
INDIRF4
CNSTF4 1120403456
DIVF4
ASGNF4
line 346
;346:			angles[PITCH] += ratio * cg.v_dmg_pitch;
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRF4
ADDRLP4 32
INDIRF4
ADDRGP4 cg+124736
INDIRF4
MULF4
ADDF4
ASGNF4
line 347
;347:			angles[ROLL] += ratio * cg.v_dmg_roll;
ADDRLP4 60
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
ADDRLP4 32
INDIRF4
ADDRGP4 cg+124740
INDIRF4
MULF4
ADDF4
ASGNF4
line 348
;348:		} else {
ADDRGP4 $386
JUMPV
LABELV $385
line 349
;349:			ratio = 1.0 - ( ratio - DAMAGE_DEFLECT_TIME ) / DAMAGE_RETURN_TIME;
ADDRLP4 32
CNSTF4 1065353216
ADDRLP4 32
INDIRF4
CNSTF4 1120403456
SUBF4
CNSTF4 1137180672
DIVF4
SUBF4
ASGNF4
line 350
;350:			if ( ratio > 0 ) {
ADDRLP4 32
INDIRF4
CNSTF4 0
LEF4 $389
line 351
;351:				angles[PITCH] += ratio * cg.v_dmg_pitch;
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRF4
ADDRLP4 32
INDIRF4
ADDRGP4 cg+124736
INDIRF4
MULF4
ADDF4
ASGNF4
line 352
;352:				angles[ROLL] += ratio * cg.v_dmg_roll;
ADDRLP4 60
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
ADDRLP4 32
INDIRF4
ADDRGP4 cg+124740
INDIRF4
MULF4
ADDF4
ASGNF4
line 353
;353:			}
LABELV $389
line 354
;354:		}
LABELV $386
line 355
;355:	}
LABELV $380
line 366
;356:
;357:	// add pitch based on fall kick
;358:#if 0
;359:	ratio = ( cg.time - cg.landTime) / FALL_TIME;
;360:	if (ratio < 0)
;361:		ratio = 0;
;362:	angles[PITCH] += ratio * cg.fall_value;
;363:#endif
;364:
;365:	// add angles based on velocity
;366:	VectorCopy( cg.predictedPlayerState.velocity, predictedVelocity );
ADDRLP4 12
ADDRGP4 cg+107636+32
INDIRB
ASGNB 12
line 368
;367:
;368:	delta = DotProduct ( predictedVelocity, cg.refdef.viewaxis[0]);
ADDRLP4 0
ADDRLP4 12
INDIRF4
ADDRGP4 cg+109044+36
INDIRF4
MULF4
ADDRLP4 12+4
INDIRF4
ADDRGP4 cg+109044+36+4
INDIRF4
MULF4
ADDF4
ADDRLP4 12+8
INDIRF4
ADDRGP4 cg+109044+36+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 369
;369:	angles[PITCH] += delta * cg_runpitch.value;
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDRGP4 cg_runpitch+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 371
;370:	
;371:	delta = DotProduct ( predictedVelocity, cg.refdef.viewaxis[1]);
ADDRLP4 0
ADDRLP4 12
INDIRF4
ADDRGP4 cg+109044+36+12
INDIRF4
MULF4
ADDRLP4 12+4
INDIRF4
ADDRGP4 cg+109044+36+12+4
INDIRF4
MULF4
ADDF4
ADDRLP4 12+8
INDIRF4
ADDRGP4 cg+109044+36+12+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 372
;372:	angles[ROLL] -= delta * cg_runroll.value;
ADDRLP4 60
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDRGP4 cg_runroll+8
INDIRF4
MULF4
SUBF4
ASGNF4
line 377
;373:
;374:	// add angles based on bob
;375:
;376:	// make sure the bob is visible even at low speeds
;377:	speed = cg.xyspeed > 200 ? cg.xyspeed : 200;
ADDRGP4 cg+124776
INDIRF4
CNSTF4 1128792064
LEF4 $423
ADDRLP4 64
ADDRGP4 cg+124776
INDIRF4
ASGNF4
ADDRGP4 $424
JUMPV
LABELV $423
ADDRLP4 64
CNSTF4 1128792064
ASGNF4
LABELV $424
ADDRLP4 28
ADDRLP4 64
INDIRF4
ASGNF4
line 379
;378:
;379:	delta = cg.bobfracsin * cg_bobpitch.value * speed;
ADDRLP4 0
ADDRGP4 cg+124768
INDIRF4
ADDRGP4 cg_bobpitch+8
INDIRF4
MULF4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 380
;380:	if (cg.predictedPlayerState.pm_flags & PMF_DUCKED)
ADDRGP4 cg+107636+12
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $427
line 381
;381:		delta *= 3;		// crouching
ADDRLP4 0
CNSTF4 1077936128
ADDRLP4 0
INDIRF4
MULF4
ASGNF4
LABELV $427
line 382
;382:	angles[PITCH] += delta;
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDF4
ASGNF4
line 383
;383:	delta = cg.bobfracsin * cg_bobroll.value * speed;
ADDRLP4 0
ADDRGP4 cg+124768
INDIRF4
ADDRGP4 cg_bobroll+8
INDIRF4
MULF4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 384
;384:	if (cg.predictedPlayerState.pm_flags & PMF_DUCKED)
ADDRGP4 cg+107636+12
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $433
line 385
;385:		delta *= 3;		// crouching accentuates roll
ADDRLP4 0
CNSTF4 1077936128
ADDRLP4 0
INDIRF4
MULF4
ASGNF4
LABELV $433
line 386
;386:	if (cg.bobcycle & 1)
ADDRGP4 cg+124772
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $437
line 387
;387:		delta = -delta;
ADDRLP4 0
ADDRLP4 0
INDIRF4
NEGF4
ASGNF4
LABELV $437
line 388
;388:	angles[ROLL] += delta;
ADDRLP4 72
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 72
INDIRP4
ADDRLP4 72
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDF4
ASGNF4
line 393
;389:
;390://===================================
;391:
;392:	// add view height
;393:	origin[2] += cg.predictedPlayerState.viewheight;
ADDRLP4 76
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 76
INDIRP4
ADDRLP4 76
INDIRP4
INDIRF4
ADDRGP4 cg+107636+164
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 396
;394:
;395:	// smooth out duck height changes
;396:	timeDelta = cg.time - cg.duckTime;
ADDRLP4 36
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+108932
INDIRI4
SUBI4
ASGNI4
line 397
;397:	if ( timeDelta < DUCK_TIME) {
ADDRLP4 36
INDIRI4
CNSTI4 100
GEI4 $444
line 398
;398:		cg.refdef.vieworg[2] -= cg.duckChange 
ADDRLP4 80
ADDRGP4 cg+109044+24+8
ASGNP4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRF4
ADDRGP4 cg+108928
INDIRF4
CNSTI4 100
ADDRLP4 36
INDIRI4
SUBI4
CVIF4 4
MULF4
CNSTF4 1120403456
DIVF4
SUBF4
ASGNF4
line 400
;399:			* (DUCK_TIME - timeDelta) / DUCK_TIME;
;400:	}
LABELV $444
line 403
;401:
;402:	// add bob height
;403:	bob = cg.bobfracsin * cg.xyspeed * cg_bobup.value;
ADDRLP4 24
ADDRGP4 cg+124768
INDIRF4
ADDRGP4 cg+124776
INDIRF4
MULF4
ADDRGP4 cg_bobup+8
INDIRF4
MULF4
ASGNF4
line 404
;404:	if (bob > 6) {
ADDRLP4 24
INDIRF4
CNSTF4 1086324736
LEF4 $453
line 405
;405:		bob = 6;
ADDRLP4 24
CNSTF4 1086324736
ASGNF4
line 406
;406:	}
LABELV $453
line 408
;407:
;408:	origin[2] += bob;
ADDRLP4 80
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 80
INDIRP4
ADDRLP4 80
INDIRP4
INDIRF4
ADDRLP4 24
INDIRF4
ADDF4
ASGNF4
line 412
;409:
;410:
;411:	// add fall height
;412:	delta = cg.time - cg.landTime;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+108940
INDIRI4
SUBI4
CVIF4 4
ASGNF4
line 413
;413:	if ( delta < LAND_DEFLECT_TIME ) {
ADDRLP4 0
INDIRF4
CNSTF4 1125515264
GEF4 $457
line 414
;414:		f = delta / LAND_DEFLECT_TIME;
ADDRLP4 40
ADDRLP4 0
INDIRF4
CNSTF4 1125515264
DIVF4
ASGNF4
line 415
;415:		cg.refdef.vieworg[2] += cg.landChange * f;
ADDRLP4 84
ADDRGP4 cg+109044+24+8
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRF4
ADDRGP4 cg+108936
INDIRF4
ADDRLP4 40
INDIRF4
MULF4
ADDF4
ASGNF4
line 416
;416:	} else if ( delta < LAND_DEFLECT_TIME + LAND_RETURN_TIME ) {
ADDRGP4 $458
JUMPV
LABELV $457
ADDRLP4 0
INDIRF4
CNSTF4 1138819072
GEF4 $463
line 417
;417:		delta -= LAND_DEFLECT_TIME;
ADDRLP4 0
ADDRLP4 0
INDIRF4
CNSTF4 1125515264
SUBF4
ASGNF4
line 418
;418:		f = 1.0 - ( delta / LAND_RETURN_TIME );
ADDRLP4 40
CNSTF4 1065353216
ADDRLP4 0
INDIRF4
CNSTF4 1133903872
DIVF4
SUBF4
ASGNF4
line 419
;419:		cg.refdef.vieworg[2] += cg.landChange * f;
ADDRLP4 84
ADDRGP4 cg+109044+24+8
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRF4
ADDRGP4 cg+108936
INDIRF4
ADDRLP4 40
INDIRF4
MULF4
ADDF4
ASGNF4
line 420
;420:	}
LABELV $463
LABELV $458
line 423
;421:
;422:	// add step offset
;423:	CG_StepOffset();
ADDRGP4 CG_StepOffset
CALLV
pop
line 427
;424:
;425:	// add kick offset
;426:
;427:	VectorAdd (origin, cg.kick_origin, origin);
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
ADDRGP4 cg+124756
INDIRF4
ADDF4
ASGNF4
ADDRLP4 88
ADDRLP4 8
INDIRP4
CNSTI4 4
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRF4
ADDRGP4 cg+124756+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 92
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRF4
ADDRGP4 cg+124756+8
INDIRF4
ADDF4
ASGNF4
line 441
;428:
;429:	// pivot the eye based on a neck length
;430:#if 0
;431:	{
;432:#define	NECK_LENGTH		8
;433:	vec3_t			forward, up;
;434: 
;435:	cg.refdef.vieworg[2] -= NECK_LENGTH;
;436:	AngleVectors( cg.refdefViewAngles, forward, NULL, up );
;437:	VectorMA( cg.refdef.vieworg, 3, forward, cg.refdef.vieworg );
;438:	VectorMA( cg.refdef.vieworg, NECK_LENGTH, up, cg.refdef.vieworg );
;439:	}
;440:#endif
;441:}
LABELV $362
endproc CG_OffsetFirstPersonView 96 0
export CG_ZoomDown_f
proc CG_ZoomDown_f 0 0
line 445
;442:
;443://======================================================================
;444:
;445:void CG_ZoomDown_f( void ) { 
line 446
;446:	if ( cg.zoomed ) {
ADDRGP4 cg+109424
INDIRI4
CNSTI4 0
EQI4 $475
line 447
;447:		return;
ADDRGP4 $474
JUMPV
LABELV $475
line 449
;448:	}
;449:	cg.zoomed = qtrue;
ADDRGP4 cg+109424
CNSTI4 1
ASGNI4
line 450
;450:	cg.zoomTime = cg.time;
ADDRGP4 cg+109428
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 451
;451:}
LABELV $474
endproc CG_ZoomDown_f 0 0
export CG_ZoomUp_f
proc CG_ZoomUp_f 0 0
line 453
;452:
;453:void CG_ZoomUp_f( void ) { 
line 454
;454:	if ( !cg.zoomed ) {
ADDRGP4 cg+109424
INDIRI4
CNSTI4 0
NEI4 $482
line 455
;455:		return;
ADDRGP4 $481
JUMPV
LABELV $482
line 457
;456:	}
;457:	cg.zoomed = qfalse;
ADDRGP4 cg+109424
CNSTI4 0
ASGNI4
line 458
;458:	cg.zoomTime = cg.time;
ADDRGP4 cg+109428
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 459
;459:}
LABELV $481
endproc CG_ZoomUp_f 0 0
proc CG_CalcFov 52 8
line 472
;460:
;461:
;462:/*
;463:====================
;464:CG_CalcFov
;465:
;466:Fixed fov at intermissions, otherwise account for fov variable and zooms.
;467:====================
;468:*/
;469:#define	WAVE_AMPLITUDE	1
;470:#define	WAVE_FREQUENCY	0.4
;471:
;472:static int CG_CalcFov( void ) {
line 482
;473:	float	x;
;474:	float	phase;
;475:	float	v;
;476:	int		contents;
;477:	float	fov_x, fov_y;
;478:	float	zoomFov;
;479:	float	f;
;480:	int		inwater;
;481:
;482:	if ( cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
ADDRGP4 cg+107636+4
INDIRI4
CNSTI4 5
NEI4 $489
line 484
;483:		// if in intermission, use a fixed value
;484:		fov_x = 90;
ADDRLP4 0
CNSTF4 1119092736
ASGNF4
line 485
;485:	} else {
ADDRGP4 $490
JUMPV
LABELV $489
line 487
;486:		// user selectable
;487:		if ( cgs.dmflags & DF_FIXED_FOV ) {
ADDRGP4 cgs+31460
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $493
line 489
;488:			// dmflag to prevent wide fov for all clients
;489:			fov_x = 90;
ADDRLP4 0
CNSTF4 1119092736
ASGNF4
line 490
;490:		} else {
ADDRGP4 $494
JUMPV
LABELV $493
line 491
;491:			fov_x = cg_fov.value;
ADDRLP4 0
ADDRGP4 cg_fov+8
INDIRF4
ASGNF4
line 492
;492:			if ( fov_x < 1 ) {
ADDRLP4 0
INDIRF4
CNSTF4 1065353216
GEF4 $497
line 493
;493:				fov_x = 1;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 494
;494:			} else if ( fov_x > 160 ) {
ADDRGP4 $498
JUMPV
LABELV $497
ADDRLP4 0
INDIRF4
CNSTF4 1126170624
LEF4 $499
line 495
;495:				fov_x = 160;
ADDRLP4 0
CNSTF4 1126170624
ASGNF4
line 496
;496:			}
LABELV $499
LABELV $498
line 497
;497:		}
LABELV $494
line 500
;498:
;499:		// account for zooms
;500:		zoomFov = cg_zoomFov.value;
ADDRLP4 8
ADDRGP4 cg_zoomFov+8
INDIRF4
ASGNF4
line 501
;501:		if ( zoomFov < 1 ) {
ADDRLP4 8
INDIRF4
CNSTF4 1065353216
GEF4 $502
line 502
;502:			zoomFov = 1;
ADDRLP4 8
CNSTF4 1065353216
ASGNF4
line 503
;503:		} else if ( zoomFov > 160 ) {
ADDRGP4 $503
JUMPV
LABELV $502
ADDRLP4 8
INDIRF4
CNSTF4 1126170624
LEF4 $504
line 504
;504:			zoomFov = 160;
ADDRLP4 8
CNSTF4 1126170624
ASGNF4
line 505
;505:		}
LABELV $504
LABELV $503
line 507
;506:
;507:		if ( cg.zoomed ) {
ADDRGP4 cg+109424
INDIRI4
CNSTI4 0
EQI4 $506
line 508
;508:			f = ( cg.time - cg.zoomTime ) / (float)ZOOM_TIME;
ADDRLP4 28
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+109428
INDIRI4
SUBI4
CVIF4 4
CNSTF4 1125515264
DIVF4
ASGNF4
line 509
;509:			if ( f > 1.0 ) {
ADDRLP4 28
INDIRF4
CNSTF4 1065353216
LEF4 $511
line 510
;510:				fov_x = zoomFov;
ADDRLP4 0
ADDRLP4 8
INDIRF4
ASGNF4
line 511
;511:			} else {
ADDRGP4 $507
JUMPV
LABELV $511
line 512
;512:				fov_x = fov_x + f * ( zoomFov - fov_x );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 28
INDIRF4
ADDRLP4 8
INDIRF4
ADDRLP4 0
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 513
;513:			}
line 514
;514:		} else {
ADDRGP4 $507
JUMPV
LABELV $506
line 515
;515:			f = ( cg.time - cg.zoomTime ) / (float)ZOOM_TIME;
ADDRLP4 28
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+109428
INDIRI4
SUBI4
CVIF4 4
CNSTF4 1125515264
DIVF4
ASGNF4
line 516
;516:			if ( f > 1.0 ) {
ADDRLP4 28
INDIRF4
CNSTF4 1065353216
LEF4 $515
line 517
;517:				fov_x = fov_x;
ADDRLP4 0
ADDRLP4 0
INDIRF4
ASGNF4
line 518
;518:			} else {
ADDRGP4 $516
JUMPV
LABELV $515
line 519
;519:				fov_x = zoomFov + f * ( fov_x - zoomFov );
ADDRLP4 36
ADDRLP4 8
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 36
INDIRF4
ADDRLP4 28
INDIRF4
ADDRLP4 0
INDIRF4
ADDRLP4 36
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 520
;520:			}
LABELV $516
line 521
;521:		}
LABELV $507
line 522
;522:	}
LABELV $490
line 524
;523:
;524:	x = cg.refdef.width / tan( fov_x / 360 * M_PI );
CNSTF4 1078530011
ADDRLP4 0
INDIRF4
CNSTF4 1135869952
DIVF4
MULF4
ARGF4
ADDRLP4 36
ADDRGP4 tan
CALLF4
ASGNF4
ADDRLP4 12
ADDRGP4 cg+109044+8
INDIRI4
CVIF4 4
ADDRLP4 36
INDIRF4
DIVF4
ASGNF4
line 525
;525:	fov_y = atan2( cg.refdef.height, x );
ADDRGP4 cg+109044+12
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 40
ADDRGP4 atan2
CALLF4
ASGNF4
ADDRLP4 4
ADDRLP4 40
INDIRF4
ASGNF4
line 526
;526:	fov_y = fov_y * 360 / M_PI;
ADDRLP4 4
CNSTF4 1135869952
ADDRLP4 4
INDIRF4
MULF4
CNSTF4 1078530011
DIVF4
ASGNF4
line 529
;527:
;528:	// warp if underwater
;529:	contents = CG_PointContents( cg.refdef.vieworg, -1 );
ADDRGP4 cg+109044+24
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 44
ADDRGP4 CG_PointContents
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 44
INDIRI4
ASGNI4
line 530
;530:	if ( contents & ( CONTENTS_WATER | CONTENTS_SLIME | CONTENTS_LAVA ) ){
ADDRLP4 16
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $523
line 531
;531:		phase = cg.time / 1000.0 * WAVE_FREQUENCY * M_PI * 2;
ADDRLP4 32
CNSTF4 1073741824
CNSTF4 1078530011
CNSTF4 1053609165
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
MULF4
MULF4
MULF4
ASGNF4
line 532
;532:		v = WAVE_AMPLITUDE * sin( phase );
ADDRLP4 32
INDIRF4
ARGF4
ADDRLP4 48
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 24
CNSTF4 1065353216
ADDRLP4 48
INDIRF4
MULF4
ASGNF4
line 533
;533:		fov_x += v;
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 24
INDIRF4
ADDF4
ASGNF4
line 534
;534:		fov_y -= v;
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 24
INDIRF4
SUBF4
ASGNF4
line 535
;535:		inwater = qtrue;
ADDRLP4 20
CNSTI4 1
ASGNI4
line 536
;536:	}
ADDRGP4 $524
JUMPV
LABELV $523
line 537
;537:	else {
line 538
;538:		inwater = qfalse;
ADDRLP4 20
CNSTI4 0
ASGNI4
line 539
;539:	}
LABELV $524
line 543
;540:
;541:
;542:	// set it
;543:	cg.refdef.fov_x = fov_x;
ADDRGP4 cg+109044+16
ADDRLP4 0
INDIRF4
ASGNF4
line 544
;544:	cg.refdef.fov_y = fov_y;
ADDRGP4 cg+109044+20
ADDRLP4 4
INDIRF4
ASGNF4
line 546
;545:
;546:	if ( !cg.zoomed ) {
ADDRGP4 cg+109424
INDIRI4
CNSTI4 0
NEI4 $530
line 547
;547:		cg.zoomSensitivity = 1;
ADDRGP4 cg+109432
CNSTF4 1065353216
ASGNF4
line 548
;548:	} else {
ADDRGP4 $531
JUMPV
LABELV $530
line 549
;549:		cg.zoomSensitivity = cg.refdef.fov_y / 75.0;
ADDRGP4 cg+109432
ADDRGP4 cg+109044+20
INDIRF4
CNSTF4 1117126656
DIVF4
ASGNF4
line 550
;550:	}
LABELV $531
line 552
;551:
;552:	return inwater;
ADDRLP4 20
INDIRI4
RETI4
LABELV $488
endproc CG_CalcFov 52 8
proc CG_DamageBlendBlob 164 12
line 563
;553:}
;554:
;555:
;556:
;557:/*
;558:===============
;559:CG_DamageBlendBlob
;560:
;561:===============
;562:*/
;563:static void CG_DamageBlendBlob( void ) {
line 568
;564:	int			t;
;565:	int			maxTime;
;566:	refEntity_t		ent;
;567:
;568:	if ( !cg.damageValue ) {
ADDRGP4 cg+124700
INDIRF4
CNSTF4 0
NEF4 $538
line 569
;569:		return;
ADDRGP4 $537
JUMPV
LABELV $538
line 577
;570:	}
;571:
;572:	//if (cg.cameraMode) {
;573:	//	return;
;574:	//}
;575:
;576:	// ragePro systems can't fade blends, so don't obscure the screen
;577:	if ( cgs.glconfig.hardwareType == GLHW_RAGEPRO ) {
ADDRGP4 cgs+20100+11288
INDIRI4
CNSTI4 3
NEI4 $541
line 578
;578:		return;
ADDRGP4 $537
JUMPV
LABELV $541
line 581
;579:	}
;580:
;581:	maxTime = DAMAGE_TIME;
ADDRLP4 144
CNSTI4 500
ASGNI4
line 582
;582:	t = cg.time - cg.damageTime;
ADDRLP4 140
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124688
INDIRF4
SUBF4
CVFI4 4
ASGNI4
line 583
;583:	if ( t <= 0 || t >= maxTime ) {
ADDRLP4 140
INDIRI4
CNSTI4 0
LEI4 $549
ADDRLP4 140
INDIRI4
ADDRLP4 144
INDIRI4
LTI4 $547
LABELV $549
line 584
;584:		return;
ADDRGP4 $537
JUMPV
LABELV $547
line 588
;585:	}
;586:
;587:
;588:	memset( &ent, 0, sizeof( ent ) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 589
;589:	ent.reType = RT_SPRITE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 590
;590:	ent.renderfx = RF_FIRST_PERSON;
ADDRLP4 0+4
CNSTI4 4
ASGNI4
line 592
;591:
;592:	VectorMA( cg.refdef.vieworg, 8, cg.refdef.viewaxis[0], ent.origin );
ADDRLP4 0+68
ADDRGP4 cg+109044+24
INDIRF4
CNSTF4 1090519040
ADDRGP4 cg+109044+36
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+4
ADDRGP4 cg+109044+24+4
INDIRF4
CNSTF4 1090519040
ADDRGP4 cg+109044+36+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+8
ADDRGP4 cg+109044+24+8
INDIRF4
CNSTF4 1090519040
ADDRGP4 cg+109044+36+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 593
;593:	VectorMA( ent.origin, cg.damageX * -8, cg.refdef.viewaxis[1], ent.origin );
ADDRLP4 0+68
ADDRLP4 0+68
INDIRF4
ADDRGP4 cg+109044+36+12
INDIRF4
CNSTF4 3238002688
ADDRGP4 cg+124692
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+4
ADDRLP4 0+68+4
INDIRF4
ADDRGP4 cg+109044+36+12+4
INDIRF4
CNSTF4 3238002688
ADDRGP4 cg+124692
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
ADDRGP4 cg+109044+36+12+8
INDIRF4
CNSTF4 3238002688
ADDRGP4 cg+124692
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 594
;594:	VectorMA( ent.origin, cg.damageY * 8, cg.refdef.viewaxis[2], ent.origin );
ADDRLP4 0+68
ADDRLP4 0+68
INDIRF4
ADDRGP4 cg+109044+36+24
INDIRF4
CNSTF4 1090519040
ADDRGP4 cg+124696
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+4
ADDRLP4 0+68+4
INDIRF4
ADDRGP4 cg+109044+36+24+4
INDIRF4
CNSTF4 1090519040
ADDRGP4 cg+124696
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+68+8
ADDRLP4 0+68+8
INDIRF4
ADDRGP4 cg+109044+36+24+8
INDIRF4
CNSTF4 1090519040
ADDRGP4 cg+124696
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 596
;595:
;596:	ent.radius = cg.damageValue * 3;
ADDRLP4 0+132
CNSTF4 1077936128
ADDRGP4 cg+124700
INDIRF4
MULF4
ASGNF4
line 597
;597:	ent.customShader = cgs.media.viewBloodShader;
ADDRLP4 0+112
ADDRGP4 cgs+152340+216
INDIRI4
ASGNI4
line 598
;598:	ent.shaderRGBA[0] = 255;
ADDRLP4 0+116
CNSTU1 255
ASGNU1
line 599
;599:	ent.shaderRGBA[1] = 255;
ADDRLP4 0+116+1
CNSTU1 255
ASGNU1
line 600
;600:	ent.shaderRGBA[2] = 255;
ADDRLP4 0+116+2
CNSTU1 255
ASGNU1
line 601
;601:	ent.shaderRGBA[3] = 200 * ( 1.0 - ((float)t / maxTime) );
ADDRLP4 156
CNSTF4 1128792064
CNSTF4 1065353216
ADDRLP4 140
INDIRI4
CVIF4 4
ADDRLP4 144
INDIRI4
CVIF4 4
DIVF4
SUBF4
MULF4
ASGNF4
ADDRLP4 160
CNSTF4 1325400064
ASGNF4
ADDRLP4 156
INDIRF4
ADDRLP4 160
INDIRF4
LTF4 $633
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
ADDRGP4 $634
JUMPV
LABELV $633
ADDRLP4 152
ADDRLP4 156
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $634
ADDRLP4 0+116+3
ADDRLP4 152
INDIRU4
CVUU1 4
ASGNU1
line 602
;602:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 603
;603:}
LABELV $537
endproc CG_DamageBlendBlob 164 12
proc CG_CalcViewValues 40 12
line 613
;604:
;605:
;606:/*
;607:===============
;608:CG_CalcViewValues
;609:
;610:Sets cg.refdef view values
;611:===============
;612:*/
;613:static int CG_CalcViewValues( void ) {
line 616
;614:	playerState_t	*ps;
;615:
;616:	memset( &cg.refdef, 0, sizeof( cg.refdef ) );
ADDRGP4 cg+109044
ARGP4
CNSTI4 0
ARGI4
CNSTI4 368
ARGI4
ADDRGP4 memset
CALLP4
pop
line 623
;617:
;618:	// strings for in game rendering
;619:	// Q_strncpyz( cg.refdef.text[0], "Park Ranger", sizeof(cg.refdef.text[0]) );
;620:	// Q_strncpyz( cg.refdef.text[1], "19", sizeof(cg.refdef.text[1]) );
;621:
;622:	// calculate size of 3D view
;623:	CG_CalcVrect();
ADDRGP4 CG_CalcVrect
CALLV
pop
line 625
;624:
;625:	ps = &cg.predictedPlayerState;
ADDRLP4 0
ADDRGP4 cg+107636
ASGNP4
line 641
;626:/*
;627:	if (cg.cameraMode) {
;628:		vec3_t origin, angles;
;629:		if (trap_getCameraInfo(cg.time, &origin, &angles)) {
;630:			VectorCopy(origin, cg.refdef.vieworg);
;631:			angles[ROLL] = 0;
;632:			VectorCopy(angles, cg.refdefViewAngles);
;633:			AnglesToAxis( cg.refdefViewAngles, cg.refdef.viewaxis );
;634:			return CG_CalcFov();
;635:		} else {
;636:			cg.cameraMode = qfalse;
;637:		}
;638:	}
;639:*/
;640:	// intermission view
;641:	if ( ps->pm_type == PM_INTERMISSION ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 5
NEI4 $639
line 642
;642:		VectorCopy( ps->origin, cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 643
;643:		VectorCopy( ps->viewangles, cg.refdefViewAngles );
ADDRGP4 cg+109412
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
INDIRB
ASGNB 12
line 644
;644:		AnglesToAxis( cg.refdefViewAngles, cg.refdef.viewaxis );
ADDRGP4 cg+109412
ARGP4
ADDRGP4 cg+109044+36
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 645
;645:		return CG_CalcFov();
ADDRLP4 4
ADDRGP4 CG_CalcFov
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
RETI4
ADDRGP4 $635
JUMPV
LABELV $639
line 648
;646:	}
;647:
;648:	cg.bobcycle = ( ps->bobCycle & 128 ) >> 7;
ADDRGP4 cg+124772
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 7
RSHI4
ASGNI4
line 649
;649:	cg.bobfracsin = fabs( sin( ( ps->bobCycle & 127 ) / 127.0 * M_PI ) );
CNSTF4 1078530011
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 127
BANDI4
CVIF4 4
CNSTF4 1123942400
DIVF4
MULF4
ARGF4
ADDRLP4 4
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 8
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRGP4 cg+124768
ADDRLP4 8
INDIRF4
ASGNF4
line 650
;650:	cg.xyspeed = sqrt( ps->velocity[0] * ps->velocity[0] +
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ASGNF4
ADDRLP4 20
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRF4
ASGNF4
ADDRLP4 16
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ADDRLP4 20
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ADDF4
ARGF4
ADDRLP4 24
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRGP4 cg+124776
ADDRLP4 24
INDIRF4
ASGNF4
line 654
;651:		ps->velocity[1] * ps->velocity[1] );
;652:
;653:
;654:	VectorCopy( ps->origin, cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 655
;655:	VectorCopy( ps->viewangles, cg.refdefViewAngles );
ADDRGP4 cg+109412
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
INDIRB
ASGNB 12
line 657
;656:
;657:	if (cg_cameraOrbit.integer) {
ADDRGP4 cg_cameraOrbit+12
INDIRI4
CNSTI4 0
EQI4 $653
line 658
;658:		if (cg.time > cg.nextOrbitTime) {
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124780
INDIRI4
LEI4 $656
line 659
;659:			cg.nextOrbitTime = cg.time + cg_cameraOrbitDelay.integer;
ADDRGP4 cg+124780
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg_cameraOrbitDelay+12
INDIRI4
ADDI4
ASGNI4
line 660
;660:			cg_thirdPersonAngle.value += cg_cameraOrbit.value;
ADDRLP4 28
ADDRGP4 cg_thirdPersonAngle+8
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRF4
ADDRGP4 cg_cameraOrbit+8
INDIRF4
ADDF4
ASGNF4
line 661
;661:		}
LABELV $656
line 662
;662:	}
LABELV $653
line 664
;663:	// add error decay
;664:	if ( cg_errorDecay.value > 0 ) {
ADDRGP4 cg_errorDecay+8
INDIRF4
CNSTF4 0
LEF4 $665
line 668
;665:		int		t;
;666:		float	f;
;667:
;668:		t = cg.time - cg.predictedErrorTime;
ADDRLP4 32
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+108836
INDIRI4
SUBI4
ASGNI4
line 669
;669:		f = ( cg_errorDecay.value - t ) / cg_errorDecay.value;
ADDRLP4 28
ADDRGP4 cg_errorDecay+8
INDIRF4
ADDRLP4 32
INDIRI4
CVIF4 4
SUBF4
ADDRGP4 cg_errorDecay+8
INDIRF4
DIVF4
ASGNF4
line 670
;670:		if ( f > 0 && f < 1 ) {
ADDRLP4 36
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
LEF4 $672
ADDRLP4 36
INDIRF4
CNSTF4 1065353216
GEF4 $672
line 671
;671:			VectorMA( cg.refdef.vieworg, f, cg.predictedError, cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRGP4 cg+109044+24
INDIRF4
ADDRGP4 cg+108840
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+109044+24+4
ADDRGP4 cg+109044+24+4
INDIRF4
ADDRGP4 cg+108840+4
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+109044+24+8
ADDRGP4 cg+109044+24+8
INDIRF4
ADDRGP4 cg+108840+8
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ADDF4
ASGNF4
line 672
;672:		} else {
ADDRGP4 $673
JUMPV
LABELV $672
line 673
;673:			cg.predictedErrorTime = 0;
ADDRGP4 cg+108836
CNSTI4 0
ASGNI4
line 674
;674:		}
LABELV $673
line 675
;675:	}
LABELV $665
line 677
;676:
;677:	if ( cg.renderingThirdPerson ) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
EQI4 $696
line 679
;678:		// back away from character
;679:		CG_OffsetThirdPersonView();
ADDRGP4 CG_OffsetThirdPersonView
CALLV
pop
line 680
;680:	} else {
ADDRGP4 $697
JUMPV
LABELV $696
line 682
;681:		// offset for local bobbing and kicks
;682:		CG_OffsetFirstPersonView();
ADDRGP4 CG_OffsetFirstPersonView
CALLV
pop
line 683
;683:	}
LABELV $697
line 686
;684:
;685:	// position eye reletive to origin
;686:	AnglesToAxis( cg.refdefViewAngles, cg.refdef.viewaxis );
ADDRGP4 cg+109412
ARGP4
ADDRGP4 cg+109044+36
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 688
;687:
;688:	if ( cg.hyperspace ) {
ADDRGP4 cg+107632
INDIRI4
CNSTI4 0
EQI4 $702
line 689
;689:		cg.refdef.rdflags |= RDF_NOWORLDMODEL | RDF_HYPERSPACE;
ADDRLP4 28
ADDRGP4 cg+109044+76
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRI4
CNSTI4 5
BORI4
ASGNI4
line 690
;690:	}
LABELV $702
line 693
;691:
;692:	// field of view
;693:	return CG_CalcFov();
ADDRLP4 28
ADDRGP4 CG_CalcFov
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
RETI4
LABELV $635
endproc CG_CalcViewValues 40 12
proc CG_PowerupTimerSounds 16 16
line 702
;694:}
;695:
;696:
;697:/*
;698:=====================
;699:CG_PowerupTimerSounds
;700:=====================
;701:*/
;702:static void CG_PowerupTimerSounds( void ) {
line 707
;703:	int		i;
;704:	int		t;
;705:
;706:	// powerup timers going away
;707:	for ( i = 0 ; i < MAX_POWERUPS ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $708
line 708
;708:		t = cg.snap->ps.powerups[i];
ADDRLP4 0
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 356
ADDP4
ADDP4
INDIRI4
ASGNI4
line 709
;709:		if ( t <= cg.time ) {
ADDRLP4 0
INDIRI4
ADDRGP4 cg+107604
INDIRI4
GTI4 $713
line 710
;710:			continue;
ADDRGP4 $709
JUMPV
LABELV $713
line 712
;711:		}
;712:		if ( t - cg.time >= POWERUP_BLINKS * POWERUP_BLINK_TIME ) {
ADDRLP4 0
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CNSTI4 5000
LTI4 $716
line 713
;713:			continue;
ADDRGP4 $709
JUMPV
LABELV $716
line 715
;714:		}
;715:		if ( ( t - cg.time ) / POWERUP_BLINK_TIME != ( t - cg.oldTime ) / POWERUP_BLINK_TIME ) {
ADDRLP4 12
CNSTI4 1000
ASGNI4
ADDRLP4 0
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
ADDRLP4 12
INDIRI4
DIVI4
ADDRLP4 0
INDIRI4
ADDRGP4 cg+107608
INDIRI4
SUBI4
ADDRLP4 12
INDIRI4
DIVI4
EQI4 $719
line 716
;716:			trap_S_StartSound( NULL, cg.snap->ps.clientNum, CHAN_ITEM, cgs.media.wearOffSound );
CNSTP4 0
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRGP4 cgs+152340+544
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 717
;717:		}
LABELV $719
line 718
;718:	}
LABELV $709
line 707
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 16
LTI4 $708
line 719
;719:}
LABELV $707
endproc CG_PowerupTimerSounds 16 16
export CG_AddBufferedSound
proc CG_AddBufferedSound 4 0
line 726
;720:
;721:/*
;722:=====================
;723:CG_AddBufferedSound
;724:=====================
;725:*/
;726:void CG_AddBufferedSound( sfxHandle_t sfx ) {
line 727
;727:	if ( !sfx )
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $727
line 728
;728:		return;
ADDRGP4 $726
JUMPV
LABELV $727
line 729
;729:	cg.soundBuffer[cg.soundBufferIn] = sfx;
ADDRGP4 cg+124552
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124564
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 730
;730:	cg.soundBufferIn = (cg.soundBufferIn + 1) % MAX_SOUNDBUFFER;
ADDRGP4 cg+124552
ADDRGP4 cg+124552
INDIRI4
CNSTI4 1
ADDI4
CNSTI4 20
MODI4
ASGNI4
line 731
;731:	if (cg.soundBufferIn == cg.soundBufferOut) {
ADDRGP4 cg+124552
INDIRI4
ADDRGP4 cg+124556
INDIRI4
NEI4 $733
line 732
;732:		cg.soundBufferOut++;
ADDRLP4 0
ADDRGP4 cg+124556
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 733
;733:	}
LABELV $733
line 734
;734:}
LABELV $726
endproc CG_AddBufferedSound 4 0
proc CG_PlayBufferedSounds 0 8
line 741
;735:
;736:/*
;737:=====================
;738:CG_PlayBufferedSounds
;739:=====================
;740:*/
;741:static void CG_PlayBufferedSounds( void ) {
line 742
;742:	if ( cg.soundTime < cg.time ) {
ADDRGP4 cg+124560
INDIRI4
ADDRGP4 cg+107604
INDIRI4
GEI4 $739
line 743
;743:		if (cg.soundBufferOut != cg.soundBufferIn && cg.soundBuffer[cg.soundBufferOut]) {
ADDRGP4 cg+124556
INDIRI4
ADDRGP4 cg+124552
INDIRI4
EQI4 $743
ADDRGP4 cg+124556
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124564
ADDP4
INDIRI4
CNSTI4 0
EQI4 $743
line 744
;744:			trap_S_StartLocalSound(cg.soundBuffer[cg.soundBufferOut], CHAN_ANNOUNCER);
ADDRGP4 cg+124556
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124564
ADDP4
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 745
;745:			cg.soundBuffer[cg.soundBufferOut] = 0;
ADDRGP4 cg+124556
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124564
ADDP4
CNSTI4 0
ASGNI4
line 746
;746:			cg.soundBufferOut = (cg.soundBufferOut + 1) % MAX_SOUNDBUFFER;
ADDRGP4 cg+124556
ADDRGP4 cg+124556
INDIRI4
CNSTI4 1
ADDI4
CNSTI4 20
MODI4
ASGNI4
line 747
;747:			cg.soundTime = cg.time + 750;
ADDRGP4 cg+124560
ADDRGP4 cg+107604
INDIRI4
CNSTI4 750
ADDI4
ASGNI4
line 748
;748:		}
LABELV $743
line 749
;749:	}
LABELV $739
line 750
;750:}
LABELV $738
endproc CG_PlayBufferedSounds 0 8
export CG_DrawActiveFrame
proc CG_DrawActiveFrame 24 16
line 761
;751:
;752://=========================================================================
;753:
;754:/*
;755:=================
;756:CG_DrawActiveFrame
;757:
;758:Generates and draws a game scene and status information at the given time.
;759:=================
;760:*/
;761:void CG_DrawActiveFrame( int serverTime, stereoFrame_t stereoView, qboolean demoPlayback ) {
line 764
;762:	int		inwater;
;763:
;764:	cg.time = serverTime;
ADDRGP4 cg+107604
ADDRFP4 0
INDIRI4
ASGNI4
line 765
;765:	cg.demoPlayback = demoPlayback;
ADDRGP4 cg+8
ADDRFP4 8
INDIRI4
ASGNI4
line 768
;766:
;767:	// update cvars
;768:	CG_UpdateCvars();
ADDRGP4 CG_UpdateCvars
CALLV
pop
line 772
;769:
;770:	// if we are only updating the screen as a loading
;771:	// pacifier, don't even try to read snapshots
;772:	if ( cg.infoScreenText[0] != 0 ) {
ADDRGP4 cg+109436
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $760
line 773
;773:		CG_DrawInformation();
ADDRGP4 CG_DrawInformation
CALLV
pop
line 774
;774:		return;
ADDRGP4 $757
JUMPV
LABELV $760
line 779
;775:	}
;776:
;777:	// any looped sounds will be respecified as entities
;778:	// are added to the render list
;779:	trap_S_ClearLoopingSounds(qfalse);
CNSTI4 0
ARGI4
ADDRGP4 trap_S_ClearLoopingSounds
CALLV
pop
line 782
;780:
;781:	// clear all the render lists
;782:	trap_R_ClearScene();
ADDRGP4 trap_R_ClearScene
CALLV
pop
line 785
;783:
;784:	// set up cg.snap and possibly cg.nextSnap
;785:	CG_ProcessSnapshots();
ADDRGP4 CG_ProcessSnapshots
CALLV
pop
line 789
;786:
;787:	// if we haven't received any snapshots yet, all
;788:	// we can draw is the information screen
;789:	if ( !cg.snap || ( cg.snap->snapFlags & SNAPFLAG_NOT_ACTIVE ) ) {
ADDRGP4 cg+36
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $767
ADDRGP4 cg+36
INDIRP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $763
LABELV $767
line 790
;790:		CG_DrawInformation();
ADDRGP4 CG_DrawInformation
CALLV
pop
line 791
;791:		return;
ADDRGP4 $757
JUMPV
LABELV $763
line 795
;792:	}
;793:
;794:	// let the client system know what our weapon and zoom settings are
;795:	trap_SetUserCmdValue( cg.weaponSelect, cg.zoomSensitivity );
ADDRGP4 cg+108944
INDIRI4
ARGI4
ADDRGP4 cg+109432
INDIRF4
ARGF4
ADDRGP4 trap_SetUserCmdValue
CALLV
pop
line 798
;796:
;797:	// this counter will be bumped for every valid scene we generate
;798:	cg.clientFrame++;
ADDRLP4 4
ADDRGP4 cg
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 801
;799:
;800:	// update cg.predictedPlayerState
;801:	CG_PredictPlayerState();
ADDRGP4 CG_PredictPlayerState
CALLV
pop
line 804
;802:
;803:	// decide on third person view
;804:	cg.renderingThirdPerson = cg_thirdPerson.integer || (cg.snap->ps.stats[STAT_HEALTH] <= 0);
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRGP4 cg_thirdPerson+12
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $776
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
GTI4 $774
LABELV $776
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $775
JUMPV
LABELV $774
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $775
ADDRGP4 cg+107628
ADDRLP4 8
INDIRI4
ASGNI4
line 807
;805:
;806:	// build cg.refdef
;807:	inwater = CG_CalcViewValues();
ADDRLP4 16
ADDRGP4 CG_CalcViewValues
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 810
;808:
;809:	// first person blend blobs, done after AnglesToAxis
;810:	if ( !cg.renderingThirdPerson ) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
NEI4 $777
line 811
;811:		CG_DamageBlendBlob();
ADDRGP4 CG_DamageBlendBlob
CALLV
pop
line 812
;812:	}
LABELV $777
line 815
;813:
;814:	// build the render lists
;815:	if ( !cg.hyperspace ) {
ADDRGP4 cg+107632
INDIRI4
CNSTI4 0
NEI4 $780
line 816
;816:		CG_AddPacketEntities();			// adter calcViewValues, so predicted player state is correct
ADDRGP4 CG_AddPacketEntities
CALLV
pop
line 817
;817:		CG_AddMarks();
ADDRGP4 CG_AddMarks
CALLV
pop
line 818
;818:		CG_AddParticles ();
ADDRGP4 CG_AddParticles
CALLV
pop
line 819
;819:		CG_AddLocalEntities();
ADDRGP4 CG_AddLocalEntities
CALLV
pop
line 820
;820:	}
LABELV $780
line 821
;821:	CG_AddViewWeapon( &cg.predictedPlayerState );
ADDRGP4 cg+107636
ARGP4
ADDRGP4 CG_AddViewWeapon
CALLV
pop
line 824
;822:
;823:	// add buffered sounds
;824:	CG_PlayBufferedSounds();
ADDRGP4 CG_PlayBufferedSounds
CALLV
pop
line 827
;825:
;826:	// play buffered voice chats
;827:	CG_PlayBufferedVoiceChats();
ADDRGP4 CG_PlayBufferedVoiceChats
CALLV
pop
line 830
;828:
;829:	// finish up the rest of the refdef
;830:	if ( cg.testModelEntity.hModel ) {
ADDRGP4 cg+124784+8
INDIRI4
CNSTI4 0
EQI4 $784
line 831
;831:		CG_AddTestModel();
ADDRGP4 CG_AddTestModel
CALLV
pop
line 832
;832:	}
LABELV $784
line 833
;833:	cg.refdef.time = cg.time;
ADDRGP4 cg+109044+72
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 834
;834:	memcpy( cg.refdef.areamask, cg.snap->areamask, sizeof( cg.refdef.areamask ) );
ADDRGP4 cg+109044+80
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 12
ADDP4
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 837
;835:
;836:	// warning sounds when powerup is wearing off
;837:	CG_PowerupTimerSounds();
ADDRGP4 CG_PowerupTimerSounds
CALLV
pop
line 840
;838:
;839:	// update audio positions
;840:	trap_S_Respatialize( cg.snap->ps.clientNum, cg.refdef.vieworg, cg.refdef.viewaxis, inwater );
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRGP4 cg+109044+24
ARGP4
ADDRGP4 cg+109044+36
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 trap_S_Respatialize
CALLV
pop
line 843
;841:
;842:	// make sure the lagometerSample and frame timing isn't done twice when in stereo
;843:	if ( stereoView != STEREO_RIGHT ) {
ADDRFP4 4
INDIRI4
CNSTI4 2
EQI4 $801
line 844
;844:		cg.frametime = cg.time - cg.oldTime;
ADDRGP4 cg+107600
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+107608
INDIRI4
SUBI4
ASGNI4
line 845
;845:		if ( cg.frametime < 0 ) {
ADDRGP4 cg+107600
INDIRI4
CNSTI4 0
GEI4 $806
line 846
;846:			cg.frametime = 0;
ADDRGP4 cg+107600
CNSTI4 0
ASGNI4
line 847
;847:		}
LABELV $806
line 848
;848:		cg.oldTime = cg.time;
ADDRGP4 cg+107608
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 849
;849:		CG_AddLagometerFrameInfo();
ADDRGP4 CG_AddLagometerFrameInfo
CALLV
pop
line 850
;850:	}
LABELV $801
line 851
;851:	if (cg_timescale.value != cg_timescaleFadeEnd.value) {
ADDRGP4 cg_timescale+8
INDIRF4
ADDRGP4 cg_timescaleFadeEnd+8
INDIRF4
EQF4 $812
line 852
;852:		if (cg_timescale.value < cg_timescaleFadeEnd.value) {
ADDRGP4 cg_timescale+8
INDIRF4
ADDRGP4 cg_timescaleFadeEnd+8
INDIRF4
GEF4 $816
line 853
;853:			cg_timescale.value += cg_timescaleFadeSpeed.value * ((float)cg.frametime) / 1000;
ADDRLP4 20
ADDRGP4 cg_timescale+8
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRF4
ADDRGP4 cg_timescaleFadeSpeed+8
INDIRF4
ADDRGP4 cg+107600
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
ADDF4
ASGNF4
line 854
;854:			if (cg_timescale.value > cg_timescaleFadeEnd.value)
ADDRGP4 cg_timescale+8
INDIRF4
ADDRGP4 cg_timescaleFadeEnd+8
INDIRF4
LEF4 $817
line 855
;855:				cg_timescale.value = cg_timescaleFadeEnd.value;
ADDRGP4 cg_timescale+8
ADDRGP4 cg_timescaleFadeEnd+8
INDIRF4
ASGNF4
line 856
;856:		}
ADDRGP4 $817
JUMPV
LABELV $816
line 857
;857:		else {
line 858
;858:			cg_timescale.value -= cg_timescaleFadeSpeed.value * ((float)cg.frametime) / 1000;
ADDRLP4 20
ADDRGP4 cg_timescale+8
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRF4
ADDRGP4 cg_timescaleFadeSpeed+8
INDIRF4
ADDRGP4 cg+107600
INDIRI4
CVIF4 4
MULF4
CNSTF4 1148846080
DIVF4
SUBF4
ASGNF4
line 859
;859:			if (cg_timescale.value < cg_timescaleFadeEnd.value)
ADDRGP4 cg_timescale+8
INDIRF4
ADDRGP4 cg_timescaleFadeEnd+8
INDIRF4
GEF4 $832
line 860
;860:				cg_timescale.value = cg_timescaleFadeEnd.value;
ADDRGP4 cg_timescale+8
ADDRGP4 cg_timescaleFadeEnd+8
INDIRF4
ASGNF4
LABELV $832
line 861
;861:		}
LABELV $817
line 862
;862:		if (cg_timescaleFadeSpeed.value) {
ADDRGP4 cg_timescaleFadeSpeed+8
INDIRF4
CNSTF4 0
EQF4 $838
line 863
;863:			trap_Cvar_Set("timescale", va("%f", cg_timescale.value));
ADDRGP4 $842
ARGP4
ADDRGP4 cg_timescale+8
INDIRF4
ARGF4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
ADDRGP4 $841
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 864
;864:		}
LABELV $838
line 865
;865:	}
LABELV $812
line 868
;866:
;867:	// actually issue the rendering calls
;868:	CG_DrawActive( stereoView );
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 CG_DrawActive
CALLV
pop
line 870
;869:
;870:	if ( cg_stats.integer ) {
ADDRGP4 cg_stats+12
INDIRI4
CNSTI4 0
EQI4 $844
line 871
;871:		CG_Printf( "cg.clientFrame:%i\n", cg.clientFrame );
ADDRGP4 $847
ARGP4
ADDRGP4 cg
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 872
;872:	}
LABELV $844
line 875
;873:
;874:
;875:}
LABELV $757
endproc CG_DrawActiveFrame 24 16
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
LABELV $847
byte 1 99
byte 1 103
byte 1 46
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 70
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 58
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $842
byte 1 37
byte 1 102
byte 1 0
align 1
LABELV $841
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 115
byte 1 99
byte 1 97
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $226
byte 1 49
byte 1 48
byte 1 48
byte 1 0
align 1
LABELV $222
byte 1 51
byte 1 48
byte 1 0
align 1
LABELV $221
byte 1 99
byte 1 103
byte 1 95
byte 1 118
byte 1 105
byte 1 101
byte 1 119
byte 1 115
byte 1 105
byte 1 122
byte 1 101
byte 1 0
align 1
LABELV $147
byte 1 115
byte 1 107
byte 1 105
byte 1 110
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $130
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $91
byte 1 67
byte 1 97
byte 1 110
byte 1 39
byte 1 116
byte 1 32
byte 1 114
byte 1 101
byte 1 103
byte 1 105
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 10
byte 1 0
