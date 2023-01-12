#define	VERSION	"5/25/94"
// Use makeld2.bat to compile and link!!!
// Use mkld020.bat to compile and link XUNIT version!!!

/*********************************************************************
*
*	LOAD2	- 	This program will perform either or both of the
*				following tasks on DMA 2 SYSTEMS ONLY!
*
*		1)	Load selected images, or images and tables from
*			selected image libraries (WIMP/BLIMP format)
*			into target system Image Rom area
*
*		2) Generate image tables for each of the selected images to
*			be included with the game source code.
*
*		The format of the generated tables can be supplied in the .lod
*		file as by a single line in the following format...
*
*	   IHDR keyword1:sz,keyword2:sz,...	 (no spaces except one after IHDR)
*
*		where IHDR begins in column 1
*			   keyword is one of the following:
*					SIZX,SIZY,ANIX,ANIY,SAG,CTRL,PAL,PWRD1,PWRD2,PWRD3,PTnx (n=0-9,x=X or Y)
*			   sz is a single character... B,W or L representing 
*					byte, word or long
*
*		If no IHDR line is supplied in the .lod file, the table is
*		written as follows:
*				SIZX:W,SIZY,W,SAG:L,ANIX:W,ANIY:W,CTRL:W,PAL:L
*
*	ORIGINAL LOADIMG by LOTSA GUYS - NEW ONE STARTED on April 6,1992 by WBD
*
*	Modifications:
*
*	Scapegoat			Description
*	----------			-----------
*  WBD/WFD	4/6/92	Start with Loadimg and take out spaghetti
*	WBD		5/11/92	First release of Load2
*	WBD		5/18/92	Added PAD and ALIGN invocation parameters
*	WBD		6/2/92	Asterisk after img name in .lod file causes
*							4 sizes of image to be stored (full,half,qrtr,eighth)
*	WBD		6/8/92	Put dma2_field AFTER anim pt and imgaddr
*	WBD		6/12/92	Add IHDR keyword to .lod file to define table style
*  WBD      8/24/92  FRM files padded to even number of bytes.
*  WBD      8/26/92  Support for Point Tables
*  WBD      8/27/92  Restart program if it was running and tables not loaded.
*  WBD      9/4/92   Supply default of 0 when point table value requested but does not
*							exist.
*  WBD      9/11/92  Change Raw File for SREC compatibility
*  WBD      9/14/92  Improved rounding in half,quarter and eighth size imgs
*  WBD      9/18/92  Allow 1024 point tables, add badlibspec flag
*  WBD      9/24/92  Fix bug in rawfilename generation, when dir is root
*  WBD      10/1/92  Fix typo bug in rawfilename generation.
*  WBD      10/2/92  Add support for UNIVERSE type backgrounds
*  WBD      10/5/92  Clean up universe support, Ensure that imgdir, srcdir,
*							tbldir, and curdir always end in a single backslash
*  WBD      10/11/92 Add directory override for img, bg, uni and frm files.
*							Allow a directory to be supplied on command line 
*							to supplement IMGDIR, SRCDIR and curdir.
*  WBD      10/15/92 Fix bug added to BBB> in prev version.
*  WBD      10/19/92 Up MAX_PTTBL from 1024 to 2048
*  WFD      10/21/92 Fixes for Zero Compression
*  WBD      10/23/92 Increase # of Table Style entries from 16 to 32
*  WBD      10/26/92 Fix bugs in reading early universes
*  WBD      10/27/92 Adjust MAX_IMGS in a single wimp file to match WIMP.
*  WBD      10/28/92 Restore magic number for SREC compatibility
*							Bug fix when fully specified path given in .lod file
*	WBD		11/3/92	Small change to zero compression warning message.
*							Fix to override directory handling, added that handling
*							to .img files stored within .uni files.  Added load2.h
*							with global stuff.
*	WBD		11/4/92  Fix to savzcom handling in read_bgnd.
*							Yet another fix to expand_filespec
*	WBD		11/5/92  Add SEC> ability to change filespec. Add override
*							dir to UNI> line. Add univtbl.glo
*	WBD		11/6/92  Write img names to GLO file if not imgtbl.glo
*							Take away SEC> and add capability to ASM>
*	WBD		11/9/92  Support for animations in universe.
*	WBD		11/10/92 Fix to save UNIV pos in table, not world.
*	WBD		11/12/92 Fix to fix
*	WBD		11/22/92 Up NUMPALS from 250 to 500
*	WBD		12/1/92  Improve storage efficiency of half shrinks
*	WBD		12/2/92  Close universe file at end of read_univ
*	WBD		12/3/92  comment on dma ctrl in bgndtbl, add new lines at
*						   program termination, x and y become longs in univtbl
*	WBD		12/7/92  Bug fix in setting global file pointer on univs.
*							Asterisk for multiple sizes must be followed by a number
*							(2-4).
*	WBD		12/14/92 Add /B option to set bits_pr_pxl based on image
*							data instead of Palette size.
*	WBD		12/28/92 Protection against imgs whose widths are less than 4
*							(Set MIN_IMG_WIDTH).  /B option default reversed. 
*							( Now automatically sets bpp based on image. )
*							Make backup of ASM> files in case a yutz puts in a
*							.asm extension.
*	WBD		12/29/92	Smarts added to detect same image written to an ASM
*							file from inside a universe and outside.
*	WBD		12/30/92	Clean up /A option.  Does not change imgtbl.asm or
*							imgtbl.glo
*	WBD		1/8/93	Add /U option which is a global override for 
*                    directories within a universe file.
*	WBD		1/22/93	Have ani pt on smaller sizes match BGTOOL technique.
*	WBD		1/27/93	Fix bug with removing duplicates in process_img.
*	WBD		2/1/93	Fix bug universe saved not at origin
*	WBD		2/8/93	Support FG flag in bgtool, add /S to write univseq.new
*	WBD		2/10/93	RE-Fix bug universe saved not at origin
*	WBD		2/18/93	Handle new WIMP large model files. Support alt pals.
*	WBD		3/3/93	Revert img and pal headers to old style. 
*	WBD		3/11/93	Restore table support of pword1,2 & 3 (now dam[0],[2] & [4]
*	WBD		3/17/93	UNIVERSES: Support flagging of ANIM, DANIM and DAMAGE
*                    from MAP_IMG field low 2 bits.
*	WBD		3/18/93	Support Placeholders in sequences. 
*	WBD		3/29/93	Slight change to DAM/DANIM/ANIM flag handling in tables
*	WBD		4/6/93	Added ticks to damage tables (as hit count)
*	WBD		4/9/93	DANIM set for static images as well.
*	WBD		4/13/93	Added optional Univ Seq File name (Univseq.h = default)
*	WBD		4/15/93	Fix warning for when imgs in uni don't match .img file
*	WBD		5/24/93	No changes to source, but linkable with new 020 lib
*                    for XUNIT compatibility. Added compilation switch W020.
*	WBD		5/28/93	Changes for Ed... Dual banked image memory.
*	WBD		6/3/93	Fixed damage tables shared by different non-damaged pcs.
*	WBD		6/7/93	Fix stupid bug in load_raw_file for XUNIT
*	WBD		6/14/93	Clean up some displayed messages for better info.
*	WBD		6/25/93	Each UNI line creates new unitblXX.asm file (up to 99)
*	WBD		6/30/93	Increase MAX OBJS to 2000 from 1000
*	WBD		7/6/93	Fixed dup name check. Added Warning if dup name found,
*							but data does not checksum match.
*	WBD		7/12/93	Added UFN to set uni_file_num (needed for /A option)
*							New ultra cool universe handling scheme
*  WBD      8/5/93   Restore sequence images into imgtbl.asm for gxuniseq.asm	
*  WBD      8/7/93   Fix raw file problem, add prog_name variable.
*  WBD      8/20/93  Recompile for new MAX_LIB of 12
*  WBD      9/7/93   Handle variable copies in read_univ.
*  WBD      9/12/93  Zero Compression turned off for universes
*  WBD      9/24/93  ED fix to background tables in read_bgnd.
*  WBD      9/30/93  Proper handling of M_FG objs in universe for tables.
*  WBD      10/7/93  Fix dual-bank handling for T-unit & support in raw file.
*  WBD      10/19/93 Add /3 option to limit sizes to 3 (full,half,qrtr)
*                    Fix call to adjust_flags (arg type change to OBJHDR from SH_OBJ)
*  WBD      10/21/93 Fix handling of copies for process_seq and process_dam
* 							change mark&0xc0 to mark&0xc in process_img
*  WBD      10/22/93 Allow ENEMY flag in a univ obj to trigger creation of
*                    enemy sequence. (don't have to create a seq in WIMP)
*  WBD      10/25/93 Small fix to do_qrtr computation for Univ pieces
*  WBD      11/11/93 Add ZAL> to override zcom_analysis (Not functional
*                    until zcom.c is changed)
*  WBD      11/18/93 Fix to static Enemy generator when damageable
*  WBD      11/30/93 Change glo to gbl_fname in insert_palname when writing
*							pal name to global file.
*  WBD      12/9/93  Support change in position of ONESHOT bit for universes.
*							No longer support universes pre-version 1.00
*	WBD		12/20/93 Up NUMPALS from 500 to 800
*	WBD		1/19/94 	Put limit of MAX_HITS on ticks written to damage tables.
*                    (process_damage in ldbgnd2)
*	WBD		2/2/94	Change ENEMY handling... create an animation for a static
*                    enemy gen ONLY IF it is not damageable
*							For Static Damageable Enemy generators, follow the damage
*							table with an IMAGE INDEPENDENT enemy animation, but leave
*							the damage table as static frames
*	SL			2/21/94	Added support for multipart image creation
*	SL			3/15/94	Finished multipart support
*	SL			3/28/94	Multipart bug fixes
*	SL			3/30/94	Added collision box support
*	SL			4/15/94	Fixed mpart zcom bug
*	SL			5/25/94	Changed setbank for multi bank support
*
*	INVOCATION - load2 FILE FLAG1
*
*		FILE is an ASCII file which specifies the images to be loaded.
*		It is assumed to be in the SRCDIR directory (presumably where you
*		keep your source code). An extension of .lod is automatically
*		tacked on to the supplied filename.
*
*		For FLAG1 definitions, see routine instruct();
*
*	FORMAT OF .lod FILE....
*
*		* No Blank Lines
*		* First line contains fully qualified name of .img file starting in
*			column 1. If the filename is simple, then the filename is prefixed
*			with the enviornmental variable IMGDIR.
*		* Following lines contain (starting in column 1)...
*		  "---> img1:stcol,img2:stcol,img3:stcol,...,imglast:stcol"
*         * The ":stcol" part is optional and represents a number which is
*		  added to all non-zero pixels to allow for a palette placed
*           higher up in color ram. If omitted, it is taken to be 0.
*		* The "---> " pattern must be exact. All image names are separated
*		  by commas (no spaces).
*		* There can be as many images on a line as will fit in 255 columns.
*		* After last line of image names, you can start again with another
*			.img file.
*		* There is no limit to how many .img files you can take images from.
*		* WIMP will generate a .lod file for you. If you are using more
*			than 1 .img file, you will need to concatenate the files
*			created by WIMP.
*		* "***> staddr[,endaddr]" causes the counter to skip to staddr and
*					optionally checks that loading does not go past endaddr.
*		* "BBB> " followed by the name of a background file causes the
*			background to be handled as well
*		* "UNI> " followed by the name of a universe file causes the
*			universe to be handled as well
*		* "IHDR " indicates that a table definition style for images follows.
*		* "GLO> <filename>" global decls to <filename>
*		* "ASM> <filename>" assembleable image headers to <filename>
*            		  		  by default, headers go to imgtbl.asm
*		* "FRM> <filename>" .bin file containing compressed still pic or frames
*		* "PPP> #" pack pixel data with # bits per pixel, 0 <= # <= 8
*				  If 0, auto-pack to smallest number of bits.
*		* "ROM> staddr,endaddr"  Set address range to NOT load into memory
*		* "CON>"/"COF>" turns on and off checksums.
*		* "ZON>"/"ZOF>" turns on and off lead/trail zero compression.
*		* "MON>"/"MOF>" turns on and off multipart box mode
*		* "BON>"/"BOF>" turns on and off collision box mode
*
*		Any line starting with ';' or '*' or '/' will be ignored as a comment
*
**************************************************************************/


#include	"wmpstruc.h"
#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <direct.h>
#include  "io.h"
#include  "dos.h"
#include  "stdio.h"
#include  "fcntl.h"
#include  <ctype.h>
#define S_IREAD 	0000400 	/* read permission, owner */
#define S_IWRITE	0000200 	/* write permission, owner */

#include "emm.c"
//	The following no longer used since we went to large model.
#define	FarRead(a,b,c)		BufferIO(a+0x3f00,(char far *)b,c)
#define	FarWrite(a,b,c)	BufferIO(a+0x4000,(char far *)b,c)
int missinglib;

#ifdef W020
#include "gsp020.dec"

#define	IRAMST	0xF0000000L
#define	IRAMEND	0xFFC00000L
#define	SRAMST	0x20000000L
#define	SRAMEND	0x21000000L
#define	PROMST	0xFFC00000L
#define	PROMEND	0xFFFFF000L

char prog_name[8]= {"LOAD20"};

#else 
#include "gspcomm.dec"

#define	IRAMST	0x2000000L
#define	IRAMEND	0x8000000L
#define	SRAMST	0x1000000L
#define	SRAMEND	0x1100000L
#define	PROMST	0xFF800000L
#define	PROMEND	0xFFFFF000L

char prog_name[8]= {"LOAD2"};

#endif

 

long	IROMST,IROMEND;	// can be set from .lod file

#include "load2.h"

int pt_indx = 0;	// index of next available point table
int badlibspec = 1;


struct RAW_FILE_HEADER	raw_hdr;
struct RAW_FILE_RECORD	raw_rec;

int	raw_file, record_num;

FSEQSCR	wlib_seq;
FSEQSCR	*wlibseq;
FENTRY wa_entry;
FENTRY *waentry;

// not used anymore  8/5/93 char uni_seq_filename[16];
char	user_glo_file[16];

