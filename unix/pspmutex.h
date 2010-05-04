#ifndef MUTEX_H
#define MUTEX_H

#ifdef __cplusplus
extern "C"
{
#endif

SceUID sceKernelCreateMutex( 
  const char *name, 
  unsigned int attributes, /* using a FIFO (0) or PRIORITIZED (256) THREAD QUEUE */ 
  int initial_count, /* the initial count of mutex when created */ 
  void *optional_parameters /* just pass 0 */ 
); // returns Mutex UID if >0 

int sceKernelDeleteMutex( 
  SceUID id /* Mutex UID */ 
); // returns 0 if OK 

int sceKernelLockMutex( 
  SceUID id, /* Mutex UID */ 
  int lock_count, /* > 0 */ 
  unsigned int *timeout /* In : 0 if no timeout or a pointer to a placeholder containing the max time value in ms. Out: time remaining when mutex is acquired */ 
); // returns 0 if OK or 0x800201a8 if timeout 

int sceKernelLockMutexCB( 
  SceUID id, /* Mutex UID */ 
  int lock_count, /* > 0 */ 
  unsigned int *timeout /* In : 0 if no timeout or a pointer to a placeholder containing the max time value in ms. Out: time remaining when mutex is acquired */ 
); // returns 0 if OK or 0x800201a8 if timeout 

int sceKernelTryLockMutex( 
  SceUID id, /* Mutex UID */ 
  int lock_count /* > 0 */ 
); // returns 0x800201c4 if current thread failed to own mutex or 0 if success 

int sceKernelUnlockMutex( 
  SceUID id, /* Mutex UID */ 
  int unlock_count /* >= 0 */ 
); // returns 0 if OK

#ifdef __cplusplus
}
#endif

#endif //MUTEX_H
