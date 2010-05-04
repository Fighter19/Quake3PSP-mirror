TARGET            = q3ded
EXTRA_TARGETS     = EBOOT.PBP
PSP_EBOOT_TITLE   = PSP Quake 3 PRJ
PSP_EBOOT_ICON    = icon.png
PSP_EBOOT_PIC1    = pic.png
PSP_LARGE_MEMORY  = 1
PSP_FW_VERSION    = 500
BUILD_PRX		  = 1

CC = psp-gcc
CXX = psp-g++

INCDIR =
#CFLAGS = -O3 -G0 -Wall -fno-strict-aliasing -D__linux__
#CFLAGS = -O6 -G0 -fomit-frame-pointer -pipe -ffast-math -fno-strict-aliasing -fstrength-reduce -D__linux__
CFLAGS = \
-O3 -G0 -Wall \
-pipe -DNDEBUG \
-ffast-math -fno-strict-aliasing \
-fstrength-reduce \
-D__linux__ -DPSP_VFPU -DWITH_NET

CXXFLAGS = $(CFLAGS) -fno-rtti -Wcast-qual
ASFLAGS = $(CFLAGS) -c
LDFLAGS =
LIBDIR = 

LIBS = -lpspvram -lpspgum_vfpu -lpspmath \
-lpspvfpu -lpspgu -lpsphprm -lpspdebug -lpspaudiolib -lpspaudio  -lpsprtc \
-lpspdisplay -lpspge -lpspctrl -lpspsdk -lc -lpspnet -lpspnet_apctl \
-lpspnet_adhoc -lpspnet_adhocctl \
-lpspnet_resolver -lpsputility -lpspuser -lpspkubridge \
-lpspwlan -lstdc++ -lm -lpsppower -lpng -lz -lpspsystemctrl_kernel \


B=bin
SDIR=server
CMDIR=qcommon
BLIBDIR=botlib
UDIR=unix
CDIR=client
NDIR=null
GDIR=game
CGDIR=cgame
Q3UIDIR=q3_ui
UIDIR=ui
RDIR=renderer
JPDIR=jpeg-6

SHLIBCFLAGS=-fPIC
DO_CXX=$(CXX) $(CXXFLAGS) -c $< -o $@
DO_DED_CC=$(CC) $(CFLAGS) -o $@ -c $<
DO_CC=$(CC) $(CFLAGS) -o $@ -c $<
DO_BOT_CC=$(CC) $(CFLAGS) -DBOTLIB  -o $@ -c $<
DO_SHLIB_CC=$(CC) $(CFLAGS) $(SHLIBCFLAGS) -o $@ -c $<

