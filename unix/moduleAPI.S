.set noreorder
#include "pspstub.s"

STUB_START "ui",    0x00090000,0x00020005
STUB_FUNC  0x247CB6E7,vmMainUI
STUB_FUNC  0xC53AF4F0,dllEntryUI
STUB_END

STUB_START "qagame",0x00090000,0x00020005
STUB_FUNC  0x247CB6E7,vmMainQAG
STUB_FUNC  0xC53AF4F0,dllEntryQAG
STUB_END

STUB_START "cgame", 0x00090000,0x00020005
STUB_FUNC  0x247CB6E7,vmMainCG
STUB_FUNC  0xC53AF4F0,dllEntryCG
STUB_END
	

STUB_START "system_extender",0x40090000,0x00060005
STUB_FUNC  0x9C597AF3,sysKernelAllocPartitionMemory
STUB_FUNC  0x3163B8B6,sysKernelGetBlockHeadAddr
STUB_FUNC  0x7BFFCB02,sysKernelFreePartitionMemory
STUB_FUNC  0x4CEBB2CD,sysKernelQueryMemoryPartitionInfo
STUB_FUNC  0x14BE9F24,sysKernelPartitionTotalFreeMemSize
STUB_FUNC  0xE91954A6,sysKernelPartitionMaxFreeMemSize
STUB_END

