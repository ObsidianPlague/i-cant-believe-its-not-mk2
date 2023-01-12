#include  <stdio.h>
#include  <io.h>
#include  <stdlib.h>
#include  <malloc.h>
#include  <string.h>
#include <dos.h>
#include <fcntl.h>
#include	"wmpstruc.h"
#include "unistruc.h"
#define S_IREAD 	0000400 	/* read permission, owner */
#define S_IWRITE	0000200 	/* write permission, owner */

/*   MODIFIED for DMA2 
*/
#include "load2.h"

extern char	prog_name[];

#define MAX_OBJS	2000		// max objects per universe

struct SHOBJ {
	char iname[16];	// img or sequence depending on ANIM bit
	int	objinfo;		// vers .96 and above
	int	flags;		// vers .96 and above
	} *obj_hdr[MAX_OBJS];

#define	M_ANIM		0x4000
#define	M_FLIPH		0x10
#define	M_FLIPV		0x20

load_bits(int data,int nbits);
void flush_buffer(long nxtsiz);
int add_to_imgaddr(unsigned long bit_cnt);
void load_block (UI wid, UI ht,int dfield,int pad);
void compute_compressed_destbits (UI wid, UI ht, int dfield, int pad);
int graceful_exit(int n);


int pname_indx [MAXPALS];
char pal_name [TOTPALS][NAME_LENGTH];
int	pname_ct=0;
static	int	wave_ctr = 0;
static	int	headct=10;	/* # of chars to print from the head of a name */

/*	These variables are used for placing the background blocks
	in image memory	*/



char	*nametail(n)			/* return tail of a name */
char	*n;
{	return n+4;}


void	msgx (a, b, c, d, e, f)
char *a;
int b, c, d, e, f;
{
	if (bgnd_err_ctr < 10) {
		bgnd_err_ctr++;
		printf ("\nread_bgnd ERROR: ");
		printf (a, b, c, d, e, f);
		}

	graceful_exit (1);
}


compute_bpp(int max_colr)
{
if (max_colr >= 128) return(8);
if (max_colr >= 64) return(7);
if (max_colr >= 32) return(6);
if (max_colr >= 16) return(5);
if (max_colr >= 8) return(4);
if (max_colr >= 4) return(3);
if (max_colr >= 2) return(2);
return(1);
}


/*   FRAME FILES are binary files (with extension .bin)
          which contain the following...
              # frames to follow
              # colors
              X size
              Y size
              Color Data (Variable # of words given by # colors above
              Compressed Frames of color mapped data (Variable length)
*/

void read_frames(char *fname)
{
unsigned char far *dp;
register UI	ct;
char  *lbl;
int frm_file;

strcat(fname,".bin");	

frm_file = open (fname, O_RDONLY|O_BINARY);
if (frm_file <= 0)	{
	printf("\nCan't open %s for reading.", fname);
  	return;
	}
if (lbl=strchr(fname,'.')) *lbl = '\0';
lbl = strrchr(fname,'\\');
if (!lbl) lbl = fname;
else lbl++;

/* MAKE SURE IMGADDR IS ON A WORD BOUNDARY */

if (bits_filled)		// align buffer to next word
	{
	*cbuff_ptr++ = dataword;
	dataword = bits_filled = 0;
	}
imgaddr = ((imgaddr + 15) >> 4) << 4;

if (do_table) fprintf(asm_fptr,"\n%s	.set	0%lxh",lbl,imgaddr);

flush_buffer(64000L<<3);
while ((ct=read (frm_file, cbuff_ptr, (size_t)64000)) != 0)   // FarRead
	{
	if (ct & 1) ct++;    // always an even number of bytes for GSP load
	if (add_to_imgaddr((long)ct<<3) < 0)
		{
		printf("\nFRM %s exceeds current RAM section!",lbl);
		break;
		}
	if (loadmsk && (do_load || do_file))
		{
		(char far *)cbuff_ptr += ct;
		flush_buffer(64000L<<3);
	  	}
	howmanytotal += ((long)ct << 3);
	}
close (frm_file);
}


int find_img_indx(IMAGE *animg)
{
register int i;

for (i=lib_hdr.num_images; --i >= 0; )
	{
	if (img[i] == animg) return(i);
	}
return(-1);
}

int find_seq_indx(FSEQSCR *ss)
{
register int i;

for (i=lib_hdr.num_seq; --i >= 0; )
	{
	if (sequence[i] == ss) return(i);
	}
return(-1);
}



void process_sequence(FSEQSCR *aseq,int qrtrflg,int pos)
{
register int n;
IMAGE *animg;
FILE	*savit;
int savno,lastfrmoff,ii,mark;

part_of_seq = (char)pos;
lastfrmoff = 0;
if (!(aseq->flags & LOADED))
	{
	if (do_wruniseq)	fprintf(univseq,"\n%s:\n",aseq->name);
	if (do_table) fprintf(univglo,"   .global   %s   ; seq\n",aseq->name);
	}
for (n=0; n < aseq->num; n++)
	{
	animg= (IMAGE *)aseq->entry[n]->itemptr;
	if (animg)
		{
		if (!(aseq->flags & LOADED) && do_wruniseq)
			{
			if (lastfrmoff)
			     fprintf(univseq,"   LWL  %s,%d|AFUNC,OBJ_ON\n",animg->name,aseq->entry[n]->ticks);
			else fprintf(univseq,"   LW   %s,%d\n",animg->name,aseq->entry[n]->ticks);
			lastfrmoff = 0;
			}
		ii = find_img_indx(animg);
		if (animg->flags & LOADED)
			{
			mark = (unsigned char)get_temp_mark(temp_img_data,ii);
			if (mark >= 4)   // ok to write global if not done already
				{
				if (!(mark & 2))
					{
					if ((mark & 0xc) == 8)
						{
						if (do_table) fprintf(univglo,"   .global   %s   ; part of seq, loaded in other uni as img\n",animg->name);
						set_temp_mark(temp_img_data,ii,(UCHAR)(mark|2));
						}
					}
				else if (!(mark & 1))
					{
					if ((mark & 0xc) == 0xc)
						{
						if (do_table) fprintf(gbl_fptr,"   .global   %s   ; part of seq, loaded local prev\n",animg->name);
						set_temp_mark(temp_img_data,ii,(UCHAR)(mark|1));
						}
					}
				}
			else if (mark == 2)
				{
				if (do_table) fprintf(univglo,"   .global   %s   ; part of seq, loaded in uni prev as img\n",animg->name);
				set_temp_mark(temp_img_data,ii,(UCHAR)(0xa));
				}
			continue;
			}

	  	if (do_qrtr = qrtrflg)	// if not NOSCALE
			{
	  		do_qrtr = ((animg->flags&M_COPIES)>>B_COPIES)-1;
			if (do_qrtr < 0) do_qrtr = 3;
			}
		process_img(animg,ii);
////	if ((qrtrflg < 3) && (do_table)) add_dummy_entry();
		}
	else if (!(aseq->flags & LOADED) && do_wruniseq)
		{
		fprintf(univseq,"   LWL  1,%d|AFUNC,OBJ_OFF\n",aseq->entry[n]->ticks);
		lastfrmoff = 1;
		}
	}
if (!(aseq->flags & LOADED) && do_wruniseq)
		fprintf(univseq,"   .long  0\n");
aseq->flags |= LOADED;
part_of_seq = 0;
}



