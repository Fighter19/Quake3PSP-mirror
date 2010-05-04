	.set noreorder

#include "pspstub.s"

	STUB_START "system_extender_driver",0x00090000,0x00060005
	STUB_FUNC  0x9C597AF3,sysKernelAllocPartitionMemory
	STUB_FUNC  0x3163B8B6,sysKernelGetBlockHeadAddr
	STUB_FUNC  0x7BFFCB02,sysKernelFreePartitionMemory
	STUB_FUNC  0x4CEBB2CD,sysKernelQueryMemoryPartitionInfo
	STUB_FUNC  0x14BE9F24,sysKernelPartitionTotalFreeMemSize
	STUB_FUNC  0xE91954A6,sysKernelPartitionMaxFreeMemSize
	STUB_END
