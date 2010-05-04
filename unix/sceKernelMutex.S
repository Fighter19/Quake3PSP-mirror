	.set noreorder

#include "pspimport.s"

#ifdef F_ThreadManForUser_000
	IMPORT_START "ThreadManForUser",0x40010000
#endif

#ifdef F_ThreadManForUser_0127
	IMPORT_FUNC  "ThreadManForUser",0xB7D098C6,sceKernelCreateMutex
#endif

#ifdef F_ThreadManForUser_0128
	IMPORT_FUNC  "ThreadManForUser",0xF8170FBE,sceKernelDeleteMutex
#endif

#ifdef F_ThreadManForUser_0129
	IMPORT_FUNC  "ThreadManForUser",0xB011B11F,sceKernelLockMutex
#endif

#ifdef F_ThreadManForUser_0130
	IMPORT_FUNC  "ThreadManForUser",0x5BF4DD27,sceKernelLockMutexCB
#endif

#ifdef F_ThreadManForUser_0131
	IMPORT_FUNC  "ThreadManForUser",0x0DDCD2C9,sceKernelTryLockMutex
#endif

#ifdef F_ThreadManForUser_0132
	IMPORT_FUNC  "ThreadManForUser",0x6B30100F,sceKernelUnlockMutex
#endif

#ifdef F_ThreadManForUser_0134
	IMPORT_FUNC  "ThreadManForUser",0x87D9223C,sceKernelCancelMutex
#endif

#ifdef F_ThreadManForUser_0135
	IMPORT_FUNC  "ThreadManForUser",0xA9C2CB9A,sceKernelReferMutexStatus
#endif

#ifdef F_ThreadManForUser_0136
    IMPORT_FUNC  "ThreadManForUser",0x19CFF145,sceKernelCreateLwMutex
#endif

#ifdef F_ThreadManForUser_0137
	IMPORT_FUNC  "ThreadManForUser",0x60107536,sceKernelDeleteLwMutex
#endif

#ifdef F_ThreadManForUser_0138
	IMPORT_FUNC  "ThreadManForUser",0x4C145944,sceKernelReferLwMutexStatusByID
#endif
