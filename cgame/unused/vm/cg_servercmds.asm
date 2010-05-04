lit
align 4
LABELV validOrders
address $71
byte 4 1
address $72
byte 4 1
address $73
byte 4 2
address $74
byte 4 2
address $75
byte 4 3
address $76
byte 4 7
address $77
byte 4 4
address $78
byte 4 5
address $79
byte 4 6
align 4
LABELV numValidOrders
byte 4 9
code
proc CG_ParseScores 212 12
file "../cg_servercmds.c"
line 67
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
;23:// cg_servercmds.c -- reliably sequenced text commands sent by the server
;24:// these are processed at snapshot transition time, so there will definately
;25:// be a valid snapshot this frame
;26:
;27:#include "cg_local.h"
;28:#include "../../ui/menudef.h" // bk001205 - for Q3_ui as well
;29:
;30:typedef struct {
;31:	const char *order;
;32:	int taskNum;
;33:} orderTask_t;
;34:
;35:static const orderTask_t validOrders[] = {
;36:	{ VOICECHAT_GETFLAG,						TEAMTASK_OFFENSE },
;37:	{ VOICECHAT_OFFENSE,						TEAMTASK_OFFENSE },
;38:	{ VOICECHAT_DEFEND,							TEAMTASK_DEFENSE },
;39:	{ VOICECHAT_DEFENDFLAG,					TEAMTASK_DEFENSE },
;40:	{ VOICECHAT_PATROL,							TEAMTASK_PATROL },
;41:	{ VOICECHAT_CAMP,								TEAMTASK_CAMP },
;42:	{ VOICECHAT_FOLLOWME,						TEAMTASK_FOLLOW },
;43:	{ VOICECHAT_RETURNFLAG,					TEAMTASK_RETRIEVE },
;44:	{ VOICECHAT_FOLLOWFLAGCARRIER,	TEAMTASK_ESCORT }
;45:};
;46:
;47:static const int numValidOrders = sizeof(validOrders) / sizeof(orderTask_t);
;48:
;49:#ifdef MISSIONPACK // bk001204
;50:static int CG_ValidOrder(const char *p) {
;51:	int i;
;52:	for (i = 0; i < numValidOrders; i++) {
;53:		if (Q_stricmp(p, validOrders[i].order) == 0) {
;54:			return validOrders[i].taskNum;
;55:		}
;56:	}
;57:	return -1;
;58:}
;59:#endif
;60:
;61:/*
;62:=================
;63:CG_ParseScores
;64:
;65:=================
;66:*/
;67:static void CG_ParseScores( void ) {
line 70
;68:	int		i, powerups;
;69:
;70:	cg.numScores = atoi( CG_Argv( 1 ) );
CNSTI4 1
ARGI4
ADDRLP4 8
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cg+110464
ADDRLP4 12
INDIRI4
ASGNI4
line 71
;71:	if ( cg.numScores > MAX_CLIENTS ) {
ADDRGP4 cg+110464
INDIRI4
CNSTI4 64
LEI4 $82
line 72
;72:		cg.numScores = MAX_CLIENTS;
ADDRGP4 cg+110464
CNSTI4 64
ASGNI4
line 73
;73:	}
LABELV $82
line 75
;74:
;75:	cg.teamScores[0] = atoi( CG_Argv( 2 ) );
CNSTI4 2
ARGI4
ADDRLP4 16
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cg+110472
ADDRLP4 20
INDIRI4
ASGNI4
line 76
;76:	cg.teamScores[1] = atoi( CG_Argv( 3 ) );
CNSTI4 3
ARGI4
ADDRLP4 24
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cg+110472+4
ADDRLP4 28
INDIRI4
ASGNI4
line 78
;77:
;78:	memset( cg.scores, 0, sizeof( cg.scores ) );
ADDRGP4 cg+110480
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3840
ARGI4
ADDRGP4 memset
CALLP4
pop
line 79
;79:	for ( i = 0 ; i < cg.numScores ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $94
JUMPV
LABELV $91
line 81
;80:		//
;81:		cg.scores[i].client = atoi( CG_Argv( i * 14 + 4 ) );
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 4
ADDI4
ARGI4
ADDRLP4 36
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 36
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480
ADDP4
ADDRLP4 40
INDIRI4
ASGNI4
line 82
;82:		cg.scores[i].score = atoi( CG_Argv( i * 14 + 5 ) );
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 5
ADDI4
ARGI4
ADDRLP4 48
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 48
INDIRP4
ARGP4
ADDRLP4 52
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+4
ADDP4
ADDRLP4 52
INDIRI4
ASGNI4
line 83
;83:		cg.scores[i].ping = atoi( CG_Argv( i * 14 + 6 ) );
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 6
ADDI4
ARGI4
ADDRLP4 60
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+8
ADDP4
ADDRLP4 64
INDIRI4
ASGNI4
line 84
;84:		cg.scores[i].time = atoi( CG_Argv( i * 14 + 7 ) );
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 7
ADDI4
ARGI4
ADDRLP4 72
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRLP4 76
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+12
ADDP4
ADDRLP4 76
INDIRI4
ASGNI4
line 85
;85:		cg.scores[i].scoreFlags = atoi( CG_Argv( i * 14 + 8 ) );
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 8
ADDI4
ARGI4
ADDRLP4 84
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 84
INDIRP4
ARGP4
ADDRLP4 88
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+16
ADDP4
ADDRLP4 88
INDIRI4
ASGNI4
line 86
;86:		powerups = atoi( CG_Argv( i * 14 + 9 ) );
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 9
ADDI4
ARGI4
ADDRLP4 92
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 96
INDIRI4
ASGNI4
line 87
;87:		cg.scores[i].accuracy = atoi(CG_Argv(i * 14 + 10));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 10
ADDI4
ARGI4
ADDRLP4 104
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 104
INDIRP4
ARGP4
ADDRLP4 108
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+24
ADDP4
ADDRLP4 108
INDIRI4
ASGNI4
line 88
;88:		cg.scores[i].impressiveCount = atoi(CG_Argv(i * 14 + 11));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 11
ADDI4
ARGI4
ADDRLP4 116
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 116
INDIRP4
ARGP4
ADDRLP4 120
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+28
ADDP4
ADDRLP4 120
INDIRI4
ASGNI4
line 89
;89:		cg.scores[i].excellentCount = atoi(CG_Argv(i * 14 + 12));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 12
ADDI4
ARGI4
ADDRLP4 128
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 128
INDIRP4
ARGP4
ADDRLP4 132
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+32
ADDP4
ADDRLP4 132
INDIRI4
ASGNI4
line 90
;90:		cg.scores[i].guantletCount = atoi(CG_Argv(i * 14 + 13));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 13
ADDI4
ARGI4
ADDRLP4 140
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 140
INDIRP4
ARGP4
ADDRLP4 144
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+36
ADDP4
ADDRLP4 144
INDIRI4
ASGNI4
line 91
;91:		cg.scores[i].defendCount = atoi(CG_Argv(i * 14 + 14));
ADDRLP4 148
CNSTI4 14
ASGNI4
ADDRLP4 148
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 148
INDIRI4
ADDI4
ARGI4
ADDRLP4 156
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 156
INDIRP4
ARGP4
ADDRLP4 160
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+40
ADDP4
ADDRLP4 160
INDIRI4
ASGNI4
line 92
;92:		cg.scores[i].assistCount = atoi(CG_Argv(i * 14 + 15));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 15
ADDI4
ARGI4
ADDRLP4 168
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 168
INDIRP4
ARGP4
ADDRLP4 172
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+44
ADDP4
ADDRLP4 172
INDIRI4
ASGNI4
line 93
;93:		cg.scores[i].perfect = atoi(CG_Argv(i * 14 + 16));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 16
ADDI4
ARGI4
ADDRLP4 180
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 180
INDIRP4
ARGP4
ADDRLP4 184
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+52
ADDP4
ADDRLP4 184
INDIRI4
ASGNI4
line 94
;94:		cg.scores[i].captures = atoi(CG_Argv(i * 14 + 17));
CNSTI4 14
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 17
ADDI4
ARGI4
ADDRLP4 192
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 192
INDIRP4
ARGP4
ADDRLP4 196
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480+48
ADDP4
ADDRLP4 196
INDIRI4
ASGNI4
line 96
;95:
;96:		if ( cg.scores[i].client < 0 || cg.scores[i].client >= MAX_CLIENTS ) {
ADDRLP4 200
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 200
INDIRI4
ADDRGP4 cg+110480
ADDP4
INDIRI4
CNSTI4 0
LTI4 $125
ADDRLP4 200
INDIRI4
ADDRGP4 cg+110480
ADDP4
INDIRI4
CNSTI4 64
LTI4 $121
LABELV $125
line 97
;97:			cg.scores[i].client = 0;
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480
ADDP4
CNSTI4 0
ASGNI4
line 98
;98:		}
LABELV $121
line 99
;99:		cgs.clientinfo[ cg.scores[i].client ].score = cg.scores[i].score;
ADDRLP4 204
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
CNSTI4 1708
ADDRLP4 204
INDIRI4
ADDRGP4 cg+110480
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972+100
ADDP4
ADDRLP4 204
INDIRI4
ADDRGP4 cg+110480+4
ADDP4
INDIRI4
ASGNI4
line 100
;100:		cgs.clientinfo[ cg.scores[i].client ].powerups = powerups;
CNSTI4 1708
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972+140
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 102
;101:
;102:		cg.scores[i].team = cgs.clientinfo[cg.scores[i].client].team;
ADDRLP4 208
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 208
INDIRI4
ADDRGP4 cg+110480+56
ADDP4
CNSTI4 1708
ADDRLP4 208
INDIRI4
ADDRGP4 cg+110480
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
ASGNI4
line 103
;103:	}
LABELV $92
line 79
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $94
ADDRLP4 0
INDIRI4
ADDRGP4 cg+110464
INDIRI4
LTI4 $91
line 108
;104:#ifdef MISSIONPACK
;105:	CG_SetScoreSelection(NULL);
;106:#endif
;107:
;108:}
LABELV $80
endproc CG_ParseScores 212 12
proc CG_ParseTeamInfo 68 4
line 116
;109:
;110:/*
;111:=================
;112:CG_ParseTeamInfo
;113:
;114:=================
;115:*/
;116:static void CG_ParseTeamInfo( void ) {
line 120
;117:	int		i;
;118:	int		client;
;119:
;120:	numSortedTeamPlayers = atoi( CG_Argv( 1 ) );
CNSTI4 1
ARGI4
ADDRLP4 8
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 numSortedTeamPlayers
ADDRLP4 12
INDIRI4
ASGNI4
line 122
;121:
;122:	for ( i = 0 ; i < numSortedTeamPlayers ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $144
JUMPV
LABELV $141
line 123
;123:		client = atoi( CG_Argv( i * 6 + 2 ) );
CNSTI4 6
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 2
ADDI4
ARGI4
ADDRLP4 16
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 20
INDIRI4
ASGNI4
line 125
;124:
;125:		sortedTeamPlayers[i] = client;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 sortedTeamPlayers
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 127
;126:
;127:		cgs.clientinfo[ client ].location = atoi( CG_Argv( i * 6 + 3 ) );
CNSTI4 6
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 3
ADDI4
ARGI4
ADDRLP4 24
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972+104
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
line 128
;128:		cgs.clientinfo[ client ].health = atoi( CG_Argv( i * 6 + 4 ) );
CNSTI4 6
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 4
ADDI4
ARGI4
ADDRLP4 32
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 32
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972+108
ADDP4
ADDRLP4 36
INDIRI4
ASGNI4
line 129
;129:		cgs.clientinfo[ client ].armor = atoi( CG_Argv( i * 6 + 5 ) );
CNSTI4 6
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 5
ADDI4
ARGI4
ADDRLP4 40
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 40
INDIRP4
ARGP4
ADDRLP4 44
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972+112
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
line 130
;130:		cgs.clientinfo[ client ].curWeapon = atoi( CG_Argv( i * 6 + 6 ) );
ADDRLP4 48
CNSTI4 6
ASGNI4
ADDRLP4 48
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 48
INDIRI4
ADDI4
ARGI4
ADDRLP4 52
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 52
INDIRP4
ARGP4
ADDRLP4 56
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972+116
ADDP4
ADDRLP4 56
INDIRI4
ASGNI4
line 131
;131:		cgs.clientinfo[ client ].powerups = atoi( CG_Argv( i * 6 + 7 ) );
CNSTI4 6
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 7
ADDI4
ARGI4
ADDRLP4 60
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 60
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 atoi
CALLI4
ASGNI4
CNSTI4 1708
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cgs+40972+140
ADDP4
ADDRLP4 64
INDIRI4
ASGNI4
line 132
;132:	}
LABELV $142
line 122
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $144
ADDRLP4 0
INDIRI4
ADDRGP4 numSortedTeamPlayers
INDIRI4
LTI4 $141
line 133
;133:}
LABELV $140
endproc CG_ParseTeamInfo 68 4
export CG_ParseServerinfo
proc CG_ParseServerinfo 84 16
line 144
;134:
;135:
;136:/*
;137:================
;138:CG_ParseServerinfo
;139:
;140:This is called explicitly when the gamestate is first received,
;141:and whenever the server updates any serverinfo flagged cvars
;142:================
;143:*/
;144:void CG_ParseServerinfo( void ) {
line 148
;145:	const char	*info;
;146:	char	*mapname;
;147:
;148:	info = CG_ConfigString( CS_SERVERINFO );
CNSTI4 0
ARGI4
ADDRLP4 8
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
line 149
;149:	cgs.gametype = atoi( Info_ValueForKey( info, "g_gametype" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $157
ARGP4
ADDRLP4 12
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31456
ADDRLP4 16
INDIRI4
ASGNI4
line 150
;150:	trap_Cvar_Set("g_gametype", va("%i", cgs.gametype));
ADDRGP4 $158
ARGP4
ADDRGP4 cgs+31456
INDIRI4
ARGI4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
ADDRGP4 $157
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 151
;151:	cgs.dmflags = atoi( Info_ValueForKey( info, "dmflags" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $161
ARGP4
ADDRLP4 24
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31460
ADDRLP4 28
INDIRI4
ASGNI4
line 152
;152:	cgs.teamflags = atoi( Info_ValueForKey( info, "teamflags" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $163
ARGP4
ADDRLP4 32
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 32
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31464
ADDRLP4 36
INDIRI4
ASGNI4
line 153
;153:	cgs.fraglimit = atoi( Info_ValueForKey( info, "fraglimit" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $165
ARGP4
ADDRLP4 40
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 40
INDIRP4
ARGP4
ADDRLP4 44
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31468
ADDRLP4 44
INDIRI4
ASGNI4
line 154
;154:	cgs.capturelimit = atoi( Info_ValueForKey( info, "capturelimit" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $167
ARGP4
ADDRLP4 48
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 48
INDIRP4
ARGP4
ADDRLP4 52
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31472
ADDRLP4 52
INDIRI4
ASGNI4
line 155
;155:	cgs.timelimit = atoi( Info_ValueForKey( info, "timelimit" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $169
ARGP4
ADDRLP4 56
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 56
INDIRP4
ARGP4
ADDRLP4 60
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31476
ADDRLP4 60
INDIRI4
ASGNI4
line 156
;156:	cgs.maxclients = atoi( Info_ValueForKey( info, "sv_maxclients" ) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $171
ARGP4
ADDRLP4 64
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 64
INDIRP4
ARGP4
ADDRLP4 68
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31480
ADDRLP4 68
INDIRI4
ASGNI4
line 157
;157:	mapname = Info_ValueForKey( info, "mapname" );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $172
ARGP4
ADDRLP4 72
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 72
INDIRP4
ASGNP4
line 158
;158:	Com_sprintf( cgs.mapname, sizeof( cgs.mapname ), "maps/%s.bsp", mapname );
ADDRGP4 cgs+31484
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $175
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 159
;159:	Q_strncpyz( cgs.redTeam, Info_ValueForKey( info, "g_redTeam" ), sizeof(cgs.redTeam) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $177
ARGP4
ADDRLP4 76
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRGP4 cgs+31548
ARGP4
ADDRLP4 76
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 160
;160:	trap_Cvar_Set("g_redTeam", cgs.redTeam);
ADDRGP4 $177
ARGP4
ADDRGP4 cgs+31548
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 161
;161:	Q_strncpyz( cgs.blueTeam, Info_ValueForKey( info, "g_blueTeam" ), sizeof(cgs.blueTeam) );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $181
ARGP4
ADDRLP4 80
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRGP4 cgs+31612
ARGP4
ADDRLP4 80
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 162
;162:	trap_Cvar_Set("g_blueTeam", cgs.blueTeam);
ADDRGP4 $181
ARGP4
ADDRGP4 cgs+31612
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 163
;163:}
LABELV $155
endproc CG_ParseServerinfo 84 16
proc CG_ParseWarmup 24 8
line 170
;164:
;165:/*
;166:==================
;167:CG_ParseWarmup
;168:==================
;169:*/
;170:static void CG_ParseWarmup( void ) {
line 174
;171:	const char	*info;
;172:	int			warmup;
;173:
;174:	info = CG_ConfigString( CS_WARMUP );
CNSTI4 5
ARGI4
ADDRLP4 8
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 176
;175:
;176:	warmup = atoi( info );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 177
;177:	cg.warmupCount = -1;
ADDRGP4 cg+124660
CNSTI4 -1
ASGNI4
line 179
;178:
;179:	if ( warmup == 0 && cg.warmup ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
NEI4 $186
ADDRGP4 cg+124656
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $186
line 181
;180:
;181:	} else if ( warmup > 0 && cg.warmup <= 0 ) {
ADDRGP4 $187
JUMPV
LABELV $186
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 20
INDIRI4
LEI4 $189
ADDRGP4 cg+124656
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $189
line 187
;182:#ifdef MISSIONPACK
;183:		if (cgs.gametype >= GT_CTF && cgs.gametype <= GT_HARVESTER) {
;184:			trap_S_StartLocalSound( cgs.media.countPrepareTeamSound, CHAN_ANNOUNCER );
;185:		} else
;186:#endif
;187:		{
line 188
;188:			trap_S_StartLocalSound( cgs.media.countPrepareSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+972
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 189
;189:		}
line 190
;190:	}
LABELV $189
LABELV $187
line 192
;191:
;192:	cg.warmup = warmup;
ADDRGP4 cg+124656
ADDRLP4 0
INDIRI4
ASGNI4
line 193
;193:}
LABELV $184
endproc CG_ParseWarmup 24 8
export CG_SetConfigValues
proc CG_SetConfigValues 36 4
line 202
;194:
;195:/*
;196:================
;197:CG_SetConfigValues
;198:
;199:Called on load to set the initial values from configure strings
;200:================
;201:*/
;202:void CG_SetConfigValues( void ) {
line 205
;203:	const char *s;
;204:
;205:	cgs.scores1 = atoi( CG_ConfigString( CS_SCORES1 ) );
CNSTI4 6
ARGI4
ADDRLP4 4
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34800
ADDRLP4 8
INDIRI4
ASGNI4
line 206
;206:	cgs.scores2 = atoi( CG_ConfigString( CS_SCORES2 ) );
CNSTI4 7
ARGI4
ADDRLP4 12
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34804
ADDRLP4 16
INDIRI4
ASGNI4
line 207
;207:	cgs.levelStartTime = atoi( CG_ConfigString( CS_LEVEL_START_TIME ) );
CNSTI4 21
ARGI4
ADDRLP4 20
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34796
ADDRLP4 24
INDIRI4
ASGNI4
line 208
;208:	if( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $199
line 209
;209:		s = CG_ConfigString( CS_FLAGSTATUS );
CNSTI4 23
ARGI4
ADDRLP4 28
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
ASGNP4
line 210
;210:		cgs.redflag = s[0] - '0';
ADDRGP4 cgs+34808
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
ASGNI4
line 211
;211:		cgs.blueflag = s[1] - '0';
ADDRGP4 cgs+34812
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
ASGNI4
line 212
;212:	}
LABELV $199
line 219
;213:#ifdef MISSIONPACK
;214:	else if( cgs.gametype == GT_1FCTF ) {
;215:		s = CG_ConfigString( CS_FLAGSTATUS );
;216:		cgs.flagStatus = s[0] - '0';
;217:	}
;218:#endif
;219:	cg.warmup = atoi( CG_ConfigString( CS_WARMUP ) );
CNSTI4 5
ARGI4
ADDRLP4 28
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cg+124656
ADDRLP4 32
INDIRI4
ASGNI4
line 220
;220:}
LABELV $195
endproc CG_SetConfigValues 36 4
export CG_ShaderStateChanged
proc CG_ShaderStateChanged 188 12
line 227
;221:
;222:/*
;223:=====================
;224:CG_ShaderStateChanged
;225:=====================
;226:*/
;227:void CG_ShaderStateChanged(void) {
line 234
;228:	char originalShader[MAX_QPATH];
;229:	char newShader[MAX_QPATH];
;230:	char timeOffset[16];
;231:	const char *o;
;232:	char *n,*t;
;233:
;234:	o = CG_ConfigString( CS_SHADERSTATE );
CNSTI4 24
ARGI4
ADDRLP4 156
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 156
INDIRP4
ASGNP4
ADDRGP4 $207
JUMPV
LABELV $206
line 235
;235:	while (o && *o) {
line 236
;236:		n = strstr(o, "=");
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $209
ARGP4
ADDRLP4 160
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 160
INDIRP4
ASGNP4
line 237
;237:		if (n && *n) {
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $208
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $208
line 238
;238:			strncpy(originalShader, o, n-o);
ADDRLP4 12
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 239
;239:			originalShader[n-o] = 0;
ADDRLP4 4
INDIRP4
CVPU4 4
ADDRLP4 0
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ADDRLP4 12
ADDP4
CNSTI1 0
ASGNI1
line 240
;240:			n++;
ADDRLP4 4
ADDRLP4 4
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 241
;241:			t = strstr(n, ":");
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $212
ARGP4
ADDRLP4 172
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 172
INDIRP4
ASGNP4
line 242
;242:			if (t && *t) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $208
ADDRLP4 8
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $208
line 243
;243:				strncpy(newShader, n, t-n);
ADDRLP4 76
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 244
;244:				newShader[t-n] = 0;
ADDRLP4 8
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ADDRLP4 76
ADDP4
CNSTI1 0
ASGNI1
line 245
;245:			} else {
line 246
;246:				break;
LABELV $214
line 248
;247:			}
;248:			t++;
ADDRLP4 8
ADDRLP4 8
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 249
;249:			o = strstr(t, "@");
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $215
ARGP4
ADDRLP4 180
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 180
INDIRP4
ASGNP4
line 250
;250:			if (o) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $211
line 251
;251:				strncpy(timeOffset, t, o-t);
ADDRLP4 140
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 252
;252:				timeOffset[o-t] = 0;
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ADDRLP4 140
ADDP4
CNSTI1 0
ASGNI1
line 253
;253:				o++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 254
;254:				trap_R_RemapShader( originalShader, newShader, timeOffset );
ADDRLP4 12
ARGP4
ADDRLP4 76
ARGP4
ADDRLP4 140
ARGP4
ADDRGP4 trap_R_RemapShader
CALLV
pop
line 255
;255:			}
line 256
;256:		} else {
line 257
;257:			break;
LABELV $211
line 259
;258:		}
;259:	}
LABELV $207
line 235
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $218
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $206
LABELV $218
LABELV $208
line 260
;260:}
LABELV $205
endproc CG_ShaderStateChanged 188 12
proc CG_ConfigStringModified 48 12
line 268
;261:
;262:/*
;263:================
;264:CG_ConfigStringModified
;265:
;266:================
;267:*/
;268:static void CG_ConfigStringModified( void ) {
line 272
;269:	const char	*str;
;270:	int		num;
;271:
;272:	num = atoi( CG_Argv( 1 ) );
CNSTI4 1
ARGI4
ADDRLP4 8
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 276
;273:
;274:	// get the gamestate from the client system, which will have the
;275:	// new configstring already integrated
;276:	trap_GetGameState( &cgs.gameState );
ADDRGP4 cgs
ARGP4
ADDRGP4 trap_GetGameState
CALLV
pop
line 279
;277:
;278:	// look up the individual string that was modified
;279:	str = CG_ConfigString( num );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 16
INDIRP4
ASGNP4
line 282
;280:
;281:	// do something with it if necessary
;282:	if ( num == CS_MUSIC ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $220
line 283
;283:		CG_StartMusic();
ADDRGP4 CG_StartMusic
CALLV
pop
line 284
;284:	} else if ( num == CS_SERVERINFO ) {
ADDRGP4 $221
JUMPV
LABELV $220
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $222
line 285
;285:		CG_ParseServerinfo();
ADDRGP4 CG_ParseServerinfo
CALLV
pop
line 286
;286:	} else if ( num == CS_WARMUP ) {
ADDRGP4 $223
JUMPV
LABELV $222
ADDRLP4 0
INDIRI4
CNSTI4 5
NEI4 $224
line 287
;287:		CG_ParseWarmup();
ADDRGP4 CG_ParseWarmup
CALLV
pop
line 288
;288:	} else if ( num == CS_SCORES1 ) {
ADDRGP4 $225
JUMPV
LABELV $224
ADDRLP4 0
INDIRI4
CNSTI4 6
NEI4 $226
line 289
;289:		cgs.scores1 = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34800
ADDRLP4 20
INDIRI4
ASGNI4
line 290
;290:	} else if ( num == CS_SCORES2 ) {
ADDRGP4 $227
JUMPV
LABELV $226
ADDRLP4 0
INDIRI4
CNSTI4 7
NEI4 $229
line 291
;291:		cgs.scores2 = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34804
ADDRLP4 20
INDIRI4
ASGNI4
line 292
;292:	} else if ( num == CS_LEVEL_START_TIME ) {
ADDRGP4 $230
JUMPV
LABELV $229
ADDRLP4 0
INDIRI4
CNSTI4 21
NEI4 $232
line 293
;293:		cgs.levelStartTime = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34796
ADDRLP4 20
INDIRI4
ASGNI4
line 294
;294:	} else if ( num == CS_VOTE_TIME ) {
ADDRGP4 $233
JUMPV
LABELV $232
ADDRLP4 0
INDIRI4
CNSTI4 8
NEI4 $235
line 295
;295:		cgs.voteTime = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31676
ADDRLP4 20
INDIRI4
ASGNI4
line 296
;296:		cgs.voteModified = qtrue;
ADDRGP4 cgs+31688
CNSTI4 1
ASGNI4
line 297
;297:	} else if ( num == CS_VOTE_YES ) {
ADDRGP4 $236
JUMPV
LABELV $235
ADDRLP4 0
INDIRI4
CNSTI4 10
NEI4 $239
line 298
;298:		cgs.voteYes = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31680
ADDRLP4 20
INDIRI4
ASGNI4
line 299
;299:		cgs.voteModified = qtrue;
ADDRGP4 cgs+31688
CNSTI4 1
ASGNI4
line 300
;300:	} else if ( num == CS_VOTE_NO ) {
ADDRGP4 $240
JUMPV
LABELV $239
ADDRLP4 0
INDIRI4
CNSTI4 11
NEI4 $243
line 301
;301:		cgs.voteNo = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31684
ADDRLP4 20
INDIRI4
ASGNI4
line 302
;302:		cgs.voteModified = qtrue;
ADDRGP4 cgs+31688
CNSTI4 1
ASGNI4
line 303
;303:	} else if ( num == CS_VOTE_STRING ) {
ADDRGP4 $244
JUMPV
LABELV $243
ADDRLP4 0
INDIRI4
CNSTI4 9
NEI4 $247
line 304
;304:		Q_strncpyz( cgs.voteString, str, sizeof( cgs.voteString ) );
ADDRGP4 cgs+31692
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 308
;305:#ifdef MISSIONPACK
;306:		trap_S_StartLocalSound( cgs.media.voteNow, CHAN_ANNOUNCER );
;307:#endif //MISSIONPACK
;308:	} else if ( num >= CS_TEAMVOTE_TIME && num <= CS_TEAMVOTE_TIME + 1) {
ADDRGP4 $248
JUMPV
LABELV $247
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $251
ADDRLP4 0
INDIRI4
CNSTI4 13
GTI4 $251
line 309
;309:		cgs.teamVoteTime[num-CS_TEAMVOTE_TIME] = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32716-48
ADDP4
ADDRLP4 24
INDIRI4
ASGNI4
line 310
;310:		cgs.teamVoteModified[num-CS_TEAMVOTE_TIME] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740-48
ADDP4
CNSTI4 1
ASGNI4
line 311
;311:	} else if ( num >= CS_TEAMVOTE_YES && num <= CS_TEAMVOTE_YES + 1) {
ADDRGP4 $252
JUMPV
LABELV $251
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $257
ADDRLP4 0
INDIRI4
CNSTI4 17
GTI4 $257
line 312
;312:		cgs.teamVoteYes[num-CS_TEAMVOTE_YES] = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32724-64
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
line 313
;313:		cgs.teamVoteModified[num-CS_TEAMVOTE_YES] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740-64
ADDP4
CNSTI4 1
ASGNI4
line 314
;314:	} else if ( num >= CS_TEAMVOTE_NO && num <= CS_TEAMVOTE_NO + 1) {
ADDRGP4 $258
JUMPV
LABELV $257
ADDRLP4 0
INDIRI4
CNSTI4 18
LTI4 $263
ADDRLP4 0
INDIRI4
CNSTI4 19
GTI4 $263
line 315
;315:		cgs.teamVoteNo[num-CS_TEAMVOTE_NO] = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32732-72
ADDP4
ADDRLP4 32
INDIRI4
ASGNI4
line 316
;316:		cgs.teamVoteModified[num-CS_TEAMVOTE_NO] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740-72
ADDP4
CNSTI4 1
ASGNI4
line 317
;317:	} else if ( num >= CS_TEAMVOTE_STRING && num <= CS_TEAMVOTE_STRING + 1) {
ADDRGP4 $264
JUMPV
LABELV $263
ADDRLP4 0
INDIRI4
CNSTI4 14
LTI4 $269
ADDRLP4 0
INDIRI4
CNSTI4 15
GTI4 $269
line 318
;318:		Q_strncpyz( cgs.teamVoteString[num-CS_TEAMVOTE_STRING], str, sizeof( cgs.teamVoteString ) );
ADDRLP4 0
INDIRI4
CNSTI4 10
LSHI4
ADDRGP4 cgs+32748-14336
ADDP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
CNSTI4 2048
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 322
;319:#ifdef MISSIONPACK
;320:		trap_S_StartLocalSound( cgs.media.voteNow, CHAN_ANNOUNCER );
;321:#endif
;322:	} else if ( num == CS_INTERMISSION ) {
ADDRGP4 $270
JUMPV
LABELV $269
ADDRLP4 0
INDIRI4
CNSTI4 22
NEI4 $274
line 323
;323:		cg.intermissionStarted = atoi( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cg+24
ADDRLP4 36
INDIRI4
ASGNI4
line 324
;324:	} else if ( num >= CS_MODELS && num < CS_MODELS+MAX_MODELS ) {
ADDRGP4 $275
JUMPV
LABELV $274
ADDRLP4 0
INDIRI4
CNSTI4 32
LTI4 $277
ADDRLP4 0
INDIRI4
CNSTI4 288
GEI4 $277
line 325
;325:		cgs.gameModels[ num-CS_MODELS ] = trap_R_RegisterModel( str );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+34824-128
ADDP4
ADDRLP4 40
INDIRI4
ASGNI4
line 326
;326:	} else if ( num >= CS_SOUNDS && num < CS_SOUNDS+MAX_MODELS ) {
ADDRGP4 $278
JUMPV
LABELV $277
ADDRLP4 0
INDIRI4
CNSTI4 288
LTI4 $281
ADDRLP4 0
INDIRI4
CNSTI4 544
GEI4 $281
line 327
;327:		if ( str[0] != '*' ) {	// player specific sounds don't register here
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 42
EQI4 $282
line 328
;328:			cgs.gameSounds[ num-CS_SOUNDS] = trap_S_RegisterSound( str, qfalse );
ADDRLP4 4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 44
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848-1152
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
line 329
;329:		}
line 330
;330:	} else if ( num >= CS_PLAYERS && num < CS_PLAYERS+MAX_CLIENTS ) {
ADDRGP4 $282
JUMPV
LABELV $281
ADDRLP4 0
INDIRI4
CNSTI4 544
LTI4 $287
ADDRLP4 0
INDIRI4
CNSTI4 608
GEI4 $287
line 331
;331:		CG_NewClientInfo( num - CS_PLAYERS );
ADDRLP4 0
INDIRI4
CNSTI4 544
SUBI4
ARGI4
ADDRGP4 CG_NewClientInfo
CALLV
pop
line 332
;332:		CG_BuildSpectatorString();
ADDRGP4 CG_BuildSpectatorString
CALLV
pop
line 333
;333:	} else if ( num == CS_FLAGSTATUS ) {
ADDRGP4 $288
JUMPV
LABELV $287
ADDRLP4 0
INDIRI4
CNSTI4 23
NEI4 $289
line 334
;334:		if( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $290
line 336
;335:			// format is rb where its red/blue, 0 is at base, 1 is taken, 2 is dropped
;336:			cgs.redflag = str[0] - '0';
ADDRGP4 cgs+34808
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
ASGNI4
line 337
;337:			cgs.blueflag = str[1] - '0';
ADDRGP4 cgs+34812
ADDRLP4 4
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
ASGNI4
line 338
;338:		}
line 344
;339:#ifdef MISSIONPACK
;340:		else if( cgs.gametype == GT_1FCTF ) {
;341:			cgs.flagStatus = str[0] - '0';
;342:		}
;343:#endif
;344:	}
ADDRGP4 $290
JUMPV
LABELV $289
line 345
;345:	else if ( num == CS_SHADERSTATE ) {
ADDRLP4 0
INDIRI4
CNSTI4 24
NEI4 $296
line 346
;346:		CG_ShaderStateChanged();
ADDRGP4 CG_ShaderStateChanged
CALLV
pop
line 347
;347:	}
LABELV $296
LABELV $290
LABELV $288
LABELV $282
LABELV $278
LABELV $275
LABELV $270
LABELV $264
LABELV $258
LABELV $252
LABELV $248
LABELV $244
LABELV $240
LABELV $236
LABELV $233
LABELV $230
LABELV $227
LABELV $225
LABELV $223
LABELV $221
line 349
;348:		
;349:}
LABELV $219
endproc CG_ConfigStringModified 48 12
proc CG_AddToTeamChat 60 0
line 358
;350:
;351:
;352:/*
;353:=======================
;354:CG_AddToTeamChat
;355:
;356:=======================
;357:*/
;358:static void CG_AddToTeamChat( const char *str ) {
line 364
;359:	int len;
;360:	char *p, *ls;
;361:	int lastcolor;
;362:	int chatHeight;
;363:
;364:	if (cg_teamChatHeight.integer < TEAMCHAT_HEIGHT) {
ADDRGP4 cg_teamChatHeight+12
INDIRI4
CNSTI4 8
GEI4 $299
line 365
;365:		chatHeight = cg_teamChatHeight.integer;
ADDRLP4 12
ADDRGP4 cg_teamChatHeight+12
INDIRI4
ASGNI4
line 366
;366:	} else {
ADDRGP4 $300
JUMPV
LABELV $299
line 367
;367:		chatHeight = TEAMCHAT_HEIGHT;
ADDRLP4 12
CNSTI4 8
ASGNI4
line 368
;368:	}
LABELV $300
line 370
;369:
;370:	if (chatHeight <= 0 || cg_teamChatTime.integer <= 0) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 12
INDIRI4
ADDRLP4 20
INDIRI4
LEI4 $306
ADDRGP4 cg_teamChatTime+12
INDIRI4
ADDRLP4 20
INDIRI4
GTI4 $303
LABELV $306
line 372
;371:		// team chat disabled, dump into normal chat
;372:		cgs.teamChatPos = cgs.teamLastChatPos = 0;
ADDRLP4 24
CNSTI4 0
ASGNI4
ADDRGP4 cgs+152248
ADDRLP4 24
INDIRI4
ASGNI4
ADDRGP4 cgs+152244
ADDRLP4 24
INDIRI4
ASGNI4
line 373
;373:		return;
ADDRGP4 $298
JUMPV
LABELV $303
line 376
;374:	}
;375:
;376:	len = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 378
;377:
;378:	p = cgs.teamChatMsgs[cgs.teamChatPos % chatHeight];
ADDRLP4 0
CNSTI4 241
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 12
INDIRI4
MODI4
MULI4
ADDRGP4 cgs+150284
ADDP4
ASGNP4
line 379
;379:	*p = 0;
ADDRLP4 0
INDIRP4
CNSTI1 0
ASGNI1
line 381
;380:
;381:	lastcolor = '7';
ADDRLP4 16
CNSTI4 55
ASGNI4
line 383
;382:
;383:	ls = NULL;
ADDRLP4 8
CNSTP4 0
ASGNP4
ADDRGP4 $312
JUMPV
LABELV $311
line 384
;384:	while (*str) {
line 385
;385:		if (len > TEAMCHAT_WIDTH - 1) {
ADDRLP4 4
INDIRI4
CNSTI4 79
LEI4 $314
line 386
;386:			if (ls) {
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $316
line 387
;387:				str -= (p - ls);
ADDRFP4 0
ADDRFP4 0
INDIRP4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
SUBP4
ASGNP4
line 388
;388:				str++;
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 389
;389:				p -= (p - ls);
ADDRLP4 0
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
SUBP4
ASGNP4
line 390
;390:			}
LABELV $316
line 391
;391:			*p = 0;
ADDRLP4 0
INDIRP4
CNSTI1 0
ASGNI1
line 393
;392:
;393:			cgs.teamChatMsgTimes[cgs.teamChatPos % chatHeight] = cg.time;
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 12
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152212
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 395
;394:
;395:			cgs.teamChatPos++;
ADDRLP4 24
ADDRGP4 cgs+152244
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 396
;396:			p = cgs.teamChatMsgs[cgs.teamChatPos % chatHeight];
ADDRLP4 0
CNSTI4 241
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 12
INDIRI4
MODI4
MULI4
ADDRGP4 cgs+150284
ADDP4
ASGNP4
line 397
;397:			*p = 0;
ADDRLP4 0
INDIRP4
CNSTI1 0
ASGNI1
line 398
;398:			*p++ = Q_COLOR_ESCAPE;
ADDRLP4 28
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI1 94
ASGNI1
line 399
;399:			*p++ = lastcolor;
ADDRLP4 32
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 32
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 16
INDIRI4
CVII1 4
ASGNI1
line 400
;400:			len = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 401
;401:			ls = NULL;
ADDRLP4 8
CNSTP4 0
ASGNP4
line 402
;402:		}
LABELV $314
line 404
;403:
;404:		if ( Q_IsColorString( str ) ) {
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $324
ADDRLP4 28
CNSTI4 94
ASGNI4
ADDRLP4 24
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 28
INDIRI4
NEI4 $324
ADDRLP4 32
ADDRLP4 24
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
EQI4 $324
ADDRLP4 32
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $324
line 405
;405:			*p++ = *str++;
ADDRLP4 36
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 44
CNSTI4 1
ASGNI4
ADDRLP4 0
ADDRLP4 36
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ASGNP4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
ADDRLP4 40
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI1
ASGNI1
line 406
;406:			lastcolor = *str;
ADDRLP4 16
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
line 407
;407:			*p++ = *str++;
ADDRLP4 48
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRLP4 0
ADDRLP4 48
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ASGNP4
ADDRLP4 52
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
ADDRLP4 52
INDIRP4
ADDRLP4 56
INDIRI4
ADDP4
ASGNP4
ADDRLP4 48
INDIRP4
ADDRLP4 52
INDIRP4
INDIRI1
ASGNI1
line 408
;408:			continue;
ADDRGP4 $312
JUMPV
LABELV $324
line 410
;409:		}
;410:		if (*str == ' ') {
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 32
NEI4 $326
line 411
;411:			ls = p;
ADDRLP4 8
ADDRLP4 0
INDIRP4
ASGNP4
line 412
;412:		}
LABELV $326
line 413
;413:		*p++ = *str++;
ADDRLP4 36
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 44
CNSTI4 1
ASGNI4
ADDRLP4 0
ADDRLP4 36
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ASGNP4
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
ADDRLP4 40
INDIRP4
ADDRLP4 44
INDIRI4
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI1
ASGNI1
line 414
;414:		len++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 415
;415:	}
LABELV $312
line 384
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $311
line 416
;416:	*p = 0;
ADDRLP4 0
INDIRP4
CNSTI1 0
ASGNI1
line 418
;417:
;418:	cgs.teamChatMsgTimes[cgs.teamChatPos % chatHeight] = cg.time;
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 12
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152212
ADDP4
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 419
;419:	cgs.teamChatPos++;
ADDRLP4 24
ADDRGP4 cgs+152244
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 421
;420:
;421:	if (cgs.teamChatPos - cgs.teamLastChatPos > chatHeight)
ADDRGP4 cgs+152244
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
SUBI4
ADDRLP4 12
INDIRI4
LEI4 $332
line 422
;422:		cgs.teamLastChatPos = cgs.teamChatPos - chatHeight;
ADDRGP4 cgs+152248
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 12
INDIRI4
SUBI4
ASGNI4
LABELV $332
line 423
;423:}
LABELV $298
endproc CG_AddToTeamChat 60 0
proc CG_MapRestart 0 12
line 436
;424:
;425:/*
;426:===============
;427:CG_MapRestart
;428:
;429:The server has issued a map_restart, so the next snapshot
;430:is completely new and should not be interpolated to.
;431:
;432:A tournement restart will clear everything, but doesn't
;433:require a reload of all the media
;434:===============
;435:*/
;436:static void CG_MapRestart( void ) {
line 437
;437:	if ( cg_showmiss.integer ) {
ADDRGP4 cg_showmiss+12
INDIRI4
CNSTI4 0
EQI4 $339
line 438
;438:		CG_Printf( "CG_MapRestart\n" );
ADDRGP4 $342
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 439
;439:	}
LABELV $339
line 441
;440:
;441:	CG_InitLocalEntities();
ADDRGP4 CG_InitLocalEntities
CALLV
pop
line 442
;442:	CG_InitMarkPolys();
ADDRGP4 CG_InitMarkPolys
CALLV
pop
line 443
;443:	CG_ClearParticles ();
ADDRGP4 CG_ClearParticles
CALLV
pop
line 446
;444:
;445:	// make sure the "3 frags left" warnings play again
;446:	cg.fraglimitWarnings = 0;
ADDRGP4 cg+107620
CNSTI4 0
ASGNI4
line 448
;447:
;448:	cg.timelimitWarnings = 0;
ADDRGP4 cg+107616
CNSTI4 0
ASGNI4
line 450
;449:
;450:	cg.intermissionStarted = qfalse;
ADDRGP4 cg+24
CNSTI4 0
ASGNI4
line 452
;451:
;452:	cgs.voteTime = 0;
ADDRGP4 cgs+31676
CNSTI4 0
ASGNI4
line 454
;453:
;454:	cg.mapRestart = qtrue;
ADDRGP4 cg+107624
CNSTI4 1
ASGNI4
line 456
;455:
;456:	CG_StartMusic();
ADDRGP4 CG_StartMusic
CALLV
pop
line 458
;457:
;458:	trap_S_ClearLoopingSounds(qtrue);
CNSTI4 1
ARGI4
ADDRGP4 trap_S_ClearLoopingSounds
CALLV
pop
line 463
;459:
;460:	// we really should clear more parts of cg here and stop sounds
;461:
;462:	// play the "fight" sound if this is a restart without warmup
;463:	if ( cg.warmup == 0 /* && cgs.gametype == GT_TOURNAMENT */) {
ADDRGP4 cg+124656
INDIRI4
CNSTI4 0
NEI4 $348
line 464
;464:		trap_S_StartLocalSound( cgs.media.countFightSound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+968
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 465
;465:		CG_CenterPrint( "FIGHT!", 120, GIANTCHAR_WIDTH*2 );
ADDRGP4 $353
ARGP4
CNSTI4 120
ARGI4
CNSTI4 64
ARGI4
ADDRGP4 CG_CenterPrint
CALLV
pop
line 466
;466:	}
LABELV $348
line 475
;467:#ifdef MISSIONPACK
;468:	if (cg_singlePlayerActive.integer) {
;469:		trap_Cvar_Set("ui_matchStartTime", va("%i", cg.time));
;470:		if (cg_recordSPDemo.integer && cg_recordSPDemoName.string && *cg_recordSPDemoName.string) {
;471:			trap_SendConsoleCommand(va("set g_synchronousclients 1 ; record %s \n", cg_recordSPDemoName.string));
;472:		}
;473:	}
;474:#endif
;475:	trap_Cvar_Set("cg_thirdPerson", "0");
ADDRGP4 $354
ARGP4
ADDRGP4 $355
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 476
;476:}
LABELV $338
endproc CG_MapRestart 0 12
export CG_ParseVoiceChats
proc CG_ParseVoiceChats 16508 16
line 515
;477:
;478:#define MAX_VOICEFILESIZE	16384
;479:#define MAX_VOICEFILES		8
;480:#define MAX_VOICECHATS		64
;481:#define MAX_VOICESOUNDS		64
;482:#define MAX_CHATSIZE		64
;483:#define MAX_HEADMODELS		64
;484:
;485:typedef struct voiceChat_s
;486:{
;487:	char id[64];
;488:	int numSounds;
;489:	sfxHandle_t sounds[MAX_VOICESOUNDS];
;490:	char chats[MAX_VOICESOUNDS][MAX_CHATSIZE];
;491:} voiceChat_t;
;492:
;493:typedef struct voiceChatList_s
;494:{
;495:	char name[64];
;496:	int gender;
;497:	int numVoiceChats;
;498:	voiceChat_t voiceChats[MAX_VOICECHATS];
;499:} voiceChatList_t;
;500:
;501:typedef struct headModelVoiceChat_s
;502:{
;503:	char headmodel[64];
;504:	int voiceChatNum;
;505:} headModelVoiceChat_t;
;506:
;507:voiceChatList_t voiceChatLists[MAX_VOICEFILES];
;508:headModelVoiceChat_t headModelVoiceChat[MAX_HEADMODELS];
;509:
;510:/*
;511:=================
;512:CG_ParseVoiceChats
;513:=================
;514:*/
;515:int CG_ParseVoiceChats( const char *filename, voiceChatList_t *voiceChatList, int maxVoiceChats ) {
line 525
;516:	int	len, i;
;517:	fileHandle_t f;
;518:	char buf[MAX_VOICEFILESIZE];
;519:	char **p, *ptr;
;520:	char *token;
;521:	voiceChat_t *voiceChats;
;522:	qboolean compress;
;523:	sfxHandle_t sound;
;524:
;525:	compress = qtrue;
ADDRLP4 16
CNSTI4 1
ASGNI4
line 526
;526:	if (cg_buildScript.integer) {
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $357
line 527
;527:		compress = qfalse;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 528
;528:	}
LABELV $357
line 530
;529:
;530:	len = trap_FS_FOpenFile( filename, &f, FS_READ );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 28
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 16420
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 24
ADDRLP4 16420
INDIRI4
ASGNI4
line 531
;531:	if ( !f ) {
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $360
line 532
;532:		trap_Print( va( S_COLOR_RED "voice chat file not found: %s\n", filename ) );
ADDRGP4 $362
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 16424
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16424
INDIRP4
ARGP4
ADDRGP4 trap_Print
CALLV
pop
line 533
;533:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $356
JUMPV
LABELV $360
line 535
;534:	}
;535:	if ( len >= MAX_VOICEFILESIZE ) {
ADDRLP4 24
INDIRI4
CNSTI4 16384
LTI4 $363
line 536
;536:		trap_Print( va( S_COLOR_RED "voice chat file too large: %s is %i, max allowed is %i", filename, len, MAX_VOICEFILESIZE ) );
ADDRGP4 $365
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 24
INDIRI4
ARGI4
CNSTI4 16384
ARGI4
ADDRLP4 16424
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16424
INDIRP4
ARGP4
ADDRGP4 trap_Print
CALLV
pop
line 537
;537:		trap_FS_FCloseFile( f );
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 538
;538:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $356
JUMPV
LABELV $363
line 541
;539:	}
;540:
;541:	trap_FS_Read( buf, len, f );
ADDRLP4 32
ARGP4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 542
;542:	buf[len] = 0;
ADDRLP4 24
INDIRI4
ADDRLP4 32
ADDP4
CNSTI1 0
ASGNI1
line 543
;543:	trap_FS_FCloseFile( f );
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 545
;544:
;545:	ptr = buf;
ADDRLP4 16416
ADDRLP4 32
ASGNP4
line 546
;546:	p = &ptr;
ADDRLP4 12
ADDRLP4 16416
ASGNP4
line 548
;547:
;548:	Com_sprintf(voiceChatList->name, sizeof(voiceChatList->name), "%s", filename);
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 549
;549:	voiceChats = voiceChatList->voiceChats;
ADDRLP4 4
ADDRFP4 4
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
line 550
;550:	for ( i = 0; i < maxVoiceChats; i++ ) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRGP4 $370
JUMPV
LABELV $367
line 551
;551:		voiceChats[i].id[0] = 0;
CNSTI4 4420
ADDRLP4 20
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 552
;552:	}
LABELV $368
line 550
ADDRLP4 20
ADDRLP4 20
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $370
ADDRLP4 20
INDIRI4
ADDRFP4 8
INDIRI4
LTI4 $367
line 553
;553:	token = COM_ParseExt(p, qtrue);
ADDRLP4 12
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 16424
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16424
INDIRP4
ASGNP4
line 554
;554:	if (!token || token[0] == 0) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $373
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $371
LABELV $373
line 555
;555:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $356
JUMPV
LABELV $371
line 557
;556:	}
;557:	if (!Q_stricmp(token, "female")) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $376
ARGP4
ADDRLP4 16432
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16432
INDIRI4
CNSTI4 0
NEI4 $374
line 558
;558:		voiceChatList->gender = GENDER_FEMALE;
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 1
ASGNI4
line 559
;559:	}
ADDRGP4 $375
JUMPV
LABELV $374
line 560
;560:	else if (!Q_stricmp(token, "male")) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $379
ARGP4
ADDRLP4 16436
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16436
INDIRI4
CNSTI4 0
NEI4 $377
line 561
;561:		voiceChatList->gender = GENDER_MALE;
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
line 562
;562:	}
ADDRGP4 $378
JUMPV
LABELV $377
line 563
;563:	else if (!Q_stricmp(token, "neuter")) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $382
ARGP4
ADDRLP4 16440
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16440
INDIRI4
CNSTI4 0
NEI4 $380
line 564
;564:		voiceChatList->gender = GENDER_NEUTER;
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
CNSTI4 2
ASGNI4
line 565
;565:	}
ADDRGP4 $381
JUMPV
LABELV $380
line 566
;566:	else {
line 567
;567:		trap_Print( va( S_COLOR_RED "expected gender not found in voice chat file: %s\n", filename ) );
ADDRGP4 $383
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 16444
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16444
INDIRP4
ARGP4
ADDRGP4 trap_Print
CALLV
pop
line 568
;568:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $356
JUMPV
LABELV $381
LABELV $378
LABELV $375
line 571
;569:	}
;570:
;571:	voiceChatList->numVoiceChats = 0;
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
CNSTI4 0
ASGNI4
ADDRGP4 $385
JUMPV
LABELV $384
line 572
;572:	while ( 1 ) {
line 573
;573:		token = COM_ParseExt(p, qtrue);
ADDRLP4 12
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 16444
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16444
INDIRP4
ASGNP4
line 574
;574:		if (!token || token[0] == 0) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $389
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $387
LABELV $389
line 575
;575:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $356
JUMPV
LABELV $387
line 577
;576:		}
;577:		Com_sprintf(voiceChats[voiceChatList->numVoiceChats].id, sizeof( voiceChats[voiceChatList->numVoiceChats].id ), "%s", token);
CNSTI4 4420
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 578
;578:		token = COM_ParseExt(p, qtrue);
ADDRLP4 12
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 16452
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16452
INDIRP4
ASGNP4
line 579
;579:		if (Q_stricmp(token, "{")) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $392
ARGP4
ADDRLP4 16456
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16456
INDIRI4
CNSTI4 0
EQI4 $390
line 580
;580:			trap_Print( va( S_COLOR_RED "expected { found %s in voice chat file: %s\n", token, filename ) );
ADDRGP4 $393
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 16460
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16460
INDIRP4
ARGP4
ADDRGP4 trap_Print
CALLV
pop
line 581
;581:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $356
JUMPV
LABELV $390
line 583
;582:		}
;583:		voiceChats[voiceChatList->numVoiceChats].numSounds = 0;
CNSTI4 4420
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
CNSTI4 64
ADDP4
CNSTI4 0
ASGNI4
ADDRGP4 $395
JUMPV
LABELV $394
line 584
;584:		while(1) {
line 585
;585:			token = COM_ParseExt(p, qtrue);
ADDRLP4 12
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 16460
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16460
INDIRP4
ASGNP4
line 586
;586:			if (!token || token[0] == 0) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $399
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $397
LABELV $399
line 587
;587:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $356
JUMPV
LABELV $397
line 589
;588:			}
;589:			if (!Q_stricmp(token, "}"))
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $402
ARGP4
ADDRLP4 16468
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16468
INDIRI4
CNSTI4 0
NEI4 $400
line 590
;590:				break;
ADDRGP4 $396
JUMPV
LABELV $400
line 591
;591:			sound = trap_S_RegisterSound( token, compress );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 16472
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 16472
INDIRI4
ASGNI4
line 592
;592:			voiceChats[voiceChatList->numVoiceChats].sounds[voiceChats[voiceChatList->numVoiceChats].numSounds] = sound;
ADDRLP4 16476
CNSTI4 68
ASGNI4
ADDRLP4 16480
CNSTI4 4420
ADDRFP4 4
INDIRP4
ADDRLP4 16476
INDIRI4
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
ASGNP4
ADDRLP4 16480
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 16480
INDIRP4
ADDRLP4 16476
INDIRI4
ADDP4
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 593
;593:			token = COM_ParseExt(p, qtrue);
ADDRLP4 12
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 16484
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 16484
INDIRP4
ASGNP4
line 594
;594:			if (!token || token[0] == 0) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $405
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $403
LABELV $405
line 595
;595:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $356
JUMPV
LABELV $403
line 597
;596:			}
;597:			Com_sprintf(voiceChats[voiceChatList->numVoiceChats].chats[
ADDRLP4 16492
CNSTI4 4420
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
ASGNP4
ADDRLP4 16496
CNSTI4 64
ASGNI4
ADDRLP4 16492
INDIRP4
ADDRLP4 16496
INDIRI4
ADDP4
INDIRI4
CNSTI4 6
LSHI4
ADDRLP4 16492
INDIRP4
CNSTI4 324
ADDP4
ADDP4
ARGP4
ADDRLP4 16496
INDIRI4
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 599
;598:							voiceChats[voiceChatList->numVoiceChats].numSounds], MAX_CHATSIZE, "%s", token);
;599:			if (sound)
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $406
line 600
;600:				voiceChats[voiceChatList->numVoiceChats].numSounds++;
ADDRLP4 16500
CNSTI4 4420
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
CNSTI4 64
ADDP4
ASGNP4
ADDRLP4 16500
INDIRP4
ADDRLP4 16500
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $406
line 601
;601:			if (voiceChats[voiceChatList->numVoiceChats].numSounds >= MAX_VOICESOUNDS)
ADDRLP4 16504
CNSTI4 64
ASGNI4
CNSTI4 4420
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 16504
INDIRI4
ADDP4
INDIRI4
ADDRLP4 16504
INDIRI4
LTI4 $408
line 602
;602:				break;
ADDRGP4 $396
JUMPV
LABELV $408
line 603
;603:		}
LABELV $395
line 584
ADDRGP4 $394
JUMPV
LABELV $396
line 604
;604:		voiceChatList->numVoiceChats++;
ADDRLP4 16460
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
ASGNP4
ADDRLP4 16460
INDIRP4
ADDRLP4 16460
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 605
;605:		if (voiceChatList->numVoiceChats >= maxVoiceChats)
ADDRFP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ADDRFP4 8
INDIRI4
LTI4 $410
line 606
;606:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $356
JUMPV
LABELV $410
line 607
;607:	}
LABELV $385
line 572
ADDRGP4 $384
JUMPV
line 608
;608:	return qtrue;
CNSTI4 1
RETI4
LABELV $356
endproc CG_ParseVoiceChats 16508 16
export CG_LoadVoiceChats
proc CG_LoadVoiceChats 12 12
line 616
;609:}
;610:
;611:/*
;612:=================
;613:CG_LoadVoiceChats
;614:=================
;615:*/
;616:void CG_LoadVoiceChats( void ) {
line 619
;617:	int size;
;618:
;619:	size = trap_MemoryRemaining();
ADDRLP4 4
ADDRGP4 trap_MemoryRemaining
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 620
;620:	CG_ParseVoiceChats( "scripts/female1.voice", &voiceChatLists[0], MAX_VOICECHATS );
ADDRGP4 $413
ARGP4
ADDRGP4 voiceChatLists
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 621
;621:	CG_ParseVoiceChats( "scripts/female2.voice", &voiceChatLists[1], MAX_VOICECHATS );
ADDRGP4 $414
ARGP4
ADDRGP4 voiceChatLists+282952
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 622
;622:	CG_ParseVoiceChats( "scripts/female3.voice", &voiceChatLists[2], MAX_VOICECHATS );
ADDRGP4 $416
ARGP4
ADDRGP4 voiceChatLists+565904
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 623
;623:	CG_ParseVoiceChats( "scripts/male1.voice", &voiceChatLists[3], MAX_VOICECHATS );
ADDRGP4 $418
ARGP4
ADDRGP4 voiceChatLists+848856
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 624
;624:	CG_ParseVoiceChats( "scripts/male2.voice", &voiceChatLists[4], MAX_VOICECHATS );
ADDRGP4 $420
ARGP4
ADDRGP4 voiceChatLists+1131808
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 625
;625:	CG_ParseVoiceChats( "scripts/male3.voice", &voiceChatLists[5], MAX_VOICECHATS );
ADDRGP4 $422
ARGP4
ADDRGP4 voiceChatLists+1414760
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 626
;626:	CG_ParseVoiceChats( "scripts/male4.voice", &voiceChatLists[6], MAX_VOICECHATS );
ADDRGP4 $424
ARGP4
ADDRGP4 voiceChatLists+1697712
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 627
;627:	CG_ParseVoiceChats( "scripts/male5.voice", &voiceChatLists[7], MAX_VOICECHATS );
ADDRGP4 $426
ARGP4
ADDRGP4 voiceChatLists+1980664
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 CG_ParseVoiceChats
CALLI4
pop
line 628
;628:	CG_Printf("voice chat memory size = %d\n", size - trap_MemoryRemaining());
ADDRLP4 8
ADDRGP4 trap_MemoryRemaining
CALLI4
ASGNI4
ADDRGP4 $428
ARGP4
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
SUBI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
line 629
;629:}
LABELV $412
endproc CG_LoadVoiceChats 12 12
export CG_HeadModelVoiceChats
proc CG_HeadModelVoiceChats 16424 16
line 636
;630:
;631:/*
;632:=================
;633:CG_HeadModelVoiceChats
;634:=================
;635:*/
;636:int CG_HeadModelVoiceChats( char *filename ) {
line 643
;637:	int	len, i;
;638:	fileHandle_t f;
;639:	char buf[MAX_VOICEFILESIZE];
;640:	char **p, *ptr;
;641:	char *token;
;642:
;643:	len = trap_FS_FOpenFile( filename, &f, FS_READ );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 16408
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 16408
INDIRI4
ASGNI4
line 644
;644:	if ( !f ) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $430
line 646
;645:		//trap_Print( va( "voice chat file not found: %s\n", filename ) );
;646:		return -1;
CNSTI4 -1
RETI4
ADDRGP4 $429
JUMPV
LABELV $430
line 648
;647:	}
;648:	if ( len >= MAX_VOICEFILESIZE ) {
ADDRLP4 8
INDIRI4
CNSTI4 16384
LTI4 $432
line 649
;649:		trap_Print( va( S_COLOR_RED "voice chat file too large: %s is %i, max allowed is %i", filename, len, MAX_VOICEFILESIZE ) );
ADDRGP4 $365
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
CNSTI4 16384
ARGI4
ADDRLP4 16412
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16412
INDIRP4
ARGP4
ADDRGP4 trap_Print
CALLV
pop
line 650
;650:		trap_FS_FCloseFile( f );
ADDRLP4 12
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 651
;651:		return -1;
CNSTI4 -1
RETI4
ADDRGP4 $429
JUMPV
LABELV $432
line 654
;652:	}
;653:
;654:	trap_FS_Read( buf, len, f );
ADDRLP4 16
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
line 655
;655:	buf[len] = 0;
ADDRLP4 8
INDIRI4
ADDRLP4 16
ADDP4
CNSTI1 0
ASGNI1
line 656
;656:	trap_FS_FCloseFile( f );
ADDRLP4 12
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
line 658
;657:
;658:	ptr = buf;
ADDRLP4 16404
ADDRLP4 16
ASGNP4
line 659
;659:	p = &ptr;
ADDRLP4 16400
ADDRLP4 16404
ASGNP4
line 661
;660:
;661:	token = COM_ParseExt(p, qtrue);
ADDRLP4 16400
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 16412
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 16412
INDIRP4
ASGNP4
line 662
;662:	if (!token || token[0] == 0) {
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $436
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $434
LABELV $436
line 663
;663:		return -1;
CNSTI4 -1
RETI4
ADDRGP4 $429
JUMPV
LABELV $434
line 666
;664:	}
;665:
;666:	for ( i = 0; i < MAX_VOICEFILES; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $437
line 667
;667:		if ( !Q_stricmp(token, voiceChatLists[i].name) ) {
ADDRLP4 4
INDIRP4
ARGP4
CNSTI4 282952
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 voiceChatLists
ADDP4
ARGP4
ADDRLP4 16420
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16420
INDIRI4
CNSTI4 0
NEI4 $441
line 668
;668:			return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $429
JUMPV
LABELV $441
line 670
;669:		}
;670:	}
LABELV $438
line 666
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 8
LTI4 $437
line 674
;671:
;672:	//FIXME: maybe try to load the .voice file which name is stored in token?
;673:
;674:	return -1;
CNSTI4 -1
RETI4
LABELV $429
endproc CG_HeadModelVoiceChats 16424 16
export CG_GetVoiceChat
proc CG_GetVoiceChat 16 8
line 683
;675:}
;676:
;677:
;678:/*
;679:=================
;680:CG_GetVoiceChat
;681:=================
;682:*/
;683:int CG_GetVoiceChat( voiceChatList_t *voiceChatList, const char *id, sfxHandle_t *snd, char **chat) {
line 686
;684:	int i, rnd;
;685:
;686:	for ( i = 0; i < voiceChatList->numVoiceChats; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $447
JUMPV
LABELV $444
line 687
;687:		if ( !Q_stricmp( id, voiceChatList->voiceChats[i].id ) ) {
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 4420
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $448
line 688
;688:			rnd = random() * voiceChatList->voiceChats[i].numSounds;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTI4 4420
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDP4
CNSTI4 64
ADDP4
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 689
;689:			*snd = voiceChatList->voiceChats[i].sounds[rnd];
ADDRFP4 8
INDIRP4
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
CNSTI4 4420
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDP4
CNSTI4 68
ADDP4
ADDP4
INDIRI4
ASGNI4
line 690
;690:			*chat = voiceChatList->voiceChats[i].chats[rnd];
ADDRFP4 12
INDIRP4
ADDRLP4 4
INDIRI4
CNSTI4 6
LSHI4
CNSTI4 4420
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDP4
CNSTI4 324
ADDP4
ADDP4
ASGNP4
line 691
;691:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $443
JUMPV
LABELV $448
line 693
;692:		}
;693:	}
LABELV $445
line 686
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $447
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
LTI4 $444
line 694
;694:	return qfalse;
CNSTI4 0
RETI4
LABELV $443
endproc CG_GetVoiceChat 16 8
export CG_VoiceChatListForClient
proc CG_VoiceChatListForClient 164 20
line 702
;695:}
;696:
;697:/*
;698:=================
;699:CG_VoiceChatListForClient
;700:=================
;701:*/
;702:voiceChatList_t *CG_VoiceChatListForClient( int clientNum ) {
line 707
;703:	clientInfo_t *ci;
;704:	int voiceChatNum, i, j, k, gender;
;705:	char filename[MAX_QPATH], headModelName[MAX_QPATH];
;706:
;707:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ) {
ADDRLP4 152
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 0
LTI4 $453
ADDRLP4 152
INDIRI4
CNSTI4 64
LTI4 $451
LABELV $453
line 708
;708:		clientNum = 0;
ADDRFP4 0
CNSTI4 0
ASGNI4
line 709
;709:	}
LABELV $451
line 710
;710:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 148
CNSTI4 1708
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 712
;711:
;712:	for ( k = 0; k < 2; k++ ) {
ADDRLP4 144
CNSTI4 0
ASGNI4
LABELV $455
line 713
;713:		if ( k == 0 ) {
ADDRLP4 144
INDIRI4
CNSTI4 0
NEI4 $459
line 714
;714:			if (ci->headModelName[0] == '*') {
ADDRLP4 148
INDIRP4
CNSTI4 288
ADDP4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $461
line 715
;715:				Com_sprintf( headModelName, sizeof(headModelName), "%s/%s", ci->headModelName+1, ci->headSkinName );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $463
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 289
ADDP4
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 352
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 716
;716:			}
ADDRGP4 $460
JUMPV
LABELV $461
line 717
;717:			else {
line 718
;718:				Com_sprintf( headModelName, sizeof(headModelName), "%s/%s", ci->headModelName, ci->headSkinName );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $463
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 288
ADDP4
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 352
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 719
;719:			}
line 720
;720:		}
ADDRGP4 $460
JUMPV
LABELV $459
line 721
;721:		else {
line 722
;722:			if (ci->headModelName[0] == '*') {
ADDRLP4 148
INDIRP4
CNSTI4 288
ADDP4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $464
line 723
;723:				Com_sprintf( headModelName, sizeof(headModelName), "%s", ci->headModelName+1 );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 289
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 724
;724:			}
ADDRGP4 $465
JUMPV
LABELV $464
line 725
;725:			else {
line 726
;726:				Com_sprintf( headModelName, sizeof(headModelName), "%s", ci->headModelName );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 288
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 727
;727:			}
LABELV $465
line 728
;728:		}
LABELV $460
line 730
;729:		// find the voice file for the head model the client uses
;730:		for ( i = 0; i < MAX_HEADMODELS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $466
line 731
;731:			if (!Q_stricmp(headModelVoiceChat[i].headmodel, headModelName)) {
CNSTI4 68
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 156
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
NEI4 $470
line 732
;732:				break;
ADDRGP4 $468
JUMPV
LABELV $470
line 734
;733:			}
;734:		}
LABELV $467
line 730
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $466
LABELV $468
line 735
;735:		if (i < MAX_HEADMODELS) {
ADDRLP4 0
INDIRI4
CNSTI4 64
GEI4 $472
line 736
;736:			return &voiceChatLists[headModelVoiceChat[i].voiceChatNum];
CNSTI4 282952
CNSTI4 68
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat+64
ADDP4
INDIRI4
MULI4
ADDRGP4 voiceChatLists
ADDP4
RETP4
ADDRGP4 $450
JUMPV
LABELV $472
line 739
;737:		}
;738:		// find a <headmodelname>.vc file
;739:		for ( i = 0; i < MAX_HEADMODELS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $475
line 740
;740:			if (!strlen(headModelVoiceChat[i].headmodel)) {
CNSTI4 68
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
ADDRLP4 156
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
NEI4 $479
line 741
;741:				Com_sprintf(filename, sizeof(filename), "scripts/%s.vc", headModelName);
ADDRLP4 76
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $481
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 742
;742:				voiceChatNum = CG_HeadModelVoiceChats(filename);
ADDRLP4 76
ARGP4
ADDRLP4 160
ADDRGP4 CG_HeadModelVoiceChats
CALLI4
ASGNI4
ADDRLP4 72
ADDRLP4 160
INDIRI4
ASGNI4
line 743
;743:				if (voiceChatNum == -1)
ADDRLP4 72
INDIRI4
CNSTI4 -1
NEI4 $482
line 744
;744:					break;
ADDRGP4 $477
JUMPV
LABELV $482
line 745
;745:				Com_sprintf(headModelVoiceChat[i].headmodel, sizeof ( headModelVoiceChat[i].headmodel ),
CNSTI4 68
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 747
;746:							"%s", headModelName);
;747:				headModelVoiceChat[i].voiceChatNum = voiceChatNum;
CNSTI4 68
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat+64
ADDP4
ADDRLP4 72
INDIRI4
ASGNI4
line 748
;748:				return &voiceChatLists[headModelVoiceChat[i].voiceChatNum];
CNSTI4 282952
CNSTI4 68
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat+64
ADDP4
INDIRI4
MULI4
ADDRGP4 voiceChatLists
ADDP4
RETP4
ADDRGP4 $450
JUMPV
LABELV $479
line 750
;749:			}
;750:		}
LABELV $476
line 739
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $475
LABELV $477
line 751
;751:	}
LABELV $456
line 712
ADDRLP4 144
ADDRLP4 144
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 2
LTI4 $455
line 752
;752:	gender = ci->gender;
ADDRLP4 140
ADDRLP4 148
INDIRP4
CNSTI4 512
ADDP4
INDIRI4
ASGNI4
line 753
;753:	for (k = 0; k < 2; k++) {
ADDRLP4 144
CNSTI4 0
ASGNI4
LABELV $486
line 755
;754:		// just pick the first with the right gender
;755:		for ( i = 0; i < MAX_VOICEFILES; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $490
line 756
;756:			if (strlen(voiceChatLists[i].name)) {
CNSTI4 282952
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 voiceChatLists
ADDP4
ARGP4
ADDRLP4 156
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
EQI4 $494
line 757
;757:				if (voiceChatLists[i].gender == gender) {
CNSTI4 282952
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 voiceChatLists+64
ADDP4
INDIRI4
ADDRLP4 140
INDIRI4
NEI4 $496
line 759
;758:					// store this head model with voice chat for future reference
;759:					for ( j = 0; j < MAX_HEADMODELS; j++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $499
line 760
;760:						if (!strlen(headModelVoiceChat[j].headmodel)) {
CNSTI4 68
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
ADDRLP4 160
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $503
line 761
;761:							Com_sprintf(headModelVoiceChat[j].headmodel, sizeof ( headModelVoiceChat[j].headmodel ),
CNSTI4 68
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 763
;762:									"%s", headModelName);
;763:							headModelVoiceChat[j].voiceChatNum = i;
CNSTI4 68
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat+64
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 764
;764:							break;
ADDRGP4 $501
JUMPV
LABELV $503
line 766
;765:						}
;766:					}
LABELV $500
line 759
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $499
LABELV $501
line 767
;767:					return &voiceChatLists[i];
CNSTI4 282952
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 voiceChatLists
ADDP4
RETP4
ADDRGP4 $450
JUMPV
LABELV $496
line 769
;768:				}
;769:			}
LABELV $494
line 770
;770:		}
LABELV $491
line 755
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 8
LTI4 $490
line 772
;771:		// fall back to male gender because we don't have neuter in the mission pack
;772:		if (gender == GENDER_MALE)
ADDRLP4 140
INDIRI4
CNSTI4 0
NEI4 $506
line 773
;773:			break;
ADDRGP4 $488
JUMPV
LABELV $506
line 774
;774:		gender = GENDER_MALE;
ADDRLP4 140
CNSTI4 0
ASGNI4
line 775
;775:	}
LABELV $487
line 753
ADDRLP4 144
ADDRLP4 144
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 2
LTI4 $486
LABELV $488
line 777
;776:	// store this head model with voice chat for future reference
;777:	for ( j = 0; j < MAX_HEADMODELS; j++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $508
line 778
;778:		if (!strlen(headModelVoiceChat[j].headmodel)) {
CNSTI4 68
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
ADDRLP4 156
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
NEI4 $512
line 779
;779:			Com_sprintf(headModelVoiceChat[j].headmodel, sizeof ( headModelVoiceChat[j].headmodel ),
CNSTI4 68
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $366
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 781
;780:					"%s", headModelName);
;781:			headModelVoiceChat[j].voiceChatNum = 0;
CNSTI4 68
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 headModelVoiceChat+64
ADDP4
CNSTI4 0
ASGNI4
line 782
;782:			break;
ADDRGP4 $510
JUMPV
LABELV $512
line 784
;783:		}
;784:	}
LABELV $509
line 777
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $508
LABELV $510
line 786
;785:	// just return the first voice chat list
;786:	return &voiceChatLists[0];
ADDRGP4 voiceChatLists
RETP4
LABELV $450
endproc CG_VoiceChatListForClient 164 20
export CG_PlayVoiceChat
proc CG_PlayVoiceChat 0 0
line 807
;787:}
;788:
;789:#define MAX_VOICECHATBUFFER		32
;790:
;791:typedef struct bufferedVoiceChat_s
;792:{
;793:	int clientNum;
;794:	sfxHandle_t snd;
;795:	int voiceOnly;
;796:	char cmd[MAX_SAY_TEXT];
;797:	char message[MAX_SAY_TEXT];
;798:} bufferedVoiceChat_t;
;799:
;800:bufferedVoiceChat_t voiceChatBuffer[MAX_VOICECHATBUFFER];
;801:
;802:/*
;803:=================
;804:CG_PlayVoiceChat
;805:=================
;806:*/
;807:void CG_PlayVoiceChat( bufferedVoiceChat_t *vchat ) {
line 834
;808:#ifdef MISSIONPACK
;809:	// if we are going into the intermission, don't start any voices
;810:	if ( cg.intermissionStarted ) {
;811:		return;
;812:	}
;813:
;814:	if ( !cg_noVoiceChats.integer ) {
;815:		trap_S_StartLocalSound( vchat->snd, CHAN_VOICE);
;816:		if (vchat->clientNum != cg.snap->ps.clientNum) {
;817:			int orderTask = CG_ValidOrder(vchat->cmd);
;818:			if (orderTask > 0) {
;819:				cgs.acceptOrderTime = cg.time + 5000;
;820:				Q_strncpyz(cgs.acceptVoice, vchat->cmd, sizeof(cgs.acceptVoice));
;821:				cgs.acceptTask = orderTask;
;822:				cgs.acceptLeader = vchat->clientNum;
;823:			}
;824:			// see if this was an order
;825:			CG_ShowResponseHead();
;826:		}
;827:	}
;828:	if (!vchat->voiceOnly && !cg_noVoiceText.integer) {
;829:		CG_AddToTeamChat( vchat->message );
;830:		CG_Printf( "%s\n", vchat->message );
;831:	}
;832:	voiceChatBuffer[cg.voiceChatBufferOut].snd = 0;
;833:#endif
;834:}
LABELV $515
endproc CG_PlayVoiceChat 0 0
export CG_PlayBufferedVoiceChats
proc CG_PlayBufferedVoiceChats 0 0
line 841
;835:
;836:/*
;837:=====================
;838:CG_PlayBufferedVoieChats
;839:=====================
;840:*/
;841:void CG_PlayBufferedVoiceChats( void ) {
line 853
;842:#ifdef MISSIONPACK
;843:	if ( cg.voiceChatTime < cg.time ) {
;844:		if (cg.voiceChatBufferOut != cg.voiceChatBufferIn && voiceChatBuffer[cg.voiceChatBufferOut].snd) {
;845:			//
;846:			CG_PlayVoiceChat(&voiceChatBuffer[cg.voiceChatBufferOut]);
;847:			//
;848:			cg.voiceChatBufferOut = (cg.voiceChatBufferOut + 1) % MAX_VOICECHATBUFFER;
;849:			cg.voiceChatTime = cg.time + 1000;
;850:		}
;851:	}
;852:#endif
;853:}
LABELV $516
endproc CG_PlayBufferedVoiceChats 0 0
export CG_AddBufferedVoiceChat
proc CG_AddBufferedVoiceChat 0 0
line 860
;854:
;855:/*
;856:=====================
;857:CG_AddBufferedVoiceChat
;858:=====================
;859:*/
;860:void CG_AddBufferedVoiceChat( bufferedVoiceChat_t *vchat ) {
line 874
;861:#ifdef MISSIONPACK
;862:	// if we are going into the intermission, don't start any voices
;863:	if ( cg.intermissionStarted ) {
;864:		return;
;865:	}
;866:
;867:	memcpy(&voiceChatBuffer[cg.voiceChatBufferIn], vchat, sizeof(bufferedVoiceChat_t));
;868:	cg.voiceChatBufferIn = (cg.voiceChatBufferIn + 1) % MAX_VOICECHATBUFFER;
;869:	if (cg.voiceChatBufferIn == cg.voiceChatBufferOut) {
;870:		CG_PlayVoiceChat( &voiceChatBuffer[cg.voiceChatBufferOut] );
;871:		cg.voiceChatBufferOut++;
;872:	}
;873:#endif
;874:}
LABELV $517
endproc CG_AddBufferedVoiceChat 0 0
export CG_VoiceChatLocal
proc CG_VoiceChatLocal 0 0
line 881
;875:
;876:/*
;877:=================
;878:CG_VoiceChatLocal
;879:=================
;880:*/
;881:void CG_VoiceChatLocal( int mode, qboolean voiceOnly, int clientNum, int color, const char *cmd ) {
line 923
;882:#ifdef MISSIONPACK
;883:	char *chat;
;884:	voiceChatList_t *voiceChatList;
;885:	clientInfo_t *ci;
;886:	sfxHandle_t snd;
;887:	bufferedVoiceChat_t vchat;
;888:
;889:	// if we are going into the intermission, don't start any voices
;890:	if ( cg.intermissionStarted ) {
;891:		return;
;892:	}
;893:
;894:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ) {
;895:		clientNum = 0;
;896:	}
;897:	ci = &cgs.clientinfo[ clientNum ];
;898:
;899:	cgs.currentVoiceClient = clientNum;
;900:
;901:	voiceChatList = CG_VoiceChatListForClient( clientNum );
;902:
;903:	if ( CG_GetVoiceChat( voiceChatList, cmd, &snd, &chat ) ) {
;904:		//
;905:		if ( mode == SAY_TEAM || !cg_teamChatsOnly.integer ) {
;906:			vchat.clientNum = clientNum;
;907:			vchat.snd = snd;
;908:			vchat.voiceOnly = voiceOnly;
;909:			Q_strncpyz(vchat.cmd, cmd, sizeof(vchat.cmd));
;910:			if ( mode == SAY_TELL ) {
;911:				Com_sprintf(vchat.message, sizeof(vchat.message), "[%s]: %c%c%s", ci->name, Q_COLOR_ESCAPE, color, chat);
;912:			}
;913:			else if ( mode == SAY_TEAM ) {
;914:				Com_sprintf(vchat.message, sizeof(vchat.message), "(%s): %c%c%s", ci->name, Q_COLOR_ESCAPE, color, chat);
;915:			}
;916:			else {
;917:				Com_sprintf(vchat.message, sizeof(vchat.message), "%s: %c%c%s", ci->name, Q_COLOR_ESCAPE, color, chat);
;918:			}
;919:			CG_AddBufferedVoiceChat(&vchat);
;920:		}
;921:	}
;922:#endif
;923:}
LABELV $518
endproc CG_VoiceChatLocal 0 0
export CG_VoiceChat
proc CG_VoiceChat 0 0
line 930
;924:
;925:/*
;926:=================
;927:CG_VoiceChat
;928:=================
;929:*/
;930:void CG_VoiceChat( int mode ) {
line 951
;931:#ifdef MISSIONPACK
;932:	const char *cmd;
;933:	int clientNum, color;
;934:	qboolean voiceOnly;
;935:
;936:	voiceOnly = atoi(CG_Argv(1));
;937:	clientNum = atoi(CG_Argv(2));
;938:	color = atoi(CG_Argv(3));
;939:	cmd = CG_Argv(4);
;940:
;941:	if (cg_noTaunt.integer != 0) {
;942:		if (!strcmp(cmd, VOICECHAT_KILLINSULT)  || !strcmp(cmd, VOICECHAT_TAUNT) || \
;943:			!strcmp(cmd, VOICECHAT_DEATHINSULT) || !strcmp(cmd, VOICECHAT_KILLGAUNTLET) || \
;944:			!strcmp(cmd, VOICECHAT_PRAISE)) {
;945:			return;
;946:		}
;947:	}
;948:
;949:	CG_VoiceChatLocal( mode, voiceOnly, clientNum, color, cmd );
;950:#endif
;951:}
LABELV $519
endproc CG_VoiceChat 0 0
proc CG_RemoveChatEscapeChar 16 0
line 958
;952:
;953:/*
;954:=================
;955:CG_RemoveChatEscapeChar
;956:=================
;957:*/
;958:static void CG_RemoveChatEscapeChar( char *text ) {
line 961
;959:	int i, l;
;960:
;961:	l = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 962
;962:	for ( i = 0; text[i]; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $524
JUMPV
LABELV $521
line 963
;963:		if (text[i] == '\x19')
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
CNSTI4 25
NEI4 $525
line 964
;964:			continue;
ADDRGP4 $522
JUMPV
LABELV $525
line 965
;965:		text[l++] = text[i];
ADDRLP4 8
ADDRLP4 4
INDIRI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRI4
ADDRLP4 12
INDIRP4
ADDP4
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRP4
ADDP4
INDIRI1
ASGNI1
line 966
;966:	}
LABELV $522
line 962
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $524
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $521
line 967
;967:	text[l] = '\0';
ADDRLP4 4
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 968
;968:}
LABELV $520
endproc CG_RemoveChatEscapeChar 16 0
proc CG_ServerCommand 224 12
line 978
;969:
;970:/*
;971:=================
;972:CG_ServerCommand
;973:
;974:The string has been tokenized and can be retrieved with
;975:Cmd_Argc() / Cmd_Argv()
;976:=================
;977:*/
;978:static void CG_ServerCommand( void ) {
line 982
;979:	const char	*cmd;
;980:	char		text[MAX_SAY_TEXT];
;981:
;982:	cmd = CG_Argv(0);
CNSTI4 0
ARGI4
ADDRLP4 156
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 156
INDIRP4
ASGNP4
line 984
;983:
;984:	if ( !cmd[0] ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $528
line 986
;985:		// server claimed the command
;986:		return;
ADDRGP4 $527
JUMPV
LABELV $528
line 989
;987:	}
;988:
;989:	if ( !strcmp( cmd, "cp" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $532
ARGP4
ADDRLP4 160
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $530
line 990
;990:		CG_CenterPrint( CG_Argv(1), SCREEN_HEIGHT * 0.30, BIGCHAR_WIDTH );
CNSTI4 1
ARGI4
ADDRLP4 164
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 164
INDIRP4
ARGP4
CNSTI4 144
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 CG_CenterPrint
CALLV
pop
line 991
;991:		return;
ADDRGP4 $527
JUMPV
LABELV $530
line 994
;992:	}
;993:
;994:	if ( !strcmp( cmd, "cs" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $535
ARGP4
ADDRLP4 164
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 164
INDIRI4
CNSTI4 0
NEI4 $533
line 995
;995:		CG_ConfigStringModified();
ADDRGP4 CG_ConfigStringModified
CALLV
pop
line 996
;996:		return;
ADDRGP4 $527
JUMPV
LABELV $533
line 999
;997:	}
;998:
;999:	if ( !strcmp( cmd, "print" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $538
ARGP4
ADDRLP4 168
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 168
INDIRI4
CNSTI4 0
NEI4 $536
line 1000
;1000:		CG_Printf( "%s", CG_Argv(1) );
CNSTI4 1
ARGI4
ADDRLP4 172
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRGP4 $366
ARGP4
ADDRLP4 172
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1010
;1001:#ifdef MISSIONPACK
;1002:		cmd = CG_Argv(1);			// yes, this is obviously a hack, but so is the way we hear about
;1003:									// votes passing or failing
;1004:		if ( !Q_stricmpn( cmd, "vote failed", 11 ) || !Q_stricmpn( cmd, "team vote failed", 16 )) {
;1005:			trap_S_StartLocalSound( cgs.media.voteFailed, CHAN_ANNOUNCER );
;1006:		} else if ( !Q_stricmpn( cmd, "vote passed", 11 ) || !Q_stricmpn( cmd, "team vote passed", 16 ) ) {
;1007:			trap_S_StartLocalSound( cgs.media.votePassed, CHAN_ANNOUNCER );
;1008:		}
;1009:#endif
;1010:		return;
ADDRGP4 $527
JUMPV
LABELV $536
line 1013
;1011:	}
;1012:
;1013:	if ( !strcmp( cmd, "chat" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $541
ARGP4
ADDRLP4 172
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 172
INDIRI4
CNSTI4 0
NEI4 $539
line 1014
;1014:		if ( !cg_teamChatsOnly.integer ) {
ADDRGP4 cg_teamChatsOnly+12
INDIRI4
CNSTI4 0
NEI4 $527
line 1015
;1015:			trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+728
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 1016
;1016:			Q_strncpyz( text, CG_Argv(1), MAX_SAY_TEXT );
CNSTI4 1
ARGI4
ADDRLP4 176
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 4
ARGP4
ADDRLP4 176
INDIRP4
ARGP4
CNSTI4 150
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1017
;1017:			CG_RemoveChatEscapeChar( text );
ADDRLP4 4
ARGP4
ADDRGP4 CG_RemoveChatEscapeChar
CALLV
pop
line 1018
;1018:			CG_Printf( "%s\n", text );
ADDRGP4 $547
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1019
;1019:		}
line 1020
;1020:		return;
ADDRGP4 $527
JUMPV
LABELV $539
line 1023
;1021:	}
;1022:
;1023:	if ( !strcmp( cmd, "tchat" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $550
ARGP4
ADDRLP4 176
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 0
NEI4 $548
line 1024
;1024:		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+728
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 1025
;1025:		Q_strncpyz( text, CG_Argv(1), MAX_SAY_TEXT );
CNSTI4 1
ARGI4
ADDRLP4 180
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 4
ARGP4
ADDRLP4 180
INDIRP4
ARGP4
CNSTI4 150
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1026
;1026:		CG_RemoveChatEscapeChar( text );
ADDRLP4 4
ARGP4
ADDRGP4 CG_RemoveChatEscapeChar
CALLV
pop
line 1027
;1027:		CG_AddToTeamChat( text );
ADDRLP4 4
ARGP4
ADDRGP4 CG_AddToTeamChat
CALLV
pop
line 1028
;1028:		CG_Printf( "%s\n", text );
ADDRGP4 $547
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1029
;1029:		return;
ADDRGP4 $527
JUMPV
LABELV $548
line 1031
;1030:	}
;1031:	if ( !strcmp( cmd, "vchat" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $555
ARGP4
ADDRLP4 180
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 0
NEI4 $553
line 1032
;1032:		CG_VoiceChat( SAY_ALL );
CNSTI4 0
ARGI4
ADDRGP4 CG_VoiceChat
CALLV
pop
line 1033
;1033:		return;
ADDRGP4 $527
JUMPV
LABELV $553
line 1036
;1034:	}
;1035:
;1036:	if ( !strcmp( cmd, "vtchat" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $558
ARGP4
ADDRLP4 184
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 0
NEI4 $556
line 1037
;1037:		CG_VoiceChat( SAY_TEAM );
CNSTI4 1
ARGI4
ADDRGP4 CG_VoiceChat
CALLV
pop
line 1038
;1038:		return;
ADDRGP4 $527
JUMPV
LABELV $556
line 1041
;1039:	}
;1040:
;1041:	if ( !strcmp( cmd, "vtell" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $561
ARGP4
ADDRLP4 188
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 188
INDIRI4
CNSTI4 0
NEI4 $559
line 1042
;1042:		CG_VoiceChat( SAY_TELL );
CNSTI4 2
ARGI4
ADDRGP4 CG_VoiceChat
CALLV
pop
line 1043
;1043:		return;
ADDRGP4 $527
JUMPV
LABELV $559
line 1046
;1044:	}
;1045:
;1046:	if ( !strcmp( cmd, "scores" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $564
ARGP4
ADDRLP4 192
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 192
INDIRI4
CNSTI4 0
NEI4 $562
line 1047
;1047:		CG_ParseScores();
ADDRGP4 CG_ParseScores
CALLV
pop
line 1048
;1048:		return;
ADDRGP4 $527
JUMPV
LABELV $562
line 1051
;1049:	}
;1050:
;1051:	if ( !strcmp( cmd, "tinfo" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $567
ARGP4
ADDRLP4 196
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 196
INDIRI4
CNSTI4 0
NEI4 $565
line 1052
;1052:		CG_ParseTeamInfo();
ADDRGP4 CG_ParseTeamInfo
CALLV
pop
line 1053
;1053:		return;
ADDRGP4 $527
JUMPV
LABELV $565
line 1056
;1054:	}
;1055:
;1056:	if ( !strcmp( cmd, "map_restart" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $570
ARGP4
ADDRLP4 200
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 200
INDIRI4
CNSTI4 0
NEI4 $568
line 1057
;1057:		CG_MapRestart();
ADDRGP4 CG_MapRestart
CALLV
pop
line 1058
;1058:		return;
ADDRGP4 $527
JUMPV
LABELV $568
line 1061
;1059:	}
;1060:
;1061:  if ( Q_stricmp (cmd, "remapShader") == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $573
ARGP4
ADDRLP4 204
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 204
INDIRI4
CNSTI4 0
NEI4 $571
line 1062
;1062:		if (trap_Argc() == 4) {
ADDRLP4 208
ADDRGP4 trap_Argc
CALLI4
ASGNI4
ADDRLP4 208
INDIRI4
CNSTI4 4
NEI4 $574
line 1063
;1063:			trap_R_RemapShader(CG_Argv(1), CG_Argv(2), CG_Argv(3));
CNSTI4 1
ARGI4
ADDRLP4 212
ADDRGP4 CG_Argv
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 216
ADDRGP4 CG_Argv
CALLP4
ASGNP4
CNSTI4 3
ARGI4
ADDRLP4 220
ADDRGP4 CG_Argv
CALLP4
ASGNP4
ADDRLP4 212
INDIRP4
ARGP4
ADDRLP4 216
INDIRP4
ARGP4
ADDRLP4 220
INDIRP4
ARGP4
ADDRGP4 trap_R_RemapShader
CALLV
pop
line 1064
;1064:		}
LABELV $574
line 1065
;1065:	}
LABELV $571
line 1068
;1066:
;1067:	// loaddeferred can be both a servercmd and a consolecmd
;1068:	if ( !strcmp( cmd, "loaddefered" ) ) {	// FIXME: spelled wrong, but not changing for demo
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $578
ARGP4
ADDRLP4 208
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 208
INDIRI4
CNSTI4 0
NEI4 $576
line 1069
;1069:		CG_LoadDeferredPlayers();
ADDRGP4 CG_LoadDeferredPlayers
CALLV
pop
line 1070
;1070:		return;
ADDRGP4 $527
JUMPV
LABELV $576
line 1075
;1071:	}
;1072:
;1073:	// clientLevelShot is sent before taking a special screenshot for
;1074:	// the menu system during development
;1075:	if ( !strcmp( cmd, "clientLevelShot" ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $581
ARGP4
ADDRLP4 212
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 212
INDIRI4
CNSTI4 0
NEI4 $579
line 1076
;1076:		cg.levelShot = qtrue;
ADDRGP4 cg+12
CNSTI4 1
ASGNI4
line 1077
;1077:		return;
ADDRGP4 $527
JUMPV
LABELV $579
line 1080
;1078:	}
;1079:
;1080:	CG_Printf( "Unknown client game command: %s\n", cmd );
ADDRGP4 $583
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 1081
;1081:}
LABELV $527
endproc CG_ServerCommand 224 12
export CG_ExecuteNewServerCommands
proc CG_ExecuteNewServerCommands 12 4
line 1092
;1082:
;1083:
;1084:/*
;1085:====================
;1086:CG_ExecuteNewServerCommands
;1087:
;1088:Execute all of the server commands that were received along
;1089:with this this snapshot.
;1090:====================
;1091:*/
;1092:void CG_ExecuteNewServerCommands( int latestSequence ) {
ADDRGP4 $586
JUMPV
LABELV $585
line 1093
;1093:	while ( cgs.serverCommandSequence < latestSequence ) {
line 1094
;1094:		if ( trap_GetServerCommand( ++cgs.serverCommandSequence ) ) {
ADDRLP4 0
ADDRGP4 cgs+31444
ASGNP4
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 4
INDIRI4
ASGNI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 trap_GetServerCommand
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $589
line 1095
;1095:			CG_ServerCommand();
ADDRGP4 CG_ServerCommand
CALLV
pop
line 1096
;1096:		}
LABELV $589
line 1097
;1097:	}
LABELV $586
line 1093
ADDRGP4 cgs+31444
INDIRI4
ADDRFP4 0
INDIRI4
LTI4 $585
line 1098
;1098:}
LABELV $584
endproc CG_ExecuteNewServerCommands 12 4
bss
export voiceChatBuffer
align 4
LABELV voiceChatBuffer
skip 9984
export headModelVoiceChat
align 4
LABELV headModelVoiceChat
skip 4352
export voiceChatLists
align 4
LABELV voiceChatLists
skip 2263616
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
LABELV $583
byte 1 85
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 32
byte 1 99
byte 1 111
byte 1 109
byte 1 109
byte 1 97
byte 1 110
byte 1 100
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $581
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 76
byte 1 101
byte 1 118
byte 1 101
byte 1 108
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $578
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 114
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $573
byte 1 114
byte 1 101
byte 1 109
byte 1 97
byte 1 112
byte 1 83
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $570
byte 1 109
byte 1 97
byte 1 112
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $567
byte 1 116
byte 1 105
byte 1 110
byte 1 102
byte 1 111
byte 1 0
align 1
LABELV $564
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $561
byte 1 118
byte 1 116
byte 1 101
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $558
byte 1 118
byte 1 116
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $555
byte 1 118
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $550
byte 1 116
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $547
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $541
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $538
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $535
byte 1 99
byte 1 115
byte 1 0
align 1
LABELV $532
byte 1 99
byte 1 112
byte 1 0
align 1
LABELV $481
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 46
byte 1 118
byte 1 99
byte 1 0
align 1
LABELV $463
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $428
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 109
byte 1 101
byte 1 109
byte 1 111
byte 1 114
byte 1 121
byte 1 32
byte 1 115
byte 1 105
byte 1 122
byte 1 101
byte 1 32
byte 1 61
byte 1 32
byte 1 37
byte 1 100
byte 1 10
byte 1 0
align 1
LABELV $426
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 53
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $424
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 52
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $422
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 51
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $420
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 50
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $418
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 49
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $416
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 102
byte 1 101
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 51
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $414
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 102
byte 1 101
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 50
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $413
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 115
byte 1 47
byte 1 102
byte 1 101
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 49
byte 1 46
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $402
byte 1 125
byte 1 0
align 1
LABELV $393
byte 1 94
byte 1 49
byte 1 101
byte 1 120
byte 1 112
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 123
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $392
byte 1 123
byte 1 0
align 1
LABELV $383
byte 1 94
byte 1 49
byte 1 101
byte 1 120
byte 1 112
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 32
byte 1 103
byte 1 101
byte 1 110
byte 1 100
byte 1 101
byte 1 114
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $382
byte 1 110
byte 1 101
byte 1 117
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $379
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $376
byte 1 102
byte 1 101
byte 1 109
byte 1 97
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $366
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $365
byte 1 94
byte 1 49
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 111
byte 1 32
byte 1 108
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 37
byte 1 105
byte 1 44
byte 1 32
byte 1 109
byte 1 97
byte 1 120
byte 1 32
byte 1 97
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 101
byte 1 100
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $362
byte 1 94
byte 1 49
byte 1 118
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $355
byte 1 48
byte 1 0
align 1
LABELV $354
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 104
byte 1 105
byte 1 114
byte 1 100
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $353
byte 1 70
byte 1 73
byte 1 71
byte 1 72
byte 1 84
byte 1 33
byte 1 0
align 1
LABELV $342
byte 1 67
byte 1 71
byte 1 95
byte 1 77
byte 1 97
byte 1 112
byte 1 82
byte 1 101
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $215
byte 1 64
byte 1 0
align 1
LABELV $212
byte 1 58
byte 1 0
align 1
LABELV $209
byte 1 61
byte 1 0
align 1
LABELV $181
byte 1 103
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $177
byte 1 103
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $175
byte 1 109
byte 1 97
byte 1 112
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 46
byte 1 98
byte 1 115
byte 1 112
byte 1 0
align 1
LABELV $172
byte 1 109
byte 1 97
byte 1 112
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $171
byte 1 115
byte 1 118
byte 1 95
byte 1 109
byte 1 97
byte 1 120
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $169
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $167
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $165
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $163
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 115
byte 1 0
align 1
LABELV $161
byte 1 100
byte 1 109
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 115
byte 1 0
align 1
LABELV $158
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $157
byte 1 103
byte 1 95
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $79
byte 1 102
byte 1 111
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 99
byte 1 97
byte 1 114
byte 1 114
byte 1 105
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $78
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $77
byte 1 102
byte 1 111
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $76
byte 1 99
byte 1 97
byte 1 109
byte 1 112
byte 1 0
align 1
LABELV $75
byte 1 112
byte 1 97
byte 1 116
byte 1 114
byte 1 111
byte 1 108
byte 1 0
align 1
LABELV $74
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 100
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $73
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $72
byte 1 111
byte 1 102
byte 1 102
byte 1 101
byte 1 110
byte 1 115
byte 1 101
byte 1 0
align 1
LABELV $71
byte 1 103
byte 1 101
byte 1 116
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