#define	MAX_HITS	15		// highest number to be placed in a damage table
								// regardless of entry in sequence or script


int get_hit_count(int tix)	// return a hit count for a damage table
{								   // based on the number of ticks in the seq/scr.
if (tix != 128)
	{
	if (tix > MAX_HITS) return(MAX_HITS);
	}
return(tix);
}


int process_damage(int damind,int qrtrflg,struct SHOBJ *anobj)
{
FSEQSCR *dam;
FSEQSCR *aseq;
IMAGE *animg;
int ss,mark;
register int i,ticks;
int savwruniseq;
int found;
char *undam;
int	enm_seq_cnt;	// sequence count for enemy generators

dam = damage[damind];

//  Check to see if table for this first frame exists

found = 0;
for (i=dam_num; i >= 0; i--)
	{
	if (dam_tbl[i]->damind == damind)
		{
		if (!strcmp(dam_tbl[i]->undam_name,anobj->iname))
			{
			return(i);
			}
		else found = 1;
		}
	}

if ((anobj->flags & (M_PORTAL | M_ENEMY)) == (M_PORTAL | M_ENEMY))
	{
	printf("\n%s marked as ENEMY GENERATOR AND PORTAL!!!\n\tNo Can Do! (It's complicated to explain)",
				anobj->iname);
	}

if (++dam_num == MAX_DAM) 
	{
	printf("WARNING! Limit of damage tables per .img file exceeded!");
	printf("         Increase MAX_DAM in load2.h");
	}
if (dam_num >= MAX_DAM) return(-1);

dam_tbl[dam_num] = (struct DAMTBL *)malloc(sizeof(struct DAMTBL));
dam_tbl[dam_num]->damind = damind;
dam_tbl[dam_num]->num = ++gbl_dam_num;
undam = dam_tbl[dam_num]->undam_name = malloc(INAMELEN+1);
strcpy(undam,anobj->iname);

savwruniseq = do_wruniseq;
do_wruniseq = 0;
enm_seq_cnt = anobj->objinfo&M_UANIM;  // 0 or 1
if (do_table)
	{
	fprintf(univtbl,"\ndam_tbl_%d:\n",dam_tbl[dam_num]->num);
	fprintf(univtbl,"\t.long  %s+%d\n",anobj->iname,
							anobj->objinfo&M_UANIM);
	}

if (dam->flags & SEQFLG) 
	{
	process_sequence(dam,qrtrflg,0);
	if (do_table)
		{
		for (i = 1; i < dam->num; i++)
			{
			animg = (IMAGE *)dam->entry[i-1]->itemptr;
			if (animg)
				{
				fprintf(univtbl,"\t.word  %d\n\t.long  %s\n",
						get_hit_count(dam->entry[i-1]->ticks),animg->name);
				}
			}
		animg = (IMAGE *)dam->entry[i-1]->itemptr;
		if (animg)
			{
			fprintf(univtbl,"\t.word  %d\n\t.long   %s+8\n",
						get_hit_count(dam->entry[i-1]->ticks),animg->name);
			}
		else		printf("ERROR: Damage table %d ends in a dummy frame!",
									dam_tbl[dam_num]->num);
		}
	}
else {					  // damage table is a script
	enm_seq_cnt += dam->num; 		// start as total num entries in dam table
	for (i=0; i < dam->num; i++ )
		{
		aseq = (FSEQSCR *)dam->entry[i]->itemptr;
		do_wruniseq = (aseq->num > 1) ? savwruniseq: 0;
  		ss = find_seq_indx(aseq);
     	mark = get_temp_mark(temp_seq_data,ss);
  		if (!mark)
  			{
  			process_sequence(aseq,qrtrflg,0);
  			set_temp_mark(temp_seq_data,ss,1);
  			}
		ticks = dam->entry[i]->ticks;
		if (aseq->num == 1)
			{
			enm_seq_cnt--;		// dec for each non-sequence in damage tbl
			animg = (IMAGE *)aseq->entry[0]->itemptr;
			if (do_table) fprintf(univtbl,"\t.word  %d\n\t.long   %s%s\n",
					get_hit_count(ticks),
					animg->name,(i == dam->num - 1) ? "+8":"");
			}
		else {
			if (do_table) fprintf(univtbl,"\t.word  %d\n\t.long   %s%s\n",
				get_hit_count(ticks),
				aseq->name,(i == dam->num - 1) ? "+9":"+1");
			}
		}
	}
if (anobj->objinfo & M_DAMG_ENEMY)
	{
	if (enm_seq_cnt == 0)    // all frames are static
		{
		if (do_table)
			{	  	// add a longword containing IMAGE INDEPENDENT enemy animation
			fprintf(univtbl,"\t.long   E_%s\n",anobj->iname);
			fprintf(univglo,"   .global   E_%s   ; img independent enemy animation\n",anobj->iname);
			}
		}
	else if (enm_seq_cnt != dam->num+1)
		printf("\nDamage table for img ENEMY %s contains img AND seqs!\n\tMust be all images if the first one is!",
			anobj->iname);
	}
do_wruniseq = savwruniseq;
return(dam_num);
}




void adjust_flags(struct OBJHDR *obj)	 
{
register int nufield;

nufield = 0;
if (obj->flags & OLD_M_WALL) nufield |= M_WALL;
if (obj->flags & OLD_M_FG) nufield |= M_FG;
if (obj->flags & OLD_M_ANIM) nufield |= M_UANIM;
if (obj->flags & OLD_M_DANIM) nufield |= M_DANIM;
obj->objinfo = nufield;
obj->flags &= ~(OLD_M_WALL | OLD_M_FG | OLD_M_ANIM | OLD_M_DANIM);
}




//	UNISTRUC.h  changes as of version 0.80 of bgtool supported