void	instruct ()
{
printf("Invocation...	%s <file> <flags>\n",prog_name);
printf("      TRGTADDR is the host communication port\n");
printf("      Source directories for related files can be chosen through flags.\n");
printf("      YOU CAN SPECIFY AN IMAGE HEADER FORMAT IN THE .LOD FILE!!!\n");
printf("\nValid <flags>...\n");
printf("  /X  -DO NOT download to GSP. (If not present, it does)\n");
printf("  /Dx -Specify directory for .lod file (see below for 'x' description)\n");
printf("  /Tx -Build image table files (see below for 'x' description)\n");
printf("  /Fx -Build raw file (see below for 'x' description)\n");
printf("  /Ox -Override dir. for all files in .lod file (see below for 'x')\n");
printf("NOTE! The above flags are independent and may be used in any combination.\n"); 
printf("  /Rx -Load from a raw image file. (see below for 'x' description).\n");
printf("  /H  -Print an explanation of .lod file directives.\n");
printf("  /V  -Verbose mode, report lots of stuff.\n");
printf("  /I  -Write background data to image roms\n");
printf("  /B  -Make Bits Per Pixel based on Palette size, not pixel data.\n");
printf("  /P  -Pad images to multiple of 4 bits\n");
printf("  /L  -aLign images to 16 bit boundaries\n");
printf("  /A  -Append new information to default files (for multiple loads)\n");
printf("\n                           Press ENTER to continue...");
getchar();
printf("\n  /3  -Limit multiple sizes to 3 (full,half,qrtr), not 4 (eighth).\n");
#ifndef W020
printf("  /E  -ED adjustment (Dual banked image memory\n");
#endif
printf("\nFlags pertaining to bgtool...\n");
printf("  /Ux -Override dirs. within all Universe files (see below for 'x')\n");
printf("  /S  -Write UNIVSEQ.NEW\n"); 
printf("\nThe T,F,R,D,O and U options use a secondary flag shown above as 'x'.\n");
printf("  If x is I, the affected file uses IMGDIR.\n");
printf("  If x is S, the affected file uses SRCDIR.\n");
printf("  If x is C, the affected file uses the current dir.\n");
printf("  If x is =, supply a directory on the command line.\n");
}


graceful_exit(int n)
{
free_blocks();
free_emm64K(cbuff);
exit(n);
}


void close_current_wimplib(void)
{
register int i,j;

if (cur_lib > 0 )
 	{
	if (!frm_univ)	adjust_temp_img(temp_img_data,lib_hdr.num_images);
	save_temp_table(libname);
 	for (i = lib_hdr.num_images; --i >= 0;) free(img[i]);
 	for (i = lib_hdr.num_palettes; --i >= NUM_DEF_PAL;)
													 free(pal[i]);
	if (lib_hdr.temp == 0xabcd)  // new wimp only
		{
		 for (i = lib_hdr.num_seq; --i >= 0;)
			{
			for (j = sequence[i]->num; --j >= 0;)
				if (sequence[i]->entry[j]) free(sequence[i]->entry[j]);
			free(sequence[i]);
			}
	 	for (i = lib_hdr.num_scripts; --i >= 0;)
			{
			for (j = script[i]->num; --j >= 0;) free(script[i]->entry[j]);
			free(script[i]);
			}
		}
 	close(cur_lib);
	cur_lib = -1;
 	}
}



char *choose_dir(char *inpstr,char *dbuf)
{
switch(*inpstr)
	{
	case 'S':
	case 's':
		return(srcdir);
		break;
	case 'I':
	case 'i':
		return(imgdir);
		break;
	case 'C':
	case 'c':
		return(curdir);
		break;
	default:
		strcpy(dbuf,inpstr+1);
		if (dbuf[strlen(dbuf)-1] != '\\')	strcat(dbuf,"\\");
		return(dbuf);
		break;
	}
}


void expand_filespec(char *srcstr,char *dststr)
{
char *filepart;

filepart = srcstr;
if (!strchr(srcstr,'\\') && !strchr(srcstr,':'))
	{							// No embedded directory
	strcpy(dststr,(do_ovr_dir)? ovr_dir : imgdir);
	}
else if (do_ovr_dir)
	{
	strcpy(dststr,ovr_dir);
	filepart = strrchr(srcstr,'\\');
	if (filepart == NULL) filepart = strchr(srcstr,':');
	filepart++;
	}
else *dststr = '\0';
strcat(dststr,filepart);
}



void if_exists_make_backup(char *fname)
{
char bname[80];
char *ext;

if (access(fname,0) == 0)
	{
	strcpy(bname,fname);
	if (ext = strrchr(bname,'.')) 
		{			// there is an extension
		*(ext+1) = '~';		
		}
	else strcat(bname,".old");
	if (access(bname,0) == 0)
		{
		remove(bname);
		}
//	ext = strrchr(bname,'\\')+1;
//	rename(fname,ext);	/* rename original file to backup name */
	rename(fname,bname);	/* rename original file to backup name */
	}
}


void build_img_name_table(void)
{
struct IMNAME *sav,*new;
char *eos;

while ( fgets(astring,255,src) != NULL )
	{
	if (*astring > 0x20)
		{
		if (eos = strchr(astring,':'))
			{
			*eos = '\0';
			sav = inames[0];
			new = (struct IMNAME *) malloc (sizeof(struct IMNAME));
			strcpy(new->iname,astring);
			new->nxtname = sav;
			inames[0] = new;
			}
		}
	}
}



void build_pal_name_table(void)
{
char *eos;

while ( fgets(astring,255,imgpal) != NULL )
	{
	if (*astring > 0x20)
		{
		if (eos = strchr(astring,':'))
			{
			*eos = '\0';
			if((!exist_imgpal(astring)) && (srch_pname(astring) == -1))
				{			 
				strcpy(imgpal_list[imgpalidx++], astring);									 
				}
			}
		}
	}
}



dup_name_check(char *iname,int indx,int add)
{
struct IMNAME *nxt,*new;

if (*iname == '\0') return(1);

nxt=inames[indx];
if (nxt != NULL)
	{
	while (1)
		{
		if (!strcmp(nxt->iname,iname)) return(0);
		if (nxt->nxtname == NULL) break;
		nxt = nxt->nxtname;
		}
	}
	                  // Check list for imgtbl.asm without adding
if (indx != 0) if (!dup_name_check(iname,0,0)) return(0);
if (add)
	{
	new = (struct IMNAME *) malloc (sizeof(struct IMNAME));
	strcpy(new->iname,iname);
	new->nxtname = NULL;

	if (inames[indx] == NULL) inames[indx] = new;
	else nxt->nxtname = new;
	}
return(1);
}




void close_current_asm_file()
{
	/* close file already open */
	if ((asm_fptr != src) && (asm_fptr != NULL))
		{
		if (fclose (asm_fptr) == EOF)
			{
			printf ("\nerror closing file %s", asm_fname);
			graceful_exit (1);
			}
		}
}





void open_asm_file(char *asm_file_name)
{
register int g;

for (g = 0; g < num_asm_files; g++)
	{
	if (!strcmpi (asm_file[g], asm_file_name))
		{
		/* got an already used file, reopen it.. */
		asm_fname = asm_file [g];
		asm_fileno = g;
		strcpy(filename,tbl_dir);
		strcat(filename,asm_fname);
		asm_fptr = fopen (filename, "a");
		if (!asm_fptr)
			{
			printf ("\nCan't reopen %s for writing.", filename);
			graceful_exit (1);
			}
		return;
		}
	}

/* must open a new file, but first record the name */
if (num_asm_files == MAX_ASM_FILES)
	{
	printf ("\nERROR: Too many ASM files, increase const MAX_ASM_FILES in load2.c");
	graceful_exit (1);
	}
asm_fname = (char *) malloc (strlen (asm_file_name)+1);
if (!asm_fname)
	{
	printf ("\nCan't get space for asm file name %s.", asm_file_name);
	graceful_exit (1);
	}
strcpy (asm_fname, asm_file_name);
asm_fileno = num_asm_files;
asm_file [num_asm_files++] = asm_fname;
inames [num_asm_files] = NULL;
strcpy(filename,tbl_dir);
strcat(filename,asm_fname);
if_exists_make_backup(filename);
asm_fptr = fopen (filename, "w");
if (!asm_fptr)
	{
	printf ("\nCan't open %s for writing.", filename);
	graceful_exit (1);
	}
fprintf (asm_fptr, "	.%s",ihdr_sect);
return;
}



void SetBank(int lbank)
{

//sysctrl = 0x7c;
//if (lbank) sysctrl |= BANK_BIT;
sysctrl = 0x987f;						 // Was 7ch
sysctrl |= (lbank<<8);
//else sysctrl &= ~BANK_BIT;
SetGSPAddr(SYS_CTL_REG);
WrGSP(sysctrl);
}



