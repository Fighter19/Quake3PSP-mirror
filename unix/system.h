/*
Func exported from kernel

Memory Partition ctrl

in user, volatile memory is 3mb
in kernel, is 4mb
*/
#ifndef SYSMEM_H
#define SYSMEM_H

#include <pspsysmem.h>
#include <pspsysmem_kernel.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	MEM_KERNEL_HI = 1,
	MEM_USER,
	MEM_KERNEL_HI_S,
	MEM_KERNEL_LO,
	MEM_VOLATILE,
	MEM_USER_S
} PartitionID;

SceUID  sysKernelAllocPartitionMemory     (SceUID partitionid, const char *name,            int type, SceSize size, void *addr);
void *  sysKernelGetBlockHeadAddr         (SceUID blockid);
int     sysKernelFreePartitionMemory      (SceUID blockid);
int     sysKernelQueryMemoryPartitionInfo (int    pid,         PspSysmemPartitionInfo *info);
SceSize sysKernelPartitionTotalFreeMemSize(int    pid);
SceSize sysKernelPartitionMaxFreeMemSize  (int    pid);

#ifdef __cplusplus
}
#endif

#endif //SYSMEM_H