void read_univ (char *fname,char *unidir)		
{
register int ii,i;
int unifile;   // file handle for universe
int bytes2read,add;
char *lbl;
char *filepart;
char actual_name[64];
char oiname[INAMELEN+1];
long unix,uniy;
long	uniz;
struct OBJHDR *anobj;
struct SHOBJ  *shobj;
int damind,qrtrflg,dd,extra;
long	obj_st_pos;
int mark,savzcom;
char  lib_names[MAX_LIB][64];
int open_lib;		// which lib is open
UCHAR newmark;

strcat(fname,".uni");	

unifile = open (fname, O_RDONLY|O_BINARY);
if (unifile <= 0)	{
	printf("\nCan't open %s for reading.", fname);
  	return;
	}

//  Chop name down to filename part only

if (lbl=strchr(fname,'.')) *lbl = '\0';
lbl = strrchr(fname,'\\');
if (!lbl) lbl = fname;
else lbl++;


//	READ UNIVERSE HEADER

read (unifile, (char *)&uni_hdr, sizeof(struct UNIHDR));

if (uni_hdr.version < 0x100)
	{
	printf("\nUniverse %s must have a version >= 1.00",fname);
	close(unifile);
	return;
	}


// READ THE LIST OF IMAGE FILES

read (unifile, &lib_names[0], 64*uni_hdr.nlibs);

// READ INFO FOR EACH OBJECT

bytes2read = sizeof(struct OBJHDR);
if (uni_hdr.objcnt > MAX_OBJS) 
	{
	close(unifile);
	printf("\nUniverse %s contains %d objects! (Max is %d)",fname,
			uni_hdr.objcnt,MAX_OBJS);
	return;
	}
obj_st_pos = tell(unifile);
anobj = (struct OBJHDR *)_fmalloc(sizeof(struct OBJHDR));
if (anobj == NULL)
	{
	printf("/nCouldn't allocate memory for object header");
	return;
	}
savzcom = do_zcom;
do_zcom = 0;
extra = 0;
for (i = 0; i < uni_hdr.objcnt; i++)
	{
	read (unifile, (char *)anobj, bytes2read);
	if (anobj->objinfo & M_FG) { obj_hdr[i] = NULL; extra++; continue; }

	obj_hdr[i]= (struct SHOBJ *)_fmalloc(sizeof(struct SHOBJ));
	if (obj_hdr[i] == NULL)
		{
		printf("/nCouldn't allocate memory for object header #%d",i);
		do_zcom = savzcom;
		return;
		}

	obj_hdr[i]->flags = anobj->flags;
	if (uni_hdr.version < 0x10d)
		{					// NOPIXSCAN used to mean ONESHOT, need to switch em
		if (obj_hdr[i]->flags & M_NOPIXSCAN)
			{
			obj_hdr[i]->flags &= ~M_NOPIXSCAN;
			obj_hdr[i]->flags |= M_ONESHOT;
			}
		}
	obj_hdr[i]->objinfo = anobj->objinfo;

// IF THIS OBJECT IS A STATIC IMAGE WHICH IS AN ENEMY
//		GENERATOR AND DAMAGEABLE...

	if ( (anobj->flags & M_ENEMY)
		&& (anobj->objinfo & M_DAMAGE) && !(anobj->objinfo & M_UANIM) )

		{			// ... THEN MARK FIRST OCCURENCE IN THIS UNIVERSE
		for (ii = 0; ii < i; ii++)
			{
			if (!strcmp(obj_hdr[ii]->iname,anobj->iname)) break;
			}
		obj_hdr[ii]->objinfo |= M_DAMG_ENEMY;
		}

	strcpy(obj_hdr[i]->iname,anobj->iname);
	}


// OPEN EACH LIBRARY AND PROCESS ALL OBJECTS

open_lib = -1;
while (++open_lib < uni_hdr.nlibs)
	{
	// CLOSE CURRENT LIB
	close_current_wimplib();

	// OPEN NEXT LIB			(take from filespec in .uni file if
	//                       UNIDIR == 0, from override dir specified
	//								 on UNI> line if there was one or override
	//								 dir specified on command line if there was 
	//								 one.
	if (unidir == NULL)
		{
		strcpy(actual_name,lib_names[open_lib]);
		}
	else {
		filepart = strrchr(lib_names[open_lib],'\\');
		if (filepart == NULL)
			{
			filepart = strchr(lib_names[open_lib],':');
			if (filepart == NULL) filepart = lib_names[open_lib];
			else filepart++;
			}
		else filepart++;
		strcpy(actual_name,unidir);
		strcat(actual_name,filepart);
		}
	if ((cur_lib = open(actual_name,O_RDONLY | O_BINARY)) <= 0)
		{
		printf("\nImage Library [%s] could not be opened.",actual_name);
		continue;
		}
	strcpy(libname,actual_name);
	frm_univ = 1;
	read_imglib();
	load_temp_table(libname);
	dam_num = -1;
	lseek(unifile,obj_st_pos,SEEK_SET);		// get to start of objects
	for (i = 0; i < uni_hdr.objcnt; i++)
		{
		read (unifile, (char *)anobj, bytes2read);
		if ((shobj=obj_hdr[i]) == NULL) continue;	// skip foreground objs
		if (anobj->lib_indx == open_lib)
			{
			ii = anobj->indx;

			qrtrflg = !(shobj->flags & M_NOSCALE);

			if ((shobj->flags & (M_PORTAL|M_ENEMY)) == (M_PORTAL|M_ENEMY))
				{
				printf("\n%s in %s marked as Portal AND Enemy!",anobj->iname,lbl);
				}

			if (shobj->objinfo & M_UANIM)
				{
  		   	mark = get_temp_mark(temp_seq_data,ii);
  				if (!mark)
  					{
  					process_sequence(sequence[ii],qrtrflg,1);
  					set_temp_mark(temp_seq_data,ii,1);
  					}
				}
			else {
				if (strcmp(img[ii]->name,shobj->iname))
					{
					printf("\nImage name discrepancy in universe [%s]!\n      Img %d of lib [%s]\n      should be [%s], but it's [%s]!",
							fname,anobj->indx,actual_name,
							shobj->iname,img[anobj->indx]->name);
					continue;
					}

				if (!(img[ii]->flags & LOADED))
					{
					if (do_qrtr = qrtrflg)	// if not NOSCALE
						{
						do_qrtr = ((img[ii]->flags&M_COPIES)>>B_COPIES)-1;
						if (do_qrtr < 0) do_qrtr = 3;
						}
					process_img(img[ii],ii);
					}
				if (shobj->flags & M_ENEMY)  // has it been made global yet?
					{
					mark = (unsigned char)get_temp_mark(temp_img_data,ii);
					newmark = 0;
					if (mark == 2)	newmark = 0xa;
					if ((mark >= 4) && !(mark & 3)) newmark = mark|2;
					if (!(shobj->objinfo & M_DAMAGE))  // rename if NOT DAMAGEABLE !!!NEW!!!
						{
						strcpy(oiname,shobj->iname);
						strcpy(shobj->iname,"E_");
						strcat(shobj->iname,oiname);
						shobj->objinfo |= M_UANIM|M_DANIM;
						}
					if (newmark)
						{
						// if NOT DAMAGEABLE, create a mock sequence for it !!!NEW!!!

						if (do_wruniseq && !(shobj->objinfo & M_DAMAGE))
							{
							fprintf(univseq,"\nE_%s:\n",img[ii]->name);
							fprintf(univseq,"   LW   %s,1\n",img[ii]->name);
							fprintf(univseq,"   .long  0\n");
							}
						if (do_table)
							{
							fprintf(univglo,"   .global   E_%s   ; enemy generator seq\n",
												img[ii]->name);
							fprintf(univglo,"   .global   %s   ; enemy generator img\n",
											img[ii]->name);
							}
						set_temp_mark(temp_img_data,ii,newmark);
						}
					}
				}
			if (shobj->objinfo & M_DAMAGE)
				{
				damind = (shobj->objinfo & M_UANIM) ? sequence[anobj->indx]->dam[0] :
													img[anobj->indx]->dam[0];
//!!!NEW!!! if (shobj->flags & M_ENEMY)  shobj->objinfo |= M_UANIM|M_DANIM;
				if (damind >= 0)
				 	{
					dd = process_damage(damind,qrtrflg,shobj);
					if (dd < 0) shobj->objinfo &= ~M_DAMAGE; 	// clear flag if problem
					else sprintf(shobj->iname,"dam_tbl_%d",dam_tbl[dd]->num);
					continue;
					} 					// Falls through if damage index is negative.
				else {
					shobj->objinfo &= ~M_DAMAGE; 	// clear flag if discrepancy
					if (do_verbose > 1)
						printf("Object %s marked as DAMAGE, damind neg\n",shobj->iname);
					}
				}
//!!!NEW!!! if (shobj->flags & M_ENEMY)  shobj->objinfo |= M_UANIM|M_DANIM;
			}
		}
	while (dam_num >= 0)
		{
		free(dam_tbl[dam_num]->undam_name);	// Free all damage structs
		free(dam_tbl[dam_num--]);					// for this img lib.
		}
	}
close_current_wimplib();

// WRITE UNIVERSE TABLE

if (do_table)
	{
	fprintf(univglo,"   .global   %s   ; univ\n",lbl);
	fprintf(univtbl,"\n\n;  The first 4 words are: num_objs, halfy, gnd colr, sky colr\n");
	fprintf(univtbl,"\n%s:\n   .word   %d,%d,0%xh,0%xh",lbl,uni_hdr.objcnt-extra,
				uni_hdr.halfy,	uni_hdr.gnd_colr,uni_hdr.sky_colr);
	fprintf(univtbl,"\n   .long   0%08lxh, 0%08lxh   ; ZMIN (zfar), WORLD Y",uni_hdr.zfar,
				uni_hdr.world_y);

	lseek(unifile,obj_st_pos,SEEK_SET);		// get to start of objects
	extra = 0;
	for (i = 0; i < uni_hdr.objcnt; i++)
		{
		read (unifile, (char *)anobj, bytes2read);
		if ((shobj = obj_hdr[i]) == NULL) { extra++; continue; }
		unix = anobj->worldx;		// X and Y are universe positions
		uniy = anobj->worldy;
		uniz = anobj->worldz;		// So is Z
		fprintf(univtbl,"\n\t\t\t\t;\tBlock Number %d\n   ",i-extra);
	   add = (shobj->objinfo & M_DAMAGE) ? 4 : 0;
		if (shobj->objinfo & M_UANIM)	add |= 1;
		if (shobj->objinfo & M_DANIM) add |= 2; 
		fprintf(univtbl,".long  %s+%1d",shobj->iname,add);
		fprintf(univtbl,"\n   .long   0%08lxh           ; X",unix);
		fprintf(univtbl,"\n   .long   0%08lxh           ; Y",uniy);
		fprintf(univtbl,"\n   .long   0%08lxh           ; Z",uniz);
		fprintf(univtbl,"\n   .word   0%xh",shobj->flags);
		}
	}
close(unifile);
for (i = 0; i < uni_hdr.objcnt; i++ )
	{
	if (obj_hdr[i] != NULL)	_ffree(obj_hdr[i]);
	}
_ffree(anobj);
do_zcom = savzcom;
}