main(argc,argv)
int	argc;
char	*argv[];
{
char	*ok, bgndname[80], *readnum, rawfilename[80], *c, *nxt;
unsigned long tempaddr;
int	inum,i,g,tblind;
int	hstctlh_save;
ULI	tmp;
char *unidir,*dnxt;
FILE *savglo,*savasm;
int savasmno;
char *savunidir,*savfname;
char  ch;
int obank;

missinglib = 0;

printf ("\nCopyright (C) Williams Electronics Games, Inc. 1993.\n");
#ifdef W020
printf ("GSP Image Loader - DMA 2 - 34020 - Version %s\n", VERSION);
#else
printf ("GSP Image Loader - DMA 2 - Version %s\n", VERSION);
#endif


/* Allocate general purpose buffers */

wlibseq = &wlib_seq;
waentry = &wa_entry;

zcom_min_fail = 0;
imgbuf = _fmalloc((UI)65500);
if (imgbuf  == NULL)
	{
	printf("\nCould not allocate first large buffer! Goombye!");
	exit(1);
	}

user_glo_file[0] = '\0';	// assume no user global file
//strcpy(uni_seq_filename,"uniseq");
strcpy(ihdr_sect,"DATA");	 // default IHDR section

dataword = bits_filled = 0;
IROMST = IROMEND = 0L;

num_gbl_files = 0;		/* # of files for writing global syms on */
num_asm_files = 0;		/* # of files for writing image tables on */
dflt_gbl_file = "imgtbl.glo";
dflt_asm_file = "imgtbl.asm";
dflt_pal_file = "imgpal.asm";
gbl_fname = dflt_gbl_file;
asm_fname = dflt_asm_file;
gbl_fileno = -1;
asm_fileno = -1;
inames[0] = NULL;							// corresponds to asm_fileno = -1;
frst_uni_flg = 1;
uni_file_num = bgfiles_open = 0;   // bgtables not open
set_default_style();
gbl_dam_num = -1;

palindex = imgpalidx = 0;
cur_lib = -1;
raw_file = -1;
imgaddr = IRAMST;
new_rec_addr = imgaddr;
cur_rec_addr = 0L;
startaddr = imgaddr;
topaddr = IRAMEND;
iram_ct = irom_ct = sram_ct = prom_ct = 0;
curr_ct = &iram_ct;
iramrec_ct = iromrec_ct = sramrec_ct = promrec_ct = 0;
currec_ct = &iramrec_ct;
loadmsk = 1;				// zero when imgaddr is in a ROM area
howmanytotal = 0x0L;
dual_bank = 0;			// assume single bank of image memory
bank = 0;				// assume first bank (0-3)

do_zcom = do_zall = 0;

mpboxon = 0;

packbits = 0;
record_num = 0;
fgnd_cksum_match = bgnd_cksum_match = 0;
fgnd_cksum_bits = bgnd_cksum_bits = 0L;
err_cnt = 0;
othpal_indx = 0;

curdir = (char *)getcwd(dirbuf,40);

if ((imgdir=getenv("IMGDIR")) != NULL)
	{
	strcpy(imgdirbuf,imgdir); 
	imgdir = imgdirbuf;
	}
else  {
	 *imgdirbuf = '\0';
	 imgdir = (char *)getcwd(imgdirbuf,40);
	 }

if ((srcdir=getenv("SRCDIR")) != NULL)  
	{
	strcpy(srcdirbuf,srcdir); 
	srcdir = srcdirbuf;
	}
else {
	 *srcdirbuf = '\0';
	 srcdir = (char *)getcwd(srcdirbuf,40);
	 }

/******  MAKE SURE ALL DIRECTORIES END IN A SINGLE BACKSLASH!!!  ***/

if (srcdir[strlen(srcdir)-1] != '\\')	strcat(srcdir,"\\");
if (imgdir[strlen(imgdir)-1] != '\\')	strcat(imgdir,"\\");
if (curdir[strlen(curdir)-1] != '\\')	strcat(curdir,"\\");

do_pad = do_sclpad = 0;
do_wruniseq = 0;
do_table = do_append = 0;
do_load = 1;
do_uni_dir = do_univ = 0;
do_ovr_dir = 0;
do_raw_load = 0;
do_file = 0;
do_superbpp = 1;
do_cksum = 1;
dbg_verbose = 0;
do_verbose = 0;
do_rawbgnd = 0;
blk_tbl_indx = 0;	/* image rom background stuff */
hdr_tbl_indx = 0;
max_copies = 3;

lod_dir = imgdir;
raw_dir = NULL;
tbl_dir = NULL;
ovr_dir = NULL;
unidir = NULL;

palette_sup = 0;
//ani_sup = 0;

if (argc < 2)
	{
	instruct ();
	exit(0);
	}

if (argc == 2)
	{
	ch = argv[1][0];
	if ((ch == 'h') || (ch == 'H') || (ch == '?')) goto typehelp;
	if (ch == '/')
		{
		ch = argv[1][1];
		if ((ch == 'h') || (ch == 'H') || (ch == '?')) goto typehelp;
		}
	}


for (i=2; i<argc; i++)
	{
	switch (argv[i][1])
		{
		case '3':
			max_copies = 2;		// limit to copies 0, 1 and 2
			break;

		case 'B':
		case 'b':
			do_superbpp = 0;
			break;

		case 'T':
		case 't':
			do_table = 1;
			tbl_dir = choose_dir(&argv[i][2],tbldirbuf);
			break;

		case 'X':
		case 'x':
			do_load = 0;
			break;

		case '?':
		case 'H':
		case 'h':
typehelp:
			system("type c:\\bin\\load2.hlp | more");
			exit(0);
			break;

		case 'S':
		case 's':
			do_wruniseq = 1;
			break;


		case 'L':
		case 'l':
			do_align = 1;
			break;

		case 'A':
		case 'a':
			do_append = 1;
			break;


		case 'P':
		case 'p':
			do_pad = 1;
			break;

	
		case 'E':
		case 'e':
			dual_bank = 1;
			break;

		case 'V':
		case 'v':
			do_verbose = argv[i][2] - '0';
			if (do_verbose > 5) do_verbose = 0;
			if (do_verbose < 0) do_verbose = 0;
			break;
	

		case 'D':
		case 'd':
			lod_dir = choose_dir(&argv[i][2],loddirbuf);
			break;

		case 'O':
		case 'o':
			do_ovr_dir = 1;
			ovr_dir = choose_dir(&argv[i][2],ovrdirbuf);
			break;

		case 'U':
		case 'u':
			do_uni_dir = 1;
			unidir = choose_dir(&argv[i][2],unidirbuf);
			break;


		case 'F':
		case 'f':
			do_file = 1;
			raw_dir = choose_dir(&argv[i][2],rawdirbuf);
			break;

		case 'R':
		case 'r':
			do_load = 0;
			do_table = 0;
			do_file = 0;
			do_raw_load = 1;
			raw_dir = choose_dir(&argv[i][2],rawdirbuf);
			break;

		case 'I':
		case 'i':
			do_rawbgnd = 1;
			break;

		default:
			printf("\nInvalid Argument...%s\n",argv[i]);
			exit(4);
		}
	}


strcpy(tname,tbl_dir);
strcat(tname,"L2TEMP");
if (!do_append)					// if we are NOT appending to a load...
	{
	remove(tname);				// delete previous temp file
	}

cbuff = (int far *)emm64K();			// for output buffer
cbuff_ptr = cbuff;
init_bd();

/*
 * TRGTADDR is an environment variable to set the HSTDATA address
 * and to relocate the other HOST I/O addresses relative to that.
*/
if (do_load || do_raw_load)
		SetHostIo(getenv("TRGTADDR"),1);


if (do_raw_load) lod_dir = raw_dir;

strcpy(filename,lod_dir);

if (do_file)
	{
	strcpy(rawfilename,raw_dir);
	}

lod_ovr_flg = 0;
if ((nxt=strchr(argv[1],':')) == NULL)
	{			// no drive specified
	strcat(filename,argv[1]);
	if (do_file)
		strcat(rawfilename,argv[1]);
	}
else
	{					  // a drive and possibly path was specified
	lod_ovr_flg = 1;			// indicate directory override
	strcpy(filename,argv[1]);
	if (!strrchr(argv[1],'\\'))
		{				// no backslashes appear
		filename[2]='\0';
		strcat(filename,"\\");
		strcat(filename,++nxt);		// make it the root
		}
	else nxt=strrchr(argv[1],'\\')+1;	// point to name part of path
	if (do_file)			// just name part
		strcat(rawfilename,nxt);
	}

if (do_raw_load)
	{
	strcat(filename,".irw");
	if ( (frawfile = fopen( filename,"rb")) == 0)
		{
		printf( "\nERROR *** Cannot open raw data file: %s\n",
							filename); 
		if (lod_ovr_flg)
			printf("\nRaw File directory taken from command line filespec.\n");
		else printf("\nRaw File is set to be taken from %s directory.\n",
					lod_dir	);
		graceful_exit(3);
		}
	raw_file = fileno(frawfile);
	}
else{
	strcat(filename,".lod");
	if ( (txt = fopen( filename,"r")) == 0) {
		printf( "\nERROR *** Cannot open: %s\n", filename); 
		if (lod_ovr_flg)
			printf("\n.LOD File directory taken from command line filespec.\n");
		else printf("\n.LOD File is set to be taken from %s directory.\n",
					lod_dir	);
		graceful_exit(3);
		}
	}
printf("Loading images ...\n\tfrom: %s\n\t",filename);
if (do_ovr_dir) printf("Images taken from %s\n\t",ovr_dir);
printf("to:   ");

/********************************************************************

	Normally, imgtbl.asm, imgtbl.glo and imgpal.asm are created for writing.
		imgtbl.asm becomes the default ASM file for image headers.
		imgtbl.glo becomes the default file for .globals.
		imgpal.asm is where all non-BLIMP palettes are placed.

	When the /A option is used for multiple loads...
		imgtbl.asm is opened for reading, & scanned for image names.
		imgtbl.glo is opened for appending.
		imgpal.asm is opened for appending, old palettes are scanned for names.

		AN ASM DIRECTIVE MUST APPEAR AT THE START OF A .LOD FILE WHEN THE /A OPTION
		IS USED SO THAT IMG HEADERS HAVE SOME PLACE TO GO!!!
		THE GLO DIRECTIVE IS OPTIONAL.  

***************************************************************************/


if (do_table)
	{
	printf("Table header files (written to directory %s)\n\t      ",tbl_dir);
	strcpy(filename,tbl_dir);
	strcat(filename, dflt_asm_file);
	if ( (src = fopen( filename,(do_append) ? "r":"w")) == 0)
		{	/* quit unable to create file */
		printf( "ERROR *** Can not create: %s\n", filename ); 
		graceful_exit(5);
		}

	strcpy(filename,tbl_dir);
	strcat(filename, dflt_gbl_file);
	if ( (glo = fopen( filename,(do_append) ? "a":"w")) == 0)
		{ /* quit unable to create file */
		printf( "ERROR *** Can not create: %s\n", filename ); 
		graceful_exit(6);
		}
	gbl_fptr = glo;

	strcpy(filename,tbl_dir);
	strcat(filename, dflt_pal_file);
	if ( (imgpal = fopen( filename,(do_append) ? "r":"w")) == 0)
		{ /* quit unable to create file */
		printf( "ERROR *** Can not open: %s\n", filename ); 
		graceful_exit(8);
		}

	if (do_append)
		{
		build_img_name_table();
		build_pal_name_table();
		asm_fptr = NULL;
		fclose(imgpal);
		if ( (imgpal = fopen( filename,"a")) == 0)
			{ /* quit unable to create file */
			printf( "ERROR *** Can not reopen: %s\n", filename ); 
			graceful_exit(8);
			}
		}
	else {
		fprintf (src, "\t.FILE \"%s\"\n",dflt_asm_file);
		fprintf (src, "\t.OPTION B,D,L,T\n");
		fprintf (src, "\n\t.include %s\n", dflt_gbl_file);
		fprintf (src, "\t.DATA\n\t.even\n");

		fprintf (imgpal, "\t.FILE \"%s\"\n",dflt_pal_file);
		fprintf (imgpal, "\t.OPTION B,D,L,T\n");
		fprintf (imgpal, "\n\t.include %s\n", dflt_gbl_file);
		fprintf (imgpal, "\t.DATA\n\t.even\n");
		asm_fptr = src;
		}
	}


if (do_load || do_raw_load)
	{
	hstctlh_save = GetHSTCTLH(); 		/* Save the current host control */
#ifdef W020
	SetHSTCTLH(HLT|NMI|NMIM|CF);
#else
	SetHSTCTLH(HLT|NMI|NMIM|CF|INCWR);
#endif
	printf("GSP target system.\n\t      ");
	}


/* Attempt to open raw output file if we need to */

if (do_raw_load)
	{
	load_raw_file();
	goto rawfinis;
	}

if (do_file)
	{
	strcat(rawfilename,".irw");
	if ( (raw_file = open(rawfilename,O_CREAT | O_RDWR | O_BINARY | O_TRUNC,S_IWRITE)) <= 0)
		{
		printf( "ERROR *** Cannot create output file %s\n", rawfilename ); 
		graceful_exit(-6);
		}
	if (dbg_verbose) printf("raw file created (%s, %d)\n",rawfilename,raw_file);
	strcpy(raw_hdr.version,VERSION);
	raw_hdr.magic_num = RAW_MAGIC;
	raw_hdr.ver_cksum = 0;
	for(i=0;raw_hdr.version[i] != '\0';i++)
		raw_hdr.ver_cksum += raw_hdr.version[i];
	write(raw_file, (char *) &raw_hdr, sizeof(struct RAW_FILE_HEADER));
	raw_pos = tell(raw_file);
	raw_rec.checksum = 0L;
	raw_rec.byte_count = 0L;
	printf("%s\n\t      ",rawfilename);
	}


if (do_verbose)
	{
	if (do_pad) printf("Padding images to multiple of 4 pixels\n");
	if (do_align) printf("Aligning images to 16-bit boundaries\n");
	}

classify_newaddr(imgaddr);

while ( fgets(astring,255,txt) != NULL )
	{
	if (*astring == '\n') continue;

	/* check for comment chars */
	if (*astring == ';') continue;
	if (*astring == '/') continue;

	*strchr(astring,'\n') = '\0';
	if (strncmp(astring,"--->",4) == 0)
		{									// image list 
		if (do_table)
			{
			if (asm_fptr == NULL)
				{
				printf("\nERROR:  ASM> directive must appear first when /A option is used!\n");
				graceful_exit(7);
				}
			}
		if (!badlibspec)
			{
			linemark = &astring[5];
			while (*linemark != '\0')
				{
				if ((inum=get_next_img()) < 0) continue;
				process_img(img[inum],inum);
				}
			}
		}

	else if (strncmp(astring,"***>",4) == 0) { /* new image addr */
		linemark = &astring[5];
		tempaddr = 0L;
		obank = bank;
		endaddr = 0L;			// make some assumptions
		bank = 0;
		sscanf (linemark, "%lX,%lX,%d", &tempaddr,&endaddr,&bank);
		if (endaddr < 4L) { bank = (int)endaddr;  endaddr = 0L; }
		if (dual_bank)
			{
			SetBank(bank);
			}
		if ((tempaddr != imgaddr)||(obank != bank))
			{
			flush_buffer(0L);
			classify_newaddr(tempaddr);
			}
		}

	else if (strncmp(astring,"PPP>",4) == 0) {	/* new PACKING */
		linemark = &astring[5];
		if (!sscanf (linemark, "%d", &packbits)) packbits=0;
		if ((packbits > 8) || (packbits < 0)) packbits=0;
		}

	else if (strncmp(astring,"IHDR",4) == 0) {	/* Img Hdr style */
		nxt = &astring[5];
		if (do_table)
			{
			tblind = 0;
			while (linemark=nxt)
				{
				if (nxt = strchr(linemark,','))  *nxt++ = '\0';
				process_table_style(linemark,tblind++);	// Create STYLE structure
				}
			table_style[tblind].field = 0;	// terminate
			}
		}

	else if (strncmp(astring,"BBB>",4) == 0) {	/*background*/
		nxt = &astring[5];				/* point to first filename of line */
		while (linemark = nxt) {
			if (nxt = strchr(linemark,','))  *nxt++ = '\0';
			expand_filespec(linemark,bgndname);
			if (do_verbose)	printf ("\nLoading Background %s\n", bgndname);
			if (do_table && (!bgfiles_open))
				{
				bgfiles_open = 1;
				strcpy(filename, tbl_dir);
				strcat(filename,"bgndequ.h");
				if ( (bgndequ = fopen(filename,(do_append) ? "a":"w")) == 0)
					{			/*quit unable to create file*/
					printf( "ERROR *** Can not create: %s\n",filename); 
					graceful_exit(7);
					}
				strcpy(filename, tbl_dir);
				strcat(filename,"bgndtbl.asm");
				if ( (bgndtbl = fopen(filename,(do_append) ? "a":"w")) == 0)
					{	/*quit unable to create file*/
					printf( "ERROR *** Can not create: %s\n",filename); 
					graceful_exit(7);
					}
				strcpy(filename, tbl_dir);
				strcat(filename,"bgndpal.asm");
				if ( (bgndpal = fopen(filename,(do_append) ? "a":"w")) == 0)
					{	/*quit unable to create file*/
					printf( "ERROR *** Can not create: %s\n",filename); 
					graceful_exit(9);
					}
				if (!do_append)
					{
					fprintf (bgndtbl, "	.OPTION	B,D,L,T\n");
					fprintf (bgndpal, "	.OPTION	B,D,L,T\n");
					}
				}
			read_bgnd (bgndname);				/* load a background */
			}
		}
	else if (strncmp(astring,"UFN>",4) == 0) {	/* starting universe number */
		linemark = &astring[5];
		sscanf (linemark, "%d", &uni_file_num);
		if (do_verbose) printf("\nChanging to universe number %d",uni_file_num);
		}

	else if (strncmp(astring,"UGL>",4) == 0) {	//user global file
		linemark = &astring[5];	  // point to filename of glotbl 
//		nxt = strchr(linemark,',');
//		if (nxt)
//			{
//			*nxt++ = '\0';
//			strcpy(user_glo_file,nxt);		 // set if supplied
//			}
		strcpy(user_glo_file,linemark);		 // set if supplied
		}
	else if (strncmp(astring,"UNI>",4) == 0) {	/*universe*/
 		/***********************
			Image headers are written into whatever ASM file is current
			(except sequences).
			Image names are not written to any global file (except sequences).
			Images which are part of a sequence are written into imgtbl.glo
			and imgtbl.asm
			                           ************************/
		/***********************
			The directory from which WIMP libraries within a universe
			file are taken is computed as follows...

			If the /U option is used, the directory specified on the
			command line is used for all WIMP libraries in all
			universe files.

			Otherwise, if an individual UNI> line in the .lod file 
			specifies an override directory, that is used for all 
			WIMP libs in the corresponding .uni file.

			Otherwise, the directories specified inside the .uni
			file are used.
												************************/

		savunidir = unidir;
		nxt = &astring[5];	  	/* point to first filename of line */
		savfname = asm_fname;
		do_univ = 1;

		if (do_table)
			{
			savglo = gbl_fptr;
			close_current_asm_file();
			sprintf(filename,"%suni%02d.asm",tbl_dir,uni_file_num);
			if ( (univtbl = fopen(filename,"w")) == 0)
				{	/*quit unable to create file*/
				printf( "ERROR *** Can not create: %s\n",filename);
				graceful_exit(7);
				}
			fprintf (univtbl, "	.OPTION	B,D,L,T\n");
			fprintf (univtbl, "	.include  imgtbl.glo\n");  
					// above is for palettes only.
					// make it a separate imgpal.glo at a later date
			fprintf (univtbl, "	.include  univtbl.glo\n");
			fprintf (univtbl, "	.include  uni%02d.tbl\n",uni_file_num);

			sprintf(filename,"%suni%02d.tbl",tbl_dir,uni_file_num);

//			if (num_asm_files == MAX_ASM_FILES)
//				{
//				printf ("\nERROR: Too many ASM files, increase const MAX_ASM_FILES in load2.c");
//				graceful_exit (1);
//				}
			asm_fname = (char *) malloc (10);
			if (!asm_fname)
				{
				printf ("\nCan't get space for asm file name uni%02d.tbl.", uni_file_num);
				graceful_exit (1);
				}

			sprintf(asm_fname,"uni%02d.tbl",uni_file_num);
			asm_fileno = num_asm_files;
//			asm_file [num_asm_files++] = asm_fname;
//			inames[num_asm_files] = NULL;
			if_exists_make_backup(filename);

			if ( (asm_fptr = fopen(filename,"w")) == 0)
				{	/*quit unable to create file*/
				printf( "ERROR *** Can not create: %s\n",filename);
				graceful_exit(7);
				}

			if (frst_uni_flg)		// open glo file only on first universe
				{
				frst_uni_flg = 0;

				fprintf (imgpal, "\n\t.include univtbl.glo\n");
						// universe palettes are declared in univtbl.glo

				if (do_wruniseq)
					{
					strcpy(filename, tbl_dir);
					strcat(filename,"univseq.new");
					if ( (univseq = fopen(filename,(do_append) ? "a":"w")) == 0)
						{	/*quit unable to create file*/
						printf( "ERROR *** Can not create: %s\n",filename);
						graceful_exit(7);
						}
					}

				strcpy(filename, tbl_dir);
				strcat(filename,"univtbl.glo");
				if ( (univglo = fopen(filename,(do_append) ? "a":"w")) == 0)
					{	/*quit unable to create file*/
					printf( "ERROR *** Can not create: %s\n",filename);
					graceful_exit(7);
					}
				if (!do_append)
					{
					fprintf (univglo, "	.OPTION	B,D,L,T\n");
					if (user_glo_file[0])
						fprintf (univglo, "  .include %s\n", user_glo_file);
					if (do_wruniseq)
						{
						fprintf (univseq, "	.include  univtbl.glo\n");
						fprintf (univseq, "	.ref   OBJ_ON,OBJ_OFF\n");
						fprintf (univseq, "* Don't forget to .include macro file and global afunc symbol file!\n");
						}
					}
				}
			gbl_fptr = univglo;
			}

		while (linemark=nxt) {
			if (nxt = strchr(linemark,','))  *nxt++ = '\0';
			if (!do_uni_dir && (dnxt = strchr(linemark,';')))
				{
				*dnxt++ = '\0';
				if (dnxt[strlen(dnxt)-1] != '\\')	strcat(dnxt,"\\");
				unidir = dnxt;			// temporary override specified in .lod file
				}
			expand_filespec(linemark,bgndname);
			if (do_verbose)	printf ("\nLoading Universe %s\n", bgndname);
			read_univ (bgndname,unidir); 			/* load a universe */
			}
		do_univ = 0;
		if (do_table)
			{
			fflush(univglo);
			fclose(univtbl);
			fclose(asm_fptr);
			free(asm_fname);
			open_asm_file(savfname);
			gbl_fptr = savglo;
			}
		unidir = savunidir;
		uni_file_num++;
		change_temp_marks();
		}
	else if (strncmp(astring,"FRM>",4) == 0) {	/* video frames */
		nxt = &astring[5];	  	/* point to first filename of line */
		while (linemark=nxt) {
			if (nxt = strchr(linemark,','))  *nxt++ = '\0';
			expand_filespec(linemark,bgndname);
			if (do_verbose)	printf ("\nLoading Frames in %s at %lx", bgndname,imgaddr);
			read_frames (bgndname);				/* load frame file */
			}
		}
	else if (!strncmp(astring,"GLO>",4)) {	/* global decls to new file */
		if (!do_table) goto gbl_file_open;

		/* close file already open */
		if (gbl_fptr != glo) {
			if (fclose (gbl_fptr) == EOF) {
				printf ("\nError closing file %s", gbl_fname);
				graceful_exit (1);
				}
			}

		linemark = &astring[5];				/* point to first filename of line */
/*		printf ("\nswitching to glo file %s", linemark); */
		if (!strcmpi (dflt_gbl_file, linemark)) {
			gbl_fileno = -1;
			gbl_fptr = glo;
			goto gbl_file_open;
			}
		for (g = 0; g < num_gbl_files; g++) {
			if (!strcmpi (gbl_file[g], linemark)) {
				/* got an already used file, reopen it.. */
				gbl_fname = gbl_file [g];
				gbl_fileno = g;
				strcpy(filename,tbl_dir);
				strcat(filename,gbl_fname);
				gbl_fptr = fopen (filename, "a");
				if (!gbl_fptr) {
					printf ("\nCan't reopen %s for writing.", filename);
					graceful_exit (1);
					}
				goto gbl_file_open;
				}
			}
		/* must open a new file, but first record the name */
		if (num_gbl_files == MAX_GBL_FILES) {
			printf ("\nERROR *** Too many GLO files, increase const MAX_GBL_FILES in load2.c");
			graceful_exit (1);
			}

		gbl_fname = (char *) malloc (strlen (linemark)+1);
		if (!gbl_fname) {
			printf ("\nCan't get space for global file name %s.", linemark);
			graceful_exit (1);
			}
		strcpy (gbl_fname, linemark);
		fprintf (src, "\n	.include %s\n", gbl_fname);
		gbl_fileno = num_gbl_files;
		gbl_file [num_gbl_files++] = gbl_fname;
		strcpy(filename,tbl_dir);
		strcat(filename,gbl_fname);
		gbl_fptr = fopen (filename, "w");
		if (!gbl_fptr) {
			printf ("\nCan't open %s for writing.", filename);
			graceful_exit (1);
			}
gbl_file_open:;
		}

	else if (!strncmp(astring,"ASM>",4))
		{									// image table to new file 
		if (do_table)
			{

			close_current_asm_file();

			linemark = &astring[5];	  /* point to filename of line */
	/*		printf ("\nswitching to asm file %s", linemark); */
			if (nxt = strchr(linemark,','))
				{
				// nxt points to section name if there is one
				*nxt++ = '\0';
				for (dnxt = nxt; *dnxt ; ) *dnxt++ = toupper(*dnxt);
				if (strcmp(nxt,"DATA") == 0)
									strcpy(ihdr_sect,nxt);
				else sprintf(ihdr_sect,"sect  \"%s\"",nxt);
				}
			if (!strcmpi (dflt_asm_file, linemark))
				{
				asm_fileno = -1;
				asm_fptr = src;
				}
			else open_asm_file(linemark);
			}
		}

	else if (strncmp(astring,"ROM>",4) == 0) 	/* protect range from loading */
		{
		linemark = &astring[5];
		sscanf (linemark, "%lX", &IROMST);		// start of protected range
		linemark = strchr(linemark,',') + 1;
		sscanf (linemark, "%lX", &IROMEND);		// end of protected range
		printf("\nAddresses %lx to %lx designated as ROM. Will not be written to.",
					IROMST,IROMEND);
		}

	else if (strncmp(astring,"CON>",4) == 0) 	/* check sums are on */
							do_cksum = 1;

	else if (strncmp(astring,"COF>",4) == 0) 	/* check sums are off */
							do_cksum = 0;

	else if (strncmp(astring,"PON>",4) == 0) 	/* LOAD PALETTES TO TABLES */
							palette_sup = 0;

	else if (strncmp(astring,"POF>",4) == 0) 	/* SUPPRESS PALETTES TO TABLES */
							palette_sup = 1;

	else if (strncmp(astring,"ZON>",4) == 0)  /* DO ZERO COMPRESSION */
						{  do_zcom = 1;	do_zall = 0; }

	else if (strncmp(astring,"ZAL>",4) == 0)  /* DO ZERO COMPRESSION ALWAYS */
						{  do_zcom = 1;	do_zall = 1; }

	else if (strncmp(astring,"ZOF>",4) == 0)  /* DON'T EVEN THINK ABOUT IT! */
						   do_zcom = 0;

	else if (strncmp(astring,"XON>",4) == 0) 	/* WRITE Extra zeros to right and bottom */
							do_sclpad = 1;

	else if (strncmp(astring,"XOF>",4) == 0) 	/* NO Extra zeros to right and bottom */
							do_sclpad = 0;

	else if (strncmp(astring,"MOF>",4) == 0) 	// Multipart box off
							mpboxon = 0;

	else if (strncmp(astring,"MON>",4) == 0) 	// Multipart box on
							mpboxon = 1;

	else if (strncmp(astring,"BOF>",4) == 0) 	// Collision box off
							cboxon = 0;

	else if (strncmp(astring,"BON>",4) == 0) 	// Collision box on
							cboxon = 1;


/* All options are exhausted. Must be a new image library */
	else
		{
		close_current_wimplib();

		expand_filespec(astring,filename);
		strcpy(libname,filename);			
		if ((cur_lib = open(filename,O_RDONLY | O_BINARY)) <= 0)
			{
			printf("\nImage Library [%s] could not be opened.",filename);
			badlibspec = 1;
			missinglib++;
/******************************************* OBSOLETE
			while ( (ok = fgets(astring,80,txt)) != NULL )
				{
				*strchr(astring,'\n') = '\0';
				if (*astring == '\n') continue;
				if (*astring == ';') continue;
				if (*astring == '/') continue;
				if (strncmp(astring,"--->",4) == 0) continue;
				if (strncmp(astring,"***>",4) == 0) continue;
				if (strncmp(astring,"PPP>",4) == 0) continue;
				if (strncmp(astring,"BBB>",4) == 0) continue;
				if (strncmp(astring,"IHDR",4) == 0) continue;
				if (strncmp(astring,"FRM>",4) == 0) continue;
				if (strncmp(astring,"GLO>",4) == 0) continue;
				if (strncmp(astring,"ASM>",4) == 0) continue;
				if (strncmp(astring,"ROM>",4) == 0) continue;
				if (strncmp(astring,"CON>",4) == 0) continue;
				if (strncmp(astring,"COF>",4) == 0) continue;
				if (strncmp(astring,"PON>",4) == 0) continue;
				if (strncmp(astring,"POF>",4) == 0) continue;
				if (strncmp(astring,"ZON>",4) == 0) continue;
				if (strncmp(astring,"ZOF>",4) == 0) continue;
				if (strncmp(astring,"UNI>",4) == 0) continue;
				if (strncmp(astring,"USQ>",4) == 0) continue;
				if (strncmp(astring,"UFN>",4) == 0) continue;
//				if (strncmp(astring,"AON>",4) == 0) continue;
//				if (strncmp(astring,"AOF>",4) == 0) continue;

				if ((*astring == '\\') || (*(astring+1) == ':'))
					strcpy(filename,astring);
				else
					sprintf (filename, "%s%s", imgdir, astring);
				break;				
				}
			if (ok == NULL) goto finis;  
******************************************* OBSOLETE    */
			}								
		else {
			if (do_verbose) printf("\nOpening img lib [%s]",libname);
			frm_univ = 0;
			read_imglib();
			load_temp_table(libname);
			badlibspec = 0;
			}
		}
	}

finis:

if (do_rawbgnd)
	{
	fprintf(glo, "\n\t.globl\tBLKTBLPTRS,HDRTBLPTRS\n");
	fprintf(bgndtbl, "\n\t.def\tBLKTBLPTRS,HDRTBLPTRS\n");
	fprintf(bgndtbl, "\nBLKTBLPTRS:\t;block table pointers\n");
	for (i = 0; i < blk_tbl_indx; i++) 
			fprintf(bgndtbl, "\t.long\t0%lXH\n", BLOCK_TABLE[i]);
	fprintf(bgndtbl, "\nHDRTBLPTRS:\t;block table pointers\n");
	for (i = 0; i < hdr_tbl_indx; i++) 
			fprintf(bgndtbl, "\t.long\t0%lXH\n", HEADER_TABLE[i]);
	}


if (do_table)
	{
	fclose(src);	
	if (glo != NULL) fclose(glo);	
	fclose(imgpal);
	if (bgfiles_open)
		{
		fclose(bgndtbl);
		fclose(bgndpal);
		fclose(bgndequ);
		}
	if (uni_file_num)		// if not 0, then we opened at least one univ
		{
		fclose(univglo);
		if (do_wruniseq) fclose(univseq);
		}
	/* close file already open */
	if ((asm_fptr != src) && (asm_fptr != NULL))
		{
		if (fclose (asm_fptr) == EOF)
			{
			printf ("\nerror closing file %s", asm_fname);
			graceful_exit (1);
			}
		}
	for (g = 0; g < num_asm_files; g++)
		{
		/* reopen all src tables and append .TEXT on them */
		asm_fname = asm_file [g];
		strcpy(filename,tbl_dir);
		strcat(filename,asm_fname);
		asm_fptr = fopen (filename, "a");
		if (!asm_fptr)
			{
			printf ("\nCan't reopen %s for writing.", filename);
			graceful_exit (1);
			}
		else {
			fprintf (asm_fptr, "\n	.TEXT\n%c",(char)0x1a);
			if (fclose (asm_fptr) == EOF)
				{
				printf ("\nerror closing file %s", asm_fname);
				graceful_exit (1);
				}
			}
		}
	}
fclose(txt);


flush_buffer(0L);			// flush buffer completely
/* Write final record of output file and close. */
if (do_file)
	{
	if (dbg_verbose) printf("raw file closed (%d)\n",raw_file);
	close(raw_file);
	}

rawfinis:
if (do_load || do_raw_load)
	{
	if (do_table) hstctlh_save |= HLT;
	else 	hstctlh_save &= CF;      // enable cache for NMI
	SetHSTCTLH(hstctlh_save);		/* Restore the host control */
	}

if (do_raw_load || do_load)
		printf ("\n\nBytes Loaded...");
if (iram_ct)
	printf ("\n\tIMAGE RAM           %10ld dec	%8lX hex", iram_ct, iram_ct);
if (irom_ct)
	printf ("\n\tIMAGE ROM           %10ld dec	%8lX hex", irom_ct, irom_ct);
if (sram_ct)
	printf ("\n\tSCRATCH RAM         %10ld dec	%8lX hex", sram_ct, sram_ct);
if (prom_ct)
	printf ("\n\tPROGRAM ROM         %10ld dec	%8lX hex", prom_ct, prom_ct);

total_ct = (iram_ct + irom_ct + sram_ct + prom_ct);

if ((total_ct) && (!do_raw_load))
	printf ("\n\n\tTOTAL LOAD          %10ld dec	%8lX hex", total_ct, total_ct);

if ((total_ct) && (do_raw_load))
	printf ("\n\n\tTOTAL LOAD          %10ld dec	%8lX hex, in %d record%s.",
				total_ct, total_ct, record_num, (record_num == 1) ? "" : "s");

if (do_file)
	{
	printf ("\n\nBytes Written to Raw File...");
	if (iramrec_ct)
		printf ("\n\tIn IMAGE RAM records   %10ld dec	%8lX hex", iramrec_ct, iramrec_ct);
	if (iromrec_ct)
		printf ("\n\tIn IMAGE ROM records   %10ld dec	%8lX hex", iromrec_ct, iromrec_ct);
	if (sramrec_ct)
		printf ("\n\tIn SCRATCH RAM records %10ld dec	%8lX hex", sramrec_ct, sramrec_ct);
	if (promrec_ct)
		printf ("\n\tIn PROGRAM ROM records %10ld dec	%8lX hex", promrec_ct, promrec_ct);

	totalrec_ct = (iramrec_ct + iromrec_ct + sramrec_ct + promrec_ct);

	if (totalrec_ct)
		{
		printf ("\n\n\tTOTAL bytes written    %10ld dec	%8lX hex, in %d record%s.",
					totalrec_ct,totalrec_ct,record_num, (record_num == 1) ? "" : "s");
		}
	}



if (do_table)
	{
	tempaddr = (howmanytotal+7) >> 3;
	printf("\n\nBytes Represented in Tables ... %ld dec %lX hex",
						tempaddr,tempaddr);
	}

if (zcom_min_fail)
	{
	printf("\n\n%d images were NOT zero-compressed because they are\n\tsmaller than %d pixels wide.",
					zcom_min_fail,ZCOMPIXELS);
	}

if ((do_cksum) && (bgnd_cksum_match))
	{
	printf ("\n\nSkipped %ld duplicate bytes in %d background checksum match%s.",	
			(bgnd_cksum_bits+7)>>3,bgnd_cksum_match,(bgnd_cksum_match == 1)?"":"es");
	}

if ((do_cksum) && (fgnd_cksum_match))
	{
	printf ("\n\nSkipped %ld duplicate bytes in %d foreground checksum match%s.",	
			(fgnd_cksum_bits+7)>>3,fgnd_cksum_match,(fgnd_cksum_match == 1)?"":"es");
	}
if (missinglib)  printf("\n\nWARNING!! Some image libs could not be opened!!!");
printf("\n\n");
graceful_exit( err_cnt);
}


