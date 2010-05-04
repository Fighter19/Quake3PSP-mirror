	.set noreorder

#include "pspstub.s"

	STUB_START "qagame",0x00090000,0x00020005
	STUB_FUNC  0x247CB6E7,vmMainQAG
	STUB_FUNC  0xC53AF4F0,dllEntryQAG
	STUB_END