OBJS = \
	$(B)/cl_cgame.o \
	$(B)/cl_cin.o \
	$(B)/cl_console.o \
	$(B)/cl_input.o \
	$(B)/cl_keys.o \
	$(B)/cl_main.o \
	$(B)/cl_net_chan.o \
	$(B)/cl_parse.o \
	$(B)/cl_scrn.o \
	$(B)/cl_ui.o \
	\
	$(B)/cm_load.o \
	$(B)/cm_patch.o \
	$(B)/cm_polylib.o \
	$(B)/cm_test.o \
	$(B)/cm_trace.o \
	\
	$(B)/cmd.o \
	$(B)/common.o \
	$(B)/cvar.o \
	$(B)/files.o \
	$(B)/md4.o \
	$(B)/msg.o \
	$(B)/huffman.o \
	\
	$(B)/snd_adpcm.o \
	$(B)/snd_dma.o \
	$(B)/snd_mem.o \
	$(B)/snd_mix.o \
	$(B)/snd_wavelet.o \
	\
	$(B)/sv_bot.o \
	$(B)/sv_ccmds.o \
	$(B)/sv_client.o \
	$(B)/sv_game.o \
	$(B)/sv_init.o \
	$(B)/sv_main.o \
	$(B)/sv_net_chan.o \
	$(B)/sv_snapshot.o \
	$(B)/sv_world.o \
	\
	$(B)/q_math.o \
	$(B)/q_shared.o \
	\
	$(B)/unzip.o \
	$(B)/ioctrl.o \
	$(B)/vm.o \
	$(B)/vm_interpreted.o \
	$(B)/vm_psp.o \
	\
	$(B)/be_aas_bspq3.o \
	$(B)/be_aas_cluster.o \
	$(B)/be_aas_debug.o \
	$(B)/be_aas_entity.o \
	$(B)/be_aas_file.o \
	$(B)/be_aas_main.o \
	$(B)/be_aas_move.o \
	$(B)/be_aas_optimize.o \
	$(B)/be_aas_reach.o \
	$(B)/be_aas_route.o \
	$(B)/be_aas_routealt.o \
	$(B)/be_aas_sample.o \
	$(B)/be_ai_char.o \
	$(B)/be_ai_chat.o \
	$(B)/be_ai_gen.o \
	$(B)/be_ai_goal.o \
	$(B)/be_ai_move.o \
	$(B)/be_ai_weap.o \
	$(B)/be_ai_weight.o \
	$(B)/be_ea.o \
	$(B)/be_interface.o \
	$(B)/l_crc.o \
	$(B)/l_libvar.o \
	$(B)/l_log.o \
	$(B)/l_memory.o \
	$(B)/l_precomp.o \
	$(B)/l_script.o \
	$(B)/l_struct.o \
	\
	$(B)/jcapimin.o \
	$(B)/jchuff.o   \
	$(B)/jcinit.o \
	$(B)/jccoefct.o  \
	$(B)/jccolor.o \
	$(B)/jfdctflt.o \
	$(B)/jcdctmgr.o \
	$(B)/jcphuff.o \
	$(B)/jcmainct.o \
	$(B)/jcmarker.o \
	$(B)/jcmaster.o \
	$(B)/jcomapi.o \
	$(B)/jcparam.o \
	$(B)/jcprepct.o \
	$(B)/jcsample.o \
	$(B)/jdapimin.o \
	$(B)/jdapistd.o \
	$(B)/jdatasrc.o \
	$(B)/jdcoefct.o \
	$(B)/jdcolor.o \
	$(B)/jddctmgr.o \
	$(B)/jdhuff.o \
	$(B)/jdinput.o \
	$(B)/jdmainct.o \
	$(B)/jdmarker.o \
	$(B)/jdmaster.o \
	$(B)/jdpostct.o \
	$(B)/jdsample.o \
	$(B)/jdtrans.o \
	$(B)/jerror.o \
	$(B)/jidctflt.o \
	$(B)/jmemmgr.o \
	$(B)/jmemnobs.o \
	$(B)/jutils.o \
	\
	$(B)/tr_animation.o \
	$(B)/tr_backend.o \
	$(B)/tr_bsp.o \
	$(B)/tr_cmds.o \
	$(B)/tr_curve.o \
	$(B)/tr_flares.o \
	$(B)/tr_font.o \
	$(B)/tr_image.o \
	$(B)/tr_init.o \
	$(B)/tr_light.o \
	$(B)/tr_main.o \
	$(B)/tr_marks.o \
	$(B)/tr_mesh.o \
	$(B)/tr_model.o \
	$(B)/tr_noise.o \
	$(B)/tr_scene.o \
	$(B)/tr_shade.o \
	$(B)/tr_shade_calc.o \
	$(B)/tr_shader.o \
	$(B)/tr_shadows.o \
	$(B)/tr_sky.o \
	$(B)/tr_surface.o \
	$(B)/tr_world.o \
	$(B)/tr_dxtn.o \
	$(B)/clipping.o \
	$(B)/math.o \
	\
	$(B)/unix_main.o \
	$(B)/unix_shared.o \
	$(B)/gethost.o \
	$(B)/danzeff.o \
	$(B)/psp_input.o \
	$(B)/psp_snddma.o \
	$(B)/unix_net.o \
	$(B)/glimp.o \
	$(B)/net_chan.o \
	$(B)/linux_common.o \
	\
      $(B)/sceDmac.o \
      $(B)/moduleAPI.o
	#$(B)/prof.o \
	#$(B)/mcount.o \
	#$(B)/g_rankings.o
	
PSPSDK=$(shell psp-config --pspsdk-path)
include $(PSPSDK)/lib/build.mak