set_default_style(void)
{
int i;
/* Default Table...
	SIZX:W,SIZY:W,SAG:L,ANIX:W,ANIY:W,CTRL:W,PAL:L
*/
for (i=0; i <= 6; i++)
	{
	table_style[i].field = i+1;
	table_style[i].size = ((i==2)||(i==6))? 'L' : 'W';
	}
table_style[i].field = 0;		// terminate
return(0);
}


process_table_style(char *thisone,int indx)
{
char *tmp;
int field = 0;

tmp = strchr(thisone,':');
if (tmp) *tmp++ = '\0';  
table_style[indx].size = (tmp) ? toupper(*tmp) : 'W';
while (!field)
	{
	if (!strcmp(thisone,"SIZX")) field = 1;
	else if (!strcmp(thisone,"SIZY")) field = 2;
	else if (!strcmp(thisone,"SAG")) field = 3;
	else if (!strcmp(thisone,"ANIX")) field = 4;
	else if (!strcmp(thisone,"ANIY")) field = 5;
	else if (!strcmp(thisone,"CTRL")) field = 6;
	else if (!strcmp(thisone,"PAL")) field = 7;
	else if (!strcmp(thisone,"PWRD1")) field = 8;
	else if (!strcmp(thisone,"PWRD2")) field = 9;
	else if (!strcmp(thisone,"PWRD3")) field = 10;
	else if (!strcmp(thisone,"ALT")) field = 11;
	else if (!strncmp(thisone,"PT",2))	  // fields 12-31
		{
		if ((thisone[2] < '0') || (thisone[2] > '9')) return(-1);
		if ((thisone[3] != 'X') && (thisone[3] != 'Y')) return(-1);
		field = 12 + (thisone[3]-'X') + ((thisone[2]-'0')<<1);
		}		
	else return(-1);
	}	
table_style[indx].field = field;
return(0);
}		



