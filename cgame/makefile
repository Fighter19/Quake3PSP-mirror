TARGET            = cgame_psp

OBJS = main.o \
../game/bg_lib.o ../game/bg_misc.o ../game/bg_pmove.o ../game/bg_slidemove.o \
cg_consolecmds.o cg_draw.o cg_drawtools.o cg_effects.o cg_ents.o cg_event.o cg_info.o \
cg_localents.o cg_main.o cg_marks.o cg_players.o cg_playerstate.o cg_predict.o cg_scoreboard.o \
cg_servercmds.o cg_snapshot.o cg_view.o cg_weapons.o cg_syscalls.o \
../game/q_math.o ../game/q_shared.o


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