$(B)/cl_cgame.o : $(CDIR)/cl_cgame.c; $(DO_CC)  
$(B)/cl_cin.o : $(CDIR)/cl_cin.c; $(DO_CC)  
$(B)/cl_console.o : $(CDIR)/cl_console.c; $(DO_CC)  
$(B)/cl_input.o : $(CDIR)/cl_input.c; $(DO_CC)  
$(B)/cl_keys.o : $(CDIR)/cl_keys.c; $(DO_CC)  
$(B)/cl_main.o : $(CDIR)/cl_main.c; $(DO_CC)  
$(B)/cl_net_chan.o : $(CDIR)/cl_net_chan.c; $(DO_CC)  
$(B)/cl_parse.o : $(CDIR)/cl_parse.c; $(DO_CC)  
$(B)/cl_scrn.o : $(CDIR)/cl_scrn.c; $(DO_CC)     
$(B)/cl_ui.o : $(CDIR)/cl_ui.c; $(DO_CC)            
$(B)/snd_adpcm.o : $(CDIR)/snd_adpcm.c; $(DO_CC)    
$(B)/snd_dma.o : $(CDIR)/snd_dma.c; $(DO_CC)        
$(B)/snd_mem.o : $(CDIR)/snd_mem.c; $(DO_CC)         
$(B)/snd_mix.o : $(CDIR)/snd_mix.c; $(DO_CC)        
$(B)/snd_wavelet.o : $(CDIR)/snd_wavelet.c; $(DO_CC)  
$(B)/sv_bot.o : $(SDIR)/sv_bot.c; $(DO_CC) 
$(B)/sv_client.o : $(SDIR)/sv_client.c; $(DO_CC) 
$(B)/sv_ccmds.o : $(SDIR)/sv_ccmds.c; $(DO_CC) 
$(B)/sv_game.o : $(SDIR)/sv_game.c; $(DO_CC) 
$(B)/sv_init.o : $(SDIR)/sv_init.c; $(DO_CC) 
$(B)/sv_main.o : $(SDIR)/sv_main.c; $(DO_CC) 
$(B)/sv_net_chan.o : $(SDIR)/sv_net_chan.c; $(DO_CC) 
$(B)/sv_snapshot.o : $(SDIR)/sv_snapshot.c; $(DO_CC) 
$(B)/sv_world.o : $(SDIR)/sv_world.c; $(DO_CC) 
$(B)/cm_load.o : $(CMDIR)/cm_load.c; $(DO_CC) 
$(B)/cm_polylib.o : $(CMDIR)/cm_polylib.c; $(DO_CC) 
$(B)/cm_test.o : $(CMDIR)/cm_test.c; $(DO_CC) 
$(B)/cm_trace.o : $(CMDIR)/cm_trace.c; $(DO_CC) 

$(B)/cg_consolecmds.o : $(CGDIR)/cg_consolecmds.c; $(DO_CC)        
$(B)/cg_draw.o : $(CGDIR)/cg_draw.c; $(DO_CC)              
$(B)/cg_drawtools.o : $(CGDIR)/cg_drawtools.c; $(DO_CC)         
$(B)/cg_effects.o : $(CGDIR)/cg_effects.c; $(DO_CC)            
$(B)/cg_ents.o : $(CGDIR)/cg_ents.c; $(DO_CC)                
$(B)/cg_event.o : $(CGDIR)/cg_event.c; $(DO_CC)             
$(B)/cg_info.o : $(CGDIR)/cg_info.c; $(DO_CC)                
$(B)/cg_localents.o : $(CGDIR)/cg_localents.c; $(DO_CC)            
$(B)/cg_main.o : $(CGDIR)/cg_main.c; $(DO_CC)                    
$(B)/cg_marks.o : $(CGDIR)/cg_marks.c; $(DO_CC)                  
$(B)/cg_players.o : $(CGDIR)/cg_players.c; $(DO_CC)              
$(B)/cg_playerstate.o : $(CGDIR)/cg_playerstate.c; $(DO_CC)         
$(B)/cg_predict.o : $(CGDIR)/cg_predict.c; $(DO_CC)         
$(B)/cg_scoreboard.o : $(CGDIR)/cg_scoreboard.c; $(DO_CC)         
$(B)/cg_servercmds.o : $(CGDIR)/cg_servercmds.c; $(DO_CC)         
$(B)/cg_snapshot.o : $(CGDIR)/cg_snapshot.c; $(DO_CC)              
$(B)/cg_syscalls.o : $(CGDIR)/cg_syscalls.c; $(DO_CC)         
$(B)/cg_view.o : $(CGDIR)/cg_view.c; $(DO_CC)                      
$(B)/cg_weapons.o : $(CGDIR)/cg_weapons.c; $(DO_CC)  