void read_bgnd (char *fname)
{
UI	w, h, x, y, z, hdr, xlength, ylength, zlength;
UI numMods, numBlocks, numPals;
ULI	bytes;
FILE	*blk_file, *data_file;
char	*extptr,name [NAME_LENGTH], pname[NAME_LENGTH];
UI	b, m, i, j, bct, ct,ctr, num_hdr_ptrs, palsize, pal_num, big_pal;
int	far *p;
char	*c1, *c2, buf80[80];
UI	block_ct, lct, y1adj, x1adj, y2adj, x2adj, x2, y2, tmp;
ULI	checksum, loadadd, tempadd, checktemp;

int bpp, savzcom, loop_var, mxcol;
ULI endaddr;

savzcom = do_zcom;

bgnd_err_ctr = 0;

if (do_table)
	{
	if (do_append) wave_ctr = 1;
	if (!wave_ctr)
		{
		wave_ctr = 1;
		fprintf (bgndtbl, "	.include	\"%s\"\n\t.DATA\n", gbl_fname);
		fprintf (bgndpal, "	.include	\"%s\"\n\t.DATA\n", gbl_fname);
		}
	}

/* Open back ground block file for reading */

extptr = &fname[strlen(fname)];
strcat (fname, ".bdb");
blk_file = fopen (fname, "r");
if (!blk_file)	msgx ("Can't open %s for reading.\n", fname);

/* Open back ground data file for reading */

strcpy (extptr, ".bdd");
data_file = fopen (fname, "rb");
if (!data_file)	msgx ("Can't open %s for reading.\n", fname);

/* Read Map Descriptor */

ct = fscanf (blk_file, "%s %u %u %u %u %u %u\n",
		name, &xlength, &ylength, &zlength, &numMods, &numPals, &numBlocks);
if (ct < 7) msgx ("Reading Map Descriptor\n");
if (numPals > MAXPALS)
		msgx ("%d palettes exceeds max of %d.\n", numPals, MAXPALS);
if (numMods > MAXMODS)
		msgx ("%d modules exceeds max of %d.\n", numMods, MAXMODS);
if (numBlocks > MAXBLOCKS)
		msgx ("%d blocks exceeds max of %d.\n", numBlocks, MAXBLOCKS);

/* Get Data Blocks - load data, make tbl of hdrs */

if (!fgets (buf80, 80, data_file)) msgx("Reading # of data blocks.\n");
if (!sscanf (buf80, "%u\n", &num_hdr_ptrs))
		msgx ("Can't read num_hdr_ptrs.\n");
if (num_hdr_ptrs > MAXHDRS)
		msgx ("%d headers exceeds max of %d.\n", num_hdr_ptrs, MAXHDRS);


if (do_table)
	{
	fprintf (bgndtbl, "\n");
	if (do_rawbgnd) fprintf (bgndtbl, ";");
	fprintf (bgndtbl, "%sHDRS:\n", nametail(name));
	/*fprintf (gbl_fptr, "	.globl	%sHDRS\n", nametail(name)); */
	}

		/*** start here ***/
for (i=0; i<num_hdr_ptrs; i++) 
	{
	if (!fgets (buf80, 80, data_file)) msgx("Reading data block.\n");
	if (sscanf (buf80, "%x %u %u %u\n",
				&(hdrs[i].oldh), &w, &h, &big_pal) != 4)
	msgx ("reading hdr, w, h, big_pal\n");
	hdrs[i].w = w;
	hdrs[i].h = h;

	bytes = (ULI)w * (ULI)h;
	if (bytes > MAXDATA)
			msgx ("Data block of %u x %u exceeds buf space of %u\n",
					w, h, MAXDATA);

	checksum = 0L;
	loadadd = imgaddr;

	if (fread (imgbuf, 1, (UI)bytes, data_file) < (UI)bytes)
			  msgx("can't read data blocks from file\n");
	checksum = getcksum ((int far *) imgbuf,  bytes>>1, &mxcol);

	bpp = packbits;
	if ( bpp && (mxcol >= (1 << packbits)) )
		{
		printf ("\nBG block has %d colors. Can't fit into %d bits per pixel.",
					 			mxcol+1, packbits);
		bpp = compute_bpp(mxcol);		// override packbits
		}
	else if (bpp == 0)
		{
		bpp = compute_bpp(mxcol);		// auto pack
		if (do_verbose > 3)
			printf("\nAuto pixel packing to %d bits on BG block.",bpp);
		}

   if (do_zcom && (w <= ZCOMPIXELS))
		{
		do_zcom = 0;
   	if (do_verbose > 3)
         	printf("\nBogus X-size for compressing BG block.");
		zcom_min_fail++;
	   }

	destbits = bytes * (long)bpp;
	dma2_field = (bpp&7) << 12;	// BPP,TM,LM,CMP fields all set.

	if (do_zcom)
		{
		if (do_zcom = zcom_analysis(imgbuf,h,w,bpp))
			{		// if above returns 0, everything set, otherwise...
			dma2_field = do_zcom;	// BPP,TM,LM,CMP fields all set.
			do_zcom = 1;
			}
		}
	if (do_align) destbits = (destbits + 15) & ~0xfL;

	if (do_cksum) 
		{
		if ((tempadd = srch_bd (w, h, checksum, dma2_field)) != -1)
      	{
			bgnd_cksum_match++;
			bgnd_cksum_bits += destbits;
			bytes = 0;
			loadadd = tempadd;
		  	}
		}


/*  ADJUST IMGADDR AND CHECK FOR ADDRESS OVERFLOW */

	if (bytes)		// skip following if checksum matched.
		{
		if (add_to_imgaddr(destbits) < 0)
			{
			printf("\nBG block exceeds current RAM section!");
			}
		else {
			ins_blockdata (w, h, checksum, loadadd, dma2_field);
			howmanytotal += destbits;
			}
		}

	if (bytes && (do_load || do_file))
		{
		flush_buffer(destbits); 		// flush buffer only if necessary
		load_block(w,h,dma2_field,0);
		}

	hdrs[i].loadadd = loadadd;

	if (do_table && !do_rawbgnd)
		{
		if (dual_bank) loadadd += (bank)?0x2000000L : -0x2000000L;
		if (i==0)
			{
			fprintf (bgndtbl, "	.word	%d,%d\t;x size, y size\n", w,h);
/* WFD BEGIN */
/*			          fprintf (bgndtbl, "	.long	00H		;anim\n"); */
			fprintf (bgndtbl, "	.long	0%lXH\t;address\n", loadadd);
         fprintf(bgndtbl,"	.word	0%XH\t;dma ctrl\n",dma2_field);
			}
		else {
			fprintf (bgndtbl, "	.word	%d,%d\n", w,h);
			fprintf (bgndtbl, "	.long	0%lXH\n", loadadd);
/*				       fprintf (bgndtbl, "	.long	00H,0%lXH\n", loadadd); */
         fprintf(bgndtbl,"	.word	0%XH\n",dma2_field);
			}
/* WFD END */
		}
	do_zcom = savzcom;
	}	 				// end for

	if (do_rawbgnd)
		{
		if (hdr_tbl_indx >= MAXHDRTBLS)
					msgx("MAX # BGND FILES EXCEEDED (MAXHDRTBLS=%d)",MAXHDRTBLS);
		HEADER_TABLE[hdr_tbl_indx] = imgaddr;
/* WFD BEGIN */
		fprintf (bgndtbl, ";	has %d headers at 0%lXH\n",
												num_hdr_ptrs, imgaddr);
/* WFD END */
		if (bits_filled) load_bits(0,16-bits_filled);
		load_bits (num_hdr_ptrs,16);
		for (i = 0; i < num_hdr_ptrs; i++)
			{
			load_bits (hdrs[i].w,16); /* x size */
			load_bits (hdrs[i].h,16); /* y size */
			loadadd = hdrs[i].loadadd;
			load_bits ((UI)loadadd,16);	/* lower half */
			load_bits ((UI)(loadadd>>16),16);	/* upper half */
			}
		}


	/* Get Palettes - stuff bgndpal.asm with pal data */
	for (i=0; i<numPals; i++)
		{
		/* read name of palette */
		if (!fgets (buf80, 80, data_file)) 	msgx("Reading pname, palsize.\n");
		ct = sscanf (buf80, "%s %u\n", pname, &palsize);
/*		      printf ("%d, pal %s has %d colors\n", i, pname, palsize); */
		if (ct != 2) msgx ("Reading palette name for palette %d\n", i);

		if (fread (imgbuf, 2, palsize, data_file) < palsize)
				msgx ("Reading palette\n");
		if ((pname_indx[i] = srch_pname(pname)) != -1);

		else if (exist_imgpal(pname))
			{
			pname_indx[i] = ins_pname(pname);		/*let background know of it*/				
			}

		else {
			pname_indx[i] = ins_pname(pname);				
			if (do_table)
				{
				fprintf(bgndpal, "%s:	;PAL #%d\n", pal_name[pname_indx[i]], i);	
				fprintf (bgndpal,	"	.word	%d	;pal size", palsize);
				lct = 1;
				wrdptr = (int far *)imgbuf;
				for (ctr = 0; ctr < palsize; ctr++)
					{
					if (lct==1)	fprintf (bgndpal, "\n	.word 0%XH", *wrdptr++);
					else	fprintf (bgndpal, ",0%XH", *wrdptr++);
					if (lct++ == 10) lct = 1;
					}
				fprintf (bgndpal, "\n");
				}
			}
		}

	if (do_table)
		{
		/* print out table of palettes */
		fprintf (bgndpal, "\n%sPALS:\n", nametail(name));
		fprintf (gbl_fptr, "	.globl	%sPALS\n", nametail(name));
		for (i=0; i<numPals; i++)
			{
			fprintf (bgndpal, "	.long	%s\n", pal_name [pname_indx [i]]);	
			fprintf (gbl_fptr, "	.globl	%s\n", pal_name [pname_indx [i]]);
			}
		}


	/* Read in MODULE definitions */
	if (numMods > MAXMODS)
		msgx ("%d modules exceeds max of %d.\n", numMods, MAXMODS);
	for (i=0; i<numMods; i++)
		{
		ct = fscanf (blk_file, "%s %u %u %u %u\n",
				bgnd_mod[i].name,
				&(bgnd_mod[i].x1), &(bgnd_mod[i].x2),
				&(bgnd_mod[i].y1), &(bgnd_mod[i].y2)
				);
		if (ct < 5)	msgx ("error reading Module\n");
		}

	/* READ and process all BLOCKS */
	for (b = 0; b < numBlocks; b++)
		{
		/* read block descriptor */
		if (fscanf (blk_file, "%x %u %u %x %u\n",
				&(z),	&(x),	&(y),	&(hdr),	&pal_num) < 5)
				msgx ("Reading block descriptor\n");
		z = z & 0xFFF0;
		z |= (pal_num & 0xF);
		bgnd_block[b].z = z;
		bgnd_block[b].x = x;
		bgnd_block[b].y = y;
		bgnd_block[b].hdr = hdr;

		bgnd_block[b].put = 0;

		/* get new hdr from table */
		for (i=0; i<num_hdr_ptrs; i++)	
			{
			if (hdrs[i].oldh == bgnd_block[b].hdr) goto SkipBad;
			}
		msgx ("Can't find block header ptr.\n");
SkipBad:
		bgnd_block[b].hdrsindx = i;
		bgnd_block[b].hdr = i; // WBD CHANGE!!! HDR # IS # of LONGWORDS INTO HDR TBL 
		bgnd_block[b].hdr += (pal_num >> 4) << 12;
		}

	/* correct Module Coors */
	if (do_table)
		{
		for (m = 0; m < numMods; m++)
			{
		/* Scan all blocks -
		 * looking for block with closest X,Y to top left of module
		 *	and block closest X,Y to bottom right of module
		 */
			x1adj = bgnd_mod[m].x2;
			y1adj = bgnd_mod[m].y2;
			x2adj = bgnd_mod[m].x1;
			y2adj = bgnd_mod[m].y1;
			bgnd_mod[m].numBlocks = 0;
			for (i=0; i<numBlocks; i++)
				{
				x2 = bgnd_block[i].x + hdrs[bgnd_block[i].hdrsindx].w - 1;
				y2 = bgnd_block[i].y + hdrs[bgnd_block[i].hdrsindx].h - 1;
				if ((bgnd_block[i].y	>= bgnd_mod[m].y1) &&
					 (bgnd_block[i].x	>= bgnd_mod[m].x1) &&
					 (y2	<= bgnd_mod[m].y2) &&
					 (x2	<= bgnd_mod[m].x2))
					{

					bgnd_mod[m].numBlocks++;

					/* set new top left */
					if (bgnd_block[i].x < x1adj) x1adj = bgnd_block[i].x;
					if (bgnd_block[i].y < y1adj) y1adj = bgnd_block[i].y;

					/* set new bottom right */
					if (x2 > x2adj) x2adj = x2;
					if (y2 > y2adj) y2adj = y2;
					}
				}
			bgnd_mod[m].x1 = x1adj;
			bgnd_mod[m].y1 = y1adj;
			bgnd_mod[m].x2 = x2adj;
			bgnd_mod[m].y2 = y2adj;
			}
		}	/* end if (do_table) */

	if (do_table)
		{
		/*fprintf (bgndtbl, "\n");*/
		for (m = 0; m < numMods; m++)
			{
			/* WRITE out BLOCKS in each MODULE */
			if (do_rawbgnd) fprintf (bgndtbl, ";");
			fprintf (bgndtbl, "%.*sBLKS:", headct, bgnd_mod[m].name);
			if (do_rawbgnd)
/* WFD BEGIN */
				fprintf (bgndtbl, "\tAt 0%lXH ", imgaddr);
/* WFD END */
			else
				fprintf (bgndtbl, "\n");

			lct = 0;
/*			printf ("m_x1=%d, m_x2=%d, m_y1=%d, m_y2\n",
				bgnd_mod[m].x1, bgnd_mod[m].x2,
				bgnd_mod[m].y1, bgnd_mod[m].y2);
*/
			if (do_rawbgnd)
				{
				if (blk_tbl_indx+m >= MAXBLKTBLS)
					msgx("MAX # MODULES EXCEEDED (MAXBLKTBLS=%d)",MAXBLKTBLS);
				BLOCK_TABLE[blk_tbl_indx+m] = imgaddr;
				}
			/*	fprintf (bgndtbl, "\t.long\t0%lXH\n", imgaddr);*/

				/* APPEND HERE */
		block_ct = 0;
		for (i=0; i<numBlocks; i++)
			{
			x2 = bgnd_block[i].x + hdrs[bgnd_block[i].hdrsindx].w - 1;
			y2 = bgnd_block[i].y + hdrs[bgnd_block[i].hdrsindx].h - 1;
/*			printf ("put=%d x1=%d, x2=%d, y1=%d, y2=%d\n", 
					bgnd_block[i].put,
					bgnd_block[i].x, x2,
					bgnd_block[i].y, y2);						 
*/
			if ( (!bgnd_block[i].put) &&
					 (bgnd_block[i].x >= bgnd_mod[m].x1) &&
					 (bgnd_block[i].y	>= bgnd_mod[m].y1) &&
					 (x2	<= bgnd_mod[m].x2) &&
					 (y2	<= bgnd_mod[m].y2))
				{

				bgnd_block[i].put = 1;
				block_ct++;

				if (do_rawbgnd)
					{
					load_bits (bgnd_block[i].z | 0x40,16);
					load_bits (bgnd_block[i].x - bgnd_mod[m].x1,16);
					load_bits (bgnd_block[i].y - bgnd_mod[m].y1,16);
					load_bits (bgnd_block[i].hdr,16);
					}
				else if (!lct)
					{
					lct = 1;
/* WFD BEGIN */
					fprintf (bgndtbl, "	.word	0%XH	;flags\n",
							bgnd_block[i].z | 0x40); /* stuff Transp bit 0x40 */
					fprintf (bgndtbl, "	.word	%d,%d ;x,y\n",
							bgnd_block[i].x - bgnd_mod[m].x1,
							bgnd_block[i].y - bgnd_mod[m].y1);
					fprintf (bgndtbl, "	.word	0%XH	;pal5,pal4,hdr13-0\n",
								bgnd_block[i].hdr);
					}
				else {
					fprintf (bgndtbl, "	.word	0%XH,%d,%d,0%XH\n",
/* WFD END */
						bgnd_block[i].z | 0x40,
						bgnd_block[i].x - bgnd_mod[m].x1,
						bgnd_block[i].y - bgnd_mod[m].y1,
						bgnd_block[i].hdr);
					}
				}
			}
		if (do_rawbgnd)
			{
			load_bits (0xFFFF,16);
			fprintf (bgndtbl, "%d blocks loaded\n", block_ct);
			}
		else
				fprintf (bgndtbl, "	.word	0FFFFH	;End Marker\n");
		bgnd_mod[m].numBlocks = block_ct;
		}

	/* Write all BLOCKS not in a Module */		
	lct = 0;
	for (i=0; i<numBlocks; i++)
		{
		if (!bgnd_block[i].put)
			{
			if (!lct)
				{
				lct = 1;
/* WFD BEGIN */
				fprintf (bgndtbl,
						"\n;file %s blocks not in any module\n", name);
				fprintf (bgndtbl, ";	.word	0%XH	;flags\n",
						bgnd_block[i].z | 0x40); /* stuff Transp bit 0x40 */
				fprintf (bgndtbl, ";	.word	%d,%d ;x,y\n",
						bgnd_block[i].x,
						bgnd_block[i].y);
				fprintf (bgndtbl, ";	.word	0%XH	;pal5,pal4,hdr13-0\n",
						bgnd_block[i].hdr);
				}
			else {
				fprintf (bgndtbl, ";	.word	0%XH,%d,%d,0%XH\n",
/* WFD END */
					bgnd_block[i].z | 0x40, /* stuff Transp bit 0x40 */
					bgnd_block[i].x,
					bgnd_block[i].y,
					bgnd_block[i].hdr);
				}
			}
		}
	if (lct)	fprintf (bgndtbl, ";	.word	0FFFFH	;End Marker\n");

	if (do_table)	for (m = 0; m < numMods; m++)
		{
		/* WRITE MODULE defs */
		fprintf (bgndtbl, "%.*sBMOD:\n", headct, bgnd_mod[m].name);
		fprintf (gbl_fptr, "	.globl	%.*sBMOD\n", headct, bgnd_mod[m].name);

		fprintf (bgndequ, "W%s .EQU	%d\n", 
				bgnd_mod[m].name, bgnd_mod[m].x2-bgnd_mod[m].x1+1);
		fprintf (bgndequ, "H%s .EQU	%d\n", 
				bgnd_mod[m].name, bgnd_mod[m].y2-bgnd_mod[m].y1+1);

		fprintf (bgndtbl, "	.word	%d,%d,%d	;x size, y size, #blocks\n",
		bgnd_mod[m].x2 - bgnd_mod[m].x1 + 1,
		bgnd_mod[m].y2 - bgnd_mod[m].y1 + 1,
		bgnd_mod[m].numBlocks);
		if (do_rawbgnd)
			{
			fprintf(bgndtbl,"\t.word\t%d,%d\t\t;block,hdr tbl indices\n",
					blk_tbl_indx+m,  hdr_tbl_indx);
			fprintf (bgndtbl, "	.long	%sPALS\n",
					nametail(name));
			}
		else 	fprintf (bgndtbl, "	.long	%.*sBLKS, %sHDRS, %sPALS\n",
						headct, bgnd_mod[m].name, nametail(name), nametail(name));
		}
	}
hdr_tbl_indx++;
blk_tbl_indx+=numMods;
			
//readmap_done:

if (fclose (blk_file) == EOF) msgx ("Closing block file.\n");
if (fclose (data_file) == EOF) msgx ("Closing raw data file.\n");

}



