	.set noreorder

#include "pspstub.s"

	STUB_START "ui",0x00090000,0x00020005
	STUB_FUNC  0x247CB6E7,vmMainUI
	STUB_FUNC  0xC53AF4F0,dllEntryUI
	STUB_END