create_point_table(void)
{
if (pt_indx > MAX_PTTBL)
	{
	printf("\nLimit exceeded on Point Tables. Ignoring after #%d",pt_indx);
	return(-1);
	}
pt_table[pt_indx] =  (POINT_TABLE *)malloc(sizeof(POINT_TABLE));
if (pt_table[pt_indx] == NULL)
	{
	printf("\nCouldn't malloc struct for Point Table #%d",pt_indx);
	return(-1);
	}
return(pt_indx++);
}



void read_a_seq(FSEQSCR *lseq)
{
struct ANIM_SEQ oldseq;
SEQSCR aseq;
register int j;

if (lib_hdr.temp != 0xabcd)  // version is old wimp
	{
	read (cur_lib, (char *)&oldseq, sizeof(struct ANIM_SEQ));
	strcpy(lseq->name,oldseq.name);
	lseq->num = oldseq.num_frames;
	lseq->flags = 0;
	for (j=NUM_DAM;--j>=0;)	lseq->dam[j] = -1; // assume no damage tables
	}
else if (lib_hdr.version < LGMODLVSN)
	{
	read (cur_lib,(char *)&aseq, sizeof(SEQSCR));
	strcpy(lseq->name,aseq.name);
	lseq->num = aseq.num;
	lseq->flags = aseq.flags;
	for (j=NUM_DAM;--j>=0;)	lseq->dam[j] = -1; // assume no damage tables
	}
else 	read (cur_lib,(char *)lseq, sizeof(FSEQSCR));

}


void read_an_entry(FENTRY *lent,int scrflg)
{
struct ANIM_ENTRY oldent;
ENTRY anent;

if (lib_hdr.temp != 0xabcd)  // version is old wimp
	{
	read (cur_lib, (char *)&oldent, sizeof(struct ANIM_ENTRY));
	lent->indx = oldent.imgind;
	lent->ticks = oldent.ticks;
	}
else if (lib_hdr.version < LGMODLVSN)
	{
	read (cur_lib, (char *)&anent, sizeof(ENTRY));
	lent->indx = anent.indx;
	lent->ticks = anent.ticks;
	}
else	read (cur_lib, (char *)lent, sizeof(FENTRY));
if (scrflg)
	(FSEQSCR *)lent->itemptr = sequence[lent->indx];
else 	
	(IMAGE *)lent->itemptr = (lent->indx < 0) ? NULL: img[lent->indx];
}



//  delete reference to damage in a sequence or image


void delete_damage_ref(int indx, char *dtbl)
{
register int i;

for (i=indx+1; i < NUM_DAM; i++)
	{
	dtbl[i-1] = dtbl[i];
	}
dtbl[i-1] = -1;
}



void remove_damage_refs(int indx)
{											
register int i,j;
char *damtbl;

for (i=lib_hdr.num_images; --i >= 0; )
	{
	damtbl = img[i]->dam;
	for (j=NUM_DAM; --j >= 0; )
		{
		if (damtbl[j] == (char)indx) delete_damage_ref(indx,damtbl);
		if (damtbl[j] > (char)indx) damtbl[j]--;
		}
	}
for (i=lib_hdr.num_seq; --i >= 0; )
	{
	damtbl = sequence[i]->dam;
	for (j=NUM_DAM; --j >= 0; )
		{
		if (damtbl[j] == (char)indx) delete_damage_ref(indx,damtbl);
		if (damtbl[j] > (char)indx) damtbl[j]--;
		}
	}
}



read_imglib()
{
register int  q, z;
int	ni, np, p, ns, qf, nb, nd;
int t,d;
IMAGE *animg;
struct PALETTE oldpal;
int *pntr;

read (cur_lib, (char *) &lib_hdr, sizeof(struct LIB_HEADER));
lseek(cur_lib,lib_hdr.offset,SEEK_SET);

np = lib_hdr.num_palettes;		/* don't count default palettes */
ni = lib_hdr.num_images;
ns = lib_hdr.num_seq;
nb = lib_hdr.num_scripts;
nd = lib_hdr.num_dam;
q = 0;

while (q < ni)
	{
	animg =  (IMAGE *)malloc(sizeof(IMAGE));
	if (!animg)
		{
		printf ("\nERROR *** malloc for img hdr failed.");
		graceful_exit (1);
		}
	if (lib_hdr.temp != 0xabcd)  // read Old WIMP file
		{
		read (cur_lib, (char *)&oldimg, sizeof(struct IMG));
		strcpy(animg->name,oldimg.name);
		animg->xsize = oldimg.xsize;
		animg->ysize = oldimg.ysize;
		animg->xoff = oldimg.xoff;
		animg->yoff = oldimg.yoff;
		animg->palind = oldimg.palind;
		animg->offset = oldimg.offset;
		animg->othpals = animg->pt_tbl = -1;
		for (z=NUM_DAM;--z>=0;)	animg->dam[z] = -1; // no damage tables
		}
	else
		{
		read (cur_lib, (char *)animg, sizeof(IMAGE));
		if (lib_hdr.version < PTTBL_VER) animg->pt_tbl = -1;
		if (lib_hdr.version < OTHPALVSN) animg->othpals = -1; // no other palettes
		if (lib_hdr.version < LGMODLVSN)
			{
			for (z=NUM_DAM;--z>=0;)	animg->dam[z] = -1; // no damage tables
			lseek(cur_lib,-6L,SEEK_CUR);	// adjust for added spares.
			}
		else if (lib_hdr.version >= REVERTVSN)
			lseek(cur_lib,-6L,SEEK_CUR);	// added spares not written.
		}
	animg->flags &= M_COPIES;
	animg->frame = -1;		/* indicated not downloaded to GSP as a frame */
	animg->lib = cur_lib;
	animg->data = 0;
	img[q++] = animg;
	}
z = NUM_DEF_PAL;
while (z < np)
	{
	pal[z] =  (PAL *)malloc(sizeof(PAL));
	if (!pal[z])
		{
		printf ("\nmalloc for pal failed.");
		graceful_exit (1);
		}
	if ((lib_hdr.version < LGMODLVSN) || (lib_hdr.version >= REVERTVSN))
		{
		read (cur_lib,(char *)&oldpal, sizeof(struct PALETTE));
		strcpy(pal[z]->name,oldpal.name);
		pal[z]->bits_pr_pxl = oldpal.bits_pr_pxl;
		pal[z]->num_cols = oldpal.num_cols;
		pal[z]->offset = oldpal.offset;
		pal[z]->cmap = oldpal.cmap;
		pal[z]->flags =  oldpal.flags;
		}
	else
		read (cur_lib,(char *)pal[z], sizeof(PAL));
	pal[z]->flags = 0;
	pal[z++]->cmap &= 0xf;	/* 0-f only valid values */
	}


if (lib_hdr.temp == 0xabcd)  // New WIMP files only
	{

	/* Scan through sequences */

	if (ns)
		{	
		for (qf=0; qf < ns; qf++)
			{
			sequence[qf]=(FSEQSCR *)malloc(sizeof(FSEQSCR));
			if (sequence[qf] == NULL)
				{
				printf("\nCouldn't malloc sequence %d",qf);
				continue;
				}
			read_a_seq(sequence[qf]);
			for (q=sequence[qf]->num; --q >= 0;)
				{
				sequence[qf]->entry[q]=(FENTRY *)malloc(sizeof(FENTRY));
				if (sequence[qf]->entry[q] == NULL)
					{
					printf("\nCouldn't malloc sequence %d, entry %d",qf,q);
					sequence[qf]->num = q;
					break;
					}
				read_an_entry(sequence[qf]->entry[q],0);
				}
			}
		}


	/* Scan through buffers */

	if (nb)
		{	
		for(qf=0; qf < nb; qf++)
			{
			script[qf]=(FSEQSCR *)malloc(sizeof(FSEQSCR));
			if (script[qf] == NULL)
				{
				printf("\nCouldn't malloc script %d",qf);
				continue;
				}
			read_a_seq(script[qf]);
			for (q=script[qf]->num; --q >= 0;)
				{
				script[qf]->entry[q]=(FENTRY *)malloc(sizeof(FENTRY));
				if (script[qf]->entry[q] == NULL)
					{
					printf("\nCouldn't malloc script %d, entry %d",qf,q);
					script[qf]->num = q;
					break;
					}
				read_an_entry(script[qf]->entry[q],1);
				}
			}
		}


	if (lib_hdr.version >= PTTBL_VER)
		{
		for (q=0; q < ni; q++) 		 // NEW SUPPORT FOR POINT TABLES
			{
			if (img[q]->pt_tbl >= 0)
				{
				if ((p=create_point_table()) < 0) break;
				read (cur_lib, (char *)pt_table[p], sizeof(POINT_TABLE));
				img[q]->pt_tbl = p;
				}
			}
		}

	if (lib_hdr.version >= OTHPALVSN)
		{
		for (q=0; q < ni; q++) 		 // NEW SUPPORT FOR POINT TABLES
			{
			if (img[q]->othpals >= 0)
				{
				if ((othpal_table[othpal_indx] = _fmalloc(16)) == NULL)
					{
					printf("Couldn't malloc Alternate Palette Table #%d",othpal_indx);
					break;
					}
				read (cur_lib, othpal_table[othpal_indx], 16);	//FarRead
				img[q]->othpals = othpal_indx++;
				}
			}
		}
	}

if (lib_hdr.version < LGMODLVSN) lib_hdr.num_dam = 0;

d = 0;
if (lib_hdr.num_dam > 0)
	{
	read(cur_lib,imgbuf,lib_hdr.num_dam*sizeof(FSEQSCR *));
	pntr = (int *)imgbuf;
	while (d < nd)
		{
		t = *pntr++;
		if ((t == SEQFLG) || (t == 0))
			{
			if (*pntr < 0)
				{
				printf("Bad index (%d) in damage tbl %d",*pntr,d);
				remove_damage_refs(d);
				nd--;
				lib_hdr.num_dam--;
				}
			else damage[d++] = (t)?sequence[*pntr] : script[*pntr];
			}
		else {
			printf("Bad flag (%d) in damage tbl %d",t,d);
			remove_damage_refs(d);
			nd--;
			lib_hdr.num_dam--;
			}
		pntr++;
		}
	}


return(0);
}


