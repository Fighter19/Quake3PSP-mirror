#ifndef IOCTRL_H
#define IOCTRL_H

int FS_Fopen(const char* name, const char* mode);
void FS_Fclose(int index);
int FS_Fseek(int index, long pos, int func);
int FS_Ftell(int index);
int FS_Fread(void* buffer, int off, int length, int index);

#endif //IOCTRL_H