/*************************************************************************
 srch_pname -
	Search for the passed name,
		if found return index of name
		else return -1;
		else insert name and return its index.
*************************************************************************/
int srch_pname (pstring)
char *pstring;
{
int i;

	for (i=0; i<pname_ct; i++){
		if (strcmp(pstring, pal_name[i]) == 0)	return i;
		}
	return -1;
}

/*************************************************************************
 ins_pname -
		insert name and return its index.
*************************************************************************/
int ins_pname (pstring)
char *pstring;
{
	if (pname_ct >= TOTPALS)
		msgx ("%d pals exceeds max of %d (TOTPALS).\n", pname_ct, TOTPALS);
	strcpy(pal_name [pname_ct], pstring);
	pname_ct++;
	return pname_ct-1;
}

/* WFD BEGIN */

/*************************************************************************
 getcksum -
   Takes far ptr to array of ints, and a word count.
   Returns a unsigned long checksum value.
*************************************************************************/
ULI getcksum (UI far *data, ULI ct, UI *max_colr )
{
register UI dword;
ULI	cksum;		 
int   pixel1,pixel2,mxcol = 0;

cksum = 0;
while (--ct)
	{
	dword = *data++;
	cksum += dword;
	pixel1 = dword & 0xff;
	pixel2 = (dword >> 8) & 0xff;
	if (pixel1 > mxcol) mxcol = pixel1;
	if (pixel2 > mxcol) mxcol = pixel2;
	}
if (max_colr != NULL) *max_colr = mxcol;
return cksum;
}



