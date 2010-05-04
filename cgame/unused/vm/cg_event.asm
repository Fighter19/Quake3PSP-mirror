bss
align 1
LABELV $71
skip 64
export CG_PlaceString
code
proc CG_PlaceString 12 20
file "../cg_event.c"
line 40
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
;23:// cg_event.c -- handle entity events at snapshot or playerstate transitions
;24:
;25:#include "cg_local.h"
;26:
;27:// for the voice chats
;28:#ifdef MISSIONPACK // bk001205
;29:#include "../../ui/menudef.h"
;30:#endif
;31://==========================================================================
;32:
;33:/*
;34:===================
;35:CG_PlaceString
;36:
;37:Also called by scoreboard drawing
;38:===================
;39:*/
;40:const char	*CG_PlaceString( int rank ) {
line 44
;41:	static char	str[64];
;42:	char	*s, *t;
;43:
;44:	if ( rank & RANK_TIED_FLAG ) {
ADDRFP4 0
INDIRI4
CNSTI4 16384
BANDI4
CNSTI4 0
EQI4 $72
line 45
;45:		rank &= ~RANK_TIED_FLAG;
ADDRFP4 0
ADDRFP4 0
INDIRI4
CNSTI4 -16385
BANDI4
ASGNI4
line 46
;46:		t = "Tied for ";
ADDRLP4 4
ADDRGP4 $74
ASGNP4
line 47
;47:	} else {
ADDRGP4 $73
JUMPV
LABELV $72
line 48
;48:		t = "";
ADDRLP4 4
ADDRGP4 $75
ASGNP4
line 49
;49:	}
LABELV $73
line 51
;50:
;51:	if ( rank == 1 ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $76
line 52
;52:		s = S_COLOR_BLUE "1st" S_COLOR_WHITE;		// draw in blue
ADDRLP4 0
ADDRGP4 $78
ASGNP4
line 53
;53:	} else if ( rank == 2 ) {
ADDRGP4 $77
JUMPV
LABELV $76
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $79
line 54
;54:		s = S_COLOR_RED "2nd" S_COLOR_WHITE;		// draw in red
ADDRLP4 0
ADDRGP4 $81
ASGNP4
line 55
;55:	} else if ( rank == 3 ) {
ADDRGP4 $80
JUMPV
LABELV $79
ADDRFP4 0
INDIRI4
CNSTI4 3
NEI4 $82
line 56
;56:		s = S_COLOR_YELLOW "3rd" S_COLOR_WHITE;		// draw in yellow
ADDRLP4 0
ADDRGP4 $84
ASGNP4
line 57
;57:	} else if ( rank == 11 ) {
ADDRGP4 $83
JUMPV
LABELV $82
ADDRFP4 0
INDIRI4
CNSTI4 11
NEI4 $85
line 58
;58:		s = "11th";
ADDRLP4 0
ADDRGP4 $87
ASGNP4
line 59
;59:	} else if ( rank == 12 ) {
ADDRGP4 $86
JUMPV
LABELV $85
ADDRFP4 0
INDIRI4
CNSTI4 12
NEI4 $88
line 60
;60:		s = "12th";
ADDRLP4 0
ADDRGP4 $90
ASGNP4
line 61
;61:	} else if ( rank == 13 ) {
ADDRGP4 $89
JUMPV
LABELV $88
ADDRFP4 0
INDIRI4
CNSTI4 13
NEI4 $91
line 62
;62:		s = "13th";
ADDRLP4 0
ADDRGP4 $93
ASGNP4
line 63
;63:	} else if ( rank % 10 == 1 ) {
ADDRGP4 $92
JUMPV
LABELV $91
ADDRFP4 0
INDIRI4
CNSTI4 10
MODI4
CNSTI4 1
NEI4 $94
line 64
;64:		s = va("%ist", rank);
ADDRGP4 $96
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 65
;65:	} else if ( rank % 10 == 2 ) {
ADDRGP4 $95
JUMPV
LABELV $94
ADDRFP4 0
INDIRI4
CNSTI4 10
MODI4
CNSTI4 2
NEI4 $97
line 66
;66:		s = va("%ind", rank);
ADDRGP4 $99
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 67
;67:	} else if ( rank % 10 == 3 ) {
ADDRGP4 $98
JUMPV
LABELV $97
ADDRFP4 0
INDIRI4
CNSTI4 10
MODI4
CNSTI4 3
NEI4 $100
line 68
;68:		s = va("%ird", rank);
ADDRGP4 $102
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 69
;69:	} else {
ADDRGP4 $101
JUMPV
LABELV $100
line 70
;70:		s = va("%ith", rank);
ADDRGP4 $103
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 71
;71:	}
LABELV $101
LABELV $98
LABELV $95
LABELV $92
LABELV $89
LABELV $86
LABELV $83
LABELV $80
LABELV $77
line 73
;72:
;73:	Com_sprintf( str, sizeof( str ), "%s%s", t, s );
ADDRGP4 $71
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $104
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 74
;74:	return str;
ADDRGP4 $71
RETP4
LABELV $70
endproc CG_PlaceString 12 20
proc CG_Obituary 132 20
line 82
;75:}
;76:
;77:/*
;78:=============
;79:CG_Obituary
;80:=============
;81:*/
;82:static void CG_Obituary( entityState_t *ent ) {
line 94
;83:	int			mod;
;84:	int			target, attacker;
;85:	char		*message;
;86:	char		*message2;
;87:	const char	*targetInfo;
;88:	const char	*attackerInfo;
;89:	char		targetName[32];
;90:	char		attackerName[32];
;91:	gender_t	gender;
;92:	clientInfo_t	*ci;
;93:
;94:	target = ent->otherEntityNum;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 95
;95:	attacker = ent->otherEntityNum2;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 96
;96:	mod = ent->eventParm;
ADDRLP4 44
ADDRFP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 98
;97:
;98:	if ( target < 0 || target >= MAX_CLIENTS ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $108
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $106
LABELV $108
line 99
;99:		CG_Error( "CG_Obituary: target out of range" );
ADDRGP4 $109
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 100
;100:	}
LABELV $106
line 101
;101:	ci = &cgs.clientinfo[target];
ADDRLP4 92
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 103
;102:
;103:	if ( attacker < 0 || attacker >= MAX_CLIENTS ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $113
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $111
LABELV $113
line 104
;104:		attacker = ENTITYNUM_WORLD;
ADDRLP4 0
CNSTI4 1022
ASGNI4
line 105
;105:		attackerInfo = NULL;
ADDRLP4 52
CNSTP4 0
ASGNP4
line 106
;106:	} else {
ADDRGP4 $112
JUMPV
LABELV $111
line 107
;107:		attackerInfo = CG_ConfigString( CS_PLAYERS + attacker );
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 108
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 52
ADDRLP4 108
INDIRP4
ASGNP4
line 108
;108:	}
LABELV $112
line 110
;109:
;110:	targetInfo = CG_ConfigString( CS_PLAYERS + target );
ADDRLP4 4
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 108
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 48
ADDRLP4 108
INDIRP4
ASGNP4
line 111
;111:	if ( !targetInfo ) {
ADDRLP4 48
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $114
line 112
;112:		return;
ADDRGP4 $105
JUMPV
LABELV $114
line 114
;113:	}
;114:	Q_strncpyz( targetName, Info_ValueForKey( targetInfo, "n" ), sizeof(targetName) - 2);
ADDRLP4 48
INDIRP4
ARGP4
ADDRGP4 $116
ARGP4
ADDRLP4 112
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ARGP4
ADDRLP4 112
INDIRP4
ARGP4
CNSTI4 30
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 115
;115:	strcat( targetName, S_COLOR_WHITE );
ADDRLP4 8
ARGP4
ADDRGP4 $117
ARGP4
ADDRGP4 strcat
CALLP4
pop
line 117
;116:
;117:	message2 = "";
ADDRLP4 88
ADDRGP4 $75
ASGNP4
line 121
;118:
;119:	// check for single client messages
;120:
;121:	switch( mod ) {
ADDRLP4 44
INDIRI4
CNSTI4 14
LTI4 $118
ADDRLP4 44
INDIRI4
CNSTI4 22
GTI4 $118
ADDRLP4 44
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $136-56
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $136
address $126
address $128
address $130
address $124
address $118
address $122
address $120
address $132
address $134
code
LABELV $120
line 123
;122:	case MOD_SUICIDE:
;123:		message = "suicides";
ADDRLP4 40
ADDRGP4 $121
ASGNP4
line 124
;124:		break;
ADDRGP4 $119
JUMPV
LABELV $122
line 126
;125:	case MOD_FALLING:
;126:		message = "cratered";
ADDRLP4 40
ADDRGP4 $123
ASGNP4
line 127
;127:		break;
ADDRGP4 $119
JUMPV
LABELV $124
line 129
;128:	case MOD_CRUSH:
;129:		message = "was squished";
ADDRLP4 40
ADDRGP4 $125
ASGNP4
line 130
;130:		break;
ADDRGP4 $119
JUMPV
LABELV $126
line 132
;131:	case MOD_WATER:
;132:		message = "sank like a rock";
ADDRLP4 40
ADDRGP4 $127
ASGNP4
line 133
;133:		break;
ADDRGP4 $119
JUMPV
LABELV $128
line 135
;134:	case MOD_SLIME:
;135:		message = "melted";
ADDRLP4 40
ADDRGP4 $129
ASGNP4
line 136
;136:		break;
ADDRGP4 $119
JUMPV
LABELV $130
line 138
;137:	case MOD_LAVA:
;138:		message = "does a back flip into the lava";
ADDRLP4 40
ADDRGP4 $131
ASGNP4
line 139
;139:		break;
ADDRGP4 $119
JUMPV
LABELV $132
line 141
;140:	case MOD_TARGET_LASER:
;141:		message = "saw the light";
ADDRLP4 40
ADDRGP4 $133
ASGNP4
line 142
;142:		break;
ADDRGP4 $119
JUMPV
LABELV $134
line 144
;143:	case MOD_TRIGGER_HURT:
;144:		message = "was in the wrong place";
ADDRLP4 40
ADDRGP4 $135
ASGNP4
line 145
;145:		break;
ADDRGP4 $119
JUMPV
LABELV $118
line 147
;146:	default:
;147:		message = NULL;
ADDRLP4 40
CNSTP4 0
ASGNP4
line 148
;148:		break;
LABELV $119
line 151
;149:	}
;150:
;151:	if (attacker == target) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $138
line 152
;152:		gender = ci->gender;
ADDRLP4 96
ADDRLP4 92
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
ASGNI4
line 153
;153:		switch (mod) {
ADDRLP4 124
CNSTI4 5
ASGNI4
ADDRLP4 44
INDIRI4
ADDRLP4 124
INDIRI4
EQI4 $142
ADDRLP4 44
INDIRI4
CNSTI4 7
EQI4 $150
ADDRLP4 44
INDIRI4
CNSTI4 9
EQI4 $158
ADDRLP4 44
INDIRI4
ADDRLP4 124
INDIRI4
LTI4 $140
LABELV $175
ADDRLP4 44
INDIRI4
CNSTI4 13
EQI4 $166
ADDRGP4 $140
JUMPV
LABELV $142
line 160
;154:#ifdef MISSIONPACK
;155:		case MOD_KAMIKAZE:
;156:			message = "goes out with a bang";
;157:			break;
;158:#endif
;159:		case MOD_GRENADE_SPLASH:
;160:			if ( gender == GENDER_FEMALE )
ADDRLP4 96
INDIRI4
CNSTI4 1
NEI4 $143
line 161
;161:				message = "tripped on her own grenade";
ADDRLP4 40
ADDRGP4 $145
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $143
line 162
;162:			else if ( gender == GENDER_NEUTER )
ADDRLP4 96
INDIRI4
CNSTI4 2
NEI4 $146
line 163
;163:				message = "tripped on its own grenade";
ADDRLP4 40
ADDRGP4 $148
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $146
line 165
;164:			else
;165:				message = "tripped on his own grenade";
ADDRLP4 40
ADDRGP4 $149
ASGNP4
line 166
;166:			break;
ADDRGP4 $141
JUMPV
LABELV $150
line 168
;167:		case MOD_ROCKET_SPLASH:
;168:			if ( gender == GENDER_FEMALE )
ADDRLP4 96
INDIRI4
CNSTI4 1
NEI4 $151
line 169
;169:				message = "blew herself up";
ADDRLP4 40
ADDRGP4 $153
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $151
line 170
;170:			else if ( gender == GENDER_NEUTER )
ADDRLP4 96
INDIRI4
CNSTI4 2
NEI4 $154
line 171
;171:				message = "blew itself up";
ADDRLP4 40
ADDRGP4 $156
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $154
line 173
;172:			else
;173:				message = "blew himself up";
ADDRLP4 40
ADDRGP4 $157
ASGNP4
line 174
;174:			break;
ADDRGP4 $141
JUMPV
LABELV $158
line 176
;175:		case MOD_PLASMA_SPLASH:
;176:			if ( gender == GENDER_FEMALE )
ADDRLP4 96
INDIRI4
CNSTI4 1
NEI4 $159
line 177
;177:				message = "melted herself";
ADDRLP4 40
ADDRGP4 $161
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $159
line 178
;178:			else if ( gender == GENDER_NEUTER )
ADDRLP4 96
INDIRI4
CNSTI4 2
NEI4 $162
line 179
;179:				message = "melted itself";
ADDRLP4 40
ADDRGP4 $164
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $162
line 181
;180:			else
;181:				message = "melted himself";
ADDRLP4 40
ADDRGP4 $165
ASGNP4
line 182
;182:			break;
ADDRGP4 $141
JUMPV
LABELV $166
line 184
;183:		case MOD_BFG_SPLASH:
;184:			message = "should have used a smaller gun";
ADDRLP4 40
ADDRGP4 $167
ASGNP4
line 185
;185:			break;
ADDRGP4 $141
JUMPV
LABELV $140
line 198
;186:#ifdef MISSIONPACK
;187:		case MOD_PROXIMITY_MINE:
;188:			if( gender == GENDER_FEMALE ) {
;189:				message = "found her prox mine";
;190:			} else if ( gender == GENDER_NEUTER ) {
;191:				message = "found it's prox mine";
;192:			} else {
;193:				message = "found his prox mine";
;194:			}
;195:			break;
;196:#endif
;197:		default:
;198:			if ( gender == GENDER_FEMALE )
ADDRLP4 96
INDIRI4
CNSTI4 1
NEI4 $168
line 199
;199:				message = "killed herself";
ADDRLP4 40
ADDRGP4 $170
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $168
line 200
;200:			else if ( gender == GENDER_NEUTER )
ADDRLP4 96
INDIRI4
CNSTI4 2
NEI4 $171
line 201
;201:				message = "killed itself";
ADDRLP4 40
ADDRGP4 $173
ASGNP4
ADDRGP4 $141
JUMPV
LABELV $171
line 203
;202:			else
;203:				message = "killed himself";
ADDRLP4 40
ADDRGP4 $174
ASGNP4
line 204
;204:			break;
LABELV $141
line 206
;205:		}
;206:	}
LABELV $138
line 208
;207:
;208:	if (message) {
ADDRLP4 40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $176
line 209
;209:		CG_Printf( "%s %s.\n", targetName, message);
ADDRGP4 $178
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 40
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 210
;210:		return;
ADDRGP4 $105
JUMPV
LABELV $176
line 214
;211:	}
;212:
;213:	// check for kill messages from the current clientNum
;214:	if ( attacker == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $179
line 217
;215:		char	*s;
;216:
;217:		if ( cgs.gametype < GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
GEI4 $182
line 218
;218:			s = va("You fragged %s\n%s place with %i", targetName, 
ADDRGP4 cg+36
INDIRP4
CNSTI4 300
ADDP4
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRLP4 124
ADDRGP4 CG_PlaceString
CALLP4
ASGNP4
ADDRGP4 $185
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 124
INDIRP4
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 292
ADDP4
INDIRI4
ARGI4
ADDRLP4 128
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 120
ADDRLP4 128
INDIRP4
ASGNP4
line 221
;219:				CG_PlaceString( cg.snap->ps.persistant[PERS_RANK] + 1 ),
;220:				cg.snap->ps.persistant[PERS_SCORE] );
;221:		} else {
ADDRGP4 $183
JUMPV
LABELV $182
line 222
;222:			s = va("You fragged %s", targetName );
ADDRGP4 $188
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 124
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 120
ADDRLP4 124
INDIRP4
ASGNP4
line 223
;223:		}
LABELV $183
line 229
;224:#ifdef MISSIONPACK
;225:		if (!(cg_singlePlayerActive.integer && cg_cameraOrbit.integer)) {
;226:			CG_CenterPrint( s, SCREEN_HEIGHT * 0.30, BIGCHAR_WIDTH );
;227:		} 
;228:#else
;229:		CG_CenterPrint( s, SCREEN_HEIGHT * 0.30, BIGCHAR_WIDTH );
ADDRLP4 120
INDIRP4
ARGP4
CNSTI4 144
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 CG_CenterPrint
CALLV
pop
line 233
;230:#endif
;231:
;232:		// print the text message as well
;233:	}
LABELV $179
line 236
;234:
;235:	// check for double client messages
;236:	if ( !attackerInfo ) {
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $189
line 237
;237:		attacker = ENTITYNUM_WORLD;
ADDRLP4 0
CNSTI4 1022
ASGNI4
line 238
;238:		strcpy( attackerName, "noname" );
ADDRLP4 56
ARGP4
ADDRGP4 $191
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 239
;239:	} else {
ADDRGP4 $190
JUMPV
LABELV $189
line 240
;240:		Q_strncpyz( attackerName, Info_ValueForKey( attackerInfo, "n" ), sizeof(attackerName) - 2);
ADDRLP4 52
INDIRP4
ARGP4
ADDRGP4 $116
ARGP4
ADDRLP4 120
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 56
ARGP4
ADDRLP4 120
INDIRP4
ARGP4
CNSTI4 30
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 241
;241:		strcat( attackerName, S_COLOR_WHITE );
ADDRLP4 56
ARGP4
ADDRGP4 $117
ARGP4
ADDRGP4 strcat
CALLP4
pop
line 243
;242:		// check for kill messages about the current clientNum
;243:		if ( target == cg.snap->ps.clientNum ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $192
line 244
;244:			Q_strncpyz( cg.killerName, attackerName, sizeof( cg.killerName ) );
ADDRGP4 cg+114332
ARGP4
ADDRLP4 56
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 245
;245:		}
LABELV $192
line 246
;246:	}
LABELV $190
line 248
;247:
;248:	if ( attacker != ENTITYNUM_WORLD ) {
ADDRLP4 0
INDIRI4
CNSTI4 1022
EQI4 $197
line 249
;249:		switch (mod) {
ADDRLP4 44
INDIRI4
CNSTI4 1
LTI4 $199
ADDRLP4 44
INDIRI4
CNSTI4 23
GTI4 $199
ADDRLP4 44
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $234-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $234
address $207
address $203
address $205
address $209
address $212
address $215
address $217
address $219
address $222
address $223
address $225
address $227
address $227
address $199
address $199
address $199
address $199
address $230
address $199
address $199
address $199
address $199
address $201
code
LABELV $201
line 251
;250:		case MOD_GRAPPLE:
;251:			message = "was caught by";
ADDRLP4 40
ADDRGP4 $202
ASGNP4
line 252
;252:			break;
ADDRGP4 $200
JUMPV
LABELV $203
line 254
;253:		case MOD_GAUNTLET:
;254:			message = "was pummeled by";
ADDRLP4 40
ADDRGP4 $204
ASGNP4
line 255
;255:			break;
ADDRGP4 $200
JUMPV
LABELV $205
line 257
;256:		case MOD_MACHINEGUN:
;257:			message = "was machinegunned by";
ADDRLP4 40
ADDRGP4 $206
ASGNP4
line 258
;258:			break;
ADDRGP4 $200
JUMPV
LABELV $207
line 260
;259:		case MOD_SHOTGUN:
;260:			message = "was gunned down by";
ADDRLP4 40
ADDRGP4 $208
ASGNP4
line 261
;261:			break;
ADDRGP4 $200
JUMPV
LABELV $209
line 263
;262:		case MOD_GRENADE:
;263:			message = "ate";
ADDRLP4 40
ADDRGP4 $210
ASGNP4
line 264
;264:			message2 = "'s grenade";
ADDRLP4 88
ADDRGP4 $211
ASGNP4
line 265
;265:			break;
ADDRGP4 $200
JUMPV
LABELV $212
line 267
;266:		case MOD_GRENADE_SPLASH:
;267:			message = "was shredded by";
ADDRLP4 40
ADDRGP4 $213
ASGNP4
line 268
;268:			message2 = "'s shrapnel";
ADDRLP4 88
ADDRGP4 $214
ASGNP4
line 269
;269:			break;
ADDRGP4 $200
JUMPV
LABELV $215
line 271
;270:		case MOD_ROCKET:
;271:			message = "ate";
ADDRLP4 40
ADDRGP4 $210
ASGNP4
line 272
;272:			message2 = "'s rocket";
ADDRLP4 88
ADDRGP4 $216
ASGNP4
line 273
;273:			break;
ADDRGP4 $200
JUMPV
LABELV $217
line 275
;274:		case MOD_ROCKET_SPLASH:
;275:			message = "almost dodged";
ADDRLP4 40
ADDRGP4 $218
ASGNP4
line 276
;276:			message2 = "'s rocket";
ADDRLP4 88
ADDRGP4 $216
ASGNP4
line 277
;277:			break;
ADDRGP4 $200
JUMPV
LABELV $219
line 279
;278:		case MOD_PLASMA:
;279:			message = "was melted by";
ADDRLP4 40
ADDRGP4 $220
ASGNP4
line 280
;280:			message2 = "'s plasmagun";
ADDRLP4 88
ADDRGP4 $221
ASGNP4
line 281
;281:			break;
ADDRGP4 $200
JUMPV
LABELV $222
line 283
;282:		case MOD_PLASMA_SPLASH:
;283:			message = "was melted by";
ADDRLP4 40
ADDRGP4 $220
ASGNP4
line 284
;284:			message2 = "'s plasmagun";
ADDRLP4 88
ADDRGP4 $221
ASGNP4
line 285
;285:			break;
ADDRGP4 $200
JUMPV
LABELV $223
line 287
;286:		case MOD_RAILGUN:
;287:			message = "was railed by";
ADDRLP4 40
ADDRGP4 $224
ASGNP4
line 288
;288:			break;
ADDRGP4 $200
JUMPV
LABELV $225
line 290
;289:		case MOD_LIGHTNING:
;290:			message = "was electrocuted by";
ADDRLP4 40
ADDRGP4 $226
ASGNP4
line 291
;291:			break;
ADDRGP4 $200
JUMPV
LABELV $227
line 294
;292:		case MOD_BFG:
;293:		case MOD_BFG_SPLASH:
;294:			message = "was blasted by";
ADDRLP4 40
ADDRGP4 $228
ASGNP4
line 295
;295:			message2 = "'s BFG";
ADDRLP4 88
ADDRGP4 $229
ASGNP4
line 296
;296:			break;
ADDRGP4 $200
JUMPV
LABELV $230
line 318
;297:#ifdef MISSIONPACK
;298:		case MOD_NAIL:
;299:			message = "was nailed by";
;300:			break;
;301:		case MOD_CHAINGUN:
;302:			message = "got lead poisoning from";
;303:			message2 = "'s Chaingun";
;304:			break;
;305:		case MOD_PROXIMITY_MINE:
;306:			message = "was too close to";
;307:			message2 = "'s Prox Mine";
;308:			break;
;309:		case MOD_KAMIKAZE:
;310:			message = "falls to";
;311:			message2 = "'s Kamikaze blast";
;312:			break;
;313:		case MOD_JUICED:
;314:			message = "was juiced by";
;315:			break;
;316:#endif
;317:		case MOD_TELEFRAG:
;318:			message = "tried to invade";
ADDRLP4 40
ADDRGP4 $231
ASGNP4
line 319
;319:			message2 = "'s personal space";
ADDRLP4 88
ADDRGP4 $232
ASGNP4
line 320
;320:			break;
ADDRGP4 $200
JUMPV
LABELV $199
line 322
;321:		default:
;322:			message = "was killed by";
ADDRLP4 40
ADDRGP4 $233
ASGNP4
line 323
;323:			break;
LABELV $200
line 326
;324:		}
;325:
;326:		if (message) {
ADDRLP4 40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $236
line 327
;327:			CG_Printf( "%s %s %s%s\n", 
ADDRGP4 $238
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 40
INDIRP4
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 88
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 329
;328:				targetName, message, attackerName, message2);
;329:			return;
ADDRGP4 $105
JUMPV
LABELV $236
line 331
;330:		}
;331:	}
LABELV $197
line 334
;332:
;333:	// we don't know what it was
;334:	CG_Printf( "%s died.\n", targetName );
ADDRGP4 $239
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 335
;335:}
LABELV $105
endproc CG_Obituary 132 20
proc CG_UseItem 32 16
line 344
;336:
;337://==========================================================================
;338:
;339:/*
;340:===============
;341:CG_UseItem
;342:===============
;343:*/
;344:static void CG_UseItem( centity_t *cent ) {
line 350
;345:	clientInfo_t *ci;
;346:	int			itemNum, clientNum;
;347:	gitem_t		*item;
;348:	entityState_t *es;
;349:
;350:	es = &cent->currentState;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
line 352
;351:	
;352:	itemNum = (es->event & ~EV_EVENT_BITS) - EV_USE_ITEM0;
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 -769
BANDI4
CNSTI4 24
SUBI4
ASGNI4
line 353
;353:	if ( itemNum < 0 || itemNum > HI_NUM_HOLDABLE ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $243
ADDRLP4 0
INDIRI4
CNSTI4 6
LEI4 $241
LABELV $243
line 354
;354:		itemNum = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 355
;355:	}
LABELV $241
line 358
;356:
;357:	// print a message if the local player
;358:	if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 4
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $244
line 359
;359:		if ( !itemNum ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $247
line 360
;360:			CG_CenterPrint( "No item to use", SCREEN_HEIGHT * 0.30, BIGCHAR_WIDTH );
ADDRGP4 $249
ARGP4
CNSTI4 144
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 CG_CenterPrint
CALLV
pop
line 361
;361:		} else {
ADDRGP4 $248
JUMPV
LABELV $247
line 362
;362:			item = BG_FindItemForHoldable( itemNum );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 BG_FindItemForHoldable
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 24
INDIRP4
ASGNP4
line 363
;363:			CG_CenterPrint( va("Use %s", item->pickup_name), SCREEN_HEIGHT * 0.30, BIGCHAR_WIDTH );
ADDRGP4 $250
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 28
ADDP4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
CNSTI4 144
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 CG_CenterPrint
CALLV
pop
line 364
;364:		}
LABELV $248
line 365
;365:	}
LABELV $244
line 367
;366:
;367:	switch ( itemNum ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $253
ADDRLP4 0
INDIRI4
CNSTI4 1
EQI4 $252
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $257
ADDRGP4 $251
JUMPV
LABELV $251
LABELV $253
line 370
;368:	default:
;369:	case HI_NONE:
;370:		trap_S_StartSound (NULL, es->number, CHAN_BODY, cgs.media.useNothingSound );
CNSTP4 0
ARGP4
ADDRLP4 4
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRGP4 cgs+152340+540
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 371
;371:		break;
ADDRGP4 $252
JUMPV
line 374
;372:
;373:	case HI_TELEPORTER:
;374:		break;
LABELV $257
line 377
;375:
;376:	case HI_MEDKIT:
;377:		clientNum = cent->currentState.clientNum;
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 378
;378:		if ( clientNum >= 0 && clientNum < MAX_CLIENTS ) {
ADDRLP4 28
ADDRLP4 12
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
LTI4 $258
ADDRLP4 28
INDIRI4
CNSTI4 64
GEI4 $258
line 379
;379:			ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 16
CNSTI4 1708
ADDRLP4 12
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 380
;380:			ci->medkitUsageTime = cg.time;
ADDRLP4 16
INDIRP4
CNSTI4 144
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 381
;381:		}
LABELV $258
line 382
;382:		trap_S_StartSound (NULL, es->number, CHAN_BODY, cgs.media.medkitSound );
CNSTP4 0
ARGP4
ADDRLP4 4
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRGP4 cgs+152340+860
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 383
;383:		break;
LABELV $252
line 397
;384:
;385:#ifdef MISSIONPACK
;386:	case HI_KAMIKAZE:
;387:		break;
;388:
;389:	case HI_PORTAL:
;390:		break;
;391:	case HI_INVULNERABILITY:
;392:		trap_S_StartSound (NULL, es->number, CHAN_BODY, cgs.media.useInvulnerabilitySound );
;393:		break;
;394:#endif
;395:	}
;396:
;397:}
LABELV $240
endproc CG_UseItem 32 16
proc CG_ItemPickup 0 0
line 406
;398:
;399:/*
;400:================
;401:CG_ItemPickup
;402:
;403:A new item was picked up this frame
;404:================
;405:*/
;406:static void CG_ItemPickup( int itemNum ) {
line 407
;407:	cg.itemPickup = itemNum;
ADDRGP4 cg+124664
ADDRFP4 0
INDIRI4
ASGNI4
line 408
;408:	cg.itemPickupTime = cg.time;
ADDRGP4 cg+124668
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 409
;409:	cg.itemPickupBlendTime = cg.time;
ADDRGP4 cg+124672
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 411
;410:	// see if it should be the grabbed weapon
;411:	if ( bg_itemlist[itemNum].giType == IT_WEAPON ) {
CNSTI4 52
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 bg_itemlist+36
ADDP4
INDIRI4
CNSTI4 1
NEI4 $270
line 413
;412:		// select it immediately
;413:		if ( cg_autoswitch.integer && bg_itemlist[itemNum].giTag != WP_MACHINEGUN ) {
ADDRGP4 cg_autoswitch+12
INDIRI4
CNSTI4 0
EQI4 $273
CNSTI4 52
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 bg_itemlist+40
ADDP4
INDIRI4
CNSTI4 2
EQI4 $273
line 414
;414:			cg.weaponSelectTime = cg.time;
ADDRGP4 cg+124676
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 415
;415:			cg.weaponSelect = bg_itemlist[itemNum].giTag;
ADDRGP4 cg+108944
CNSTI4 52
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 bg_itemlist+40
ADDP4
INDIRI4
ASGNI4
line 416
;416:		}
LABELV $273
line 417
;417:	}
LABELV $270
line 419
;418:
;419:}
LABELV $264
endproc CG_ItemPickup 0 0
export CG_PainEvent
proc CG_PainEvent 12 16
line 429
;420:
;421:
;422:/*
;423:================
;424:CG_PainEvent
;425:
;426:Also called by playerstate transition
;427:================
;428:*/
;429:void CG_PainEvent( centity_t *cent, int health ) {
line 433
;430:	char	*snd;
;431:
;432:	// don't do more than two pain sounds a second
;433:	if ( cg.time - cent->pe.painTime < 500 ) {
ADDRGP4 cg+107604
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRI4
SUBI4
CNSTI4 500
GEI4 $282
line 434
;434:		return;
ADDRGP4 $281
JUMPV
LABELV $282
line 437
;435:	}
;436:
;437:	if ( health < 25 ) {
ADDRFP4 4
INDIRI4
CNSTI4 25
GEI4 $285
line 438
;438:		snd = "*pain25_1.wav";
ADDRLP4 0
ADDRGP4 $287
ASGNP4
line 439
;439:	} else if ( health < 50 ) {
ADDRGP4 $286
JUMPV
LABELV $285
ADDRFP4 4
INDIRI4
CNSTI4 50
GEI4 $288
line 440
;440:		snd = "*pain50_1.wav";
ADDRLP4 0
ADDRGP4 $290
ASGNP4
line 441
;441:	} else if ( health < 75 ) {
ADDRGP4 $289
JUMPV
LABELV $288
ADDRFP4 4
INDIRI4
CNSTI4 75
GEI4 $291
line 442
;442:		snd = "*pain75_1.wav";
ADDRLP4 0
ADDRGP4 $293
ASGNP4
line 443
;443:	} else {
ADDRGP4 $292
JUMPV
LABELV $291
line 444
;444:		snd = "*pain100_1.wav";
ADDRLP4 0
ADDRGP4 $294
ASGNP4
line 445
;445:	}
LABELV $292
LABELV $289
LABELV $286
line 446
;446:	trap_S_StartSound( NULL, cent->currentState.number, CHAN_VOICE, 
ADDRFP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRFP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 450
;447:		CG_CustomSound( cent->currentState.number, snd ) );
;448:
;449:	// save pain time for programitic twitch animation
;450:	cent->pe.painTime = cg.time;
ADDRFP4 0
INDIRP4
CNSTI4 596
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 451
;451:	cent->pe.painDirection ^= 1;
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 600
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
BXORI4
ASGNI4
line 452
;452:}
LABELV $281
endproc CG_PainEvent 12 16
lit
align 4
LABELV $442
byte 4 0
byte 4 0
byte 4 1065353216
export CG_EntityEvent
code
proc CG_EntityEvent 108 48
line 465
;453:
;454:
;455:
;456:/*
;457:==============
;458:CG_EntityEvent
;459:
;460:An entity has an event value
;461:also called by CG_CheckPlayerstateEvents
;462:==============
;463:*/
;464:#define	DEBUGNAME(x) if(cg_debugEvents.integer){CG_Printf(x"\n");}
;465:void CG_EntityEvent( centity_t *cent, vec3_t position ) {
line 473
;466:	entityState_t	*es;
;467:	int				event;
;468:	vec3_t			dir;
;469:	const char		*s;
;470:	int				clientNum;
;471:	clientInfo_t	*ci;
;472:
;473:	es = &cent->currentState;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 474
;474:	event = es->event & ~EV_EVENT_BITS;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 -769
BANDI4
ASGNI4
line 476
;475:
;476:	if ( cg_debugEvents.integer ) {
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $297
line 477
;477:		CG_Printf( "ent:%3i  event:%3i ", es->number, event );
ADDRGP4 $300
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 478
;478:	}
LABELV $297
line 480
;479:
;480:	if ( !event ) {
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $301
line 481
;481:		DEBUGNAME("ZEROEVENT");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $296
ADDRGP4 $306
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 482
;482:		return;
ADDRGP4 $296
JUMPV
LABELV $301
line 485
;483:	}
;484:
;485:	clientNum = es->clientNum;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ASGNI4
line 486
;486:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $309
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $307
LABELV $309
line 487
;487:		clientNum = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 488
;488:	}
LABELV $307
line 489
;489:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 12
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 491
;490:
;491:	switch ( event ) {
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $311
ADDRLP4 8
INDIRI4
CNSTI4 76
GTI4 $311
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $922-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $922
address $313
address $323
address $334
address $345
address $356
address $407
address $407
address $407
address $407
address $367
address $381
address $393
address $437
address $449
address $460
address $467
address $474
address $481
address $487
address $505
address $519
address $527
address $534
address $539
address $544
address $549
address $554
address $559
address $564
address $569
address $574
address $579
address $584
address $589
address $594
address $599
address $604
address $609
address $311
address $635
address $628
address $614
address $621
address $643
address $696
address $705
address $716
address $686
address $681
address $659
address $664
address $669
address $674
address $691
address $311
address $840
address $848
address $848
address $848
address $854
address $859
address $872
address $885
address $898
address $654
address $311
address $311
address $311
address $311
address $311
address $311
address $311
address $311
address $912
address $907
address $454
code
LABELV $313
line 496
;492:	//
;493:	// movement generated events
;494:	//
;495:	case EV_FOOTSTEP:
;496:		DEBUGNAME("EV_FOOTSTEP");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $314
ADDRGP4 $317
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $314
line 497
;497:		if (cg_footsteps.integer) {
ADDRGP4 cg_footsteps+12
INDIRI4
CNSTI4 0
EQI4 $312
line 498
;498:			trap_S_StartSound (NULL, es->number, CHAN_BODY, 
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRLP4 40
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 2
LSHI4
ADDRLP4 12
INDIRP4
CNSTI4 508
ADDP4
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 cgs+152340+548
ADDP4
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 500
;499:				cgs.media.footsteps[ ci->footsteps ][rand()&3] );
;500:		}
line 501
;501:		break;
ADDRGP4 $312
JUMPV
LABELV $323
line 503
;502:	case EV_FOOTSTEP_METAL:
;503:		DEBUGNAME("EV_FOOTSTEP_METAL");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $324
ADDRGP4 $327
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $324
line 504
;504:		if (cg_footsteps.integer) {
ADDRGP4 cg_footsteps+12
INDIRI4
CNSTI4 0
EQI4 $312
line 505
;505:			trap_S_StartSound (NULL, es->number, CHAN_BODY, 
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRLP4 40
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+548+80
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 507
;506:				cgs.media.footsteps[ FOOTSTEP_METAL ][rand()&3] );
;507:		}
line 508
;508:		break;
ADDRGP4 $312
JUMPV
LABELV $334
line 510
;509:	case EV_FOOTSPLASH:
;510:		DEBUGNAME("EV_FOOTSPLASH");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $335
ADDRGP4 $338
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $335
line 511
;511:		if (cg_footsteps.integer) {
ADDRGP4 cg_footsteps+12
INDIRI4
CNSTI4 0
EQI4 $312
line 512
;512:			trap_S_StartSound (NULL, es->number, CHAN_BODY, 
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRLP4 40
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+548+96
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 514
;513:				cgs.media.footsteps[ FOOTSTEP_SPLASH ][rand()&3] );
;514:		}
line 515
;515:		break;
ADDRGP4 $312
JUMPV
LABELV $345
line 517
;516:	case EV_FOOTWADE:
;517:		DEBUGNAME("EV_FOOTWADE");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $346
ADDRGP4 $349
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $346
line 518
;518:		if (cg_footsteps.integer) {
ADDRGP4 cg_footsteps+12
INDIRI4
CNSTI4 0
EQI4 $312
line 519
;519:			trap_S_StartSound (NULL, es->number, CHAN_BODY, 
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRLP4 40
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+548+96
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 521
;520:				cgs.media.footsteps[ FOOTSTEP_SPLASH ][rand()&3] );
;521:		}
line 522
;522:		break;
ADDRGP4 $312
JUMPV
LABELV $356
line 524
;523:	case EV_SWIM:
;524:		DEBUGNAME("EV_SWIM");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $357
ADDRGP4 $360
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $357
line 525
;525:		if (cg_footsteps.integer) {
ADDRGP4 cg_footsteps+12
INDIRI4
CNSTI4 0
EQI4 $312
line 526
;526:			trap_S_StartSound (NULL, es->number, CHAN_BODY, 
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRLP4 40
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+548+96
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 528
;527:				cgs.media.footsteps[ FOOTSTEP_SPLASH ][rand()&3] );
;528:		}
line 529
;529:		break;
ADDRGP4 $312
JUMPV
LABELV $367
line 533
;530:
;531:
;532:	case EV_FALL_SHORT:
;533:		DEBUGNAME("EV_FALL_SHORT");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $368
ADDRGP4 $371
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $368
line 534
;534:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.landSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+732
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 535
;535:		if ( clientNum == cg.predictedPlayerState.clientNum ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+107636+140
INDIRI4
NEI4 $312
line 537
;536:			// smooth landing z changes
;537:			cg.landChange = -8;
ADDRGP4 cg+108936
CNSTF4 3238002688
ASGNF4
line 538
;538:			cg.landTime = cg.time;
ADDRGP4 cg+108940
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 539
;539:		}
line 540
;540:		break;
ADDRGP4 $312
JUMPV
LABELV $381
line 542
;541:	case EV_FALL_MEDIUM:
;542:		DEBUGNAME("EV_FALL_MEDIUM");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $382
ADDRGP4 $385
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $382
line 544
;543:		// use normal pain sound
;544:		trap_S_StartSound( NULL, es->number, CHAN_VOICE, CG_CustomSound( es->number, "*pain100_1.wav" ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 $294
ARGP4
ADDRLP4 40
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 40
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 545
;545:		if ( clientNum == cg.predictedPlayerState.clientNum ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+107636+140
INDIRI4
NEI4 $312
line 547
;546:			// smooth landing z changes
;547:			cg.landChange = -16;
ADDRGP4 cg+108936
CNSTF4 3246391296
ASGNF4
line 548
;548:			cg.landTime = cg.time;
ADDRGP4 cg+108940
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 549
;549:		}
line 550
;550:		break;
ADDRGP4 $312
JUMPV
LABELV $393
line 552
;551:	case EV_FALL_FAR:
;552:		DEBUGNAME("EV_FALL_FAR");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $394
ADDRGP4 $397
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $394
line 553
;553:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, CG_CustomSound( es->number, "*fall1.wav" ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 $398
ARGP4
ADDRLP4 44
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 44
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 554
;554:		cent->pe.painTime = cg.time;	// don't play a pain sound right after this
ADDRFP4 0
INDIRP4
CNSTI4 596
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 555
;555:		if ( clientNum == cg.predictedPlayerState.clientNum ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+107636+140
INDIRI4
NEI4 $312
line 557
;556:			// smooth landing z changes
;557:			cg.landChange = -24;
ADDRGP4 cg+108936
CNSTF4 3250585600
ASGNF4
line 558
;558:			cg.landTime = cg.time;
ADDRGP4 cg+108940
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 559
;559:		}
line 560
;560:		break;
ADDRGP4 $312
JUMPV
LABELV $407
line 566
;561:
;562:	case EV_STEP_4:
;563:	case EV_STEP_8:
;564:	case EV_STEP_12:
;565:	case EV_STEP_16:		// smooth out step up transitions
;566:		DEBUGNAME("EV_STEP");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $408
ADDRGP4 $411
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $408
line 567
;567:	{
line 572
;568:		float	oldStep;
;569:		int		delta;
;570:		int		step;
;571:
;572:		if ( clientNum != cg.predictedPlayerState.clientNum ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+107636+140
INDIRI4
EQI4 $412
line 573
;573:			break;
ADDRGP4 $312
JUMPV
LABELV $412
line 576
;574:		}
;575:		// if we are interpolating, we don't need to smooth steps
;576:		if ( cg.demoPlayback || (cg.snap->ps.pm_flags & PMF_FOLLOW) ||
ADDRLP4 60
CNSTI4 0
ASGNI4
ADDRGP4 cg+8
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $424
ADDRGP4 cg+36
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
ADDRLP4 60
INDIRI4
NEI4 $424
ADDRGP4 cg_nopredict+12
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $424
ADDRGP4 cg_synchronousClients+12
INDIRI4
ADDRLP4 60
INDIRI4
EQI4 $416
LABELV $424
line 577
;577:			cg_nopredict.integer || cg_synchronousClients.integer ) {
line 578
;578:			break;
ADDRGP4 $312
JUMPV
LABELV $416
line 581
;579:		}
;580:		// check for stepping up before a previous step is completed
;581:		delta = cg.time - cg.stepTime;
ADDRLP4 48
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+108924
INDIRI4
SUBI4
ASGNI4
line 582
;582:		if (delta < STEP_TIME) {
ADDRLP4 48
INDIRI4
CNSTI4 200
GEI4 $427
line 583
;583:			oldStep = cg.stepChange * (STEP_TIME - delta) / STEP_TIME;
ADDRLP4 52
ADDRGP4 cg+108920
INDIRF4
CNSTI4 200
ADDRLP4 48
INDIRI4
SUBI4
CVIF4 4
MULF4
CNSTF4 1128792064
DIVF4
ASGNF4
line 584
;584:		} else {
ADDRGP4 $428
JUMPV
LABELV $427
line 585
;585:			oldStep = 0;
ADDRLP4 52
CNSTF4 0
ASGNF4
line 586
;586:		}
LABELV $428
line 589
;587:
;588:		// add this amount
;589:		step = 4 * (event - EV_STEP_4 + 1 );
ADDRLP4 56
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 24
SUBI4
CNSTI4 4
ADDI4
ASGNI4
line 590
;590:		cg.stepChange = oldStep + step;
ADDRGP4 cg+108920
ADDRLP4 52
INDIRF4
ADDRLP4 56
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 591
;591:		if ( cg.stepChange > MAX_STEP_CHANGE ) {
ADDRGP4 cg+108920
INDIRF4
CNSTF4 1107296256
LEF4 $431
line 592
;592:			cg.stepChange = MAX_STEP_CHANGE;
ADDRGP4 cg+108920
CNSTF4 1107296256
ASGNF4
line 593
;593:		}
LABELV $431
line 594
;594:		cg.stepTime = cg.time;
ADDRGP4 cg+108924
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 595
;595:		break;
ADDRGP4 $312
JUMPV
LABELV $437
line 599
;596:	}
;597:
;598:	case EV_JUMP_PAD:
;599:		DEBUGNAME("EV_JUMP_PAD");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $438
ADDRGP4 $441
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $438
line 601
;600://		CG_Printf( "EV_JUMP_PAD w/effect #%i\n", es->eventParm );
;601:		{
line 603
;602:			localEntity_t	*smoke;
;603:			vec3_t			up = {0, 0, 1};
ADDRLP4 48
ADDRGP4 $442
INDIRB
ASGNB 12
line 606
;604:
;605:
;606:			smoke = CG_SmokePuff( cent->lerpOrigin, up, 
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 48
ARGP4
CNSTF4 1107296256
ARGF4
ADDRLP4 64
CNSTF4 1065353216
ASGNF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
ADDRLP4 64
INDIRF4
ARGF4
CNSTF4 1051260355
ARGF4
CNSTF4 1148846080
ARGF4
ADDRGP4 cg+107604
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 cgs+152340+276
INDIRI4
ARGI4
ADDRLP4 68
ADDRGP4 CG_SmokePuff
CALLP4
ASGNP4
ADDRLP4 60
ADDRLP4 68
INDIRP4
ASGNP4
line 613
;607:						  32, 
;608:						  1, 1, 1, 0.33f,
;609:						  1000, 
;610:						  cg.time, 0,
;611:						  LEF_PUFF_DONT_SCALE, 
;612:						  cgs.media.smokePuffShader );
;613:		}
line 616
;614:
;615:		// boing sound at origin, jump sound on player
;616:		trap_S_StartSound ( cent->lerpOrigin, -1, CHAN_VOICE, cgs.media.jumpPadSound );
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
CNSTI4 -1
ARGI4
CNSTI4 3
ARGI4
ADDRGP4 cgs+152340+740
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 617
;617:		trap_S_StartSound (NULL, es->number, CHAN_VOICE, CG_CustomSound( es->number, "*jump1.wav" ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 $448
ARGP4
ADDRLP4 48
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 48
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 618
;618:		break;
ADDRGP4 $312
JUMPV
LABELV $449
line 621
;619:
;620:	case EV_JUMP:
;621:		DEBUGNAME("EV_JUMP");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $450
ADDRGP4 $453
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $450
line 622
;622:		trap_S_StartSound (NULL, es->number, CHAN_VOICE, CG_CustomSound( es->number, "*jump1.wav" ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 $448
ARGP4
ADDRLP4 52
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 623
;623:		break;
ADDRGP4 $312
JUMPV
LABELV $454
line 625
;624:	case EV_TAUNT:
;625:		DEBUGNAME("EV_TAUNT");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $455
ADDRGP4 $458
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $455
line 626
;626:		trap_S_StartSound (NULL, es->number, CHAN_VOICE, CG_CustomSound( es->number, "*taunt.wav" ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 $459
ARGP4
ADDRLP4 56
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 56
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 627
;627:		break;
ADDRGP4 $312
JUMPV
LABELV $460
line 655
;628:#ifdef MISSIONPACK
;629:	case EV_TAUNT_YES:
;630:		DEBUGNAME("EV_TAUNT_YES");
;631:		CG_VoiceChatLocal(SAY_TEAM, qfalse, es->number, COLOR_CYAN, VOICECHAT_YES);
;632:		break;
;633:	case EV_TAUNT_NO:
;634:		DEBUGNAME("EV_TAUNT_NO");
;635:		CG_VoiceChatLocal(SAY_TEAM, qfalse, es->number, COLOR_CYAN, VOICECHAT_NO);
;636:		break;
;637:	case EV_TAUNT_FOLLOWME:
;638:		DEBUGNAME("EV_TAUNT_FOLLOWME");
;639:		CG_VoiceChatLocal(SAY_TEAM, qfalse, es->number, COLOR_CYAN, VOICECHAT_FOLLOWME);
;640:		break;
;641:	case EV_TAUNT_GETFLAG:
;642:		DEBUGNAME("EV_TAUNT_GETFLAG");
;643:		CG_VoiceChatLocal(SAY_TEAM, qfalse, es->number, COLOR_CYAN, VOICECHAT_ONGETFLAG);
;644:		break;
;645:	case EV_TAUNT_GUARDBASE:
;646:		DEBUGNAME("EV_TAUNT_GUARDBASE");
;647:		CG_VoiceChatLocal(SAY_TEAM, qfalse, es->number, COLOR_CYAN, VOICECHAT_ONDEFENSE);
;648:		break;
;649:	case EV_TAUNT_PATROL:
;650:		DEBUGNAME("EV_TAUNT_PATROL");
;651:		CG_VoiceChatLocal(SAY_TEAM, qfalse, es->number, COLOR_CYAN, VOICECHAT_ONPATROL);
;652:		break;
;653:#endif
;654:	case EV_WATER_TOUCH:
;655:		DEBUGNAME("EV_WATER_TOUCH");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $461
ADDRGP4 $464
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $461
line 656
;656:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.watrInSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+844
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 657
;657:		break;
ADDRGP4 $312
JUMPV
LABELV $467
line 659
;658:	case EV_WATER_LEAVE:
;659:		DEBUGNAME("EV_WATER_LEAVE");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $468
ADDRGP4 $471
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $468
line 660
;660:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.watrOutSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+848
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 661
;661:		break;
ADDRGP4 $312
JUMPV
LABELV $474
line 663
;662:	case EV_WATER_UNDER:
;663:		DEBUGNAME("EV_WATER_UNDER");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $475
ADDRGP4 $478
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $475
line 664
;664:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.watrUnSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+852
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 665
;665:		break;
ADDRGP4 $312
JUMPV
LABELV $481
line 667
;666:	case EV_WATER_CLEAR:
;667:		DEBUGNAME("EV_WATER_CLEAR");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $482
ADDRGP4 $485
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $482
line 668
;668:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, CG_CustomSound( es->number, "*gasp.wav" ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 $486
ARGP4
ADDRLP4 60
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 60
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 669
;669:		break;
ADDRGP4 $312
JUMPV
LABELV $487
line 672
;670:
;671:	case EV_ITEM_PICKUP:
;672:		DEBUGNAME("EV_ITEM_PICKUP");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $488
ADDRGP4 $491
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $488
line 673
;673:		{
line 677
;674:			gitem_t	*item;
;675:			int		index;
;676:
;677:			index = es->eventParm;		// player predicted
ADDRLP4 64
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 679
;678:
;679:			if ( index < 1 || index >= bg_numItems ) {
ADDRLP4 72
ADDRLP4 64
INDIRI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 1
LTI4 $494
ADDRLP4 72
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $492
LABELV $494
line 680
;680:				break;
ADDRGP4 $312
JUMPV
LABELV $492
line 682
;681:			}
;682:			item = &bg_itemlist[ index ];
ADDRLP4 68
CNSTI4 52
ADDRLP4 64
INDIRI4
MULI4
ADDRGP4 bg_itemlist
ADDP4
ASGNP4
line 686
;683:
;684:			// powerups and team items will have a separate global sound, this one
;685:			// will be played at prediction time
;686:			if ( item->giType == IT_POWERUP || item->giType == IT_TEAM) {
ADDRLP4 76
ADDRLP4 68
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 5
EQI4 $497
ADDRLP4 76
INDIRI4
CNSTI4 8
NEI4 $495
LABELV $497
line 687
;687:				trap_S_StartSound (NULL, es->number, CHAN_AUTO,	cgs.media.n_healthSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+996
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 688
;688:			} else if (item->giType == IT_PERSISTANT_POWERUP) {
ADDRGP4 $496
JUMPV
LABELV $495
ADDRLP4 68
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
CNSTI4 7
NEI4 $500
line 705
;689:#ifdef MISSIONPACK
;690:				switch (item->giTag ) {
;691:					case PW_SCOUT:
;692:						trap_S_StartSound (NULL, es->number, CHAN_AUTO,	cgs.media.scoutSound );
;693:					break;
;694:					case PW_GUARD:
;695:						trap_S_StartSound (NULL, es->number, CHAN_AUTO,	cgs.media.guardSound );
;696:					break;
;697:					case PW_DOUBLER:
;698:						trap_S_StartSound (NULL, es->number, CHAN_AUTO,	cgs.media.doublerSound );
;699:					break;
;700:					case PW_AMMOREGEN:
;701:						trap_S_StartSound (NULL, es->number, CHAN_AUTO,	cgs.media.ammoregenSound );
;702:					break;
;703:				}
;704:#endif
;705:			} else {
ADDRGP4 $501
JUMPV
LABELV $500
line 706
;706:				trap_S_StartSound (NULL, es->number, CHAN_AUTO,	trap_S_RegisterSound( item->pickup_sound, qfalse ) );
ADDRLP4 68
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 80
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 80
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 707
;707:			}
LABELV $501
LABELV $496
line 710
;708:
;709:			// show icon and name on status bar
;710:			if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $312
line 711
;711:				CG_ItemPickup( index );
ADDRLP4 64
INDIRI4
ARGI4
ADDRGP4 CG_ItemPickup
CALLV
pop
line 712
;712:			}
line 713
;713:		}
line 714
;714:		break;
ADDRGP4 $312
JUMPV
LABELV $505
line 717
;715:
;716:	case EV_GLOBAL_ITEM_PICKUP:
;717:		DEBUGNAME("EV_GLOBAL_ITEM_PICKUP");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $506
ADDRGP4 $509
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $506
line 718
;718:		{
line 722
;719:			gitem_t	*item;
;720:			int		index;
;721:
;722:			index = es->eventParm;		// player predicted
ADDRLP4 64
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 724
;723:
;724:			if ( index < 1 || index >= bg_numItems ) {
ADDRLP4 72
ADDRLP4 64
INDIRI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 1
LTI4 $512
ADDRLP4 72
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $510
LABELV $512
line 725
;725:				break;
ADDRGP4 $312
JUMPV
LABELV $510
line 727
;726:			}
;727:			item = &bg_itemlist[ index ];
ADDRLP4 68
CNSTI4 52
ADDRLP4 64
INDIRI4
MULI4
ADDRGP4 bg_itemlist
ADDP4
ASGNP4
line 729
;728:			// powerup pickups are global
;729:			if( item->pickup_sound ) {
ADDRLP4 68
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $513
line 730
;730:				trap_S_StartSound (NULL, cg.snap->ps.clientNum, CHAN_AUTO, trap_S_RegisterSound( item->pickup_sound, qfalse ) );
ADDRLP4 68
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 76
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 76
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 731
;731:			}
LABELV $513
line 734
;732:
;733:			// show icon and name on status bar
;734:			if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $312
line 735
;735:				CG_ItemPickup( index );
ADDRLP4 64
INDIRI4
ARGI4
ADDRGP4 CG_ItemPickup
CALLV
pop
line 736
;736:			}
line 737
;737:		}
line 738
;738:		break;
ADDRGP4 $312
JUMPV
LABELV $519
line 744
;739:
;740:	//
;741:	// weapon events
;742:	//
;743:	case EV_NOAMMO:
;744:		DEBUGNAME("EV_NOAMMO");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $520
ADDRGP4 $523
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $520
line 746
;745://		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.noAmmoSound );
;746:		if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $312
line 747
;747:			CG_OutOfAmmoChange();
ADDRGP4 CG_OutOfAmmoChange
CALLV
pop
line 748
;748:		}
line 749
;749:		break;
ADDRGP4 $312
JUMPV
LABELV $527
line 751
;750:	case EV_CHANGE_WEAPON:
;751:		DEBUGNAME("EV_CHANGE_WEAPON");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $528
ADDRGP4 $531
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $528
line 752
;752:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.selectSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+536
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 753
;753:		break;
ADDRGP4 $312
JUMPV
LABELV $534
line 755
;754:	case EV_FIRE_WEAPON:
;755:		DEBUGNAME("EV_FIRE_WEAPON");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $535
ADDRGP4 $538
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $535
line 756
;756:		CG_FireWeapon( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_FireWeapon
CALLV
pop
line 757
;757:		break;
ADDRGP4 $312
JUMPV
LABELV $539
line 760
;758:
;759:	case EV_USE_ITEM0:
;760:		DEBUGNAME("EV_USE_ITEM0");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $540
ADDRGP4 $543
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $540
line 761
;761:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 762
;762:		break;
ADDRGP4 $312
JUMPV
LABELV $544
line 764
;763:	case EV_USE_ITEM1:
;764:		DEBUGNAME("EV_USE_ITEM1");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $545
ADDRGP4 $548
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $545
line 765
;765:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 766
;766:		break;
ADDRGP4 $312
JUMPV
LABELV $549
line 768
;767:	case EV_USE_ITEM2:
;768:		DEBUGNAME("EV_USE_ITEM2");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $550
ADDRGP4 $553
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $550
line 769
;769:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 770
;770:		break;
ADDRGP4 $312
JUMPV
LABELV $554
line 772
;771:	case EV_USE_ITEM3:
;772:		DEBUGNAME("EV_USE_ITEM3");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $555
ADDRGP4 $558
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $555
line 773
;773:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 774
;774:		break;
ADDRGP4 $312
JUMPV
LABELV $559
line 776
;775:	case EV_USE_ITEM4:
;776:		DEBUGNAME("EV_USE_ITEM4");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $560
ADDRGP4 $563
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $560
line 777
;777:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 778
;778:		break;
ADDRGP4 $312
JUMPV
LABELV $564
line 780
;779:	case EV_USE_ITEM5:
;780:		DEBUGNAME("EV_USE_ITEM5");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $565
ADDRGP4 $568
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $565
line 781
;781:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 782
;782:		break;
ADDRGP4 $312
JUMPV
LABELV $569
line 784
;783:	case EV_USE_ITEM6:
;784:		DEBUGNAME("EV_USE_ITEM6");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $570
ADDRGP4 $573
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $570
line 785
;785:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 786
;786:		break;
ADDRGP4 $312
JUMPV
LABELV $574
line 788
;787:	case EV_USE_ITEM7:
;788:		DEBUGNAME("EV_USE_ITEM7");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $575
ADDRGP4 $578
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $575
line 789
;789:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 790
;790:		break;
ADDRGP4 $312
JUMPV
LABELV $579
line 792
;791:	case EV_USE_ITEM8:
;792:		DEBUGNAME("EV_USE_ITEM8");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $580
ADDRGP4 $583
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $580
line 793
;793:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 794
;794:		break;
ADDRGP4 $312
JUMPV
LABELV $584
line 796
;795:	case EV_USE_ITEM9:
;796:		DEBUGNAME("EV_USE_ITEM9");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $585
ADDRGP4 $588
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $585
line 797
;797:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 798
;798:		break;
ADDRGP4 $312
JUMPV
LABELV $589
line 800
;799:	case EV_USE_ITEM10:
;800:		DEBUGNAME("EV_USE_ITEM10");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $590
ADDRGP4 $593
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $590
line 801
;801:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 802
;802:		break;
ADDRGP4 $312
JUMPV
LABELV $594
line 804
;803:	case EV_USE_ITEM11:
;804:		DEBUGNAME("EV_USE_ITEM11");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $595
ADDRGP4 $598
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $595
line 805
;805:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 806
;806:		break;
ADDRGP4 $312
JUMPV
LABELV $599
line 808
;807:	case EV_USE_ITEM12:
;808:		DEBUGNAME("EV_USE_ITEM12");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $600
ADDRGP4 $603
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $600
line 809
;809:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 810
;810:		break;
ADDRGP4 $312
JUMPV
LABELV $604
line 812
;811:	case EV_USE_ITEM13:
;812:		DEBUGNAME("EV_USE_ITEM13");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $605
ADDRGP4 $608
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $605
line 813
;813:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 814
;814:		break;
ADDRGP4 $312
JUMPV
LABELV $609
line 816
;815:	case EV_USE_ITEM14:
;816:		DEBUGNAME("EV_USE_ITEM14");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $610
ADDRGP4 $613
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $610
line 817
;817:		CG_UseItem( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_UseItem
CALLV
pop
line 818
;818:		break;
ADDRGP4 $312
JUMPV
LABELV $614
line 826
;819:
;820:	//=================================================================
;821:
;822:	//
;823:	// other events
;824:	//
;825:	case EV_PLAYER_TELEPORT_IN:
;826:		DEBUGNAME("EV_PLAYER_TELEPORT_IN");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $615
ADDRGP4 $618
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $615
line 827
;827:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.teleInSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+712
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 828
;828:		CG_SpawnEffect( position);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_SpawnEffect
CALLV
pop
line 829
;829:		break;
ADDRGP4 $312
JUMPV
LABELV $621
line 832
;830:
;831:	case EV_PLAYER_TELEPORT_OUT:
;832:		DEBUGNAME("EV_PLAYER_TELEPORT_OUT");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $622
ADDRGP4 $625
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $622
line 833
;833:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.teleOutSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+716
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 834
;834:		CG_SpawnEffect(  position);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 CG_SpawnEffect
CALLV
pop
line 835
;835:		break;
ADDRGP4 $312
JUMPV
LABELV $628
line 838
;836:
;837:	case EV_ITEM_POP:
;838:		DEBUGNAME("EV_ITEM_POP");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $629
ADDRGP4 $632
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $629
line 839
;839:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.respawnSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+724
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 840
;840:		break;
ADDRGP4 $312
JUMPV
LABELV $635
line 842
;841:	case EV_ITEM_RESPAWN:
;842:		DEBUGNAME("EV_ITEM_RESPAWN");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $636
ADDRGP4 $639
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $636
line 843
;843:		cent->miscTime = cg.time;	// scale up from this
ADDRFP4 0
INDIRP4
CNSTI4 444
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 844
;844:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.respawnSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+724
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 845
;845:		break;
ADDRGP4 $312
JUMPV
LABELV $643
line 848
;846:
;847:	case EV_GRENADE_BOUNCE:
;848:		DEBUGNAME("EV_GRENADE_BOUNCE");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $644
ADDRGP4 $647
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $644
line 849
;849:		if ( rand() & 1 ) {
ADDRLP4 64
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 64
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $648
line 850
;850:			trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.hgrenb1aSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+1000
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 851
;851:		} else {
ADDRGP4 $312
JUMPV
LABELV $648
line 852
;852:			trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.hgrenb2aSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 cgs+152340+1004
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 853
;853:		}
line 854
;854:		break;
ADDRGP4 $312
JUMPV
LABELV $654
line 898
;855:
;856:#ifdef MISSIONPACK
;857:	case EV_PROXIMITY_MINE_STICK:
;858:		DEBUGNAME("EV_PROXIMITY_MINE_STICK");
;859:		if( es->eventParm & SURF_FLESH ) {
;860:			trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.wstbimplSound );
;861:		} else 	if( es->eventParm & SURF_METALSTEPS ) {
;862:			trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.wstbimpmSound );
;863:		} else {
;864:			trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.wstbimpdSound );
;865:		}
;866:		break;
;867:
;868:	case EV_PROXIMITY_MINE_TRIGGER:
;869:		DEBUGNAME("EV_PROXIMITY_MINE_TRIGGER");
;870:		trap_S_StartSound (NULL, es->number, CHAN_AUTO, cgs.media.wstbactvSound );
;871:		break;
;872:	case EV_KAMIKAZE:
;873:		DEBUGNAME("EV_KAMIKAZE");
;874:		CG_KamikazeEffect( cent->lerpOrigin );
;875:		break;
;876:	case EV_OBELISKEXPLODE:
;877:		DEBUGNAME("EV_OBELISKEXPLODE");
;878:		CG_ObeliskExplode( cent->lerpOrigin, es->eventParm );
;879:		break;
;880:	case EV_OBELISKPAIN:
;881:		DEBUGNAME("EV_OBELISKPAIN");
;882:		CG_ObeliskPain( cent->lerpOrigin );
;883:		break;
;884:	case EV_INVUL_IMPACT:
;885:		DEBUGNAME("EV_INVUL_IMPACT");
;886:		CG_InvulnerabilityImpact( cent->lerpOrigin, cent->currentState.angles );
;887:		break;
;888:	case EV_JUICED:
;889:		DEBUGNAME("EV_JUICED");
;890:		CG_InvulnerabilityJuiced( cent->lerpOrigin );
;891:		break;
;892:	case EV_LIGHTNINGBOLT:
;893:		DEBUGNAME("EV_LIGHTNINGBOLT");
;894:		CG_LightningBoltBeam(es->origin2, es->pos.trBase);
;895:		break;
;896:#endif
;897:	case EV_SCOREPLUM:
;898:		DEBUGNAME("EV_SCOREPLUM");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $655
ADDRGP4 $658
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $655
line 899
;899:		CG_ScorePlum( cent->currentState.otherEntityNum, cent->lerpOrigin, cent->currentState.time );
ADDRLP4 68
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 68
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRLP4 68
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRLP4 68
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_ScorePlum
CALLV
pop
line 900
;900:		break;
ADDRGP4 $312
JUMPV
LABELV $659
line 906
;901:
;902:	//
;903:	// missile impacts
;904:	//
;905:	case EV_MISSILE_HIT:
;906:		DEBUGNAME("EV_MISSILE_HIT");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $660
ADDRGP4 $663
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $660
line 907
;907:		ByteToDir( es->eventParm, dir );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 ByteToDir
CALLV
pop
line 908
;908:		CG_MissileHitPlayer( es->weapon, position, dir, es->otherEntityNum );
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_MissileHitPlayer
CALLV
pop
line 909
;909:		break;
ADDRGP4 $312
JUMPV
LABELV $664
line 912
;910:
;911:	case EV_MISSILE_MISS:
;912:		DEBUGNAME("EV_MISSILE_MISS");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $665
ADDRGP4 $668
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $665
line 913
;913:		ByteToDir( es->eventParm, dir );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 ByteToDir
CALLV
pop
line 914
;914:		CG_MissileHitWall( es->weapon, 0, position, dir, IMPACTSOUND_DEFAULT );
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 76
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
ADDRLP4 76
INDIRI4
ARGI4
ADDRGP4 CG_MissileHitWall
CALLV
pop
line 915
;915:		break;
ADDRGP4 $312
JUMPV
LABELV $669
line 918
;916:
;917:	case EV_MISSILE_MISS_METAL:
;918:		DEBUGNAME("EV_MISSILE_MISS_METAL");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $670
ADDRGP4 $673
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $670
line 919
;919:		ByteToDir( es->eventParm, dir );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 ByteToDir
CALLV
pop
line 920
;920:		CG_MissileHitWall( es->weapon, 0, position, dir, IMPACTSOUND_METAL );
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 CG_MissileHitWall
CALLV
pop
line 921
;921:		break;
ADDRGP4 $312
JUMPV
LABELV $674
line 924
;922:
;923:	case EV_RAILTRAIL:
;924:		DEBUGNAME("EV_RAILTRAIL");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $675
ADDRGP4 $678
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $675
line 925
;925:		cent->currentState.weapon = WP_RAILGUN;
ADDRFP4 0
INDIRP4
CNSTI4 192
ADDP4
CNSTI4 7
ASGNI4
line 927
;926:		// if the end was on a nomark surface, don't make an explosion
;927:		CG_RailTrail( ci, es->origin2, es->pos.trBase );
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 104
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
ADDRGP4 CG_RailTrail
CALLV
pop
line 928
;928:		if ( es->eventParm != 255 ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 255
EQI4 $312
line 929
;929:			ByteToDir( es->eventParm, dir );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 ByteToDir
CALLV
pop
line 930
;930:			CG_MissileHitWall( es->weapon, es->clientNum, position, dir, IMPACTSOUND_DEFAULT );
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 168
ADDP4
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 CG_MissileHitWall
CALLV
pop
line 931
;931:		}
line 932
;932:		break;
ADDRGP4 $312
JUMPV
LABELV $681
line 935
;933:
;934:	case EV_BULLET_HIT_WALL:
;935:		DEBUGNAME("EV_BULLET_HIT_WALL");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $682
ADDRGP4 $685
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $682
line 936
;936:		ByteToDir( es->eventParm, dir );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 ByteToDir
CALLV
pop
line 937
;937:		CG_Bullet( es->pos.trBase, es->otherEntityNum, dir, qfalse, ENTITYNUM_WORLD );
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
CNSTI4 0
ARGI4
CNSTI4 1022
ARGI4
ADDRGP4 CG_Bullet
CALLV
pop
line 938
;938:		break;
ADDRGP4 $312
JUMPV
LABELV $686
line 941
;939:
;940:	case EV_BULLET_HIT_FLESH:
;941:		DEBUGNAME("EV_BULLET_HIT_FLESH");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $687
ADDRGP4 $690
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $687
line 942
;942:		CG_Bullet( es->pos.trBase, es->otherEntityNum, dir, qtrue, es->eventParm );
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_Bullet
CALLV
pop
line 943
;943:		break;
ADDRGP4 $312
JUMPV
LABELV $691
line 946
;944:
;945:	case EV_SHOTGUN:
;946:		DEBUGNAME("EV_SHOTGUN");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $692
ADDRGP4 $695
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $692
line 947
;947:		CG_ShotgunFire( es );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_ShotgunFire
CALLV
pop
line 948
;948:		break;
ADDRGP4 $312
JUMPV
LABELV $696
line 951
;949:
;950:	case EV_GENERAL_SOUND:
;951:		DEBUGNAME("EV_GENERAL_SOUND");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $697
ADDRGP4 $700
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $697
line 952
;952:		if ( cgs.gameSounds[ es->eventParm ] ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
CNSTI4 0
EQI4 $701
line 953
;953:			trap_S_StartSound (NULL, es->number, CHAN_VOICE, cgs.gameSounds[ es->eventParm ] );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 954
;954:		} else {
ADDRGP4 $312
JUMPV
LABELV $701
line 955
;955:			s = CG_ConfigString( CS_SOUNDS + es->eventParm );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 288
ADDI4
ARGI4
ADDRLP4 92
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 92
INDIRP4
ASGNP4
line 956
;956:			trap_S_StartSound (NULL, es->number, CHAN_VOICE, CG_CustomSound( es->number, s ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 96
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 957
;957:		}
line 958
;958:		break;
ADDRGP4 $312
JUMPV
LABELV $705
line 961
;959:
;960:	case EV_GLOBAL_SOUND:	// play from the player's head so it never diminishes
;961:		DEBUGNAME("EV_GLOBAL_SOUND");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $706
ADDRGP4 $709
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $706
line 962
;962:		if ( cgs.gameSounds[ es->eventParm ] ) {
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
CNSTI4 0
EQI4 $710
line 963
;963:			trap_S_StartSound (NULL, cg.snap->ps.clientNum, CHAN_AUTO, cgs.gameSounds[ es->eventParm ] );
CNSTP4 0
ARGP4
ADDRLP4 92
CNSTI4 184
ASGNI4
ADDRGP4 cg+36
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 0
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 964
;964:		} else {
ADDRGP4 $312
JUMPV
LABELV $710
line 965
;965:			s = CG_ConfigString( CS_SOUNDS + es->eventParm );
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 288
ADDI4
ARGI4
ADDRLP4 92
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 92
INDIRP4
ASGNP4
line 966
;966:			trap_S_StartSound (NULL, cg.snap->ps.clientNum, CHAN_AUTO, CG_CustomSound( es->number, s ) );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 96
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 967
;967:		}
line 968
;968:		break;
ADDRGP4 $312
JUMPV
LABELV $716
line 971
;969:
;970:	case EV_GLOBAL_TEAM_SOUND:	// play from the player's head so it never diminishes
;971:		{
line 972
;972:			DEBUGNAME("EV_GLOBAL_TEAM_SOUND");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $717
ADDRGP4 $720
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $717
line 973
;973:			switch( es->eventParm ) {
ADDRLP4 92
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
ADDRLP4 92
INDIRI4
CNSTI4 0
LTI4 $312
ADDRLP4 92
INDIRI4
CNSTI4 12
GTI4 $312
ADDRLP4 92
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $839
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $839
address $724
address $734
address $744
address $756
address $768
address $788
address $808
address $816
address $824
address $827
address $830
address $833
address $836
code
LABELV $724
line 975
;974:				case GTS_RED_CAPTURE: // CTF: red team captured the blue flag, 1FCTF: red team captured the neutral flag
;975:					if ( cgs.clientinfo[cg.clientNum].team == TEAM_RED )
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 1
NEI4 $725
line 976
;976:						CG_AddBufferedSound( cgs.media.captureYourTeamSound );
ADDRGP4 cgs+152340+892
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
ADDRGP4 $312
JUMPV
LABELV $725
line 978
;977:					else
;978:						CG_AddBufferedSound( cgs.media.captureOpponentSound );
ADDRGP4 cgs+152340+896
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 979
;979:					break;
ADDRGP4 $312
JUMPV
LABELV $734
line 981
;980:				case GTS_BLUE_CAPTURE: // CTF: blue team captured the red flag, 1FCTF: blue team captured the neutral flag
;981:					if ( cgs.clientinfo[cg.clientNum].team == TEAM_BLUE )
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $735
line 982
;982:						CG_AddBufferedSound( cgs.media.captureYourTeamSound );
ADDRGP4 cgs+152340+892
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
ADDRGP4 $312
JUMPV
LABELV $735
line 984
;983:					else
;984:						CG_AddBufferedSound( cgs.media.captureOpponentSound );
ADDRGP4 cgs+152340+896
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 985
;985:					break;
ADDRGP4 $312
JUMPV
LABELV $744
line 987
;986:				case GTS_RED_RETURN: // CTF: blue flag returned, 1FCTF: never used
;987:					if ( cgs.clientinfo[cg.clientNum].team == TEAM_RED )
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 1
NEI4 $745
line 988
;988:						CG_AddBufferedSound( cgs.media.returnYourTeamSound );
ADDRGP4 cgs+152340+900
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
ADDRGP4 $746
JUMPV
LABELV $745
line 990
;989:					else
;990:						CG_AddBufferedSound( cgs.media.returnOpponentSound );
ADDRGP4 cgs+152340+904
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
LABELV $746
line 992
;991:					//
;992:					CG_AddBufferedSound( cgs.media.blueFlagReturnedSound );
ADDRGP4 cgs+152340+920
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 993
;993:					break;
ADDRGP4 $312
JUMPV
LABELV $756
line 995
;994:				case GTS_BLUE_RETURN: // CTF red flag returned, 1FCTF: neutral flag returned
;995:					if ( cgs.clientinfo[cg.clientNum].team == TEAM_BLUE )
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $757
line 996
;996:						CG_AddBufferedSound( cgs.media.returnYourTeamSound );
ADDRGP4 cgs+152340+900
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
ADDRGP4 $758
JUMPV
LABELV $757
line 998
;997:					else
;998:						CG_AddBufferedSound( cgs.media.returnOpponentSound );
ADDRGP4 cgs+152340+904
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
LABELV $758
line 1000
;999:					//
;1000:					CG_AddBufferedSound( cgs.media.redFlagReturnedSound );
ADDRGP4 cgs+152340+916
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1001
;1001:					break;
ADDRGP4 $312
JUMPV
LABELV $768
line 1005
;1002:
;1003:				case GTS_RED_TAKEN: // CTF: red team took blue flag, 1FCTF: blue team took the neutral flag
;1004:					// if this player picked up the flag then a sound is played in CG_CheckLocalSounds
;1005:					if (cg.snap->ps.powerups[PW_BLUEFLAG] || cg.snap->ps.powerups[PW_NEUTRALFLAG]) {
ADDRLP4 100
CNSTI4 0
ASGNI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 388
ADDP4
INDIRI4
ADDRLP4 100
INDIRI4
NEI4 $773
ADDRGP4 cg+36
INDIRP4
CNSTI4 392
ADDP4
INDIRI4
ADDRLP4 100
INDIRI4
EQI4 $769
LABELV $773
line 1006
;1006:					}
ADDRGP4 $312
JUMPV
LABELV $769
line 1007
;1007:					else {
line 1008
;1008:					if (cgs.clientinfo[cg.clientNum].team == TEAM_BLUE) {
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $774
line 1014
;1009:#ifdef MISSIONPACK
;1010:							if (cgs.gametype == GT_1FCTF) 
;1011:								CG_AddBufferedSound( cgs.media.yourTeamTookTheFlagSound );
;1012:							else
;1013:#endif
;1014:						 	CG_AddBufferedSound( cgs.media.enemyTookYourFlagSound );
ADDRGP4 cgs+152340+928
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1015
;1015:						}
ADDRGP4 $312
JUMPV
LABELV $774
line 1016
;1016:						else if (cgs.clientinfo[cg.clientNum].team == TEAM_RED) {
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 1
NEI4 $312
line 1022
;1017:#ifdef MISSIONPACK
;1018:							if (cgs.gametype == GT_1FCTF)
;1019:								CG_AddBufferedSound( cgs.media.enemyTookTheFlagSound );
;1020:							else
;1021:#endif
;1022: 							CG_AddBufferedSound( cgs.media.yourTeamTookEnemyFlagSound );
ADDRGP4 cgs+152340+936
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1023
;1023:						}
line 1024
;1024:					}
line 1025
;1025:					break;
ADDRGP4 $312
JUMPV
LABELV $788
line 1028
;1026:				case GTS_BLUE_TAKEN: // CTF: blue team took the red flag, 1FCTF red team took the neutral flag
;1027:					// if this player picked up the flag then a sound is played in CG_CheckLocalSounds
;1028:					if (cg.snap->ps.powerups[PW_REDFLAG] || cg.snap->ps.powerups[PW_NEUTRALFLAG]) {
ADDRLP4 104
CNSTI4 0
ASGNI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 384
ADDP4
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $793
ADDRGP4 cg+36
INDIRP4
CNSTI4 392
ADDP4
INDIRI4
ADDRLP4 104
INDIRI4
EQI4 $789
LABELV $793
line 1029
;1029:					}
ADDRGP4 $312
JUMPV
LABELV $789
line 1030
;1030:					else {
line 1031
;1031:						if (cgs.clientinfo[cg.clientNum].team == TEAM_RED) {
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 1
NEI4 $794
line 1037
;1032:#ifdef MISSIONPACK
;1033:							if (cgs.gametype == GT_1FCTF)
;1034:								CG_AddBufferedSound( cgs.media.yourTeamTookTheFlagSound );
;1035:							else
;1036:#endif
;1037:							CG_AddBufferedSound( cgs.media.enemyTookYourFlagSound );
ADDRGP4 cgs+152340+928
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1038
;1038:						}
ADDRGP4 $312
JUMPV
LABELV $794
line 1039
;1039:						else if (cgs.clientinfo[cg.clientNum].team == TEAM_BLUE) {
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $312
line 1045
;1040:#ifdef MISSIONPACK
;1041:							if (cgs.gametype == GT_1FCTF)
;1042:								CG_AddBufferedSound( cgs.media.enemyTookTheFlagSound );
;1043:							else
;1044:#endif
;1045:							CG_AddBufferedSound( cgs.media.yourTeamTookEnemyFlagSound );
ADDRGP4 cgs+152340+936
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1046
;1046:						}
line 1047
;1047:					}
line 1048
;1048:					break;
ADDRGP4 $312
JUMPV
LABELV $808
line 1050
;1049:				case GTS_REDOBELISK_ATTACKED: // Overload: red obelisk is being attacked
;1050:					if (cgs.clientinfo[cg.clientNum].team == TEAM_RED) {
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 1
NEI4 $312
line 1051
;1051:						CG_AddBufferedSound( cgs.media.yourBaseIsUnderAttackSound );
ADDRGP4 cgs+152340+948
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1052
;1052:					}
line 1053
;1053:					break;
ADDRGP4 $312
JUMPV
LABELV $816
line 1055
;1054:				case GTS_BLUEOBELISK_ATTACKED: // Overload: blue obelisk is being attacked
;1055:					if (cgs.clientinfo[cg.clientNum].team == TEAM_BLUE) {
CNSTI4 1708
ADDRGP4 cg+4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 2
NEI4 $312
line 1056
;1056:						CG_AddBufferedSound( cgs.media.yourBaseIsUnderAttackSound );
ADDRGP4 cgs+152340+948
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1057
;1057:					}
line 1058
;1058:					break;
ADDRGP4 $312
JUMPV
LABELV $824
line 1061
;1059:
;1060:				case GTS_REDTEAM_SCORED:
;1061:					CG_AddBufferedSound(cgs.media.redScoredSound);
ADDRGP4 cgs+152340+872
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1062
;1062:					break;
ADDRGP4 $312
JUMPV
LABELV $827
line 1064
;1063:				case GTS_BLUETEAM_SCORED:
;1064:					CG_AddBufferedSound(cgs.media.blueScoredSound);
ADDRGP4 cgs+152340+876
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1065
;1065:					break;
ADDRGP4 $312
JUMPV
LABELV $830
line 1067
;1066:				case GTS_REDTEAM_TOOK_LEAD:
;1067:					CG_AddBufferedSound(cgs.media.redLeadsSound);
ADDRGP4 cgs+152340+880
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1068
;1068:					break;
ADDRGP4 $312
JUMPV
LABELV $833
line 1070
;1069:				case GTS_BLUETEAM_TOOK_LEAD:
;1070:					CG_AddBufferedSound(cgs.media.blueLeadsSound);
ADDRGP4 cgs+152340+884
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1071
;1071:					break;
ADDRGP4 $312
JUMPV
LABELV $836
line 1073
;1072:				case GTS_TEAMS_ARE_TIED:
;1073:					CG_AddBufferedSound( cgs.media.teamsTiedSound );
ADDRGP4 cgs+152340+888
INDIRI4
ARGI4
ADDRGP4 CG_AddBufferedSound
CALLV
pop
line 1074
;1074:					break;
line 1081
;1075:#ifdef MISSIONPACK
;1076:				case GTS_KAMIKAZE:
;1077:					trap_S_StartLocalSound(cgs.media.kamikazeFarSound, CHAN_ANNOUNCER);
;1078:					break;
;1079:#endif
;1080:				default:
;1081:					break;
line 1083
;1082:			}
;1083:			break;
ADDRGP4 $312
JUMPV
LABELV $840
line 1089
;1084:		}
;1085:
;1086:	case EV_PAIN:
;1087:		// local player sounds are triggered in CG_CheckLocalSounds,
;1088:		// so ignore events on the player
;1089:		DEBUGNAME("EV_PAIN");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $841
ADDRGP4 $844
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $841
line 1090
;1090:		if ( cent->currentState.number != cg.snap->ps.clientNum ) {
ADDRFP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
EQI4 $312
line 1091
;1091:			CG_PainEvent( cent, es->eventParm );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_PainEvent
CALLV
pop
line 1092
;1092:		}
line 1093
;1093:		break;
ADDRGP4 $312
JUMPV
LABELV $848
line 1098
;1094:
;1095:	case EV_DEATH1:
;1096:	case EV_DEATH2:
;1097:	case EV_DEATH3:
;1098:		DEBUGNAME("EV_DEATHx");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $849
ADDRGP4 $852
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $849
line 1099
;1099:		trap_S_StartSound( NULL, es->number, CHAN_VOICE, 
ADDRGP4 $853
ARGP4
ADDRLP4 8
INDIRI4
CNSTI4 57
SUBI4
CNSTI4 1
ADDI4
ARGI4
ADDRLP4 92
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRLP4 92
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 CG_CustomSound
CALLI4
ASGNI4
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 96
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 1101
;1100:				CG_CustomSound( es->number, va("*death%i.wav", event - EV_DEATH1 + 1) ) );
;1101:		break;
ADDRGP4 $312
JUMPV
LABELV $854
line 1105
;1102:
;1103:
;1104:	case EV_OBITUARY:
;1105:		DEBUGNAME("EV_OBITUARY");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $855
ADDRGP4 $858
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $855
line 1106
;1106:		CG_Obituary( es );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Obituary
CALLV
pop
line 1107
;1107:		break;
ADDRGP4 $312
JUMPV
LABELV $859
line 1113
;1108:
;1109:	//
;1110:	// powerup events
;1111:	//
;1112:	case EV_POWERUP_QUAD:
;1113:		DEBUGNAME("EV_POWERUP_QUAD");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $860
ADDRGP4 $863
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $860
line 1114
;1114:		if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $864
line 1115
;1115:			cg.powerupActive = PW_QUAD;
ADDRGP4 cg+124408
CNSTI4 1
ASGNI4
line 1116
;1116:			cg.powerupTime = cg.time;
ADDRGP4 cg+124412
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1117
;1117:		}
LABELV $864
line 1118
;1118:		trap_S_StartSound (NULL, es->number, CHAN_ITEM, cgs.media.quadSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRGP4 cgs+152340+528
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 1119
;1119:		break;
ADDRGP4 $312
JUMPV
LABELV $872
line 1121
;1120:	case EV_POWERUP_BATTLESUIT:
;1121:		DEBUGNAME("EV_POWERUP_BATTLESUIT");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $873
ADDRGP4 $876
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $873
line 1122
;1122:		if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $877
line 1123
;1123:			cg.powerupActive = PW_BATTLESUIT;
ADDRGP4 cg+124408
CNSTI4 2
ASGNI4
line 1124
;1124:			cg.powerupTime = cg.time;
ADDRGP4 cg+124412
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1125
;1125:		}
LABELV $877
line 1126
;1126:		trap_S_StartSound (NULL, es->number, CHAN_ITEM, cgs.media.protectSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRGP4 cgs+152340+992
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 1127
;1127:		break;
ADDRGP4 $312
JUMPV
LABELV $885
line 1129
;1128:	case EV_POWERUP_REGEN:
;1129:		DEBUGNAME("EV_POWERUP_REGEN");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $886
ADDRGP4 $889
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $886
line 1130
;1130:		if ( es->number == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $890
line 1131
;1131:			cg.powerupActive = PW_REGEN;
ADDRGP4 cg+124408
CNSTI4 5
ASGNI4
line 1132
;1132:			cg.powerupTime = cg.time;
ADDRGP4 cg+124412
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1133
;1133:		}
LABELV $890
line 1134
;1134:		trap_S_StartSound (NULL, es->number, CHAN_ITEM, cgs.media.regenSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRGP4 cgs+152340+988
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 1135
;1135:		break;
ADDRGP4 $312
JUMPV
LABELV $898
line 1138
;1136:
;1137:	case EV_GIB_PLAYER:
;1138:		DEBUGNAME("EV_GIB_PLAYER");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $899
ADDRGP4 $902
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $899
line 1142
;1139:		// don't play gib sound when using the kamikaze because it interferes
;1140:		// with the kamikaze sound, downside is that the gib sound will also
;1141:		// not be played when someone is gibbed while just carrying the kamikaze
;1142:		if ( !(es->eFlags & EF_KAMIKAZE) ) {
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 512
BANDI4
CNSTI4 0
NEI4 $903
line 1143
;1143:			trap_S_StartSound( NULL, es->number, CHAN_BODY, cgs.media.gibSound );
CNSTP4 0
ARGP4
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
CNSTI4 5
ARGI4
ADDRGP4 cgs+152340+696
INDIRI4
ARGI4
ADDRGP4 trap_S_StartSound
CALLV
pop
line 1144
;1144:		}
LABELV $903
line 1145
;1145:		CG_GibPlayer( cent->lerpOrigin );
ADDRFP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 CG_GibPlayer
CALLV
pop
line 1146
;1146:		break;
ADDRGP4 $312
JUMPV
LABELV $907
line 1149
;1147:
;1148:	case EV_STOPLOOPINGSOUND:
;1149:		DEBUGNAME("EV_STOPLOOPINGSOUND");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $908
ADDRGP4 $911
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $908
line 1150
;1150:		trap_S_StopLoopingSound( es->number );
ADDRLP4 0
INDIRP4
INDIRI4
ARGI4
ADDRGP4 trap_S_StopLoopingSound
CALLV
pop
line 1151
;1151:		es->loopSound = 0;
ADDRLP4 0
INDIRP4
CNSTI4 156
ADDP4
CNSTI4 0
ASGNI4
line 1152
;1152:		break;
ADDRGP4 $312
JUMPV
LABELV $912
line 1155
;1153:
;1154:	case EV_DEBUG_LINE:
;1155:		DEBUGNAME("EV_DEBUG_LINE");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $913
ADDRGP4 $916
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $913
line 1156
;1156:		CG_Beam( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Beam
CALLV
pop
line 1157
;1157:		break;
ADDRGP4 $312
JUMPV
LABELV $311
line 1160
;1158:
;1159:	default:
;1160:		DEBUGNAME("UNKNOWN");
ADDRGP4 cg_debugEvents+12
INDIRI4
CNSTI4 0
EQI4 $917
ADDRGP4 $920
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
LABELV $917
line 1161
;1161:		CG_Error( "Unknown event: %i", event );
ADDRGP4 $921
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 1162
;1162:		break;
LABELV $312
line 1165
;1163:	}
;1164:
;1165:}
LABELV $296
endproc CG_EntityEvent 108 48
export CG_CheckEvents
proc CG_CheckEvents 8 12
line 1174
;1166:
;1167:
;1168:/*
;1169:==============
;1170:CG_CheckEvents
;1171:
;1172:==============
;1173:*/
;1174:void CG_CheckEvents( centity_t *cent ) {
line 1176
;1175:	// check for event-only entities
;1176:	if ( cent->currentState.eType > ET_EVENTS ) {
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
LEI4 $925
line 1177
;1177:		if ( cent->previousEvent ) {
ADDRFP4 0
INDIRP4
CNSTI4 428
ADDP4
INDIRI4
CNSTI4 0
EQI4 $927
line 1178
;1178:			return;	// already fired
ADDRGP4 $924
JUMPV
LABELV $927
line 1181
;1179:		}
;1180:		// if this is a player event set the entity number of the client entity number
;1181:		if ( cent->currentState.eFlags & EF_PLAYER_EVENT ) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $929
line 1182
;1182:			cent->currentState.number = cent->currentState.otherEntityNum;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 1183
;1183:		}
LABELV $929
line 1185
;1184:
;1185:		cent->previousEvent = 1;
ADDRFP4 0
INDIRP4
CNSTI4 428
ADDP4
CNSTI4 1
ASGNI4
line 1187
;1186:
;1187:		cent->currentState.event = cent->currentState.eType - ET_EVENTS;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
SUBI4
ASGNI4
line 1188
;1188:	} else {
ADDRGP4 $926
JUMPV
LABELV $925
line 1190
;1189:		// check for events riding with another entity
;1190:		if ( cent->currentState.event == cent->previousEvent ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 428
ADDP4
INDIRI4
NEI4 $931
line 1191
;1191:			return;
ADDRGP4 $924
JUMPV
LABELV $931
line 1193
;1192:		}
;1193:		cent->previousEvent = cent->currentState.event;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 428
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
ASGNI4
line 1194
;1194:		if ( ( cent->currentState.event & ~EV_EVENT_BITS ) == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 -769
BANDI4
CNSTI4 0
NEI4 $933
line 1195
;1195:			return;
ADDRGP4 $924
JUMPV
LABELV $933
line 1197
;1196:		}
;1197:	}
LABELV $926
line 1200
;1198:
;1199:	// calculate the position at exactly the frame time
;1200:	BG_EvaluateTrajectory( &cent->currentState.pos, cg.snap->serverTime, cent->lerpOrigin );
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 704
ADDP4
ARGP4
ADDRGP4 BG_EvaluateTrajectory
CALLV
pop
line 1201
;1201:	CG_SetEntitySoundPosition( cent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_SetEntitySoundPosition
CALLV
pop
line 1203
;1202:
;1203:	CG_EntityEvent( cent, cent->lerpOrigin );
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
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
line 1204
;1204:}
LABELV $924
endproc CG_CheckEvents 8 12
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
LABELV $921
byte 1 85
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $920
byte 1 85
byte 1 78
byte 1 75
byte 1 78
byte 1 79
byte 1 87
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $916
byte 1 69
byte 1 86
byte 1 95
byte 1 68
byte 1 69
byte 1 66
byte 1 85
byte 1 71
byte 1 95
byte 1 76
byte 1 73
byte 1 78
byte 1 69
byte 1 10
byte 1 0
align 1
LABELV $911
byte 1 69
byte 1 86
byte 1 95
byte 1 83
byte 1 84
byte 1 79
byte 1 80
byte 1 76
byte 1 79
byte 1 79
byte 1 80
byte 1 73
byte 1 78
byte 1 71
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 10
byte 1 0
align 1
LABELV $902
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 73
byte 1 66
byte 1 95
byte 1 80
byte 1 76
byte 1 65
byte 1 89
byte 1 69
byte 1 82
byte 1 10
byte 1 0
align 1
LABELV $889
byte 1 69
byte 1 86
byte 1 95
byte 1 80
byte 1 79
byte 1 87
byte 1 69
byte 1 82
byte 1 85
byte 1 80
byte 1 95
byte 1 82
byte 1 69
byte 1 71
byte 1 69
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $876
byte 1 69
byte 1 86
byte 1 95
byte 1 80
byte 1 79
byte 1 87
byte 1 69
byte 1 82
byte 1 85
byte 1 80
byte 1 95
byte 1 66
byte 1 65
byte 1 84
byte 1 84
byte 1 76
byte 1 69
byte 1 83
byte 1 85
byte 1 73
byte 1 84
byte 1 10
byte 1 0
align 1
LABELV $863
byte 1 69
byte 1 86
byte 1 95
byte 1 80
byte 1 79
byte 1 87
byte 1 69
byte 1 82
byte 1 85
byte 1 80
byte 1 95
byte 1 81
byte 1 85
byte 1 65
byte 1 68
byte 1 10
byte 1 0
align 1
LABELV $858
byte 1 69
byte 1 86
byte 1 95
byte 1 79
byte 1 66
byte 1 73
byte 1 84
byte 1 85
byte 1 65
byte 1 82
byte 1 89
byte 1 10
byte 1 0
align 1
LABELV $853
byte 1 42
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $852
byte 1 69
byte 1 86
byte 1 95
byte 1 68
byte 1 69
byte 1 65
byte 1 84
byte 1 72
byte 1 120
byte 1 10
byte 1 0
align 1
LABELV $844
byte 1 69
byte 1 86
byte 1 95
byte 1 80
byte 1 65
byte 1 73
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $720
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 76
byte 1 79
byte 1 66
byte 1 65
byte 1 76
byte 1 95
byte 1 84
byte 1 69
byte 1 65
byte 1 77
byte 1 95
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 10
byte 1 0
align 1
LABELV $709
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 76
byte 1 79
byte 1 66
byte 1 65
byte 1 76
byte 1 95
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 10
byte 1 0
align 1
LABELV $700
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 69
byte 1 78
byte 1 69
byte 1 82
byte 1 65
byte 1 76
byte 1 95
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 10
byte 1 0
align 1
LABELV $695
byte 1 69
byte 1 86
byte 1 95
byte 1 83
byte 1 72
byte 1 79
byte 1 84
byte 1 71
byte 1 85
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $690
byte 1 69
byte 1 86
byte 1 95
byte 1 66
byte 1 85
byte 1 76
byte 1 76
byte 1 69
byte 1 84
byte 1 95
byte 1 72
byte 1 73
byte 1 84
byte 1 95
byte 1 70
byte 1 76
byte 1 69
byte 1 83
byte 1 72
byte 1 10
byte 1 0
align 1
LABELV $685
byte 1 69
byte 1 86
byte 1 95
byte 1 66
byte 1 85
byte 1 76
byte 1 76
byte 1 69
byte 1 84
byte 1 95
byte 1 72
byte 1 73
byte 1 84
byte 1 95
byte 1 87
byte 1 65
byte 1 76
byte 1 76
byte 1 10
byte 1 0
align 1
LABELV $678
byte 1 69
byte 1 86
byte 1 95
byte 1 82
byte 1 65
byte 1 73
byte 1 76
byte 1 84
byte 1 82
byte 1 65
byte 1 73
byte 1 76
byte 1 10
byte 1 0
align 1
LABELV $673
byte 1 69
byte 1 86
byte 1 95
byte 1 77
byte 1 73
byte 1 83
byte 1 83
byte 1 73
byte 1 76
byte 1 69
byte 1 95
byte 1 77
byte 1 73
byte 1 83
byte 1 83
byte 1 95
byte 1 77
byte 1 69
byte 1 84
byte 1 65
byte 1 76
byte 1 10
byte 1 0
align 1
LABELV $668
byte 1 69
byte 1 86
byte 1 95
byte 1 77
byte 1 73
byte 1 83
byte 1 83
byte 1 73
byte 1 76
byte 1 69
byte 1 95
byte 1 77
byte 1 73
byte 1 83
byte 1 83
byte 1 10
byte 1 0
align 1
LABELV $663
byte 1 69
byte 1 86
byte 1 95
byte 1 77
byte 1 73
byte 1 83
byte 1 83
byte 1 73
byte 1 76
byte 1 69
byte 1 95
byte 1 72
byte 1 73
byte 1 84
byte 1 10
byte 1 0
align 1
LABELV $658
byte 1 69
byte 1 86
byte 1 95
byte 1 83
byte 1 67
byte 1 79
byte 1 82
byte 1 69
byte 1 80
byte 1 76
byte 1 85
byte 1 77
byte 1 10
byte 1 0
align 1
LABELV $647
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 82
byte 1 69
byte 1 78
byte 1 65
byte 1 68
byte 1 69
byte 1 95
byte 1 66
byte 1 79
byte 1 85
byte 1 78
byte 1 67
byte 1 69
byte 1 10
byte 1 0
align 1
LABELV $639
byte 1 69
byte 1 86
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 95
byte 1 82
byte 1 69
byte 1 83
byte 1 80
byte 1 65
byte 1 87
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $632
byte 1 69
byte 1 86
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 95
byte 1 80
byte 1 79
byte 1 80
byte 1 10
byte 1 0
align 1
LABELV $625
byte 1 69
byte 1 86
byte 1 95
byte 1 80
byte 1 76
byte 1 65
byte 1 89
byte 1 69
byte 1 82
byte 1 95
byte 1 84
byte 1 69
byte 1 76
byte 1 69
byte 1 80
byte 1 79
byte 1 82
byte 1 84
byte 1 95
byte 1 79
byte 1 85
byte 1 84
byte 1 10
byte 1 0
align 1
LABELV $618
byte 1 69
byte 1 86
byte 1 95
byte 1 80
byte 1 76
byte 1 65
byte 1 89
byte 1 69
byte 1 82
byte 1 95
byte 1 84
byte 1 69
byte 1 76
byte 1 69
byte 1 80
byte 1 79
byte 1 82
byte 1 84
byte 1 95
byte 1 73
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $613
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 49
byte 1 52
byte 1 10
byte 1 0
align 1
LABELV $608
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 49
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $603
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 49
byte 1 50
byte 1 10
byte 1 0
align 1
LABELV $598
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 49
byte 1 49
byte 1 10
byte 1 0
align 1
LABELV $593
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 49
byte 1 48
byte 1 10
byte 1 0
align 1
LABELV $588
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 57
byte 1 10
byte 1 0
align 1
LABELV $583
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 56
byte 1 10
byte 1 0
align 1
LABELV $578
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 55
byte 1 10
byte 1 0
align 1
LABELV $573
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 54
byte 1 10
byte 1 0
align 1
LABELV $568
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 53
byte 1 10
byte 1 0
align 1
LABELV $563
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 52
byte 1 10
byte 1 0
align 1
LABELV $558
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $553
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 50
byte 1 10
byte 1 0
align 1
LABELV $548
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 49
byte 1 10
byte 1 0
align 1
LABELV $543
byte 1 69
byte 1 86
byte 1 95
byte 1 85
byte 1 83
byte 1 69
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 48
byte 1 10
byte 1 0
align 1
LABELV $538
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 73
byte 1 82
byte 1 69
byte 1 95
byte 1 87
byte 1 69
byte 1 65
byte 1 80
byte 1 79
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $531
byte 1 69
byte 1 86
byte 1 95
byte 1 67
byte 1 72
byte 1 65
byte 1 78
byte 1 71
byte 1 69
byte 1 95
byte 1 87
byte 1 69
byte 1 65
byte 1 80
byte 1 79
byte 1 78
byte 1 10
byte 1 0
align 1
LABELV $523
byte 1 69
byte 1 86
byte 1 95
byte 1 78
byte 1 79
byte 1 65
byte 1 77
byte 1 77
byte 1 79
byte 1 10
byte 1 0
align 1
LABELV $509
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 76
byte 1 79
byte 1 66
byte 1 65
byte 1 76
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 95
byte 1 80
byte 1 73
byte 1 67
byte 1 75
byte 1 85
byte 1 80
byte 1 10
byte 1 0
align 1
LABELV $491
byte 1 69
byte 1 86
byte 1 95
byte 1 73
byte 1 84
byte 1 69
byte 1 77
byte 1 95
byte 1 80
byte 1 73
byte 1 67
byte 1 75
byte 1 85
byte 1 80
byte 1 10
byte 1 0
align 1
LABELV $486
byte 1 42
byte 1 103
byte 1 97
byte 1 115
byte 1 112
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $485
byte 1 69
byte 1 86
byte 1 95
byte 1 87
byte 1 65
byte 1 84
byte 1 69
byte 1 82
byte 1 95
byte 1 67
byte 1 76
byte 1 69
byte 1 65
byte 1 82
byte 1 10
byte 1 0
align 1
LABELV $478
byte 1 69
byte 1 86
byte 1 95
byte 1 87
byte 1 65
byte 1 84
byte 1 69
byte 1 82
byte 1 95
byte 1 85
byte 1 78
byte 1 68
byte 1 69
byte 1 82
byte 1 10
byte 1 0
align 1
LABELV $471
byte 1 69
byte 1 86
byte 1 95
byte 1 87
byte 1 65
byte 1 84
byte 1 69
byte 1 82
byte 1 95
byte 1 76
byte 1 69
byte 1 65
byte 1 86
byte 1 69
byte 1 10
byte 1 0
align 1
LABELV $464
byte 1 69
byte 1 86
byte 1 95
byte 1 87
byte 1 65
byte 1 84
byte 1 69
byte 1 82
byte 1 95
byte 1 84
byte 1 79
byte 1 85
byte 1 67
byte 1 72
byte 1 10
byte 1 0
align 1
LABELV $459
byte 1 42
byte 1 116
byte 1 97
byte 1 117
byte 1 110
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $458
byte 1 69
byte 1 86
byte 1 95
byte 1 84
byte 1 65
byte 1 85
byte 1 78
byte 1 84
byte 1 10
byte 1 0
align 1
LABELV $453
byte 1 69
byte 1 86
byte 1 95
byte 1 74
byte 1 85
byte 1 77
byte 1 80
byte 1 10
byte 1 0
align 1
LABELV $448
byte 1 42
byte 1 106
byte 1 117
byte 1 109
byte 1 112
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $441
byte 1 69
byte 1 86
byte 1 95
byte 1 74
byte 1 85
byte 1 77
byte 1 80
byte 1 95
byte 1 80
byte 1 65
byte 1 68
byte 1 10
byte 1 0
align 1
LABELV $411
byte 1 69
byte 1 86
byte 1 95
byte 1 83
byte 1 84
byte 1 69
byte 1 80
byte 1 10
byte 1 0
align 1
LABELV $398
byte 1 42
byte 1 102
byte 1 97
byte 1 108
byte 1 108
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $397
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 65
byte 1 76
byte 1 76
byte 1 95
byte 1 70
byte 1 65
byte 1 82
byte 1 10
byte 1 0
align 1
LABELV $385
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 65
byte 1 76
byte 1 76
byte 1 95
byte 1 77
byte 1 69
byte 1 68
byte 1 73
byte 1 85
byte 1 77
byte 1 10
byte 1 0
align 1
LABELV $371
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 65
byte 1 76
byte 1 76
byte 1 95
byte 1 83
byte 1 72
byte 1 79
byte 1 82
byte 1 84
byte 1 10
byte 1 0
align 1
LABELV $360
byte 1 69
byte 1 86
byte 1 95
byte 1 83
byte 1 87
byte 1 73
byte 1 77
byte 1 10
byte 1 0
align 1
LABELV $349
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 79
byte 1 79
byte 1 84
byte 1 87
byte 1 65
byte 1 68
byte 1 69
byte 1 10
byte 1 0
align 1
LABELV $338
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 79
byte 1 79
byte 1 84
byte 1 83
byte 1 80
byte 1 76
byte 1 65
byte 1 83
byte 1 72
byte 1 10
byte 1 0
align 1
LABELV $327
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 79
byte 1 79
byte 1 84
byte 1 83
byte 1 84
byte 1 69
byte 1 80
byte 1 95
byte 1 77
byte 1 69
byte 1 84
byte 1 65
byte 1 76
byte 1 10
byte 1 0
align 1
LABELV $317
byte 1 69
byte 1 86
byte 1 95
byte 1 70
byte 1 79
byte 1 79
byte 1 84
byte 1 83
byte 1 84
byte 1 69
byte 1 80
byte 1 10
byte 1 0
align 1
LABELV $306
byte 1 90
byte 1 69
byte 1 82
byte 1 79
byte 1 69
byte 1 86
byte 1 69
byte 1 78
byte 1 84
byte 1 10
byte 1 0
align 1
LABELV $300
byte 1 101
byte 1 110
byte 1 116
byte 1 58
byte 1 37
byte 1 51
byte 1 105
byte 1 32
byte 1 32
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 58
byte 1 37
byte 1 51
byte 1 105
byte 1 32
byte 1 0
align 1
LABELV $294
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 49
byte 1 48
byte 1 48
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $293
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 55
byte 1 53
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $290
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 53
byte 1 48
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $287
byte 1 42
byte 1 112
byte 1 97
byte 1 105
byte 1 110
byte 1 50
byte 1 53
byte 1 95
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $250
byte 1 85
byte 1 115
byte 1 101
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $249
byte 1 78
byte 1 111
byte 1 32
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 117
byte 1 115
byte 1 101
byte 1 0
align 1
LABELV $239
byte 1 37
byte 1 115
byte 1 32
byte 1 100
byte 1 105
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $238
byte 1 37
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $233
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $232
byte 1 39
byte 1 115
byte 1 32
byte 1 112
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 32
byte 1 115
byte 1 112
byte 1 97
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $231
byte 1 116
byte 1 114
byte 1 105
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 105
byte 1 110
byte 1 118
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $229
byte 1 39
byte 1 115
byte 1 32
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $228
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 98
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $226
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 101
byte 1 108
byte 1 101
byte 1 99
byte 1 116
byte 1 114
byte 1 111
byte 1 99
byte 1 117
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $224
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $221
byte 1 39
byte 1 115
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $220
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 109
byte 1 101
byte 1 108
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $218
byte 1 97
byte 1 108
byte 1 109
byte 1 111
byte 1 115
byte 1 116
byte 1 32
byte 1 100
byte 1 111
byte 1 100
byte 1 103
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $216
byte 1 39
byte 1 115
byte 1 32
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $214
byte 1 39
byte 1 115
byte 1 32
byte 1 115
byte 1 104
byte 1 114
byte 1 97
byte 1 112
byte 1 110
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $213
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 115
byte 1 104
byte 1 114
byte 1 101
byte 1 100
byte 1 100
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $211
byte 1 39
byte 1 115
byte 1 32
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $210
byte 1 97
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $208
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 103
byte 1 117
byte 1 110
byte 1 110
byte 1 101
byte 1 100
byte 1 32
byte 1 100
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $206
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 109
byte 1 97
byte 1 99
byte 1 104
byte 1 105
byte 1 110
byte 1 101
byte 1 103
byte 1 117
byte 1 110
byte 1 110
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $204
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 112
byte 1 117
byte 1 109
byte 1 109
byte 1 101
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $202
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 99
byte 1 97
byte 1 117
byte 1 103
byte 1 104
byte 1 116
byte 1 32
byte 1 98
byte 1 121
byte 1 0
align 1
LABELV $191
byte 1 110
byte 1 111
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $188
byte 1 89
byte 1 111
byte 1 117
byte 1 32
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 103
byte 1 101
byte 1 100
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $185
byte 1 89
byte 1 111
byte 1 117
byte 1 32
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 103
byte 1 101
byte 1 100
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 37
byte 1 115
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $178
byte 1 37
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $174
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 104
byte 1 105
byte 1 109
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 0
align 1
LABELV $173
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 105
byte 1 116
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 0
align 1
LABELV $170
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 101
byte 1 100
byte 1 32
byte 1 104
byte 1 101
byte 1 114
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 0
align 1
LABELV $167
byte 1 115
byte 1 104
byte 1 111
byte 1 117
byte 1 108
byte 1 100
byte 1 32
byte 1 104
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 117
byte 1 115
byte 1 101
byte 1 100
byte 1 32
byte 1 97
byte 1 32
byte 1 115
byte 1 109
byte 1 97
byte 1 108
byte 1 108
byte 1 101
byte 1 114
byte 1 32
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $165
byte 1 109
byte 1 101
byte 1 108
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 104
byte 1 105
byte 1 109
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 0
align 1
LABELV $164
byte 1 109
byte 1 101
byte 1 108
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 105
byte 1 116
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 0
align 1
LABELV $161
byte 1 109
byte 1 101
byte 1 108
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 104
byte 1 101
byte 1 114
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 0
align 1
LABELV $157
byte 1 98
byte 1 108
byte 1 101
byte 1 119
byte 1 32
byte 1 104
byte 1 105
byte 1 109
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 32
byte 1 117
byte 1 112
byte 1 0
align 1
LABELV $156
byte 1 98
byte 1 108
byte 1 101
byte 1 119
byte 1 32
byte 1 105
byte 1 116
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 32
byte 1 117
byte 1 112
byte 1 0
align 1
LABELV $153
byte 1 98
byte 1 108
byte 1 101
byte 1 119
byte 1 32
byte 1 104
byte 1 101
byte 1 114
byte 1 115
byte 1 101
byte 1 108
byte 1 102
byte 1 32
byte 1 117
byte 1 112
byte 1 0
align 1
LABELV $149
byte 1 116
byte 1 114
byte 1 105
byte 1 112
byte 1 112
byte 1 101
byte 1 100
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 104
byte 1 105
byte 1 115
byte 1 32
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $148
byte 1 116
byte 1 114
byte 1 105
byte 1 112
byte 1 112
byte 1 101
byte 1 100
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 105
byte 1 116
byte 1 115
byte 1 32
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $145
byte 1 116
byte 1 114
byte 1 105
byte 1 112
byte 1 112
byte 1 101
byte 1 100
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 104
byte 1 101
byte 1 114
byte 1 32
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $135
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 119
byte 1 114
byte 1 111
byte 1 110
byte 1 103
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $133
byte 1 115
byte 1 97
byte 1 119
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 108
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $131
byte 1 100
byte 1 111
byte 1 101
byte 1 115
byte 1 32
byte 1 97
byte 1 32
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 32
byte 1 102
byte 1 108
byte 1 105
byte 1 112
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 111
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 108
byte 1 97
byte 1 118
byte 1 97
byte 1 0
align 1
LABELV $129
byte 1 109
byte 1 101
byte 1 108
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $127
byte 1 115
byte 1 97
byte 1 110
byte 1 107
byte 1 32
byte 1 108
byte 1 105
byte 1 107
byte 1 101
byte 1 32
byte 1 97
byte 1 32
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 0
align 1
LABELV $125
byte 1 119
byte 1 97
byte 1 115
byte 1 32
byte 1 115
byte 1 113
byte 1 117
byte 1 105
byte 1 115
byte 1 104
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $123
byte 1 99
byte 1 114
byte 1 97
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $121
byte 1 115
byte 1 117
byte 1 105
byte 1 99
byte 1 105
byte 1 100
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $117
byte 1 94
byte 1 55
byte 1 0
align 1
LABELV $116
byte 1 110
byte 1 0
align 1
LABELV $109
byte 1 67
byte 1 71
byte 1 95
byte 1 79
byte 1 98
byte 1 105
byte 1 116
byte 1 117
byte 1 97
byte 1 114
byte 1 121
byte 1 58
byte 1 32
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $104
byte 1 37
byte 1 115
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $103
byte 1 37
byte 1 105
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $102
byte 1 37
byte 1 105
byte 1 114
byte 1 100
byte 1 0
align 1
LABELV $99
byte 1 37
byte 1 105
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $96
byte 1 37
byte 1 105
byte 1 115
byte 1 116
byte 1 0
align 1
LABELV $93
byte 1 49
byte 1 51
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $90
byte 1 49
byte 1 50
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $87
byte 1 49
byte 1 49
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $84
byte 1 94
byte 1 51
byte 1 51
byte 1 114
byte 1 100
byte 1 94
byte 1 55
byte 1 0
align 1
LABELV $81
byte 1 94
byte 1 49
byte 1 50
byte 1 110
byte 1 100
byte 1 94
byte 1 55
byte 1 0
align 1
LABELV $78
byte 1 94
byte 1 52
byte 1 49
byte 1 115
byte 1 116
byte 1 94
byte 1 55
byte 1 0
align 1
LABELV $75
byte 1 0
align 1
LABELV $74
byte 1 84
byte 1 105
byte 1 101
byte 1 100
byte 1 32
byte 1 102
byte 1 111
byte 1 114
byte 1 32
byte 1 0
