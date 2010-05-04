code
proc CG_DrawClientScore 1080 28
file "../cg_scoreboard.c"
line 81
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
;23:// cg_scoreboard -- draw the scoreboard on top of the game screen
;24:#include "cg_local.h"
;25:
;26:
;27:#define	SCOREBOARD_X		(0)
;28:
;29:#define SB_HEADER			86
;30:#define SB_TOP				(SB_HEADER+32)
;31:
;32:// Where the status bar starts, so we don't overwrite it
;33:#define SB_STATUSBAR		420
;34:
;35:#define SB_NORMAL_HEIGHT	40
;36:#define SB_INTER_HEIGHT		16 // interleaved height
;37:
;38:#define SB_MAXCLIENTS_NORMAL  ((SB_STATUSBAR - SB_TOP) / SB_NORMAL_HEIGHT)
;39:#define SB_MAXCLIENTS_INTER   ((SB_STATUSBAR - SB_TOP) / SB_INTER_HEIGHT - 1)
;40:
;41:// Used when interleaved
;42:
;43:
;44:
;45:#define SB_LEFT_BOTICON_X	(SCOREBOARD_X+0)
;46:#define SB_LEFT_HEAD_X		(SCOREBOARD_X+32)
;47:#define SB_RIGHT_BOTICON_X	(SCOREBOARD_X+64)
;48:#define SB_RIGHT_HEAD_X		(SCOREBOARD_X+96)
;49:// Normal
;50:#define SB_BOTICON_X		(SCOREBOARD_X+32)
;51:#define SB_HEAD_X			(SCOREBOARD_X+64)
;52:
;53:#define SB_SCORELINE_X		112
;54:
;55:#define SB_RATING_WIDTH	    (6 * BIGCHAR_WIDTH) // width 6
;56:#define SB_SCORE_X			(SB_SCORELINE_X + BIGCHAR_WIDTH) // width 6
;57:#define SB_RATING_X			(SB_SCORELINE_X + 6 * BIGCHAR_WIDTH) // width 6
;58:#define SB_PING_X			(SB_SCORELINE_X + 12 * BIGCHAR_WIDTH + 8) // width 5
;59:#define SB_TIME_X			(SB_SCORELINE_X + 17 * BIGCHAR_WIDTH + 8) // width 5
;60:#define SB_NAME_X			(SB_SCORELINE_X + 22 * BIGCHAR_WIDTH) // width 15
;61:
;62:// The new and improved score board
;63://
;64:// In cases where the number of clients is high, the score board heads are interleaved
;65:// here's the layout
;66:
;67://
;68://	0   32   80  112  144   240  320  400   <-- pixel position
;69://  bot head bot head score ping time name
;70://  
;71://  wins/losses are drawn on bot icon now
;72:
;73:static qboolean localClient; // true if local client has been displayed
;74:
;75:
;76:							 /*
;77:=================
;78:CG_DrawScoreboard
;79:=================
;80:*/
;81:static void CG_DrawClientScore( int y, score_t *score, float *color, float fade, qboolean largeFormat ) {
line 87
;82:	char	string[1024];
;83:	vec3_t	headAngles;
;84:	clientInfo_t	*ci;
;85:	int iconx, headx;
;86:
;87:	if ( score->client < 0 || score->client >= cgs.maxclients ) {
ADDRLP4 1048
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
ADDRLP4 1048
INDIRI4
CNSTI4 0
LTI4 $74
ADDRLP4 1048
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $71
LABELV $74
line 88
;88:		Com_Printf( "Bad score->client: %i\n", score->client );
ADDRGP4 $75
ARGP4
ADDRFP4 4
INDIRP4
INDIRI4
ARGI4
ADDRGP4 Com_Printf
CALLV
pop
line 89
;89:		return;
ADDRGP4 $70
JUMPV
LABELV $71
line 92
;90:	}
;91:	
;92:	ci = &cgs.clientinfo[score->client];
ADDRLP4 12
CNSTI4 1708
ADDRFP4 4
INDIRP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 94
;93:
;94:	iconx = SB_BOTICON_X + (SB_RATING_WIDTH / 2);
ADDRLP4 1040
CNSTI4 80
ASGNI4
line 95
;95:	headx = SB_HEAD_X + (SB_RATING_WIDTH / 2);
ADDRLP4 1044
CNSTI4 112
ASGNI4
line 98
;96:
;97:	// draw the handicap or bot skill marker (unless player has flag)
;98:	if ( ci->powerups & ( 1 << PW_NEUTRALFLAG ) ) {
ADDRLP4 12
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
CNSTI4 512
BANDI4
CNSTI4 0
EQI4 $77
line 99
;99:		if( largeFormat ) {
ADDRFP4 16
INDIRI4
CNSTI4 0
EQI4 $79
line 100
;100:			CG_DrawFlagModel( iconx, y - ( 32 - BIGCHAR_HEIGHT ) / 2, 32, 32, TEAM_FREE, qfalse );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CNSTI4 8
SUBI4
CVIF4 4
ARGF4
ADDRLP4 1052
CNSTF4 1107296256
ASGNF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1056
CNSTI4 0
ASGNI4
ADDRLP4 1056
INDIRI4
ARGI4
ADDRLP4 1056
INDIRI4
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 101
;101:		}
ADDRGP4 $78
JUMPV
LABELV $79
line 102
;102:		else {
line 103
;103:			CG_DrawFlagModel( iconx, y, 16, 16, TEAM_FREE, qfalse );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 1052
CNSTF4 1098907648
ASGNF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1056
CNSTI4 0
ASGNI4
ADDRLP4 1056
INDIRI4
ARGI4
ADDRLP4 1056
INDIRI4
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 104
;104:		}
line 105
;105:	} else if ( ci->powerups & ( 1 << PW_REDFLAG ) ) {
ADDRGP4 $78
JUMPV
LABELV $77
ADDRLP4 12
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $81
line 106
;106:		if( largeFormat ) {
ADDRFP4 16
INDIRI4
CNSTI4 0
EQI4 $83
line 107
;107:			CG_DrawFlagModel( iconx, y - ( 32 - BIGCHAR_HEIGHT ) / 2, 32, 32, TEAM_RED, qfalse );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CNSTI4 8
SUBI4
CVIF4 4
ARGF4
ADDRLP4 1052
CNSTF4 1107296256
ASGNF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1052
INDIRF4
ARGF4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 108
;108:		}
ADDRGP4 $82
JUMPV
LABELV $83
line 109
;109:		else {
line 110
;110:			CG_DrawFlagModel( iconx, y, 16, 16, TEAM_RED, qfalse );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 1052
CNSTF4 1098907648
ASGNF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1052
INDIRF4
ARGF4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 111
;111:		}
line 112
;112:	} else if ( ci->powerups & ( 1 << PW_BLUEFLAG ) ) {
ADDRGP4 $82
JUMPV
LABELV $81
ADDRLP4 12
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $85
line 113
;113:		if( largeFormat ) {
ADDRFP4 16
INDIRI4
CNSTI4 0
EQI4 $87
line 114
;114:			CG_DrawFlagModel( iconx, y - ( 32 - BIGCHAR_HEIGHT ) / 2, 32, 32, TEAM_BLUE, qfalse );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CNSTI4 8
SUBI4
CVIF4 4
ARGF4
ADDRLP4 1052
CNSTF4 1107296256
ASGNF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1052
INDIRF4
ARGF4
CNSTI4 2
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 115
;115:		}
ADDRGP4 $86
JUMPV
LABELV $87
line 116
;116:		else {
line 117
;117:			CG_DrawFlagModel( iconx, y, 16, 16, TEAM_BLUE, qfalse );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 1052
CNSTF4 1098907648
ASGNF4
ADDRLP4 1052
INDIRF4
ARGF4
ADDRLP4 1052
INDIRF4
ARGF4
CNSTI4 2
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 118
;118:		}
line 119
;119:	} else {
ADDRGP4 $86
JUMPV
LABELV $85
line 120
;120:		if ( ci->botSkill > 0 && ci->botSkill <= 5 ) {
ADDRLP4 1052
ADDRLP4 12
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
ASGNI4
ADDRLP4 1052
INDIRI4
CNSTI4 0
LEI4 $89
ADDRLP4 1052
INDIRI4
CNSTI4 5
GTI4 $89
line 121
;121:			if ( cg_drawIcons.integer ) {
ADDRGP4 cg_drawIcons+12
INDIRI4
CNSTI4 0
EQI4 $90
line 122
;122:				if( largeFormat ) {
ADDRFP4 16
INDIRI4
CNSTI4 0
EQI4 $94
line 123
;123:					CG_DrawPic( iconx, y - ( 32 - BIGCHAR_HEIGHT ) / 2, 32, 32, cgs.media.botSkillShaders[ ci->botSkill - 1 ] );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CNSTI4 8
SUBI4
CVIF4 4
ARGF4
ADDRLP4 1056
CNSTF4 1107296256
ASGNF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRLP4 12
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+348-4
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 124
;124:				}
ADDRGP4 $90
JUMPV
LABELV $94
line 125
;125:				else {
line 126
;126:					CG_DrawPic( iconx, y, 16, 16, cgs.media.botSkillShaders[ ci->botSkill - 1 ] );
ADDRLP4 1040
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 1056
CNSTF4 1098907648
ASGNF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRLP4 12
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+348-4
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 127
;127:				}
line 128
;128:			}
line 129
;129:		} else if ( ci->handicap < 100 ) {
ADDRGP4 $90
JUMPV
LABELV $89
ADDRLP4 12
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
CNSTI4 100
GEI4 $102
line 130
;130:			Com_sprintf( string, sizeof( string ), "%i", ci->handicap );
ADDRLP4 16
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $104
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 131
;131:			if ( cgs.gametype == GT_TOURNAMENT )
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 1
NEI4 $105
line 132
;132:				CG_DrawSmallStringColor( iconx, y - SMALLCHAR_HEIGHT/2, string, color );
ADDRLP4 1040
INDIRI4
ARGI4
ADDRFP4 0
INDIRI4
CNSTI4 8
SUBI4
ARGI4
ADDRLP4 16
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CG_DrawSmallStringColor
CALLV
pop
ADDRGP4 $106
JUMPV
LABELV $105
line 134
;133:			else
;134:				CG_DrawSmallStringColor( iconx, y, string, color );
ADDRLP4 1040
INDIRI4
ARGI4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CG_DrawSmallStringColor
CALLV
pop
LABELV $106
line 135
;135:		}
LABELV $102
LABELV $90
line 138
;136:
;137:		// draw the wins / losses
;138:		if ( cgs.gametype == GT_TOURNAMENT ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 1
NEI4 $108
line 139
;139:			Com_sprintf( string, sizeof( string ), "%i/%i", ci->wins, ci->losses );
ADDRLP4 16
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $111
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 128
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 140
;140:			if( ci->handicap < 100 && !ci->botSkill ) {
ADDRLP4 12
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
CNSTI4 100
GEI4 $112
ADDRLP4 12
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
NEI4 $112
line 141
;141:				CG_DrawSmallStringColor( iconx, y + SMALLCHAR_HEIGHT/2, string, color );
ADDRLP4 1040
INDIRI4
ARGI4
ADDRFP4 0
INDIRI4
CNSTI4 8
ADDI4
ARGI4
ADDRLP4 16
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CG_DrawSmallStringColor
CALLV
pop
line 142
;142:			}
ADDRGP4 $113
JUMPV
LABELV $112
line 143
;143:			else {
line 144
;144:				CG_DrawSmallStringColor( iconx, y, string, color );
ADDRLP4 1040
INDIRI4
ARGI4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CG_DrawSmallStringColor
CALLV
pop
line 145
;145:			}
LABELV $113
line 146
;146:		}
LABELV $108
line 147
;147:	}
LABELV $86
LABELV $82
LABELV $78
line 150
;148:
;149:	// draw the face
;150:	VectorClear( headAngles );
ADDRLP4 1052
CNSTF4 0
ASGNF4
ADDRLP4 0+8
ADDRLP4 1052
INDIRF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 1052
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 1052
INDIRF4
ASGNF4
line 151
;151:	headAngles[YAW] = 180;
ADDRLP4 0+4
CNSTF4 1127481344
ASGNF4
line 152
;152:	if( largeFormat ) {
ADDRFP4 16
INDIRI4
CNSTI4 0
EQI4 $117
line 153
;153:		CG_DrawHead( headx, y - ( ICON_SIZE - BIGCHAR_HEIGHT ) / 2, ICON_SIZE, ICON_SIZE, 
ADDRLP4 1044
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CNSTI4 16
SUBI4
CVIF4 4
ARGF4
ADDRLP4 1056
CNSTF4 1111490560
ASGNF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRFP4 4
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 CG_DrawHead
CALLV
pop
line 155
;154:			score->client, headAngles );
;155:	}
ADDRGP4 $118
JUMPV
LABELV $117
line 156
;156:	else {
line 157
;157:		CG_DrawHead( headx, y, 16, 16, score->client, headAngles );
ADDRLP4 1044
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 1056
CNSTF4 1098907648
ASGNF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRLP4 1056
INDIRF4
ARGF4
ADDRFP4 4
INDIRP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 CG_DrawHead
CALLV
pop
line 158
;158:	}
LABELV $118
line 172
;159:
;160:#ifdef MISSIONPACK
;161:	// draw the team task
;162:	if ( ci->teamTask != TEAMTASK_NONE ) {
;163:		if ( ci->teamTask == TEAMTASK_OFFENSE ) {
;164:			CG_DrawPic( headx + 48, y, 16, 16, cgs.media.assaultShader );
;165:		}
;166:		else if ( ci->teamTask == TEAMTASK_DEFENSE ) {
;167:			CG_DrawPic( headx + 48, y, 16, 16, cgs.media.defendShader );
;168:		}
;169:	}
;170:#endif
;171:	// draw the score line
;172:	if ( score->ping == -1 ) {
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 -1
NEI4 $119
line 173
;173:		Com_sprintf(string, sizeof(string),
ADDRLP4 16
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $121
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 175
;174:			" connecting    %s", ci->name);
;175:	} else if ( ci->team == TEAM_SPECTATOR ) {
ADDRGP4 $120
JUMPV
LABELV $119
ADDRLP4 12
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 3
NEI4 $122
line 176
;176:		Com_sprintf(string, sizeof(string),
ADDRLP4 16
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $124
ARGP4
ADDRLP4 1056
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 1056
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 1056
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 178
;177:			" SPECT %3i %4i %s", score->ping, score->time, ci->name);
;178:	} else {
ADDRGP4 $123
JUMPV
LABELV $122
line 179
;179:		Com_sprintf(string, sizeof(string),
ADDRLP4 16
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $125
ARGP4
ADDRLP4 1056
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 1060
CNSTI4 4
ASGNI4
ADDRLP4 1056
INDIRP4
ADDRLP4 1060
INDIRI4
ADDP4
INDIRI4
ARGI4
ADDRLP4 1056
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 1056
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
ADDRLP4 1060
INDIRI4
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 181
;180:			"%5i %4i %4i %s", score->score, score->ping, score->time, ci->name);
;181:	}
LABELV $123
LABELV $120
line 184
;182:
;183:	// highlight your position
;184:	if ( score->client == cg.snap->ps.clientNum ) {
ADDRFP4 4
INDIRP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $126
line 188
;185:		float	hcolor[4];
;186:		int		rank;
;187:
;188:		localClient = qtrue;
ADDRGP4 localClient
CNSTI4 1
ASGNI4
line 190
;189:
;190:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR 
ADDRLP4 1076
CNSTI4 3
ASGNI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
ADDRLP4 1076
INDIRI4
EQI4 $133
ADDRGP4 cgs+31456
INDIRI4
ADDRLP4 1076
INDIRI4
LTI4 $129
LABELV $133
line 191
;191:			|| cgs.gametype >= GT_TEAM ) {
line 192
;192:			rank = -1;
ADDRLP4 1072
CNSTI4 -1
ASGNI4
line 193
;193:		} else {
ADDRGP4 $130
JUMPV
LABELV $129
line 194
;194:			rank = cg.snap->ps.persistant[PERS_RANK] & ~RANK_TIED_FLAG;
ADDRLP4 1072
ADDRGP4 cg+36
INDIRP4
CNSTI4 300
ADDP4
INDIRI4
CNSTI4 -16385
BANDI4
ASGNI4
line 195
;195:		}
LABELV $130
line 196
;196:		if ( rank == 0 ) {
ADDRLP4 1072
INDIRI4
CNSTI4 0
NEI4 $135
line 197
;197:			hcolor[0] = 0;
ADDRLP4 1056
CNSTF4 0
ASGNF4
line 198
;198:			hcolor[1] = 0;
ADDRLP4 1056+4
CNSTF4 0
ASGNF4
line 199
;199:			hcolor[2] = 0.7f;
ADDRLP4 1056+8
CNSTF4 1060320051
ASGNF4
line 200
;200:		} else if ( rank == 1 ) {
ADDRGP4 $136
JUMPV
LABELV $135
ADDRLP4 1072
INDIRI4
CNSTI4 1
NEI4 $139
line 201
;201:			hcolor[0] = 0.7f;
ADDRLP4 1056
CNSTF4 1060320051
ASGNF4
line 202
;202:			hcolor[1] = 0;
ADDRLP4 1056+4
CNSTF4 0
ASGNF4
line 203
;203:			hcolor[2] = 0;
ADDRLP4 1056+8
CNSTF4 0
ASGNF4
line 204
;204:		} else if ( rank == 2 ) {
ADDRGP4 $140
JUMPV
LABELV $139
ADDRLP4 1072
INDIRI4
CNSTI4 2
NEI4 $143
line 205
;205:			hcolor[0] = 0.7f;
ADDRLP4 1056
CNSTF4 1060320051
ASGNF4
line 206
;206:			hcolor[1] = 0.7f;
ADDRLP4 1056+4
CNSTF4 1060320051
ASGNF4
line 207
;207:			hcolor[2] = 0;
ADDRLP4 1056+8
CNSTF4 0
ASGNF4
line 208
;208:		} else {
ADDRGP4 $144
JUMPV
LABELV $143
line 209
;209:			hcolor[0] = 0.7f;
ADDRLP4 1056
CNSTF4 1060320051
ASGNF4
line 210
;210:			hcolor[1] = 0.7f;
ADDRLP4 1056+4
CNSTF4 1060320051
ASGNF4
line 211
;211:			hcolor[2] = 0.7f;
ADDRLP4 1056+8
CNSTF4 1060320051
ASGNF4
line 212
;212:		}
LABELV $144
LABELV $140
LABELV $136
line 214
;213:
;214:		hcolor[3] = fade * 0.7;
ADDRLP4 1056+12
CNSTF4 1060320051
ADDRFP4 12
INDIRF4
MULF4
ASGNF4
line 215
;215:		CG_FillRect( SB_SCORELINE_X + BIGCHAR_WIDTH + (SB_RATING_WIDTH / 2), y, 
CNSTF4 1127219200
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1140850688
ARGF4
CNSTF4 1099431936
ARGF4
ADDRLP4 1056
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 217
;216:			640 - SB_SCORELINE_X - BIGCHAR_WIDTH, BIGCHAR_HEIGHT+1, hcolor );
;217:	}
LABELV $126
line 219
;218:
;219:	CG_DrawBigString( SB_SCORELINE_X + (SB_RATING_WIDTH / 2), y, string, fade );
CNSTI4 160
ARGI4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRFP4 12
INDIRF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 222
;220:
;221:	// add the "ready" marker for intermission exiting
;222:	if ( cg.snap->ps.stats[ STAT_CLIENTS_READY ] & ( 1 << score->client ) ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 248
ADDP4
INDIRI4
CNSTI4 1
ADDRFP4 4
INDIRP4
INDIRI4
LSHI4
BANDI4
CNSTI4 0
EQI4 $150
line 223
;223:		CG_DrawBigStringColor( iconx, y, "READY", color );
ADDRLP4 1040
INDIRI4
ARGI4
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 $153
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 CG_DrawBigStringColor
CALLV
pop
line 224
;224:	}
LABELV $150
line 225
;225:}
LABELV $70
endproc CG_DrawClientScore 1080 28
proc CG_TeamScoreboard 44 20
line 232
;226:
;227:/*
;228:=================
;229:CG_TeamScoreboard
;230:=================
;231:*/
;232:static int CG_TeamScoreboard( int y, team_t team, float fade, int maxClients, int lineHeight ) {
line 239
;233:	int		i;
;234:	score_t	*score;
;235:	float	color[4];
;236:	int		count;
;237:	clientInfo_t	*ci;
;238:
;239:	color[0] = color[1] = color[2] = 1.0;
ADDRLP4 32
CNSTF4 1065353216
ASGNF4
ADDRLP4 16+8
ADDRLP4 32
INDIRF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 32
INDIRF4
ASGNF4
ADDRLP4 16
ADDRLP4 32
INDIRF4
ASGNF4
line 240
;240:	color[3] = fade;
ADDRLP4 16+12
ADDRFP4 8
INDIRF4
ASGNF4
line 242
;241:
;242:	count = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 243
;243:	for ( i = 0 ; i < cg.numScores && count < maxClients ; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $161
JUMPV
LABELV $158
line 244
;244:		score = &cg.scores[i];
ADDRLP4 8
CNSTI4 60
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cg+110480
ADDP4
ASGNP4
line 245
;245:		ci = &cgs.clientinfo[ score->client ];
ADDRLP4 12
CNSTI4 1708
ADDRLP4 8
INDIRP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 247
;246:
;247:		if ( team != ci->team ) {
ADDRFP4 4
INDIRI4
ADDRLP4 12
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
EQI4 $165
line 248
;248:			continue;
ADDRGP4 $159
JUMPV
LABELV $165
line 251
;249:		}
;250:
;251:		CG_DrawClientScore( y + lineHeight * count, score, color, fade, lineHeight == SB_NORMAL_HEIGHT );
ADDRLP4 40
ADDRFP4 16
INDIRI4
ASGNI4
ADDRFP4 0
INDIRI4
ADDRLP4 40
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ADDI4
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 16
ARGP4
ADDRFP4 8
INDIRF4
ARGF4
ADDRLP4 40
INDIRI4
CNSTI4 40
NEI4 $168
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $169
JUMPV
LABELV $168
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $169
ADDRLP4 36
INDIRI4
ARGI4
ADDRGP4 CG_DrawClientScore
CALLV
pop
line 253
;252:
;253:		count++;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 254
;254:	}
LABELV $159
line 243
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $161
ADDRLP4 4
INDIRI4
ADDRGP4 cg+110464
INDIRI4
GEI4 $170
ADDRLP4 0
INDIRI4
ADDRFP4 12
INDIRI4
LTI4 $158
LABELV $170
line 256
;255:
;256:	return count;
ADDRLP4 0
INDIRI4
RETI4
LABELV $154
endproc CG_TeamScoreboard 44 20
export CG_DrawOldScoreboard
proc CG_DrawOldScoreboard 68 24
line 266
;257:}
;258:
;259:/*
;260:=================
;261:CG_DrawScoreboard
;262:
;263:Draw the normal in-game scoreboard
;264:=================
;265:*/
;266:qboolean CG_DrawOldScoreboard( void ) {
line 276
;267:	int		x, y, w, i, n1, n2;
;268:	float	fade;
;269:	float	*fadeColor;
;270:	char	*s;
;271:	int maxClients;
;272:	int lineHeight;
;273:	int topBorderSize, bottomBorderSize;
;274:
;275:	// don't draw amuthing if the menu or console is up
;276:	if ( cg_paused.integer ) {
ADDRGP4 cg_paused+12
INDIRI4
CNSTI4 0
EQI4 $172
line 277
;277:		cg.deferredPlayerLoading = 0;
ADDRGP4 cg+16
CNSTI4 0
ASGNI4
line 278
;278:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $171
JUMPV
LABELV $172
line 281
;279:	}
;280:
;281:	if ( cgs.gametype == GT_SINGLE_PLAYER && cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 2
NEI4 $176
ADDRGP4 cg+107636+4
INDIRI4
CNSTI4 5
NEI4 $176
line 282
;282:		cg.deferredPlayerLoading = 0;
ADDRGP4 cg+16
CNSTI4 0
ASGNI4
line 283
;283:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $171
JUMPV
LABELV $176
line 287
;284:	}
;285:
;286:	// don't draw scoreboard during death while warmup up
;287:	if ( cg.warmup && !cg.showScores ) {
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRGP4 cg+124656
INDIRI4
ADDRLP4 52
INDIRI4
EQI4 $182
ADDRGP4 cg+114320
INDIRI4
ADDRLP4 52
INDIRI4
NEI4 $182
line 288
;288:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $171
JUMPV
LABELV $182
line 291
;289:	}
;290:
;291:	if ( cg.showScores || cg.predictedPlayerState.pm_type == PM_DEAD ||
ADDRGP4 cg+114320
INDIRI4
CNSTI4 0
NEI4 $194
ADDRGP4 cg+107636+4
INDIRI4
CNSTI4 3
EQI4 $194
ADDRGP4 cg+107636+4
INDIRI4
CNSTI4 5
NEI4 $186
LABELV $194
line 292
;292:		 cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
line 293
;293:		fade = 1.0;
ADDRLP4 12
CNSTF4 1065353216
ASGNF4
line 294
;294:		fadeColor = colorWhite;
ADDRLP4 20
ADDRGP4 colorWhite
ASGNP4
line 295
;295:	} else {
ADDRGP4 $187
JUMPV
LABELV $186
line 296
;296:		fadeColor = CG_FadeColor( cg.scoreFadeTime, FADE_TIME );
ADDRGP4 cg+114328
INDIRI4
ARGI4
CNSTI4 200
ARGI4
ADDRLP4 56
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 56
INDIRP4
ASGNP4
line 298
;297:		
;298:		if ( !fadeColor ) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $196
line 300
;299:			// next time scoreboard comes up, don't print killer
;300:			cg.deferredPlayerLoading = 0;
ADDRGP4 cg+16
CNSTI4 0
ASGNI4
line 301
;301:			cg.killerName[0] = 0;
ADDRGP4 cg+114332
CNSTI1 0
ASGNI1
line 302
;302:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $171
JUMPV
LABELV $196
line 304
;303:		}
;304:		fade = *fadeColor;
ADDRLP4 12
ADDRLP4 20
INDIRP4
INDIRF4
ASGNF4
line 305
;305:	}
LABELV $187
line 309
;306:
;307:
;308:	// fragged by ... line
;309:	if ( cg.killerName[0] ) {
ADDRGP4 cg+114332
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $200
line 310
;310:		s = va("Fragged by %s", cg.killerName );
ADDRGP4 $203
ARGP4
ADDRGP4 cg+114332
ARGP4
ADDRLP4 56
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 56
INDIRP4
ASGNP4
line 311
;311:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 60
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 60
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 312
;312:		x = ( SCREEN_WIDTH - w ) / 2;
ADDRLP4 36
CNSTI4 640
ADDRLP4 40
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 313
;313:		y = 40;
ADDRLP4 4
CNSTI4 40
ASGNI4
line 314
;314:		CG_DrawBigString( x, y, s, fade );
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 12
INDIRF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 315
;315:	}
LABELV $200
line 318
;316:
;317:	// current rank
;318:	if ( cgs.gametype < GT_TEAM) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
GEI4 $205
line 319
;319:		if (cg.snap->ps.persistant[PERS_TEAM] != TEAM_SPECTATOR ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
EQI4 $206
line 320
;320:			s = va("%s place with %i",
ADDRGP4 cg+36
INDIRP4
CNSTI4 300
ADDP4
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRLP4 56
ADDRGP4 CG_PlaceString
CALLP4
ASGNP4
ADDRGP4 $211
ARGP4
ADDRLP4 56
INDIRP4
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 292
ADDP4
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 60
INDIRP4
ASGNP4
line 323
;321:				CG_PlaceString( cg.snap->ps.persistant[PERS_RANK] + 1 ),
;322:				cg.snap->ps.persistant[PERS_SCORE] );
;323:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 64
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 324
;324:			x = ( SCREEN_WIDTH - w ) / 2;
ADDRLP4 36
CNSTI4 640
ADDRLP4 40
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 325
;325:			y = 60;
ADDRLP4 4
CNSTI4 60
ASGNI4
line 326
;326:			CG_DrawBigString( x, y, s, fade );
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 12
INDIRF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 327
;327:		}
line 328
;328:	} else {
ADDRGP4 $206
JUMPV
LABELV $205
line 329
;329:		if ( cg.teamScores[0] == cg.teamScores[1] ) {
ADDRGP4 cg+110472
INDIRI4
ADDRGP4 cg+110472+4
INDIRI4
NEI4 $214
line 330
;330:			s = va("Teams are tied at %i", cg.teamScores[0] );
ADDRGP4 $219
ARGP4
ADDRGP4 cg+110472
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 56
INDIRP4
ASGNP4
line 331
;331:		} else if ( cg.teamScores[0] >= cg.teamScores[1] ) {
ADDRGP4 $215
JUMPV
LABELV $214
ADDRGP4 cg+110472
INDIRI4
ADDRGP4 cg+110472+4
INDIRI4
LTI4 $221
line 332
;332:			s = va("Red leads %i to %i",cg.teamScores[0], cg.teamScores[1] );
ADDRGP4 $226
ARGP4
ADDRGP4 cg+110472
INDIRI4
ARGI4
ADDRGP4 cg+110472+4
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 56
INDIRP4
ASGNP4
line 333
;333:		} else {
ADDRGP4 $222
JUMPV
LABELV $221
line 334
;334:			s = va("Blue leads %i to %i",cg.teamScores[1], cg.teamScores[0] );
ADDRGP4 $230
ARGP4
ADDRGP4 cg+110472+4
INDIRI4
ARGI4
ADDRGP4 cg+110472
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 56
INDIRP4
ASGNP4
line 335
;335:		}
LABELV $222
LABELV $215
line 337
;336:
;337:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 56
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 56
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 338
;338:		x = ( SCREEN_WIDTH - w ) / 2;
ADDRLP4 36
CNSTI4 640
ADDRLP4 40
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 339
;339:		y = 60;
ADDRLP4 4
CNSTI4 60
ASGNI4
line 340
;340:		CG_DrawBigString( x, y, s, fade );
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 12
INDIRF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 341
;341:	}
LABELV $206
line 344
;342:
;343:	// scoreboard
;344:	y = SB_HEADER;
ADDRLP4 4
CNSTI4 86
ASGNI4
line 346
;345:
;346:	CG_DrawPic( SB_SCORE_X + (SB_RATING_WIDTH / 2), y, 64, 32, cgs.media.scoreboardScore );
CNSTF4 1127219200
ARGF4
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1115684864
ARGF4
CNSTF4 1107296256
ARGF4
ADDRGP4 cgs+152340+496
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 347
;347:	CG_DrawPic( SB_PING_X - (SB_RATING_WIDTH / 2), y, 64, 32, cgs.media.scoreboardPing );
CNSTF4 1132724224
ARGF4
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1115684864
ARGF4
CNSTF4 1107296256
ARGF4
ADDRGP4 cgs+152340+492
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 348
;348:	CG_DrawPic( SB_TIME_X - (SB_RATING_WIDTH / 2), y, 64, 32, cgs.media.scoreboardTime );
CNSTF4 1135345664
ARGF4
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1115684864
ARGF4
CNSTF4 1107296256
ARGF4
ADDRGP4 cgs+152340+500
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 349
;349:	CG_DrawPic( SB_NAME_X - (SB_RATING_WIDTH / 2), y, 64, 32, cgs.media.scoreboardName );
CNSTF4 1137704960
ARGF4
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1115684864
ARGF4
CNSTF4 1107296256
ARGF4
ADDRGP4 cgs+152340+488
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 351
;350:
;351:	y = SB_TOP;
ADDRLP4 4
CNSTI4 118
ASGNI4
line 354
;352:
;353:	// If there are more than SB_MAXCLIENTS_NORMAL, use the interleaved scores
;354:	if ( cg.numScores > SB_MAXCLIENTS_NORMAL ) {
ADDRGP4 cg+110464
INDIRI4
CNSTI4 7
LEI4 $242
line 355
;355:		maxClients = SB_MAXCLIENTS_INTER;
ADDRLP4 24
CNSTI4 17
ASGNI4
line 356
;356:		lineHeight = SB_INTER_HEIGHT;
ADDRLP4 8
CNSTI4 16
ASGNI4
line 357
;357:		topBorderSize = 8;
ADDRLP4 44
CNSTI4 8
ASGNI4
line 358
;358:		bottomBorderSize = 16;
ADDRLP4 48
CNSTI4 16
ASGNI4
line 359
;359:	} else {
ADDRGP4 $243
JUMPV
LABELV $242
line 360
;360:		maxClients = SB_MAXCLIENTS_NORMAL;
ADDRLP4 24
CNSTI4 7
ASGNI4
line 361
;361:		lineHeight = SB_NORMAL_HEIGHT;
ADDRLP4 8
CNSTI4 40
ASGNI4
line 362
;362:		topBorderSize = 16;
ADDRLP4 44
CNSTI4 16
ASGNI4
line 363
;363:		bottomBorderSize = 16;
ADDRLP4 48
CNSTI4 16
ASGNI4
line 364
;364:	}
LABELV $243
line 366
;365:
;366:	localClient = qfalse;
ADDRGP4 localClient
CNSTI4 0
ASGNI4
line 368
;367:
;368:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $245
line 372
;369:		//
;370:		// teamplay scoreboard
;371:		//
;372:		y += lineHeight/2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRI4
CNSTI4 2
DIVI4
ADDI4
ASGNI4
line 374
;373:
;374:		if ( cg.teamScores[0] >= cg.teamScores[1] ) {
ADDRGP4 cg+110472
INDIRI4
ADDRGP4 cg+110472+4
INDIRI4
LTI4 $248
line 375
;375:			n1 = CG_TeamScoreboard( y, TEAM_RED, fade, maxClients, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 56
INDIRI4
ASGNI4
line 376
;376:			CG_DrawTeamBackground( 0, y - topBorderSize, 640, n1 * lineHeight + bottomBorderSize, 0.33f, TEAM_RED );
CNSTI4 0
ARGI4
ADDRLP4 4
INDIRI4
ADDRLP4 44
INDIRI4
SUBI4
ARGI4
CNSTI4 640
ARGI4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 48
INDIRI4
ADDI4
ARGI4
CNSTF4 1051260355
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 CG_DrawTeamBackground
CALLV
pop
line 377
;377:			y += (n1 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 378
;378:			maxClients -= n1;
ADDRLP4 24
ADDRLP4 24
INDIRI4
ADDRLP4 16
INDIRI4
SUBI4
ASGNI4
line 379
;379:			n2 = CG_TeamScoreboard( y, TEAM_BLUE, fade, maxClients, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 60
INDIRI4
ASGNI4
line 380
;380:			CG_DrawTeamBackground( 0, y - topBorderSize, 640, n2 * lineHeight + bottomBorderSize, 0.33f, TEAM_BLUE );
CNSTI4 0
ARGI4
ADDRLP4 4
INDIRI4
ADDRLP4 44
INDIRI4
SUBI4
ARGI4
CNSTI4 640
ARGI4
ADDRLP4 32
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 48
INDIRI4
ADDI4
ARGI4
CNSTF4 1051260355
ARGF4
CNSTI4 2
ARGI4
ADDRGP4 CG_DrawTeamBackground
CALLV
pop
line 381
;381:			y += (n2 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 32
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 382
;382:			maxClients -= n2;
ADDRLP4 24
ADDRLP4 24
INDIRI4
ADDRLP4 32
INDIRI4
SUBI4
ASGNI4
line 383
;383:		} else {
ADDRGP4 $249
JUMPV
LABELV $248
line 384
;384:			n1 = CG_TeamScoreboard( y, TEAM_BLUE, fade, maxClients, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 56
INDIRI4
ASGNI4
line 385
;385:			CG_DrawTeamBackground( 0, y - topBorderSize, 640, n1 * lineHeight + bottomBorderSize, 0.33f, TEAM_BLUE );
CNSTI4 0
ARGI4
ADDRLP4 4
INDIRI4
ADDRLP4 44
INDIRI4
SUBI4
ARGI4
CNSTI4 640
ARGI4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 48
INDIRI4
ADDI4
ARGI4
CNSTF4 1051260355
ARGF4
CNSTI4 2
ARGI4
ADDRGP4 CG_DrawTeamBackground
CALLV
pop
line 386
;386:			y += (n1 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 387
;387:			maxClients -= n1;
ADDRLP4 24
ADDRLP4 24
INDIRI4
ADDRLP4 16
INDIRI4
SUBI4
ASGNI4
line 388
;388:			n2 = CG_TeamScoreboard( y, TEAM_RED, fade, maxClients, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 60
INDIRI4
ASGNI4
line 389
;389:			CG_DrawTeamBackground( 0, y - topBorderSize, 640, n2 * lineHeight + bottomBorderSize, 0.33f, TEAM_RED );
CNSTI4 0
ARGI4
ADDRLP4 4
INDIRI4
ADDRLP4 44
INDIRI4
SUBI4
ARGI4
CNSTI4 640
ARGI4
ADDRLP4 32
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 48
INDIRI4
ADDI4
ARGI4
CNSTF4 1051260355
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 CG_DrawTeamBackground
CALLV
pop
line 390
;390:			y += (n2 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 32
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 391
;391:			maxClients -= n2;
ADDRLP4 24
ADDRLP4 24
INDIRI4
ADDRLP4 32
INDIRI4
SUBI4
ASGNI4
line 392
;392:		}
LABELV $249
line 393
;393:		n1 = CG_TeamScoreboard( y, TEAM_SPECTATOR, fade, maxClients, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 56
INDIRI4
ASGNI4
line 394
;394:		y += (n1 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 396
;395:
;396:	} else {
ADDRGP4 $246
JUMPV
LABELV $245
line 400
;397:		//
;398:		// free for all scoreboard
;399:		//
;400:		n1 = CG_TeamScoreboard( y, TEAM_FREE, fade, maxClients, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 56
INDIRI4
ASGNI4
line 401
;401:		y += (n1 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 402
;402:		n2 = CG_TeamScoreboard( y, TEAM_SPECTATOR, fade, maxClients - n1, lineHeight );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ADDRLP4 16
INDIRI4
SUBI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 CG_TeamScoreboard
CALLI4
ASGNI4
ADDRLP4 32
ADDRLP4 60
INDIRI4
ASGNI4
line 403
;403:		y += (n2 * lineHeight) + BIGCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 32
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
CNSTI4 16
ADDI4
ADDI4
ASGNI4
line 404
;404:	}
LABELV $246
line 406
;405:
;406:	if (!localClient) {
ADDRGP4 localClient
INDIRI4
CNSTI4 0
NEI4 $253
line 408
;407:		// draw local client at the bottom
;408:		for ( i = 0 ; i < cg.numScores ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $258
JUMPV
LABELV $255
line 409
;409:			if ( cg.scores[i].client == cg.snap->ps.clientNum ) {
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480
ADDP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $260
line 410
;410:				CG_DrawClientScore( y, &cg.scores[i], fadeColor, fade, lineHeight == SB_NORMAL_HEIGHT );
ADDRLP4 4
INDIRI4
ARGI4
CNSTI4 60
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+110480
ADDP4
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 8
INDIRI4
CNSTI4 40
NEI4 $266
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $267
JUMPV
LABELV $266
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $267
ADDRLP4 56
INDIRI4
ARGI4
ADDRGP4 CG_DrawClientScore
CALLV
pop
line 411
;411:				break;
ADDRGP4 $257
JUMPV
LABELV $260
line 413
;412:			}
;413:		}
LABELV $256
line 408
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $258
ADDRLP4 0
INDIRI4
ADDRGP4 cg+110464
INDIRI4
LTI4 $255
LABELV $257
line 414
;414:	}
LABELV $253
line 417
;415:
;416:	// load any models that have been deferred
;417:	if ( ++cg.deferredPlayerLoading > 10 ) {
ADDRLP4 56
ADDRGP4 cg+16
ASGNP4
ADDRLP4 60
ADDRLP4 56
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 56
INDIRP4
ADDRLP4 60
INDIRI4
ASGNI4
ADDRLP4 60
INDIRI4
CNSTI4 10
LEI4 $268
line 418
;418:		CG_LoadDeferredPlayers();
ADDRGP4 CG_LoadDeferredPlayers
CALLV
pop
line 419
;419:	}
LABELV $268
line 421
;420:
;421:	return qtrue;
CNSTI4 1
RETI4
LABELV $171
endproc CG_DrawOldScoreboard 68 24
proc CG_CenterGiantLine 28 36
line 431
;422:}
;423:
;424://================================================================================
;425:
;426:/*
;427:================
;428:CG_CenterGiantLine
;429:================
;430:*/
;431:static void CG_CenterGiantLine( float y, const char *string ) {
line 435
;432:	float		x;
;433:	vec4_t		color;
;434:
;435:	color[0] = 1;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 436
;436:	color[1] = 1;
ADDRLP4 0+4
CNSTF4 1065353216
ASGNF4
line 437
;437:	color[2] = 1;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 438
;438:	color[3] = 1;
ADDRLP4 0+12
CNSTF4 1065353216
ASGNF4
line 440
;439:
;440:	x = 0.5 * ( 640 - GIANT_WIDTH * CG_DrawStrlen( string ) );
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
CNSTF4 1056964608
CNSTI4 640
ADDRLP4 20
INDIRI4
CNSTI4 5
LSHI4
SUBI4
CVIF4 4
MULF4
ASGNF4
line 442
;441:
;442:	CG_DrawStringExt( x, y, string, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
ADDRLP4 16
INDIRF4
CVFI4 4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 443
;443:}
LABELV $271
endproc CG_CenterGiantLine 28 36
export CG_DrawOldTourneyScoreboard
proc CG_DrawOldTourneyScoreboard 92 36
line 452
;444:
;445:/*
;446:=================
;447:CG_DrawTourneyScoreboard
;448:
;449:Draw the oversize scoreboard for tournements
;450:=================
;451:*/
;452:void CG_DrawOldTourneyScoreboard( void ) {
line 461
;453:	const char		*s;
;454:	vec4_t			color;
;455:	int				min, tens, ones;
;456:	clientInfo_t	*ci;
;457:	int				y;
;458:	int				i;
;459:
;460:	// request more scores regularly
;461:	if ( cg.scoresRequestTime + 2000 < cg.time ) {
ADDRGP4 cg+110460
INDIRI4
CNSTI4 2000
ADDI4
ADDRGP4 cg+107604
INDIRI4
GEI4 $276
line 462
;462:		cg.scoresRequestTime = cg.time;
ADDRGP4 cg+110460
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 463
;463:		trap_SendClientCommand( "score" );
ADDRGP4 $282
ARGP4
ADDRGP4 trap_SendClientCommand
CALLV
pop
line 464
;464:	}
LABELV $276
line 466
;465:
;466:	color[0] = 1;
ADDRLP4 8
CNSTF4 1065353216
ASGNF4
line 467
;467:	color[1] = 1;
ADDRLP4 8+4
CNSTF4 1065353216
ASGNF4
line 468
;468:	color[2] = 1;
ADDRLP4 8+8
CNSTF4 1065353216
ASGNF4
line 469
;469:	color[3] = 1;
ADDRLP4 8+12
CNSTF4 1065353216
ASGNF4
line 472
;470:
;471:	// draw the dialog background
;472:	color[0] = color[1] = color[2] = 0;
ADDRLP4 44
CNSTF4 0
ASGNF4
ADDRLP4 8+8
ADDRLP4 44
INDIRF4
ASGNF4
ADDRLP4 8+4
ADDRLP4 44
INDIRF4
ASGNF4
ADDRLP4 8
ADDRLP4 44
INDIRF4
ASGNF4
line 473
;473:	color[3] = 1;
ADDRLP4 8+12
CNSTF4 1065353216
ASGNF4
line 474
;474:	CG_FillRect( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, color );
ADDRLP4 48
CNSTF4 0
ASGNF4
ADDRLP4 48
INDIRF4
ARGF4
ADDRLP4 48
INDIRF4
ARGF4
CNSTF4 1142947840
ARGF4
CNSTF4 1139802112
ARGF4
ADDRLP4 8
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 477
;475:
;476:	// print the mesage of the day
;477:	s = CG_ConfigString( CS_MOTD );
CNSTI4 4
ARGI4
ADDRLP4 52
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 52
INDIRP4
ASGNP4
line 478
;478:	if ( !s[0] ) {
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $289
line 479
;479:		s = "Scoreboard";
ADDRLP4 4
ADDRGP4 $291
ASGNP4
line 480
;480:	}
LABELV $289
line 483
;481:
;482:	// print optional title
;483:	CG_CenterGiantLine( 8, s );
CNSTF4 1090519040
ARGF4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_CenterGiantLine
CALLV
pop
line 486
;484:
;485:	// print server time
;486:	ones = cg.time / 1000;
ADDRLP4 32
ADDRGP4 cg+107604
INDIRI4
CNSTI4 1000
DIVI4
ASGNI4
line 487
;487:	min = ones / 60;
ADDRLP4 36
ADDRLP4 32
INDIRI4
CNSTI4 60
DIVI4
ASGNI4
line 488
;488:	ones %= 60;
ADDRLP4 32
ADDRLP4 32
INDIRI4
CNSTI4 60
MODI4
ASGNI4
line 489
;489:	tens = ones / 10;
ADDRLP4 40
ADDRLP4 32
INDIRI4
CNSTI4 10
DIVI4
ASGNI4
line 490
;490:	ones %= 10;
ADDRLP4 32
ADDRLP4 32
INDIRI4
CNSTI4 10
MODI4
ASGNI4
line 491
;491:	s = va("%i:%i%i", min, tens, ones );
ADDRGP4 $293
ARGP4
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 40
INDIRI4
ARGI4
ADDRLP4 32
INDIRI4
ARGI4
ADDRLP4 56
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 56
INDIRP4
ASGNP4
line 493
;492:
;493:	CG_CenterGiantLine( 64, s );
CNSTF4 1115684864
ARGF4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_CenterGiantLine
CALLV
pop
line 498
;494:
;495:
;496:	// print the two scores
;497:
;498:	y = 160;
ADDRLP4 24
CNSTI4 160
ASGNI4
line 499
;499:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $294
line 503
;500:		//
;501:		// teamplay scoreboard
;502:		//
;503:		CG_DrawStringExt( 8, y, "Red Team", color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
CNSTI4 8
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 $297
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 60
CNSTI4 1
ASGNI4
ADDRLP4 60
INDIRI4
ARGI4
ADDRLP4 60
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 504
;504:		s = va("%i", cg.teamScores[0] );
ADDRGP4 $104
ARGP4
ADDRGP4 cg+110472
INDIRI4
ARGI4
ADDRLP4 64
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 64
INDIRP4
ASGNP4
line 505
;505:		CG_DrawStringExt( 632 - GIANT_WIDTH * strlen(s), y, s, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 68
ADDRGP4 strlen
CALLI4
ASGNI4
CNSTI4 632
ADDRLP4 68
INDIRI4
CNSTI4 5
LSHI4
SUBI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRLP4 72
INDIRI4
ARGI4
ADDRLP4 72
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 507
;506:		
;507:		y += 64;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 64
ADDI4
ASGNI4
line 509
;508:
;509:		CG_DrawStringExt( 8, y, "Blue Team", color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
CNSTI4 8
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 $299
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 76
CNSTI4 1
ASGNI4
ADDRLP4 76
INDIRI4
ARGI4
ADDRLP4 76
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 510
;510:		s = va("%i", cg.teamScores[1] );
ADDRGP4 $104
ARGP4
ADDRGP4 cg+110472+4
INDIRI4
ARGI4
ADDRLP4 80
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 80
INDIRP4
ASGNP4
line 511
;511:		CG_DrawStringExt( 632 - GIANT_WIDTH * strlen(s), y, s, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 84
ADDRGP4 strlen
CALLI4
ASGNI4
CNSTI4 632
ADDRLP4 84
INDIRI4
CNSTI4 5
LSHI4
SUBI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRLP4 88
INDIRI4
ARGI4
ADDRLP4 88
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 512
;512:	} else {
ADDRGP4 $295
JUMPV
LABELV $294
line 516
;513:		//
;514:		// free for all scoreboard
;515:		//
;516:		for ( i = 0 ; i < MAX_CLIENTS ; i++ ) {
ADDRLP4 28
CNSTI4 0
ASGNI4
LABELV $302
line 517
;517:			ci = &cgs.clientinfo[i];
ADDRLP4 0
CNSTI4 1708
ADDRLP4 28
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 518
;518:			if ( !ci->infoValid ) {
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $307
line 519
;519:				continue;
ADDRGP4 $303
JUMPV
LABELV $307
line 521
;520:			}
;521:			if ( ci->team != TEAM_FREE ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $309
line 522
;522:				continue;
ADDRGP4 $303
JUMPV
LABELV $309
line 525
;523:			}
;524:
;525:			CG_DrawStringExt( 8, y, ci->name, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
CNSTI4 8
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 60
CNSTI4 1
ASGNI4
ADDRLP4 60
INDIRI4
ARGI4
ADDRLP4 60
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 526
;526:			s = va("%i", ci->score );
ADDRGP4 $104
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRI4
ARGI4
ADDRLP4 64
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 64
INDIRP4
ASGNP4
line 527
;527:			CG_DrawStringExt( 632 - GIANT_WIDTH * strlen(s), y, s, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 68
ADDRGP4 strlen
CALLI4
ASGNI4
CNSTI4 632
ADDRLP4 68
INDIRI4
CNSTI4 5
LSHI4
SUBI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRLP4 72
INDIRI4
ARGI4
ADDRLP4 72
INDIRI4
ARGI4
CNSTI4 32
ARGI4
CNSTI4 48
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 528
;528:			y += 64;
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 64
ADDI4
ASGNI4
line 529
;529:		}
LABELV $303
line 516
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 64
LTI4 $302
line 530
;530:	}
LABELV $295
line 533
;531:
;532:
;533:}
LABELV $275
endproc CG_DrawOldTourneyScoreboard 92 36
bss
align 4
LABELV localClient
skip 4
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
LABELV $299
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $297
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $293
byte 1 37
byte 1 105
byte 1 58
byte 1 37
byte 1 105
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $291
byte 1 83
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 98
byte 1 111
byte 1 97
byte 1 114
byte 1 100
byte 1 0
align 1
LABELV $282
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $230
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 115
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $226
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 115
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $219
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 115
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 32
byte 1 116
byte 1 105
byte 1 101
byte 1 100
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $211
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
LABELV $203
byte 1 70
byte 1 114
byte 1 97
byte 1 103
byte 1 103
byte 1 101
byte 1 100
byte 1 32
byte 1 98
byte 1 121
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $153
byte 1 82
byte 1 69
byte 1 65
byte 1 68
byte 1 89
byte 1 0
align 1
LABELV $125
byte 1 37
byte 1 53
byte 1 105
byte 1 32
byte 1 37
byte 1 52
byte 1 105
byte 1 32
byte 1 37
byte 1 52
byte 1 105
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $124
byte 1 32
byte 1 83
byte 1 80
byte 1 69
byte 1 67
byte 1 84
byte 1 32
byte 1 37
byte 1 51
byte 1 105
byte 1 32
byte 1 37
byte 1 52
byte 1 105
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $121
byte 1 32
byte 1 99
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 32
byte 1 32
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $111
byte 1 37
byte 1 105
byte 1 47
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $104
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $75
byte 1 66
byte 1 97
byte 1 100
byte 1 32
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 45
byte 1 62
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