int blk_handle[4];
int num_free_segs;
int cur_blk_seg;
int emm_page_frame;
int new_blk_seg;
UI nextblk;
int	bd_ct;




void set_emm_seg(int emm_seg)
{
if (emm_seg != cur_blk_seg)
	{
	map_pages(0x0000,blk_handle[emm_seg]);
	map_pages(0x0101,blk_handle[emm_seg]);
	map_pages(0x0202,blk_handle[emm_seg]);
	map_pages(0x0303,blk_handle[emm_seg]);
	cur_blk_seg = emm_seg;
	}
}



/*************************************************************************
 init_bd -	initialize checksum blocks in EMM
*************************************************************************/
void init_bd ()
{
register int i;

if ((i=get_free_page_count()) >= 4)
	{	
	nextblk = 0;
	new_blk_seg = 0;
	cur_blk_seg = 0xffff;
	num_free_segs = i >> 2;
	emm_page_frame = get_page_frame_base();
	for (i=0; i < 4; i++) 
			blk_handle[i] = (i >= num_free_segs) ? -1 : allocate_pages(4);
	bd_ct = 0;
	}		
else {
	printf("Get some expanded memory, you low-tech weenie!\n");
	graceful_exit(3);
	}
}



/*************************************************************************
 srch_bd -
	Search blockdata table for the passed w, h, and checksum of a block
		if found return address of block data.
		else return -1;
*************************************************************************/
ULI srch_bd (UI w, UI h, ULI cksum, UI dma2_ctrl)
{
register int i;
BLOCKDATA far *bdp;
UI	thisblk;
ULI retval = -1L;

FP_SEG(bdp) = emm_page_frame;
thisblk = 0;
set_emm_seg(0);			// start at first segment of EMM

for (i=bd_ct; --i >= 0; )
	{
	FP_OFF(bdp) = thisblk;
	if ((thisblk += sizeof(BLOCKDATA)) < sizeof(BLOCKDATA))
		{
		set_emm_seg(cur_blk_seg+1);
		thisblk = sizeof(BLOCKDATA);
		FP_OFF(bdp) = 0;
		}
	if (bdp->w == w)
		{
		if (bdp->h == h)
			{
			if (bdp->dma2_ctrl == dma2_ctrl)
				{
				if (bdp->cksum == cksum)
					{
					if (do_verbose > 3)
						printf("\nblock cksum match w:%d, h:%d, dma2:%04x add:%lX",
							w, h, dma2_ctrl, bdp->add);
					retval = bdp->add;
					break;
					}
				}
			}
		}
	}
cur_blk_seg = 0xffff;
set_emm_handle();
return retval;
}


