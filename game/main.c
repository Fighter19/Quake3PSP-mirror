#include <pspkernel.h>
#include <stdio.h>

PSP_MODULE_INFO("qagame", 0, 1, 0);

void Com_Printf(char* msg, ...);

int module_start( SceSize arglen, void *argp )
{
	return 0;
}

int module_stop( SceSize arglen, void *argp )
{
	Com_Printf("QAGame prx Stoped\n");
	return 0;
}






