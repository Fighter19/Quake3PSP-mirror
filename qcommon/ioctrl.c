/*
   Copyright (C) 2010 Crow_bar.

   *************************
   *File Read&Write System.*
   *************************

   ioctrl.c
*/
#include "../client/client.h"

typedef struct psp_file_s
{
	FILE* file;
	char name[256];
    char mode[3];
} psp_file_t;

#define MAX_OPEN_FILES 5   //psp have limit, 10 opened files max (for fopen)
#define MAX_FILES      64

static psp_file_t files[MAX_FILES];

int file_count = 0;
int file_used[MAX_FILES];
int file_closed[MAX_FILES];

void FS_FreeHandle(void)
{
    if(file_count+1 > MAX_OPEN_FILES)
    {
		int i;
		for(i = 1; i <= MAX_FILES; i++)
	    {
	        if((file_used[i]) && (!file_closed[i]))
	        {
	          psp_file_t* fdesc = &files[i];
			  if(fdesc->file)
			  {
				 fclose(fdesc->file);
				 printf("Cl: %s w_i: %i\n", fdesc->name, i);
				 file_closed[i] = 1;
				 file_count--;
				 break;
			  }
			}
		}
    }
}

void FS_RestoreHandle(int index)
{
    if(file_closed[index])
    {
	    FS_FreeHandle();

		psp_file_t* fdesc = &files[index];
		fdesc->file = fopen(fdesc->name, fdesc->mode);
		file_count++;
		file_closed[index] = 0;
		printf("Rs: %s w_i: %i\n", fdesc->name, index);
	}
}

int FS_Fopen(const char* name, const char* mode)
{
	int i, index = -1;
    if(file_count+1 > MAX_FILES)
	{
	   Sys_Error("FS_Fopen: no free slots for %s", name);
	}

	FS_FreeHandle(); //free unused handle

	for(i = 1; i <= MAX_FILES; i++)
	{
		if(!file_used[i])
        {
		   index = i;
		   break;
		}
	}


	psp_file_t *fdesc = &files[index];
    memset(fdesc, 0, sizeof(psp_file_t));

	fdesc->file = fopen(name, mode);
	if(fdesc->file)
	{
        printf("Opn: %s w_i: %i\n", name, index);

		strcpy(fdesc->name, name);
        strcpy(fdesc->mode, mode);

		file_count++;

	    file_used[index] = 1;
	    file_closed[index] = 0;
		return index;
	}
	return 0;
}

void FS_Fclose(int index)
{
    if(file_used[index])
    {
		psp_file_t *fdesc = &files[index];

		if(!file_closed[index])
		{
            printf("ICl: %s w_i: %i\n", fdesc->name, index);
		    fclose(fdesc->file);
		    fdesc->file = NULL;
		    file_count--;
		}
       	file_used[index] = 0;
		file_closed[index] = 0;
		memset(fdesc, 0, sizeof(psp_file_t));
	}
}

int FS_Fseek(int index, long pos, int func)
{
	FS_RestoreHandle(index); //Restore Deleted files

	psp_file_t *fdesc = &files[index];

    if(!fdesc->file)
	{
		Sys_Error("FS_Fseek: no file\n");
		return 0;
	}

	return fseek(fdesc->file, pos, func);
}

int FS_Ftell(int index)
{
    FS_RestoreHandle(index); //Restore Deleted files

	psp_file_t *fdesc = &files[index];

	if(!fdesc->file)
	{
		Sys_Error("FS_Ftell: no file\n");
		return 0;
	}

	return ftell(fdesc->file);
}

int FS_Fread(void* buffer, int off, int length, int index)
{
    FS_RestoreHandle(index); //Restore Deleted files

	psp_file_t *fdesc = &files[index];

	if(!fdesc->file)
	{
		Sys_Error("FS_Fread: no file\n");
		return 0;
	}
	return fread(buffer, off, length, fdesc->file);
}

