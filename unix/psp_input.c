/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Foobar; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/
#include "../client/client.h"

#include <pspctrl.h>
#include "../unix/keyboard/danzeff.h"

static cvar_t *in_mouse;
static cvar_t *in_dgamouse;
cvar_t *in_subframe;
cvar_t *in_nograb; 
cvar_t   *in_joystick      = NULL;
cvar_t   *in_joystickDebug = NULL;
cvar_t   *joy_threshold    = NULL;

static cvar_t *in_psp_acceleration;
static cvar_t *in_psp_tolerance;
static cvar_t *in_psp_speed;
static cvar_t *in_psp_reset;
static cvar_t *in_psp_keymap;

static qboolean mouse_avail;
static qboolean mouse_active = qfalse;

static int keystate[256];
static int keytime = 0;
static int oldmx = 0, oldmy = 0;
static int mwx, mwy;

float IN_CalcInput(int axis, float speed, float tolerance, float acceleration)
{
	float value = ((float) axis / 128.0f) - 1.0f;

	if (value == 0.0f)
	{
		return 0.0f;
	}

	float abs_value = fabs(value);

	if (abs_value < tolerance)
	{
		return 0.0f;
	}

	abs_value -= tolerance;
	abs_value /= (1.0f - tolerance);
	abs_value = powf(abs_value, acceleration);
	abs_value *= speed;

	if (value < 0.0f)
	{
		value = -abs_value;
	}
	else
	{
		value = abs_value;
	}
	return value;
}

static void keymap(int key1, int key, qboolean down, int repeattime)
{
	if(down)
	{
		if(keystate[key] == 0)
		{
            Sys_QueEvent(keytime, key1, key, qtrue, 0, NULL);
			keystate[key] = keytime;
		}
		else if(repeattime > 0 && keystate[key] + repeattime < keytime)
		{
			Sys_QueEvent(keytime, key1, key, qtrue, 0, NULL);
			keystate[key] += keytime / 2;
		}

	}
	else
	{

		if(keystate[key] != 0)
		{
			Sys_QueEvent(keytime, key1, key, qfalse, 0, NULL);
			keystate[key] = 0;
		}
	}
}

void IN_ActivateMouse( void )
{
/*
  if (!mouse_avail)
    return;

  if (!mouse_active)
  {
		if (in_dgamouse->value) // force dga mouse to 0 if using nograb
			riCvar_Set("in_dgamouse", "0");
        mouse_active = qtrue;
  }
*/
}

void IN_DeactivateMouse( void )
{
/*
  if (!mouse_avail)
    return;

  if (mouse_active)
  {
		if (in_dgamouse->value) // force dga mouse to 0 if using nograb
			ri.Cvar_Set("in_dgamouse", "0");
    mouse_active = qfalse;
  }
*/
}

void IN_Init(void)
{
  memset(keystate, 0, sizeof(keystate));

  Com_Printf ("\n------- Input Initialization -------\n");

  // mouse variables
  in_mouse            = Cvar_Get ("in_mouse", "1",    CVAR_ARCHIVE);
  in_dgamouse         = Cvar_Get ("in_dgamouse", "1", CVAR_ARCHIVE);

  // turn on-off sub-frame timing of X events
  in_subframe         = Cvar_Get ("in_subframe", "0", CVAR_ARCHIVE);

  // developer feature, allows to break without loosing mouse pointer
  in_nograb           = Cvar_Get ("in_nograb", "0", 0);

  // bk001130 - from cvs.17 (mkv), joystick variables
  in_joystick         = Cvar_Get ("in_joystick", "0", CVAR_ARCHIVE|CVAR_LATCH);

  // bk001130 - changed this to match win32
  in_joystickDebug    = Cvar_Get ("in_debugjoystick", "0", CVAR_TEMP);
  joy_threshold       = Cvar_Get ("joy_threshold", "0.15", CVAR_ARCHIVE); // FIXME: in_joythreshold

  //psp input setups
  in_psp_acceleration = Cvar_Get ("in_psp_acceleration", "3",    CVAR_ARCHIVE);
  in_psp_tolerance    = Cvar_Get ("in_psp_tolerance",    "0.25", CVAR_ARCHIVE);
  in_psp_speed        = Cvar_Get ("in_psp_speed",        "5",    CVAR_ARCHIVE);
  in_psp_reset        = Cvar_Get ("in_psp_reset",        "25",   CVAR_ARCHIVE);
  in_psp_keymap       = Cvar_Get ("in_psp_keymap",       "0",    CVAR_ARCHIVE);

  sceCtrlSetSamplingCycle(0);
  sceCtrlSetSamplingMode(PSP_CTRL_MODE_ANALOG);

  //if (in_mouse->value)
  // mouse_avail = qtrue;
  //else
  //  mouse_avail = qfalse;

  mouse_active = qtrue;

  Com_Printf ("------------------------------------\n");
}

void IN_Shutdown(void)
{
  mouse_avail = qfalse;
  mouse_active = qfalse;
}

int keyb_init = 0;
static int mouseResetTime = 0;
#define MOUSE_RESET_DELAY 30  //default(50)

