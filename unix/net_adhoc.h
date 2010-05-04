#ifndef PSPADHOC_H
#define PSPADHOC_H

#include <pspkernel.h>
#include <pspwlan.h>
#include <pspsdk.h>
#include <pspnet.h>
#include <pspnet_adhoc.h>
#include <pspnet_adhocctl.h>
#include <psputility.h>

#define ADHOC_PORT 29

typedef struct
{
	int nic;
	u16 port;
	char mac[6];
} psp_sockaddr;

typedef psp_sockaddr mysockaddr_t;

int pspSdkLoadAdhocModules();
int pspSdkAdhocInit(char *product);
void pspSdkAdhocTerm();
int OpenSocket(int port);
int CloseSocket(int socket);
int ADHOC_recv(int socket, char *buf, int len, psp_sockaddr *addr);
int ADHOC_send(int socket, char *buf, int len, psp_sockaddr *addr);
char *AddrToString(psp_sockaddr *addr);
int StringToAddr(char *string, psp_sockaddr *addr);
int AddrCompare(psp_sockaddr *addr1, psp_sockaddr *addr2);
int Adhoc_Init();
#endif //PSPADHOC_H




