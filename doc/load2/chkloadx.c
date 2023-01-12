/*********************************************************************
*
*	CHKLOAD	- 	This program will open a raw file and compare GSP memory
*					with the contents of the raw file to see if a load executed
*					properly.
*
***********************************************************************/

#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <direct.h>
#include  "io.h"
#include  "dos.h"
#include  "stdio.h"
#include  "fcntl.h"
#include  <ctype.h>
#include "wmpstruc.h"
#include "load2.h"
#define S_IREAD 	0000400 	/* read permission, owner */
#define S_IWRITE	0000200 	/* write permission, owner */

#ifdef W020
#include "gsp020.dec"
#else
#include "gspcomm.dec"
#endif

#define MAX_BUFF_SIZE 65500


struct RAW_FILE_HEADER	raw_hdr;
struct RAW_FILE_RECORD	raw_rec;

int	raw_file;
int  ffile,gfile;

char filename[80];

char *fbuff,*gbuff;

main(int argc,char **argv)
{
int	j,chunk;
unsigned int	load_word, temp, len;
unsigned long	i;
unsigned int byte_count;
unsigned char *fbp;
unsigned char *gbp;
long	record_bytes,errcnt;
unsigned long  laddr;

if (argc == 1)
	{
	printf("\nUSAGE:\n\nCHKLOAD  raw_file\n\n");
	exit(0);
	}

SetHostIo(getenv("TRGTADDR"),1);

fbuff = malloc((size_t)MAX_BUFF_SIZE);
gbuff = malloc((size_t)MAX_BUFF_SIZE);

strcpy(filename,argv[1]);
if (!strchr(filename,'.')) strcat(filename,".irw");

if ( (frawfile = fopen( filename,"rb")) == 0)
	{
	printf( "\nERROR *** Cannot open raw data file: %s\n",
							filename); 
	exit(1);
	}

raw_file = fileno(frawfile);

if ( (ffile = open( "Rawdata.bin",O_CREAT|O_RDWR|O_BINARY|O_TRUNC,S_IWRITE)) <= 0)
	{
	printf( "\nERROR *** Cannot open rawdata.bin\n"); 
	exit(1);
	}
if ( (gfile = open( "Gspdata.bin",O_CREAT|O_RDWR|O_BINARY|O_TRUNC,S_IWRITE)) <= 0)
	{
	printf( "\nERROR *** Cannot open gspdata.bin\n"); 
	exit(1);
	}


read(raw_file, (char *) &raw_hdr, sizeof(struct RAW_FILE_HEADER));

if (raw_hdr.magic_num != RAW_MAGIC)
	{
	printf("\nERROR *** File is not in raw image format.");
	exit(3);
	}

temp = 0;

for(j=0;raw_hdr.version[j] != '\0';j++)
					temp += raw_hdr.version[j];

if (temp != raw_hdr.ver_cksum)
	{
	printf("\nERROR *** Raw image file corrupt.");
	exit(2);
	}

printf("\n%s created with LOAD2 version %s", argv[1], raw_hdr.version);

while	((read(raw_file, (char *) &raw_rec,
				sizeof(struct RAW_FILE_RECORD))) != 0)
	{
	chunk = -1;
	record_bytes = raw_rec.byte_count;
#ifdef W020
	laddr = raw_rec.start_addr;
#else
	SetAuto(laddr = raw_rec.start_addr,INCRD);
	laddr = raw_rec.start_addr;
#endif

	printf("\nReading %7lu bytes at %8lx\n",raw_rec.byte_count,raw_rec.start_addr);
	errcnt = 0L;
	while	(record_bytes)
		{
		chunk++;
		byte_count = (record_bytes < (long)MAX_BUFF_SIZE) ? (UI)record_bytes : MAX_BUFF_SIZE;
		read(raw_file, fbuff, byte_count);		//FarRead
		record_bytes -= (long)byte_count;

		printf("\nChunk %d Reading %7u bytes at %8lx",chunk,byte_count,laddr);
//		printf("+");
		len = byte_count>>1;
#ifdef W020
		GSPBlkRd((int *)gbuff,len,laddr);
		laddr += (long)byte_count<<3;
#else
		RdGSPBuffer((int *)gbuff,len);
		laddr += (long)byte_count<<3;
#endif

		write(ffile, fbuff, byte_count);
		write(gfile, gbuff, byte_count);

//		fbp = fbuff;
//		gbp = gbuff;
//		for (i=byte_count; i-- != 0; )
//			{
//			if (*fbp++ != *gbp++) errcnt++;
//			}
		}

	if (errcnt) printf("\n%lu errors",errcnt);
	}
close(ffile);
close(gfile);
close(raw_file);

}