/*************************************************************************
 ins_blockdata -
		make a blockdata table entry.
*************************************************************************/
void ins_blockdata (UI w,UI h,ULI cksum,ULI add,UI dma2_ctrl)
{
BLOCKDATA far *bdp;

FP_SEG(bdp) = emm_page_frame;
FP_OFF(bdp) = nextblk;
if ((nextblk+=sizeof(BLOCKDATA)) < sizeof(BLOCKDATA))
	{
	if (++new_blk_seg >= num_free_segs)
		{
		msgx ("No more blocks available!\n");
		}
	else {
		nextblk = sizeof(BLOCKDATA);
		FP_OFF(bdp) = 0;
		}
	}
set_emm_seg(new_blk_seg);
bdp->w = w;
bdp->h = h;
bdp->dma2_ctrl = dma2_ctrl;
bdp->cksum = cksum;
bdp->add = add;
bd_ct++;
cur_blk_seg = 0xffff;
set_emm_handle();
}



void free_blocks()
{	
register int i;

for (i=0; i < 4; i++) 
		release_pages(blk_handle[i]);
}


//////////////////////   TEMP TABLE ROUTINES

void load_temp_table(char *fname)
{
int tmpfil;
char imname[68];
int loaded,i,num_imgs,num_seqs;
char *ti;
int *iptr;

loaded = 0;
if (access(tname,0) == 0)	// if it exists...
	{								// look for this entry in the table
	if ((tmpfil = open(tname,O_RDONLY | O_BINARY)) <= 0)
		{
		printf( "\nERROR *** Cannot open temp file for read, load_temp_table!!\n");
		graceful_exit(7);
		}
	if (dbg_verbose) printf("tmp file opened for read (%s,%d) - load_temp_table\n",tname,tmpfil);
	while (read (tmpfil, imname, 68) == 68)
		{
		num_imgs = *(int *)(&imname[64]);
		num_seqs = *(int *)(&imname[66]);
		tmppos = tell(tmpfil);
		read(tmpfil, temp_img_data, (num_imgs+1)>>1);
		read(tmpfil, temp_seq_data, (num_seqs+1)>>1);
		for (ti = fname; *ti; ti++) *ti = toupper(*ti);
		if (strcmp(fname,imname)) continue;
		if (num_imgs != lib_hdr.num_images)
			printf("\nWARNING!! IMG count for %s is %d in tmp file, %d in .img file",
					fname,num_imgs,lib_hdr.num_images);
		if (num_seqs != lib_hdr.num_seq)
			printf("\nWARNING!! SEQ count for %s is %d in tmp file, %d in .img file",
					fname,num_seqs,lib_hdr.num_seq);
		loaded = 1;
		break;
		}
	close(tmpfil);	
	if (dbg_verbose) printf("tmp file closed (%s,%d) - load_temp_table\n",tname,tmpfil);
	}

if (!loaded)
	{
	tmppos = 0xffffffffL;
	iptr = (int *)temp_img_data;
	for (i=(MAX_IMG+3)>>2; --i >= 0;) *iptr++ = 0;
	iptr = (int *)temp_seq_data;
	for (i=(MAX_SEQ+3)>>2; --i >= 0;) *iptr++ = 0;
	}

	
}






