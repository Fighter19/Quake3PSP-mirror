/*
  Kernel memory Hook
*/

#include <pspsdk.h>
#include <pspkernel.h>
#include <pspsysevent.h>
#include <pspsysmem.h>
#include <pspsysmem_kernel.h>

#include <psptypes.h>

#include <stdio.h>
#include <string.h>

PSP_MODULE_INFO("Q3SystemHook", PSP_MODULE_KERNEL, 1, 0);


SceUID sysKernelAllocPartitionMemory(SceUID partitionid, const char *name, int type, SceSize size, void *addr)
{
    int k1 = pspSdkSetK1(0);
    SceUID ret = sceKernelAllocPartitionMemory(partitionid, name, type, size, addr);
    pspSdkSetK1(k1);
    return ret;
}

void * sysKernelGetBlockHeadAddr(SceUID blockid)
{
    int k1 = pspSdkSetK1(0);
    void *ret = sceKernelGetBlockHeadAddr(blockid);
    pspSdkSetK1(k1);
    return ret;
}

int sysKernelQueryMemoryPartitionInfo(int pid, PspSysmemPartitionInfo *info)
{
    int k1 = pspSdkSetK1(0);
    int ret = sceKernelQueryMemoryPartitionInfo(pid, info);
    pspSdkSetK1(k1);
    return ret;
}

int sysKernelFreePartitionMemory(SceUID blockid)
{
    int k1 = pspSdkSetK1(0);
    int ret = sceKernelFreePartitionMemory(blockid);
    pspSdkSetK1(k1);
    return ret;
}

SceSize sysKernelPartitionTotalFreeMemSize(int pid)
{
    int k1 = pspSdkSetK1(0);
    SceSize ret = sceKernelPartitionTotalFreeMemSize(pid);
    pspSdkSetK1(k1);
    return ret;
}

SceSize sysKernelPartitionMaxFreeMemSize(int pid)
{
    int k1 = pspSdkSetK1(0);
    SceSize ret = sceKernelPartitionMaxFreeMemSize(pid);
    pspSdkSetK1(k1);
    return ret;
}


int module_start(SceSize args, void *argp)
{
	return 0;
}

int module_stop(SceSize args, void *argp)
{
	return 0;
}
