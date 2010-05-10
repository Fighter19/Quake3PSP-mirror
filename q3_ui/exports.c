#include <pspmoduleexport.h>
#define NULL ((void *) 0)

void extern module_start;
void extern module_stop;
void extern module_info;
static const unsigned int __syslib_exports[6] __attribute__((section(".rodata.sceResident"))) = {
	0xD632ACDB,
	0xCEE8593C,
	0xF01D73A7,
	(unsigned int) &module_start,
	(unsigned int) &module_stop,
	(unsigned int) &module_info,
};

void extern vmMain;
void extern dllEntry;
static const unsigned int __ui_exports[4] __attribute__((section(".rodata.sceResident"))) = {
	0x247CB6E7,
	0xC53AF4F0,
	(unsigned int) &vmMain,
	(unsigned int) &dllEntry,
};

const struct _PspLibraryEntry __library_exports[2] __attribute__((section(".lib.ent"), used)) = {
	{ NULL, 0x0000, 0x8000, 4, 1, 2, &__syslib_exports },
	{ "ui", 0x0000, 0x0001, 4, 0, 2, &__ui_exports },
};