$(B)/cm_patch.o : $(CMDIR)/cm_patch.c; $(DO_CC) 
$(B)/cmd.o : $(CMDIR)/cmd.c; $(DO_CC) 
$(B)/common.o : $(CMDIR)/common.c; $(DO_CC)
$(B)/cvar.o : $(CMDIR)/cvar.c; $(DO_CC) 
$(B)/files.o : $(CMDIR)/files.c; $(DO_CC) 
$(B)/md4.o : $(CMDIR)/md4.c; $(DO_CC) 
$(B)/msg.o : $(CMDIR)/msg.c; $(DO_CC) 
$(B)/net_chan.o : $(CMDIR)/net_chan.c; $(DO_CC) 
$(B)/huffman.o : $(CMDIR)/huffman.c; $(DO_CC) 
$(B)/q_shared.o : $(GDIR)/q_shared.c; $(DO_CC) 
$(B)/q_math.o : $(GDIR)/q_math.c; $(DO_CC) 
$(B)/ai_chat.o :  $(GDIR)/ai_chat.c; $(DO_CC) 
$(B)/ai_cmd.o :  $(GDIR)/ai_cmd.c; $(DO_CC) 
$(B)/ai_dmnet.o :  $(GDIR)/ai_dmnet.c; $(DO_CC) 
$(B)/ai_dmq3.o :  $(GDIR)/ai_dmq3.c; $(DO_CC) 
$(B)/ai_main.o :  $(GDIR)/ai_main.c; $(DO_CC) 
$(B)/ai_team.o :  $(GDIR)/ai_team.c; $(DO_CC) 
$(B)/ai_vcmd.o :  $(GDIR)/ai_vcmd.c; $(DO_CC) 
$(B)/bg_lib.o :  $(GDIR)/bg_lib.c; $(DO_CC) 
$(B)/bg_misc.o :  $(GDIR)/bg_misc.c; $(DO_CC) 
$(B)/bg_pmove.o :  $(GDIR)/bg_pmove.c; $(DO_CC) 
$(B)/bg_slidemove.o :  $(GDIR)/bg_slidemove.c; $(DO_CC) 
$(B)/g_active.o :  $(GDIR)/g_active.c; $(DO_CC) 
$(B)/g_arenas.o :  $(GDIR)/g_arenas.c; $(DO_CC) 
$(B)/g_bot.o :  $(GDIR)/g_bot.c; $(DO_CC) 
$(B)/g_client.o :  $(GDIR)/g_client.c; $(DO_CC) 
$(B)/g_cmds.o :  $(GDIR)/g_cmds.c; $(DO_CC) 
$(B)/g_combat.o :  $(GDIR)/g_combat.c; $(DO_CC) 
$(B)/g_items.o :  $(GDIR)/g_items.c; $(DO_CC) 
$(B)/g_main.o :  $(GDIR)/g_main.c; $(DO_CC) 
$(B)/g_mem.o :  $(GDIR)/g_mem.c; $(DO_CC) 
$(B)/g_misc.o :  $(GDIR)/g_misc.c; $(DO_CC) 
$(B)/g_missile.o :  $(GDIR)/g_missile.c; $(DO_CC) 
$(B)/g_mover.o :  $(GDIR)/g_mover.c; $(DO_CC) 
$(B)/g_rankings.o :  $(GDIR)/g_rankings.c; $(DO_CC) 
$(B)/g_session.o :  $(GDIR)/g_session.c; $(DO_CC) 
$(B)/g_spawn.o :  $(GDIR)/g_spawn.c; $(DO_CC) 
$(B)/g_svcmds.o :  $(GDIR)/g_svcmds.c; $(DO_CC) 
$(B)/g_syscalls.o :  $(GDIR)/g_syscalls.c; $(DO_CC) 
$(B)/g_target.o : $(GDIR)/g_target.c; $(DO_CC) 
$(B)/g_team.o : $(GDIR)/g_team.c; $(DO_CC) 
$(B)/g_trigger.o : $(GDIR)/g_trigger.c; $(DO_CC) 
$(B)/g_utils.o : $(GDIR)/g_utils.c; $(DO_CC) 
$(B)/g_weapon.o : $(GDIR)/g_weapon.c; $(DO_CC) 
$(B)/be_aas_bspq3.o : $(BLIBDIR)/be_aas_bspq3.c; $(DO_BOT_CC)
$(B)/be_aas_cluster.o : $(BLIBDIR)/be_aas_cluster.c; $(DO_BOT_CC)
$(B)/be_aas_debug.o : $(BLIBDIR)/be_aas_debug.c; $(DO_BOT_CC)
$(B)/be_aas_entity.o : $(BLIBDIR)/be_aas_entity.c; $(DO_BOT_CC)
$(B)/be_aas_file.o : $(BLIBDIR)/be_aas_file.c; $(DO_BOT_CC)
$(B)/be_aas_main.o : $(BLIBDIR)/be_aas_main.c; $(DO_BOT_CC)
$(B)/be_aas_move.o : $(BLIBDIR)/be_aas_move.c; $(DO_BOT_CC)
$(B)/be_aas_optimize.o : $(BLIBDIR)/be_aas_optimize.c; $(DO_BOT_CC)
$(B)/be_aas_reach.o : $(BLIBDIR)/be_aas_reach.c; $(DO_BOT_CC)
$(B)/be_aas_route.o : $(BLIBDIR)/be_aas_route.c; $(DO_BOT_CC)
$(B)/be_aas_routealt.o : $(BLIBDIR)/be_aas_routealt.c; $(DO_BOT_CC)
$(B)/be_aas_sample.o : $(BLIBDIR)/be_aas_sample.c; $(DO_BOT_CC)
$(B)/be_ai_char.o : $(BLIBDIR)/be_ai_char.c; $(DO_BOT_CC)
$(B)/be_ai_chat.o : $(BLIBDIR)/be_ai_chat.c; $(DO_BOT_CC)
$(B)/be_ai_gen.o : $(BLIBDIR)/be_ai_gen.c; $(DO_BOT_CC)
$(B)/be_ai_goal.o : $(BLIBDIR)/be_ai_goal.c; $(DO_BOT_CC)
$(B)/be_ai_move.o : $(BLIBDIR)/be_ai_move.c; $(DO_BOT_CC)
$(B)/be_ai_weap.o : $(BLIBDIR)/be_ai_weap.c; $(DO_BOT_CC)
$(B)/be_ai_weight.o : $(BLIBDIR)/be_ai_weight.c; $(DO_BOT_CC)
$(B)/be_ea.o : $(BLIBDIR)/be_ea.c; $(DO_BOT_CC)
$(B)/be_interface.o : $(BLIBDIR)/be_interface.c; $(DO_BOT_CC)
$(B)/l_cmd.o : bspc/l_cmd_modified.c; $(DO_BOT_CC)
$(B)/l_crc.o : $(BLIBDIR)/l_crc.c; $(DO_BOT_CC)
$(B)/l_libvar.o : $(BLIBDIR)/l_libvar.c; $(DO_BOT_CC)
$(B)/l_log.o : $(BLIBDIR)/l_log.c; $(DO_BOT_CC)
$(B)/l_memory.o : $(BLIBDIR)/l_memory.c; $(DO_BOT_CC)
$(B)/l_precomp.o : $(BLIBDIR)/l_precomp.c; $(DO_BOT_CC)
$(B)/l_script.o : $(BLIBDIR)/l_script.c; $(DO_BOT_CC)
$(B)/l_struct.o : $(BLIBDIR)/l_struct.c; $(DO_BOT_CC)

