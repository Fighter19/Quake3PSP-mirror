TARGET            = qagame_psp

OBJS = main.o \
g_main.o bg_misc.o bg_lib.o bg_pmove.o bg_slidemove.o \
q_math.o q_shared.o ai_dmnet.o ai_dmq3.o ai_team.o ai_main.o ai_chat.o ai_cmd.o g_active.o g_arenas.o g_bot.o \
g_client.o g_cmds.o g_combat.o g_items.o g_mem.o g_misc.o g_missile.o g_mover.o g_session.o \
g_spawn.o g_svcmds.o g_target.o g_team.o g_trigger.o g_utils.o g_weapon.o g_syscalls.o

BUILD_PRX = 1
PRX_EXPORTS = exports.exp

USE_NEWLIB_LIBC = 1

INCDIR =

CFLAGS = -O3 -Os -G0 -Wall -ffast-math -fno-strict-aliasing -DPSPBLB -D__LCC__ -g
ASFLAGS = $(CFLAGS)

LIBDIR =
LIBS = -lc -lm -lpspuser

LDFLAGS = -mno-crt0 -nostartfiles

PSPSDK=$(shell psp-config --pspsdk-path)
include $(PSPSDK)/lib/build.mak