get_next_img()
{
char  *newmark,*tmp;
int	q;

/* get ptr to next image, or end of line */
if ((newmark = strchr(linemark,',')) == 0) 
		/* point to null terminator */
				newmark = &linemark[strlen(linemark)];  
else *newmark++ = '\0';

strt_col = 0;
if ((tmp = strchr(linemark,':')) != 0)
	{
	if (tmp < newmark)
		{
		*tmp++ = '\0';
		while ((*tmp != '\0') && (*tmp != '+'))
			strt_col = (strt_col * 10) + (*tmp++ -'0');
		}
	}

tmp = &linemark[strlen(linemark)-1];
do_qrtr = (*(tmp-1) == '*');
if (do_qrtr)
	{
	do_qrtr = *tmp - '1';		// do_qrtr is 1 if you want 2 versions,
	*(tmp-1) = '\0';				//	2 if you want 3, and 3 if you want 4
	}
if (do_qrtr > 3)
	{
	printf("\n[%s*%c] Mult. copies need *2, *3 or *4. *4 used",linemark,do_qrtr+'1'); 
	do_qrtr = 3;
	}

for (q = lib_hdr.num_images; --q >= 0; )
	{
	if (strcmp(img[q]->name, linemark) == 0) break;
	}
if (q < 0)
	{
	err_cnt++;
	printf("\nCouldn't find image [%s] in library [%s]",linemark,libname);
	}
linemark = newmark;
return q;
}


void	add_safety_column(char far *idata,int xs,int ys)
{
register int i,j;
char far *src,*dst;
unsigned int offset;

offset = xs * ys;
src = &idata[offset];		// end of original data
dst = &src[ys<<2];			// end of final data

for (i = ys; --i >= 0; )
	{
	*--dst = 0;		// new padding
	*--dst = 0;
	*--dst = 0;
	*--dst = 0;
	for (j = xs; --j >= 0; )
		{
		*--dst = *--src;
		}
	}
}		




void	add_safety_row(char far *idata,int xs,int ys)
{
register int i;
char far *dst;
unsigned int offset;

offset = xs * ys;
dst = &idata[offset];		// end of original data

for (i = xs; --i >= 0; )
	{
	*dst++ = 0;		// new padding
	}
}		


char *size_string(char sz)
{
if (sz == 'B') return("byte");
if (sz == 'W') return("word");
if (sz == 'L') return("long");
return("oops");
}



void halve_anioff(IMAGE *animg,int ox, int oy,int fac)
{
register int ttt;

ttt = (1<<fac) - 1;

animg->xoff = (ox + ((ox > 0)? ttt : (-ttt)) ) >> fac;
animg->yoff = (oy + ((oy > 0)? ttt : (-ttt)) ) >> fac;
}




process_img (IMAGE *animg, int ii)
{
register int x,y;
int	p,val,nuround;
unsigned char mark,newmark;
char	*altpal;
int	max,num_cols,sclpadtst;
PAL	*apal;
unsigned char far *ip,*i2p;
char	size,last_size,tblind;
char	savzcom,savsclpad,savldmsk;
unsigned long	endaddr, srcbytes, rimgaddr, checksum, tempaddr;
int	cols,colvar,xmin,ymin,xmax,ymax,xsize,bpp,i,origx;
char	savname,num_copies,*cname;
int	oanix,oaniy,dupit,fgmatchflg;
char	tmp1,*colmap;
int	savxoff,savyoff;

short	w, imgw,imgh;
int	mpbdid1st;
int	mpboxcnt = 0;
int	mpbtdone = 0;
int	mpbxo = 0, mpbyo = 0;
int	mpbw, mpbh;
unsigned char	*mpbe_p;
long	*l_p;


savname = animg->name[0];
savldmsk = loadmsk;   // save flag before it becomes img specific
savzcom = do_zcom;    // save flag before it becomes img specific
savsclpad = do_sclpad;
savxoff = animg->xoff;
savyoff = animg->yoff;

if (do_qrtr)
	{
	oanix = animg->xoff;
	oaniy = animg->yoff;
	num_copies = (do_qrtr > max_copies)? max_copies:do_qrtr; 
							// decremented after each copy
	do_qrtr = 1;		// incremented after each copy
	do_sclpad = 1;		// add extra row/column if img can shrink
	}


if (mpboxon) {

	mpbdid1st = 0;
	y = 0;

	if (animg->pt_tbl >= 0) {

		imgw = animg->xsize;
		imgh = animg->ysize;

		mpbe_p = (char *)pt_table[animg->pt_tbl]+16;
		l_p = (long *)mpbe_p;

		for (x = 0; ++x <= 5; )
			if (*l_p++) y++;

		}

	if (y) {
		mpboxcnt = 5;
		if (do_verbose > 1) printf("\nMPB>");
		}
	else {
		y = 1;
		}

	fprintf(asm_fptr,"\n\t.word\t%d", y);	// Write count
	}


if (do_verbose > 1) printf(" %16s ",animg->name);
if (do_verbose > 2) printf("(%3d by %3d) XO=%d  YO=%d",
				animg->xsize,animg->ysize,animg->xoff,animg->yoff);


mpblp:


if (mpboxcnt > 0) {

	if (*(long *)mpbe_p == 0) {
		mpbe_p += 4;
		goto mpbnxt;
		}

	mpbxo = *mpbe_p++;
	mpbyo = *mpbe_p++;
	mpbw = *mpbe_p++ + 1;
	mpbh = *mpbe_p++ + 1;

	if (mpbw < 4) printf("\n[%s] Multipart box width < 4",animg->name);
	if (do_verbose > 2) printf("\n BOX %u,%u,%u,%u",mpbxo,mpbyo,mpbw,mpbh);

	animg->xsize = imgw;		// Restore
	animg->ysize = imgh;

	animg->xoff = savxoff - mpbxo;
	animg->yoff = savyoff - mpbyo;

	mpbdid1st = 1;
	}


/*  DETERMINE BITS PER PIXEL FOR PACKING  */

cols = pal [animg->palind]->num_cols;

if ( (bpp = packbits) && (cols > (1 << packbits)) )
	{
	printf ("\nImage %s has %d colors. Can't fit into %d bits per pixel.",
					 animg->name, cols, packbits);
	bpp = pal[animg->palind]->bits_pr_pxl;		// override packbits
	}
else if (bpp == 0)
	{
	bpp = pal[animg->palind]->bits_pr_pxl;		// auto pack
	if (do_verbose > 1)
		printf("\n [%s] Auto pixel packing to %d bits",animg->name,bpp);
	}


/* 	LOAD IMAGE DATA       */

if (animg->xsize < MIN_IMG_WIDTH)
	{
	if (do_verbose > 2) printf("\nImage [%s] has width = %d. Padding to %d.",animg->name,
				animg->xsize,MIN_IMG_WIDTH);
	animg->xsize = MIN_IMG_WIDTH;
	}
origx = animg->xsize;
xsize = round_x(animg->xsize);
if (do_sclpad) sclpadtst = (animg->xsize == xsize);
if (do_pad) animg->xsize = xsize;

srcbytes = (unsigned long)(xsize * animg->ysize);
animg->data = imgbuf;
lseek(cur_lib,animg->offset,SEEK_SET);

read(cur_lib, imgbuf, (int)srcbytes);		//FarRead


//컴컴컴컴컴컴컴�


if (mpboxcnt > 0) {		// Copy boxed area to start of buffer

	ip = animg->data;
	i2p = ip + mpbxo + xsize * mpbyo;

	animg->xsize = mpbw;
	animg->ysize = mpbh;

	for (y = mpbh; --y >= 0; ) {

		for (x = mpbw; --x >= 0; ) {
			*ip++ = *i2p++;
			}

		for (x = ((mpbw + 3) & ~3) - mpbw; --x >= 0; ) *ip++ = 0;

		i2p += xsize - mpbw;
		}

	xsize = round_x(animg->xsize);
	srcbytes = (unsigned long)(xsize * animg->ysize);
	}


//컴컴컴컴컴컴컴�

/*  HANDLE A NON-ZERO START COLOR (IMAGE DATA SHIFTED UP)

		This also does checking to see if the selected bpp
		is valid for the shifted color range.
*/

if (strt_col)		// if we are shifting up in the palette
	{
	max = 0;
	ip = animg->data;
	for (y = animg->ysize; --y >= 0; )
		{
		for (x = xsize; --x >= 0; ip++ )
			{
			if (*ip)		  // leave zero's alone
				{
				if ((*ip += strt_col) > max)	max = *ip;
				}
			}		
		}
	i = bpp;   // use as flag to indicate no change to bpp.
	while (max >= (1 << bpp))
		{
		if (++bpp > 8) 
			{
			printf("\nImage %s can't start at color %d. (exceeds 256 colors)",
							animg->name,strt_col);
			ip = animg->data;				// Undo shift up.
			for (y = animg->ysize; --y >= 0; )
				{
				for (x = xsize; --x >= 0; ip++ )
					{
					if (*ip)		  // leave zero's alone
						{
						*ip -= strt_col;
						}
					}		
				}
			strt_col = 0;
			bpp = i;  //restore original bpp
			break;
			}
		}
	if (i != bpp)		// change was made due to strt_color
		{
		printf("\nImage %s: bpp changed from %d to %d due to start color=%d.",
								animg->name,i,bpp,strt_col);
		}
	}
else if ((packbits == 0) && (do_superbpp))
	{								// scan image to see if max pixel allows smaller bpp 
	max = 0;
	ip = animg->data;
	for (y = animg->ysize; --y >= 0; )
		{
		for (x = xsize; --x >= 0; ip++ )
			{
			if (*ip > max)	max = *ip;
			}		
		}
	if (max == 1) bpp = 1;
	else if (max < 4) bpp = 2;
	else if (max < 8) bpp = 3;
	else if (max < 16) bpp = 4;
	else if (max < 32) bpp = 5;
	else if (max < 64) bpp = 6;
	else if (max < 128) bpp = 7;
	}






/*  HANDLE ZERO COMPRESSION  (Final bpp must be known by now) */

if (do_qrtr)
	{
	if (do_zcom && (do_verbose>2))
		printf("\nZero compression turned OFF for scaling image [%s]",animg->name);
	do_zcom = 0;   // Don't zero compress scaling images
	}

if (do_zcom && (animg->xsize <= ZCOMPIXELS))
	{
	do_zcom = 0;
	if (do_verbose > 1)
	  	printf("\nCan't Zero-compress image [%s] (Need %d non-zero pixels minimum.)",animg->name,ZCOMPIXELS);
	zcom_min_fail++;
	}

//컴컴컴컴컴컴컴�

qrtrpass:

fgmatchflg = 0;

if (do_sclpad)			// Add column of zeros and a bottom row of zeros?
	{
	if (sclpadtst)
		{
		add_safety_column(animg->data,xsize,animg->ysize);
		xsize+=4;
		if (do_pad) animg->xsize = xsize;
		}
	if (!do_pad) animg->xsize++;
	add_safety_row(animg->data,xsize,animg->ysize++);
	srcbytes = (unsigned long)(xsize * animg->ysize);
	}

//		Make Some Assumptions
destbits = (unsigned long) (animg->xsize * animg->ysize) * (long)bpp;
dma2_field = (bpp&7) << 12;	// BPP,TM,LM,CMP fields all set.


/********************************************************
	WFD!!!

	Everything has been added to implement this feature except
	to modify zcom.c to check the do_zall flag and compute and return a
	number representing the dma2 control field if the flag is non-zero.

	do_zall is an int, and is global.

	To compile (on my c:\video\loadimg directory only) type...

C:\VIDEO\LOADIMG>  makeld2 /D load2 ldbgnd2

	the new load2.exe will be in that directory.

***********************************************************/

if (do_zcom)
	{
	if (do_zcom = zcom_analysis(animg->data,animg->ysize,animg->xsize,bpp))
		{		// if above returns 0, assumptions were correct, otherwise...
		dma2_field = do_zcom;	// BPP,TM,LM,CMP fields all set.
		do_zcom = 1;
		}
	}

if (do_align) destbits = (destbits + 15) & ~0xfL;
rimgaddr = tempaddr = imgaddr;

/*  COMPUTE CHECKSUM AND SEARCH FOR PREVIOUSLY LOADED MATCH */

if (do_cksum) 
	{
	checksum = getcksum ((int far *) animg->data, srcbytes >> 1, NULL);
	if ((tempaddr = srch_bd(animg->xsize, animg->ysize, checksum, dma2_field)) != -1L)
		{
		if (do_verbose > 2)
			  printf("\nChecksum match on image [%s].", animg->name);
		fgnd_cksum_match++;
		fgmatchflg = 1;			// so name check knows.

		/* NOTE:  It is possible for an image to match both a previously loaded
		  			 image's data and a DIFFERENT previously loaded image's
		  			 name. In this case, load2 will correctly ignore the
		  			 second loading, but use of the image's name will reference
		  			 the FIRST image which used that name.
		*/

		fgnd_cksum_bits += destbits;
		loadmsk = 0;				// disable loading of this image
		rimgaddr = tempaddr;
		}
	}

/*  ADJUST IMGADDR AND CHECK FOR ADDRESS OVERFLOW */

if (imgaddr == rimgaddr)	// skip following if checksum matched.
	{
	if (add_to_imgaddr(destbits) < 0)
		{
		animg->name[0] = savname;
		printf("\nImage %s exceeds current RAM section!",animg->name);
		goto earlyabt;
		}
	else {
		ins_blockdata (animg->xsize, animg->ysize, checksum, rimgaddr, dma2_field);
		howmanytotal += destbits;
		}
	}

/*  DO THE LOAD */

if (loadmsk && (do_load || do_file))
	{
	flush_buffer(destbits); 		// flush buffer only if necessary
	load_block(animg->xsize,animg->ysize,dma2_field,(4-animg->xsize)&3);
								// output buffer stuffed with data
	if (do_verbose > 3) printf("\nLOADED");
	}

/*  DO TABLE BULLSHIT */

if (!(dupit = dup_name_check(animg->name,asm_fileno+1,1)))
	{
	if (do_cksum && (!fgmatchflg))  // If data didn't match, could be bad
		{
		printf("\nWARNING! Two different images named [%s] have been detected!\n",animg->name);
		}
	num_copies = 0;		// ignore either way
	}


if (do_table && animg->name[0])
	{
	mark = (unsigned char)get_temp_mark(temp_img_data,ii);
	if (mark == 0)
		{			  	// write img header and mark as such
		if (part_of_seq)	
			{
			fprintf(univglo,"   .global   %s   ; img in sequence\n",animg->name);
			set_temp_mark(temp_img_data,ii,0xa);
			}
		else {
			if (gbl_fptr == univglo) newmark = 2;
			else if ((asm_fptr == src) && (gbl_fptr == glo)) newmark = 3;
			else newmark = 1;
			set_temp_mark(temp_img_data,ii,newmark);
			if (!dupit && fgmatchflg)
					printf("\nWARNING! Identical images named [%s] exist in more than one .img library!\n",animg->name);
			}
		}
	if (mark >= 4)   // ok to write global if not done already
		{
		if (do_qrtr < 2)
			{
			if (do_univ)
				{
				if (!(mark & 2))
					{
					fprintf(univglo,"   .global   %s   ; new check\n",animg->name);
					set_temp_mark(temp_img_data,ii,(UCHAR)(mark|2));
					}
				}
			else if (!(mark & 1))
				{
		//				  ??? should it be glo or gbl_fptr? WBD 11/30/93
				fprintf(glo,"   .global   %s   ; new check\n",animg->name);
				set_temp_mark(temp_img_data,ii,(UCHAR)(mark|1));
//				if ((mark & 0xc) == 8)
//					{		// if defined in universe, put in univtbl.glo too
//					if (!(mark & 2))
//						{
//						fprintf(univglo,"   .global   %s   ; new check\n",animg->name);
//						set_temp_mark(temp_img_data,ii,(UCHAR)(mark|2));
//						}
//					}
				}
			}
		}
	if (mark != 0)	  	// if anything other than zero, abort further processing.
		{
		dupit = 0;
		num_copies = 0;
		}
	}

if (do_table && dupit)
	{
	if ((colvar = animg->palind) < 3) colmap = "NULL";
	else colmap = pal[colvar]->name;

	if (*animg->name)	fprintf(asm_fptr,"\n%s:",animg->name);

	last_size = 0;
	for (tblind = 0; table_style[tblind].field != 0; tblind++)
		{
		size = table_style[tblind].size;

		if (mpboxcnt > 0 && table_style[tblind].field > 6)
			if (mpbtdone) continue;		// Full already printed?

		switch(table_style[tblind].field)
			{
			case 1:			// XSIZE
				if (last_size == size)
						fprintf(asm_fptr,",%d", animg->xsize);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size),animg->xsize);
						last_size = size;
						}
				break;

			case 2:			// YSIZE
				if (last_size == size)
						fprintf(asm_fptr,",%d", animg->ysize);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size),animg->ysize);
						last_size = size;
						}
				break;

			case 3:			// SAG
				tempaddr = rimgaddr;
				if (dual_bank) tempaddr += (bank)?0x2000000L : -0x2000000L;
				if (last_size == size)
						fprintf(asm_fptr,",0%lxH", tempaddr);
				else	{
						fprintf(asm_fptr,"\n\t.%s   0%lxH", size_string(size),tempaddr);
						last_size = size;
						}
				break;

			case 4:			// ANIOFF X
				if (last_size == size)
						fprintf(asm_fptr,",%d", animg->xoff);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size),animg->xoff);
						last_size = size;
						}
				break;

			case 5:			// ANIOFF Y
				if (last_size == size)
						fprintf(asm_fptr,",%d", animg->yoff);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size),animg->yoff);
						last_size = size;
						}
				break;

			case 6:			// CONTROL
				if (last_size == size)
						fprintf(asm_fptr,",0%xH", dma2_field);
				else	{
						fprintf(asm_fptr,"\n\t.%s   0%xH", size_string(size),dma2_field);
						last_size = size;
						}
				break;

			case 7:			// PAL
				if (!palette_sup)
					{
					insert_palname (colmap, gbl_fileno);
					palette_to_file (colmap, colvar);
					if (last_size == size)
							fprintf(asm_fptr,",%s", colmap);
					else	{
							fprintf(asm_fptr,"\n\t.%s   %s", size_string(size),colmap);
							last_size = size;
							}
					}
				break;


			case 8:			// PWORD1
				x = *(short *)&animg->dam[0];
				if (x != -1 || *(long *)&animg->dam[2] != -1)
					x -= mpbxo;
				if (last_size == size)
						fprintf(asm_fptr,",%d", x);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size), x);
						last_size = size;
						}
				break;


			case 9:			// PWORD2
				x = *(short *)&animg->dam[2];
				if (*(short *)&animg->dam[0] != -1 || *(long *)&animg->dam[2] != -1)
					x -= mpbyo;
				if (last_size == size)
						fprintf(asm_fptr,",%d", x);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size), x);
						last_size = size;
						}
				break;


			case 10:			// PWORD3
				if (last_size == size)
						fprintf(asm_fptr,",%d", *(int *)&animg->dam[4]);
				else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size),*(int *)&animg->dam[4]);
						last_size = size;
						}
				break;


			case 11:			// ALTERNATE PALS
				if (!palette_sup)
					{
					last_size = size;
					if (animg->othpals >= 0)
						{
						altpal = othpal_table[animg->othpals];
						for (i=0; i < 16; i++)
							{
							if (altpal[i] < 0) break;
							cname = pal[altpal[i]]->name;
							insert_palname (cname, gbl_fileno);
							palette_to_file (cname, altpal[i]);
							if (!(i&3))			// four to a line
								fprintf(asm_fptr,"\n\t.%s  ", size_string(size));
							fprintf(asm_fptr,"%c%s", (i&3)?',':' ',cname);
							}
						}
					fprintf(asm_fptr,"\n\t.%s  -1   ;Terminate alternate palettes",
									size_string(size));
					}
				break;



			default:
				x = table_style[tblind].field - 12;
				if ((unsigned int)x > 19)
					printf("\nInvalid field value in table style!");
				else {
					if ((p=animg->pt_tbl) >= 0)
						{
						y = x >> 1;     // index
						val = (x&1) ? pt_table[p]->pt[y].y : pt_table[p]->pt[y].x;
						}
					else val = 0;
					if (last_size == size)
						fprintf(asm_fptr,",%d", val);
					else	{
						fprintf(asm_fptr,"\n\t.%s   %d", size_string(size),val);
						last_size = size;
						}
					}
				break;
			}
		}

	if (cboxon) {

		if (!mpbtdone) {

			if ((p = animg->pt_tbl) >= 0) {
				x = ((char)pt_table[p]->pt[9].x ) - savxoff;
				y = ((char)(pt_table[p]->pt[9].x >> 8)) - savyoff;
				fprintf(asm_fptr,"\n\t.word	%d,%d", x,y);
				x = (pt_table[p]->pt[9].y & 0xff);
				y = ((pt_table[p]->pt[9].y >> 8) & 0xff);
				fprintf(asm_fptr,",%d,%d", x,y);
				}
			else fprintf(asm_fptr,"\n\t.word	0,0,0,0");
			}
		}


	if (do_qrtr < 2)
		{
		/********************************************************

		   The image name gets placed in the current global file if...
				the current asm_file is imgtbl.asm    OR...
				the current gbl_file is NOT imgtbl.glo

		*********************************************************/
		if (!do_univ && animg->name[0])
			{
			if ( (asm_fptr == src) || (gbl_fptr != glo) )
				{
				fprintf(gbl_fptr,"	.global	%s\n",animg->name);
				}
			}
		}


	mpbtdone = 1;	// Flag full table as printed

	}