$(B)/linux_common.o : $(UDIR)/linux_common.c; $(DO_CC) 
$(B)/unix_main.o : $(UDIR)/unix_main.cpp; $(DO_CXX)
$(B)/gethost.o : $(UDIR)/gethost.cpp; $(DO_CXX)
$(B)/prof.o : $(UDIR)/prof.c; $(DO_CC)
$(B)/mcount.o : $(UDIR)/mcount.S; $(DO_AS)
$(B)/unix_net.o : $(UDIR)/unix_net.c; $(DO_CC)
$(B)/exception.o : $(UDIR)/exception.c; $(DO_CC)
$(B)/moduleAPI.o : $(UDIR)/moduleAPI.S; $(DO_CC)
$(B)/sceDmac.o : $(UDIR)/sceDmac.S; $(DO_CC)
$(B)/sceKernelMutex.o : $(UDIR)/sceKernelMutex.S; $(DO_CC)
$(B)/unix_shared.o : $(UDIR)/unix_shared.c; $(DO_CC) 
$(B)/danzeff.o : $(UDIR)/keyboard/danzeff.c; $(DO_CC) 
$(B)/pspctrl_emu.o : $(UDIR)/keyboard/pspctrl_emu.c; $(DO_CC) 
$(B)/glimp.o : $(UDIR)/glimp.cpp; $(DO_CXX) 
$(B)/null_client.o : $(NDIR)/null_client.c; $(DO_CC) 
$(B)/psp_input.o : $(UDIR)/psp_input.c; $(DO_CC)
$(B)/psp_snddma.o : $(UDIR)/psp_snddma.cpp; $(DO_CXX)
$(B)/unzip.o : $(CMDIR)/unzip.c; $(DO_CC) 
$(B)/ioctrl.o : $(CMDIR)/ioctrl.c; $(DO_CC)
$(B)/vm.o : $(CMDIR)/vm.c; $(DO_CC) 
$(B)/vm_interpreted.o : $(CMDIR)/vm_interpreted.c; $(DO_CC) 
$(B)/vm_psp.o : $(CMDIR)/vm_psp.c; $(DO_CC) 

