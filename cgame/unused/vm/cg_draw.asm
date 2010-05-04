data
export drawTeamOverlayModificationCount
align 4
LABELV drawTeamOverlayModificationCount
byte 4 -1
code
proc CG_DrawField 64 20
file "../cg_draw.c"
line 212
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
;23:// cg_draw.c -- draw all of the graphical elements during
;24:// active (after loading) gameplay
;25:
;26:#include "cg_local.h"
;27:
;28:#ifdef MISSIONPACK
;29:#include "../ui/ui_shared.h"
;30:
;31:// used for scoreboard
;32:extern displayContextDef_t cgDC;
;33:menuDef_t *menuScoreboard = NULL;
;34:#else
;35:int drawTeamOverlayModificationCount = -1;
;36:#endif
;37:
;38:int sortedTeamPlayers[TEAM_MAXOVERLAY];
;39:int	numSortedTeamPlayers;
;40:
;41:char systemChat[256];
;42:char teamChat1[256];
;43:char teamChat2[256];
;44:
;45:#ifdef MISSIONPACK
;46:
;47:int CG_Text_Width(const char *text, float scale, int limit) {
;48:  int count,len;
;49:	float out;
;50:	glyphInfo_t *glyph;
;51:	float useScale;
;52:// FIXME: see ui_main.c, same problem
;53://	const unsigned char *s = text;
;54:	const char *s = text;
;55:	fontInfo_t *font = &cgDC.Assets.textFont;
;56:	if (scale <= cg_smallFont.value) {
;57:		font = &cgDC.Assets.smallFont;
;58:	} else if (scale > cg_bigFont.value) {
;59:		font = &cgDC.Assets.bigFont;
;60:	}
;61:	useScale = scale * font->glyphScale;
;62:  out = 0;
;63:  if (text) {
;64:    len = strlen(text);
;65:		if (limit > 0 && len > limit) {
;66:			len = limit;
;67:		}
;68:		count = 0;
;69:		while (s && *s && count < len) {
;70:			if ( Q_IsColorString(s) ) {
;71:				s += 2;
;72:				continue;
;73:			} else {
;74:				glyph = &font->glyphs[(int)*s]; // TTimo: FIXME: getting nasty warnings without the cast, hopefully this doesn't break the VM build
;75:				out += glyph->xSkip;
;76:				s++;
;77:				count++;
;78:			}
;79:    }
;80:  }
;81:  return out * useScale;
;82:}
;83:
;84:int CG_Text_Height(const char *text, float scale, int limit) {
;85:  int len, count;
;86:	float max;
;87:	glyphInfo_t *glyph;
;88:	float useScale;
;89:// TTimo: FIXME
;90://	const unsigned char *s = text;
;91:	const char *s = text;
;92:	fontInfo_t *font = &cgDC.Assets.textFont;
;93:	if (scale <= cg_smallFont.value) {
;94:		font = &cgDC.Assets.smallFont;
;95:	} else if (scale > cg_bigFont.value) {
;96:		font = &cgDC.Assets.bigFont;
;97:	}
;98:	useScale = scale * font->glyphScale;
;99:  max = 0;
;100:  if (text) {
;101:    len = strlen(text);
;102:		if (limit > 0 && len > limit) {
;103:			len = limit;
;104:		}
;105:		count = 0;
;106:		while (s && *s && count < len) {
;107:			if ( Q_IsColorString(s) ) {
;108:				s += 2;
;109:				continue;
;110:			} else {
;111:				glyph = &font->glyphs[(int)*s]; // TTimo: FIXME: getting nasty warnings without the cast, hopefully this doesn't break the VM build
;112:	      if (max < glyph->height) {
;113:		      max = glyph->height;
;114:			  }
;115:				s++;
;116:				count++;
;117:			}
;118:    }
;119:  }
;120:  return max * useScale;
;121:}
;122:
;123:void CG_Text_PaintChar(float x, float y, float width, float height, float scale, float s, float t, float s2, float t2, qhandle_t hShader) {
;124:  float w, h;
;125:  w = width * scale;
;126:  h = height * scale;
;127:  CG_AdjustFrom640( &x, &y, &w, &h );
;128:  trap_R_DrawStretchPic( x, y, w, h, s, t, s2, t2, hShader );
;129:}
;130:
;131:void CG_Text_Paint(float x, float y, float scale, vec4_t color, const char *text, float adjust, int limit, int style) {
;132:  int len, count;
;133:	vec4_t newColor;
;134:	glyphInfo_t *glyph;
;135:	float useScale;
;136:	fontInfo_t *font = &cgDC.Assets.textFont;
;137:	if (scale <= cg_smallFont.value) {
;138:		font = &cgDC.Assets.smallFont;
;139:	} else if (scale > cg_bigFont.value) {
;140:		font = &cgDC.Assets.bigFont;
;141:	}
;142:	useScale = scale * font->glyphScale;
;143:  if (text) {
;144:// TTimo: FIXME
;145://		const unsigned char *s = text;
;146:		const char *s = text;
;147:		trap_R_SetColor( color );
;148:		memcpy(&newColor[0], &color[0], sizeof(vec4_t));
;149:    len = strlen(text);
;150:		if (limit > 0 && len > limit) {
;151:			len = limit;
;152:		}
;153:		count = 0;
;154:		while (s && *s && count < len) {
;155:			glyph = &font->glyphs[(int)*s]; // TTimo: FIXME: getting nasty warnings without the cast, hopefully this doesn't break the VM build
;156:      //int yadj = Assets.textFont.glyphs[text[i]].bottom + Assets.textFont.glyphs[text[i]].top;
;157:      //float yadj = scale * (Assets.textFont.glyphs[text[i]].imageHeight - Assets.textFont.glyphs[text[i]].height);
;158:			if ( Q_IsColorString( s ) ) {
;159:				memcpy( newColor, g_color_table[ColorIndex(*(s+1))], sizeof( newColor ) );
;160:				newColor[3] = color[3];
;161:				trap_R_SetColor( newColor );
;162:				s += 2;
;163:				continue;
;164:			} else {
;165:				float yadj = useScale * glyph->top;
;166:				if (style == ITEM_TEXTSTYLE_SHADOWED || style == ITEM_TEXTSTYLE_SHADOWEDMORE) {
;167:					int ofs = style == ITEM_TEXTSTYLE_SHADOWED ? 1 : 2;
;168:					colorBlack[3] = newColor[3];
;169:					trap_R_SetColor( colorBlack );
;170:					CG_Text_PaintChar(x + ofs, y - yadj + ofs, 
;171:														glyph->imageWidth,
;172:														glyph->imageHeight,
;173:														useScale, 
;174:														glyph->s,
;175:														glyph->t,
;176:														glyph->s2,
;177:														glyph->t2,
;178:														glyph->glyph);
;179:					colorBlack[3] = 1.0;
;180:					trap_R_SetColor( newColor );
;181:				}
;182:				CG_Text_PaintChar(x, y - yadj, 
;183:													glyph->imageWidth,
;184:													glyph->imageHeight,
;185:													useScale, 
;186:													glyph->s,
;187:													glyph->t,
;188:													glyph->s2,
;189:													glyph->t2,
;190:													glyph->glyph);
;191:				// CG_DrawPic(x, y - yadj, scale * cgDC.Assets.textFont.glyphs[text[i]].imageWidth, scale * cgDC.Assets.textFont.glyphs[text[i]].imageHeight, cgDC.Assets.textFont.glyphs[text[i]].glyph);
;192:				x += (glyph->xSkip * useScale) + adjust;
;193:				s++;
;194:				count++;
;195:			}
;196:    }
;197:	  trap_R_SetColor( NULL );
;198:  }
;199:}
;200:
;201:
;202:#endif
;203:
;204:/*
;205:==============
;206:CG_DrawField
;207:
;208:Draws large numbers for status bar and powerups
;209:==============
;210:*/
;211:#ifndef MISSIONPACK
;212:static void CG_DrawField (int x, int y, int width, int value) {
line 217
;213:	char	num[16], *ptr;
;214:	int		l;
;215:	int		frame;
;216:
;217:	if ( width < 1 ) {
ADDRFP4 8
INDIRI4
CNSTI4 1
GEI4 $71
line 218
;218:		return;
ADDRGP4 $70
JUMPV
LABELV $71
line 222
;219:	}
;220:
;221:	// draw number string
;222:	if ( width > 5 ) {
ADDRFP4 8
INDIRI4
CNSTI4 5
LEI4 $73
line 223
;223:		width = 5;
ADDRFP4 8
CNSTI4 5
ASGNI4
line 224
;224:	}
LABELV $73
line 226
;225:
;226:	switch ( width ) {
ADDRLP4 28
ADDRFP4 8
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
LTI4 $75
ADDRLP4 28
INDIRI4
CNSTI4 4
GTI4 $75
ADDRLP4 28
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $105-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $105
address $77
address $84
address $91
address $98
code
LABELV $77
line 228
;227:	case 1:
;228:		value = value > 9 ? 9 : value;
ADDRFP4 12
INDIRI4
CNSTI4 9
LEI4 $79
ADDRLP4 32
CNSTI4 9
ASGNI4
ADDRGP4 $80
JUMPV
LABELV $79
ADDRLP4 32
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $80
ADDRFP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 229
;229:		value = value < 0 ? 0 : value;
ADDRFP4 12
INDIRI4
CNSTI4 0
GEI4 $82
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRGP4 $83
JUMPV
LABELV $82
ADDRLP4 36
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $83
ADDRFP4 12
ADDRLP4 36
INDIRI4
ASGNI4
line 230
;230:		break;
ADDRGP4 $76
JUMPV
LABELV $84
line 232
;231:	case 2:
;232:		value = value > 99 ? 99 : value;
ADDRFP4 12
INDIRI4
CNSTI4 99
LEI4 $86
ADDRLP4 40
CNSTI4 99
ASGNI4
ADDRGP4 $87
JUMPV
LABELV $86
ADDRLP4 40
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $87
ADDRFP4 12
ADDRLP4 40
INDIRI4
ASGNI4
line 233
;233:		value = value < -9 ? -9 : value;
ADDRFP4 12
INDIRI4
CNSTI4 -9
GEI4 $89
ADDRLP4 44
CNSTI4 -9
ASGNI4
ADDRGP4 $90
JUMPV
LABELV $89
ADDRLP4 44
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $90
ADDRFP4 12
ADDRLP4 44
INDIRI4
ASGNI4
line 234
;234:		break;
ADDRGP4 $76
JUMPV
LABELV $91
line 236
;235:	case 3:
;236:		value = value > 999 ? 999 : value;
ADDRFP4 12
INDIRI4
CNSTI4 999
LEI4 $93
ADDRLP4 48
CNSTI4 999
ASGNI4
ADDRGP4 $94
JUMPV
LABELV $93
ADDRLP4 48
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $94
ADDRFP4 12
ADDRLP4 48
INDIRI4
ASGNI4
line 237
;237:		value = value < -99 ? -99 : value;
ADDRFP4 12
INDIRI4
CNSTI4 -99
GEI4 $96
ADDRLP4 52
CNSTI4 -99
ASGNI4
ADDRGP4 $97
JUMPV
LABELV $96
ADDRLP4 52
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $97
ADDRFP4 12
ADDRLP4 52
INDIRI4
ASGNI4
line 238
;238:		break;
ADDRGP4 $76
JUMPV
LABELV $98
line 240
;239:	case 4:
;240:		value = value > 9999 ? 9999 : value;
ADDRFP4 12
INDIRI4
CNSTI4 9999
LEI4 $100
ADDRLP4 56
CNSTI4 9999
ASGNI4
ADDRGP4 $101
JUMPV
LABELV $100
ADDRLP4 56
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $101
ADDRFP4 12
ADDRLP4 56
INDIRI4
ASGNI4
line 241
;241:		value = value < -999 ? -999 : value;
ADDRFP4 12
INDIRI4
CNSTI4 -999
GEI4 $103
ADDRLP4 60
CNSTI4 -999
ASGNI4
ADDRGP4 $104
JUMPV
LABELV $103
ADDRLP4 60
ADDRFP4 12
INDIRI4
ASGNI4
LABELV $104
ADDRFP4 12
ADDRLP4 60
INDIRI4
ASGNI4
line 242
;242:		break;
LABELV $75
LABELV $76
line 245
;243:	}
;244:
;245:	Com_sprintf (num, sizeof(num), "%i", value);
ADDRLP4 12
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 $107
ARGP4
ADDRFP4 12
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 246
;246:	l = strlen(num);
ADDRLP4 12
ARGP4
ADDRLP4 32
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 32
INDIRI4
ASGNI4
line 247
;247:	if (l > width)
ADDRLP4 4
INDIRI4
ADDRFP4 8
INDIRI4
LEI4 $108
line 248
;248:		l = width;
ADDRLP4 4
ADDRFP4 8
INDIRI4
ASGNI4
LABELV $108
line 249
;249:	x += 2 + CHAR_WIDTH*(width - l);
ADDRFP4 0
ADDRFP4 0
INDIRI4
ADDRFP4 8
INDIRI4
ADDRLP4 4
INDIRI4
SUBI4
CNSTI4 5
LSHI4
CNSTI4 2
ADDI4
ADDI4
ASGNI4
line 251
;250:
;251:	ptr = num;
ADDRLP4 0
ADDRLP4 12
ASGNP4
ADDRGP4 $111
JUMPV
LABELV $110
line 253
;252:	while (*ptr && l)
;253:	{
line 254
;254:		if (*ptr == '-')
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $113
line 255
;255:			frame = STAT_MINUS;
ADDRLP4 8
CNSTI4 10
ASGNI4
ADDRGP4 $114
JUMPV
LABELV $113
line 257
;256:		else
;257:			frame = *ptr -'0';
ADDRLP4 8
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
ASGNI4
LABELV $114
line 259
;258:
;259:		CG_DrawPic( x,y, CHAR_WIDTH, CHAR_HEIGHT, cgs.media.numberShaders[frame] );
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1107296256
ARGF4
CNSTF4 1111490560
ARGF4
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+300
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 260
;260:		x += CHAR_WIDTH;
ADDRFP4 0
ADDRFP4 0
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 261
;261:		ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 262
;262:		l--;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 263
;263:	}
LABELV $111
line 252
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ADDRLP4 36
INDIRI4
EQI4 $117
ADDRLP4 4
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $110
LABELV $117
line 264
;264:}
LABELV $70
endproc CG_DrawField 64 20
export CG_Draw3DModel
proc CG_Draw3DModel 512 16
line 273
;265:#endif // MISSIONPACK
;266:
;267:/*
;268:================
;269:CG_Draw3DModel
;270:
;271:================
;272:*/
;273:void CG_Draw3DModel( float x, float y, float w, float h, qhandle_t model, qhandle_t skin, vec3_t origin, vec3_t angles ) {
line 277
;274:	refdef_t		refdef;
;275:	refEntity_t		ent;
;276:
;277:	if ( !cg_draw3dIcons.integer || !cg_drawIcons.integer ) {
ADDRLP4 508
CNSTI4 0
ASGNI4
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 508
INDIRI4
EQI4 $123
ADDRGP4 cg_drawIcons+12
INDIRI4
ADDRLP4 508
INDIRI4
NEI4 $119
LABELV $123
line 278
;278:		return;
ADDRGP4 $118
JUMPV
LABELV $119
line 281
;279:	}
;280:
;281:	CG_AdjustFrom640( &x, &y, &w, &h );
ADDRFP4 0
ARGP4
ADDRFP4 4
ARGP4
ADDRFP4 8
ARGP4
ADDRFP4 12
ARGP4
ADDRGP4 CG_AdjustFrom640
CALLV
pop
line 283
;282:
;283:	memset( &refdef, 0, sizeof( refdef ) );
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 368
ARGI4
ADDRGP4 memset
CALLP4
pop
line 285
;284:
;285:	memset( &ent, 0, sizeof( ent ) );
ADDRLP4 368
ARGP4
CNSTI4 0
ARGI4
CNSTI4 140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 286
;286:	AnglesToAxis( angles, ent.axis );
ADDRFP4 28
INDIRP4
ARGP4
ADDRLP4 368+28
ARGP4
ADDRGP4 AnglesToAxis
CALLV
pop
line 287
;287:	VectorCopy( origin, ent.origin );
ADDRLP4 368+68
ADDRFP4 24
INDIRP4
INDIRB
ASGNB 12
line 288
;288:	ent.hModel = model;
ADDRLP4 368+8
ADDRFP4 16
INDIRI4
ASGNI4
line 289
;289:	ent.customSkin = skin;
ADDRLP4 368+108
ADDRFP4 20
INDIRI4
ASGNI4
line 290
;290:	ent.renderfx = RF_NOSHADOW;		// no stencil shadows
ADDRLP4 368+4
CNSTI4 64
ASGNI4
line 292
;291:
;292:	refdef.rdflags = RDF_NOWORLDMODEL;
ADDRLP4 0+76
CNSTI4 1
ASGNI4
line 294
;293:
;294:	AxisClear( refdef.viewaxis );
ADDRLP4 0+36
ARGP4
ADDRGP4 AxisClear
CALLV
pop
line 296
;295:
;296:	refdef.fov_x = 30;
ADDRLP4 0+16
CNSTF4 1106247680
ASGNF4
line 297
;297:	refdef.fov_y = 30;
ADDRLP4 0+20
CNSTF4 1106247680
ASGNF4
line 299
;298:
;299:	refdef.x = x;
ADDRLP4 0
ADDRFP4 0
INDIRF4
CVFI4 4
ASGNI4
line 300
;300:	refdef.y = y;
ADDRLP4 0+4
ADDRFP4 4
INDIRF4
CVFI4 4
ASGNI4
line 301
;301:	refdef.width = w;
ADDRLP4 0+8
ADDRFP4 8
INDIRF4
CVFI4 4
ASGNI4
line 302
;302:	refdef.height = h;
ADDRLP4 0+12
ADDRFP4 12
INDIRF4
CVFI4 4
ASGNI4
line 304
;303:
;304:	refdef.time = cg.time;
ADDRLP4 0+72
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 306
;305:
;306:	trap_R_ClearScene();
ADDRGP4 trap_R_ClearScene
CALLV
pop
line 307
;307:	trap_R_AddRefEntityToScene( &ent );
ADDRLP4 368
ARGP4
ADDRGP4 trap_R_AddRefEntityToScene
CALLV
pop
line 308
;308:	trap_R_RenderScene( &refdef );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_RenderScene
CALLV
pop
line 309
;309:}
LABELV $118
endproc CG_Draw3DModel 512 16
export CG_DrawHead
proc CG_DrawHead 56 32
line 318
;310:
;311:/*
;312:================
;313:CG_DrawHead
;314:
;315:Used for both the status bar and the scoreboard
;316:================
;317:*/
;318:void CG_DrawHead( float x, float y, float w, float h, int clientNum, vec3_t headAngles ) {
line 325
;319:	clipHandle_t	cm;
;320:	clientInfo_t	*ci;
;321:	float			len;
;322:	vec3_t			origin;
;323:	vec3_t			mins, maxs;
;324:
;325:	ci = &cgs.clientinfo[ clientNum ];
ADDRLP4 0
CNSTI4 1708
ADDRFP4 16
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 327
;326:
;327:	if ( cg_draw3dIcons.integer ) {
ADDRGP4 cg_draw3dIcons+12
INDIRI4
CNSTI4 0
EQI4 $140
line 328
;328:		cm = ci->headModel;
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
ASGNI4
line 329
;329:		if ( !cm ) {
ADDRLP4 40
INDIRI4
CNSTI4 0
NEI4 $143
line 330
;330:			return;
ADDRGP4 $138
JUMPV
LABELV $143
line 334
;331:		}
;332:
;333:		// offset the origin y and z to center the head
;334:		trap_R_ModelBounds( cm, mins, maxs );
ADDRLP4 40
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRLP4 28
ARGP4
ADDRGP4 trap_R_ModelBounds
CALLV
pop
line 336
;335:
;336:		origin[2] = -0.5 * ( mins[2] + maxs[2] );
ADDRLP4 4+8
CNSTF4 3204448256
ADDRLP4 16+8
INDIRF4
ADDRLP4 28+8
INDIRF4
ADDF4
MULF4
ASGNF4
line 337
;337:		origin[1] = 0.5 * ( mins[1] + maxs[1] );
ADDRLP4 4+4
CNSTF4 1056964608
ADDRLP4 16+4
INDIRF4
ADDRLP4 28+4
INDIRF4
ADDF4
MULF4
ASGNF4
line 341
;338:
;339:		// calculate distance so the head nearly fills the box
;340:		// assume heads are taller than wide
;341:		len = 0.7 * ( maxs[2] - mins[2] );		
ADDRLP4 44
CNSTF4 1060320051
ADDRLP4 28+8
INDIRF4
ADDRLP4 16+8
INDIRF4
SUBF4
MULF4
ASGNF4
line 342
;342:		origin[0] = len / 0.268;	// len / tan( fov/2 )
ADDRLP4 4
ADDRLP4 44
INDIRF4
CNSTF4 1049179980
DIVF4
ASGNF4
line 345
;343:
;344:		// allow per-model tweaking
;345:		VectorAdd( origin, ci->headOffset, origin );
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 4+4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 500
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 4+8
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 504
ADDP4
INDIRF4
ADDF4
ASGNF4
line 347
;346:
;347:		CG_Draw3DModel( x, y, w, h, ci->headModel, ci->headSkin, origin, headAngles );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRFP4 20
INDIRP4
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 348
;348:	} else if ( cg_drawIcons.integer ) {
ADDRGP4 $141
JUMPV
LABELV $140
ADDRGP4 cg_drawIcons+12
INDIRI4
CNSTI4 0
EQI4 $157
line 349
;349:		CG_DrawPic( x, y, w, h, ci->modelIcon );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 540
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 350
;350:	}
LABELV $157
LABELV $141
line 353
;351:
;352:	// if they are deferred, draw a cross out
;353:	if ( ci->deferred ) {
ADDRLP4 0
INDIRP4
CNSTI4 480
ADDP4
INDIRI4
CNSTI4 0
EQI4 $160
line 354
;354:		CG_DrawPic( x, y, w, h, cgs.media.deferShader );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRGP4 cgs+152340+132
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 355
;355:	}
LABELV $160
line 356
;356:}
LABELV $138
endproc CG_DrawHead 56 32
export CG_DrawFlagModel
proc CG_DrawFlagModel 72 32
line 365
;357:
;358:/*
;359:================
;360:CG_DrawFlagModel
;361:
;362:Used for both the status bar and the scoreboard
;363:================
;364:*/
;365:void CG_DrawFlagModel( float x, float y, float w, float h, int team, qboolean force2D ) {
line 372
;366:	qhandle_t		cm;
;367:	float			len;
;368:	vec3_t			origin, angles;
;369:	vec3_t			mins, maxs;
;370:	qhandle_t		handle;
;371:
;372:	if ( !force2D && cg_draw3dIcons.integer ) {
ADDRLP4 60
CNSTI4 0
ASGNI4
ADDRFP4 20
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $165
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 60
INDIRI4
EQI4 $165
line 374
;373:
;374:		VectorClear( angles );
ADDRLP4 64
CNSTF4 0
ASGNF4
ADDRLP4 0+8
ADDRLP4 64
INDIRF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 64
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 64
INDIRF4
ASGNF4
line 376
;375:
;376:		cm = cgs.media.redFlagModel;
ADDRLP4 48
ADDRGP4 cgs+152340+36
INDIRI4
ASGNI4
line 379
;377:
;378:		// offset the origin y and z to center the flag
;379:		trap_R_ModelBounds( cm, mins, maxs );
ADDRLP4 48
INDIRI4
ARGI4
ADDRLP4 24
ARGP4
ADDRLP4 36
ARGP4
ADDRGP4 trap_R_ModelBounds
CALLV
pop
line 381
;380:
;381:		origin[2] = -0.5 * ( mins[2] + maxs[2] );
ADDRLP4 12+8
CNSTF4 3204448256
ADDRLP4 24+8
INDIRF4
ADDRLP4 36+8
INDIRF4
ADDF4
MULF4
ASGNF4
line 382
;382:		origin[1] = 0.5 * ( mins[1] + maxs[1] );
ADDRLP4 12+4
CNSTF4 1056964608
ADDRLP4 24+4
INDIRF4
ADDRLP4 36+4
INDIRF4
ADDF4
MULF4
ASGNF4
line 386
;383:
;384:		// calculate distance so the flag nearly fills the box
;385:		// assume heads are taller than wide
;386:		len = 0.5 * ( maxs[2] - mins[2] );		
ADDRLP4 52
CNSTF4 1056964608
ADDRLP4 36+8
INDIRF4
ADDRLP4 24+8
INDIRF4
SUBF4
MULF4
ASGNF4
line 387
;387:		origin[0] = len / 0.268;	// len / tan( fov/2 )
ADDRLP4 12
ADDRLP4 52
INDIRF4
CNSTF4 1049179980
DIVF4
ASGNF4
line 389
;388:
;389:		angles[YAW] = 60 * sin( cg.time / 2000.0 );;
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1157234688
DIVF4
ARGF4
ADDRLP4 68
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 0+4
CNSTF4 1114636288
ADDRLP4 68
INDIRF4
MULF4
ASGNF4
line 391
;390:
;391:		if( team == TEAM_RED ) {
ADDRFP4 16
INDIRI4
CNSTI4 1
NEI4 $182
line 392
;392:			handle = cgs.media.redFlagModel;
ADDRLP4 56
ADDRGP4 cgs+152340+36
INDIRI4
ASGNI4
line 393
;393:		} else if( team == TEAM_BLUE ) {
ADDRGP4 $183
JUMPV
LABELV $182
ADDRFP4 16
INDIRI4
CNSTI4 2
NEI4 $186
line 394
;394:			handle = cgs.media.blueFlagModel;
ADDRLP4 56
ADDRGP4 cgs+152340+40
INDIRI4
ASGNI4
line 395
;395:		} else if( team == TEAM_FREE ) {
ADDRGP4 $187
JUMPV
LABELV $186
ADDRFP4 16
INDIRI4
CNSTI4 0
NEI4 $164
line 396
;396:			handle = cgs.media.neutralFlagModel;
ADDRLP4 56
ADDRGP4 cgs+152340+44
INDIRI4
ASGNI4
line 397
;397:		} else {
line 398
;398:			return;
LABELV $191
LABELV $187
LABELV $183
line 400
;399:		}
;400:		CG_Draw3DModel( x, y, w, h, handle, 0, origin, angles );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 56
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 401
;401:	} else if ( cg_drawIcons.integer ) {
ADDRGP4 $166
JUMPV
LABELV $165
ADDRGP4 cg_drawIcons+12
INDIRI4
CNSTI4 0
EQI4 $194
line 404
;402:		gitem_t *item;
;403:
;404:		if( team == TEAM_RED ) {
ADDRFP4 16
INDIRI4
CNSTI4 1
NEI4 $197
line 405
;405:			item = BG_FindItemForPowerup( PW_REDFLAG );
CNSTI4 7
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 68
INDIRP4
ASGNP4
line 406
;406:		} else if( team == TEAM_BLUE ) {
ADDRGP4 $198
JUMPV
LABELV $197
ADDRFP4 16
INDIRI4
CNSTI4 2
NEI4 $199
line 407
;407:			item = BG_FindItemForPowerup( PW_BLUEFLAG );
CNSTI4 8
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 68
INDIRP4
ASGNP4
line 408
;408:		} else if( team == TEAM_FREE ) {
ADDRGP4 $200
JUMPV
LABELV $199
ADDRFP4 16
INDIRI4
CNSTI4 0
NEI4 $164
line 409
;409:			item = BG_FindItemForPowerup( PW_NEUTRALFLAG );
CNSTI4 9
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 64
ADDRLP4 68
INDIRP4
ASGNP4
line 410
;410:		} else {
line 411
;411:			return;
LABELV $202
LABELV $200
LABELV $198
line 413
;412:		}
;413:		if (item) {
ADDRLP4 64
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $203
line 414
;414:		  CG_DrawPic( x, y, w, h, cg_items[ ITEM_INDEX(item) ].icon );
ADDRFP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRF4
ARGF4
ADDRFP4 8
INDIRF4
ARGF4
ADDRFP4 12
INDIRF4
ARGF4
CNSTI4 24
ADDRLP4 64
INDIRP4
CVPU4 4
ADDRGP4 bg_itemlist
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 52
DIVI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 415
;415:		}
LABELV $203
line 416
;416:	}
LABELV $194
LABELV $166
line 417
;417:}
LABELV $164
endproc CG_DrawFlagModel 72 32
proc CG_DrawStatusBarHead 56 24
line 427
;418:
;419:/*
;420:================
;421:CG_DrawStatusBarHead
;422:
;423:================
;424:*/
;425:#ifndef MISSIONPACK
;426:
;427:static void CG_DrawStatusBarHead( float x ) {
line 432
;428:	vec3_t		angles;
;429:	float		size, stretch;
;430:	float		frac;
;431:
;432:	VectorClear( angles );
ADDRLP4 24
CNSTF4 0
ASGNF4
ADDRLP4 4+8
ADDRLP4 24
INDIRF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 24
INDIRF4
ASGNF4
ADDRLP4 4
ADDRLP4 24
INDIRF4
ASGNF4
line 434
;433:
;434:	if ( cg.damageTime && cg.time - cg.damageTime < DAMAGE_TIME ) {
ADDRGP4 cg+124688
INDIRF4
CNSTF4 0
EQF4 $209
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124688
INDIRF4
SUBF4
CNSTF4 1140457472
GEF4 $209
line 435
;435:		frac = (float)(cg.time - cg.damageTime ) / DAMAGE_TIME;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124688
INDIRF4
SUBF4
CNSTF4 1140457472
DIVF4
ASGNF4
line 436
;436:		size = ICON_SIZE * 1.25 * ( 1.5 - frac * 0.5 );
ADDRLP4 16
CNSTF4 1114636288
CNSTF4 1069547520
CNSTF4 1056964608
ADDRLP4 0
INDIRF4
MULF4
SUBF4
MULF4
ASGNF4
line 438
;437:
;438:		stretch = size - ICON_SIZE * 1.25;
ADDRLP4 20
ADDRLP4 16
INDIRF4
CNSTF4 1114636288
SUBF4
ASGNF4
line 440
;439:		// kick in the direction of damage
;440:		x -= stretch * 0.5 + cg.damageX * stretch * 0.5;
ADDRLP4 28
CNSTF4 1056964608
ASGNF4
ADDRLP4 32
ADDRLP4 20
INDIRF4
ASGNF4
ADDRFP4 0
ADDRFP4 0
INDIRF4
ADDRLP4 28
INDIRF4
ADDRLP4 32
INDIRF4
MULF4
ADDRLP4 28
INDIRF4
ADDRGP4 cg+124692
INDIRF4
ADDRLP4 32
INDIRF4
MULF4
MULF4
ADDF4
SUBF4
ASGNF4
line 442
;441:
;442:		cg.headStartYaw = 180 + cg.damageX * 45;
ADDRGP4 cg+124724
CNSTF4 1110704128
ADDRGP4 cg+124692
INDIRF4
MULF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 444
;443:
;444:		cg.headEndYaw = 180 + 20 * cos( crandom()*M_PI );
ADDRLP4 36
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
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
ARGF4
ADDRLP4 40
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124712
CNSTF4 1101004800
ADDRLP4 40
INDIRF4
MULF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 445
;445:		cg.headEndPitch = 5 * cos( crandom()*M_PI );
ADDRLP4 44
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
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
ARGF4
ADDRLP4 48
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124708
CNSTF4 1084227584
ADDRLP4 48
INDIRF4
MULF4
ASGNF4
line 447
;446:
;447:		cg.headStartTime = cg.time;
ADDRGP4 cg+124728
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 448
;448:		cg.headEndTime = cg.time + 100 + random() * 2000;
ADDRLP4 52
ADDRGP4 rand
CALLI4
ASGNI4
ADDRGP4 cg+124716
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
CNSTF4 1157234688
ADDRLP4 52
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
line 449
;449:	} else {
ADDRGP4 $210
JUMPV
LABELV $209
line 450
;450:		if ( cg.time >= cg.headEndTime ) {
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124716
INDIRI4
LTI4 $225
line 452
;451:			// select a new head angle
;452:			cg.headStartYaw = cg.headEndYaw;
ADDRGP4 cg+124724
ADDRGP4 cg+124712
INDIRF4
ASGNF4
line 453
;453:			cg.headStartPitch = cg.headEndPitch;
ADDRGP4 cg+124720
ADDRGP4 cg+124708
INDIRF4
ASGNF4
line 454
;454:			cg.headStartTime = cg.headEndTime;
ADDRGP4 cg+124728
ADDRGP4 cg+124716
INDIRI4
ASGNI4
line 455
;455:			cg.headEndTime = cg.time + 100 + random() * 2000;
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRGP4 cg+124716
ADDRGP4 cg+107604
INDIRI4
CNSTI4 100
ADDI4
CVIF4 4
CNSTF4 1157234688
ADDRLP4 28
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
line 457
;456:
;457:			cg.headEndYaw = 180 + 20 * cos( crandom()*M_PI );
ADDRLP4 32
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
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
ARGF4
ADDRLP4 36
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124712
CNSTF4 1101004800
ADDRLP4 36
INDIRF4
MULF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 458
;458:			cg.headEndPitch = 5 * cos( crandom()*M_PI );
ADDRLP4 40
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1078530011
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
ARGF4
ADDRLP4 44
ADDRGP4 cos
CALLF4
ASGNF4
ADDRGP4 cg+124708
CNSTF4 1084227584
ADDRLP4 44
INDIRF4
MULF4
ASGNF4
line 459
;459:		}
LABELV $225
line 461
;460:
;461:		size = ICON_SIZE * 1.25;
ADDRLP4 16
CNSTF4 1114636288
ASGNF4
line 462
;462:	}
LABELV $210
line 465
;463:
;464:	// if the server was frozen for a while we may have a bad head start time
;465:	if ( cg.headStartTime > cg.time ) {
ADDRGP4 cg+124728
INDIRI4
ADDRGP4 cg+107604
INDIRI4
LEI4 $239
line 466
;466:		cg.headStartTime = cg.time;
ADDRGP4 cg+124728
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 467
;467:	}
LABELV $239
line 469
;468:
;469:	frac = ( cg.time - cg.headStartTime ) / (float)( cg.headEndTime - cg.headStartTime );
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124728
INDIRI4
SUBI4
CVIF4 4
ADDRGP4 cg+124716
INDIRI4
ADDRGP4 cg+124728
INDIRI4
SUBI4
CVIF4 4
DIVF4
ASGNF4
line 470
;470:	frac = frac * frac * ( 3 - 2 * frac );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
CNSTF4 1077936128
CNSTF4 1073741824
ADDRLP4 0
INDIRF4
MULF4
SUBF4
MULF4
ASGNF4
line 471
;471:	angles[YAW] = cg.headStartYaw + ( cg.headEndYaw - cg.headStartYaw ) * frac;
ADDRLP4 4+4
ADDRGP4 cg+124724
INDIRF4
ADDRGP4 cg+124712
INDIRF4
ADDRGP4 cg+124724
INDIRF4
SUBF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 472
;472:	angles[PITCH] = cg.headStartPitch + ( cg.headEndPitch - cg.headStartPitch ) * frac;
ADDRLP4 4
ADDRGP4 cg+124720
INDIRF4
ADDRGP4 cg+124708
INDIRF4
ADDRGP4 cg+124720
INDIRF4
SUBF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
line 474
;473:
;474:	CG_DrawHead( x, 480 - size, size, size, 
ADDRFP4 0
INDIRF4
ARGF4
CNSTF4 1139802112
ADDRLP4 16
INDIRF4
SUBF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 CG_DrawHead
CALLV
pop
line 476
;475:				cg.snap->ps.clientNum, angles );
;476:}
LABELV $206
endproc CG_DrawStatusBarHead 56 24
proc CG_DrawStatusBarFlag 4 24
line 486
;477:#endif // MISSIONPACK
;478:
;479:/*
;480:================
;481:CG_DrawStatusBarFlag
;482:
;483:================
;484:*/
;485:#ifndef MISSIONPACK
;486:static void CG_DrawStatusBarFlag( float x, int team ) {
line 487
;487:	CG_DrawFlagModel( x, 480 - ICON_SIZE, ICON_SIZE, ICON_SIZE, team, qfalse );
ADDRFP4 0
INDIRF4
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 0
CNSTF4 1111490560
ASGNF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRFP4 4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawFlagModel
CALLV
pop
line 488
;488:}
LABELV $257
endproc CG_DrawStatusBarFlag 4 24
export CG_DrawTeamBackground
proc CG_DrawTeamBackground 16 20
line 498
;489:#endif // MISSIONPACK
;490:
;491:/*
;492:================
;493:CG_DrawTeamBackground
;494:
;495:================
;496:*/
;497:void CG_DrawTeamBackground( int x, int y, int w, int h, float alpha, int team )
;498:{
line 501
;499:	vec4_t		hcolor;
;500:
;501:	hcolor[3] = alpha;
ADDRLP4 0+12
ADDRFP4 16
INDIRF4
ASGNF4
line 502
;502:	if ( team == TEAM_RED ) {
ADDRFP4 20
INDIRI4
CNSTI4 1
NEI4 $260
line 503
;503:		hcolor[0] = 1;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 504
;504:		hcolor[1] = 0;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 505
;505:		hcolor[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 506
;506:	} else if ( team == TEAM_BLUE ) {
ADDRGP4 $261
JUMPV
LABELV $260
ADDRFP4 20
INDIRI4
CNSTI4 2
NEI4 $258
line 507
;507:		hcolor[0] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 508
;508:		hcolor[1] = 0;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 509
;509:		hcolor[2] = 1;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 510
;510:	} else {
line 511
;511:		return;
LABELV $265
LABELV $261
line 513
;512:	}
;513:	trap_R_SetColor( hcolor );
ADDRLP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 514
;514:	CG_DrawPic( x, y, w, h, cgs.media.teamStatusBar );
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 cgs+152340+128
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 515
;515:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 516
;516:}
LABELV $258
endproc CG_DrawTeamBackground 16 20
data
align 4
LABELV $271
byte 4 1065353216
byte 4 1060152279
byte 4 0
byte 4 1065353216
byte 4 1065353216
byte 4 1045220557
byte 4 1045220557
byte 4 1065353216
byte 4 1056964608
byte 4 1056964608
byte 4 1056964608
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
code
proc CG_DrawStatusBar 80 32
line 525
;517:
;518:/*
;519:================
;520:CG_DrawStatusBar
;521:
;522:================
;523:*/
;524:#ifndef MISSIONPACK
;525:static void CG_DrawStatusBar( void ) {
line 543
;526:	int			color;
;527:	centity_t	*cent;
;528:	playerState_t	*ps;
;529:	int			value;
;530:	vec4_t		hcolor;
;531:	vec3_t		angles;
;532:	vec3_t		origin;
;533:#ifdef MISSIONPACK
;534:	qhandle_t	handle;
;535:#endif
;536:	static float colors[4][4] = { 
;537://		{ 0.2, 1.0, 0.2, 1.0 } , { 1.0, 0.2, 0.2, 1.0 }, {0.5, 0.5, 0.5, 1} };
;538:		{ 1.0f, 0.69f, 0.0f, 1.0f },    // normal
;539:		{ 1.0f, 0.2f, 0.2f, 1.0f },     // low health
;540:		{ 0.5f, 0.5f, 0.5f, 1.0f },     // weapon firing
;541:		{ 1.0f, 1.0f, 1.0f, 1.0f } };   // health > 100
;542:
;543:	if ( cg_drawStatus.integer == 0 ) {
ADDRGP4 cg_drawStatus+12
INDIRI4
CNSTI4 0
NEI4 $272
line 544
;544:		return;
ADDRGP4 $270
JUMPV
LABELV $272
line 548
;545:	}
;546:
;547:	// draw the team background
;548:	CG_DrawTeamBackground( 0, 420, 640, 60, 0.33f, cg.snap->ps.persistant[PERS_TEAM] );
CNSTI4 0
ARGI4
CNSTI4 420
ARGI4
CNSTI4 640
ARGI4
CNSTI4 60
ARGI4
CNSTF4 1051260355
ARGF4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawTeamBackground
CALLV
pop
line 550
;549:
;550:	cent = &cg_entities[cg.snap->ps.clientNum];
ADDRLP4 4
CNSTI4 728
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
line 551
;551:	ps = &cg.snap->ps;
ADDRLP4 20
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
line 553
;552:
;553:	VectorClear( angles );
ADDRLP4 56
CNSTF4 0
ASGNF4
ADDRLP4 8+8
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 8+4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 8
ADDRLP4 56
INDIRF4
ASGNF4
line 556
;554:
;555:	// draw any 3D icons first, so the changes back to 2D are minimized
;556:	if ( cent->currentState.weapon && cg_weapons[ cent->currentState.weapon ].ammoModel ) {
ADDRLP4 60
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ASGNI4
ADDRLP4 64
CNSTI4 0
ASGNI4
ADDRLP4 60
INDIRI4
ADDRLP4 64
INDIRI4
EQI4 $280
CNSTI4 136
ADDRLP4 60
INDIRI4
MULI4
ADDRGP4 cg_weapons+76
ADDP4
INDIRI4
ADDRLP4 64
INDIRI4
EQI4 $280
line 557
;557:		origin[0] = 70;
ADDRLP4 24
CNSTF4 1116471296
ASGNF4
line 558
;558:		origin[1] = 0;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 559
;559:		origin[2] = 0;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 560
;560:		angles[YAW] = 90 + 20 * sin( cg.time / 1000.0 );
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ARGF4
ADDRLP4 68
ADDRGP4 sin
CALLF4
ASGNF4
ADDRLP4 8+4
CNSTF4 1101004800
ADDRLP4 68
INDIRF4
MULF4
CNSTF4 1119092736
ADDF4
ASGNF4
line 561
;561:		CG_Draw3DModel( CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE,
CNSTF4 1120403456
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 72
CNSTF4 1111490560
ASGNF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRLP4 72
INDIRF4
ARGF4
CNSTI4 136
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons+76
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 24
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 563
;562:					   cg_weapons[ cent->currentState.weapon ].ammoModel, 0, origin, angles );
;563:	}
LABELV $280
line 565
;564:
;565:	CG_DrawStatusBarHead( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE );
CNSTF4 1133412352
ARGF4
ADDRGP4 CG_DrawStatusBarHead
CALLV
pop
line 567
;566:
;567:	if( cg.predictedPlayerState.powerups[PW_REDFLAG] ) {
ADDRGP4 cg+107636+312+28
INDIRI4
CNSTI4 0
EQI4 $288
line 568
;568:		CG_DrawStatusBarFlag( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE + ICON_SIZE, TEAM_RED );
CNSTF4 1134985216
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 CG_DrawStatusBarFlag
CALLV
pop
line 569
;569:	} else if( cg.predictedPlayerState.powerups[PW_BLUEFLAG] ) {
ADDRGP4 $289
JUMPV
LABELV $288
ADDRGP4 cg+107636+312+32
INDIRI4
CNSTI4 0
EQI4 $293
line 570
;570:		CG_DrawStatusBarFlag( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE + ICON_SIZE, TEAM_BLUE );
CNSTF4 1134985216
ARGF4
CNSTI4 2
ARGI4
ADDRGP4 CG_DrawStatusBarFlag
CALLV
pop
line 571
;571:	} else if( cg.predictedPlayerState.powerups[PW_NEUTRALFLAG] ) {
ADDRGP4 $294
JUMPV
LABELV $293
ADDRGP4 cg+107636+312+36
INDIRI4
CNSTI4 0
EQI4 $298
line 572
;572:		CG_DrawStatusBarFlag( 185 + CHAR_WIDTH*3 + TEXT_ICON_SPACE + ICON_SIZE, TEAM_FREE );
CNSTF4 1134985216
ARGF4
CNSTI4 0
ARGI4
ADDRGP4 CG_DrawStatusBarFlag
CALLV
pop
line 573
;573:	}
LABELV $298
LABELV $294
LABELV $289
line 575
;574:
;575:	if ( ps->stats[ STAT_ARMOR ] ) {
ADDRLP4 20
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
CNSTI4 0
EQI4 $303
line 576
;576:		origin[0] = 90;
ADDRLP4 24
CNSTF4 1119092736
ASGNF4
line 577
;577:		origin[1] = 0;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 578
;578:		origin[2] = -10;
ADDRLP4 24+8
CNSTF4 3240099840
ASGNF4
line 579
;579:		angles[YAW] = ( cg.time & 2047 ) * 360 / 2048.0;
ADDRLP4 8+4
CNSTI4 360
ADDRGP4 cg+107604
INDIRI4
CNSTI4 2047
BANDI4
MULI4
CVIF4 4
CNSTF4 1157627904
DIVF4
ASGNF4
line 580
;580:		CG_Draw3DModel( 370 + CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE,
CNSTF4 1139474432
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 68
CNSTF4 1111490560
ASGNF4
ADDRLP4 68
INDIRF4
ARGF4
ADDRLP4 68
INDIRF4
ARGF4
ADDRGP4 cgs+152340+120
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 24
ARGP4
ADDRLP4 8
ARGP4
ADDRGP4 CG_Draw3DModel
CALLV
pop
line 582
;581:					   cgs.media.armorModel, 0, origin, angles );
;582:	}
LABELV $303
line 600
;583:#ifdef MISSIONPACK
;584:	if( cgs.gametype == GT_HARVESTER ) {
;585:		origin[0] = 90;
;586:		origin[1] = 0;
;587:		origin[2] = -10;
;588:		angles[YAW] = ( cg.time & 2047 ) * 360 / 2048.0;
;589:		if( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
;590:			handle = cgs.media.redCubeModel;
;591:		} else {
;592:			handle = cgs.media.blueCubeModel;
;593:		}
;594:		CG_Draw3DModel( 640 - (TEXT_ICON_SPACE + ICON_SIZE), 416, ICON_SIZE, ICON_SIZE, handle, 0, origin, angles );
;595:	}
;596:#endif
;597:	//
;598:	// ammo
;599:	//
;600:	if ( cent->currentState.weapon ) {
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 0
EQI4 $311
line 601
;601:		value = ps->ammo[cent->currentState.weapon];
ADDRLP4 0
ADDRLP4 4
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 20
INDIRP4
CNSTI4 376
ADDP4
ADDP4
INDIRI4
ASGNI4
line 602
;602:		if ( value > -1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 -1
LEI4 $313
line 603
;603:			if ( cg.predictedPlayerState.weaponstate == WEAPON_FIRING
ADDRGP4 cg+107636+148
INDIRI4
CNSTI4 3
NEI4 $315
ADDRGP4 cg+107636+44
INDIRI4
CNSTI4 100
LEI4 $315
line 604
;604:				&& cg.predictedPlayerState.weaponTime > 100 ) {
line 606
;605:				// draw as dark grey when reloading
;606:				color = 2;	// dark grey
ADDRLP4 52
CNSTI4 2
ASGNI4
line 607
;607:			} else {
ADDRGP4 $316
JUMPV
LABELV $315
line 608
;608:				if ( value >= 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $321
line 609
;609:					color = 0;	// green
ADDRLP4 52
CNSTI4 0
ASGNI4
line 610
;610:				} else {
ADDRGP4 $322
JUMPV
LABELV $321
line 611
;611:					color = 1;	// red
ADDRLP4 52
CNSTI4 1
ASGNI4
line 612
;612:				}
LABELV $322
line 613
;613:			}
LABELV $316
line 614
;614:			trap_R_SetColor( colors[color] );
ADDRLP4 52
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 $271
ADDP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 616
;615:			
;616:			CG_DrawField (0, 432, 3, value);
CNSTI4 0
ARGI4
CNSTI4 432
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 617
;617:			trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 620
;618:
;619:			// if we didn't draw a 3D icon, draw a 2D icon for ammo
;620:			if ( !cg_draw3dIcons.integer && cg_drawIcons.integer ) {
ADDRLP4 68
CNSTI4 0
ASGNI4
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
NEI4 $323
ADDRGP4 cg_drawIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
EQI4 $323
line 623
;621:				qhandle_t	icon;
;622:
;623:				icon = cg_weapons[ cg.predictedPlayerState.weapon ].ammoIcon;
ADDRLP4 72
CNSTI4 136
ADDRGP4 cg+107636+144
INDIRI4
MULI4
ADDRGP4 cg_weapons+72
ADDP4
INDIRI4
ASGNI4
line 624
;624:				if ( icon ) {
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $330
line 625
;625:					CG_DrawPic( CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE, icon );
CNSTF4 1120403456
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 76
CNSTF4 1111490560
ASGNF4
ADDRLP4 76
INDIRF4
ARGF4
ADDRLP4 76
INDIRF4
ARGF4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 626
;626:				}
LABELV $330
line 627
;627:			}
LABELV $323
line 628
;628:		}
LABELV $313
line 629
;629:	}
LABELV $311
line 634
;630:
;631:	//
;632:	// health
;633:	//
;634:	value = ps->stats[STAT_HEALTH];
ADDRLP4 0
ADDRLP4 20
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 635
;635:	if ( value > 100 ) {
ADDRLP4 0
INDIRI4
CNSTI4 100
LEI4 $332
line 636
;636:		trap_R_SetColor( colors[3] );		// white
ADDRGP4 $271+48
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 637
;637:	} else if (value > 25) {
ADDRGP4 $333
JUMPV
LABELV $332
ADDRLP4 0
INDIRI4
CNSTI4 25
LEI4 $335
line 638
;638:		trap_R_SetColor( colors[0] );	// green
ADDRGP4 $271
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 639
;639:	} else if (value > 0) {
ADDRGP4 $336
JUMPV
LABELV $335
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $337
line 640
;640:		color = (cg.time >> 8) & 1;	// flash
ADDRLP4 52
ADDRGP4 cg+107604
INDIRI4
CNSTI4 8
RSHI4
CNSTI4 1
BANDI4
ASGNI4
line 641
;641:		trap_R_SetColor( colors[color] );
ADDRLP4 52
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 $271
ADDP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 642
;642:	} else {
ADDRGP4 $338
JUMPV
LABELV $337
line 643
;643:		trap_R_SetColor( colors[1] );	// red
ADDRGP4 $271+16
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 644
;644:	}
LABELV $338
LABELV $336
LABELV $333
line 647
;645:
;646:	// stretch the health up when taking damage
;647:	CG_DrawField ( 185, 432, 3, value);
CNSTI4 185
ARGI4
CNSTI4 432
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 648
;648:	CG_ColorForHealth( hcolor );
ADDRLP4 36
ARGP4
ADDRGP4 CG_ColorForHealth
CALLV
pop
line 649
;649:	trap_R_SetColor( hcolor );
ADDRLP4 36
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 655
;650:
;651:
;652:	//
;653:	// armor
;654:	//
;655:	value = ps->stats[STAT_ARMOR];
ADDRLP4 0
ADDRLP4 20
INDIRP4
CNSTI4 196
ADDP4
INDIRI4
ASGNI4
line 656
;656:	if (value > 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $341
line 657
;657:		trap_R_SetColor( colors[0] );
ADDRGP4 $271
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 658
;658:		CG_DrawField (370, 432, 3, value);
CNSTI4 370
ARGI4
CNSTI4 432
ARGI4
CNSTI4 3
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 659
;659:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 661
;660:		// if we didn't draw a 3D icon, draw a 2D icon for armor
;661:		if ( !cg_draw3dIcons.integer && cg_drawIcons.integer ) {
ADDRLP4 68
CNSTI4 0
ASGNI4
ADDRGP4 cg_draw3dIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
NEI4 $343
ADDRGP4 cg_drawIcons+12
INDIRI4
ADDRLP4 68
INDIRI4
EQI4 $343
line 662
;662:			CG_DrawPic( 370 + CHAR_WIDTH*3 + TEXT_ICON_SPACE, 432, ICON_SIZE, ICON_SIZE, cgs.media.armorIcon );
CNSTF4 1139474432
ARGF4
CNSTF4 1138229248
ARGF4
ADDRLP4 72
CNSTF4 1111490560
ASGNF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRGP4 cgs+152340+124
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 663
;663:		}
LABELV $343
line 665
;664:
;665:	}
LABELV $341
line 689
;666:#ifdef MISSIONPACK
;667:	//
;668:	// cubes
;669:	//
;670:	if( cgs.gametype == GT_HARVESTER ) {
;671:		value = ps->generic1;
;672:		if( value > 99 ) {
;673:			value = 99;
;674:		}
;675:		trap_R_SetColor( colors[0] );
;676:		CG_DrawField (640 - (CHAR_WIDTH*2 + TEXT_ICON_SPACE + ICON_SIZE), 432, 2, value);
;677:		trap_R_SetColor( NULL );
;678:		// if we didn't draw a 3D icon, draw a 2D icon for armor
;679:		if ( !cg_draw3dIcons.integer && cg_drawIcons.integer ) {
;680:			if( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
;681:				handle = cgs.media.redCubeIcon;
;682:			} else {
;683:				handle = cgs.media.blueCubeIcon;
;684:			}
;685:			CG_DrawPic( 640 - (TEXT_ICON_SPACE + ICON_SIZE), 432, ICON_SIZE, ICON_SIZE, handle );
;686:		}
;687:	}
;688:#endif
;689:}
LABELV $270
endproc CG_DrawStatusBar 80 32
proc CG_DrawAttacker 52 24
line 706
;690:#endif
;691:
;692:/*
;693:===========================================================================================
;694:
;695:  UPPER RIGHT CORNER
;696:
;697:===========================================================================================
;698:*/
;699:
;700:/*
;701:================
;702:CG_DrawAttacker
;703:
;704:================
;705:*/
;706:static float CG_DrawAttacker( float y ) {
line 714
;707:	int			t;
;708:	float		size;
;709:	vec3_t		angles;
;710:	const char	*info;
;711:	const char	*name;
;712:	int			clientNum;
;713:
;714:	if ( cg.predictedPlayerState.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+107636+184
INDIRI4
CNSTI4 0
GTI4 $350
line 715
;715:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $349
JUMPV
LABELV $350
line 718
;716:	}
;717:
;718:	if ( !cg.attackerTime ) {
ADDRGP4 cg+124416
INDIRI4
CNSTI4 0
NEI4 $354
line 719
;719:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $349
JUMPV
LABELV $354
line 722
;720:	}
;721:
;722:	clientNum = cg.predictedPlayerState.persistant[PERS_ATTACKER];
ADDRLP4 0
ADDRGP4 cg+107636+248+24
INDIRI4
ASGNI4
line 723
;723:	if ( clientNum < 0 || clientNum >= MAX_CLIENTS || clientNum == cg.snap->ps.clientNum ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $364
ADDRLP4 0
INDIRI4
CNSTI4 64
GEI4 $364
ADDRLP4 0
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
NEI4 $360
LABELV $364
line 724
;724:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $349
JUMPV
LABELV $360
line 727
;725:	}
;726:
;727:	t = cg.time - cg.attackerTime;
ADDRLP4 24
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124416
INDIRI4
SUBI4
ASGNI4
line 728
;728:	if ( t > ATTACKER_HEAD_TIME ) {
ADDRLP4 24
INDIRI4
CNSTI4 10000
LEI4 $367
line 729
;729:		cg.attackerTime = 0;
ADDRGP4 cg+124416
CNSTI4 0
ASGNI4
line 730
;730:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $349
JUMPV
LABELV $367
line 733
;731:	}
;732:
;733:	size = ICON_SIZE * 1.25;
ADDRLP4 4
CNSTF4 1114636288
ASGNF4
line 735
;734:
;735:	angles[PITCH] = 0;
ADDRLP4 8
CNSTF4 0
ASGNF4
line 736
;736:	angles[YAW] = 180;
ADDRLP4 8+4
CNSTF4 1127481344
ASGNF4
line 737
;737:	angles[ROLL] = 0;
ADDRLP4 8+8
CNSTF4 0
ASGNF4
line 738
;738:	CG_DrawHead( 640 - size, y, size, size, clientNum, angles );
CNSTF4 1142947840
ADDRLP4 4
INDIRF4
SUBF4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ARGP4
ADDRGP4 CG_DrawHead
CALLV
pop
line 740
;739:
;740:	info = CG_ConfigString( CS_PLAYERS + clientNum );
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 40
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 40
INDIRP4
ASGNP4
line 741
;741:	name = Info_ValueForKey(  info, "n" );
ADDRLP4 28
INDIRP4
ARGP4
ADDRGP4 $372
ARGP4
ADDRLP4 44
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 44
INDIRP4
ASGNP4
line 742
;742:	y += size;
ADDRFP4 0
ADDRFP4 0
INDIRF4
ADDRLP4 4
INDIRF4
ADDF4
ASGNF4
line 743
;743:	CG_DrawBigString( 640 - ( Q_PrintStrlen( name ) * BIGCHAR_WIDTH), y, name, 0.5 );
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 48
ADDRGP4 Q_PrintStrlen
CALLI4
ASGNI4
CNSTI4 640
ADDRLP4 48
INDIRI4
CNSTI4 4
LSHI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
CNSTF4 1056964608
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 745
;744:
;745:	return y + BIGCHAR_HEIGHT + 2;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1073741824
ADDF4
RETF4
LABELV $349
endproc CG_DrawAttacker 52 24
proc CG_DrawSnapshot 16 16
line 753
;746:}
;747:
;748:/*
;749:==================
;750:CG_DrawSnapshot
;751:==================
;752:*/
;753:static float CG_DrawSnapshot( float y ) {
line 757
;754:	char		*s;
;755:	int			w;
;756:
;757:	s = va( "time:%i snap:%i cmd:%i", cg.snap->serverTime, 
ADDRGP4 $374
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 cg+28
INDIRI4
ARGI4
ADDRGP4 cgs+31444
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
line 759
;758:		cg.latestSnapshotNum, cgs.serverCommandSequence );
;759:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 761
;760:
;761:	CG_DrawBigString( 635 - w, y + 2, s, 1.0F);
CNSTI4 635
ADDRLP4 4
INDIRI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CNSTF4 1073741824
ADDF4
CVFI4 4
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 763
;762:
;763:	return y + BIGCHAR_HEIGHT + 4;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1082130432
ADDF4
RETF4
LABELV $373
endproc CG_DrawSnapshot 16 16
bss
align 4
LABELV $379
skip 16
align 4
LABELV $380
skip 4
align 4
LABELV $381
skip 4
code
proc CG_DrawFPS 44 16
line 772
;764:}
;765:
;766:/*
;767:==================
;768:CG_DrawFPS
;769:==================
;770:*/
;771:#define	FPS_FRAMES	4
;772:static float CG_DrawFPS( float y ) {
line 784
;773:	char		*s;
;774:	int			w;
;775:	static int	previousTimes[FPS_FRAMES];
;776:	static int	index;
;777:	int		i, total;
;778:	int		fps;
;779:	static	int	previous;
;780:	int		t, frameTime;
;781:
;782:	// don't use serverTime, because that will be drifting to
;783:	// correct for internet lag changes, timescales, timedemos, etc
;784:	t = trap_Milliseconds();
ADDRLP4 28
ADDRGP4 trap_Milliseconds
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 28
INDIRI4
ASGNI4
line 785
;785:	frameTime = t - previous;
ADDRLP4 12
ADDRLP4 8
INDIRI4
ADDRGP4 $381
INDIRI4
SUBI4
ASGNI4
line 786
;786:	previous = t;
ADDRGP4 $381
ADDRLP4 8
INDIRI4
ASGNI4
line 788
;787:
;788:	previousTimes[index % FPS_FRAMES] = frameTime;
ADDRGP4 $380
INDIRI4
CNSTI4 4
MODI4
CNSTI4 2
LSHI4
ADDRGP4 $379
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
line 789
;789:	index++;
ADDRLP4 32
ADDRGP4 $380
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 790
;790:	if ( index > FPS_FRAMES ) {
ADDRGP4 $380
INDIRI4
CNSTI4 4
LEI4 $382
line 792
;791:		// average multiple frames together to smooth changes out a bit
;792:		total = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 793
;793:		for ( i = 0 ; i < FPS_FRAMES ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $384
line 794
;794:			total += previousTimes[i];
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $379
ADDP4
INDIRI4
ADDI4
ASGNI4
line 795
;795:		}
LABELV $385
line 793
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $384
line 796
;796:		if ( !total ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $388
line 797
;797:			total = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 798
;798:		}
LABELV $388
line 799
;799:		fps = 1000 * FPS_FRAMES / total;
ADDRLP4 24
CNSTI4 4000
ADDRLP4 4
INDIRI4
DIVI4
ASGNI4
line 801
;800:
;801:		s = va( "%ifps", fps );
ADDRGP4 $390
ARGP4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 36
INDIRP4
ASGNP4
line 802
;802:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 40
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 804
;803:
;804:		CG_DrawBigString( 635 - w, y + 2, s, 1.0F);
CNSTI4 635
ADDRLP4 20
INDIRI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CNSTF4 1073741824
ADDF4
CVFI4 4
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 805
;805:	}
LABELV $382
line 807
;806:
;807:	return y + BIGCHAR_HEIGHT + 4;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1082130432
ADDF4
RETF4
LABELV $378
endproc CG_DrawFPS 44 16
proc CG_DrawTimer 32 16
line 815
;808:}
;809:
;810:/*
;811:=================
;812:CG_DrawTimer
;813:=================
;814:*/
;815:static float CG_DrawTimer( float y ) {
line 821
;816:	char		*s;
;817:	int			w;
;818:	int			mins, seconds, tens;
;819:	int			msec;
;820:
;821:	msec = cg.time - cgs.levelStartTime;
ADDRLP4 20
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+34796
INDIRI4
SUBI4
ASGNI4
line 823
;822:
;823:	seconds = msec / 1000;
ADDRLP4 0
ADDRLP4 20
INDIRI4
CNSTI4 1000
DIVI4
ASGNI4
line 824
;824:	mins = seconds / 60;
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 60
DIVI4
ASGNI4
line 825
;825:	seconds -= mins * 60;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 60
ADDRLP4 8
INDIRI4
MULI4
SUBI4
ASGNI4
line 826
;826:	tens = seconds / 10;
ADDRLP4 12
ADDRLP4 0
INDIRI4
CNSTI4 10
DIVI4
ASGNI4
line 827
;827:	seconds -= tens * 10;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 10
ADDRLP4 12
INDIRI4
MULI4
SUBI4
ASGNI4
line 829
;828:
;829:	s = va( "%i:%i%i", mins, tens, seconds );
ADDRGP4 $394
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 24
INDIRP4
ASGNP4
line 830
;830:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 28
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 832
;831:
;832:	CG_DrawBigString( 635 - w, y + 2, s, 1.0F);
CNSTI4 635
ADDRLP4 16
INDIRI4
SUBI4
ARGI4
ADDRFP4 0
INDIRF4
CNSTF4 1073741824
ADDF4
CVFI4 4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 834
;833:
;834:	return y + BIGCHAR_HEIGHT + 4;
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
ADDF4
CNSTF4 1082130432
ADDF4
RETF4
LABELV $391
endproc CG_DrawTimer 32 16
proc CG_DrawTeamOverlay 148 36
line 844
;835:}
;836:
;837:
;838:/*
;839:=================
;840:CG_DrawTeamOverlay
;841:=================
;842:*/
;843:
;844:static float CG_DrawTeamOverlay( float y, qboolean right, qboolean upper ) {
line 856
;845:	int x, w, h, xx;
;846:	int i, j, len;
;847:	const char *p;
;848:	vec4_t		hcolor;
;849:	int pwidth, lwidth;
;850:	int plyrs;
;851:	char st[16];
;852:	clientInfo_t *ci;
;853:	gitem_t	*item;
;854:	int ret_y, count;
;855:
;856:	if ( !cg_drawTeamOverlay.integer ) {
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 0
NEI4 $396
line 857
;857:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $395
JUMPV
LABELV $396
line 860
;858:	}
;859:
;860:	if ( cg.snap->ps.persistant[PERS_TEAM] != TEAM_RED && cg.snap->ps.persistant[PERS_TEAM] != TEAM_BLUE ) {
ADDRLP4 92
CNSTI4 304
ASGNI4
ADDRGP4 cg+36
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRI4
CNSTI4 1
EQI4 $399
ADDRGP4 cg+36
INDIRP4
ADDRLP4 92
INDIRI4
ADDP4
INDIRI4
CNSTI4 2
EQI4 $399
line 861
;861:		return y; // Not on any team
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $395
JUMPV
LABELV $399
line 864
;862:	}
;863:
;864:	plyrs = 0;
ADDRLP4 76
CNSTI4 0
ASGNI4
line 867
;865:
;866:	// max player name width
;867:	pwidth = 0;
ADDRLP4 56
CNSTI4 0
ASGNI4
line 868
;868:	count = (numSortedTeamPlayers > 8) ? 8 : numSortedTeamPlayers;
ADDRGP4 numSortedTeamPlayers
INDIRI4
CNSTI4 8
LEI4 $404
ADDRLP4 96
CNSTI4 8
ASGNI4
ADDRGP4 $405
JUMPV
LABELV $404
ADDRLP4 96
ADDRGP4 numSortedTeamPlayers
INDIRI4
ASGNI4
LABELV $405
ADDRLP4 48
ADDRLP4 96
INDIRI4
ASGNI4
line 869
;869:	for (i = 0; i < count; i++) {
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $409
JUMPV
LABELV $406
line 870
;870:		ci = cgs.clientinfo + sortedTeamPlayers[i];
ADDRLP4 4
CNSTI4 1708
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 sortedTeamPlayers
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 871
;871:		if ( ci->infoValid && ci->team == cg.snap->ps.persistant[PERS_TEAM]) {
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $411
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
NEI4 $411
line 872
;872:			plyrs++;
ADDRLP4 76
ADDRLP4 76
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 873
;873:			len = CG_DrawStrlen(ci->name);
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRLP4 104
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 104
INDIRI4
ASGNI4
line 874
;874:			if (len > pwidth)
ADDRLP4 40
INDIRI4
ADDRLP4 56
INDIRI4
LEI4 $414
line 875
;875:				pwidth = len;
ADDRLP4 56
ADDRLP4 40
INDIRI4
ASGNI4
LABELV $414
line 876
;876:		}
LABELV $411
line 877
;877:	}
LABELV $407
line 869
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $409
ADDRLP4 8
INDIRI4
ADDRLP4 48
INDIRI4
LTI4 $406
line 879
;878:
;879:	if (!plyrs)
ADDRLP4 76
INDIRI4
CNSTI4 0
NEI4 $416
line 880
;880:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $395
JUMPV
LABELV $416
line 882
;881:
;882:	if (pwidth > TEAM_OVERLAY_MAXNAME_WIDTH)
ADDRLP4 56
INDIRI4
CNSTI4 12
LEI4 $418
line 883
;883:		pwidth = TEAM_OVERLAY_MAXNAME_WIDTH;
ADDRLP4 56
CNSTI4 12
ASGNI4
LABELV $418
line 886
;884:
;885:	// max location name width
;886:	lwidth = 0;
ADDRLP4 44
CNSTI4 0
ASGNI4
line 887
;887:	for (i = 1; i < MAX_LOCATIONS; i++) {
ADDRLP4 8
CNSTI4 1
ASGNI4
LABELV $420
line 888
;888:		p = CG_ConfigString(CS_LOCATIONS + i);
ADDRLP4 8
INDIRI4
CNSTI4 608
ADDI4
ARGI4
ADDRLP4 100
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 100
INDIRP4
ASGNP4
line 889
;889:		if (p && *p) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $424
ADDRLP4 20
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $424
line 890
;890:			len = CG_DrawStrlen(p);
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 108
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 108
INDIRI4
ASGNI4
line 891
;891:			if (len > lwidth)
ADDRLP4 40
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $426
line 892
;892:				lwidth = len;
ADDRLP4 44
ADDRLP4 40
INDIRI4
ASGNI4
LABELV $426
line 893
;893:		}
LABELV $424
line 894
;894:	}
LABELV $421
line 887
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 64
LTI4 $420
line 896
;895:
;896:	if (lwidth > TEAM_OVERLAY_MAXLOCATION_WIDTH)
ADDRLP4 44
INDIRI4
CNSTI4 16
LEI4 $428
line 897
;897:		lwidth = TEAM_OVERLAY_MAXLOCATION_WIDTH;
ADDRLP4 44
CNSTI4 16
ASGNI4
LABELV $428
line 899
;898:
;899:	w = (pwidth + lwidth + 4 + 7) * TINYCHAR_WIDTH;
ADDRLP4 80
ADDRLP4 56
INDIRI4
ADDRLP4 44
INDIRI4
ADDI4
CNSTI4 3
LSHI4
CNSTI4 32
ADDI4
CNSTI4 56
ADDI4
ASGNI4
line 901
;900:
;901:	if ( right )
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $430
line 902
;902:		x = 640 - w;
ADDRLP4 52
CNSTI4 640
ADDRLP4 80
INDIRI4
SUBI4
ASGNI4
ADDRGP4 $431
JUMPV
LABELV $430
line 904
;903:	else
;904:		x = 0;
ADDRLP4 52
CNSTI4 0
ASGNI4
LABELV $431
line 906
;905:
;906:	h = plyrs * TINYCHAR_HEIGHT;
ADDRLP4 84
ADDRLP4 76
INDIRI4
CNSTI4 3
LSHI4
ASGNI4
line 908
;907:
;908:	if ( upper ) {
ADDRFP4 8
INDIRI4
CNSTI4 0
EQI4 $432
line 909
;909:		ret_y = y + h;
ADDRLP4 88
ADDRFP4 0
INDIRF4
ADDRLP4 84
INDIRI4
CVIF4 4
ADDF4
CVFI4 4
ASGNI4
line 910
;910:	} else {
ADDRGP4 $433
JUMPV
LABELV $432
line 911
;911:		y -= h;
ADDRFP4 0
ADDRFP4 0
INDIRF4
ADDRLP4 84
INDIRI4
CVIF4 4
SUBF4
ASGNF4
line 912
;912:		ret_y = y;
ADDRLP4 88
ADDRFP4 0
INDIRF4
CVFI4 4
ASGNI4
line 913
;913:	}
LABELV $433
line 915
;914:
;915:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_RED ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 1
NEI4 $434
line 916
;916:		hcolor[0] = 1.0f;
ADDRLP4 24
CNSTF4 1065353216
ASGNF4
line 917
;917:		hcolor[1] = 0.0f;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 918
;918:		hcolor[2] = 0.0f;
ADDRLP4 24+8
CNSTF4 0
ASGNF4
line 919
;919:		hcolor[3] = 0.33f;
ADDRLP4 24+12
CNSTF4 1051260355
ASGNF4
line 920
;920:	} else { // if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE )
ADDRGP4 $435
JUMPV
LABELV $434
line 921
;921:		hcolor[0] = 0.0f;
ADDRLP4 24
CNSTF4 0
ASGNF4
line 922
;922:		hcolor[1] = 0.0f;
ADDRLP4 24+4
CNSTF4 0
ASGNF4
line 923
;923:		hcolor[2] = 1.0f;
ADDRLP4 24+8
CNSTF4 1065353216
ASGNF4
line 924
;924:		hcolor[3] = 0.33f;
ADDRLP4 24+12
CNSTF4 1051260355
ASGNF4
line 925
;925:	}
LABELV $435
line 926
;926:	trap_R_SetColor( hcolor );
ADDRLP4 24
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 927
;927:	CG_DrawPic( x, y, w, h, cgs.media.teamStatusBar );
ADDRLP4 52
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 80
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 cgs+152340+128
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 928
;928:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 930
;929:
;930:	for (i = 0; i < count; i++) {
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $448
JUMPV
LABELV $445
line 931
;931:		ci = cgs.clientinfo + sortedTeamPlayers[i];
ADDRLP4 4
CNSTI4 1708
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 sortedTeamPlayers
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 932
;932:		if ( ci->infoValid && ci->team == cg.snap->ps.persistant[PERS_TEAM]) {
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $450
ADDRLP4 4
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
NEI4 $450
line 934
;933:
;934:			hcolor[0] = hcolor[1] = hcolor[2] = hcolor[3] = 1.0;
ADDRLP4 104
CNSTF4 1065353216
ASGNF4
ADDRLP4 24+12
ADDRLP4 104
INDIRF4
ASGNF4
ADDRLP4 24+8
ADDRLP4 104
INDIRF4
ASGNF4
ADDRLP4 24+4
ADDRLP4 104
INDIRF4
ASGNF4
ADDRLP4 24
ADDRLP4 104
INDIRF4
ASGNF4
line 936
;935:
;936:			xx = x + TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 52
INDIRI4
CNSTI4 8
ADDI4
ASGNI4
line 938
;937:
;938:			CG_DrawStringExt( xx, y,
ADDRLP4 12
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 108
CNSTI4 0
ASGNI4
ADDRLP4 108
INDIRI4
ARGI4
ADDRLP4 108
INDIRI4
ARGI4
ADDRLP4 112
CNSTI4 8
ASGNI4
ADDRLP4 112
INDIRI4
ARGI4
ADDRLP4 112
INDIRI4
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 942
;939:				ci->name, hcolor, qfalse, qfalse,
;940:				TINYCHAR_WIDTH, TINYCHAR_HEIGHT, TEAM_OVERLAY_MAXNAME_WIDTH);
;941:
;942:			if (lwidth) {
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $456
line 943
;943:				p = CG_ConfigString(CS_LOCATIONS + ci->location);
ADDRLP4 4
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
CNSTI4 608
ADDI4
ARGI4
ADDRLP4 116
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 116
INDIRP4
ASGNP4
line 944
;944:				if (!p || !*p)
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $460
ADDRLP4 20
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $458
LABELV $460
line 945
;945:					p = "unknown";
ADDRLP4 20
ADDRGP4 $461
ASGNP4
LABELV $458
line 946
;946:				len = CG_DrawStrlen(p);
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 124
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 124
INDIRI4
ASGNI4
line 947
;947:				if (len > lwidth)
ADDRLP4 40
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $462
line 948
;948:					len = lwidth;
ADDRLP4 40
ADDRLP4 44
INDIRI4
ASGNI4
LABELV $462
line 952
;949:
;950://				xx = x + TINYCHAR_WIDTH * 2 + TINYCHAR_WIDTH * pwidth + 
;951://					((lwidth/2 - len/2) * TINYCHAR_WIDTH);
;952:				xx = x + TINYCHAR_WIDTH * 2 + TINYCHAR_WIDTH * pwidth;
ADDRLP4 12
ADDRLP4 52
INDIRI4
CNSTI4 16
ADDI4
ADDRLP4 56
INDIRI4
CNSTI4 3
LSHI4
ADDI4
ASGNI4
line 953
;953:				CG_DrawStringExt( xx, y,
ADDRLP4 12
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 128
CNSTI4 0
ASGNI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 132
CNSTI4 8
ASGNI4
ADDRLP4 132
INDIRI4
ARGI4
ADDRLP4 132
INDIRI4
ARGI4
CNSTI4 16
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 956
;954:					p, hcolor, qfalse, qfalse, TINYCHAR_WIDTH, TINYCHAR_HEIGHT,
;955:					TEAM_OVERLAY_MAXLOCATION_WIDTH);
;956:			}
LABELV $456
line 958
;957:
;958:			CG_GetColorForHealth( ci->health, ci->armor, hcolor );
ADDRLP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
ARGP4
ADDRGP4 CG_GetColorForHealth
CALLV
pop
line 960
;959:
;960:			Com_sprintf (st, sizeof(st), "%3i %3i", ci->health,	ci->armor);
ADDRLP4 60
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 $464
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 962
;961:
;962:			xx = x + TINYCHAR_WIDTH * 3 + 
ADDRLP4 124
CNSTI4 3
ASGNI4
ADDRLP4 12
ADDRLP4 52
INDIRI4
CNSTI4 24
ADDI4
ADDRLP4 56
INDIRI4
ADDRLP4 124
INDIRI4
LSHI4
ADDI4
ADDRLP4 44
INDIRI4
ADDRLP4 124
INDIRI4
LSHI4
ADDI4
ASGNI4
line 965
;963:				TINYCHAR_WIDTH * pwidth + TINYCHAR_WIDTH * lwidth;
;964:
;965:			CG_DrawStringExt( xx, y,
ADDRLP4 12
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 60
ARGP4
ADDRLP4 24
ARGP4
ADDRLP4 128
CNSTI4 0
ASGNI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRLP4 132
CNSTI4 8
ASGNI4
ADDRLP4 132
INDIRI4
ARGI4
ADDRLP4 132
INDIRI4
ARGI4
ADDRLP4 128
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 970
;966:				st, hcolor, qfalse, qfalse,
;967:				TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 0 );
;968:
;969:			// draw weapon icon
;970:			xx += TINYCHAR_WIDTH * 3;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 24
ADDI4
ASGNI4
line 972
;971:
;972:			if ( cg_weapons[ci->curWeapon].weaponIcon ) {
CNSTI4 136
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons+68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $465
line 973
;973:				CG_DrawPic( xx, y, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 136
CNSTF4 1090519040
ASGNF4
ADDRLP4 136
INDIRF4
ARGF4
ADDRLP4 136
INDIRF4
ARGF4
CNSTI4 136
ADDRLP4 4
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_weapons+68
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 975
;974:					cg_weapons[ci->curWeapon].weaponIcon );
;975:			} else {
ADDRGP4 $466
JUMPV
LABELV $465
line 976
;976:				CG_DrawPic( xx, y, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 136
CNSTF4 1090519040
ASGNF4
ADDRLP4 136
INDIRF4
ARGF4
ADDRLP4 136
INDIRF4
ARGF4
ADDRGP4 cgs+152340+132
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 978
;977:					cgs.media.deferShader );
;978:			}
LABELV $466
line 981
;979:
;980:			// Draw powerup icons
;981:			if (right) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $471
line 982
;982:				xx = x;
ADDRLP4 12
ADDRLP4 52
INDIRI4
ASGNI4
line 983
;983:			} else {
ADDRGP4 $472
JUMPV
LABELV $471
line 984
;984:				xx = x + w - TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 52
INDIRI4
ADDRLP4 80
INDIRI4
ADDI4
CNSTI4 8
SUBI4
ASGNI4
line 985
;985:			}
LABELV $472
line 986
;986:			for (j = 0; j <= PW_NUM_POWERUPS; j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $473
line 987
;987:				if (ci->powerups & (1 << j)) {
ADDRLP4 4
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
CNSTI4 1
ADDRLP4 0
INDIRI4
LSHI4
BANDI4
CNSTI4 0
EQI4 $477
line 989
;988:
;989:					item = BG_FindItemForPowerup( j );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 136
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 136
INDIRP4
ASGNP4
line 991
;990:
;991:					if (item) {
ADDRLP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $479
line 992
;992:						CG_DrawPic( xx, y, TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 
ADDRLP4 16
INDIRP4
CNSTI4 24
ADDP4
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
ARGF4
ADDRLP4 144
CNSTF4 1090519040
ASGNF4
ADDRLP4 144
INDIRF4
ARGF4
ADDRLP4 144
INDIRF4
ARGF4
ADDRLP4 140
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 994
;993:						trap_R_RegisterShader( item->icon ) );
;994:						if (right) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $481
line 995
;995:							xx -= TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 8
SUBI4
ASGNI4
line 996
;996:						} else {
ADDRGP4 $482
JUMPV
LABELV $481
line 997
;997:							xx += TINYCHAR_WIDTH;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 8
ADDI4
ASGNI4
line 998
;998:						}
LABELV $482
line 999
;999:					}
LABELV $479
line 1000
;1000:				}
LABELV $477
line 1001
;1001:			}
LABELV $474
line 986
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 15
LEI4 $473
line 1003
;1002:
;1003:			y += TINYCHAR_HEIGHT;
ADDRFP4 0
ADDRFP4 0
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 1004
;1004:		}
LABELV $450
line 1005
;1005:	}
LABELV $446
line 930
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $448
ADDRLP4 8
INDIRI4
ADDRLP4 48
INDIRI4
LTI4 $445
line 1007
;1006:
;1007:	return ret_y;
ADDRLP4 88
INDIRI4
CVIF4 4
RETF4
LABELV $395
endproc CG_DrawTeamOverlay 148 36
proc CG_DrawUpperRight 12 12
line 1018
;1008://#endif
;1009:}
;1010:
;1011:
;1012:/*
;1013:=====================
;1014:CG_DrawUpperRight
;1015:
;1016:=====================
;1017:*/
;1018:static void CG_DrawUpperRight( void ) {
line 1021
;1019:	float	y;
;1020:
;1021:	y = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1023
;1022:
;1023:	if ( cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 1 ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $484
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 1
NEI4 $484
line 1024
;1024:		y = CG_DrawTeamOverlay( y, qtrue, qtrue );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 CG_DrawTeamOverlay
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 8
INDIRF4
ASGNF4
line 1025
;1025:	} 
LABELV $484
line 1026
;1026:	if ( cg_drawSnapshot.integer ) {
ADDRGP4 cg_drawSnapshot+12
INDIRI4
CNSTI4 0
EQI4 $488
line 1027
;1027:		y = CG_DrawSnapshot( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawSnapshot
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1028
;1028:	}
LABELV $488
line 1029
;1029:	if ( cg_drawFPS.integer ) {
ADDRGP4 cg_drawFPS+12
INDIRI4
CNSTI4 0
EQI4 $491
line 1030
;1030:		y = CG_DrawFPS( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawFPS
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1031
;1031:	}
LABELV $491
line 1032
;1032:	if ( cg_drawTimer.integer ) {
ADDRGP4 cg_drawTimer+12
INDIRI4
CNSTI4 0
EQI4 $494
line 1033
;1033:		y = CG_DrawTimer( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawTimer
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1034
;1034:	}
LABELV $494
line 1035
;1035:	if ( cg_drawAttacker.integer ) {
ADDRGP4 cg_drawAttacker+12
INDIRI4
CNSTI4 0
EQI4 $497
line 1036
;1036:		y = CG_DrawAttacker( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawAttacker
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1037
;1037:	}
LABELV $497
line 1039
;1038:
;1039:}
LABELV $483
endproc CG_DrawUpperRight 12 12
proc CG_DrawScores 76 20
line 1057
;1040:
;1041:/*
;1042:===========================================================================================
;1043:
;1044:  LOWER RIGHT CORNER
;1045:
;1046:===========================================================================================
;1047:*/
;1048:
;1049:/*
;1050:=================
;1051:CG_DrawScores
;1052:
;1053:Draw the small two score display
;1054:=================
;1055:*/
;1056:#ifndef MISSIONPACK
;1057:static float CG_DrawScores( float y ) {
line 1066
;1058:	const char	*s;
;1059:	int			s1, s2, score;
;1060:	int			x, w;
;1061:	int			v;
;1062:	vec4_t		color;
;1063:	float		y1;
;1064:	gitem_t		*item;
;1065:
;1066:	s1 = cgs.scores1;
ADDRLP4 28
ADDRGP4 cgs+34800
INDIRI4
ASGNI4
line 1067
;1067:	s2 = cgs.scores2;
ADDRLP4 32
ADDRGP4 cgs+34804
INDIRI4
ASGNI4
line 1069
;1068:
;1069:	y -=  BIGCHAR_HEIGHT + 8;
ADDRFP4 0
ADDRFP4 0
INDIRF4
CNSTF4 1103101952
SUBF4
ASGNF4
line 1071
;1070:
;1071:	y1 = y;
ADDRLP4 36
ADDRFP4 0
INDIRF4
ASGNF4
line 1074
;1072:
;1073:	// draw from the right side to left
;1074:	if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $503
line 1075
;1075:		x = 640;
ADDRLP4 16
CNSTI4 640
ASGNI4
line 1076
;1076:		color[0] = 0.0f;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1077
;1077:		color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1078
;1078:		color[2] = 1.0f;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 1079
;1079:		color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1080
;1080:		s = va( "%2i", s2 );
ADDRGP4 $509
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRLP4 52
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 52
INDIRP4
ASGNP4
line 1081
;1081:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 56
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 56
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1082
;1082:		x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1083
;1083:		CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1084
;1084:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 2
NEI4 $510
line 1085
;1085:			CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1086
;1086:		}
LABELV $510
line 1087
;1087:		CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1089
;1088:
;1089:		if ( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $515
line 1091
;1090:			// Display flag status
;1091:			item = BG_FindItemForPowerup( PW_BLUEFLAG );
CNSTI4 8
ARGI4
ADDRLP4 60
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 48
ADDRLP4 60
INDIRP4
ASGNP4
line 1093
;1092:
;1093:			if (item) {
ADDRLP4 48
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $518
line 1094
;1094:				y1 = y - BIGCHAR_HEIGHT - 8;
ADDRLP4 36
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
SUBF4
CNSTF4 1090519040
SUBF4
ASGNF4
line 1095
;1095:				if( cgs.blueflag >= 0 && cgs.blueflag <= 2 ) {
ADDRGP4 cgs+34812
INDIRI4
CNSTI4 0
LTI4 $520
ADDRGP4 cgs+34812
INDIRI4
CNSTI4 2
GTI4 $520
line 1096
;1096:					CG_DrawPic( x, y1-4, w, BIGCHAR_HEIGHT+8, cgs.media.blueFlagShader[cgs.blueflag] );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 36
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+34812
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+60
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1097
;1097:				}
LABELV $520
line 1098
;1098:			}
LABELV $518
line 1099
;1099:		}
LABELV $515
line 1100
;1100:		color[0] = 1.0f;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 1101
;1101:		color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1102
;1102:		color[2] = 0.0f;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1103
;1103:		color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1104
;1104:		s = va( "%2i", s1 );
ADDRGP4 $509
ARGP4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 60
INDIRP4
ASGNP4
line 1105
;1105:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 64
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1106
;1106:		x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1107
;1107:		CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1108
;1108:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_RED ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 1
NEI4 $530
line 1109
;1109:			CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1110
;1110:		}
LABELV $530
line 1111
;1111:		CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1113
;1112:
;1113:		if ( cgs.gametype == GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $535
line 1115
;1114:			// Display flag status
;1115:			item = BG_FindItemForPowerup( PW_REDFLAG );
CNSTI4 7
ARGI4
ADDRLP4 68
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 48
ADDRLP4 68
INDIRP4
ASGNP4
line 1117
;1116:
;1117:			if (item) {
ADDRLP4 48
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $538
line 1118
;1118:				y1 = y - BIGCHAR_HEIGHT - 8;
ADDRLP4 36
ADDRFP4 0
INDIRF4
CNSTF4 1098907648
SUBF4
CNSTF4 1090519040
SUBF4
ASGNF4
line 1119
;1119:				if( cgs.redflag >= 0 && cgs.redflag <= 2 ) {
ADDRGP4 cgs+34808
INDIRI4
CNSTI4 0
LTI4 $540
ADDRGP4 cgs+34808
INDIRI4
CNSTI4 2
GTI4 $540
line 1120
;1120:					CG_DrawPic( x, y1-4, w, BIGCHAR_HEIGHT+8, cgs.media.redFlagShader[cgs.redflag] );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 36
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+34808
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+48
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1121
;1121:				}
LABELV $540
line 1122
;1122:			}
LABELV $538
line 1123
;1123:		}
LABELV $535
line 1138
;1124:
;1125:#ifdef MISSIONPACK
;1126:		if ( cgs.gametype == GT_1FCTF ) {
;1127:			// Display flag status
;1128:			item = BG_FindItemForPowerup( PW_NEUTRALFLAG );
;1129:
;1130:			if (item) {
;1131:				y1 = y - BIGCHAR_HEIGHT - 8;
;1132:				if( cgs.flagStatus >= 0 && cgs.flagStatus <= 3 ) {
;1133:					CG_DrawPic( x, y1-4, w, BIGCHAR_HEIGHT+8, cgs.media.flagShader[cgs.flagStatus] );
;1134:				}
;1135:			}
;1136:		}
;1137:#endif
;1138:		if ( cgs.gametype >= GT_CTF ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
LTI4 $547
line 1139
;1139:			v = cgs.capturelimit;
ADDRLP4 44
ADDRGP4 cgs+31472
INDIRI4
ASGNI4
line 1140
;1140:		} else {
ADDRGP4 $548
JUMPV
LABELV $547
line 1141
;1141:			v = cgs.fraglimit;
ADDRLP4 44
ADDRGP4 cgs+31468
INDIRI4
ASGNI4
line 1142
;1142:		}
LABELV $548
line 1143
;1143:		if ( v ) {
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $504
line 1144
;1144:			s = va( "%2i", v );
ADDRGP4 $509
ARGP4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 68
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 68
INDIRP4
ASGNP4
line 1145
;1145:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 72
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1146
;1146:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1147
;1147:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1148
;1148:		}
line 1150
;1149:
;1150:	} else {
ADDRGP4 $504
JUMPV
LABELV $503
line 1153
;1151:		qboolean	spectator;
;1152:
;1153:		x = 640;
ADDRLP4 16
CNSTI4 640
ASGNI4
line 1154
;1154:		score = cg.snap->ps.persistant[PERS_SCORE];
ADDRLP4 40
ADDRGP4 cg+36
INDIRP4
CNSTI4 292
ADDP4
INDIRI4
ASGNI4
line 1155
;1155:		spectator = ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR );
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $557
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $558
JUMPV
LABELV $557
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $558
ADDRLP4 52
ADDRLP4 56
INDIRI4
ASGNI4
line 1158
;1156:
;1157:		// always show your score in the second box if not in first place
;1158:		if ( s1 != score ) {
ADDRLP4 28
INDIRI4
ADDRLP4 40
INDIRI4
EQI4 $559
line 1159
;1159:			s2 = score;
ADDRLP4 32
ADDRLP4 40
INDIRI4
ASGNI4
line 1160
;1160:		}
LABELV $559
line 1161
;1161:		if ( s2 != SCORE_NOT_PRESENT ) {
ADDRLP4 32
INDIRI4
CNSTI4 -9999
EQI4 $561
line 1162
;1162:			s = va( "%2i", s2 );
ADDRGP4 $509
ARGP4
ADDRLP4 32
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 60
INDIRP4
ASGNP4
line 1163
;1163:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 64
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1164
;1164:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1165
;1165:			if ( !spectator && score == s2 && score != s1 ) {
ADDRLP4 52
INDIRI4
CNSTI4 0
NEI4 $563
ADDRLP4 68
ADDRLP4 40
INDIRI4
ASGNI4
ADDRLP4 68
INDIRI4
ADDRLP4 32
INDIRI4
NEI4 $563
ADDRLP4 68
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $563
line 1166
;1166:				color[0] = 1.0f;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 1167
;1167:				color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1168
;1168:				color[2] = 0.0f;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1169
;1169:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1170
;1170:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1171
;1171:				CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1172
;1172:			} else {
ADDRGP4 $564
JUMPV
LABELV $563
line 1173
;1173:				color[0] = 0.5f;
ADDRLP4 0
CNSTF4 1056964608
ASGNF4
line 1174
;1174:				color[1] = 0.5f;
ADDRLP4 0+4
CNSTF4 1056964608
ASGNF4
line 1175
;1175:				color[2] = 0.5f;
ADDRLP4 0+8
CNSTF4 1056964608
ASGNF4
line 1176
;1176:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1177
;1177:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1178
;1178:			}	
LABELV $564
line 1179
;1179:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1180
;1180:		}
LABELV $561
line 1183
;1181:
;1182:		// first place
;1183:		if ( s1 != SCORE_NOT_PRESENT ) {
ADDRLP4 28
INDIRI4
CNSTI4 -9999
EQI4 $573
line 1184
;1184:			s = va( "%2i", s1 );
ADDRGP4 $509
ARGP4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 60
INDIRP4
ASGNP4
line 1185
;1185:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 64
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1186
;1186:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1187
;1187:			if ( !spectator && score == s1 ) {
ADDRLP4 52
INDIRI4
CNSTI4 0
NEI4 $575
ADDRLP4 40
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $575
line 1188
;1188:				color[0] = 0.0f;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 1189
;1189:				color[1] = 0.0f;
ADDRLP4 0+4
CNSTF4 0
ASGNF4
line 1190
;1190:				color[2] = 1.0f;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 1191
;1191:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1192
;1192:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1193
;1193:				CG_DrawPic( x, y-4, w, BIGCHAR_HEIGHT+8, cgs.media.selectShader );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRGP4 cgs+152340+212
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1194
;1194:			} else {
ADDRGP4 $576
JUMPV
LABELV $575
line 1195
;1195:				color[0] = 0.5f;
ADDRLP4 0
CNSTF4 1056964608
ASGNF4
line 1196
;1196:				color[1] = 0.5f;
ADDRLP4 0+4
CNSTF4 1056964608
ASGNF4
line 1197
;1197:				color[2] = 0.5f;
ADDRLP4 0+8
CNSTF4 1056964608
ASGNF4
line 1198
;1198:				color[3] = 0.33f;
ADDRLP4 0+12
CNSTF4 1051260355
ASGNF4
line 1199
;1199:				CG_FillRect( x, y-4,  w, BIGCHAR_HEIGHT+8, color );
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1082130432
SUBF4
ARGF4
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1103101952
ARGF4
ADDRLP4 0
ARGP4
ADDRGP4 CG_FillRect
CALLV
pop
line 1200
;1200:			}	
LABELV $576
line 1201
;1201:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1202
;1202:		}
LABELV $573
line 1204
;1203:
;1204:		if ( cgs.fraglimit ) {
ADDRGP4 cgs+31468
INDIRI4
CNSTI4 0
EQI4 $585
line 1205
;1205:			s = va( "%2i", cgs.fraglimit );
ADDRGP4 $509
ARGP4
ADDRGP4 cgs+31468
INDIRI4
ARGI4
ADDRLP4 60
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 24
ADDRLP4 60
INDIRP4
ASGNP4
line 1206
;1206:			w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH + 8;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 64
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 64
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 8
ADDI4
ASGNI4
line 1207
;1207:			x -= w;
ADDRLP4 16
ADDRLP4 16
INDIRI4
ADDRLP4 20
INDIRI4
SUBI4
ASGNI4
line 1208
;1208:			CG_DrawBigString( x + 4, y, s, 1.0F);
ADDRLP4 16
INDIRI4
CNSTI4 4
ADDI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1209
;1209:		}
LABELV $585
line 1211
;1210:
;1211:	}
LABELV $504
line 1213
;1212:
;1213:	return y1 - 8;
ADDRLP4 36
INDIRF4
CNSTF4 1090519040
SUBF4
RETF4
LABELV $500
endproc CG_DrawScores 76 20
data
align 4
LABELV $590
byte 4 1045220557
byte 4 1065353216
byte 4 1045220557
byte 4 1065353216
byte 4 1065353216
byte 4 1045220557
byte 4 1045220557
byte 4 1065353216
code
proc CG_DrawPowerups 208 20
line 1223
;1214:}
;1215:#endif // MISSIONPACK
;1216:
;1217:/*
;1218:================
;1219:CG_DrawPowerups
;1220:================
;1221:*/
;1222:#ifndef MISSIONPACK
;1223:static float CG_DrawPowerups( float y ) {
line 1240
;1224:	int		sorted[MAX_POWERUPS];
;1225:	int		sortedTime[MAX_POWERUPS];
;1226:	int		i, j, k;
;1227:	int		active;
;1228:	playerState_t	*ps;
;1229:	int		t;
;1230:	gitem_t	*item;
;1231:	int		x;
;1232:	int		color;
;1233:	float	size;
;1234:	float	f;
;1235:	static float colors[2][4] = { 
;1236:    { 0.2f, 1.0f, 0.2f, 1.0f } , 
;1237:    { 1.0f, 0.2f, 0.2f, 1.0f } 
;1238:  };
;1239:
;1240:	ps = &cg.snap->ps;
ADDRLP4 148
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
ASGNP4
line 1242
;1241:
;1242:	if ( ps->stats[STAT_HEALTH] <= 0 ) {
ADDRLP4 148
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $592
line 1243
;1243:		return y;
ADDRFP4 0
INDIRF4
RETF4
ADDRGP4 $589
JUMPV
LABELV $592
line 1247
;1244:	}
;1245:
;1246:	// sort the list by time remaining
;1247:	active = 0;
ADDRLP4 136
CNSTI4 0
ASGNI4
line 1248
;1248:	for ( i = 0 ; i < MAX_POWERUPS ; i++ ) {
ADDRLP4 144
CNSTI4 0
ASGNI4
LABELV $594
line 1249
;1249:		if ( !ps->powerups[ i ] ) {
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 148
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $598
line 1250
;1250:			continue;
ADDRGP4 $595
JUMPV
LABELV $598
line 1252
;1251:		}
;1252:		t = ps->powerups[ i ] - cg.time;
ADDRLP4 140
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 148
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
ASGNI4
line 1255
;1253:		// ZOID--don't draw if the power up has unlimited time (999 seconds)
;1254:		// This is true of the CTF flags
;1255:		if ( t < 0 || t > 999000) {
ADDRLP4 140
INDIRI4
CNSTI4 0
LTI4 $603
ADDRLP4 140
INDIRI4
CNSTI4 999000
LEI4 $601
LABELV $603
line 1256
;1256:			continue;
ADDRGP4 $595
JUMPV
LABELV $601
line 1260
;1257:		}
;1258:
;1259:		// insert into the list
;1260:		for ( j = 0 ; j < active ; j++ ) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $607
JUMPV
LABELV $604
line 1261
;1261:			if ( sortedTime[j] >= t ) {
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
ADDRLP4 140
INDIRI4
LTI4 $608
line 1262
;1262:				for ( k = active - 1 ; k >= j ; k-- ) {
ADDRLP4 0
ADDRLP4 136
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $613
JUMPV
LABELV $610
line 1263
;1263:					sorted[k+1] = sorted[k];
ADDRLP4 176
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 176
INDIRI4
ADDRLP4 68+4
ADDP4
ADDRLP4 176
INDIRI4
ADDRLP4 68
ADDP4
INDIRI4
ASGNI4
line 1264
;1264:					sortedTime[k+1] = sortedTime[k];
ADDRLP4 180
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 180
INDIRI4
ADDRLP4 4+4
ADDP4
ADDRLP4 180
INDIRI4
ADDRLP4 4
ADDP4
INDIRI4
ASGNI4
line 1265
;1265:				}
LABELV $611
line 1262
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $613
ADDRLP4 0
INDIRI4
ADDRLP4 132
INDIRI4
GEI4 $610
line 1266
;1266:				break;
ADDRGP4 $606
JUMPV
LABELV $608
line 1268
;1267:			}
;1268:		}
LABELV $605
line 1260
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $607
ADDRLP4 132
INDIRI4
ADDRLP4 136
INDIRI4
LTI4 $604
LABELV $606
line 1269
;1269:		sorted[j] = i;
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 68
ADDP4
ADDRLP4 144
INDIRI4
ASGNI4
line 1270
;1270:		sortedTime[j] = t;
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
ADDRLP4 140
INDIRI4
ASGNI4
line 1271
;1271:		active++;
ADDRLP4 136
ADDRLP4 136
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1272
;1272:	}
LABELV $595
line 1248
ADDRLP4 144
ADDRLP4 144
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 16
LTI4 $594
line 1275
;1273:
;1274:	// draw the icons and timers
;1275:	x = 640 - ICON_SIZE - CHAR_WIDTH * 2;
ADDRLP4 168
CNSTI4 528
ASGNI4
line 1276
;1276:	for ( i = 0 ; i < active ; i++ ) {
ADDRLP4 144
CNSTI4 0
ASGNI4
ADDRGP4 $619
JUMPV
LABELV $616
line 1277
;1277:		item = BG_FindItemForPowerup( sorted[i] );
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 68
ADDP4
INDIRI4
ARGI4
ADDRLP4 172
ADDRGP4 BG_FindItemForPowerup
CALLP4
ASGNP4
ADDRLP4 152
ADDRLP4 172
INDIRP4
ASGNP4
line 1279
;1278:
;1279:    if (item) {
ADDRLP4 152
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $620
line 1281
;1280:
;1281:		  color = 1;
ADDRLP4 164
CNSTI4 1
ASGNI4
line 1283
;1282:
;1283:		  y -= ICON_SIZE;
ADDRFP4 0
ADDRFP4 0
INDIRF4
CNSTF4 1111490560
SUBF4
ASGNF4
line 1285
;1284:
;1285:		  trap_R_SetColor( colors[color] );
ADDRLP4 164
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 $590
ADDP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1286
;1286:		  CG_DrawField( x, y, 2, sortedTime[ i ] / 1000 );
ADDRLP4 168
INDIRI4
ARGI4
ADDRFP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 176
CNSTI4 2
ASGNI4
ADDRLP4 176
INDIRI4
ARGI4
ADDRLP4 144
INDIRI4
ADDRLP4 176
INDIRI4
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
CNSTI4 1000
DIVI4
ARGI4
ADDRGP4 CG_DrawField
CALLV
pop
line 1288
;1287:
;1288:		  t = ps->powerups[ sorted[i] ];
ADDRLP4 180
CNSTI4 2
ASGNI4
ADDRLP4 140
ADDRLP4 144
INDIRI4
ADDRLP4 180
INDIRI4
LSHI4
ADDRLP4 68
ADDP4
INDIRI4
ADDRLP4 180
INDIRI4
LSHI4
ADDRLP4 148
INDIRP4
CNSTI4 312
ADDP4
ADDP4
INDIRI4
ASGNI4
line 1289
;1289:		  if ( t - cg.time >= POWERUP_BLINKS * POWERUP_BLINK_TIME ) {
ADDRLP4 140
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CNSTI4 5000
LTI4 $622
line 1290
;1290:			  trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1291
;1291:		  } else {
ADDRGP4 $623
JUMPV
LABELV $622
line 1294
;1292:			  vec4_t	modulate;
;1293:
;1294:			  f = (float)( t - cg.time ) / POWERUP_BLINK_TIME;
ADDRLP4 160
ADDRLP4 140
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CVIF4 4
CNSTF4 1148846080
DIVF4
ASGNF4
line 1295
;1295:			  f -= (int)f;
ADDRLP4 160
ADDRLP4 160
INDIRF4
ADDRLP4 160
INDIRF4
CVFI4 4
CVIF4 4
SUBF4
ASGNF4
line 1296
;1296:			  modulate[0] = modulate[1] = modulate[2] = modulate[3] = f;
ADDRLP4 184+12
ADDRLP4 160
INDIRF4
ASGNF4
ADDRLP4 184+8
ADDRLP4 160
INDIRF4
ASGNF4
ADDRLP4 184+4
ADDRLP4 160
INDIRF4
ASGNF4
ADDRLP4 184
ADDRLP4 160
INDIRF4
ASGNF4
line 1297
;1297:			  trap_R_SetColor( modulate );
ADDRLP4 184
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1298
;1298:		  }
LABELV $623
line 1300
;1299:
;1300:		  if ( cg.powerupActive == sorted[i] && 
ADDRGP4 cg+124408
INDIRI4
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 68
ADDP4
INDIRI4
NEI4 $629
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124412
INDIRI4
SUBI4
CNSTI4 200
GEI4 $629
line 1301
;1301:			  cg.time - cg.powerupTime < PULSE_TIME ) {
line 1302
;1302:			  f = 1.0 - ( ( (float)cg.time - cg.powerupTime ) / PULSE_TIME );
ADDRLP4 160
CNSTF4 1065353216
ADDRGP4 cg+107604
INDIRI4
CVIF4 4
ADDRGP4 cg+124412
INDIRI4
CVIF4 4
SUBF4
CNSTF4 1128792064
DIVF4
SUBF4
ASGNF4
line 1303
;1303:			  size = ICON_SIZE * ( 1.0 + ( PULSE_SCALE - 1.0 ) * f );
ADDRLP4 156
CNSTF4 1111490560
CNSTF4 1056964608
ADDRLP4 160
INDIRF4
MULF4
CNSTF4 1065353216
ADDF4
MULF4
ASGNF4
line 1304
;1304:		  } else {
ADDRGP4 $630
JUMPV
LABELV $629
line 1305
;1305:			  size = ICON_SIZE;
ADDRLP4 156
CNSTF4 1111490560
ASGNF4
line 1306
;1306:		  }
LABELV $630
line 1308
;1307:
;1308:		  CG_DrawPic( 640 - size, y + ICON_SIZE / 2 - size / 2, 
ADDRLP4 152
INDIRP4
CNSTI4 24
ADDP4
INDIRP4
ARGP4
ADDRLP4 184
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
CNSTF4 1142947840
ADDRLP4 156
INDIRF4
SUBF4
ARGF4
ADDRFP4 0
INDIRF4
CNSTF4 1103101952
ADDF4
ADDRLP4 156
INDIRF4
CNSTF4 1073741824
DIVF4
SUBF4
ARGF4
ADDRLP4 156
INDIRF4
ARGF4
ADDRLP4 156
INDIRF4
ARGF4
ADDRLP4 184
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1310
;1309:			  size, size, trap_R_RegisterShader( item->icon ) );
;1310:    }
LABELV $620
line 1311
;1311:	}
LABELV $617
line 1276
ADDRLP4 144
ADDRLP4 144
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $619
ADDRLP4 144
INDIRI4
ADDRLP4 136
INDIRI4
LTI4 $616
line 1312
;1312:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1314
;1313:
;1314:	return y;
ADDRFP4 0
INDIRF4
RETF4
LABELV $589
endproc CG_DrawPowerups 208 20
proc CG_DrawLowerRight 12 12
line 1325
;1315:}
;1316:#endif // MISSIONPACK
;1317:
;1318:/*
;1319:=====================
;1320:CG_DrawLowerRight
;1321:
;1322:=====================
;1323:*/
;1324:#ifndef MISSIONPACK
;1325:static void CG_DrawLowerRight( void ) {
line 1328
;1326:	float	y;
;1327:
;1328:	y = 480 - ICON_SIZE;
ADDRLP4 0
CNSTF4 1138229248
ASGNF4
line 1330
;1329:
;1330:	if ( cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 2 ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $637
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 2
NEI4 $637
line 1331
;1331:		y = CG_DrawTeamOverlay( y, qtrue, qfalse );
ADDRLP4 0
INDIRF4
ARGF4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 4
ADDRGP4 CG_DrawTeamOverlay
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1332
;1332:	} 
LABELV $637
line 1334
;1333:
;1334:	y = CG_DrawScores( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 CG_DrawScores
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 1335
;1335:	y = CG_DrawPowerups( y );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 8
ADDRGP4 CG_DrawPowerups
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 8
INDIRF4
ASGNF4
line 1336
;1336:}
LABELV $636
endproc CG_DrawLowerRight 12 12
proc CG_DrawPickupItem 16 20
line 1345
;1337:#endif // MISSIONPACK
;1338:
;1339:/*
;1340:===================
;1341:CG_DrawPickupItem
;1342:===================
;1343:*/
;1344:#ifndef MISSIONPACK
;1345:static int CG_DrawPickupItem( int y ) {
line 1349
;1346:	int		value;
;1347:	float	*fadeColor;
;1348:
;1349:	if ( cg.snap->ps.stats[STAT_HEALTH] <= 0 ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
CNSTI4 0
GTI4 $642
line 1350
;1350:		return y;
ADDRFP4 0
INDIRI4
RETI4
ADDRGP4 $641
JUMPV
LABELV $642
line 1353
;1351:	}
;1352:
;1353:	y -= ICON_SIZE;
ADDRFP4 0
ADDRFP4 0
INDIRI4
CNSTI4 48
SUBI4
ASGNI4
line 1355
;1354:
;1355:	value = cg.itemPickup;
ADDRLP4 0
ADDRGP4 cg+124664
INDIRI4
ASGNI4
line 1356
;1356:	if ( value ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $646
line 1357
;1357:		fadeColor = CG_FadeColor( cg.itemPickupTime, 3000 );
ADDRGP4 cg+124668
INDIRI4
ARGI4
CNSTI4 3000
ARGI4
ADDRLP4 8
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 1358
;1358:		if ( fadeColor ) {
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $649
line 1359
;1359:			CG_RegisterItemVisuals( value );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_RegisterItemVisuals
CALLV
pop
line 1360
;1360:			trap_R_SetColor( fadeColor );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1361
;1361:			CG_DrawPic( 8, y, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon );
CNSTF4 1090519040
ARGF4
ADDRFP4 0
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 12
CNSTF4 1111490560
ASGNF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
CNSTI4 24
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1362
;1362:			CG_DrawBigString( ICON_SIZE + 16, y + (ICON_SIZE/2 - BIGCHAR_HEIGHT/2), bg_itemlist[ value ].pickup_name, fadeColor[0] );
CNSTI4 64
ARGI4
ADDRFP4 0
INDIRI4
CNSTI4 16
ADDI4
ARGI4
CNSTI4 52
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 bg_itemlist+28
ADDP4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
INDIRF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1363
;1363:			trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1364
;1364:		}
LABELV $649
line 1365
;1365:	}
LABELV $646
line 1367
;1366:	
;1367:	return y;
ADDRFP4 0
INDIRI4
RETI4
LABELV $641
endproc CG_DrawPickupItem 16 20
proc CG_DrawLowerLeft 16 12
line 1378
;1368:}
;1369:#endif // MISSIONPACK
;1370:
;1371:/*
;1372:=====================
;1373:CG_DrawLowerLeft
;1374:
;1375:=====================
;1376:*/
;1377:#ifndef MISSIONPACK
;1378:static void CG_DrawLowerLeft( void ) {
line 1381
;1379:	float	y;
;1380:
;1381:	y = 480 - ICON_SIZE;
ADDRLP4 0
CNSTF4 1138229248
ASGNF4
line 1383
;1382:
;1383:	if ( cgs.gametype >= GT_TEAM && cg_drawTeamOverlay.integer == 3 ) {
ADDRLP4 4
CNSTI4 3
ASGNI4
ADDRGP4 cgs+31456
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $654
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $654
line 1384
;1384:		y = CG_DrawTeamOverlay( y, qfalse, qfalse );
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 CG_DrawTeamOverlay
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 12
INDIRF4
ASGNF4
line 1385
;1385:	} 
LABELV $654
line 1388
;1386:
;1387:
;1388:	y = CG_DrawPickupItem( y );
ADDRLP4 0
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 8
ADDRGP4 CG_DrawPickupItem
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 8
INDIRI4
CVIF4 4
ASGNF4
line 1389
;1389:}
LABELV $653
endproc CG_DrawLowerLeft 16 12
proc CG_DrawTeamInfo 56 36
line 1401
;1390:#endif // MISSIONPACK
;1391:
;1392:
;1393://===========================================================================================
;1394:
;1395:/*
;1396:=================
;1397:CG_DrawTeamInfo
;1398:=================
;1399:*/
;1400:#ifndef MISSIONPACK
;1401:static void CG_DrawTeamInfo( void ) {
line 1410
;1402:	int w, h;
;1403:	int i, len;
;1404:	vec4_t		hcolor;
;1405:	int		chatHeight;
;1406:
;1407:#define CHATLOC_Y 420 // bottom end
;1408:#define CHATLOC_X 0
;1409:
;1410:	if (cg_teamChatHeight.integer < TEAMCHAT_HEIGHT)
ADDRGP4 cg_teamChatHeight+12
INDIRI4
CNSTI4 8
GEI4 $659
line 1411
;1411:		chatHeight = cg_teamChatHeight.integer;
ADDRLP4 8
ADDRGP4 cg_teamChatHeight+12
INDIRI4
ASGNI4
ADDRGP4 $660
JUMPV
LABELV $659
line 1413
;1412:	else
;1413:		chatHeight = TEAMCHAT_HEIGHT;
ADDRLP4 8
CNSTI4 8
ASGNI4
LABELV $660
line 1414
;1414:	if (chatHeight <= 0)
ADDRLP4 8
INDIRI4
CNSTI4 0
GTI4 $663
line 1415
;1415:		return; // disabled
ADDRGP4 $658
JUMPV
LABELV $663
line 1417
;1416:
;1417:	if (cgs.teamLastChatPos != cgs.teamChatPos) {
ADDRGP4 cgs+152248
INDIRI4
ADDRGP4 cgs+152244
INDIRI4
EQI4 $665
line 1418
;1418:		if (cg.time - cgs.teamChatMsgTimes[cgs.teamLastChatPos % chatHeight] > cg_teamChatTime.integer) {
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
ADDRLP4 8
INDIRI4
MODI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152212
ADDP4
INDIRI4
SUBI4
ADDRGP4 cg_teamChatTime+12
INDIRI4
LEI4 $669
line 1419
;1419:			cgs.teamLastChatPos++;
ADDRLP4 36
ADDRGP4 cgs+152248
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1420
;1420:		}
LABELV $669
line 1422
;1421:
;1422:		h = (cgs.teamChatPos - cgs.teamLastChatPos) * TINYCHAR_HEIGHT;
ADDRLP4 32
ADDRGP4 cgs+152244
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
SUBI4
CNSTI4 3
LSHI4
ASGNI4
line 1424
;1423:
;1424:		w = 0;
ADDRLP4 28
CNSTI4 0
ASGNI4
line 1426
;1425:
;1426:		for (i = cgs.teamLastChatPos; i < cgs.teamChatPos; i++) {
ADDRLP4 0
ADDRGP4 cgs+152248
INDIRI4
ASGNI4
ADDRGP4 $681
JUMPV
LABELV $678
line 1427
;1427:			len = CG_DrawStrlen(cgs.teamChatMsgs[i % chatHeight]);
CNSTI4 241
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
MODI4
MULI4
ADDRGP4 cgs+150284
ADDP4
ARGP4
ADDRLP4 36
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 36
INDIRI4
ASGNI4
line 1428
;1428:			if (len > w)
ADDRLP4 4
INDIRI4
ADDRLP4 28
INDIRI4
LEI4 $685
line 1429
;1429:				w = len;
ADDRLP4 28
ADDRLP4 4
INDIRI4
ASGNI4
LABELV $685
line 1430
;1430:		}
LABELV $679
line 1426
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $681
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+152244
INDIRI4
LTI4 $678
line 1431
;1431:		w *= TINYCHAR_WIDTH;
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 3
LSHI4
ASGNI4
line 1432
;1432:		w += TINYCHAR_WIDTH * 2;
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1434
;1433:
;1434:		if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_RED ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 1
NEI4 $687
line 1435
;1435:			hcolor[0] = 1.0f;
ADDRLP4 12
CNSTF4 1065353216
ASGNF4
line 1436
;1436:			hcolor[1] = 0.0f;
ADDRLP4 12+4
CNSTF4 0
ASGNF4
line 1437
;1437:			hcolor[2] = 0.0f;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 1438
;1438:			hcolor[3] = 0.33f;
ADDRLP4 12+12
CNSTF4 1051260355
ASGNF4
line 1439
;1439:		} else if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_BLUE ) {
ADDRGP4 $688
JUMPV
LABELV $687
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 2
NEI4 $693
line 1440
;1440:			hcolor[0] = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 1441
;1441:			hcolor[1] = 0.0f;
ADDRLP4 12+4
CNSTF4 0
ASGNF4
line 1442
;1442:			hcolor[2] = 1.0f;
ADDRLP4 12+8
CNSTF4 1065353216
ASGNF4
line 1443
;1443:			hcolor[3] = 0.33f;
ADDRLP4 12+12
CNSTF4 1051260355
ASGNF4
line 1444
;1444:		} else {
ADDRGP4 $694
JUMPV
LABELV $693
line 1445
;1445:			hcolor[0] = 0.0f;
ADDRLP4 12
CNSTF4 0
ASGNF4
line 1446
;1446:			hcolor[1] = 1.0f;
ADDRLP4 12+4
CNSTF4 1065353216
ASGNF4
line 1447
;1447:			hcolor[2] = 0.0f;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 1448
;1448:			hcolor[3] = 0.33f;
ADDRLP4 12+12
CNSTF4 1051260355
ASGNF4
line 1449
;1449:		}
LABELV $694
LABELV $688
line 1451
;1450:
;1451:		trap_R_SetColor( hcolor );
ADDRLP4 12
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1452
;1452:		CG_DrawPic( CHATLOC_X, CHATLOC_Y - h, 640, h, cgs.media.teamStatusBar );
CNSTF4 0
ARGF4
ADDRLP4 36
ADDRLP4 32
INDIRI4
ASGNI4
CNSTI4 420
ADDRLP4 36
INDIRI4
SUBI4
CVIF4 4
ARGF4
CNSTF4 1142947840
ARGF4
ADDRLP4 36
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 cgs+152340+128
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1453
;1453:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1455
;1454:
;1455:		hcolor[0] = hcolor[1] = hcolor[2] = 1.0f;
ADDRLP4 40
CNSTF4 1065353216
ASGNF4
ADDRLP4 12+8
ADDRLP4 40
INDIRF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 40
INDIRF4
ASGNF4
ADDRLP4 12
ADDRLP4 40
INDIRF4
ASGNF4
line 1456
;1456:		hcolor[3] = 1.0f;
ADDRLP4 12+12
CNSTF4 1065353216
ASGNF4
line 1458
;1457:
;1458:		for (i = cgs.teamChatPos - 1; i >= cgs.teamLastChatPos; i--) {
ADDRLP4 0
ADDRGP4 cgs+152244
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $710
JUMPV
LABELV $707
line 1459
;1459:			CG_DrawStringExt( CHATLOC_X + TINYCHAR_WIDTH, 
ADDRLP4 44
CNSTI4 8
ASGNI4
ADDRLP4 44
INDIRI4
ARGI4
CNSTI4 420
ADDRGP4 cgs+152244
INDIRI4
ADDRLP4 0
INDIRI4
SUBI4
CNSTI4 3
LSHI4
SUBI4
ARGI4
CNSTI4 241
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
MODI4
MULI4
ADDRGP4 cgs+150284
ADDP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 44
INDIRI4
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 1463
;1460:				CHATLOC_Y - (cgs.teamChatPos - i)*TINYCHAR_HEIGHT, 
;1461:				cgs.teamChatMsgs[i % chatHeight], hcolor, qfalse, qfalse,
;1462:				TINYCHAR_WIDTH, TINYCHAR_HEIGHT, 0 );
;1463:		}
LABELV $708
line 1458
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $710
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+152248
INDIRI4
GEI4 $707
line 1464
;1464:	}
LABELV $665
line 1465
;1465:}
LABELV $658
endproc CG_DrawTeamInfo 56 36
proc CG_DrawHoldableItem 8 20
line 1474
;1466:#endif // MISSIONPACK
;1467:
;1468:/*
;1469:===================
;1470:CG_DrawHoldableItem
;1471:===================
;1472:*/
;1473:#ifndef MISSIONPACK
;1474:static void CG_DrawHoldableItem( void ) { 
line 1477
;1475:	int		value;
;1476:
;1477:	value = cg.snap->ps.stats[STAT_HOLDABLE_ITEM];
ADDRLP4 0
ADDRGP4 cg+36
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
ASGNI4
line 1478
;1478:	if ( value ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $717
line 1479
;1479:		CG_RegisterItemVisuals( value );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_RegisterItemVisuals
CALLV
pop
line 1480
;1480:		CG_DrawPic( 640-ICON_SIZE, (SCREEN_HEIGHT-ICON_SIZE)/2, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon );
CNSTF4 1142161408
ARGF4
CNSTF4 1129840640
ARGF4
ADDRLP4 4
CNSTF4 1111490560
ASGNF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
CNSTI4 24
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_items+20
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1481
;1481:	}
LABELV $717
line 1483
;1482:
;1483:}
LABELV $715
endproc CG_DrawHoldableItem 8 20
proc CG_DrawReward 68 36
line 1511
;1484:#endif // MISSIONPACK
;1485:
;1486:#ifdef MISSIONPACK
;1487:/*
;1488:===================
;1489:CG_DrawPersistantPowerup
;1490:===================
;1491:*/
;1492:#if 0 // sos001208 - DEAD
;1493:static void CG_DrawPersistantPowerup( void ) { 
;1494:	int		value;
;1495:
;1496:	value = cg.snap->ps.stats[STAT_PERSISTANT_POWERUP];
;1497:	if ( value ) {
;1498:		CG_RegisterItemVisuals( value );
;1499:		CG_DrawPic( 640-ICON_SIZE, (SCREEN_HEIGHT-ICON_SIZE)/2 - ICON_SIZE, ICON_SIZE, ICON_SIZE, cg_items[ value ].icon );
;1500:	}
;1501:}
;1502:#endif
;1503:#endif // MISSIONPACK
;1504:
;1505:
;1506:/*
;1507:===================
;1508:CG_DrawReward
;1509:===================
;1510:*/
;1511:static void CG_DrawReward( void ) { 
line 1517
;1512:	float	*color;
;1513:	int		i, count;
;1514:	float	x, y;
;1515:	char	buf[32];
;1516:
;1517:	if ( !cg_drawRewards.integer ) {
ADDRGP4 cg_drawRewards+12
INDIRI4
CNSTI4 0
NEI4 $721
line 1518
;1518:		return;
ADDRGP4 $720
JUMPV
LABELV $721
line 1521
;1519:	}
;1520:
;1521:	color = CG_FadeColor( cg.rewardTime, REWARD_TIME );
ADDRGP4 cg+124428
INDIRI4
ARGI4
CNSTI4 3000
ARGI4
ADDRLP4 52
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 52
INDIRP4
ASGNP4
line 1522
;1522:	if ( !color ) {
ADDRLP4 16
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $725
line 1523
;1523:		if (cg.rewardStack > 0) {
ADDRGP4 cg+124424
INDIRI4
CNSTI4 0
LEI4 $720
line 1524
;1524:			for(i = 0; i < cg.rewardStack; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $733
JUMPV
LABELV $730
line 1525
;1525:				cg.rewardSound[i] = cg.rewardSound[i+1];
ADDRLP4 56
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 56
INDIRI4
ADDRGP4 cg+124512
ADDP4
ADDRLP4 56
INDIRI4
ADDRGP4 cg+124512+4
ADDP4
INDIRI4
ASGNI4
line 1526
;1526:				cg.rewardShader[i] = cg.rewardShader[i+1];
ADDRLP4 60
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 60
INDIRI4
ADDRGP4 cg+124472
ADDP4
ADDRLP4 60
INDIRI4
ADDRGP4 cg+124472+4
ADDP4
INDIRI4
ASGNI4
line 1527
;1527:				cg.rewardCount[i] = cg.rewardCount[i+1];
ADDRLP4 64
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 64
INDIRI4
ADDRGP4 cg+124432
ADDP4
ADDRLP4 64
INDIRI4
ADDRGP4 cg+124432+4
ADDP4
INDIRI4
ASGNI4
line 1528
;1528:			}
LABELV $731
line 1524
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $733
ADDRLP4 0
INDIRI4
ADDRGP4 cg+124424
INDIRI4
LTI4 $730
line 1529
;1529:			cg.rewardTime = cg.time;
ADDRGP4 cg+124428
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1530
;1530:			cg.rewardStack--;
ADDRLP4 56
ADDRGP4 cg+124424
ASGNP4
ADDRLP4 56
INDIRP4
ADDRLP4 56
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 1531
;1531:			color = CG_FadeColor( cg.rewardTime, REWARD_TIME );
ADDRGP4 cg+124428
INDIRI4
ARGI4
CNSTI4 3000
ARGI4
ADDRLP4 60
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 60
INDIRP4
ASGNP4
line 1532
;1532:			trap_S_StartLocalSound(cg.rewardSound[0], CHAN_ANNOUNCER);
ADDRGP4 cg+124512
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 1533
;1533:		} else {
line 1534
;1534:			return;
LABELV $728
line 1536
;1535:		}
;1536:	}
LABELV $725
line 1538
;1537:
;1538:	trap_R_SetColor( color );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1555
;1539:
;1540:	/*
;1541:	count = cg.rewardCount[0]/10;				// number of big rewards to draw
;1542:
;1543:	if (count) {
;1544:		y = 4;
;1545:		x = 320 - count * ICON_SIZE;
;1546:		for ( i = 0 ; i < count ; i++ ) {
;1547:			CG_DrawPic( x, y, (ICON_SIZE*2)-4, (ICON_SIZE*2)-4, cg.rewardShader[0] );
;1548:			x += (ICON_SIZE*2);
;1549:		}
;1550:	}
;1551:
;1552:	count = cg.rewardCount[0] - count*10;		// number of small rewards to draw
;1553:	*/
;1554:
;1555:	if ( cg.rewardCount[0] >= 10 ) {
ADDRGP4 cg+124432
INDIRI4
CNSTI4 10
LTI4 $749
line 1556
;1556:		y = 56;
ADDRLP4 8
CNSTF4 1113587712
ASGNF4
line 1557
;1557:		x = 320 - ICON_SIZE/2;
ADDRLP4 4
CNSTF4 1133772800
ASGNF4
line 1558
;1558:		CG_DrawPic( x, y, ICON_SIZE-4, ICON_SIZE-4, cg.rewardShader[0] );
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 56
CNSTF4 1110441984
ASGNF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRGP4 cg+124472
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1559
;1559:		Com_sprintf(buf, sizeof(buf), "%d", cg.rewardCount[0]);
ADDRLP4 20
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 $753
ARGP4
ADDRGP4 cg+124432
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1560
;1560:		x = ( SCREEN_WIDTH - SMALLCHAR_WIDTH * CG_DrawStrlen( buf ) ) / 2;
ADDRLP4 20
ARGP4
ADDRLP4 60
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
CNSTI4 640
ADDRLP4 60
INDIRI4
CNSTI4 3
LSHI4
SUBI4
CNSTI4 2
DIVI4
CVIF4 4
ASGNF4
line 1561
;1561:		CG_DrawStringExt( x, y+ICON_SIZE, buf, color, qfalse, qtrue,
ADDRLP4 4
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 8
INDIRF4
CNSTF4 1111490560
ADDF4
CVFI4 4
ARGI4
ADDRLP4 20
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 64
CNSTI4 0
ASGNI4
ADDRLP4 64
INDIRI4
ARGI4
CNSTI4 1
ARGI4
CNSTI4 8
ARGI4
CNSTI4 16
ARGI4
ADDRLP4 64
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 1563
;1562:								SMALLCHAR_WIDTH, SMALLCHAR_HEIGHT, 0 );
;1563:	}
ADDRGP4 $750
JUMPV
LABELV $749
line 1564
;1564:	else {
line 1566
;1565:
;1566:		count = cg.rewardCount[0];
ADDRLP4 12
ADDRGP4 cg+124432
INDIRI4
ASGNI4
line 1568
;1567:
;1568:		y = 56;
ADDRLP4 8
CNSTF4 1113587712
ASGNF4
line 1569
;1569:		x = 320 - count * ICON_SIZE/2;
ADDRLP4 4
CNSTI4 320
CNSTI4 48
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
CVIF4 4
ASGNF4
line 1570
;1570:		for ( i = 0 ; i < count ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $759
JUMPV
LABELV $756
line 1571
;1571:			CG_DrawPic( x, y, ICON_SIZE-4, ICON_SIZE-4, cg.rewardShader[0] );
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 56
CNSTF4 1110441984
ASGNF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRGP4 cg+124472
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1572
;1572:			x += ICON_SIZE;
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1111490560
ADDF4
ASGNF4
line 1573
;1573:		}
LABELV $757
line 1570
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $759
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
LTI4 $756
line 1574
;1574:	}
LABELV $750
line 1575
;1575:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1576
;1576:}
LABELV $720
endproc CG_DrawReward 68 36
export CG_AddLagometerFrameInfo
proc CG_AddLagometerFrameInfo 8 0
line 1607
;1577:
;1578:
;1579:/*
;1580:===============================================================================
;1581:
;1582:LAGOMETER
;1583:
;1584:===============================================================================
;1585:*/
;1586:
;1587:#define	LAG_SAMPLES		128
;1588:
;1589:
;1590:typedef struct {
;1591:	int		frameSamples[LAG_SAMPLES];
;1592:	int		frameCount;
;1593:	int		snapshotFlags[LAG_SAMPLES];
;1594:	int		snapshotSamples[LAG_SAMPLES];
;1595:	int		snapshotCount;
;1596:} lagometer_t;
;1597:
;1598:lagometer_t		lagometer;
;1599:
;1600:/*
;1601:==============
;1602:CG_AddLagometerFrameInfo
;1603:
;1604:Adds the current interpolate / extrapolate bar for this frame
;1605:==============
;1606:*/
;1607:void CG_AddLagometerFrameInfo( void ) {
line 1610
;1608:	int			offset;
;1609:
;1610:	offset = cg.time - cg.latestSnapshotTime;
ADDRLP4 0
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+32
INDIRI4
SUBI4
ASGNI4
line 1611
;1611:	lagometer.frameSamples[ lagometer.frameCount & ( LAG_SAMPLES - 1) ] = offset;
ADDRGP4 lagometer+512
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1612
;1612:	lagometer.frameCount++;
ADDRLP4 4
ADDRGP4 lagometer+512
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1613
;1613:}
LABELV $762
endproc CG_AddLagometerFrameInfo 8 0
export CG_AddLagometerSnapshotInfo
proc CG_AddLagometerSnapshotInfo 4 0
line 1625
;1614:
;1615:/*
;1616:==============
;1617:CG_AddLagometerSnapshotInfo
;1618:
;1619:Each time a snapshot is received, log its ping time and
;1620:the number of snapshots that were dropped before it.
;1621:
;1622:Pass NULL for a dropped packet.
;1623:==============
;1624:*/
;1625:void CG_AddLagometerSnapshotInfo( snapshot_t *snap ) {
line 1627
;1626:	// dropped packet
;1627:	if ( !snap ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $768
line 1628
;1628:		lagometer.snapshotSamples[ lagometer.snapshotCount & ( LAG_SAMPLES - 1) ] = -1;
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+1028
ADDP4
CNSTI4 -1
ASGNI4
line 1629
;1629:		lagometer.snapshotCount++;
ADDRLP4 0
ADDRGP4 lagometer+1540
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1630
;1630:		return;
ADDRGP4 $767
JUMPV
LABELV $768
line 1634
;1631:	}
;1632:
;1633:	// add this snapshot's info
;1634:	lagometer.snapshotSamples[ lagometer.snapshotCount & ( LAG_SAMPLES - 1) ] = snap->ping;
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+1028
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
line 1635
;1635:	lagometer.snapshotFlags[ lagometer.snapshotCount & ( LAG_SAMPLES - 1) ] = snap->snapFlags;
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 127
BANDI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+516
ADDP4
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 1636
;1636:	lagometer.snapshotCount++;
ADDRLP4 0
ADDRGP4 lagometer+1540
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1637
;1637:}
LABELV $767
endproc CG_AddLagometerSnapshotInfo 4 0
proc CG_DrawDisconnect 64 20
line 1646
;1638:
;1639:/*
;1640:==============
;1641:CG_DrawDisconnect
;1642:
;1643:Should we draw something differnet for long lag vs no packets?
;1644:==============
;1645:*/
;1646:static void CG_DrawDisconnect( void ) {
line 1654
;1647:	float		x, y;
;1648:	int			cmdNum;
;1649:	usercmd_t	cmd;
;1650:	const char		*s;
;1651:	int			w;  // bk010215 - FIXME char message[1024];
;1652:
;1653:	// draw the phone jack if we are completely past our buffers
;1654:	cmdNum = trap_GetCurrentCmdNumber() - CMD_BACKUP + 1;
ADDRLP4 44
ADDRGP4 trap_GetCurrentCmdNumber
CALLI4
ASGNI4
ADDRLP4 36
ADDRLP4 44
INDIRI4
CNSTI4 64
SUBI4
CNSTI4 1
ADDI4
ASGNI4
line 1655
;1655:	trap_GetUserCmd( cmdNum, &cmd );
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_GetUserCmd
CALLI4
pop
line 1656
;1656:	if ( cmd.serverTime <= cg.snap->ps.commandTime
ADDRLP4 48
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 48
INDIRI4
ADDRGP4 cg+36
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
LEI4 $783
ADDRLP4 48
INDIRI4
ADDRGP4 cg+107604
INDIRI4
LEI4 $779
LABELV $783
line 1657
;1657:		|| cmd.serverTime > cg.time ) {	// special check for map_restart // bk 0102165 - FIXME
line 1658
;1658:		return;
ADDRGP4 $778
JUMPV
LABELV $779
line 1662
;1659:	}
;1660:
;1661:	// also add text in center of screen
;1662:	s = "Connection Interrupted"; // bk 010215 - FIXME
ADDRLP4 24
ADDRGP4 $784
ASGNP4
line 1663
;1663:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 52
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 52
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 1664
;1664:	CG_DrawBigString( 320 - w/2, 100, s, 1.0F);
CNSTI4 320
ADDRLP4 40
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 100
ARGI4
ADDRLP4 24
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1667
;1665:
;1666:	// blink the icon
;1667:	if ( ( cg.time >> 9 ) & 1 ) {
ADDRGP4 cg+107604
INDIRI4
CNSTI4 9
RSHI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $785
line 1668
;1668:		return;
ADDRGP4 $778
JUMPV
LABELV $785
line 1671
;1669:	}
;1670:
;1671:	x = 640 - 48;
ADDRLP4 28
CNSTF4 1142161408
ASGNF4
line 1672
;1672:	y = 480 - 48;
ADDRLP4 32
CNSTF4 1138229248
ASGNF4
line 1674
;1673:
;1674:	CG_DrawPic( x, y, 48, 48, trap_R_RegisterShader("gfx/2d/net.tga" ) );
ADDRGP4 $788
ARGP4
ADDRLP4 56
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 28
INDIRF4
ARGF4
ADDRLP4 32
INDIRF4
ARGF4
ADDRLP4 60
CNSTF4 1111490560
ASGNF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 56
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1675
;1675:}
LABELV $778
endproc CG_DrawDisconnect 64 20
proc CG_DrawLagometer 68 36
line 1686
;1676:
;1677:
;1678:#define	MAX_LAGOMETER_PING	900
;1679:#define	MAX_LAGOMETER_RANGE	300
;1680:
;1681:/*
;1682:==============
;1683:CG_DrawLagometer
;1684:==============
;1685:*/
;1686:static void CG_DrawLagometer( void ) {
line 1693
;1687:	int		a, x, y, i;
;1688:	float	v;
;1689:	float	ax, ay, aw, ah, mid, range;
;1690:	int		color;
;1691:	float	vscale;
;1692:
;1693:	if ( !cg_lagometer.integer || cgs.localServer ) {
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRGP4 cg_lagometer+12
INDIRI4
ADDRLP4 52
INDIRI4
EQI4 $794
ADDRGP4 cgs+31452
INDIRI4
ADDRLP4 52
INDIRI4
EQI4 $790
LABELV $794
line 1694
;1694:		CG_DrawDisconnect();
ADDRGP4 CG_DrawDisconnect
CALLV
pop
line 1695
;1695:		return;
ADDRGP4 $789
JUMPV
LABELV $790
line 1705
;1696:	}
;1697:
;1698:	//
;1699:	// draw the graph
;1700:	//
;1701:#ifdef MISSIONPACK
;1702:	x = 640 - 48;
;1703:	y = 480 - 144;
;1704:#else
;1705:	x = 640 - 48;
ADDRLP4 44
CNSTI4 592
ASGNI4
line 1706
;1706:	y = 480 - 48;
ADDRLP4 48
CNSTI4 432
ASGNI4
line 1709
;1707:#endif
;1708:
;1709:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1710
;1710:	CG_DrawPic( x, y, 48, 48, cgs.media.lagometerShader );
ADDRLP4 44
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 48
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 56
CNSTF4 1111490560
ASGNF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRLP4 56
INDIRF4
ARGF4
ADDRGP4 cgs+152340+264
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
line 1712
;1711:
;1712:	ax = x;
ADDRLP4 24
ADDRLP4 44
INDIRI4
CVIF4 4
ASGNF4
line 1713
;1713:	ay = y;
ADDRLP4 36
ADDRLP4 48
INDIRI4
CVIF4 4
ASGNF4
line 1714
;1714:	aw = 48;
ADDRLP4 12
CNSTF4 1111490560
ASGNF4
line 1715
;1715:	ah = 48;
ADDRLP4 32
CNSTF4 1111490560
ASGNF4
line 1716
;1716:	CG_AdjustFrom640( &ax, &ay, &aw, &ah );
ADDRLP4 24
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 32
ARGP4
ADDRGP4 CG_AdjustFrom640
CALLV
pop
line 1718
;1717:
;1718:	color = -1;
ADDRLP4 20
CNSTI4 -1
ASGNI4
line 1719
;1719:	range = ah / 3;
ADDRLP4 16
ADDRLP4 32
INDIRF4
CNSTF4 1077936128
DIVF4
ASGNF4
line 1720
;1720:	mid = ay + range;
ADDRLP4 40
ADDRLP4 36
INDIRF4
ADDRLP4 16
INDIRF4
ADDF4
ASGNF4
line 1722
;1721:
;1722:	vscale = range / MAX_LAGOMETER_RANGE;
ADDRLP4 28
ADDRLP4 16
INDIRF4
CNSTF4 1133903872
DIVF4
ASGNF4
line 1725
;1723:
;1724:	// draw the frame interpoalte / extrapolate graph
;1725:	for ( a = 0 ; a < aw ; a++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $800
JUMPV
LABELV $797
line 1726
;1726:		i = ( lagometer.frameCount - 1 - a ) & (LAG_SAMPLES - 1);
ADDRLP4 8
ADDRGP4 lagometer+512
INDIRI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
SUBI4
CNSTI4 127
BANDI4
ASGNI4
line 1727
;1727:		v = lagometer.frameSamples[i];
ADDRLP4 0
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer
ADDP4
INDIRI4
CVIF4 4
ASGNF4
line 1728
;1728:		v *= vscale;
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 1729
;1729:		if ( v > 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
LEF4 $802
line 1730
;1730:			if ( color != 1 ) {
ADDRLP4 20
INDIRI4
CNSTI4 1
EQI4 $804
line 1731
;1731:				color = 1;
ADDRLP4 20
CNSTI4 1
ASGNI4
line 1732
;1732:				trap_R_SetColor( g_color_table[ColorIndex(COLOR_YELLOW)] );
ADDRGP4 g_color_table+48
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1733
;1733:			}
LABELV $804
line 1734
;1734:			if ( v > range ) {
ADDRLP4 0
INDIRF4
ADDRLP4 16
INDIRF4
LEF4 $807
line 1735
;1735:				v = range;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 1736
;1736:			}
LABELV $807
line 1737
;1737:			trap_R_DrawStretchPic ( ax + aw - a, mid - v, 1, v, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 40
INDIRF4
ADDRLP4 0
INDIRF4
SUBF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 64
CNSTF4 0
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
ADDRLP4 64
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1738
;1738:		} else if ( v < 0 ) {
ADDRGP4 $803
JUMPV
LABELV $802
ADDRLP4 0
INDIRF4
CNSTF4 0
GEF4 $811
line 1739
;1739:			if ( color != 2 ) {
ADDRLP4 20
INDIRI4
CNSTI4 2
EQI4 $813
line 1740
;1740:				color = 2;
ADDRLP4 20
CNSTI4 2
ASGNI4
line 1741
;1741:				trap_R_SetColor( g_color_table[ColorIndex(COLOR_BLUE)] );
ADDRGP4 g_color_table+64
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1742
;1742:			}
LABELV $813
line 1743
;1743:			v = -v;
ADDRLP4 0
ADDRLP4 0
INDIRF4
NEGF4
ASGNF4
line 1744
;1744:			if ( v > range ) {
ADDRLP4 0
INDIRF4
ADDRLP4 16
INDIRF4
LEF4 $816
line 1745
;1745:				v = range;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 1746
;1746:			}
LABELV $816
line 1747
;1747:			trap_R_DrawStretchPic( ax + aw - a, mid, 1, v, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 40
INDIRF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 60
CNSTF4 0
ASGNF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRLP4 60
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1748
;1748:		}
LABELV $811
LABELV $803
line 1749
;1749:	}
LABELV $798
line 1725
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $800
ADDRLP4 4
INDIRI4
CVIF4 4
ADDRLP4 12
INDIRF4
LTF4 $797
line 1752
;1750:
;1751:	// draw the snapshot latency / drop graph
;1752:	range = ah / 2;
ADDRLP4 16
ADDRLP4 32
INDIRF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 1753
;1753:	vscale = range / MAX_LAGOMETER_PING;
ADDRLP4 28
ADDRLP4 16
INDIRF4
CNSTF4 1147207680
DIVF4
ASGNF4
line 1755
;1754:
;1755:	for ( a = 0 ; a < aw ; a++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $823
JUMPV
LABELV $820
line 1756
;1756:		i = ( lagometer.snapshotCount - 1 - a ) & (LAG_SAMPLES - 1);
ADDRLP4 8
ADDRGP4 lagometer+1540
INDIRI4
CNSTI4 1
SUBI4
ADDRLP4 4
INDIRI4
SUBI4
CNSTI4 127
BANDI4
ASGNI4
line 1757
;1757:		v = lagometer.snapshotSamples[i];
ADDRLP4 0
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+1028
ADDP4
INDIRI4
CVIF4 4
ASGNF4
line 1758
;1758:		if ( v > 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
LEF4 $826
line 1759
;1759:			if ( lagometer.snapshotFlags[i] & SNAPFLAG_RATE_DELAYED ) {
ADDRLP4 8
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 lagometer+516
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $828
line 1760
;1760:				if ( color != 5 ) {
ADDRLP4 20
INDIRI4
CNSTI4 5
EQI4 $829
line 1761
;1761:					color = 5;	// YELLOW for rate delay
ADDRLP4 20
CNSTI4 5
ASGNI4
line 1762
;1762:					trap_R_SetColor( g_color_table[ColorIndex(COLOR_YELLOW)] );
ADDRGP4 g_color_table+48
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1763
;1763:				}
line 1764
;1764:			} else {
ADDRGP4 $829
JUMPV
LABELV $828
line 1765
;1765:				if ( color != 3 ) {
ADDRLP4 20
INDIRI4
CNSTI4 3
EQI4 $834
line 1766
;1766:					color = 3;
ADDRLP4 20
CNSTI4 3
ASGNI4
line 1767
;1767:					trap_R_SetColor( g_color_table[ColorIndex(COLOR_GREEN)] );
ADDRGP4 g_color_table+32
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1768
;1768:				}
LABELV $834
line 1769
;1769:			}
LABELV $829
line 1770
;1770:			v = v * vscale;
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 1771
;1771:			if ( v > range ) {
ADDRLP4 0
INDIRF4
ADDRLP4 16
INDIRF4
LEF4 $837
line 1772
;1772:				v = range;
ADDRLP4 0
ADDRLP4 16
INDIRF4
ASGNF4
line 1773
;1773:			}
LABELV $837
line 1774
;1774:			trap_R_DrawStretchPic( ax + aw - a, ay + ah - v, 1, v, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 36
INDIRF4
ADDRLP4 32
INDIRF4
ADDF4
ADDRLP4 0
INDIRF4
SUBF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 64
CNSTF4 0
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
ADDRLP4 64
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1775
;1775:		} else if ( v < 0 ) {
ADDRGP4 $827
JUMPV
LABELV $826
ADDRLP4 0
INDIRF4
CNSTF4 0
GEF4 $841
line 1776
;1776:			if ( color != 4 ) {
ADDRLP4 20
INDIRI4
CNSTI4 4
EQI4 $843
line 1777
;1777:				color = 4;		// RED for dropped snapshots
ADDRLP4 20
CNSTI4 4
ASGNI4
line 1778
;1778:				trap_R_SetColor( g_color_table[ColorIndex(COLOR_RED)] );
ADDRGP4 g_color_table+16
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1779
;1779:			}
LABELV $843
line 1780
;1780:			trap_R_DrawStretchPic( ax + aw - a, ay + ah - range, 1, range, 0, 0, 0, 0, cgs.media.whiteShader );
ADDRLP4 24
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ADDRLP4 4
INDIRI4
CVIF4 4
SUBF4
ARGF4
ADDRLP4 36
INDIRF4
ADDRLP4 32
INDIRF4
ADDF4
ADDRLP4 16
INDIRF4
SUBF4
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 64
CNSTF4 0
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
ADDRLP4 64
INDIRF4
ARGF4
ADDRGP4 cgs+152340+16
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1781
;1781:		}
LABELV $841
LABELV $827
line 1782
;1782:	}
LABELV $821
line 1755
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $823
ADDRLP4 4
INDIRI4
CVIF4 4
ADDRLP4 12
INDIRF4
LTF4 $820
line 1784
;1783:
;1784:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1786
;1785:
;1786:	if ( cg_nopredict.integer || cg_synchronousClients.integer ) {
ADDRLP4 60
CNSTI4 0
ASGNI4
ADDRGP4 cg_nopredict+12
INDIRI4
ADDRLP4 60
INDIRI4
NEI4 $852
ADDRGP4 cg_synchronousClients+12
INDIRI4
ADDRLP4 60
INDIRI4
EQI4 $848
LABELV $852
line 1787
;1787:		CG_DrawBigString( ax, ay, "snc", 1.0 );
ADDRLP4 24
INDIRF4
CVFI4 4
ARGI4
ADDRLP4 36
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 $853
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 1788
;1788:	}
LABELV $848
line 1790
;1789:
;1790:	CG_DrawDisconnect();
ADDRGP4 CG_DrawDisconnect
CALLV
pop
line 1791
;1791:}
LABELV $789
endproc CG_DrawLagometer 68 36
export CG_CenterPrint
proc CG_CenterPrint 8 12
line 1812
;1792:
;1793:
;1794:
;1795:/*
;1796:===============================================================================
;1797:
;1798:CENTER PRINTING
;1799:
;1800:===============================================================================
;1801:*/
;1802:
;1803:
;1804:/*
;1805:==============
;1806:CG_CenterPrint
;1807:
;1808:Called for important messages that should stay in the center of the screen
;1809:for a few moments
;1810:==============
;1811:*/
;1812:void CG_CenterPrint( const char *str, int y, int charWidth ) {
line 1815
;1813:	char	*s;
;1814:
;1815:	Q_strncpyz( cg.centerPrint, str, sizeof(cg.centerPrint) );
ADDRGP4 cg+123364
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1817
;1816:
;1817:	cg.centerPrintTime = cg.time;
ADDRGP4 cg+123352
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 1818
;1818:	cg.centerPrintY = y;
ADDRGP4 cg+123360
ADDRFP4 4
INDIRI4
ASGNI4
line 1819
;1819:	cg.centerPrintCharWidth = charWidth;
ADDRGP4 cg+123356
ADDRFP4 8
INDIRI4
ASGNI4
line 1822
;1820:
;1821:	// count the number of lines for centering
;1822:	cg.centerPrintLines = 1;
ADDRGP4 cg+124388
CNSTI4 1
ASGNI4
line 1823
;1823:	s = cg.centerPrint;
ADDRLP4 0
ADDRGP4 cg+123364
ASGNP4
ADDRGP4 $864
JUMPV
LABELV $863
line 1824
;1824:	while( *s ) {
line 1825
;1825:		if (*s == '\n')
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 10
NEI4 $866
line 1826
;1826:			cg.centerPrintLines++;
ADDRLP4 4
ADDRGP4 cg+124388
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $866
line 1827
;1827:		s++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1828
;1828:	}
LABELV $864
line 1824
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $863
line 1829
;1829:}
LABELV $854
endproc CG_CenterPrint 8 12
proc CG_DrawCenterString 1064 36
line 1837
;1830:
;1831:
;1832:/*
;1833:===================
;1834:CG_DrawCenterString
;1835:===================
;1836:*/
;1837:static void CG_DrawCenterString( void ) {
line 1846
;1838:	char	*start;
;1839:	int		l;
;1840:	int		x, y, w;
;1841:#ifdef MISSIONPACK // bk010221 - unused else
;1842:  int h;
;1843:#endif
;1844:	float	*color;
;1845:
;1846:	if ( !cg.centerPrintTime ) {
ADDRGP4 cg+123352
INDIRI4
CNSTI4 0
NEI4 $870
line 1847
;1847:		return;
ADDRGP4 $869
JUMPV
LABELV $870
line 1850
;1848:	}
;1849:
;1850:	color = CG_FadeColor( cg.centerPrintTime, 1000 * cg_centertime.value );
ADDRGP4 cg+123352
INDIRI4
ARGI4
CNSTF4 1148846080
ADDRGP4 cg_centertime+8
INDIRF4
MULF4
CVFI4 4
ARGI4
ADDRLP4 24
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 24
INDIRP4
ASGNP4
line 1851
;1851:	if ( !color ) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $875
line 1852
;1852:		return;
ADDRGP4 $869
JUMPV
LABELV $875
line 1855
;1853:	}
;1854:
;1855:	trap_R_SetColor( color );
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1857
;1856:
;1857:	start = cg.centerPrint;
ADDRLP4 0
ADDRGP4 cg+123364
ASGNP4
line 1859
;1858:
;1859:	y = cg.centerPrintY - cg.centerPrintLines * BIGCHAR_HEIGHT / 2;
ADDRLP4 8
ADDRGP4 cg+123360
INDIRI4
ADDRGP4 cg+124388
INDIRI4
CNSTI4 4
LSHI4
CNSTI4 2
DIVI4
SUBI4
ASGNI4
ADDRGP4 $881
JUMPV
LABELV $880
line 1861
;1860:
;1861:	while ( 1 ) {
line 1864
;1862:		char linebuffer[1024];
;1863:
;1864:		for ( l = 0; l < 50; l++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $883
line 1865
;1865:			if ( !start[l] || start[l] == '\n' ) {
ADDRLP4 1052
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1052
INDIRI4
CNSTI4 0
EQI4 $889
ADDRLP4 1052
INDIRI4
CNSTI4 10
NEI4 $887
LABELV $889
line 1866
;1866:				break;
ADDRGP4 $885
JUMPV
LABELV $887
line 1868
;1867:			}
;1868:			linebuffer[l] = start[l];
ADDRLP4 4
INDIRI4
ADDRLP4 28
ADDP4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
ADDP4
INDIRI1
ASGNI1
line 1869
;1869:		}
LABELV $884
line 1864
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 50
LTI4 $883
LABELV $885
line 1870
;1870:		linebuffer[l] = 0;
ADDRLP4 4
INDIRI4
ADDRLP4 28
ADDP4
CNSTI1 0
ASGNI1
line 1879
;1871:
;1872:#ifdef MISSIONPACK
;1873:		w = CG_Text_Width(linebuffer, 0.5, 0);
;1874:		h = CG_Text_Height(linebuffer, 0.5, 0);
;1875:		x = (SCREEN_WIDTH - w) / 2;
;1876:		CG_Text_Paint(x, y + h, 0.5, color, linebuffer, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;1877:		y += h + 6;
;1878:#else
;1879:		w = cg.centerPrintCharWidth * CG_DrawStrlen( linebuffer );
ADDRLP4 28
ARGP4
ADDRLP4 1052
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRGP4 cg+123356
INDIRI4
ADDRLP4 1052
INDIRI4
MULI4
ASGNI4
line 1881
;1880:
;1881:		x = ( SCREEN_WIDTH - w ) / 2;
ADDRLP4 12
CNSTI4 640
ADDRLP4 16
INDIRI4
SUBI4
CNSTI4 2
DIVI4
ASGNI4
line 1883
;1882:
;1883:		CG_DrawStringExt( x, y, linebuffer, color, qfalse, qtrue,
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 28
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 1056
CNSTI4 0
ASGNI4
ADDRLP4 1056
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 cg+123356
INDIRI4
ARGI4
CNSTF4 1069547520
ADDRGP4 cg+123356
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 1056
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 1886
;1884:			cg.centerPrintCharWidth, (int)(cg.centerPrintCharWidth * 1.5), 0 );
;1885:
;1886:		y += cg.centerPrintCharWidth * 1.5;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CVIF4 4
CNSTF4 1069547520
ADDRGP4 cg+123356
INDIRI4
CVIF4 4
MULF4
ADDF4
CVFI4 4
ASGNI4
ADDRGP4 $895
JUMPV
LABELV $894
line 1888
;1887:#endif
;1888:		while ( *start && ( *start != '\n' ) ) {
line 1889
;1889:			start++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1890
;1890:		}
LABELV $895
line 1888
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $897
ADDRLP4 1060
INDIRI4
CNSTI4 10
NEI4 $894
LABELV $897
line 1891
;1891:		if ( !*start ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $898
line 1892
;1892:			break;
ADDRGP4 $882
JUMPV
LABELV $898
line 1894
;1893:		}
;1894:		start++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1895
;1895:	}
LABELV $881
line 1861
ADDRGP4 $880
JUMPV
LABELV $882
line 1897
;1896:
;1897:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1898
;1898:}
LABELV $869
endproc CG_DrawCenterString 1064 36
proc CG_DrawCrosshair 56 36
line 1916
;1899:
;1900:
;1901:
;1902:/*
;1903:================================================================================
;1904:
;1905:CROSSHAIR
;1906:
;1907:================================================================================
;1908:*/
;1909:
;1910:
;1911:/*
;1912:=================
;1913:CG_DrawCrosshair
;1914:=================
;1915:*/
;1916:static void CG_DrawCrosshair(void) {
line 1923
;1917:	float		w, h;
;1918:	qhandle_t	hShader;
;1919:	float		f;
;1920:	float		x, y;
;1921:	int			ca;
;1922:
;1923:	if ( !cg_drawCrosshair.integer ) {
ADDRGP4 cg_drawCrosshair+12
INDIRI4
CNSTI4 0
NEI4 $901
line 1924
;1924:		return;
ADDRGP4 $900
JUMPV
LABELV $901
line 1927
;1925:	}
;1926:
;1927:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $904
line 1928
;1928:		return;
ADDRGP4 $900
JUMPV
LABELV $904
line 1931
;1929:	}
;1930:
;1931:	if ( cg.renderingThirdPerson ) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
EQI4 $907
line 1932
;1932:		return;
ADDRGP4 $900
JUMPV
LABELV $907
line 1936
;1933:	}
;1934:
;1935:	// set color based on health
;1936:	if ( cg_crosshairHealth.integer ) {
ADDRGP4 cg_crosshairHealth+12
INDIRI4
CNSTI4 0
EQI4 $910
line 1939
;1937:		vec4_t		hcolor;
;1938:
;1939:		CG_ColorForHealth( hcolor );
ADDRLP4 28
ARGP4
ADDRGP4 CG_ColorForHealth
CALLV
pop
line 1940
;1940:		trap_R_SetColor( hcolor );
ADDRLP4 28
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1941
;1941:	} else {
ADDRGP4 $911
JUMPV
LABELV $910
line 1942
;1942:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 1943
;1943:	}
LABELV $911
line 1945
;1944:
;1945:	w = h = cg_crosshairSize.value;
ADDRLP4 28
ADDRGP4 cg_crosshairSize+8
INDIRF4
ASGNF4
ADDRLP4 4
ADDRLP4 28
INDIRF4
ASGNF4
ADDRLP4 0
ADDRLP4 28
INDIRF4
ASGNF4
line 1948
;1946:
;1947:	// pulse the size of the crosshair when picking up items
;1948:	f = cg.time - cg.itemPickupBlendTime;
ADDRLP4 8
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124672
INDIRI4
SUBI4
CVIF4 4
ASGNF4
line 1949
;1949:	if ( f > 0 && f < ITEM_BLOB_TIME ) {
ADDRLP4 8
INDIRF4
CNSTF4 0
LEF4 $916
ADDRLP4 8
INDIRF4
CNSTF4 1128792064
GEF4 $916
line 1950
;1950:		f /= ITEM_BLOB_TIME;
ADDRLP4 8
ADDRLP4 8
INDIRF4
CNSTF4 1128792064
DIVF4
ASGNF4
line 1951
;1951:		w *= ( 1 + f );
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 8
INDIRF4
CNSTF4 1065353216
ADDF4
MULF4
ASGNF4
line 1952
;1952:		h *= ( 1 + f );
ADDRLP4 4
ADDRLP4 4
INDIRF4
ADDRLP4 8
INDIRF4
CNSTF4 1065353216
ADDF4
MULF4
ASGNF4
line 1953
;1953:	}
LABELV $916
line 1955
;1954:
;1955:	x = cg_crosshairX.integer;
ADDRLP4 16
ADDRGP4 cg_crosshairX+12
INDIRI4
CVIF4 4
ASGNF4
line 1956
;1956:	y = cg_crosshairY.integer;
ADDRLP4 20
ADDRGP4 cg_crosshairY+12
INDIRI4
CVIF4 4
ASGNF4
line 1957
;1957:	CG_AdjustFrom640( &x, &y, &w, &h );
ADDRLP4 16
ARGP4
ADDRLP4 20
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_AdjustFrom640
CALLV
pop
line 1959
;1958:
;1959:	ca = cg_drawCrosshair.integer;
ADDRLP4 12
ADDRGP4 cg_drawCrosshair+12
INDIRI4
ASGNI4
line 1960
;1960:	if (ca < 0) {
ADDRLP4 12
INDIRI4
CNSTI4 0
GEI4 $921
line 1961
;1961:		ca = 0;
ADDRLP4 12
CNSTI4 0
ASGNI4
line 1962
;1962:	}
LABELV $921
line 1963
;1963:	hShader = cgs.media.crosshairShader[ ca % NUM_CROSSHAIRS ];
ADDRLP4 24
ADDRLP4 12
INDIRI4
CNSTI4 10
MODI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+224
ADDP4
INDIRI4
ASGNI4
line 1965
;1964:
;1965:	trap_R_DrawStretchPic( x + cg.refdef.x + 0.5 * (cg.refdef.width - w), 
ADDRLP4 36
CNSTF4 1056964608
ASGNF4
ADDRLP4 40
ADDRLP4 0
INDIRF4
ASGNF4
ADDRLP4 16
INDIRF4
ADDRGP4 cg+109044
INDIRI4
CVIF4 4
ADDF4
ADDRLP4 36
INDIRF4
ADDRGP4 cg+109044+8
INDIRI4
CVIF4 4
ADDRLP4 40
INDIRF4
SUBF4
MULF4
ADDF4
ARGF4
ADDRLP4 44
ADDRLP4 4
INDIRF4
ASGNF4
ADDRLP4 20
INDIRF4
ADDRGP4 cg+109044+4
INDIRI4
CVIF4 4
ADDF4
ADDRLP4 36
INDIRF4
ADDRGP4 cg+109044+12
INDIRI4
CVIF4 4
ADDRLP4 44
INDIRF4
SUBF4
MULF4
ADDF4
ARGF4
ADDRLP4 40
INDIRF4
ARGF4
ADDRLP4 44
INDIRF4
ARGF4
ADDRLP4 48
CNSTF4 0
ASGNF4
ADDRLP4 48
INDIRF4
ARGF4
ADDRLP4 48
INDIRF4
ARGF4
ADDRLP4 52
CNSTF4 1065353216
ASGNF4
ADDRLP4 52
INDIRF4
ARGF4
ADDRLP4 52
INDIRF4
ARGF4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 trap_R_DrawStretchPic
CALLV
pop
line 1968
;1966:		y + cg.refdef.y + 0.5 * (cg.refdef.height - h), 
;1967:		w, h, 0, 0, 1, 1, hShader );
;1968:}
LABELV $900
endproc CG_DrawCrosshair 56 36
proc CG_ScanForCrosshairEntity 96 28
line 1977
;1969:
;1970:
;1971:
;1972:/*
;1973:=================
;1974:CG_ScanForCrosshairEntity
;1975:=================
;1976:*/
;1977:static void CG_ScanForCrosshairEntity( void ) {
line 1982
;1978:	trace_t		trace;
;1979:	vec3_t		start, end;
;1980:	int			content;
;1981:
;1982:	VectorCopy( cg.refdef.vieworg, start );
ADDRLP4 56
ADDRGP4 cg+109044+24
INDIRB
ASGNB 12
line 1983
;1983:	VectorMA( start, 131072, cg.refdef.viewaxis[0], end );
ADDRLP4 84
CNSTF4 1207959552
ASGNF4
ADDRLP4 68
ADDRLP4 56
INDIRF4
ADDRLP4 84
INDIRF4
ADDRGP4 cg+109044+36
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 56+4
INDIRF4
ADDRLP4 84
INDIRF4
ADDRGP4 cg+109044+36+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1207959552
ADDRGP4 cg+109044+36+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 1985
;1984:
;1985:	CG_Trace( &trace, start, vec3_origin, vec3_origin, end, 
ADDRLP4 0
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 88
ADDRGP4 vec3_origin
ASGNP4
ADDRLP4 88
INDIRP4
ARGP4
ADDRLP4 88
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
CNSTI4 33554433
ARGI4
ADDRGP4 CG_Trace
CALLV
pop
line 1987
;1986:		cg.snap->ps.clientNum, CONTENTS_SOLID|CONTENTS_BODY );
;1987:	if ( trace.entityNum >= MAX_CLIENTS ) {
ADDRLP4 0+52
INDIRI4
CNSTI4 64
LTI4 $948
line 1988
;1988:		return;
ADDRGP4 $932
JUMPV
LABELV $948
line 1992
;1989:	}
;1990:
;1991:	// if the player is in fog, don't show it
;1992:	content = trap_CM_PointContents( trace.endpos, 0 );
ADDRLP4 0+12
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 92
ADDRGP4 trap_CM_PointContents
CALLI4
ASGNI4
ADDRLP4 80
ADDRLP4 92
INDIRI4
ASGNI4
line 1993
;1993:	if ( content & CONTENTS_FOG ) {
ADDRLP4 80
INDIRI4
CNSTI4 64
BANDI4
CNSTI4 0
EQI4 $952
line 1994
;1994:		return;
ADDRGP4 $932
JUMPV
LABELV $952
line 1998
;1995:	}
;1996:
;1997:	// if the player is invisible, don't show it
;1998:	if ( cg_entities[ trace.entityNum ].currentState.powerups & ( 1 << PW_INVIS ) ) {
CNSTI4 728
ADDRLP4 0+52
INDIRI4
MULI4
ADDRGP4 cg_entities+188
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $954
line 1999
;1999:		return;
ADDRGP4 $932
JUMPV
LABELV $954
line 2003
;2000:	}
;2001:
;2002:	// update the fade timer
;2003:	cg.crosshairClientNum = trace.entityNum;
ADDRGP4 cg+124400
ADDRLP4 0+52
INDIRI4
ASGNI4
line 2004
;2004:	cg.crosshairClientTime = cg.time;
ADDRGP4 cg+124404
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 2005
;2005:}
LABELV $932
endproc CG_ScanForCrosshairEntity 96 28
proc CG_DrawCrosshairNames 20 16
line 2013
;2006:
;2007:
;2008:/*
;2009:=====================
;2010:CG_DrawCrosshairNames
;2011:=====================
;2012:*/
;2013:static void CG_DrawCrosshairNames( void ) {
line 2018
;2014:	float		*color;
;2015:	char		*name;
;2016:	float		w;
;2017:
;2018:	if ( !cg_drawCrosshair.integer ) {
ADDRGP4 cg_drawCrosshair+12
INDIRI4
CNSTI4 0
NEI4 $963
line 2019
;2019:		return;
ADDRGP4 $962
JUMPV
LABELV $963
line 2021
;2020:	}
;2021:	if ( !cg_drawCrosshairNames.integer ) {
ADDRGP4 cg_drawCrosshairNames+12
INDIRI4
CNSTI4 0
NEI4 $966
line 2022
;2022:		return;
ADDRGP4 $962
JUMPV
LABELV $966
line 2024
;2023:	}
;2024:	if ( cg.renderingThirdPerson ) {
ADDRGP4 cg+107628
INDIRI4
CNSTI4 0
EQI4 $969
line 2025
;2025:		return;
ADDRGP4 $962
JUMPV
LABELV $969
line 2029
;2026:	}
;2027:
;2028:	// scan the known entities to see if the crosshair is sighted on one
;2029:	CG_ScanForCrosshairEntity();
ADDRGP4 CG_ScanForCrosshairEntity
CALLV
pop
line 2032
;2030:
;2031:	// draw the name of the player being looked at
;2032:	color = CG_FadeColor( cg.crosshairClientTime, 1000 );
ADDRGP4 cg+124404
INDIRI4
ARGI4
CNSTI4 1000
ARGI4
ADDRLP4 12
ADDRGP4 CG_FadeColor
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 2033
;2033:	if ( !color ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $973
line 2034
;2034:		trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 2035
;2035:		return;
ADDRGP4 $962
JUMPV
LABELV $973
line 2038
;2036:	}
;2037:
;2038:	name = cgs.clientinfo[ cg.crosshairClientNum ].name;
ADDRLP4 4
CNSTI4 1708
ADDRGP4 cg+124400
INDIRI4
MULI4
ADDRGP4 cgs+40972+4
ADDP4
ASGNP4
line 2044
;2039:#ifdef MISSIONPACK
;2040:	color[3] *= 0.5f;
;2041:	w = CG_Text_Width(name, 0.3f, 0);
;2042:	CG_Text_Paint( 320 - w / 2, 190, 0.3f, color, name, 0, 0, ITEM_TEXTSTYLE_SHADOWED);
;2043:#else
;2044:	w = CG_DrawStrlen( name ) * BIGCHAR_WIDTH;
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 16
INDIRI4
CNSTI4 4
LSHI4
CVIF4 4
ASGNF4
line 2045
;2045:	CG_DrawBigString( 320 - w / 2, 170, name, color[3] * 0.5f );
CNSTF4 1134559232
ADDRLP4 8
INDIRF4
CNSTF4 1073741824
DIVF4
SUBF4
CVFI4 4
ARGI4
CNSTI4 170
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
CNSTF4 1056964608
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRF4
MULF4
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2047
;2046:#endif
;2047:	trap_R_SetColor( NULL );
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
line 2048
;2048:}
LABELV $962
endproc CG_DrawCrosshairNames 20 16
proc CG_DrawSpectator 0 16
line 2058
;2049:
;2050:
;2051://==============================================================================
;2052:
;2053:/*
;2054:=================
;2055:CG_DrawSpectator
;2056:=================
;2057:*/
;2058:static void CG_DrawSpectator(void) {
line 2059
;2059:	CG_DrawBigString(320 - 9 * 8, 440, "SPECTATOR", 1.0F);
CNSTI4 248
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $979
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2060
;2060:	if ( cgs.gametype == GT_TOURNAMENT ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 1
NEI4 $980
line 2061
;2061:		CG_DrawBigString(320 - 15 * 8, 460, "waiting to play", 1.0F);
CNSTI4 200
ARGI4
CNSTI4 460
ARGI4
ADDRGP4 $983
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2062
;2062:	}
ADDRGP4 $981
JUMPV
LABELV $980
line 2063
;2063:	else if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $984
line 2064
;2064:		CG_DrawBigString(320 - 39 * 8, 460, "press ESC and use the JOIN menu to play", 1.0F);
CNSTI4 8
ARGI4
CNSTI4 460
ARGI4
ADDRGP4 $987
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2065
;2065:	}
LABELV $984
LABELV $981
line 2066
;2066:}
LABELV $978
endproc CG_DrawSpectator 0 16
proc CG_DrawVote 12 20
line 2073
;2067:
;2068:/*
;2069:=================
;2070:CG_DrawVote
;2071:=================
;2072:*/
;2073:static void CG_DrawVote(void) {
line 2077
;2074:	char	*s;
;2075:	int		sec;
;2076:
;2077:	if ( !cgs.voteTime ) {
ADDRGP4 cgs+31676
INDIRI4
CNSTI4 0
NEI4 $989
line 2078
;2078:		return;
ADDRGP4 $988
JUMPV
LABELV $989
line 2082
;2079:	}
;2080:
;2081:	// play a talk beep whenever it is modified
;2082:	if ( cgs.voteModified ) {
ADDRGP4 cgs+31688
INDIRI4
CNSTI4 0
EQI4 $992
line 2083
;2083:		cgs.voteModified = qfalse;
ADDRGP4 cgs+31688
CNSTI4 0
ASGNI4
line 2084
;2084:		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+728
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2085
;2085:	}
LABELV $992
line 2087
;2086:
;2087:	sec = ( VOTE_TIME - ( cg.time - cgs.voteTime ) ) / 1000;
ADDRLP4 0
CNSTI4 30000
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cgs+31676
INDIRI4
SUBI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 2088
;2088:	if ( sec < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1000
line 2089
;2089:		sec = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 2090
;2090:	}
LABELV $1000
line 2097
;2091:#ifdef MISSIONPACK
;2092:	s = va("VOTE(%i):%s yes:%i no:%i", sec, cgs.voteString, cgs.voteYes, cgs.voteNo);
;2093:	CG_DrawSmallString( 0, 58, s, 1.0F );
;2094:	s = "or press ESC then click Vote";
;2095:	CG_DrawSmallString( 0, 58 + SMALLCHAR_HEIGHT + 2, s, 1.0F );
;2096:#else
;2097:	s = va("VOTE(%i):%s yes:%i no:%i", sec, cgs.voteString, cgs.voteYes, cgs.voteNo );
ADDRGP4 $1002
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 cgs+31692
ARGP4
ADDRGP4 cgs+31680
INDIRI4
ARGI4
ADDRGP4 cgs+31684
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 2098
;2098:	CG_DrawSmallString( 0, 58, s, 1.0F );
CNSTI4 0
ARGI4
CNSTI4 58
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawSmallString
CALLV
pop
line 2100
;2099:#endif
;2100:}
LABELV $988
endproc CG_DrawVote 12 20
proc CG_DrawTeamVote 24 20
line 2107
;2101:
;2102:/*
;2103:=================
;2104:CG_DrawTeamVote
;2105:=================
;2106:*/
;2107:static void CG_DrawTeamVote(void) {
line 2111
;2108:	char	*s;
;2109:	int		sec, cs_offset;
;2110:
;2111:	if ( cgs.clientinfo->team == TEAM_RED )
ADDRGP4 cgs+40972+68
INDIRI4
CNSTI4 1
NEI4 $1007
line 2112
;2112:		cs_offset = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1008
JUMPV
LABELV $1007
line 2113
;2113:	else if ( cgs.clientinfo->team == TEAM_BLUE )
ADDRGP4 cgs+40972+68
INDIRI4
CNSTI4 2
NEI4 $1006
line 2114
;2114:		cs_offset = 1;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 2116
;2115:	else
;2116:		return;
LABELV $1012
LABELV $1008
line 2118
;2117:
;2118:	if ( !cgs.teamVoteTime[cs_offset] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32716
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1015
line 2119
;2119:		return;
ADDRGP4 $1006
JUMPV
LABELV $1015
line 2123
;2120:	}
;2121:
;2122:	// play a talk beep whenever it is modified
;2123:	if ( cgs.teamVoteModified[cs_offset] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1018
line 2124
;2124:		cgs.teamVoteModified[cs_offset] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32740
ADDP4
CNSTI4 0
ASGNI4
line 2125
;2125:		trap_S_StartLocalSound( cgs.media.talkSound, CHAN_LOCAL_SOUND );
ADDRGP4 cgs+152340+728
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2126
;2126:	}
LABELV $1018
line 2128
;2127:
;2128:	sec = ( VOTE_TIME - ( cg.time - cgs.teamVoteTime[cs_offset] ) ) / 1000;
ADDRLP4 4
CNSTI4 30000
ADDRGP4 cg+107604
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+32716
ADDP4
INDIRI4
SUBI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 2129
;2129:	if ( sec < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $1026
line 2130
;2130:		sec = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 2131
;2131:	}
LABELV $1026
line 2132
;2132:	s = va("TEAMVOTE(%i):%s yes:%i no:%i", sec, cgs.teamVoteString[cs_offset],
ADDRGP4 $1028
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
CNSTI4 10
LSHI4
ADDRGP4 cgs+32748
ADDP4
ARGP4
ADDRLP4 16
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 16
INDIRI4
ADDRGP4 cgs+32724
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
INDIRI4
ADDRGP4 cgs+32732
ADDP4
INDIRI4
ARGI4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 20
INDIRP4
ASGNP4
line 2134
;2133:							cgs.teamVoteYes[cs_offset], cgs.teamVoteNo[cs_offset] );
;2134:	CG_DrawSmallString( 0, 90, s, 1.0F );
CNSTI4 0
ARGI4
CNSTI4 90
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawSmallString
CALLV
pop
line 2135
;2135:}
LABELV $1006
endproc CG_DrawTeamVote 24 20
proc CG_DrawScoreboard 4 0
line 2138
;2136:
;2137:
;2138:static qboolean CG_DrawScoreboard() {
line 2203
;2139:#ifdef MISSIONPACK
;2140:	static qboolean firstTime = qtrue;
;2141:	float fade, *fadeColor;
;2142:
;2143:	if (menuScoreboard) {
;2144:		menuScoreboard->window.flags &= ~WINDOW_FORCED;
;2145:	}
;2146:	if (cg_paused.integer) {
;2147:		cg.deferredPlayerLoading = 0;
;2148:		firstTime = qtrue;
;2149:		return qfalse;
;2150:	}
;2151:
;2152:	// should never happen in Team Arena
;2153:	if (cgs.gametype == GT_SINGLE_PLAYER && cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
;2154:		cg.deferredPlayerLoading = 0;
;2155:		firstTime = qtrue;
;2156:		return qfalse;
;2157:	}
;2158:
;2159:	// don't draw scoreboard during death while warmup up
;2160:	if ( cg.warmup && !cg.showScores ) {
;2161:		return qfalse;
;2162:	}
;2163:
;2164:	if ( cg.showScores || cg.predictedPlayerState.pm_type == PM_DEAD || cg.predictedPlayerState.pm_type == PM_INTERMISSION ) {
;2165:		fade = 1.0;
;2166:		fadeColor = colorWhite;
;2167:	} else {
;2168:		fadeColor = CG_FadeColor( cg.scoreFadeTime, FADE_TIME );
;2169:		if ( !fadeColor ) {
;2170:			// next time scoreboard comes up, don't print killer
;2171:			cg.deferredPlayerLoading = 0;
;2172:			cg.killerName[0] = 0;
;2173:			firstTime = qtrue;
;2174:			return qfalse;
;2175:		}
;2176:		fade = *fadeColor;
;2177:	}																					  
;2178:
;2179:
;2180:	if (menuScoreboard == NULL) {
;2181:		if ( cgs.gametype >= GT_TEAM ) {
;2182:			menuScoreboard = Menus_FindByName("teamscore_menu");
;2183:		} else {
;2184:			menuScoreboard = Menus_FindByName("score_menu");
;2185:		}
;2186:	}
;2187:
;2188:	if (menuScoreboard) {
;2189:		if (firstTime) {
;2190:			CG_SetScoreSelection(menuScoreboard);
;2191:			firstTime = qfalse;
;2192:		}
;2193:		Menu_Paint(menuScoreboard, qtrue);
;2194:	}
;2195:
;2196:	// load any models that have been deferred
;2197:	if ( ++cg.deferredPlayerLoading > 10 ) {
;2198:		CG_LoadDeferredPlayers();
;2199:	}
;2200:
;2201:	return qtrue;
;2202:#else
;2203:	return CG_DrawOldScoreboard();
ADDRLP4 0
ADDRGP4 CG_DrawOldScoreboard
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $1032
endproc CG_DrawScoreboard 4 0
proc CG_DrawIntermission 4 0
line 2212
;2204:#endif
;2205:}
;2206:
;2207:/*
;2208:=================
;2209:CG_DrawIntermission
;2210:=================
;2211:*/
;2212:static void CG_DrawIntermission( void ) {
line 2220
;2213://	int key;
;2214:#ifdef MISSIONPACK
;2215:	//if (cg_singlePlayer.integer) {
;2216:	//	CG_DrawCenterString();
;2217:	//	return;
;2218:	//}
;2219:#else
;2220:	if ( cgs.gametype == GT_SINGLE_PLAYER ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 2
NEI4 $1034
line 2221
;2221:		CG_DrawCenterString();
ADDRGP4 CG_DrawCenterString
CALLV
pop
line 2222
;2222:		return;
ADDRGP4 $1033
JUMPV
LABELV $1034
line 2225
;2223:	}
;2224:#endif
;2225:	cg.scoreFadeTime = cg.time;
ADDRGP4 cg+114328
ADDRGP4 cg+107604
INDIRI4
ASGNI4
line 2226
;2226:	cg.scoreBoardShowing = CG_DrawScoreboard();
ADDRLP4 0
ADDRGP4 CG_DrawScoreboard
CALLI4
ASGNI4
ADDRGP4 cg+114324
ADDRLP4 0
INDIRI4
ASGNI4
line 2227
;2227:}
LABELV $1033
endproc CG_DrawIntermission 4 0
proc CG_DrawFollow 32 36
line 2234
;2228:
;2229:/*
;2230:=================
;2231:CG_DrawFollow
;2232:=================
;2233:*/
;2234:static qboolean CG_DrawFollow( void ) {
line 2239
;2235:	float		x;
;2236:	vec4_t		color;
;2237:	const char	*name;
;2238:
;2239:	if ( !(cg.snap->ps.pm_flags & PMF_FOLLOW) ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $1041
line 2240
;2240:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1040
JUMPV
LABELV $1041
line 2242
;2241:	}
;2242:	color[0] = 1;
ADDRLP4 0
CNSTF4 1065353216
ASGNF4
line 2243
;2243:	color[1] = 1;
ADDRLP4 0+4
CNSTF4 1065353216
ASGNF4
line 2244
;2244:	color[2] = 1;
ADDRLP4 0+8
CNSTF4 1065353216
ASGNF4
line 2245
;2245:	color[3] = 1;
ADDRLP4 0+12
CNSTF4 1065353216
ASGNF4
line 2248
;2246:
;2247:
;2248:	CG_DrawBigString( 320 - 9 * 8, 24, "following", 1.0F );
CNSTI4 248
ARGI4
CNSTI4 24
ARGI4
ADDRGP4 $1047
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2250
;2249:
;2250:	name = cgs.clientinfo[ cg.snap->ps.clientNum ].name;
ADDRLP4 16
CNSTI4 1708
ADDRGP4 cg+36
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
MULI4
ADDRGP4 cgs+40972+4
ADDP4
ASGNP4
line 2252
;2251:
;2252:	x = 0.5 * ( 640 - GIANT_WIDTH * CG_DrawStrlen( name ) );
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 20
CNSTF4 1056964608
CNSTI4 640
ADDRLP4 24
INDIRI4
CNSTI4 5
LSHI4
SUBI4
CVIF4 4
MULF4
ASGNF4
line 2254
;2253:
;2254:	CG_DrawStringExt( x, 40, name, color, qtrue, qtrue, GIANT_WIDTH, GIANT_HEIGHT, 0 );
ADDRLP4 20
INDIRF4
CVFI4 4
ARGI4
CNSTI4 40
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 28
CNSTI4 1
ASGNI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 28
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
line 2256
;2255:
;2256:	return qtrue;
CNSTI4 1
RETI4
LABELV $1040
endproc CG_DrawFollow 32 36
proc CG_DrawAmmoWarning 12 16
line 2266
;2257:}
;2258:
;2259:
;2260:
;2261:/*
;2262:=================
;2263:CG_DrawAmmoWarning
;2264:=================
;2265:*/
;2266:static void CG_DrawAmmoWarning( void ) {
line 2270
;2267:	const char	*s;
;2268:	int			w;
;2269:
;2270:	if ( cg_drawAmmoWarning.integer == 0 ) {
ADDRGP4 cg_drawAmmoWarning+12
INDIRI4
CNSTI4 0
NEI4 $1052
line 2271
;2271:		return;
ADDRGP4 $1051
JUMPV
LABELV $1052
line 2274
;2272:	}
;2273:
;2274:	if ( !cg.lowAmmoWarning ) {
ADDRGP4 cg+124392
INDIRI4
CNSTI4 0
NEI4 $1055
line 2275
;2275:		return;
ADDRGP4 $1051
JUMPV
LABELV $1055
line 2278
;2276:	}
;2277:
;2278:	if ( cg.lowAmmoWarning == 2 ) {
ADDRGP4 cg+124392
INDIRI4
CNSTI4 2
NEI4 $1058
line 2279
;2279:		s = "OUT OF AMMO";
ADDRLP4 0
ADDRGP4 $1061
ASGNP4
line 2280
;2280:	} else {
ADDRGP4 $1059
JUMPV
LABELV $1058
line 2281
;2281:		s = "LOW AMMO WARNING";
ADDRLP4 0
ADDRGP4 $1062
ASGNP4
line 2282
;2282:	}
LABELV $1059
line 2283
;2283:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2284
;2284:	CG_DrawBigString(320 - w / 2, 64, s, 1.0F);
CNSTI4 320
ADDRLP4 4
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 64
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2285
;2285:}
LABELV $1051
endproc CG_DrawAmmoWarning 12 16
proc CG_DrawWarmup 56 36
line 2334
;2286:
;2287:
;2288:#ifdef MISSIONPACK
;2289:/*
;2290:=================
;2291:CG_DrawProxWarning
;2292:=================
;2293:*/
;2294:static void CG_DrawProxWarning( void ) {
;2295:	char s [32];
;2296:	int			w;
;2297:  static int proxTime;
;2298:  static int proxCounter;
;2299:  static int proxTick;
;2300:
;2301:	if( !(cg.snap->ps.eFlags & EF_TICKING ) ) {
;2302:    proxTime = 0;
;2303:		return;
;2304:	}
;2305:
;2306:  if (proxTime == 0) {
;2307:    proxTime = cg.time + 5000;
;2308:    proxCounter = 5;
;2309:    proxTick = 0;
;2310:  }
;2311:
;2312:  if (cg.time > proxTime) {
;2313:    proxTick = proxCounter--;
;2314:    proxTime = cg.time + 1000;
;2315:  }
;2316:
;2317:  if (proxTick != 0) {
;2318:    Com_sprintf(s, sizeof(s), "INTERNAL COMBUSTION IN: %i", proxTick);
;2319:  } else {
;2320:    Com_sprintf(s, sizeof(s), "YOU HAVE BEEN MINED");
;2321:  }
;2322:
;2323:	w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
;2324:	CG_DrawBigStringColor( 320 - w / 2, 64 + BIGCHAR_HEIGHT, s, g_color_table[ColorIndex(COLOR_RED)] );
;2325:}
;2326:#endif
;2327:
;2328:
;2329:/*
;2330:=================
;2331:CG_DrawWarmup
;2332:=================
;2333:*/
;2334:static void CG_DrawWarmup( void ) {
line 2343
;2335:	int			w;
;2336:	int			sec;
;2337:	int			i;
;2338:	float scale;
;2339:	clientInfo_t	*ci1, *ci2;
;2340:	int			cw;
;2341:	const char	*s;
;2342:
;2343:	sec = cg.warmup;
ADDRLP4 4
ADDRGP4 cg+124656
INDIRI4
ASGNI4
line 2344
;2344:	if ( !sec ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1065
line 2345
;2345:		return;
ADDRGP4 $1063
JUMPV
LABELV $1065
line 2348
;2346:	}
;2347:
;2348:	if ( sec < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $1067
line 2349
;2349:		s = "Waiting for players";		
ADDRLP4 8
ADDRGP4 $1069
ASGNP4
line 2350
;2350:		w = CG_DrawStrlen( s ) * BIGCHAR_WIDTH;
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 32
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2351
;2351:		CG_DrawBigString(320 - w / 2, 24, s, 1.0F);
CNSTI4 320
ADDRLP4 16
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 24
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 CG_DrawBigString
CALLV
pop
line 2352
;2352:		cg.warmupCount = 0;
ADDRGP4 cg+124660
CNSTI4 0
ASGNI4
line 2353
;2353:		return;
ADDRGP4 $1063
JUMPV
LABELV $1067
line 2356
;2354:	}
;2355:
;2356:	if (cgs.gametype == GT_TOURNAMENT) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 1
NEI4 $1071
line 2358
;2357:		// find the two active players
;2358:		ci1 = NULL;
ADDRLP4 20
CNSTP4 0
ASGNP4
line 2359
;2359:		ci2 = NULL;
ADDRLP4 24
CNSTP4 0
ASGNP4
line 2360
;2360:		for ( i = 0 ; i < cgs.maxclients ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1077
JUMPV
LABELV $1074
line 2361
;2361:			if ( cgs.clientinfo[i].infoValid && cgs.clientinfo[i].team == TEAM_FREE ) {
ADDRLP4 32
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 32
INDIRI4
ADDRGP4 cgs+40972
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
EQI4 $1079
ADDRLP4 32
INDIRI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $1079
line 2362
;2362:				if ( !ci1 ) {
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1084
line 2363
;2363:					ci1 = &cgs.clientinfo[i];
ADDRLP4 20
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 2364
;2364:				} else {
ADDRGP4 $1085
JUMPV
LABELV $1084
line 2365
;2365:					ci2 = &cgs.clientinfo[i];
ADDRLP4 24
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972
ADDP4
ASGNP4
line 2366
;2366:				}
LABELV $1085
line 2367
;2367:			}
LABELV $1079
line 2368
;2368:		}
LABELV $1075
line 2360
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1077
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+31480
INDIRI4
LTI4 $1074
line 2370
;2369:
;2370:		if ( ci1 && ci2 ) {
ADDRLP4 32
CNSTU4 0
ASGNU4
ADDRLP4 20
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $1072
ADDRLP4 24
INDIRP4
CVPU4 4
ADDRLP4 32
INDIRU4
EQU4 $1072
line 2371
;2371:			s = va( "%s vs %s", ci1->name, ci2->name );
ADDRGP4 $1090
ARGP4
ADDRLP4 36
CNSTI4 4
ASGNI4
ADDRLP4 20
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ARGP4
ADDRLP4 24
INDIRP4
ADDRLP4 36
INDIRI4
ADDP4
ARGP4
ADDRLP4 40
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 40
INDIRP4
ASGNP4
line 2376
;2372:#ifdef MISSIONPACK
;2373:			w = CG_Text_Width(s, 0.6f, 0);
;2374:			CG_Text_Paint(320 - w / 2, 60, 0.6f, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;2375:#else
;2376:			w = CG_DrawStrlen( s );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 44
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 44
INDIRI4
ASGNI4
line 2377
;2377:			if ( w > 640 / GIANT_WIDTH ) {
ADDRLP4 16
INDIRI4
CNSTI4 20
LEI4 $1091
line 2378
;2378:				cw = 640 / w;
ADDRLP4 12
CNSTI4 640
ADDRLP4 16
INDIRI4
DIVI4
ASGNI4
line 2379
;2379:			} else {
ADDRGP4 $1092
JUMPV
LABELV $1091
line 2380
;2380:				cw = GIANT_WIDTH;
ADDRLP4 12
CNSTI4 32
ASGNI4
line 2381
;2381:			}
LABELV $1092
line 2382
;2382:			CG_DrawStringExt( 320 - w * cw/2, 20,s, colorWhite, 
CNSTI4 320
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 20
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 colorWhite
ARGP4
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRLP4 52
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTF4 1069547520
ADDRLP4 12
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 52
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2385
;2383:					qfalse, qtrue, cw, (int)(cw * 1.5f), 0 );
;2384:#endif
;2385:		}
line 2386
;2386:	} else {
ADDRGP4 $1072
JUMPV
LABELV $1071
line 2387
;2387:		if ( cgs.gametype == GT_FFA ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 0
NEI4 $1093
line 2388
;2388:			s = "Free For All";
ADDRLP4 8
ADDRGP4 $1096
ASGNP4
line 2389
;2389:		} else if ( cgs.gametype == GT_TEAM ) {
ADDRGP4 $1094
JUMPV
LABELV $1093
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
NEI4 $1097
line 2390
;2390:			s = "Team Deathmatch";
ADDRLP4 8
ADDRGP4 $1100
ASGNP4
line 2391
;2391:		} else if ( cgs.gametype == GT_CTF ) {
ADDRGP4 $1098
JUMPV
LABELV $1097
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
NEI4 $1101
line 2392
;2392:			s = "Capture the Flag";
ADDRLP4 8
ADDRGP4 $1104
ASGNP4
line 2401
;2393:#ifdef MISSIONPACK
;2394:		} else if ( cgs.gametype == GT_1FCTF ) {
;2395:			s = "One Flag CTF";
;2396:		} else if ( cgs.gametype == GT_OBELISK ) {
;2397:			s = "Overload";
;2398:		} else if ( cgs.gametype == GT_HARVESTER ) {
;2399:			s = "Harvester";
;2400:#endif
;2401:		} else {
ADDRGP4 $1102
JUMPV
LABELV $1101
line 2402
;2402:			s = "";
ADDRLP4 8
ADDRGP4 $1105
ASGNP4
line 2403
;2403:		}
LABELV $1102
LABELV $1098
LABELV $1094
line 2408
;2404:#ifdef MISSIONPACK
;2405:		w = CG_Text_Width(s, 0.6f, 0);
;2406:		CG_Text_Paint(320 - w / 2, 90, 0.6f, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;2407:#else
;2408:		w = CG_DrawStrlen( s );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 32
INDIRI4
ASGNI4
line 2409
;2409:		if ( w > 640 / GIANT_WIDTH ) {
ADDRLP4 16
INDIRI4
CNSTI4 20
LEI4 $1106
line 2410
;2410:			cw = 640 / w;
ADDRLP4 12
CNSTI4 640
ADDRLP4 16
INDIRI4
DIVI4
ASGNI4
line 2411
;2411:		} else {
ADDRGP4 $1107
JUMPV
LABELV $1106
line 2412
;2412:			cw = GIANT_WIDTH;
ADDRLP4 12
CNSTI4 32
ASGNI4
line 2413
;2413:		}
LABELV $1107
line 2414
;2414:		CG_DrawStringExt( 320 - w * cw/2, 25,s, colorWhite, 
CNSTI4 320
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 25
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 colorWhite
ARGP4
ADDRLP4 40
CNSTI4 0
ASGNI4
ADDRLP4 40
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTF4 1066192077
ADDRLP4 12
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 40
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2417
;2415:				qfalse, qtrue, cw, (int)(cw * 1.1f), 0 );
;2416:#endif
;2417:	}
LABELV $1072
line 2419
;2418:
;2419:	sec = ( sec - cg.time ) / 1000;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRGP4 cg+107604
INDIRI4
SUBI4
CNSTI4 1000
DIVI4
ASGNI4
line 2420
;2420:	if ( sec < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $1109
line 2421
;2421:		cg.warmup = 0;
ADDRGP4 cg+124656
CNSTI4 0
ASGNI4
line 2422
;2422:		sec = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 2423
;2423:	}
LABELV $1109
line 2424
;2424:	s = va( "Starts in: %i", sec + 1 );
ADDRGP4 $1112
ARGP4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRLP4 32
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 32
INDIRP4
ASGNP4
line 2425
;2425:	if ( sec != cg.warmupCount ) {
ADDRLP4 4
INDIRI4
ADDRGP4 cg+124660
INDIRI4
EQI4 $1113
line 2426
;2426:		cg.warmupCount = sec;
ADDRGP4 cg+124660
ADDRLP4 4
INDIRI4
ASGNI4
line 2427
;2427:		switch ( sec ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $1119
ADDRLP4 4
INDIRI4
CNSTI4 1
EQI4 $1122
ADDRLP4 4
INDIRI4
CNSTI4 2
EQI4 $1125
ADDRGP4 $1118
JUMPV
LABELV $1119
line 2429
;2428:		case 0:
;2429:			trap_S_StartLocalSound( cgs.media.count1Sound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+964
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2430
;2430:			break;
ADDRGP4 $1118
JUMPV
LABELV $1122
line 2432
;2431:		case 1:
;2432:			trap_S_StartLocalSound( cgs.media.count2Sound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+960
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2433
;2433:			break;
ADDRGP4 $1118
JUMPV
LABELV $1125
line 2435
;2434:		case 2:
;2435:			trap_S_StartLocalSound( cgs.media.count3Sound, CHAN_ANNOUNCER );
ADDRGP4 cgs+152340+956
INDIRI4
ARGI4
CNSTI4 7
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
line 2436
;2436:			break;
line 2438
;2437:		default:
;2438:			break;
LABELV $1118
line 2440
;2439:		}
;2440:	}
LABELV $1113
line 2441
;2441:	scale = 0.45f;
ADDRLP4 28
CNSTF4 1055286886
ASGNF4
line 2442
;2442:	switch ( cg.warmupCount ) {
ADDRLP4 36
ADDRGP4 cg+124660
INDIRI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
EQI4 $1131
ADDRLP4 36
INDIRI4
CNSTI4 1
EQI4 $1132
ADDRLP4 36
INDIRI4
CNSTI4 2
EQI4 $1133
ADDRGP4 $1128
JUMPV
LABELV $1131
line 2444
;2443:	case 0:
;2444:		cw = 28;
ADDRLP4 12
CNSTI4 28
ASGNI4
line 2445
;2445:		scale = 0.54f;
ADDRLP4 28
CNSTF4 1057635697
ASGNF4
line 2446
;2446:		break;
ADDRGP4 $1129
JUMPV
LABELV $1132
line 2448
;2447:	case 1:
;2448:		cw = 24;
ADDRLP4 12
CNSTI4 24
ASGNI4
line 2449
;2449:		scale = 0.51f;
ADDRLP4 28
CNSTF4 1057132380
ASGNF4
line 2450
;2450:		break;
ADDRGP4 $1129
JUMPV
LABELV $1133
line 2452
;2451:	case 2:
;2452:		cw = 20;
ADDRLP4 12
CNSTI4 20
ASGNI4
line 2453
;2453:		scale = 0.48f;
ADDRLP4 28
CNSTF4 1056293519
ASGNF4
line 2454
;2454:		break;
ADDRGP4 $1129
JUMPV
LABELV $1128
line 2456
;2455:	default:
;2456:		cw = 16;
ADDRLP4 12
CNSTI4 16
ASGNI4
line 2457
;2457:		scale = 0.45f;
ADDRLP4 28
CNSTF4 1055286886
ASGNF4
line 2458
;2458:		break;
LABELV $1129
line 2465
;2459:	}
;2460:
;2461:#ifdef MISSIONPACK
;2462:		w = CG_Text_Width(s, scale, 0);
;2463:		CG_Text_Paint(320 - w / 2, 125, scale, colorWhite, s, 0, 0, ITEM_TEXTSTYLE_SHADOWEDMORE);
;2464:#else
;2465:	w = CG_DrawStrlen( s );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 CG_DrawStrlen
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 40
INDIRI4
ASGNI4
line 2466
;2466:	CG_DrawStringExt( 320 - w * cw/2, 70, s, colorWhite, 
CNSTI4 320
ADDRLP4 16
INDIRI4
ADDRLP4 12
INDIRI4
MULI4
CNSTI4 2
DIVI4
SUBI4
ARGI4
CNSTI4 70
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 colorWhite
ARGP4
ADDRLP4 48
CNSTI4 0
ASGNI4
ADDRLP4 48
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTF4 1069547520
ADDRLP4 12
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ARGI4
ADDRLP4 48
INDIRI4
ARGI4
ADDRGP4 CG_DrawStringExt
CALLV
pop
line 2469
;2467:			qfalse, qtrue, cw, (int)(cw * 1.5), 0 );
;2468:#endif
;2469:}
LABELV $1063
endproc CG_DrawWarmup 56 36
proc CG_Draw2D 8 0
line 2494
;2470:
;2471://==================================================================================
;2472:#ifdef MISSIONPACK
;2473:/* 
;2474:=================
;2475:CG_DrawTimedMenus
;2476:=================
;2477:*/
;2478:void CG_DrawTimedMenus() {
;2479:	if (cg.voiceTime) {
;2480:		int t = cg.time - cg.voiceTime;
;2481:		if ( t > 2500 ) {
;2482:			Menus_CloseByName("voiceMenu");
;2483:			trap_Cvar_Set("cl_conXOffset", "0");
;2484:			cg.voiceTime = 0;
;2485:		}
;2486:	}
;2487:}
;2488:#endif
;2489:/*
;2490:=================
;2491:CG_Draw2D
;2492:=================
;2493:*/
;2494:static void CG_Draw2D( void ) {
line 2501
;2495:#ifdef MISSIONPACK
;2496:	if (cgs.orderPending && cg.time > cgs.orderTime) {
;2497:		CG_CheckOrderPending();
;2498:	}
;2499:#endif
;2500:	// if we are taking a levelshot for the menu, don't draw anything
;2501:	if ( cg.levelShot ) {
ADDRGP4 cg+12
INDIRI4
CNSTI4 0
EQI4 $1135
line 2502
;2502:		return;
ADDRGP4 $1134
JUMPV
LABELV $1135
line 2505
;2503:	}
;2504:
;2505:	if ( cg_draw2D.integer == 0 ) {
ADDRGP4 cg_draw2D+12
INDIRI4
CNSTI4 0
NEI4 $1138
line 2506
;2506:		return;
ADDRGP4 $1134
JUMPV
LABELV $1138
line 2509
;2507:	}
;2508:
;2509:	if ( cg.snap->ps.pm_type == PM_INTERMISSION ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 5
NEI4 $1141
line 2510
;2510:		CG_DrawIntermission();
ADDRGP4 CG_DrawIntermission
CALLV
pop
line 2511
;2511:		return;
ADDRGP4 $1134
JUMPV
LABELV $1141
line 2519
;2512:	}
;2513:
;2514:/*
;2515:	if (cg.cameraMode) {
;2516:		return;
;2517:	}
;2518:*/
;2519:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR ) {
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $1144
line 2520
;2520:		CG_DrawSpectator();
ADDRGP4 CG_DrawSpectator
CALLV
pop
line 2521
;2521:		CG_DrawCrosshair();
ADDRGP4 CG_DrawCrosshair
CALLV
pop
line 2522
;2522:		CG_DrawCrosshairNames();
ADDRGP4 CG_DrawCrosshairNames
CALLV
pop
line 2523
;2523:	} else {
ADDRGP4 $1145
JUMPV
LABELV $1144
line 2525
;2524:		// don't draw any status if dead or the scoreboard is being explicitly shown
;2525:		if ( !cg.showScores && cg.snap->ps.stats[STAT_HEALTH] > 0 ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 cg+114320
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1147
ADDRGP4 cg+36
INDIRP4
CNSTI4 228
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
LEI4 $1147
line 2533
;2526:
;2527:#ifdef MISSIONPACK
;2528:			if ( cg_drawStatus.integer ) {
;2529:				Menu_PaintAll();
;2530:				CG_DrawTimedMenus();
;2531:			}
;2532:#else
;2533:			CG_DrawStatusBar();
ADDRGP4 CG_DrawStatusBar
CALLV
pop
line 2536
;2534:#endif
;2535:      
;2536:			CG_DrawAmmoWarning();
ADDRGP4 CG_DrawAmmoWarning
CALLV
pop
line 2541
;2537:
;2538:#ifdef MISSIONPACK
;2539:			CG_DrawProxWarning();
;2540:#endif      
;2541:			CG_DrawCrosshair();
ADDRGP4 CG_DrawCrosshair
CALLV
pop
line 2542
;2542:			CG_DrawCrosshairNames();
ADDRGP4 CG_DrawCrosshairNames
CALLV
pop
line 2543
;2543:			CG_DrawWeaponSelect();
ADDRGP4 CG_DrawWeaponSelect
CALLV
pop
line 2546
;2544:
;2545:#ifndef MISSIONPACK
;2546:			CG_DrawHoldableItem();
ADDRGP4 CG_DrawHoldableItem
CALLV
pop
line 2550
;2547:#else
;2548:			//CG_DrawPersistantPowerup();
;2549:#endif
;2550:			CG_DrawReward();
ADDRGP4 CG_DrawReward
CALLV
pop
line 2551
;2551:		}
LABELV $1147
line 2553
;2552:    
;2553:		if ( cgs.gametype >= GT_TEAM ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
LTI4 $1151
line 2555
;2554:#ifndef MISSIONPACK
;2555:			CG_DrawTeamInfo();
ADDRGP4 CG_DrawTeamInfo
CALLV
pop
line 2557
;2556:#endif
;2557:		}
LABELV $1151
line 2558
;2558:	}
LABELV $1145
line 2560
;2559:
;2560:	CG_DrawVote();
ADDRGP4 CG_DrawVote
CALLV
pop
line 2561
;2561:	CG_DrawTeamVote();
ADDRGP4 CG_DrawTeamVote
CALLV
pop
line 2563
;2562:
;2563:	CG_DrawLagometer();
ADDRGP4 CG_DrawLagometer
CALLV
pop
line 2570
;2564:
;2565:#ifdef MISSIONPACK
;2566:	if (!cg_paused.integer) {
;2567:		CG_DrawUpperRight();
;2568:	}
;2569:#else
;2570:	CG_DrawUpperRight();
ADDRGP4 CG_DrawUpperRight
CALLV
pop
line 2574
;2571:#endif
;2572:
;2573:#ifndef MISSIONPACK
;2574:	CG_DrawLowerRight();
ADDRGP4 CG_DrawLowerRight
CALLV
pop
line 2575
;2575:	CG_DrawLowerLeft();
ADDRGP4 CG_DrawLowerLeft
CALLV
pop
line 2578
;2576:#endif
;2577:
;2578:	if ( !CG_DrawFollow() ) {
ADDRLP4 0
ADDRGP4 CG_DrawFollow
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1154
line 2579
;2579:		CG_DrawWarmup();
ADDRGP4 CG_DrawWarmup
CALLV
pop
line 2580
;2580:	}
LABELV $1154
line 2583
;2581:
;2582:	// don't draw center string if scoreboard is up
;2583:	cg.scoreBoardShowing = CG_DrawScoreboard();
ADDRLP4 4
ADDRGP4 CG_DrawScoreboard
CALLI4
ASGNI4
ADDRGP4 cg+114324
ADDRLP4 4
INDIRI4
ASGNI4
line 2584
;2584:	if ( !cg.scoreBoardShowing) {
ADDRGP4 cg+114324
INDIRI4
CNSTI4 0
NEI4 $1157
line 2585
;2585:		CG_DrawCenterString();
ADDRGP4 CG_DrawCenterString
CALLV
pop
line 2586
;2586:	}
LABELV $1157
line 2587
;2587:}
LABELV $1134
endproc CG_Draw2D 8 0
proc CG_DrawTourneyScoreboard 0 0
line 2590
;2588:
;2589:
;2590:static void CG_DrawTourneyScoreboard() {
line 2593
;2591:#ifdef MISSIONPACK
;2592:#else
;2593:	CG_DrawOldTourneyScoreboard();
ADDRGP4 CG_DrawOldTourneyScoreboard
CALLV
pop
line 2595
;2594:#endif
;2595:}
LABELV $1160
endproc CG_DrawTourneyScoreboard 0 0
export CG_DrawActive
proc CG_DrawActive 24 4
line 2604
;2596:
;2597:/*
;2598:=====================
;2599:CG_DrawActive
;2600:
;2601:Perform all drawing needed to completely fill the screen
;2602:=====================
;2603:*/
;2604:void CG_DrawActive( stereoFrame_t stereoView ) {
line 2609
;2605:	float		separation;
;2606:	vec3_t		baseOrg;
;2607:
;2608:	// optionally draw the info screen instead
;2609:	if ( !cg.snap ) {
ADDRGP4 cg+36
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1162
line 2610
;2610:		CG_DrawInformation();
ADDRGP4 CG_DrawInformation
CALLV
pop
line 2611
;2611:		return;
ADDRGP4 $1161
JUMPV
LABELV $1162
line 2615
;2612:	}
;2613:
;2614:	// optionally draw the tournement scoreboard instead
;2615:	if ( cg.snap->ps.persistant[PERS_TEAM] == TEAM_SPECTATOR &&
ADDRGP4 cg+36
INDIRP4
CNSTI4 304
ADDP4
INDIRI4
CNSTI4 3
NEI4 $1165
ADDRGP4 cg+36
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 8192
BANDI4
CNSTI4 0
EQI4 $1165
line 2616
;2616:		( cg.snap->ps.pm_flags & PMF_SCOREBOARD ) ) {
line 2617
;2617:		CG_DrawTourneyScoreboard();
ADDRGP4 CG_DrawTourneyScoreboard
CALLV
pop
line 2618
;2618:		return;
ADDRGP4 $1161
JUMPV
LABELV $1165
line 2621
;2619:	}
;2620:
;2621:	switch ( stereoView ) {
ADDRLP4 16
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $1172
ADDRLP4 16
INDIRI4
CNSTI4 1
EQI4 $1173
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $1175
ADDRGP4 $1169
JUMPV
LABELV $1172
line 2623
;2622:	case STEREO_CENTER:
;2623:		separation = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 2624
;2624:		break;
ADDRGP4 $1170
JUMPV
LABELV $1173
line 2626
;2625:	case STEREO_LEFT:
;2626:		separation = -cg_stereoSeparation.value / 2;
ADDRLP4 0
ADDRGP4 cg_stereoSeparation+8
INDIRF4
NEGF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 2627
;2627:		break;
ADDRGP4 $1170
JUMPV
LABELV $1175
line 2629
;2628:	case STEREO_RIGHT:
;2629:		separation = cg_stereoSeparation.value / 2;
ADDRLP4 0
ADDRGP4 cg_stereoSeparation+8
INDIRF4
CNSTF4 1073741824
DIVF4
ASGNF4
line 2630
;2630:		break;
ADDRGP4 $1170
JUMPV
LABELV $1169
line 2632
;2631:	default:
;2632:		separation = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 2633
;2633:		CG_Error( "CG_DrawActive: Undefined stereoView" );
ADDRGP4 $1177
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 2634
;2634:	}
LABELV $1170
line 2638
;2635:
;2636:
;2637:	// clear around the rendered view if sized down
;2638:	CG_TileClear();
ADDRGP4 CG_TileClear
CALLV
pop
line 2641
;2639:
;2640:	// offset vieworg appropriately if we're doing stereo separation
;2641:	VectorCopy( cg.refdef.vieworg, baseOrg );
ADDRLP4 4
ADDRGP4 cg+109044+24
INDIRB
ASGNB 12
line 2642
;2642:	if ( separation != 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
EQF4 $1180
line 2643
;2643:		VectorMA( cg.refdef.vieworg, -separation, cg.refdef.viewaxis[1], cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRGP4 cg+109044+24
INDIRF4
ADDRGP4 cg+109044+36+12
INDIRF4
ADDRLP4 0
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+109044+24+4
ADDRGP4 cg+109044+24+4
INDIRF4
ADDRGP4 cg+109044+36+12+4
INDIRF4
ADDRLP4 0
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRGP4 cg+109044+24+8
ADDRGP4 cg+109044+24+8
INDIRF4
ADDRGP4 cg+109044+36+12+8
INDIRF4
ADDRLP4 0
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 2644
;2644:	}
LABELV $1180
line 2647
;2645:
;2646:	// draw 3D view
;2647:	trap_R_RenderScene( &cg.refdef );
ADDRGP4 cg+109044
ARGP4
ADDRGP4 trap_R_RenderScene
CALLV
pop
line 2650
;2648:
;2649:	// restore original viewpoint if running stereo
;2650:	if ( separation != 0 ) {
ADDRLP4 0
INDIRF4
CNSTF4 0
EQF4 $1210
line 2651
;2651:		VectorCopy( baseOrg, cg.refdef.vieworg );
ADDRGP4 cg+109044+24
ADDRLP4 4
INDIRB
ASGNB 12
line 2652
;2652:	}
LABELV $1210
line 2655
;2653:
;2654:	// draw status bar and other floating elements
;2655: 	CG_Draw2D();
ADDRGP4 CG_Draw2D
CALLV
pop
line 2656
;2656:}
LABELV $1161
endproc CG_DrawActive 24 4
bss
export lagometer
align 4
LABELV lagometer
skip 1544
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
export teamChat2
align 1
LABELV teamChat2
skip 256
export teamChat1
align 1
LABELV teamChat1
skip 256
export systemChat
align 1
LABELV systemChat
skip 256
export numSortedTeamPlayers
align 4
LABELV numSortedTeamPlayers
skip 4
export sortedTeamPlayers
align 4
LABELV sortedTeamPlayers
skip 128
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
LABELV $1177
byte 1 67
byte 1 71
byte 1 95
byte 1 68
byte 1 114
byte 1 97
byte 1 119
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 101
byte 1 58
byte 1 32
byte 1 85
byte 1 110
byte 1 100
byte 1 101
byte 1 102
byte 1 105
byte 1 110
byte 1 101
byte 1 100
byte 1 32
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 111
byte 1 86
byte 1 105
byte 1 101
byte 1 119
byte 1 0
align 1
LABELV $1112
byte 1 83
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1105
byte 1 0
align 1
LABELV $1104
byte 1 67
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $1100
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 68
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 109
byte 1 97
byte 1 116
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $1096
byte 1 70
byte 1 114
byte 1 101
byte 1 101
byte 1 32
byte 1 70
byte 1 111
byte 1 114
byte 1 32
byte 1 65
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $1090
byte 1 37
byte 1 115
byte 1 32
byte 1 118
byte 1 115
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $1069
byte 1 87
byte 1 97
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 102
byte 1 111
byte 1 114
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 0
align 1
LABELV $1062
byte 1 76
byte 1 79
byte 1 87
byte 1 32
byte 1 65
byte 1 77
byte 1 77
byte 1 79
byte 1 32
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 0
align 1
LABELV $1061
byte 1 79
byte 1 85
byte 1 84
byte 1 32
byte 1 79
byte 1 70
byte 1 32
byte 1 65
byte 1 77
byte 1 77
byte 1 79
byte 1 0
align 1
LABELV $1047
byte 1 102
byte 1 111
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $1028
byte 1 84
byte 1 69
byte 1 65
byte 1 77
byte 1 86
byte 1 79
byte 1 84
byte 1 69
byte 1 40
byte 1 37
byte 1 105
byte 1 41
byte 1 58
byte 1 37
byte 1 115
byte 1 32
byte 1 121
byte 1 101
byte 1 115
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 110
byte 1 111
byte 1 58
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1002
byte 1 86
byte 1 79
byte 1 84
byte 1 69
byte 1 40
byte 1 37
byte 1 105
byte 1 41
byte 1 58
byte 1 37
byte 1 115
byte 1 32
byte 1 121
byte 1 101
byte 1 115
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 110
byte 1 111
byte 1 58
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $987
byte 1 112
byte 1 114
byte 1 101
byte 1 115
byte 1 115
byte 1 32
byte 1 69
byte 1 83
byte 1 67
byte 1 32
byte 1 97
byte 1 110
byte 1 100
byte 1 32
byte 1 117
byte 1 115
byte 1 101
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 74
byte 1 79
byte 1 73
byte 1 78
byte 1 32
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $983
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $979
byte 1 83
byte 1 80
byte 1 69
byte 1 67
byte 1 84
byte 1 65
byte 1 84
byte 1 79
byte 1 82
byte 1 0
align 1
LABELV $853
byte 1 115
byte 1 110
byte 1 99
byte 1 0
align 1
LABELV $788
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 101
byte 1 116
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $784
byte 1 67
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 73
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 114
byte 1 117
byte 1 112
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $753
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $509
byte 1 37
byte 1 50
byte 1 105
byte 1 0
align 1
LABELV $464
byte 1 37
byte 1 51
byte 1 105
byte 1 32
byte 1 37
byte 1 51
byte 1 105
byte 1 0
align 1
LABELV $461
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 0
align 1
LABELV $394
byte 1 37
byte 1 105
byte 1 58
byte 1 37
byte 1 105
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $390
byte 1 37
byte 1 105
byte 1 102
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $374
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 115
byte 1 110
byte 1 97
byte 1 112
byte 1 58
byte 1 37
byte 1 105
byte 1 32
byte 1 99
byte 1 109
byte 1 100
byte 1 58
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $372
byte 1 110
byte 1 0
align 1
LABELV $107
byte 1 37
byte 1 105
byte 1 0