if (num_copies-- == 0) do_qrtr = 0;    // stop shrinking
if (do_qrtr == 1)
	{
	if ((xsize < 8) || (animg->ysize < 4))
    	printf("\nImage [%s] Too Small for Half Shrink.",animg->name);
	else	{
		num_cols = read_pal(animg->palind);
		half_shrink_smple(xsize,animg->ysize,animg->data);
		animg->name[0] = '\0';
		animg->ysize = (animg->ysize+1)>>1;
		goto qrtr2;
		}
	}
else if ((do_qrtr == 2) || (do_qrtr == 3))
	{
	if (do_qrtr == 3)
		{
//		half_shrink_smple(xsize,animg->ysize,animg->data);
		half_shrink_avg(xsize,animg->ysize,animg->data,PalBuf,num_cols);
		if ((animg->ysize >>= 1) == 0) animg->ysize = 1;
		}
	else
		{
		half_shrink_smple(xsize,animg->ysize,animg->data);
		animg->ysize = (animg->ysize+1)>>1;
		}
qrtr2:
	nuround = round_x((xsize>>1));
	animg->xsize = origx = (origx+1)>>1;
	xsize = round_x(animg->xsize);
	if (do_sclpad) sclpadtst = (animg->xsize == nuround);
	if (do_pad)
		{
		if (do_sclpad && (animg->xsize == xsize)) animg->xsize = nuround;
		else                                		animg->xsize = xsize;
		}
	xsize = nuround;
//	if ((!do_pad) && (animg->xsize < 4)) animg->xsize = xsize-1;
	halve_anioff(animg,oanix,oaniy,do_qrtr);
	srcbytes = (unsigned long)(xsize * animg->ysize);
	do_qrtr++;
	loadmsk = savldmsk;		// restore flag for next shrunk size
	goto qrtrpass;
	}

mpbnxt:
if (--mpboxcnt > 0) {
	if (mpbdid1st)	animg->name[0] = '\0';
	loadmsk = savldmsk;
	do_zcom = savzcom;
	goto mpblp;
	}

animg->flags |= LOADED;
earlyabt:
animg->xoff = savxoff;
animg->yoff = savyoff;
do_sclpad = savsclpad;
do_zcom = savzcom;		// restore flag to pre-img-specific state.
loadmsk = savldmsk;		// restore flag to pre-img-specific state.
animg->name[0] = savname;
return 1;
}





#include "zcom.c"



/*************************************************************************
 insert_palname -
	Search for the passed name and file number, if they aren't found
	insert them into their respective lists and write the palette name
	to the current .glo file.
	Also write palette name on 'imgtbl.glo' if it hasn't been already.
	A match only occurs if both the pallist array matches
	the string, and the parallel array pallstf matches the file number.
*************************************************************************/
void insert_palname (palstring, fileno)
char *palstring;
int	fileno;
{
int i;
FILE	*tmp_fptr;

	if (fileno != -1) {
		tmp_fptr = gbl_fptr;
		gbl_fptr = glo;
		insert_palname (palstring, -1);
		gbl_fptr = tmp_fptr;
		}

	for (i=0;i<palindex;i++){
		if (fileno == pallstf[i]) {
			if ((strcmp(palstring, pallist[i])) == 0)
				return;
			}
		}
	if (palindex == NUMPALS) {
		printf ("\nMax number of palettes %d exceeded, ", NUMPALS);
		printf ("increase constant NUMPALS in load2.c");
		graceful_exit (1);
		}
 	//				  for universes, all palettes are written to imgtbl.glo
	//					otherwise, written to current global file.
	//					(in universes, current global is univtbl.glo)
	fprintf ((do_univ)?glo:gbl_fptr,"\t.globl\t%s\n", palstring);
	strcpy(pallist [palindex], palstring);
	pallstf [palindex] = fileno;
	palindex++;
	return;
}


/*************************************************************************
*                                                                        *
* palette_to_file - write this palette to imgpal.asm if it has not		 *
* 						already been written.											 *
*                                                                        *
*************************************************************************/
palette_to_file(palname,palnum)
char *palname;
int palnum;
{
int i;

if((!exist_imgpal(palname)) && (srch_pname(palname) == -1))
	{			 
	strcpy(imgpal_list[imgpalidx++], palname);									 
	write_palette(palnum);		 /*Write the palette to imgpal.asm*/
	}																							 
return(0);
}

/*************************************************************************
*                                                                        *
* exist_imgpal - see if palette already exists in imgpal.asm				 *
* returns:																					 *
* 		TRUE if there is one																 *
* 		FALSE if not																		 *
*                                                                        *
*************************************************************************/
int exist_imgpal(palname)
char	*palname;
{
int i;
	for (i=0;i<imgpalidx;i++){
		if ((strcmp(palname, imgpal_list[i])) == 0) return 1;
	}				
	return 0;
}

write_palette(palnum)
int palnum;
{
int	*datptr, ctr, midline;
int colcount=0;

	read_pal(palnum);
	fprintf(imgpal, "\n%s:",pal[palnum]->name);
	datptr = PalBuf;
	midline	= 0;

	fprintf(imgpal, "\n\t.word	%3d",pal[palnum]->num_cols); /*output color count 1st*/

	for( ctr=0; ctr < pal[palnum]->num_cols ; ctr++)
	{
		if(!midline || (colcount == 7)){
			fputs("\n\t.word\t",imgpal);
			colcount	= 0;
			midline = 1;
		}
		else 
		{
			fputc(',',imgpal);
			colcount++;
		}
		fprintf(imgpal,"0%0XH",*datptr++); 
	}
	fputs("\n",imgpal);			/*trail with a CR*/
}


read_pal(palind)
int	palind;
{
unsigned	int	size;
PAL	*apal;

apal = pal[palind];	
lseek(cur_lib,apal->offset,SEEK_SET);
size = apal->num_cols << 1;
read(cur_lib, (char *)PalBuf, size);
apal->colind = 0;

return(apal->num_cols);
}