void IN_MouseMove(void)
{
	if(keyb_init)
	   return;
	   
	SceCtrlData pad;
	sceCtrlPeekBufferPositive(&pad, 1);

	int balldx = 0;
	int balldy = 0;

    int t = 0; // default to 0 in case we don't set
	if((in_psp_keymap->value) && !(cls.keyCatchers & KEYCATCH_UI) && !(cls.keyCatchers & KEYCATCH_CONSOLE))
	{
		int speed = in_psp_speed->value;
		if(pad.Buttons & PSP_CTRL_SQUARE)
	    {
	      balldx -= speed;
	    }
		if(pad.Buttons & PSP_CTRL_CIRCLE)
		{
	      balldx += speed;
	    }
		if(pad.Buttons & PSP_CTRL_CROSS)
		{
	      balldy += speed;
	    }
		if(pad.Buttons & PSP_CTRL_TRIANGLE)
		{
	      balldy -= speed;
	    }
	}
	else
	{
	   balldx = IN_CalcInput(pad.Lx, in_psp_speed->value, in_psp_tolerance->value, in_psp_acceleration->value);
	   balldy = IN_CalcInput(pad.Ly, in_psp_speed->value, in_psp_tolerance->value, in_psp_acceleration->value);
    }
    
	if (balldx || balldy)
	{
        t = Sys_Milliseconds();
        if (t - mouseResetTime > in_psp_reset->value )
        {
            Sys_QueEvent( t, SE_MOUSE, balldx, balldy, 0, NULL );
            mouseResetTime = Sys_Milliseconds();
        }
	}

}

extern int gpu_init;

void IN_Frame (void)
{
/*
	  if ( cls.keyCatchers & KEYCATCH_CONSOLE )
	  {
	    // temporarily deactivate if not in the game and
	    // running on the desktop
	    // voodoo always counts as full screen
	    if (Cvar_VariableValue ("r_fullscreen") == 0
	        && strcmp( Cvar_VariableString("r_glDriver"), _3DFX_DRIVER_NAME ) )
	    {
	      IN_DeactivateMouse ();
	      return;
	    }
	  }
      IN_ActivateMouse();
*/
	  //if(!gpu_init)
	//	  return;
		  
	  IN_MouseMove();
}

void IN_Activate(void)
{

}

void IN_InitKeyboard (void)
{
    danzeff_load(); 
    danzeff_moveTo(330,0);
    keyb_init = 1;
}

void IN_ShutdownKeyboard (void)
{
    danzeff_free();
    keyb_init = 0;
}

void Sys_SendKeyEvents (void)
{
 	keytime = Sys_Milliseconds();
	  
	SceCtrlData pad;
	sceCtrlPeekBufferPositive(&pad, 1);

	if((qboolean)((pad.Buttons & PSP_CTRL_LEFT) && (pad.Buttons & PSP_CTRL_LTRIGGER)))
	{
		if(keyb_init == 0)
		{
		  IN_InitKeyboard();

		  if(!danzeff_isinitialized())
              keyb_init = 0;
		}
	}

    if(keyb_init && danzeff_isinitialized())
	{
	    int inpt = danzeff_readInput(pad);
		if (inpt == DANZEFF_RIGHT)
		{
		   IN_ShutdownKeyboard();
		}
		else if(inpt != 0)
		{
		  Sys_QueEvent(0, SE_CHAR, inpt, 0, 0, NULL);
		}
	    return;
	}

	if((in_psp_keymap->value) && !(cls.keyCatchers & KEYCATCH_UI) && !(cls.keyCatchers & KEYCATCH_CONSOLE))
	{
	    int x = IN_CalcInput(pad.Lx, 3, in_psp_tolerance->value, 3);
	    int y = IN_CalcInput(pad.Ly, 3, in_psp_tolerance->value, 3);
		keymap(SE_KEY, K_TAB,       (x <= -1) ? 1 : 0,         250);
		keymap(SE_KEY, K_INS,       (x >=  1) ? 1 : 0,         250);
		keymap(SE_KEY, K_ENTER,     (y >=  1) ? 1 : 0,         250);
		keymap(SE_KEY, K_DEL,       (y <= -1) ? 1 : 0,         250);
	}
	else
	{
        keymap(SE_KEY, K_TAB,           pad.Buttons & PSP_CTRL_SQUARE,	  250);
        keymap(SE_KEY, K_INS,           pad.Buttons & PSP_CTRL_CIRCLE,    250);
	    keymap(SE_KEY, K_ENTER,         pad.Buttons & PSP_CTRL_CROSS,     250);
	    keymap(SE_KEY, K_DEL,           pad.Buttons & PSP_CTRL_TRIANGLE,  250);
	}

	keymap(SE_KEY, K_LEFTARROW,     pad.Buttons & PSP_CTRL_LEFT,      250);
	keymap(SE_KEY, K_RIGHTARROW,    pad.Buttons & PSP_CTRL_RIGHT,     250);
	keymap(SE_KEY, K_DOWNARROW,     pad.Buttons & PSP_CTRL_DOWN,      250);
	keymap(SE_KEY, K_UPARROW,       pad.Buttons & PSP_CTRL_UP,        250);
	keymap(SE_KEY, K_MWHEELDOWN,	pad.Buttons & PSP_CTRL_LTRIGGER,  250);
	keymap(SE_KEY, K_MWHEELUP,	    pad.Buttons & PSP_CTRL_RTRIGGER,  250);
	keymap(SE_KEY, K_ESCAPE,        pad.Buttons & PSP_CTRL_START,     250);
	keymap(SE_KEY, '~',             pad.Buttons & PSP_CTRL_SELECT,    250);
 
}

