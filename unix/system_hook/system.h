/*
Func exported from kernel
*/
#ifndef SYSMEM_H
#define SYSMEM_H

#include <pspsysmem.h>
#include <pspsysmem_kernel.h>

SceUID  sysKernelAllocPartitionMemory     (SceUID partitionid, const char *name,            int type, SceSize size, void *addr);
void *  sysKernelGetBlockHeadAddr         (SceUID blockid);
int     sysKernelFreePartitionMemory      (SceUID blockid);
int     sysKernelQueryMemoryPartitionInfo (int    pid,         PspSysmemPartitionInfo *info);
SceSize sysKernelPartitionTotalFreeMemSize(int    pid);
SceSize sysKernelPartitionMaxFreeMemSize  (int    pid);


#endif //SYSMEM_H