/*************************************************************************
*																							    *
* classify_newaddr - determine where the new address exists in memory	 *
* 						and deal with the counters.									 *
* 																								 *
* Passed:																					 *
* 																								 *
* Globals:																					 *
* 	newaddr	-	new address to load image data.									 *
* 	imgaddr	-	set to newaddr.														 *
* 	startaddr - first load address of previous load section.					 *
* 	topaddr	-	set to max address for this section								 *
* 	*curr_cnt -	ptr to count variable for this section.						 *
*																							    *
*************************************************************************/
classify_newaddr(unsigned long newaddr)
{

	bits_filled = newaddr & 0xf;

	if (bits_filled && do_align)
		{
		newaddr += 16-bits_filled;
		bits_filled = 0;
		}		

 	if ((newaddr >= PROMST) && (newaddr < PROMEND))
		{
 		topaddr = PROMEND; loadmsk = 1;
 		curr_ct = &prom_ct;
 		currec_ct = &promrec_ct;
 		printf("\nSET new Program ROM address = %lX",newaddr);
	 	}

	else if ((newaddr >= SRAMST) && (newaddr < SRAMEND))
		{
		topaddr = SRAMEND; loadmsk = 1;
		curr_ct = &sram_ct;
		currec_ct = &sramrec_ct;
		printf("\nSET new Scratch RAM address = %lX",newaddr);
		}

	else if ((newaddr >= IROMST) && (newaddr < IROMEND))
		{
		topaddr = IROMEND; loadmsk = 0;
		curr_ct = &irom_ct;
		currec_ct = &iromrec_ct;
		printf("\nSET new IROM address = %lX",newaddr);
		if (dual_bank) printf(" bank %d",bank);
		}

	else if ((newaddr >= IRAMST) && (newaddr < IRAMEND))
		{
		topaddr = IRAMEND; loadmsk = 1;
		curr_ct = &iram_ct;
		currec_ct = &iramrec_ct;
		printf("\nSET new IRAM address = %lX",newaddr);
		if (dual_bank) printf(" bank %d",bank);
		}

	else 
		{
		printf("\nWARNING *** Illegal load address (%lx)!",newaddr); 
		exit(7);
		}
	if (endaddr) printf("   Ends at %lX",endaddr);
	imgaddr = newaddr;
 	startaddr = imgaddr;		 		// address of buffer start
	new_rec_addr = imgaddr;			// address of memory chunk start

}	






/*************************************************************************
*																							    *
* compute_compressed_destbits - 	NOW DONE IN ZCOM_ANALYSIS!!!!!											    	 *
*																							    *
************************************************************************

void compute_compressed_destbits (UI wid, UI ht, int dfield, int pad)
{
register int y;
unsigned char *ldtr;
UI lead,trail;
int lmult,tmult,bpp;

bpp = (dfield & 0x7000) >> 12;
if (!bpp) bpp=8;
lmult = (dfield & 0x300) >> 8;
tmult = (dfield & 0xC00) >> 10;

ldtr = (unsigned char *)&zero_array[0].lead;  	// start of lead/trail array

destbits = 0;
for (y = ht; --y >= 0; )
	{
	lead = *ldtr;
	ldtr += 4; 
	trail = ((lead >> 4) & 0xf) << tmult;
	lead = (lead & 0xf) << lmult;
	destbits += 8 + (wid - lead - trail) * bpp;
	}
}
*/


/*************************************************************************
*																							    *
* load_bits - stuff output buffer with specified number of bits			 *
*					(up to 16)                                                *
*																							    *
*	Globals	- dataword (current word being built out of bits)		 		 *
*             bits_filled (how many bits does the current dataword 		 *
*									represent)											    *
*************************************************************************/
load_bits(int data,int nbits)
{
dataword |= data << bits_filled;		// shift new data up
if ((bits_filled += nbits) >= 16)  	// is word full or overfull?
	{
	*cbuff_ptr++ = dataword;			// if yes, write the full word.
	dataword = (bits_filled -= 16) ? data >> (nbits - bits_filled) : 0;
	}
}
	




/*************************************************************************
*																							    *
* load_block - load a data block to a buffer which will be downloaded	 *
*              to the GSP or written to a raw file.							 *
*																							    *
*************************************************************************/
void load_block (UI wid, UI ht, int dfield, int pad)
{
register int x,y;
unsigned char *ldtr;
UI lead,trail;
unsigned char far *ip;
int zcom,lmult,tmult,bpp;


zcom = dfield & 0x80;
lmult = (dfield & 0x300) >> 8;
tmult = (dfield & 0xC00) >> 10;
bpp = (dfield & 0x7000) >> 12;
if (!bpp) bpp = 8;

if ((do_zcom && !zcom) || (!do_zcom && zcom))
	printf("WARNING! the do_zcom flag and dma field do not agree!!\n");

ldtr = (unsigned char *)&zero_array[0].lead;  	// start of lead/trail array
ip = (unsigned char far *)imgbuf;
if (zcom) 
	{
	for (y = ht; --y >= 0; )
		{
		load_bits(lead = *ldtr,8);
		ldtr += 4; 
		trail = ((lead >> 4) & 0xf) << tmult;
		lead = (lead & 0xf) << lmult;
		ip += lead;
		for (x = wid - (lead+trail); --x >= 0; )
			{
			load_bits(*ip++,bpp);
			}		
		ip += pad + trail;		// get past padded bytes if there are any;
		}
	}
else
	{
	for (y = ht; --y >= 0; )
		{
		for (x = wid; --x >= 0; )
			{
			load_bits(*ip++,bpp);
			}		
		ip += pad;		// get past padded bytes if there are any;
		}
	}
if (do_align && bits_filled) load_bits(0,16-bits_filled);
}


/*************************************************************************
*																							    *
* add_to_imgaddr - function to add a given number of bits to add   		 *
* 						to imgaddr. This will be translated to bytes and		 *
* 						everyone must use this.											 *
* 																								 *
* Passed:																					 *
* 	bits_cnt	= number of bits to add.												 *
* 																								 *
* Globals:																					 *
* 	imgaddr	= current image load address.											 *
*	loadmsk = flag which says OK to load to GSP and/or raw file.		    *
* 																								 *
* Returns:																					 *
* 	 -1 if current RAM section exceeded, 0 otherwise                      *
*																							    *
*************************************************************************/
add_to_imgaddr(unsigned long bit_cnt)
{
/*	Note to George: Remember to use classify_newaddr() when changing imgaddr */
unsigned long tmpnew,cmpaddr;

tmpnew = imgaddr + bit_cnt;
cmpaddr = (endaddr)? endaddr : topaddr;
if (tmpnew > cmpaddr)
	{
	loadmsk = 0;
	err_cnt++;
	return(-1);
	}
imgaddr = tmpnew;
return(0);
}




/*************************************************************************
*																							    *
* load_raw_file - Load image data from a raw image data file to			 *
* 					the GSP.																	 *
* Passed:																					 *
* 																								 *
* Globals:																					 *
* 	raw_file	- handle to load file.											       *
* 	raw_hdr	- ptr to raw file header storage.							       *
* 	raw_rec	- ptr to raw file record storage.							       * 
* 	cbuff - far ptr to load buffer.										          *
* 	record_num		- record counter for raw file									 *
*																							    *
*************************************************************************/
load_raw_file()
{
int	j;
unsigned int	load_word, temp, len;
unsigned long	i, byte_count, local_cksum;
unsigned int far *wbp;
long	record_bytes;
long  laddr;
int chunk;		//TEMP

read(raw_file, (char *) &raw_hdr, sizeof(struct RAW_FILE_HEADER));

if (raw_hdr.magic_num != RAW_MAGIC)
	{
	printf("\nERROR *** File is not in raw image format.");
	graceful_exit(-6);
	}

temp = 0;

for(j=0;raw_hdr.version[j] != '\0';j++)
					temp += raw_hdr.version[j];

if (temp != raw_hdr.ver_cksum)
	{
	printf("\nERROR *** Raw image file corrupt.");
	graceful_exit(-6);
	}

if ((strcmp(raw_hdr.version,VERSION)) != 0)
		printf("\nWARNING *** Raw file created by different version of %s.",
						prog_name);

while	((read(raw_file, (char *) &raw_rec,
				sizeof(struct RAW_FILE_RECORD))) != 0)
	{
	record_num++;
	if (raw_rec.bank >= 0) SetBank(raw_rec.bank);
	classify_newaddr(raw_rec.start_addr);
	local_cksum = 0L;
	record_bytes = raw_rec.byte_count;
#ifdef W020
	laddr = imgaddr;
#else
	SetGSPAddr(imgaddr);
	laddr = imgaddr;		// TEMP
#endif
	chunk = -1;			  // TEMP
	while	(record_bytes)
		{
		chunk++;			  // TEMP
		byte_count = (record_bytes < MAX_CBUFF_SIZEL) ? record_bytes : MAX_CBUFF_SIZEL;
		read(raw_file, cbuff, (UI)byte_count);		//FarRead
		record_bytes -= byte_count;

		wbp = (unsigned int far *)cbuff;
		for (i=byte_count>>1; i-- != 0; )
							local_cksum += (long) *wbp++;	
//		printf("\nChunk %d Reading %7lu bytes at %8lx",chunk,byte_count,laddr);
		len = byte_count>>1;
#ifdef W020
		GSPBlkWr(cbuff,len,laddr);
		laddr += (long)byte_count << 3;
#else
		WrGSPBuffer(cbuff,len);
		laddr += (long)byte_count << 3;		// TEMP
#endif
		*curr_ct += byte_count;
		}

	if (raw_rec.checksum != local_cksum)
			printf("\nWARNING *** checksum mismatch for record %d",
					record_num);
	}
close(raw_file);
}	



/*************************************************************************
*																							    *
* flush_buffer - empties output buffer												 *
* 						dataword is partial word at end								 *
*						bits_filled is number of valid bits in word at end     *
*																								 *
* Passed:																					 *
* 	nxtsiz - if 0, complete flush of this memory area		 					 *
*           if non-0, checkl if temporary flush is necessary             *
*                     leave partially stuffed word                       *
* Globals:																					 *
*		bits_filled	  number of bits of dataword which are stuffed			 *
*		dataword		  partial word being stuffed            					 *
*																							    *
*************************************************************************/
void flush_buffer(long nxtsiz)
{
UI byte_count;
UI w,word_count;
long temp_raw_pos;
unsigned int far *cp;

byte_count = (char far *)cbuff_ptr - (char far *)cbuff;

if (!nxtsiz) 	// if nxtsiz == 0, then flush completely
	{
	if (bits_filled)   // if bits_filled == 0, there's nothing to add.
		{
		*cbuff_ptr++ = dataword;
		byte_count += 2;
		dataword = bits_filled = 0;
		}
	}
else if (((long)byte_count+(nxtsiz>>3)) < MAX_CBUFF_SIZEL) return;

word_count = byte_count >> 1;

if (do_load)
	{
	*curr_ct += byte_count;
#ifdef W020
	GSPBlkWr(cbuff,word_count,startaddr);
#else
	SetGSPAddr(startaddr);
	WrGSPBuffer(cbuff,word_count);
#endif
	startaddr += ((long)byte_count << 3);
	}
if (do_file)
	{
	/*	 Write a record header if this is a new raw record */
	if ((raw_rec.byte_count == 0) && (byte_count > 0))
		{
		raw_rec.interleave = 4;		// SREC compatibility
		raw_rec.skipbytes = 0;		// SREC compatibility
		write(raw_file, (char *) &raw_rec, sizeof(struct RAW_FILE_RECORD));
		}
	raw_rec.byte_count += (long)byte_count;
	cp = cbuff;
	for (w = word_count; w-- != 0; )
		raw_rec.checksum += (unsigned long)(*cp++);
	
	write(raw_file, cbuff, byte_count); 		// FarWrite
	*currec_ct += byte_count;
	if (!nxtsiz)			// finish this record;
		{
		temp_raw_pos = tell(raw_file);
		lseek(raw_file,raw_pos,SEEK_SET);
		raw_rec.start_addr = new_rec_addr;	
		raw_rec.bank = (dual_bank)? bank : -1;	
		raw_rec.interleave = 4;		// SREC compatibility
		raw_rec.skipbytes = 0;		// SREC compatibility
 		write(raw_file, (char *) &raw_rec, sizeof(struct RAW_FILE_RECORD));
 		lseek(raw_file,temp_raw_pos,SEEK_SET);
 		raw_pos = temp_raw_pos;
 		record_num++;
 		raw_rec.byte_count = 0L;	
 		raw_rec.checksum = 0L;	
		}

	if (dbg_verbose) printf("raw file header written (%d)\n",raw_file);
	}

cbuff_ptr = cbuff;
}



half_shrink_avg(int x,int y,char *bufr,int *palbuf,int num_cols)
{
char *outbuf;
register int xx,ptrinc;
int	pad,origx;
char *line1,*lsav;

origx = x;
outbuf = bufr;
line1 = lsav = bufr;
ptrinc = x << 1;
x >>= 1;
pad = round_x(x) - x;
if (y & 1) y &= ~1;		 // Make it mult of 2
while ((y-=2) >= 0)
	{
	for (xx = x; --xx >= 0;)
		{ 
		*outbuf++ = color_average(origx,line1,palbuf,num_cols);	
		line1+=2; 
		}
	for (xx = pad; --xx >= 0; )  *outbuf++ = 0;
	line1 = lsav + ptrinc;
	lsav = line1;
	}
}



half_shrink_smple(int x,int y,char *bufr)
{						// x is rounded to a multiple of 4
char *outbuf;
register int xx,ptrinc;
int	pad;
char *line1,*lsav;

outbuf = bufr;
line1 = lsav = bufr;
ptrinc = x << 1;
x >>= 1;
pad = round_x(x) - x;
if (y & 1) y++;		 // Make it mult of 2
while ((y-=2) >= 0)
	{
	for (xx = x; --xx >= 0;)
		{ 
		*outbuf++ = *line1;	
		line1+=2; 
		}
	for (xx = pad; --xx >= 0; )  *outbuf++ = 0;
	line1 = lsav + ptrinc;
	lsav = line1;
	}
}


