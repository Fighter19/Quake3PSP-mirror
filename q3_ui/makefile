TARGET            = ui_psp
OBJS = main.o \
ui_addbots.o ui_atoms.o ui_cdkey.o ui_cinematics.o ui_confirm.o ui_connect.o ui_controls2.o ui_credits.o \
ui_demo2.o ui_display.o ui_gameinfo.o ui_ingame.o ui_loadconfig.o ui_main.o ui_menu.o ui_mfield.o ui_mods.o \
ui_network.o ui_options.o ui_playermodel.o ui_players.o ui_playersettings.o ui_preferences.o ui_qmenu.o \
ui_removebots.o ui_saveconfig.o ui_serverinfo.o ui_servers2.o ui_setup.o ui_sound.o ui_sparena.o ui_specifyserver.o \
ui_splevel.o ui_sppostgame.o ui_spskill.o ui_startserver.o ui_team.o ui_teamorders.o ui_video.o ui_syscalls.o \
../game/q_math.o ../game/q_shared.o ../game/bg_lib.o ../game/bg_misc.o ../game/bg_pmove.o ../game/bg_slidemove.o

BUILD_PRX = 1
PRX_EXPORTS = exports.exp

USE_NEWLIB_LIBC = 1

INCDIR =

CFLAGS = -O3 -G0 -Wall -ffast-math -fno-strict-aliasing -DPSPBLB -D__LCC__ -g
ASFLAGS = $(CFLAGS)

LIBDIR =
LIBS = -lc -lm -lpspuser

LDFLAGS = -mno-crt0 -nostartfiles

PSPSDK=$(shell psp-config --pspsdk-path)
include $(PSPSDK)/lib/build.mak