$(B)/ui_addbots.o : $(Q3UIDIR)/ui_addbots.c; $(DO_CC)  
$(B)/ui_atoms.o : $(Q3UIDIR)/ui_atoms.c; $(DO_CC)  
$(B)/ui_cinematics.o : $(Q3UIDIR)/ui_cinematics.c; $(DO_CC)  
$(B)/ui_cdkey.o : $(Q3UIDIR)/ui_cdkey.c; $(DO_CC) 
$(B)/ui_confirm.o : $(Q3UIDIR)/ui_confirm.c; $(DO_CC)  
$(B)/ui_connect.o : $(Q3UIDIR)/ui_connect.c; $(DO_CC)  
$(B)/ui_controls2.o : $(Q3UIDIR)/ui_controls2.c; $(DO_CC)  
$(B)/ui_credits.o : $(Q3UIDIR)/ui_credits.c; $(DO_CC)  
$(B)/ui_demo2.o : $(Q3UIDIR)/ui_demo2.c; $(DO_CC)  
$(B)/ui_display.o : $(Q3UIDIR)/ui_display.c; $(DO_CC)  
$(B)/ui_gameinfo.o : $(Q3UIDIR)/ui_gameinfo.c; $(DO_CC)  
$(B)/ui_ingame.o : $(Q3UIDIR)/ui_ingame.c; $(DO_CC)  
$(B)/ui_loadconfig.o : $(Q3UIDIR)/ui_loadconfig.c; $(DO_CC)  
$(B)/ui_main.o : $(Q3UIDIR)/ui_main.c; $(DO_CC)  
$(B)/ui_menu.o : $(Q3UIDIR)/ui_menu.c; $(DO_CC)  
$(B)/ui_mfield.o : $(Q3UIDIR)/ui_mfield.c; $(DO_CC)  
$(B)/ui_mods.o : $(Q3UIDIR)/ui_mods.c; $(DO_CC)  
$(B)/ui_network.o : $(Q3UIDIR)/ui_network.c; $(DO_CC)  
$(B)/ui_options.o : $(Q3UIDIR)/ui_options.c; $(DO_CC) 
$(B)/ui_playermodel.o : $(Q3UIDIR)/ui_playermodel.c; $(DO_CC)  
$(B)/ui_players.o : $(Q3UIDIR)/ui_players.c; $(DO_CC)  
$(B)/ui_playersettings.o : $(Q3UIDIR)/ui_playersettings.c; $(DO_CC)  
$(B)/ui_preferences.o : $(Q3UIDIR)/ui_preferences.c; $(DO_CC)  
$(B)/ui_qmenu.o : $(Q3UIDIR)/ui_qmenu.c; $(DO_CC)  
$(B)/ui_quit.o : $(Q3UIDIR)/ui_quit.c; $(DO_CC)  
$(B)/ui_removebots.o : $(Q3UIDIR)/ui_removebots.c; $(DO_CC)  
$(B)/ui_saveconfig.o : $(Q3UIDIR)/ui_saveconfig.c; $(DO_CC)  
$(B)/ui_serverinfo.o : $(Q3UIDIR)/ui_serverinfo.c; $(DO_CC)  
$(B)/ui_servers2.o : $(Q3UIDIR)/ui_servers2.c; $(DO_CC)  
$(B)/ui_setup.o : $(Q3UIDIR)/ui_setup.c; $(DO_CC)  
$(B)/ui_sound.o : $(Q3UIDIR)/ui_sound.c; $(DO_CC)  
$(B)/ui_sparena.o : $(Q3UIDIR)/ui_sparena.c; $(DO_CC)  
$(B)/ui_specifyserver.o : $(Q3UIDIR)/ui_specifyserver.c; $(DO_CC)  
$(B)/ui_splevel.o : $(Q3UIDIR)/ui_splevel.c; $(DO_CC)  
$(B)/ui_sppostgame.o : $(Q3UIDIR)/ui_sppostgame.c; $(DO_CC)  
$(B)/ui_spskill.o : $(Q3UIDIR)/ui_spskill.c; $(DO_CC)  
$(B)/ui_startserver.o : $(Q3UIDIR)/ui_startserver.c; $(DO_CC)  
$(B)/ui_team.o : $(Q3UIDIR)/ui_team.c; $(DO_CC)  
$(B)/ui_teamorders.o : $(Q3UIDIR)/ui_teamorders.c; $(DO_CC)  
$(B)/ui_syscalls.o : $(Q3UIDIR)/ui_syscalls.c; $(DO_CC)  
$(B)/ui_video.o : $(Q3UIDIR)/ui_video.c; $(DO_CC)  

