
#ifndef DMAC_H
#define DMAC_H

#ifdef __cplusplus
extern "C"
{
#endif

int sceDmacMemcpy(void *dest, const void *source, unsigned int size);
int sceDmacTryMemcpy(void *dest, const void *source, unsigned int size);

#ifdef __cplusplus
}
#endif

#endif //DMAC_H

