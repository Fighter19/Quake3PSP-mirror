export CG_BuildSolidList
code
proc CG_BuildSolidList 28 0
file "../cg_predict.c"
line 46
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
;23:// cg_predict.c -- this file generates cg.predictedPlayerState by either
;24:// interpolating between snapshots from the server or locally predicting
;25:// ahead the client's movement.
;26:// It also handles local physics interaction, like fragments bouncing off walls
;27:
;28:#include "cg_local.h"
;29:
;30:static	pmove_t		cg_pmove;
;31:
;32:static	int			cg_numSolidEntities;
;33:static	centity_t	*cg_solidEntities[MAX_ENTITIES_IN_SNAPSHOT];
;34:static	int			cg_numTriggerEntities;
;35:static	centity_t	*cg_triggerEntities[MAX_ENTITIES_IN_SNAPSHOT];
;36:
;37:/*
;38:====================
;39:CG_BuildSolidList
;40:
;41:When a new cg.snap has been set, this function builds a sublist
;42:of the entities that are actually solid, to make for more
;43:efficient collision detection
;44:====================
;45:*/
;46:void CG_BuildSolidList( void ) {
line 52
;47:	int			i;
;48:	centity_t	*cent;
;49:	snapshot_t	*snap;
;50:	entityState_t	*ent;
;51:
;52:	cg_numSolidEntities = 0;
ADDRGP4 cg_numSolidEntities
CNSTI4 0
ASGNI4
line 53
;53:	cg_numTriggerEntities = 0;
ADDRGP4 cg_numTriggerEntities
CNSTI4 0
ASGNI4
line 55
;54:
;55:	if ( cg.nextSnap && !cg.nextFrameTeleport && !cg.thisFrameTeleport ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $71
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 cg+107596
INDIRI4
ADDRLP4 16
INDIRI4
NEI4 $71
ADDRGP4 cg+107592
INDIRI4
ADDRLP4 16
INDIRI4
NEI4 $71
line 56
;56:		snap = cg.nextSnap;
ADDRLP4 12
ADDRGP4 cg+40
INDIRP4
ASGNP4
line 57
;57:	} else {
ADDRGP4 $72
JUMPV
LABELV $71
line 58
;58:		snap = cg.snap;
ADDRLP4 12
ADDRGP4 cg+36
INDIRP4
ASGNP4
line 59
;59:	}
LABELV $72
line 61
;60:
;61:	for ( i = 0 ; i < snap->numEntities ; i++ ) {
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $81
JUMPV
LABELV $78
line 62
;62:		cent = &cg_entities[ snap->entities[ i ].number ];
ADDRLP4 0
CNSTI4 728
CNSTI4 208
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 12
INDIRP4
CNSTI4 516
ADDP4
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 63
;63:		ent = &cent->currentState;
ADDRLP4 4
ADDRLP4 0
INDIRP4
ASGNP4
line 65
;64:
;65:		if ( ent->eType == ET_ITEM || ent->eType == ET_PUSH_TRIGGER || ent->eType == ET_TELEPORT_TRIGGER ) {
ADDRLP4 20
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 2
EQI4 $85
ADDRLP4 20
INDIRI4
CNSTI4 8
EQI4 $85
ADDRLP4 20
INDIRI4
CNSTI4 9
NEI4 $82
LABELV $85
line 66
;66:			cg_triggerEntities[cg_numTriggerEntities] = cent;
ADDRGP4 cg_numTriggerEntities
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_triggerEntities
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 67
;67:			cg_numTriggerEntities++;
ADDRLP4 24
ADDRGP4 cg_numTriggerEntities
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 68
;68:			continue;
ADDRGP4 $79
JUMPV
LABELV $82
line 71
;69:		}
;70:
;71:		if ( cent->nextState.solid ) {
ADDRLP4 0
INDIRP4
CNSTI4 384
ADDP4
INDIRI4
CNSTI4 0
EQI4 $86
line 72
;72:			cg_solidEntities[cg_numSolidEntities] = cent;
ADDRGP4 cg_numSolidEntities
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_solidEntities
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 73
;73:			cg_numSolidEntities++;
ADDRLP4 24
ADDRGP4 cg_numSolidEntities
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 74
;74:			continue;
LABELV $86
line 76
;75:		}
;76:	}
LABELV $79
line 61
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $81
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
LTI4 $78
line 77
;77:}
LABELV $70
endproc CG_BuildSolidList 28 0
proc CG_ClipMoveToEntities 144 36
line 86
;78:
;79:/*
;80:====================
;81:CG_ClipMoveToEntities
;82:
;83:====================
;84:*/
;85:static void CG_ClipMoveToEntities ( const vec3_t start, const vec3_t mins, const vec3_t maxs, const vec3_t end,
;86:							int skipNumber, int mask, trace_t *tr ) {
line 95
;87:	int			i, x, zd, zu;
;88:	trace_t		trace;
;89:	entityState_t	*ent;
;90:	clipHandle_t 	cmodel;
;91:	vec3_t		bmins, bmaxs;
;92:	vec3_t		origin, angles;
;93:	centity_t	*cent;
;94:
;95:	for ( i = 0 ; i < cg_numSolidEntities ; i++ ) {
ADDRLP4 64
CNSTI4 0
ASGNI4
ADDRGP4 $92
JUMPV
LABELV $89
line 96
;96:		cent = cg_solidEntities[ i ];
ADDRLP4 60
ADDRLP4 64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_solidEntities
ADDP4
INDIRP4
ASGNP4
line 97
;97:		ent = &cent->currentState;
ADDRLP4 0
ADDRLP4 60
INDIRP4
ASGNP4
line 99
;98:
;99:		if ( ent->number == skipNumber ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRFP4 16
INDIRI4
NEI4 $93
line 100
;100:			continue;
ADDRGP4 $90
JUMPV
LABELV $93
line 103
;101:		}
;102:
;103:		if ( ent->solid == SOLID_BMODEL ) {
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
NEI4 $95
line 105
;104:			// special value for bmodel
;105:			cmodel = trap_CM_InlineModel( ent->modelindex );
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRLP4 132
ADDRGP4 trap_CM_InlineModel
CALLI4
ASGNI4
ADDRLP4 68
ADDRLP4 132
INDIRI4
ASGNI4
line 106
;106:			VectorCopy( cent->lerpAngles, angles );
ADDRLP4 108
ADDRLP4 60
INDIRP4
CNSTI4 716
ADDP4
INDIRB
ASGNB 12
line 107
;107:			BG_EvaluateTrajectory( &cent->currentState.pos, cg.physicsTime, origin );
ADDRLP4 60
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 cg+107612
INDIRI4
ARGI4
ADDRLP4 96
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 108
;108:		} else {
ADDRGP4 $96
JUMPV
LABELV $95
line 110
;109:			// encoded bbox
;110:			x = (ent->solid & 255);
ADDRLP4 120
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 255
BANDI4
ASGNI4
line 111
;111:			zd = ((ent->solid>>8) & 255);
ADDRLP4 124
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 255
BANDI4
ASGNI4
line 112
;112:			zu = ((ent->solid>>16) & 255) - 32;
ADDRLP4 128
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16
RSHI4
CNSTI4 255
BANDI4
CNSTI4 32
SUBI4
ASGNI4
line 114
;113:
;114:			bmins[0] = bmins[1] = -x;
ADDRLP4 132
ADDRLP4 120
INDIRI4
NEGI4
CVIF4 4
ASGNF4
ADDRLP4 72+4
ADDRLP4 132
INDIRF4
ASGNF4
ADDRLP4 72
ADDRLP4 132
INDIRF4
ASGNF4
line 115
;115:			bmaxs[0] = bmaxs[1] = x;
ADDRLP4 136
ADDRLP4 120
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 84+4
ADDRLP4 136
INDIRF4
ASGNF4
ADDRLP4 84
ADDRLP4 136
INDIRF4
ASGNF4
line 116
;116:			bmins[2] = -zd;
ADDRLP4 72+8
ADDRLP4 124
INDIRI4
NEGI4
CVIF4 4
ASGNF4
line 117
;117:			bmaxs[2] = zu;
ADDRLP4 84+8
ADDRLP4 128
INDIRI4
CVIF4 4
ASGNF4
line 119
;118:
;119:			cmodel = trap_CM_TempBoxModel( bmins, bmaxs );
ADDRLP4 72
ARGP4
ADDRLP4 84
ARGP4
ADDRLP4 140
ADDRGP4 trap_CM_TempBoxModel
CALLI4
ASGNI4
ADDRLP4 68
ADDRLP4 140
INDIRI4
ASGNI4
line 120
;120:			VectorCopy( vec3_origin, angles );
ADDRLP4 108
ADDRGP4 vec3_origin
INDIRB
ASGNB 12
line 121
;121:			VectorCopy( cent->lerpOrigin, origin );
ADDRLP4 96
ADDRLP4 60
INDIRP4
CNSTI4 704
ADDP4
INDIRB
ASGNB 12
line 122
;122:		}
LABELV $96
line 125
;123:
;124:
;125:		trap_CM_TransformedBoxTrace ( &trace, start, end,
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 68
INDIRI4
ARGI4
ADDRFP4 20
INDIRI4
ARGI4
ADDRLP4 96
ARGP4
ADDRLP4 108
ARGP4
ADDRGP4 trap_CM_TransformedBoxTrace
CALLV
pop
line 128
;126:			mins, maxs, cmodel,  mask, origin, angles);
;127:
;128:		if (trace.allsolid || trace.fraction < tr->fraction) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $105
ADDRLP4 4+8
INDIRF4
ADDRFP4 24
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
GEF4 $102
LABELV $105
line 129
;129:			trace.entityNum = ent->number;
ADDRLP4 4+52
ADDRLP4 0
INDIRP4
INDIRI4
ASGNI4
line 130
;130:			*tr = trace;
ADDRFP4 24
INDIRP4
ADDRLP4 4
INDIRB
ASGNB 56
line 131
;131:		} else if (trace.startsolid) {
ADDRGP4 $103
JUMPV
LABELV $102
ADDRLP4 4+4
INDIRI4
CNSTI4 0
EQI4 $107
line 132
;132:			tr->startsolid = qtrue;
ADDRFP4 24
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 1
ASGNI4
line 133
;133:		}
LABELV $107
LABELV $103
line 134
;134:		if ( tr->allsolid ) {
ADDRFP4 24
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $110
line 135
;135:			return;
ADDRGP4 $88
JUMPV
LABELV $110
line 137
;136:		}
;137:	}
LABELV $90
line 95
ADDRLP4 64
ADDRLP4 64
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $92
ADDRLP4 64
INDIRI4
ADDRGP4 cg_numSolidEntities
INDIRI4
LTI4 $89
line 138
;138:}
LABELV $88
endproc CG_ClipMoveToEntities 144 36
export CG_Trace
proc CG_Trace 60 28
line 146
;139:
;140:/*
;141:================
;142:CG_Trace
;143:================
;144:*/
;145:void	CG_Trace( trace_t *result, const vec3_t start, const vec3_t mins, const vec3_t maxs, const vec3_t end, 
;146:					 int skipNumber, int mask ) {
line 149
;147:	trace_t	t;
;148:
;149:	trap_CM_BoxTrace ( &t, start, end, mins, maxs, 0, mask);
ADDRLP4 0
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRFP4 24
INDIRI4
ARGI4
ADDRGP4 trap_CM_BoxTrace
CALLV
pop
line 150
;150:	t.entityNum = t.fraction != 1.0 ? ENTITYNUM_WORLD : ENTITYNUM_NONE;
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $116
ADDRLP4 56
CNSTI4 1022
ASGNI4
ADDRGP4 $117
JUMPV
LABELV $116
ADDRLP4 56
CNSTI4 1023
ASGNI4
LABELV $117
ADDRLP4 0+52
ADDRLP4 56
INDIRI4
ASGNI4
line 152
;151:	// check all other solid models
;152:	CG_ClipMoveToEntities (start, mins, maxs, end, skipNumber, mask, &t);
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRFP4 20
INDIRI4
ARGI4
ADDRFP4 24
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 CG_ClipMoveToEntities
CALLV
pop
line 154
;153:
;154:	*result = t;
ADDRFP4 0
INDIRP4
ADDRLP4 0
INDIRB
ASGNB 56
line 155
;155:}
LABELV $112
endproc CG_Trace 60 28
export CG_PointContents
proc CG_PointContents 36 16
line 162
;156:
;157:/*
;158:================
;159:CG_PointContents
;160:================
;161:*/
;162:int		CG_PointContents( const vec3_t point, int passEntityNum ) {
line 169
;163:	int			i;
;164:	entityState_t	*ent;
;165:	centity_t	*cent;
;166:	clipHandle_t cmodel;
;167:	int			contents;
;168:
;169:	contents = trap_CM_PointContents (point, 0);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 20
ADDRGP4 trap_CM_PointContents
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
line 171
;170:
;171:	for ( i = 0 ; i < cg_numSolidEntities ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $122
JUMPV
LABELV $119
line 172
;172:		cent = cg_solidEntities[ i ];
ADDRLP4 12
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_solidEntities
ADDP4
INDIRP4
ASGNP4
line 174
;173:
;174:		ent = &cent->currentState;
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 176
;175:
;176:		if ( ent->number == passEntityNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $123
line 177
;177:			continue;
ADDRGP4 $120
JUMPV
LABELV $123
line 180
;178:		}
;179:
;180:		if (ent->solid != SOLID_BMODEL) { // special value for bmodel
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
EQI4 $125
line 181
;181:			continue;
ADDRGP4 $120
JUMPV
LABELV $125
line 184
;182:		}
;183:
;184:		cmodel = trap_CM_InlineModel( ent->modelindex );
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 trap_CM_InlineModel
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 24
INDIRI4
ASGNI4
line 185
;185:		if ( !cmodel ) {
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $127
line 186
;186:			continue;
ADDRGP4 $120
JUMPV
LABELV $127
line 189
;187:		}
;188:
;189:		contents |= trap_CM_TransformedPointContents( point, cmodel, ent->origin, ent->angles );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ARGP4
ADDRLP4 32
ADDRGP4 trap_CM_TransformedPointContents
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 32
INDIRI4
BORI4
ASGNI4
line 190
;190:	}
LABELV $120
line 171
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $122
ADDRLP4 4
INDIRI4
ADDRGP4 cg_numSolidEntities
INDIRI4
LTI4 $119
line 192
;191:
;192:	return contents;
ADDRLP4 16
INDIRI4
RETI4
LABELV $118
endproc CG_PointContents 36 16
proc CG_InterpolatePlayerState 64 12
line 204
;193:}
;194:
;195:
;196:/*
;197:========================
;198:CG_InterpolatePlayerState
;199:
;200:Generates cg.predictedPlayerState by interpolating between
;201:cg.snap->player_state and cg.nextFrame->player_state
;202:========================
;203:*/
;204:static void CG_InterpolatePlayerState( qboolean grabAngles ) {
line 210
;205:	float			f;
;206:	int				i;
;207:	playerState_t	*out;
;208:	snapshot_t		*prev, *next;
;209:
;210:	out = &cg.predictedPlayerState;
ADDRLP4 12
ADDRGP4 cg+107636
ASGNP4
line 211
;211:	prev = cg.snap;
ADDRLP4 4
ADDRGP4 cg+36
INDIRP4
ASGNP4
line 212
;212:	next = cg.nextSnap;
ADDRLP4 8
ADDRGP4 cg+40
INDIRP4
ASGNP4
line 214
;213:
;214:	*out = cg.snap->ps;
ADDRLP4 12
INDIRP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
INDIRB
ASGNB 468
line 217
;215:
;216:	// if we are still allowing local input, short circuit the view angles
;217:	if ( grabAngles ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
EQI4 $134
line 221
;218:		usercmd_t	cmd;
;219:		int			cmdNum;
;220:
;221:		cmdNum = trap_GetCurrentCmdNumber();
ADDRLP4 48
ADDRGP4 trap_GetCurrentCmdNumber
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 48
INDIRI4
ASGNI4
line 222
;222:		trap_GetUserCmd( cmdNum, &cmd );
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 20
ARGP4
ADDRGP4 trap_GetUserCmd
CALLI4
pop
line 224
;223:
;224:		PM_UpdateViewAngles( out, &cmd );
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 20
ARGP4
ADDRGP4 PM_UpdateViewAngles
CALLV
pop
line 225
;225:	}
LABELV $134
line 228
;226:
;227:	// if the next frame is a teleport, we can't lerp to it
;228:	if ( cg.nextFrameTeleport ) {
ADDRGP4 cg+107596
INDIRI4
CNSTI4 0
EQI4 $136
line 229
;229:		return;
ADDRGP4 $129
JUMPV
LABELV $136
line 232
;230:	}
;231:
;232:	if ( !next || next->serverTime <= prev->serverTime ) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $141
ADDRLP4 24
CNSTI4 8
ASGNI4
ADDRLP4 8
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
ADDRLP4 4
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
GTI4 $139
LABELV $141
line 233
;233:		return;
ADDRGP4 $129
JUMPV
LABELV $139
line 236
;234:	}
;235:
;236:	f = (float)( cg.time - prev->serverTime ) / ( next->serverTime - prev->serverTime );
ADDRLP4 28
CNSTI4 8
ASGNI4
ADDRLP4 32
ADDRLP4 4
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 32
INDIRI4
SUBI4
CVIF4 4
ADDRLP4 8
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ADDRLP4 32
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 238
;237:
;238:	i = next->ps.bobCycle;
ADDRLP4 0
ADDRLP4 8
INDIRP4
CNSTI4 52
ADDP4
INDIRI4
ASGNI4
line 239
;239:	if ( i < prev->ps.bobCycle ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 52
ADDP4
INDIRI4
GEI4 $143
line 240
;240:		i += 256;		// handle wraparound
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 256
ADDI4
ASGNI4
line 241
;241:	}
LABELV $143
line 242
;242:	out->bobCycle = prev->ps.bobCycle + f * ( i - prev->ps.bobCycle );
ADDRLP4 36
ADDRLP4 4
INDIRP4
CNSTI4 52
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 36
INDIRI4
CVIF4 4
ADDRLP4 16
INDIRF4
ADDRLP4 0
INDIRI4
ADDRLP4 36
INDIRI4
SUBI4
CVIF4 4
MULF4
ADDF4
CVFI4 4
ASGNI4
line 244
;243:
;244:	for ( i = 0 ; i < 3 ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $145
line 245
;245:		out->origin[i] = prev->ps.origin[i] + f * (next->ps.origin[i] - prev->ps.origin[i] );
ADDRLP4 40
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 44
CNSTI4 64
ASGNI4
ADDRLP4 48
ADDRLP4 40
INDIRI4
ADDRLP4 4
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ADDP4
INDIRF4
ASGNF4
ADDRLP4 40
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 20
ADDP4
ADDP4
ADDRLP4 48
INDIRF4
ADDRLP4 16
INDIRF4
ADDRLP4 40
INDIRI4
ADDRLP4 8
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ADDP4
INDIRF4
ADDRLP4 48
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 246
;246:		if ( !grabAngles ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $149
line 247
;247:			out->viewangles[i] = LerpAngle( 
ADDRLP4 52
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 56
CNSTI4 196
ASGNI4
ADDRLP4 52
INDIRI4
ADDRLP4 4
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ADDP4
INDIRF4
ARGF4
ADDRLP4 52
INDIRI4
ADDRLP4 8
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ADDP4
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 60
ADDRGP4 LerpAngle
CALLF4
ASGNF4
ADDRLP4 52
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 152
ADDP4
ADDP4
ADDRLP4 60
INDIRF4
ASGNF4
line 249
;248:				prev->ps.viewangles[i], next->ps.viewangles[i], f );
;249:		}
LABELV $149
line 250
;250:		out->velocity[i] = prev->ps.velocity[i] + 
ADDRLP4 52
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 56
CNSTI4 76
ASGNI4
ADDRLP4 60
ADDRLP4 52
INDIRI4
ADDRLP4 4
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ADDP4
INDIRF4
ASGNF4
ADDRLP4 52
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 32
ADDP4
ADDP4
ADDRLP4 60
INDIRF4
ADDRLP4 16
INDIRF4
ADDRLP4 52
INDIRI4
ADDRLP4 8
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ADDP4
INDIRF4
ADDRLP4 60
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 252
;251:			f * (next->ps.velocity[i] - prev->ps.velocity[i] );
;252:	}
LABELV $146
line 244
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $145
line 254
;253:
;254:}
LABELV $129
endproc CG_InterpolatePlayerState 64 12
proc CG_TouchItem 20 12
line 261
;255:
;256:/*
;257:===================
;258:CG_TouchItem
;259:===================
;260:*/
;261:static void CG_TouchItem( centity_t *cent ) {
line 264
;262:	gitem_t		*item;
;263:
;264:	if ( !cg_predictItems.integer ) {
ADDRGP4 cg_predictItems+12
INDIRI4
CNSTI4 0
NEI4 $152
line 265
;265:		return;
ADDRGP4 $151
JUMPV
LABELV $152
line 267
;266:	}
;267:	if ( !BG_PlayerTouchesItem( &cg.predictedPlayerState, &cent->currentState, cg.time ) ) {
ADDRGP4 cg+107636
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRLP4 4
ADDRGP4 BG_PlayerTouchesItem
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $155
line 268
;268:		return;
ADDRGP4 $151
JUMPV
LABELV $155
line 272
;269:	}
;270:
;271:	// never pick an item up twice in a prediction
;272:	if ( cent->miscTime == cg.time ) {
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
NEI4 $159
line 273
;273:		return;
ADDRGP4 $151
JUMPV
LABELV $159
line 276
;274:	}
;275:
;276:	if ( !BG_CanItemBeGrabbed( cgs.gametype, &cent->currentState, &cg.predictedPlayerState ) ) {
ADDRGP4 cgs+31456
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 cg+107636
ARGP4
ADDRLP4 8
ADDRGP4 BG_CanItemBeGrabbed
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $162
line 277
;277:		return;		// can't hold it
ADDRGP4 $151
JUMPV
LABELV $162
line 280
;278:	}
;279:
;280:	item = &bg_itemlist[ cent->currentState.modelindex ];
ADDRLP4 0
CNSTI4 52
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
MULI4
ADDRGP4 bg_itemlist
ADDP4
ASGNP4
line 292
;281:
;282:	// Special case for flags.  
;283:	// We don't predict touching our own flag
;284:#ifdef MISSIONPACK
;285:	if( cgs.gametype == GT_1FCTF ) {
;286:		if( item->giTag != PW_NEUTRALFLAG ) {
;287:			return;
;288:		}
;289:	}
;290:	if( cgs.gametype == GT_CTF || cgs.gametype == GT_HARVESTER ) {
;291:#else
;292:	if( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $166
line 294
;293:#endif
;294:		if (cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_RED &&
ADDRGP4 cg+107636+248+12
INDIRI4
CNSTI4 1
NEI4 $169
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 7
NEI4 $169
line 296
;295:			item->giTag == PW_REDFLAG)
;296:			return;
ADDRGP4 $151
JUMPV
LABELV $169
line 297
;297:		if (cg.predictedPlayerState.persistant[PERS_TEAM] == TEAM_BLUE &&
ADDRGP4 cg+107636+248+12
INDIRI4
CNSTI4 2
NEI4 $174
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 8
NEI4 $174
line 299
;298:			item->giTag == PW_BLUEFLAG)
;299:			return;
ADDRGP4 $151
JUMPV
LABELV $174
line 300
;300:	}
LABELV $166
line 303
;301:
;302:	// grab it
;303:	BG_AddPredictableEventToPlayerstate( EV_ITEM_PICKUP, cent->currentState.modelindex , &cg.predictedPlayerState);
CNSTI4 19
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRGP4 cg+107636
ARGP4
ADDRGP4 BG_AddPredictableEventToPlayerstate
CALLV
pop
line 306
;304:
;305:	// remove it from the frame so it won't be drawn
;306:	cent->currentState.eFlags |= EF_NODRAW;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
line 309
;307:
;308:	// don't touch it again this prediction
;309:	cent->miscTime = cg.time;
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 312
;310:
;311:	// if its a weapon, give them some predicted ammo so the autoswitch will work
;312:	if ( item->giType == IT_WEAPON ) {
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $181
line 313
;313:		cg.predictedPlayerState.stats[ STAT_WEAPONS ] |= 1 << item->giTag;
ADDRLP4 16
ADDRGP4 cg+107636+184+8
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 1
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
LSHI4
BORI4
ASGNI4
line 314
;314:		if ( !cg.predictedPlayerState.ammo[ item->giTag ] ) {
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+107636+376
ADDP4
INDIRI4
CNSTI4 0
NEI4 $186
line 315
;315:			cg.predictedPlayerState.ammo[ item->giTag ] = 1;
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+107636+376
ADDP4
CNSTI4 1
ASGNI4
line 316
;316:		}
LABELV $186
line 317
;317:	}
LABELV $181
line 318
;318:}
LABELV $151
endproc CG_TouchItem 20 12
proc CG_TouchTriggerPrediction 88 28
line 328
;319:
;320:
;321:/*
;322:=========================
;323:CG_TouchTriggerPrediction
;324:
;325:Predict push triggers and items
;326:=========================
;327:*/
;328:static void CG_TouchTriggerPrediction( void ) {
line 337
;329:	int			i;
;330:	trace_t		trace;
;331:	entityState_t	*ent;
;332:	clipHandle_t cmodel;
;333:	centity_t	*cent;
;334:	qboolean	spectator;
;335:
;336:	// dead clients don't activate triggers
;337:	if ( cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+107636+184
INDIRI4
CNSTI4 0
GTI4 $193
line 338
;338:		return;
ADDRGP4 $192
JUMPV
LABELV $193
line 341
;339:	}
;340:
;341:	spectator = ( cg.predictedPlayerState.pm_type == PM_SPECTATOR );
ADDRGP4 cg+107636+4
INDIRI4
CNSTI4 2
NEI4 $200
ADDRLP4 76
CNSTI4 1
ASGNI4
ADDRGP4 $201
JUMPV
LABELV $200
ADDRLP4 76
CNSTI4 0
ASGNI4
LABELV $201
ADDRLP4 72
ADDRLP4 76
INDIRI4
ASGNI4
line 343
;342:
;343:	if ( cg.predictedPlayerState.pm_type != PM_NORMAL && !spectator ) {
ADDRLP4 80
CNSTI4 0
ASGNI4
ADDRGP4 cg+107636+4
INDIRI4
ADDRLP4 80
INDIRI4
EQI4 $202
ADDRLP4 72
INDIRI4
ADDRLP4 80
INDIRI4
NEI4 $202
line 344
;344:		return;
ADDRGP4 $192
JUMPV
LABELV $202
line 347
;345:	}
;346:
;347:	for ( i = 0 ; i < cg_numTriggerEntities ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $209
JUMPV
LABELV $206
line 348
;348:		cent = cg_triggerEntities[ i ];
ADDRLP4 12
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg_triggerEntities
ADDP4
INDIRP4
ASGNP4
line 349
;349:		ent = &cent->currentState;
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 351
;350:
;351:		if ( ent->eType == ET_ITEM && !spectator ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 2
NEI4 $210
ADDRLP4 72
INDIRI4
CNSTI4 0
NEI4 $210
line 352
;352:			CG_TouchItem( cent );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 CG_TouchItem
CALLV
pop
line 353
;353:			continue;
ADDRGP4 $207
JUMPV
LABELV $210
line 356
;354:		}
;355:
;356:		if ( ent->solid != SOLID_BMODEL ) {
ADDRLP4 0
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
CNSTI4 16777215
EQI4 $212
line 357
;357:			continue;
ADDRGP4 $207
JUMPV
LABELV $212
line 360
;358:		}
;359:
;360:		cmodel = trap_CM_InlineModel( ent->modelindex );
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ARGI4
ADDRLP4 84
ADDRGP4 trap_CM_InlineModel
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 84
INDIRI4
ASGNI4
line 361
;361:		if ( !cmodel ) {
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $214
line 362
;362:			continue;
ADDRGP4 $207
JUMPV
LABELV $214
line 365
;363:		}
;364:
;365:		trap_CM_BoxTrace( &trace, cg.predictedPlayerState.origin, cg.predictedPlayerState.origin, 
ADDRLP4 16
ARGP4
ADDRGP4 cg+107636+20
ARGP4
ADDRGP4 cg+107636+20
ARGP4
ADDRGP4 cg_pmove+180
ARGP4
ADDRGP4 cg_pmove+192
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
CNSTI4 -1
ARGI4
ADDRGP4 trap_CM_BoxTrace
CALLV
pop
line 368
;366:			cg_pmove.mins, cg_pmove.maxs, cmodel, -1 );
;367:
;368:		if ( !trace.startsolid ) {
ADDRLP4 16+4
INDIRI4
CNSTI4 0
NEI4 $222
line 369
;369:			continue;
ADDRGP4 $207
JUMPV
LABELV $222
line 372
;370:		}
;371:
;372:		if ( ent->eType == ET_TELEPORT_TRIGGER ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 9
NEI4 $225
line 373
;373:			cg.hyperspace = qtrue;
ADDRGP4 cg+107632
CNSTI4 1
ASGNI4
line 374
;374:		} else if ( ent->eType == ET_PUSH_TRIGGER ) {
ADDRGP4 $226
JUMPV
LABELV $225
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 8
NEI4 $228
line 375
;375:			BG_TouchJumpPad( &cg.predictedPlayerState, ent );
ADDRGP4 cg+107636
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 BG_TouchJumpPad
CALLV
pop
line 376
;376:		}
LABELV $228
LABELV $226
line 377
;377:	}
LABELV $207
line 347
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $209
ADDRLP4 4
INDIRI4
ADDRGP4 cg_numTriggerEntities
INDIRI4
LTI4 $206
line 380
;378:
;379:	// if we didn't touch a jump pad this pmove frame
;380:	if ( cg.predictedPlayerState.jumppad_frame != cg.predictedPlayerState.pmove_framecount ) {
ADDRGP4 cg+107636+460
INDIRI4
ADDRGP4 cg+107636+456
INDIRI4
EQI4 $231
line 381
;381:		cg.predictedPlayerState.jumppad_frame = 0;
ADDRGP4 cg+107636+460
CNSTI4 0
ASGNI4
line 382
;382:		cg.predictedPlayerState.jumppad_ent = 0;
ADDRGP4 cg+107636+448
CNSTI4 0
ASGNI4
line 383
;383:	}
LABELV $231
line 384
;384:}
LABELV $192
endproc CG_TouchTriggerPrediction 88 28
export CG_PredictPlayerState
proc CG_PredictPlayerState 592 20
line 414
;385:
;386:
;387:
;388:/*
;389:=================
;390:CG_PredictPlayerState
;391:
;392:Generates cg.predictedPlayerState for the current cg.time
;393:cg.predictedPlayerState is guaranteed to be valid after exiting.
;394:
;395:For demo playback, this will be an interpolation between two valid
;396:playerState_t.
;397:
;398:For normal gameplay, it will be the result of predicted usercmd_t on
;399:top of the most recent playerState_t received from the server.
;400:
;401:Each new snapshot will usually have one or more new usercmd over the last,
;402:but we simulate all unacknowledged commands each time, not just the new ones.
;403:This means that on an internet connection, quite a few pmoves may be issued
;404:each frame.
;405:
;406:OPTIMIZE: don't re-simulate unless the newly arrived snapshot playerState_t
;407:differs from the predicted one.  Would require saving all intermediate
;408:playerState_t during prediction.
;409:
;410:We detect prediction errors and allow them to be decayed off over several frames
;411:to ease the jerk.
;412:=================
;413:*/
;414:void CG_PredictPlayerState( void ) {
line 421
;415:	int			cmdNum, current;
;416:	playerState_t	oldPlayerState;
;417:	qboolean	moved;
;418:	usercmd_t	oldestCmd;
;419:	usercmd_t	latestCmd;
;420:
;421:	cg.hyperspace = qfalse;	// will be set if touching a trigger_teleport
ADDRGP4 cg+107632
CNSTI4 0
ASGNI4
line 426
;422:
;423:	// if this is the first frame we must guarantee
;424:	// predictedPlayerState is valid even if there is some
;425:	// other error condition
;426:	if ( !cg.validPPS ) {
ADDRGP4 cg+108832
INDIRI4
CNSTI4 0
NEI4 $243
line 427
;427:		cg.validPPS = qtrue;
ADDRGP4 cg+108832
CNSTI4 1
ASGNI4
line 428
;428:		cg.predictedPlayerState = cg.snap->ps;
ADDRGP4 cg+107636
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
INDIRB
ASGNB 468
line 429
;429:	}
LABELV $243
line 433
;430:
;431:
;432:	// demo playback just copies the moves
;433:	if ( cg.demoPlayback || (cg.snap->ps.pm_flags & PMF_FOLLOW) ) {
ADDRLP4 528
CNSTI4 0
ASGNI4
ADDRGP4 cg+8
INDIRI4
ADDRLP4 528
INDIRI4
NEI4 $253
ADDRGP4 cg+36
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
ADDRLP4 528
INDIRI4
EQI4 $249
LABELV $253
line 434
;434:		CG_InterpolatePlayerState( qfalse );
CNSTI4 0
ARGI4
ADDRGP4 CG_InterpolatePlayerState
CALLV
pop
line 435
;435:		return;
ADDRGP4 $241
JUMPV
LABELV $249
line 439
;436:	}
;437:
;438:	// non-predicting local movement will grab the latest angles
;439:	if ( cg_nopredict.integer || cg_synchronousClients.integer ) {
ADDRLP4 532
CNSTI4 0
ASGNI4
ADDRGP4 cg_nopredict+12
INDIRI4
ADDRLP4 532
INDIRI4
NEI4 $258
ADDRGP4 cg_synchronousClients+12
INDIRI4
ADDRLP4 532
INDIRI4
EQI4 $254
LABELV $258
line 440
;440:		CG_InterpolatePlayerState( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 CG_InterpolatePlayerState
CALLV
pop
line 441
;441:		return;
ADDRGP4 $241
JUMPV
LABELV $254
line 445
;442:	}
;443:
;444:	// prepare for pmove
;445:	cg_pmove.ps = &cg.predictedPlayerState;
ADDRGP4 cg_pmove
ADDRGP4 cg+107636
ASGNP4
line 446
;446:	cg_pmove.trace = CG_Trace;
ADDRGP4 cg_pmove+224
ADDRGP4 CG_Trace
ASGNP4
line 447
;447:	cg_pmove.pointcontents = CG_PointContents;
ADDRGP4 cg_pmove+228
ADDRGP4 CG_PointContents
ASGNP4
line 448
;448:	if ( cg_pmove.ps->pm_type == PM_DEAD ) {
ADDRGP4 cg_pmove
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $262
line 449
;449:		cg_pmove.tracemask = MASK_PLAYERSOLID & ~CONTENTS_BODY;
ADDRGP4 cg_pmove+28
CNSTI4 65537
ASGNI4
line 450
;450:	}
ADDRGP4 $263
JUMPV
LABELV $262
line 451
;451:	else {
line 452
;452:		cg_pmove.tracemask = MASK_PLAYERSOLID;
ADDRGP4 cg_pmove+28
CNSTI4 33619969
ASGNI4
line 453
;453:	}
LABELV $263
line 454
;454:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $266
line 455
;455:		cg_pmove.tracemask &= ~CONTENTS_BODY;	// spectators can fly through bodies
ADDRLP4 536
ADDRGP4 cg_pmove+28
ASGNP4
ADDRLP4 536
INDIRP4
ADDRLP4 536
INDIRP4
INDIRI4
CNSTI4 -33554433
BANDI4
ASGNI4
line 456
;456:	}
LABELV $266
line 457
;457:	cg_pmove.noFootsteps = ( cgs.dmflags & DF_NO_FOOTSTEPS ) > 0;
ADDRGP4 cgs+31460
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
LEI4 $273
ADDRLP4 536
CNSTI4 1
ASGNI4
ADDRGP4 $274
JUMPV
LABELV $273
ADDRLP4 536
CNSTI4 0
ASGNI4
LABELV $274
ADDRGP4 cg_pmove+36
ADDRLP4 536
INDIRI4
ASGNI4
line 460
;458:
;459:	// save the state before the pmove so we can detect transitions
;460:	oldPlayerState = cg.predictedPlayerState;
ADDRLP4 4
ADDRGP4 cg+107636
INDIRB
ASGNB 468
line 462
;461:
;462:	current = trap_GetCurrentCmdNumber();
ADDRLP4 540
ADDRGP4 trap_GetCurrentCmdNumber
CALLI4
ASGNI4
ADDRLP4 472
ADDRLP4 540
INDIRI4
ASGNI4
line 467
;463:
;464:	// if we don't have the commands right after the snapshot, we
;465:	// can't accurately predict a current position, so just freeze at
;466:	// the last good position we had
;467:	cmdNum = current - CMD_BACKUP + 1;
ADDRLP4 0
ADDRLP4 472
INDIRI4
CNSTI4 64
SUBI4
CNSTI4 1
ADDI4
ASGNI4
line 468
;468:	trap_GetUserCmd( cmdNum, &oldestCmd );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 504
ARGP4
ADDRGP4 trap_GetUserCmd
CALLI4
pop
line 469
;469:	if ( oldestCmd.serverTime > cg.snap->ps.commandTime 
ADDRLP4 544
ADDRLP4 504
INDIRI4
ASGNI4
ADDRLP4 544
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
LEI4 $276
ADDRLP4 544
INDIRI4
ADDRGP4 cg+107604
INDIRI4
GEI4 $276
line 470
;470:		&& oldestCmd.serverTime < cg.time ) {	// special check for map_restart
line 471
;471:		if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $241
line 472
;472:			CG_Printf ("exceeded PACKET_BACKUP on commands\n");
ADDRGP4 $283
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 473
;473:		}
line 474
;474:		return;
ADDRGP4 $241
JUMPV
LABELV $276
line 478
;475:	}
;476:
;477:	// get the latest command so we can know which commands are from previous map_restarts
;478:	trap_GetUserCmd( current, &latestCmd );
ADDRLP4 472
INDIRI4
ARGI4
ADDRLP4 480
ARGP4
ADDRGP4 trap_GetUserCmd
CALLI4
pop
line 484
;479:
;480:	// get the most recent information we have, even if
;481:	// the server time is beyond our current cg.time,
;482:	// because predicted player positions are going to 
;483:	// be ahead of everything else anyway
;484:	if ( cg.nextSnap && !cg.nextFrameTeleport && !cg.thisFrameTeleport ) {
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $284
ADDRLP4 548
CNSTI4 0
ASGNI4
ADDRGP4 cg+107596
INDIRI4
ADDRLP4 548
INDIRI4
NEI4 $284
ADDRGP4 cg+107592
INDIRI4
ADDRLP4 548
INDIRI4
NEI4 $284
line 485
;485:		cg.predictedPlayerState = cg.nextSnap->ps;
ADDRGP4 cg+107636
ADDRGP4 cg+40
INDIRP4
CNSTI4 44
ADDP4
INDIRB
ASGNB 468
line 486
;486:		cg.physicsTime = cg.nextSnap->serverTime;
ADDRGP4 cg+107612
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 487
;487:	} else {
ADDRGP4 $285
JUMPV
LABELV $284
line 488
;488:		cg.predictedPlayerState = cg.snap->ps;
ADDRGP4 cg+107636
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
INDIRB
ASGNB 468
line 489
;489:		cg.physicsTime = cg.snap->serverTime;
ADDRGP4 cg+107612
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 490
;490:	}
LABELV $285
line 492
;491:
;492:	if ( pmove_msec.integer < 8 ) {
ADDRGP4 pmove_msec+12
INDIRI4
CNSTI4 8
GEI4 $297
line 493
;493:		trap_Cvar_Set("pmove_msec", "8");
ADDRGP4 $300
ARGP4
ADDRGP4 $301
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 494
;494:	}
ADDRGP4 $298
JUMPV
LABELV $297
line 495
;495:	else if (pmove_msec.integer > 33) {
ADDRGP4 pmove_msec+12
INDIRI4
CNSTI4 33
LEI4 $302
line 496
;496:		trap_Cvar_Set("pmove_msec", "33");
ADDRGP4 $300
ARGP4
ADDRGP4 $305
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 497
;497:	}
LABELV $302
LABELV $298
line 499
;498:
;499:	cg_pmove.pmove_fixed = pmove_fixed.integer;// | cg_pmove_fixed.integer;
ADDRGP4 cg_pmove+216
ADDRGP4 pmove_fixed+12
INDIRI4
ASGNI4
line 500
;500:	cg_pmove.pmove_msec = pmove_msec.integer;
ADDRGP4 cg_pmove+220
ADDRGP4 pmove_msec+12
INDIRI4
ASGNI4
line 503
;501:
;502:	// run cmds
;503:	moved = qfalse;
ADDRLP4 476
CNSTI4 0
ASGNI4
line 504
;504:	for ( cmdNum = current - CMD_BACKUP + 1 ; cmdNum <= current ; cmdNum++ ) {
ADDRLP4 0
ADDRLP4 472
INDIRI4
CNSTI4 64
SUBI4
CNSTI4 1
ADDI4
ASGNI4
ADDRGP4 $313
JUMPV
LABELV $310
line 506
;505:		// get the command
;506:		trap_GetUserCmd( cmdNum, &cg_pmove.cmd );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 cg_pmove+4
ARGP4
ADDRGP4 trap_GetUserCmd
CALLI4
pop
line 508
;507:
;508:		if ( cg_pmove.pmove_fixed ) {
ADDRGP4 cg_pmove+216
INDIRI4
CNSTI4 0
EQI4 $315
line 509
;509:			PM_UpdateViewAngles( cg_pmove.ps, &cg_pmove.cmd );
ADDRGP4 cg_pmove
INDIRP4
ARGP4
ADDRGP4 cg_pmove+4
ARGP4
ADDRGP4 PM_UpdateViewAngles
CALLV
pop
line 510
;510:		}
LABELV $315
line 513
;511:
;512:		// don't do anything if the time is before the snapshot player time
;513:		if ( cg_pmove.cmd.serverTime <= cg.predictedPlayerState.commandTime ) {
ADDRGP4 cg_pmove+4
INDIRI4
ADDRGP4 cg+107636
INDIRI4
GTI4 $319
line 514
;514:			continue;
ADDRGP4 $311
JUMPV
LABELV $319
line 518
;515:		}
;516:
;517:		// don't do anything if the command was from a previous map_restart
;518:		if ( cg_pmove.cmd.serverTime > latestCmd.serverTime ) {
ADDRGP4 cg_pmove+4
INDIRI4
ADDRLP4 480
INDIRI4
LEI4 $323
line 519
;519:			continue;
ADDRGP4 $311
JUMPV
LABELV $323
line 527
;520:		}
;521:
;522:		// check for a prediction error from last frame
;523:		// on a lan, this will often be the exact value
;524:		// from the snapshot, but on a wan we will have
;525:		// to predict several commands to get to the point
;526:		// we want to compare
;527:		if ( cg.predictedPlayerState.commandTime == oldPlayerState.commandTime ) {
ADDRGP4 cg+107636
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $326
line 531
;528:			vec3_t	delta;
;529:			float	len;
;530:
;531:			if ( cg.thisFrameTeleport ) {
ADDRGP4 cg+107592
INDIRI4
CNSTI4 0
EQI4 $329
line 533
;532:				// a teleport will not cause an error decay
;533:				VectorClear( cg.predictedError );
ADDRLP4 568
CNSTF4 0
ASGNF4
ADDRGP4 cg+108840+8
ADDRLP4 568
INDIRF4
ASGNF4
ADDRGP4 cg+108840+4
ADDRLP4 568
INDIRF4
ASGNF4
ADDRGP4 cg+108840
ADDRLP4 568
INDIRF4
ASGNF4
line 534
;534:				if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $337
line 535
;535:					CG_Printf( "PredictionTeleport\n" );
ADDRGP4 $340
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 536
;536:				}
LABELV $337
line 537
;537:				cg.thisFrameTeleport = qfalse;
ADDRGP4 cg+107592
CNSTI4 0
ASGNI4
line 538
;538:			} else {
ADDRGP4 $330
JUMPV
LABELV $329
line 540
;539:				vec3_t	adjusted;
;540:				CG_AdjustPositionForMover( cg.predictedPlayerState.origin, 
ADDRGP4 cg+107636+20
ARGP4
ADDRGP4 cg+107636+68
INDIRI4
ARGI4
ADDRGP4 cg+107612
INDIRI4
ARGI4
ADDRGP4 cg+107608
INDIRI4
ARGI4
ADDRLP4 568
ARGP4
ADDRGP4 CG_AdjustPositionForMover
CALLV
pop
line 543
;541:					cg.predictedPlayerState.groundEntityNum, cg.physicsTime, cg.oldTime, adjusted );
;542:
;543:				if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $348
line 544
;544:					if (!VectorCompare( oldPlayerState.origin, adjusted )) {
ADDRLP4 4+20
ARGP4
ADDRLP4 568
ARGP4
ADDRLP4 580
ADDRGP4 VectorCompare
CALLI4
ASGNI4
ADDRLP4 580
INDIRI4
CNSTI4 0
NEI4 $351
line 545
;545:						CG_Printf("prediction error\n");
ADDRGP4 $354
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 546
;546:					}
LABELV $351
line 547
;547:				}
LABELV $348
line 548
;548:				VectorSubtract( oldPlayerState.origin, adjusted, delta );
ADDRLP4 552
ADDRLP4 4+20
INDIRF4
ADDRLP4 568
INDIRF4
SUBF4
ASGNF4
ADDRLP4 552+4
ADDRLP4 4+20+4
INDIRF4
ADDRLP4 568+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 552+8
ADDRLP4 4+20+8
INDIRF4
ADDRLP4 568+8
INDIRF4
SUBF4
ASGNF4
line 549
;549:				len = VectorLength( delta );
ADDRLP4 552
ARGP4
ADDRLP4 580
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 564
ADDRLP4 580
INDIRF4
ASGNF4
line 550
;550:				if ( len > 0.1 ) {
ADDRLP4 564
INDIRF4
CNSTF4 1036831949
LEF4 $364
line 551
;551:					if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $366
line 552
;552:						CG_Printf("Prediction miss: %f\n", len);
ADDRGP4 $369
ARGP4
ADDRLP4 564
INDIRF4
ARGF4
ADDRGP4 CG_Printf
CALLV
pop
line 553
;553:					}
LABELV $366
line 554
;554:					if ( cg_errorDecay.integer ) {
ADDRGP4 cg_errorDecay+12
INDIRI4
CNSTI4 0
EQI4 $370
line 558
;555:						int		t;
;556:						float	f;
;557:
;558:						t = cg.time - cg.predictedErrorTime;
ADDRLP4 588
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+108836
INDIRI4
SUBI4
ASGNI4
line 559
;559:						f = ( cg_errorDecay.value - t ) / cg_errorDecay.value;
ADDRLP4 584
ADDRGP4 cg_errorDecay+8
INDIRF4
ADDRLP4 588
INDIRI4
CVIF4 4
SUBF4
ADDRGP4 cg_errorDecay+8
INDIRF4
DIVF4
ASGNF4
line 560
;560:						if ( f < 0 ) {
ADDRLP4 584
INDIRF4
CNSTF4 0
GEF4 $377
line 561
;561:							f = 0;
ADDRLP4 584
CNSTF4 0
ASGNF4
line 562
;562:						}
LABELV $377
line 563
;563:						if ( f > 0 && cg_showmiss.integer ) {
ADDRLP4 584
INDIRF4
CNSTF4 0
LEF4 $379
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $379
line 564
;564:							CG_Printf("Double prediction decay: %f\n", f);
ADDRGP4 $382
ARGP4
ADDRLP4 584
INDIRF4
ARGF4
ADDRGP4 CG_Printf
CALLV
pop
line 565
;565:						}
LABELV $379
line 566
;566:						VectorScale( cg.predictedError, f, cg.predictedError );
ADDRGP4 cg+108840
ADDRGP4 cg+108840
INDIRF4
ADDRLP4 584
INDIRF4
MULF4
ASGNF4
ADDRGP4 cg+108840+4
ADDRGP4 cg+108840+4
INDIRF4
ADDRLP4 584
INDIRF4
MULF4
ASGNF4
ADDRGP4 cg+108840+8
ADDRGP4 cg+108840+8
INDIRF4
ADDRLP4 584
INDIRF4
MULF4
ASGNF4
line 567
;567:					} else {
ADDRGP4 $371
JUMPV
LABELV $370
line 568
;568:						VectorClear( cg.predictedError );
ADDRLP4 584
CNSTF4 0
ASGNF4
ADDRGP4 cg+108840+8
ADDRLP4 584
INDIRF4
ASGNF4
ADDRGP4 cg+108840+4
ADDRLP4 584
INDIRF4
ASGNF4
ADDRGP4 cg+108840
ADDRLP4 584
INDIRF4
ASGNF4
line 569
;569:					}
LABELV $371
line 570
;570:					VectorAdd( delta, cg.predictedError, cg.predictedError );
ADDRGP4 cg+108840
ADDRLP4 552
INDIRF4
ADDRGP4 cg+108840
INDIRF4
ADDF4
ASGNF4
ADDRGP4 cg+108840+4
ADDRLP4 552+4
INDIRF4
ADDRGP4 cg+108840+4
INDIRF4
ADDF4
ASGNF4
ADDRGP4 cg+108840+8
ADDRLP4 552+8
INDIRF4
ADDRGP4 cg+108840+8
INDIRF4
ADDF4
ASGNF4
line 571
;571:					cg.predictedErrorTime = cg.oldTime;
ADDRGP4 cg+108836
ADDRGP4 cg+107608
INDIRI4
ASGNI4
line 572
;572:				}
LABELV $364
line 573
;573:			}
LABELV $330
line 574
;574:		}
LABELV $326
line 578
;575:
;576:		// don't predict gauntlet firing, which is only supposed to happen
;577:		// when it actually inflicts damage
;578:		cg_pmove.gauntletHit = qfalse;
ADDRGP4 cg_pmove+40
CNSTI4 0
ASGNI4
line 580
;579:
;580:		if ( cg_pmove.pmove_fixed ) {
ADDRGP4 cg_pmove+216
INDIRI4
CNSTI4 0
EQI4 $413
line 581
;581:			cg_pmove.cmd.serverTime = ((cg_pmove.cmd.serverTime + pmove_msec.integer-1) / pmove_msec.integer) * pmove_msec.integer;
ADDRGP4 cg_pmove+4
ADDRGP4 cg_pmove+4
INDIRI4
ADDRGP4 pmove_msec+12
INDIRI4
ADDI4
CNSTI4 1
SUBI4
ADDRGP4 pmove_msec+12
INDIRI4
DIVI4
ADDRGP4 pmove_msec+12
INDIRI4
MULI4
ASGNI4
line 582
;582:		}
LABELV $413
line 584
;583:
;584:		Pmove (&cg_pmove);
ADDRGP4 cg_pmove
ARGP4
ADDRGP4 Pmove
CALLV
pop
line 586
;585:
;586:		moved = qtrue;
ADDRLP4 476
CNSTI4 1
ASGNI4
line 589
;587:
;588:		// add push trigger movement effects
;589:		CG_TouchTriggerPrediction();
ADDRGP4 CG_TouchTriggerPrediction
CALLV
pop
line 593
;590:
;591:		// check for predictable events that changed from previous predictions
;592:		//CG_CheckChangedPredictableEvents(&cg.predictedPlayerState);
;593:	}
LABELV $311
line 504
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $313
ADDRLP4 0
INDIRI4
ADDRLP4 472
INDIRI4
LEI4 $310
line 595
;594:
;595:	if ( cg_showmiss.integer > 1 ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 1
LEI4 $421
line 596
;596:		CG_Printf( "[%i : %i] ", cg_pmove.cmd.serverTime, cg.time );
ADDRGP4 $424
ARGP4
ADDRGP4 cg_pmove+4
INDIRI4
ARGI4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 597
;597:	}
LABELV $421
line 599
;598:
;599:	if ( !moved ) {
ADDRLP4 476
INDIRI4
CNSTI4 0
NEI4 $427
line 600
;600:		if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $241
line 601
;601:			CG_Printf( "not moved\n" );
ADDRGP4 $432
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 602
;602:		}
line 603
;603:		return;
ADDRGP4 $241
JUMPV
LABELV $427
line 607
;604:	}
;605:
;606:	// adjust for the movement of the groundentity
;607:	CG_AdjustPositionForMover( cg.predictedPlayerState.origin, 
ADDRGP4 cg+107636+20
ARGP4
ADDRGP4 cg+107636+68
INDIRI4
ARGI4
ADDRGP4 cg+107612
INDIRI4
ARGI4
ADDRGP4 cg+107604
INDIRI4
ARGI4
ADDRGP4 cg+107636+20
ARGP4
ADDRGP4 CG_AdjustPositionForMover
CALLV
pop
line 611
;608:		cg.predictedPlayerState.groundEntityNum, 
;609:		cg.physicsTime, cg.time, cg.predictedPlayerState.origin );
;610:
;611:	if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $441
line 612
;612:		if (cg.predictedPlayerState.eventSequence > oldPlayerState.eventSequence + MAX_PS_EVENTS) {
ADDRGP4 cg+107636+108
INDIRI4
ADDRLP4 4+108
INDIRI4
CNSTI4 2
ADDI4
LEI4 $444
line 613
;613:			CG_Printf("WARNING: dropped event\n");
ADDRGP4 $449
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 614
;614:		}
LABELV $444
line 615
;615:	}
LABELV $441
line 618
;616:
;617:	// fire events and other transition triggered things
;618:	CG_TransitionPlayerState( &cg.predictedPlayerState, &oldPlayerState );
ADDRGP4 cg+107636
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_TransitionPlayerState
CALLV
pop
line 620
;619:
;620:	if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $451
line 621
;621:		if (cg.eventSequence > cg.predictedPlayerState.eventSequence) {
ADDRGP4 cg+108852
INDIRI4
ADDRGP4 cg+107636+108
INDIRI4
LEI4 $454
line 622
;622:			CG_Printf("WARNING: double event\n");
ADDRGP4 $459
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 623
;623:			cg.eventSequence = cg.predictedPlayerState.eventSequence;
ADDRGP4 cg+108852
ADDRGP4 cg+107636+108
INDIRI4
ASGNI4
line 624
;624:		}
LABELV $454
line 625
;625:	}
LABELV $451
line 626
;626:}
LABELV $241
endproc CG_PredictPlayerState 592 20
bss
align 4
LABELV cg_triggerEntities
skip 1024
align 4
LABELV cg_numTriggerEntities
skip 4
align 4
LABELV cg_solidEntities
skip 1024
align 4
LABELV cg_numSolidEntities
skip 4
align 4
LABELV cg_pmove
skip 232
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
LABELV $459
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 58
byte 1 32
byte 1 100
byte 1 111
byte 1 117
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $449
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 58
byte 1 32
byte 1 100
byte 1 114
byte 1 111
byte 1 112
byte 1 112
byte 1 101
byte 1 100
byte 1 32
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $432
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 100
byte 1 10
byte 1 0
align 1
LABELV $424
byte 1 91
byte 1 37
byte 1 105
byte 1 32
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 93
byte 1 32
byte 1 0
align 1
LABELV $382
byte 1 68
byte 1 111
byte 1 117
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 100
byte 1 101
byte 1 99
byte 1 97
byte 1 121
byte 1 58
byte 1 32
byte 1 37
byte 1 102
byte 1 10
byte 1 0
align 1
LABELV $369
byte 1 80
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 58
byte 1 32
byte 1 37
byte 1 102
byte 1 10
byte 1 0
align 1
LABELV $354
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 101
byte 1 114
byte 1 114
byte 1 111
byte 1 114
byte 1 10
byte 1 0
align 1
LABELV $340
byte 1 80
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 84
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $305
byte 1 51
byte 1 51
byte 1 0
align 1
LABELV $301
byte 1 56
byte 1 0
align 1
LABELV $300
byte 1 112
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 95
byte 1 109
byte 1 115
byte 1 101
byte 1 99
byte 1 0
align 1
LABELV $283
byte 1 101
byte 1 120
byte 1 99
byte 1 101
byte 1 101
byte 1 100
byte 1 101
byte 1 100
byte 1 32
byte 1 80
byte 1 65
byte 1 67
byte 1 75
byte 1 69
byte 1 84
byte 1 95
byte 1 66
byte 1 65
byte 1 67
byte 1 75
byte 1 85
byte 1 80
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 99
byte 1 111
byte 1 109
byte 1 109
byte 1 97
byte 1 110
byte 1 100
byte 1 115
byte 1 10
byte 1 0