$(B)/jcapimin.o : $(JPDIR)/jcapimin.c; $(DO_CC)  
$(B)/jchuff.o : $(JPDIR)/jchuff.c; $(DO_CC)  
$(B)/jcinit.o : $(JPDIR)/jcinit.c; $(DO_CC)  
$(B)/jccoefct.o : $(JPDIR)/jccoefct.c; $(DO_CC)  
$(B)/jccolor.o : $(JPDIR)/jccolor.c; $(DO_CC)  
$(B)/jfdctflt.o : $(JPDIR)/jfdctflt.c; $(DO_CC)  
$(B)/jcdctmgr.o : $(JPDIR)/jcdctmgr.c; $(DO_CC)  
$(B)/jcmainct.o : $(JPDIR)/jcmainct.c; $(DO_CC)  
$(B)/jcmarker.o : $(JPDIR)/jcmarker.c; $(DO_CC)  
$(B)/jcmaster.o : $(JPDIR)/jcmaster.c; $(DO_CC)  
$(B)/jcomapi.o : $(JPDIR)/jcomapi.c; $(DO_CC) 
$(B)/jcparam.o : $(JPDIR)/jcparam.c;  $(DO_CC) 
$(B)/jcprepct.o : $(JPDIR)/jcprepct.c; $(DO_CC) 
$(B)/jcsample.o : $(JPDIR)/jcsample.c; $(DO_CC)  