void save_temp_table(char *fname)
{
register int tmpfil,frst;
char *ti;

frst = 0;

if (access(tname,0) < 0)	// if it doesn't exist create it
	{
	if ((tmpfil = open(tname,O_CREAT | O_RDWR | O_BINARY | O_TRUNC,S_IWRITE)) <= 0)
		{
		printf( "\nERROR *** Cannot create temp file, save_temp_file!!\n");
		graceful_exit(7);
		}
	if (dbg_verbose) printf("tmp file CREATED (%s,%d) - save_temp_table\n",tname,tmpfil);
	frst = 1;
	}
else {
	if ((tmpfil = open(tname,O_RDWR | O_BINARY)) <= 0)
		{
		printf( "\nERROR *** Cannot open temp file for update, save_temp_table!!\n");
		graceful_exit(7);
		}
	if (dbg_verbose) printf("tmp file opened for update (%s,%d) - save_temp_table\n",tname,tmpfil);
	if (tmppos == 0xffffffffL)
		{
		lseek(tmpfil,0,SEEK_END);
		frst = 1;
		}
	else lseek (tmpfil,tmppos,SEEK_SET);
	}

if (frst)
	{
	for (ti = fname; *ti; ti++) *ti = toupper(*ti);
	write(tmpfil,libname,64);
	write(tmpfil, (char *)&lib_hdr.num_images,2);
	write(tmpfil, (char *)&lib_hdr.num_seq,2);
	}
write(tmpfil, temp_img_data, (lib_hdr.num_images+1)>>1);
write(tmpfil, temp_seq_data, (lib_hdr.num_seq+1)>>1);
if (dbg_verbose) printf("tmp file closed (%s,%d) - save_temp_table\n",tname,tmpfil);
close (tmpfil);
}



int get_temp_mark(char *tbl,int indx)
{
char data;

data = tbl[indx>>1];
if (indx&1) data >>= 4;
else data &= 0xf;
return(data);
}


void set_temp_mark(char *tbl,int indx,unsigned char data)
{
char odata;

odata = tbl[indx>>1];
if (indx&1)
	  odata = (odata & 0x0f) | (data <<= 4);
else odata = (odata & 0xf0) | (data &= 0xf);
tbl[indx>>1] = odata;
}



/*   4 bits per image as follows

	if upper 2 bits == 0,
		then lower 2 bits =...  means...
			        0			    never seen it
			        1				 wrote img hdr to imgtbl.asm/imgtbl.glo
			        2				 wrote img hdr to unixx.tbl
 			        3             wrote img hdr to a local .tbl file OR
					                                imgtbl.asm/other .glo file

	if upper 2 bits != 0,  then they have same meaning as 1,2,3 above
		and lower 2 bits tell which .glo file name has been written to.
			bit 0 = written to imgtbl.glo
			bit 1 = written to univtbl.glo
*/


void adjust_temp_img(char *cptr,int num)
{
register unsigned char high,low;
int i;

for (i=(num+1)>>1; --i >= 0;)
	{
	high = low = *cptr;
	if ((low &= 0xf) < 4)
		{
		if (low)		// if not zero	
			{
			low <<= 2;
			if (low == 4) low = 5;		// already written to imgtbl.glo
			}
		}
	if ((high &= 0xf0) < 0x40)
		{
		if (high)		// if not zero	
			{
			high <<= 2;
			if (high == 0x40) high = 0x50; // already written to imgtbl.glo
			}
		}
	*cptr++ = low | high;
	}
}


void change_temp_marks(void)
{
int tmpfil,num_imgs,num_seqs;
char imname[68];

if (access(tname,0) == 0)	// if it exists...
	{								// look for this entry in the table
	if ((tmpfil = open(tname,O_RDWR | O_BINARY)) <= 0)
		{
		printf( "\nERROR *** Cannot open temp file for update, change_temp_marks!!\n");
		graceful_exit(7);
		}
	if (dbg_verbose) printf("tmp file opened for update (%s,%d) - change_temp_marks\n",tname,tmpfil);
	while (read (tmpfil, imname, 68) == 68)
		{
		num_imgs = *(int *)(&imname[64]);
		num_seqs = *(int *)(&imname[66]);
		tmppos = tell(tmpfil);
		read(tmpfil, temp_img_data, (num_imgs+1)>>1);
		read(tmpfil, temp_seq_data, (num_seqs+1)>>1);
		adjust_temp_img(temp_img_data,num_imgs);
		adjust_temp_img(temp_seq_data,num_seqs);
		lseek (tmpfil,tmppos,SEEK_SET);
		write(tmpfil, temp_img_data, (num_imgs+1)>>1);
		write(tmpfil, temp_seq_data, (num_seqs+1)>>1);
		}
	close(tmpfil);
	if (dbg_verbose) printf("tmp file closed (%s,%d) - change_temp_marks\n",tname,tmpfil);
	}
}
