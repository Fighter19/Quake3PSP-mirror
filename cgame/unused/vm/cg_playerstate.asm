export CG_CheckAmmo
code
proc CG_CheckAmmo 20 8
file "../cg_playerstate.c"
line 37
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
;23:// cg_playerstate.c -- this file acts on changes in a new playerState_t
;24:// With normal play, this will be done after local prediction, but when
;25:// following another player or playing back a demo, it will be checked
;26:// when the snapshot transitions like all the other entities
;27:
;28:#include "cg_local.h"
;29:
;30:/*
;31:==============
;32:CG_CheckAmmo
;33:
;34:If the ammo has gone low enough to generate the warning, play a sound
;35:==============
;36:*/
;37:void CG_CheckAmmo( void ) {
line 44
;38:	int		i;
;39:	int		total;
;40:	int		previous;
;41:	int		weapons;
;42:
;43:	// see about how many seconds of ammo we have remaining
;44:	weapons = cg.snap->ps.stats[ STAT_WEAPONS ];
ADDRLP4 8
ADDRGP4 cg+36
INDIRP4
CNSTI4 236
ADDP4
INDIRI4
ASGNI4
line 45
;45:	total = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 46
;46:	for ( i = WP_MACHINEGUN ; i < WP_NUM_WEAPONS ; i++ ) {
ADDRLP4 0
CNSTI4 2
ASGNI4
LABELV $72
line 47
;47:		if ( ! ( weapons & ( 1 << i ) ) ) {
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDRLP4 0
INDIRI4
LSHI4
BANDI4
CNSTI4 0
NEI4 $76
line 48
;48:			continue;
ADDRGP4 $73
JUMPV
LABELV $76
line 50
;49:		}
;50:		switch ( i ) {
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $78
ADDRLP4 0
INDIRI4
CNSTI4 7
GTI4 $78
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $83-12
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $83
address $80
address $80
address $80
address $78
address $80
code
LABELV $80
line 58
;51:		case WP_ROCKET_LAUNCHER:
;52:		case WP_GRENADE_LAUNCHER:
;53:		case WP_RAILGUN:
;54:		case WP_SHOTGUN:
;55:#ifdef MISSIONPACK
;56:		case WP_PROX_LAUNCHER:
;57:#endif
;58:			total += cg.snap->ps.ammo[i] * 1000;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1000
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 420
ADDP4
ADDP4
INDIRI4
MULI4
ADDI4
ASGNI4
line 59
;59:			break;
ADDRGP4 $79
JUMPV
LABELV $78
line 61
;60:		default:
;61:			total += cg.snap->ps.ammo[i] * 200;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 200
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 420
ADDP4
ADDP4
INDIRI4
MULI4
ADDI4
ASGNI4
line 62
;62:			break;
LABELV $79
line 64
;63:		}
;64:		if ( total >= 5000 ) {
ADDRLP4 4
INDIRI4
CNSTI4 5000
LTI4 $85
line 65
;65:			cg.lowAmmoWarning = 0;
ADDRGP4 cg+124392
CNSTI4 0
ASGNI4
line 66
;66:			return;
ADDRGP4 $70
JUMPV
LABELV $85
line 68
;67:		}
;68:	}
LABELV $73
line 46
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 11
LTI4 $72
line 70
;69:
;70:	previous = cg.lowAmmoWarning;
ADDRLP4 12
ADDRGP4 cg+124392
INDIRI4
ASGNI4
line 72
;71:
;72:	if ( total == 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $89
line 73
;73:		cg.lowAmmoWarning = 2;
ADDRGP4 cg+124392
CNSTI4 2
ASGNI4
line 74
;74:	} else {
ADDRGP4 $90
JUMPV
LABELV $89
line 75
;75:		cg.lowAmmoWarning = 1;
ADDRGP4 cg+124392
CNSTI4 1
ASGNI4
line 76
;76:	}
LABELV $90
line 79
;77:
;78:	// play a sound on transitions
;79:	if ( cg.lowAmmoWarning != previous ) {
ADDRGP4 cg+124392
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $93
line 80
;80:		trap_S_StartLocalSound( cgs.media.noAmmoSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+720
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 81
;81:	}
LABELV $93
line 82
;82:}
LABELV $70
endproc CG_CheckAmmo 20 8
export CG_DamageFeedback
proc CG_DamageFeedback 72 16
line 89
;83:
;84:/*
;85:==============
;86:CG_DamageFeedback
;87:==============
;88:*/
;89:void CG_DamageFeedback( int yawByte, int pitchByte, int damage ) {
line 100
;90:	float		left, front, up;
;91:	float		kick;
;92:	int			health;
;93:	float		scale;
;94:	vec3_t		dir;
;95:	vec3_t		angles;
;96:	float		dist;
;97:	float		yaw, pitch;
;98:
;99:	// show the attacking player's head and name in corner
;100:	cg.attackerTime = cg.time;
ADDRGP4 cg+124416
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 103
;101:
;102:	// the lower on health you are, the greater the view kick will be
;103:	health = cg.snap->ps.stats[STAT_HEALTH];
ADDRLP4 20
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
ASGNI4
line 104
;104:	if ( health < 40 ) {
ADDRLP4 20
INDIRI4
CNSTI4 40
GEI4 $102
line 105
;105:		scale = 1;
ADDRLP4 28
CNSTF4 1065353216
ASGNF4
line 106
;106:	} else {
ADDRGP4 $103
JUMPV
LABELV $102
line 107
;107:		scale = 40.0 / health;
ADDRLP4 28
CNSTF4 1109393408
ADDRLP4 20
INDIRI4
CVIF4 4
DIVF4
ASGNF4
line 108
;108:	}
LABELV $103
line 109
;109:	kick = damage * scale;
ADDRLP4 12
ADDRFP4 8
INDIRI4
CVIF4 4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 111
;110:
;111:	if (kick < 5)
ADDRLP4 12
INDIRF4
CNSTF4 1084227584
GEF4 $104
line 112
;112:		kick = 5;
ADDRLP4 12
CNSTF4 1084227584
ASGNF4
LABELV $104
line 113
;113:	if (kick > 10)
ADDRLP4 12
INDIRF4
CNSTF4 1092616192
LEF4 $106
line 114
;114:		kick = 10;
ADDRLP4 12
CNSTF4 1092616192
ASGNF4
LABELV $106
line 117
;115:
;116:	// if yaw and pitch are both 255, make the damage always centered (falling, etc)
;117:	if ( yawByte == 255 && pitchByte == 255 ) {
ADDRLP4 60
CNSTI4 255
ASGNI4
ADDRFP4 0
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $108
ADDRFP4 4
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $108
line 118
;118:		cg.damageX = 0;
ADDRGP4 cg+124692
CNSTF4 0
ASGNF4
line 119
;119:		cg.damageY = 0;
ADDRGP4 cg+124696
CNSTF4 0
ASGNF4
line 120
;120:		cg.v_dmg_roll = 0;
ADDRGP4 cg+124740
CNSTF4 0
ASGNF4
line 121
;121:		cg.v_dmg_pitch = -kick;
ADDRGP4 cg+124736
ADDRLP4 12
INDIRF4
NEGF4
ASGNF4
line 122
;122:	} else {
ADDRGP4 $109
JUMPV
LABELV $108
line 124
;123:		// positional
;124:		pitch = pitchByte / 255.0 * 360;
ADDRLP4 56
CNSTF4 1135869952
ADDRFP4 4
INDIRI4
CVIF4 4
CNSTF4 1132396544
DIVF4
MULF4
ASGNF4
line 125
;125:		yaw = yawByte / 255.0 * 360;
ADDRLP4 52
CNSTF4 1135869952
ADDRFP4 0
INDIRI4
CVIF4 4
CNSTF4 1132396544
DIVF4
MULF4
ASGNF4
line 127
;126:
;127:		angles[PITCH] = pitch;
ADDRLP4 32
ADDRLP4 56
INDIRF4
ASGNF4
line 128
;128:		angles[YAW] = yaw;
ADDRLP4 32+4
ADDRLP4 52
INDIRF4
ASGNF4
line 129
;129:		angles[ROLL] = 0;
ADDRLP4 32+8
CNSTF4 0
ASGNF4
line 131
;130:
;131:		AngleVectors( angles, dir, NULL, NULL );
ADDRLP4 32
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 64
CNSTP4 0
ASGNP4
ADDRLP4 64
INDIRP4
ARGP4
ADDRLP4 64
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 132
;132:		VectorSubtract( vec3_origin, dir, dir );
ADDRLP4 0
ADDRGP4 vec3_origin
INDIRF4
ADDRLP4 0
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRGP4 vec3_origin+4
INDIRF4
ADDRLP4 0+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+8
ADDRGP4 vec3_origin+8
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
ASGNF4
line 134
;133:
;134:		front = DotProduct (dir, cg.refdef.viewaxis[0] );
ADDRLP4 16
ADDRLP4 0
INDIRF4
ADDRGP4 cg+109044+36
INDIRF4
MULF4
ADDRLP4 0+4
INDIRF4
ADDRGP4 cg+109044+36+4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+8
INDIRF4
ADDRGP4 cg+109044+36+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 135
;135:		left = DotProduct (dir, cg.refdef.viewaxis[1] );
ADDRLP4 24
ADDRLP4 0
INDIRF4
ADDRGP4 cg+109044+36+12
INDIRF4
MULF4
ADDRLP4 0+4
INDIRF4
ADDRGP4 cg+109044+36+12+4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+8
INDIRF4
ADDRGP4 cg+109044+36+12+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 136
;136:		up = DotProduct (dir, cg.refdef.viewaxis[2] );
ADDRLP4 48
ADDRLP4 0
INDIRF4
ADDRGP4 cg+109044+36+24
INDIRF4
MULF4
ADDRLP4 0+4
INDIRF4
ADDRGP4 cg+109044+36+24+4
INDIRF4
MULF4
ADDF4
ADDRLP4 0+8
INDIRF4
ADDRGP4 cg+109044+36+24+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 138
;137:
;138:		dir[0] = front;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 139
;139:		dir[1] = left;
ADDRLP4 0+4
ADDRLP4 24
INDIRF4
ASGNF4
line 140
;140:		dir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 141
;141:		dist = VectorLength( dir );
ADDRLP4 0
ARGP4
ADDRLP4 68
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 44
ADDRLP4 68
INDIRF4
ASGNF4
line 142
;142:		if ( dist < 0.1 ) {
ADDRLP4 44
INDIRF4
CNSTF4 1036831949
GEF4 $160
line 143
;143:			dist = 0.1f;
ADDRLP4 44
CNSTF4 1036831949
ASGNF4
line 144
;144:		}
LABELV $160
line 146
;145:
;146:		cg.v_dmg_roll = kick * left;
ADDRGP4 cg+124740
ADDRLP4 12
INDIRF4
ADDRLP4 24
INDIRF4
MULF4
ASGNF4
line 148
;147:		
;148:		cg.v_dmg_pitch = -kick * front;
ADDRGP4 cg+124736
ADDRLP4 12
INDIRF4
NEGF4
ADDRLP4 16
INDIRF4
MULF4
ASGNF4
line 150
;149:
;150:		if ( front <= 0.1 ) {
ADDRLP4 16
INDIRF4
CNSTF4 1036831949
GTF4 $164
line 151
;151:			front = 0.1f;
ADDRLP4 16
CNSTF4 1036831949
ASGNF4
line 152
;152:		}
LABELV $164
line 153
;153:		cg.damageX = -left / front;
ADDRGP4 cg+124692
ADDRLP4 24
INDIRF4
NEGF4
ADDRLP4 16
INDIRF4
DIVF4
ASGNF4
line 154
;154:		cg.damageY = up / dist;
ADDRGP4 cg+124696
ADDRLP4 48
INDIRF4
ADDRLP4 44
INDIRF4
DIVF4
ASGNF4
line 155
;155:	}
LABELV $109
line 158
;156:
;157:	// clamp the position
;158:	if ( cg.damageX > 1.0 ) {
ADDRGP4 cg+124692
INDIRF4
CNSTF4 1065353216
LEF4 $168
line 159
;159:		cg.damageX = 1.0;
ADDRGP4 cg+124692
CNSTF4 1065353216
ASGNF4
line 160
;160:	}
LABELV $168
line 161
;161:	if ( cg.damageX < - 1.0 ) {
ADDRGP4 cg+124692
INDIRF4
CNSTF4 3212836864
GEF4 $172
line 162
;162:		cg.damageX = -1.0;
ADDRGP4 cg+124692
CNSTF4 3212836864
ASGNF4
line 163
;163:	}
LABELV $172
line 165
;164:
;165:	if ( cg.damageY > 1.0 ) {
ADDRGP4 cg+124696
INDIRF4
CNSTF4 1065353216
LEF4 $176
line 166
;166:		cg.damageY = 1.0;
ADDRGP4 cg+124696
CNSTF4 1065353216
ASGNF4
line 167
;167:	}
LABELV $176
line 168
;168:	if ( cg.damageY < - 1.0 ) {
ADDRGP4 cg+124696
INDIRF4
CNSTF4 3212836864
GEF4 $180
line 169
;169:		cg.damageY = -1.0;
ADDRGP4 cg+124696
CNSTF4 3212836864
ASGNF4
line 170
;170:	}
LABELV $180
line 173
;171:
;172:	// don't let the screen flashes vary as much
;173:	if ( kick > 10 ) {
ADDRLP4 12
INDIRF4
CNSTF4 1092616192
LEF4 $184
line 174
;174:		kick = 10;
ADDRLP4 12
CNSTF4 1092616192
ASGNF4
line 175
;175:	}
LABELV $184
line 176
;176:	cg.damageValue = kick;
ADDRGP4 cg+124700
ADDRLP4 12
INDIRF4
ASGNF4
line 177
;177:	cg.v_dmg_time = cg.time + DAMAGE_TIME;
ADDRGP4 cg+124732
ADDRGP4 cg+107604
INDIRI4
CNSTI4 500
ADDI4
CVIF4 4
ASGNF4
line 178
;178:	cg.damageTime = cg.snap->serverTime;
ADDRGP4 cg+124688
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CVIF4 4
ASGNF4
line 179
;179:}
LABELV $98
endproc CG_DamageFeedback 72 16
export CG_Respawn
proc CG_Respawn 0 0
line 191
;180:
;181:
;182:
;183:
;184:/*
;185:================
;186:CG_Respawn
;187:
;188:A respawn happened this snapshot
;189:================
;190:*/
;191:void CG_Respawn( void ) {
line 193
;192:	// no error decay on player movement
;193:	cg.thisFrameTeleport = qtrue;
ADDRGP4 cg+107592
CNSTI4 1
ASGNI4
line 196
;194:
;195:	// display weapons available
;196:	cg.weaponSelectTime = cg.time;
ADDRGP4 cg+124676
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 199
;197:
;198:	// select the weapon the server says we are using
;199:	cg.weaponSelect = cg.snap->ps.weapon;
ADDRGP4 cg+108944
ADDRGP4 cg+36
INDIRP4
CNSTI4 188
ADDP4
INDIRI4
ASGNI4
line 200
;200:}
LABELV $191
endproc CG_Respawn 0 0
export CG_CheckPlayerstateEvents
proc CG_CheckPlayerstateEvents 52 8
line 209
;201:
;202:extern char *eventnames[];
;203:
;204:/*
;205:==============
;206:CG_CheckPlayerstateEvents
;207:==============
;208:*/
;209:void CG_CheckPlayerstateEvents( playerState_t *ps, playerState_t *ops ) {
line 214
;210:	int			i;
;211:	int			event;
;212:	centity_t	*cent;
;213:
;214:	if ( ps->externalEvent && ps->externalEvent != ops->externalEvent ) {
ADDRLP4 12
CNSTI4 128
ASGNI4
ADDRLP4 16
ADDRFP4 0
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $198
ADDRLP4 16
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
EQI4 $198
line 215
;215:		cent = &cg_entities[ ps->clientNum ];
ADDRLP4 4
CNSTI4 728
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 216
;216:		cent->currentState.event = ps->externalEvent;
ADDRLP4 4
INDIRP4
CNSTI4 180
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 128
ADDP4
INDIRI4
ASGNI4
line 217
;217:		cent->currentState.eventParm = ps->externalEventParm;
ADDRLP4 4
INDIRP4
CNSTI4 184
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 132
ADDP4
INDIRI4
ASGNI4
line 218
;218:		CG_EntityEvent( cent, cent->lerpOrigin );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 CG_EntityEvent
CALLV
pop
line 219
;219:	}
LABELV $198
line 221
;220:
;221:	cent = &cg.predictedPlayerEntity; // cg_entities[ ps->clientNum ];
ADDRLP4 4
ADDRGP4 cg+108104
ASGNP4
line 223
;222:	// go through the predictable events buffer
;223:	for ( i = ps->eventSequence - MAX_PS_EVENTS ; i < ps->eventSequence ; i++ ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 2
SUBI4
ASGNI4
ADDRGP4 $204
JUMPV
LABELV $201
line 225
;224:		// if we have a new predictable event
;225:		if ( i >= ops->eventSequence
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 28
ADDRLP4 24
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 28
INDIRI4
GEI4 $207
ADDRLP4 32
CNSTI4 2
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 28
INDIRI4
ADDRLP4 32
INDIRI4
SUBI4
LEI4 $205
ADDRLP4 36
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
ADDRLP4 32
INDIRI4
LSHI4
ASGNI4
ADDRLP4 40
CNSTI4 112
ASGNI4
ADDRLP4 36
INDIRI4
ADDRFP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
ADDRLP4 24
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
ADDP4
INDIRI4
EQI4 $205
LABELV $207
line 228
;226:			// or the server told us to play another event instead of a predicted event we already issued
;227:			// or something the server told us changed our prediction causing a different event
;228:			|| (i > ops->eventSequence - MAX_PS_EVENTS && ps->events[i & (MAX_PS_EVENTS-1)] != ops->events[i & (MAX_PS_EVENTS-1)]) ) {
line 230
;229:
;230:			event = ps->events[ i & (MAX_PS_EVENTS-1) ];
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDP4
INDIRI4
ASGNI4
line 231
;231:			cent->currentState.event = event;
ADDRLP4 4
INDIRP4
CNSTI4 180
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 232
;232:			cent->currentState.eventParm = ps->eventParms[ i & (MAX_PS_EVENTS-1) ];
ADDRLP4 4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
ADDP4
INDIRI4
ASGNI4
line 233
;233:			CG_EntityEvent( cent, cent->lerpOrigin );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 CG_EntityEvent
CALLV
pop
line 235
;234:
;235:			cg.predictableEvents[ i & (MAX_PREDICTED_EVENTS-1) ] = event;
ADDRLP4 0
INDIRI4
CNSTI4 15
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 cg+108856
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 237
;236:
;237:			cg.eventSequence++;
ADDRLP4 48
ADDRGP4 cg+108852
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 48
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 238
;238:		}
LABELV $205
line 239
;239:	}
LABELV $202
line 223
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $204
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
LTI4 $201
line 240
;240:}
LABELV $197
endproc CG_CheckPlayerstateEvents 52 8
export CG_CheckChangedPredictableEvents
proc CG_CheckChangedPredictableEvents 24 8
line 247
;241:
;242:/*
;243:==================
;244:CG_CheckChangedPredictableEvents
;245:==================
;246:*/
;247:void CG_CheckChangedPredictableEvents( playerState_t *ps ) {
line 252
;248:	int i;
;249:	int event;
;250:	centity_t	*cent;
;251:
;252:	cent = &cg.predictedPlayerEntity;
ADDRLP4 4
ADDRGP4 cg+108104
ASGNP4
line 253
;253:	for ( i = ps->eventSequence - MAX_PS_EVENTS ; i < ps->eventSequence ; i++ ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
CNSTI4 2
SUBI4
ASGNI4
ADDRGP4 $215
JUMPV
LABELV $212
line 255
;254:		//
;255:		if (i >= cg.eventSequence) {
ADDRLP4 0
INDIRI4
ADDRGP4 cg+108852
INDIRI4
LTI4 $216
line 256
;256:			continue;
ADDRGP4 $213
JUMPV
LABELV $216
line 259
;257:		}
;258:		// if this event is not further back in than the maximum predictable events we remember
;259:		if (i > cg.eventSequence - MAX_PREDICTED_EVENTS) {
ADDRLP4 0
INDIRI4
ADDRGP4 cg+108852
INDIRI4
CNSTI4 16
SUBI4
LEI4 $219
line 261
;260:			// if the new playerstate event is different from a previously predicted one
;261:			if ( ps->events[i & (MAX_PS_EVENTS-1)] != cg.predictableEvents[i & (MAX_PREDICTED_EVENTS-1) ] ) {
ADDRLP4 16
CNSTI4 2
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
ADDRLP4 16
INDIRI4
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 15
BANDI4
ADDRLP4 16
INDIRI4
LSHI4
ADDRGP4 cg+108856
ADDP4
INDIRI4
EQI4 $222
line 263
;262:
;263:				event = ps->events[ i & (MAX_PS_EVENTS-1) ];
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDP4
INDIRI4
ASGNI4
line 264
;264:				cent->currentState.event = event;
ADDRLP4 4
INDIRP4
CNSTI4 180
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 265
;265:				cent->currentState.eventParm = ps->eventParms[ i & (MAX_PS_EVENTS-1) ];
ADDRLP4 4
INDIRP4
CNSTI4 184
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 120
ADDP4
ADDP4
INDIRI4
ASGNI4
line 266
;266:				CG_EntityEvent( cent, cent->lerpOrigin );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 CG_EntityEvent
CALLV
pop
line 268
;267:
;268:				cg.predictableEvents[ i & (MAX_PREDICTED_EVENTS-1) ] = event;
ADDRLP4 0
INDIRI4
CNSTI4 15
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 cg+108856
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 270
;269:
;270:				if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $226
line 271
;271:					CG_Printf("WARNING: changed predicted event\n");
ADDRGP4 $229
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 272
;272:				}
LABELV $226
line 273
;273:			}
LABELV $222
line 274
;274:		}
LABELV $219
line 275
;275:	}
LABELV $213
line 253
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $215
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
LTI4 $212
line 276
;276:}
LABELV $210
endproc CG_CheckChangedPredictableEvents 24 8
proc pushReward 4 0
line 283
;277:
;278:/*
;279:==================
;280:pushReward
;281:==================
;282:*/
;283:static void pushReward(sfxHandle_t sfx, qhandle_t shader, int rewardCount) {
line 284
;284:	if (cg.rewardStack < (MAX_REWARDSTACK-1)) {
ADDRGP4 cg+124424
INDIRI4
CNSTI4 9
GEI4 $231
line 285
;285:		cg.rewardStack++;
ADDRLP4 0
ADDRGP4 cg+124424
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 286
;286:		cg.rewardSound[cg.rewardStack] = sfx;
ADDRGP4 cg+124424
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124512
ADDP4
ADDRFP4 0
INDIRI4
ASGNI4
line 287
;287:		cg.rewardShader[cg.rewardStack] = shader;
ADDRGP4 cg+124424
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124472
ADDP4
ADDRFP4 4
INDIRI4
ASGNI4
line 288
;288:		cg.rewardCount[cg.rewardStack] = rewardCount;
ADDRGP4 cg+124424
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cg+124432
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 289
;289:	}
LABELV $231
line 290
;290:}
LABELV $230
endproc pushReward 4 0
export CG_CheckLocalSounds
proc CG_CheckLocalSounds 88 12
line 297
;291:
;292:/*
;293:==================
;294:CG_CheckLocalSounds
;295:==================
;296:*/
;297:void CG_CheckLocalSounds( playerState_t *ps, playerState_t *ops ) {
line 302
;298:	int			highScore, health, armor, reward;
;299:	sfxHandle_t sfx;
;300:
;301:	// don't play the sounds if the player just changed teams
;302:	if ( ps->persistant[PERS_TEAM] != ops->persistant[PERS_TEAM] ) {
ADDRLP4 20
CNSTI4 260
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
EQI4 $242
line 303
;303:		return;
ADDRGP4 $241
JUMPV
LABELV $242
line 307
;304:	}
;305:
;306:	// hit changes
;307:	if ( ps->persistant[PERS_HITS] > ops->persistant[PERS_HITS] ) {
ADDRLP4 24
CNSTI4 252
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
LEI4 $244
line 308
;308:		armor  = ps->persistant[PERS_ATTACKEE_ARMOR] & 0xff;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 276
ADDP4
INDIRI4
CNSTI4 255
BANDI4
ASGNI4
line 309
;309:		health = ps->persistant[PERS_ATTACKEE_ARMOR] >> 8;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 276
ADDP4
INDIRI4
CNSTI4 8
RSHI4
ASGNI4
line 319
;310:#ifdef MISSIONPACK
;311:		if (armor > 50 ) {
;312:			trap_S_StartLocalSound( cgs.media.hitSoundHighArmor, CHAN_LOCAL_SOUND );
;313:		} else if (armor || health > 100) {
;314:			trap_S_StartLocalSound( cgs.media.hitSoundLowArmor, CHAN_LOCAL_SOUND );
;315:		} else {
;316:			trap_S_StartLocalSound( cgs.media.hitSound, CHAN_LOCAL_SOUND );
;317:		}
;318:#else
;319:		trap_S_StartLocalSound( cgs.media.hitSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+768
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 321
;320:#endif
;321:	} else if ( ps->persistant[PERS_HITS] < ops->persistant[PERS_HITS] ) {
ADDRGP4 $245
JUMPV
LABELV $244
ADDRLP4 28
CNSTI4 252
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 28
INDIRI4
ADDP4
INDIRI4
GEI4 $248
line 322
;322:		trap_S_StartLocalSound( cgs.media.hitTeamSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+780
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 323
;323:	}
LABELV $248
LABELV $245
line 326
;324:
;325:	// health changes of more than -1 should make pain sounds
;326:	if ( ps->stats[STAT_HEALTH] < ops->stats[STAT_HEALTH] - 1 ) {
ADDRLP4 32
CNSTI4 184
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
CNSTI4 1
SUBI4
GEI4 $252
line 327
;327:		if ( ps->stats[STAT_HEALTH] > 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
LEI4 $254
line 328
;328:			CG_PainEvent( &cg.predictedPlayerEntity, ps->stats[STAT_HEALTH] );
ADDRGP4 cg+108104
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_PainEvent
CALLV
pop
line 329
;329:		}
LABELV $254
line 330
;330:	}
LABELV $252
line 334
;331:
;332:
;333:	// if we are going into the intermission, don't start any voices
;334:	if ( cg.intermissionStarted ) {
ADDRGP4 cg+24
INDIRI4
CNSTI4 0
EQI4 $257
line 335
;335:		return;
ADDRGP4 $241
JUMPV
LABELV $257
line 339
;336:	}
;337:
;338:	// reward sounds
;339:	reward = qfalse;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 340
;340:	if (ps->persistant[PERS_CAPTURES] != ops->persistant[PERS_CAPTURES]) {
ADDRLP4 36
CNSTI4 304
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
INDIRI4
EQI4 $260
line 341
;341:		pushReward(cgs.media.captureAwardSound, cgs.media.medalCapture, ps->persistant[PERS_CAPTURES]);
ADDRGP4 cgs+152340+868
INDIRI4
ARGI4
ADDRGP4 cgs+152340+524
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
ARGI4
ADDRGP4 pushReward
CALLV
pop
line 342
;342:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 344
;343:		//Com_Printf("capture\n");
;344:	}
LABELV $260
line 345
;345:	if (ps->persistant[PERS_IMPRESSIVE_COUNT] != ops->persistant[PERS_IMPRESSIVE_COUNT]) {
ADDRLP4 40
CNSTI4 284
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRI4
EQI4 $266
line 353
;346:#ifdef MISSIONPACK
;347:		if (ps->persistant[PERS_IMPRESSIVE_COUNT] == 1) {
;348:			sfx = cgs.media.firstImpressiveSound;
;349:		} else {
;350:			sfx = cgs.media.impressiveSound;
;351:		}
;352:#else
;353:		sfx = cgs.media.impressiveSound;
ADDRLP4 4
ADDRGP4 cgs+152340+784
INDIRI4
ASGNI4
line 355
;354:#endif
;355:		pushReward(sfx, cgs.media.medalImpressive, ps->persistant[PERS_IMPRESSIVE_COUNT]);
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 cgs+152340+504
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 284
ADDP4
INDIRI4
ARGI4
ADDRGP4 pushReward
CALLV
pop
line 356
;356:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 358
;357:		//Com_Printf("impressive\n");
;358:	}
LABELV $266
line 359
;359:	if (ps->persistant[PERS_EXCELLENT_COUNT] != ops->persistant[PERS_EXCELLENT_COUNT]) {
ADDRLP4 44
CNSTI4 288
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
INDIRI4
EQI4 $272
line 367
;360:#ifdef MISSIONPACK
;361:		if (ps->persistant[PERS_EXCELLENT_COUNT] == 1) {
;362:			sfx = cgs.media.firstExcellentSound;
;363:		} else {
;364:			sfx = cgs.media.excellentSound;
;365:		}
;366:#else
;367:		sfx = cgs.media.excellentSound;
ADDRLP4 4
ADDRGP4 cgs+152340+788
INDIRI4
ASGNI4
line 369
;368:#endif
;369:		pushReward(sfx, cgs.media.medalExcellent, ps->persistant[PERS_EXCELLENT_COUNT]);
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 cgs+152340+508
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 288
ADDP4
INDIRI4
ARGI4
ADDRGP4 pushReward
CALLV
pop
line 370
;370:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 372
;371:		//Com_Printf("excellent\n");
;372:	}
LABELV $272
line 373
;373:	if (ps->persistant[PERS_GAUNTLET_FRAG_COUNT] != ops->persistant[PERS_GAUNTLET_FRAG_COUNT]) {
ADDRLP4 48
CNSTI4 300
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRI4
EQI4 $278
line 381
;374:#ifdef MISSIONPACK
;375:		if (ops->persistant[PERS_GAUNTLET_FRAG_COUNT] == 1) {
;376:			sfx = cgs.media.firstHumiliationSound;
;377:		} else {
;378:			sfx = cgs.media.humiliationSound;
;379:		}
;380:#else
;381:		sfx = cgs.media.humiliationSound;
ADDRLP4 4
ADDRGP4 cgs+152340+796
INDIRI4
ASGNI4
line 383
;382:#endif
;383:		pushReward(sfx, cgs.media.medalGauntlet, ps->persistant[PERS_GAUNTLET_FRAG_COUNT]);
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 cgs+152340+512
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 300
ADDP4
INDIRI4
ARGI4
ADDRGP4 pushReward
CALLV
pop
line 384
;384:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 386
;385:		//Com_Printf("guantlet frag\n");
;386:	}
LABELV $278
line 387
;387:	if (ps->persistant[PERS_DEFEND_COUNT] != ops->persistant[PERS_DEFEND_COUNT]) {
ADDRLP4 52
CNSTI4 292
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRI4
EQI4 $284
line 388
;388:		pushReward(cgs.media.defendSound, cgs.media.medalDefend, ps->persistant[PERS_DEFEND_COUNT]);
ADDRGP4 cgs+152340+804
INDIRI4
ARGI4
ADDRGP4 cgs+152340+516
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 292
ADDP4
INDIRI4
ARGI4
ADDRGP4 pushReward
CALLV
pop
line 389
;389:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 391
;390:		//Com_Printf("defend\n");
;391:	}
LABELV $284
line 392
;392:	if (ps->persistant[PERS_ASSIST_COUNT] != ops->persistant[PERS_ASSIST_COUNT]) {
ADDRLP4 56
CNSTI4 296
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
INDIRI4
EQI4 $290
line 393
;393:		pushReward(cgs.media.assistSound, cgs.media.medalAssist, ps->persistant[PERS_ASSIST_COUNT]);
ADDRGP4 cgs+152340+800
INDIRI4
ARGI4
ADDRGP4 cgs+152340+520
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 296
ADDP4
INDIRI4
ARGI4
ADDRGP4 pushReward
CALLV
pop
line 394
;394:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 396
;395:		//Com_Printf("assist\n");
;396:	}
LABELV $290
line 398
;397:	// if any of the player event bits changed
;398:	if (ps->persistant[PERS_PLAYEREVENTS] != ops->persistant[PERS_PLAYEREVENTS]) {
ADDRLP4 60
CNSTI4 268
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRI4
EQI4 $296
line 399
;399:		if ((ps->persistant[PERS_PLAYEREVENTS] & PLAYEREVENT_DENIEDREWARD) !=
ADDRLP4 64
CNSTI4 268
ASGNI4
ADDRLP4 68
CNSTI4 1
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRI4
ADDRLP4 68
INDIRI4
BANDI4
ADDRFP4 4
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRI4
ADDRLP4 68
INDIRI4
BANDI4
EQI4 $298
line 400
;400:				(ops->persistant[PERS_PLAYEREVENTS] & PLAYEREVENT_DENIEDREWARD)) {
line 401
;401:			trap_S_StartLocalSound( cgs.media.deniedSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+792
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 402
;402:		}
ADDRGP4 $299
JUMPV
LABELV $298
line 403
;403:		else if ((ps->persistant[PERS_PLAYEREVENTS] & PLAYEREVENT_GAUNTLETREWARD) !=
ADDRLP4 72
CNSTI4 268
ASGNI4
ADDRLP4 76
CNSTI4 2
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
BANDI4
ADDRFP4 4
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
BANDI4
EQI4 $302
line 404
;404:				(ops->persistant[PERS_PLAYEREVENTS] & PLAYEREVENT_GAUNTLETREWARD)) {
line 405
;405:			trap_S_StartLocalSound( cgs.media.humiliationSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+796
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 406
;406:		}
ADDRGP4 $303
JUMPV
LABELV $302
line 407
;407:		else if ((ps->persistant[PERS_PLAYEREVENTS] & PLAYEREVENT_HOLYSHIT) !=
ADDRLP4 80
CNSTI4 268
ASGNI4
ADDRLP4 84
CNSTI4 4
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
BANDI4
ADDRFP4 4
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
BANDI4
EQI4 $306
line 408
;408:				(ops->persistant[PERS_PLAYEREVENTS] & PLAYEREVENT_HOLYSHIT)) {
line 409
;409:			trap_S_StartLocalSound( cgs.media.holyShitSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+952
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 410
;410:		}
LABELV $306
LABELV $303
LABELV $299
line 411
;411:		reward = qtrue;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 412
;412:	}
LABELV $296
line 415
;413:
;414:	// check for flag pickup
;415:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $310
line 416
;416:		if ((ps->powerups[PW_REDFLAG] != ops->powerups[PW_REDFLAG] && ps->powerups[PW_REDFLAG]) ||
ADDRLP4 64
CNSTI4 340
ASGNI4
ADDRLP4 68
ADDRFP4 0
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 68
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRI4
EQI4 $316
ADDRLP4 68
INDIRI4
CNSTI4 0
NEI4 $317
LABELV $316
ADDRLP4 72
CNSTI4 344
ASGNI4
ADDRLP4 76
ADDRFP4 0
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 72
INDIRI4
ADDP4
INDIRI4
EQI4 $318
ADDRLP4 76
INDIRI4
CNSTI4 0
NEI4 $317
LABELV $318
ADDRLP4 80
CNSTI4 348
ASGNI4
ADDRLP4 84
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 84
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 80
INDIRI4
ADDP4
INDIRI4
EQI4 $313
ADDRLP4 84
INDIRI4
CNSTI4 0
EQI4 $313
LABELV $317
line 419
;417:			(ps->powerups[PW_BLUEFLAG] != ops->powerups[PW_BLUEFLAG] && ps->powerups[PW_BLUEFLAG]) ||
;418:			(ps->powerups[PW_NEUTRALFLAG] != ops->powerups[PW_NEUTRALFLAG] && ps->powerups[PW_NEUTRALFLAG]) )
;419:		{
line 420
;420:			trap_S_StartLocalSound( cgs.media.youHaveFlagSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+944
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 421
;421:		}
LABELV $313
line 422
;422:	}
LABELV $310
line 425
;423:
;424:	// lead changes
;425:	if (!reward) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $321
line 427
;426:		//
;427:		if ( !cg.warmup ) {
ADDRGP4 cg+124656
INDIRI4
CNSTI4 0
NEI4 $323
line 429
;428:			// never play lead changes during warmup
;429:			if ( ps->persistant[PERS_RANK] != ops->persistant[PERS_RANK] ) {
ADDRLP4 64
CNSTI4 256
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 64
INDIRI4
ADDP4
INDIRI4
EQI4 $326
line 430
;430:				if ( cgs.gametype < GT_TEAM) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
GEI4 $328
line 431
;431:					if (  ps->persistant[PERS_RANK] == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 256
ADDP4
INDIRI4
CNSTI4 0
NEI4 $331
line 432
;432:						CG_AddBufferedSound(cgs.media.takenLeadSound);
ADDRGP4 cgs+152340+820
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 433
;433:					} else if ( ps->persistant[PERS_RANK] == RANK_TIED_FLAG ) {
ADDRGP4 $332
JUMPV
LABELV $331
ADDRFP4 0
INDIRP4
CNSTI4 256
ADDP4
INDIRI4
CNSTI4 16384
NEI4 $335
line 434
;434:						CG_AddBufferedSound(cgs.media.tiedLeadSound);
ADDRGP4 cgs+152340+824
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 435
;435:					} else if ( ( ops->persistant[PERS_RANK] & ~RANK_TIED_FLAG ) == 0 ) {
ADDRGP4 $336
JUMPV
LABELV $335
ADDRFP4 4
INDIRP4
CNSTI4 256
ADDP4
INDIRI4
CNSTI4 -16385
BANDI4
CNSTI4 0
NEI4 $339
line 436
;436:						CG_AddBufferedSound(cgs.media.lostLeadSound);
ADDRGP4 cgs+152340+828
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 437
;437:					}
LABELV $339
LABELV $336
LABELV $332
line 438
;438:				}
LABELV $328
line 439
;439:			}
LABELV $326
line 440
;440:		}
LABELV $323
line 441
;441:	}
LABELV $321
line 444
;442:
;443:	// timelimit warnings
;444:	if ( cgs.timelimit > 0 ) {
ADDRGP4 cgs+31476
INDIRI4
CNSTI4 0
LEI4 $343
line 447
;445:		int		msec;
;446:
;447:		msec = cg.time - cgs.levelStartTime;
ADDRLP4 64
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+34796
INDIRI4
SUBI4
ASGNI4
line 448
;448:		if ( !( cg.timelimitWarnings & 4 ) && msec > ( cgs.timelimit * 60 + 2 ) * 1000 ) {
ADDRGP4 cg+107616
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
NEI4 $348
ADDRLP4 64
INDIRI4
CNSTI4 1000
CNSTI4 60
ADDRGP4 cgs+31476
INDIRI4
MULI4
MULI4
CNSTI4 2000
ADDI4
LEI4 $348
line 449
;449:			cg.timelimitWarnings |= 1 | 2 | 4;
ADDRLP4 68
ADDRGP4 cg+107616
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRI4
CNSTI4 7
BORI4
ASGNI4
line 450
;450:			trap_S_StartLocalSound( cgs.media.suddenDeathSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+752
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 451
;451:		}
ADDRGP4 $349
JUMPV
LABELV $348
line 452
;452:		else if ( !( cg.timelimitWarnings & 2 ) && msec > (cgs.timelimit - 1) * 60 * 1000 ) {
ADDRGP4 cg+107616
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
NEI4 $355
ADDRLP4 64
INDIRI4
CNSTI4 1000
CNSTI4 60
ADDRGP4 cgs+31476
INDIRI4
MULI4
MULI4
CNSTI4 60000
SUBI4
LEI4 $355
line 453
;453:			cg.timelimitWarnings |= 1 | 2;
ADDRLP4 68
ADDRGP4 cg+107616
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRI4
CNSTI4 3
BORI4
ASGNI4
line 454
;454:			trap_S_StartLocalSound( cgs.media.oneMinuteSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+744
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 455
;455:		}
ADDRGP4 $356
JUMPV
LABELV $355
line 456
;456:		else if ( cgs.timelimit > 5 && !( cg.timelimitWarnings & 1 ) && msec > (cgs.timelimit - 5) * 60 * 1000 ) {
ADDRGP4 cgs+31476
INDIRI4
CNSTI4 5
LEI4 $362
ADDRGP4 cg+107616
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $362
ADDRLP4 64
INDIRI4
CNSTI4 1000
CNSTI4 60
ADDRGP4 cgs+31476
INDIRI4
MULI4
MULI4
CNSTI4 300000
SUBI4
LEI4 $362
line 457
;457:			cg.timelimitWarnings |= 1;
ADDRLP4 68
ADDRGP4 cg+107616
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 458
;458:			trap_S_StartLocalSound( cgs.media.fiveMinuteSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+748
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 459
;459:		}
LABELV $362
LABELV $356
LABELV $349
line 460
;460:	}
LABELV $343
line 463
;461:
;462:	// fraglimit warnings
;463:	if ( cgs.fraglimit > 0 && cgs.gametype < GT_CTF) {
ADDRGP4 cgs+31468
INDIRI4
CNSTI4 0
LEI4 $370
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
GEI4 $370
line 464
;464:		highScore = cgs.scores1;
ADDRLP4 8
ADDRGP4 cgs+34800
INDIRI4
ASGNI4
line 465
;465:		if ( !( cg.fraglimitWarnings & 4 ) && highScore == (cgs.fraglimit - 1) ) {
ADDRGP4 cg+107620
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
NEI4 $375
ADDRLP4 8
INDIRI4
ADDRGP4 cgs+31468
INDIRI4
CNSTI4 1
SUBI4
NEI4 $375
line 466
;466:			cg.fraglimitWarnings |= 1 | 2 | 4;
ADDRLP4 64
ADDRGP4 cg+107620
ASGNP4
ADDRLP4 64
INDIRP4
ADDRLP4 64
INDIRP4
INDIRI4
CNSTI4 7
BORI4
ASGNI4
line 467
;467:			CG_AddBufferedSound(cgs.media.oneFragSound);
ADDRGP4 cgs+152340+764
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 468
;468:		}
ADDRGP4 $376
JUMPV
LABELV $375
line 469
;469:		else if ( cgs.fraglimit > 2 && !( cg.fraglimitWarnings & 2 ) && highScore == (cgs.fraglimit - 2) ) {
ADDRLP4 64
CNSTI4 2
ASGNI4
ADDRGP4 cgs+31468
INDIRI4
ADDRLP4 64
INDIRI4
LEI4 $382
ADDRGP4 cg+107620
INDIRI4
ADDRLP4 64
INDIRI4
BANDI4
CNSTI4 0
NEI4 $382
ADDRLP4 8
INDIRI4
ADDRGP4 cgs+31468
INDIRI4
ADDRLP4 64
INDIRI4
SUBI4
NEI4 $382
line 470
;470:			cg.fraglimitWarnings |= 1 | 2;
ADDRLP4 68
ADDRGP4 cg+107620
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRI4
CNSTI4 3
BORI4
ASGNI4
line 471
;471:			CG_AddBufferedSound(cgs.media.twoFragSound);
ADDRGP4 cgs+152340+760
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 472
;472:		}
ADDRGP4 $383
JUMPV
LABELV $382
line 473
;473:		else if ( cgs.fraglimit > 3 && !( cg.fraglimitWarnings & 1 ) && highScore == (cgs.fraglimit - 3) ) {
ADDRLP4 68
CNSTI4 3
ASGNI4
ADDRGP4 cgs+31468
INDIRI4
ADDRLP4 68
INDIRI4
LEI4 $390
ADDRGP4 cg+107620
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $390
ADDRLP4 8
INDIRI4
ADDRGP4 cgs+31468
INDIRI4
ADDRLP4 68
INDIRI4
SUBI4
NEI4 $390
line 474
;474:			cg.fraglimitWarnings |= 1;
ADDRLP4 72
ADDRGP4 cg+107620
ASGNP4
ADDRLP4 72
INDIRP4
ADDRLP4 72
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 475
;475:			CG_AddBufferedSound(cgs.media.threeFragSound);
ADDRGP4 cgs+152340+756
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 476
;476:		}
LABELV $390
LABELV $383
LABELV $376
line 477
;477:	}
LABELV $370
line 478
;478:}
LABELV $241
endproc CG_CheckLocalSounds 88 12
export CG_TransitionPlayerState
proc CG_TransitionPlayerState 24 12
line 486
;479:
;480:/*
;481:===============
;482:CG_TransitionPlayerState
;483:
;484:===============
;485:*/
;486:void CG_TransitionPlayerState( playerState_t *ps, playerState_t *ops ) {
line 488
;487:	// check for changing follow mode
;488:	if ( ps->clientNum != ops->clientNum ) {
ADDRLP4 0
CNSTI4 140
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 0
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRI4
ADDP4
INDIRI4
EQI4 $399
line 489
;489:		cg.thisFrameTeleport = qtrue;
ADDRGP4 cg+107592
CNSTI4 1
ASGNI4
line 491
;490:		// make sure we don't get any unwanted transition effects
;491:		*ops = *ps;
ADDRFP4 4
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 468
line 492
;492:	}
LABELV $399
line 495
;493:
;494:	// damage events (player is getting wounded)
;495:	if ( ps->damageEvent != ops->damageEvent && ps->damageCount ) {
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
CNSTI4 168
ASGNI4
ADDRLP4 4
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRI4
EQI4 $402
ADDRLP4 4
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 0
EQI4 $402
line 496
;496:		CG_DamageFeedback( ps->damageYaw, ps->damagePitch, ps->damageCount );
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 172
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 176
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DamageFeedback
CALLV
pop
line 497
;497:	}
LABELV $402
line 500
;498:
;499:	// respawning
;500:	if ( ps->persistant[PERS_SPAWN_COUNT] != ops->persistant[PERS_SPAWN_COUNT] ) {
ADDRLP4 12
CNSTI4 264
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
EQI4 $404
line 501
;501:		CG_Respawn();
ADDRGP4 CG_Respawn
CALLV
pop
line 502
;502:	}
LABELV $404
line 504
;503:
;504:	if ( cg.mapRestart ) {
ADDRGP4 cg+107624
INDIRI4
CNSTI4 0
EQI4 $406
line 505
;505:		CG_Respawn();
ADDRGP4 CG_Respawn
CALLV
pop
line 506
;506:		cg.mapRestart = qfalse;
ADDRGP4 cg+107624
CNSTI4 0
ASGNI4
line 507
;507:	}
LABELV $406
line 509
;508:
;509:	if ( cg.snap->ps.pm_type != PM_INTERMISSION 
ADDRGP4 cg+36
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 5
EQI4 $410
ADDRFP4 0
INDIRP4
CNSTI4 260
ADDP4
INDIRI4
CNSTI4 3
EQI4 $410
line 510
;510:		&& ps->persistant[PERS_TEAM] != TEAM_SPECTATOR ) {
line 511
;511:		CG_CheckLocalSounds( ps, ops );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_CheckLocalSounds
CALLV
pop
line 512
;512:	}
LABELV $410
line 515
;513:
;514:	// check for going low on ammo
;515:	CG_CheckAmmo();
ADDRGP4 CG_CheckAmmo
CALLV
pop
line 518
;516:
;517:	// run events
;518:	CG_CheckPlayerstateEvents( ps, ops );
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_CheckPlayerstateEvents
CALLV
pop
line 521
;519:
;520:	// smooth the ducking viewheight change
;521:	if ( ps->viewheight != ops->viewheight ) {
ADDRLP4 16
CNSTI4 164
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
EQI4 $413
line 522
;522:		cg.duckChange = ps->viewheight - ops->viewheight;
ADDRLP4 20
CNSTI4 164
ASGNI4
ADDRGP4 cg+108928
ADDRFP4 0
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
SUBI4
CVIF4 4
ASGNF4
line 523
;523:		cg.duckTime = cg.time;
ADDRGP4 cg+108932
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 524
;524:	}
LABELV $413
line 525
;525:}
LABELV $398
endproc CG_TransitionPlayerState 24 12
import eventnames
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
LABELV $229
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 58
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 100
byte 1 32
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
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