$(B)/jdapimin.o : $(JPDIR)/jdapimin.c; $(DO_CC)  
$(B)/jdapistd.o : $(JPDIR)/jdapistd.c; $(DO_CC)  
$(B)/jdatasrc.o : $(JPDIR)/jdatasrc.c; $(DO_CC)  
$(B)/jdcoefct.o : $(JPDIR)/jdcoefct.c; $(DO_CC)  
$(B)/jdcolor.o : $(JPDIR)/jdcolor.c; $(DO_CC)  
$(B)/jcphuff.o : $(JPDIR)/jcphuff.c; $(DO_CC)  
$(B)/jddctmgr.o : $(JPDIR)/jddctmgr.c; $(DO_CC)  
$(B)/jdhuff.o : $(JPDIR)/jdhuff.c; $(DO_CC)  
$(B)/jdinput.o : $(JPDIR)/jdinput.c; $(DO_CC)  
$(B)/jdmainct.o : $(JPDIR)/jdmainct.c; $(DO_CC)  
$(B)/jdmarker.o : $(JPDIR)/jdmarker.c; $(DO_CC)  
$(B)/jdmaster.o : $(JPDIR)/jdmaster.c; $(DO_CC)  
$(B)/jdpostct.o : $(JPDIR)/jdpostct.c; $(DO_CC)  
$(B)/jdsample.o : $(JPDIR)/jdsample.c; $(DO_CC)  
$(B)/jdtrans.o : $(JPDIR)/jdtrans.c; $(DO_CC)  
$(B)/jerror.o : $(JPDIR)/jerror.c; $(DO_CC)  
$(B)/jidctflt.o : $(JPDIR)/jidctflt.c; $(DO_CC)  
$(B)/jmemmgr.o : $(JPDIR)/jmemmgr.c; $(DO_CC)  
$(B)/jmemnobs.o : $(JPDIR)/jmemnobs.c; $(DO_CC)  
$(B)/jutils.o : $(JPDIR)/jutils.c; $(DO_CC)  

$(B)/tr_bsp.o : $(RDIR)/tr_bsp.cpp; $(DO_CXX)  
$(B)/tr_animation.o : $(RDIR)/tr_animation.cpp; $(DO_CXX)  
$(B)/tr_backend.o : $(RDIR)/tr_backend.cpp; $(DO_CXX)  
$(B)/tr_cmds.o : $(RDIR)/tr_cmds.cpp; $(DO_CXX)  
$(B)/tr_curve.o : $(RDIR)/tr_curve.cpp; $(DO_CXX) 
$(B)/tr_flares.o : $(RDIR)/tr_flares.cpp; $(DO_CXX) 
$(B)/tr_font.o : $(RDIR)/tr_font.cpp; $(DO_CXX) 
$(B)/tr_image.o : $(RDIR)/tr_image.cpp; $(DO_CXX) 
$(B)/tr_init.o : $(RDIR)/tr_init.cpp; $(DO_CXX) 
$(B)/tr_light.o : $(RDIR)/tr_light.cpp; $(DO_CXX) 
$(B)/tr_main.o : $(RDIR)/tr_main.cpp; $(DO_CXX) 
$(B)/tr_marks.o : $(RDIR)/tr_marks.cpp; $(DO_CXX) 
$(B)/tr_mesh.o : $(RDIR)/tr_mesh.cpp; $(DO_CXX) 
$(B)/tr_model.o : $(RDIR)/tr_model.cpp; $(DO_CXX) 
$(B)/tr_noise.o : $(RDIR)/tr_noise.cpp; $(DO_CXX) 
$(B)/tr_scene.o : $(RDIR)/tr_scene.cpp; $(DO_CXX) 
$(B)/tr_shade.o : $(RDIR)/tr_shade.cpp; $(DO_CXX) 
$(B)/tr_shader.o : $(RDIR)/tr_shader.cpp; $(DO_CXX)  
$(B)/tr_shade_calc.o : $(RDIR)/tr_shade_calc.cpp; $(DO_CXX) 
$(B)/tr_shadows.o : $(RDIR)/tr_shadows.cpp; $(DO_CXX) 
$(B)/tr_sky.o : $(RDIR)/tr_sky.cpp; $(DO_CXX) 
$(B)/tr_smp.o : $(RDIR)/tr_smp.cpp; $(DO_CXX) 
$(B)/tr_stripify.o : $(RDIR)/tr_stripify.cpp; $(DO_CXX) 
$(B)/tr_subdivide.o : $(RDIR)/tr_subdivide.cpp; $(DO_CXX) 
$(B)/tr_surface.o : $(RDIR)/tr_surface.cpp; $(DO_CXX) 
$(B)/tr_world.o : $(RDIR)/tr_world.cpp; $(DO_CXX)
$(B)/tr_dxtn.o : $(RDIR)/tr_dxtn.c; $(DO_CC)
$(B)/clipping.o : $(RDIR)/clipping.cpp; $(DO_CXX)
$(B)/math.o : $(RDIR)/math.cpp; $(DO_CXX)

EXTRA_TARGETS = EBOOT.PBP


