#define MIN_IMG_WIDTH	3		// Imgs less than this are padded to this.


/* for setting HSTCTLH */
#define	INCRD	0x10
#define	INCWR	0x8
#define NOINC		0x0
#define HLT			0x80      /* 1 = Halt GSP */
#define CF			0x40      /* 0 = disable/flush cache, 1 = enable */
#define NMIM		0x02      /* 0 = retain context, 1 = lose */
#define NMI			0x01      /* 1 = software reset */

int color_average(int delt,char *c1,int *palbuf,int num_cols);

#define	NUMPALS 800			/* WBD 9/9/91 */

#define	ZCOMPIXELS	10

typedef unsigned int UI;
typedef unsigned long ULI;


int	srch_pname(char *pstring);
void ins_blockdata (UI, UI, ULI, ULI, UI);
void init_bd (void);
ULI srch_bd (UI, UI, ULI, UI);
ULI getcksum (UI far *data, ULI ct, UI *max_colr );
void free_blocks(void);


#define NAME_LENGTH	10
#define MAXDATA	65500			// 65536
/* these defines are for each bgnd file */
#define MAXMODS	100
#define MAXPALS	256
#define MAXBLOCKS		2500
#define MAXHDRS	400
/* these defines are across all bgnd files */
#define TOTPALS	512


  /* At 1 HDR TBL per BGND file == MAX # BGND FILES */
#define	MAXHDRTBLS	50 
  /* MAXBLKTBLS is really MAX # of MODULES ACROSS all BGND FILES */
#define  MAXBLKTBLS	500

int far bdbuf [MAXDATA/2];

struct	Module {
	char	name [NAME_LENGTH];
	UI	x1, x2, y1, y2, numBlocks;
	} bgnd_mod [MAXMODS];

struct	BgndBlock {
	UI	z, x, y, hdr, put, hdrsindx;
	} far bgnd_block [MAXBLOCKS];
int	bgnd_err_ctr;

struct	Header {
	UI	oldh, w, h;
	ULI	loadadd;
	}	hdrs [MAXHDRS];

typedef struct {
	UI		w, h;
	UI		dma2_ctrl;
	ULI	cksum;
	ULI	add;
	} BLOCKDATA;



struct STYLE {
	int	field;
	char	size;
	}  table_style[32];


int   zcom_min_fail;
int bits_filled,dataword;
IMAGE	 *img[MAX_IMG];			 
FSEQSCR	*sequence[MAX_SEQ];
FSEQSCR	*script[MAX_SCR];
struct LIB_HEADER	lib_hdr;
struct IMG oldimg;			 
#define MAX_PTTBL 2048
POINT_TABLE  *pt_table[MAX_PTTBL];
PAL		*pal[MAX_PAL*2];
int PalBuf[256];
ULI	destbits;
char far *imgbuf;
int far *wrdptr;


struct zero_thing
{ int lead, trail;     	// lower 8 bits of 'lead' ultimately contain
} zero_array[256];		// the lead/trail nibbles.


#define MAX_CBUFF_SIZEL 65500L

int far *cbuff, far *cbuff_ptr;


int		cur_lib,strt_col,palindex, imgpalidx;
char		c;
char		*srcdir, srcdirbuf[40], *curdir, dirbuf[40],filename[80],*linemark;
char		*imgdir, imgdirbuf[40], pallist[NUMPALS][10], imgpal_list[NUMPALS][10];
char 		unidirbuf[40],loddirbuf[40],tbldirbuf[40],rawdirbuf[40],libname[64];
char 		ovrdirbuf[40];
int		pallstf[NUMPALS];
char		astring[256],loadmsk,*fgets();
long	startaddr,imgaddr,topaddr,paladdr;
long  endaddr;
ULI	howmanytotal;
long	cur_rec_addr, new_rec_addr;
long	iram_ct, irom_ct, sram_ct, prom_ct, total_ct;
long	*curr_ct;
long	iramrec_ct, iromrec_ct, sramrec_ct, promrec_ct, totalrec_ct;
long	*currec_ct;
char	do_load, do_table, do_cksum, do_verbose, do_ovr_dir, do_superbpp;
char	do_file, do_raw_load, do_rawbgnd,do_qrtr,do_pad,do_align,do_sclpad;
char  do_append,do_uni_dir,do_wruniseq,do_univ,part_of_seq;
int	packbits;
int	do_zcom,do_zall;
unsigned int dma2_field;
int	err_cnt;
char *ovr_dir,*tbl_dir,*raw_dir,*lod_dir;
char lod_ovr_flg,max_copies;
int	mpboxon;
int	cboxon;

#define	MAX_GBL_FILES	50
char	*gbl_file [MAX_GBL_FILES];
int	num_gbl_files;
int	gbl_fileno;
FILE	*gbl_fptr;
char	*gbl_fname;
char	*dflt_gbl_file;

#define	MAX_ASM_FILES	100
char	*asm_file [MAX_ASM_FILES];
int	num_asm_files;
int	asm_fileno;

//char	*inames [MAX_ASM_FILES][256];
struct IMNAME {
	char iname[INAMELEN+1];
	struct IMNAME *nxtname;
	}	*inames[MAX_ASM_FILES];

FILE	*asm_fptr;
char	*asm_fname;
char	*dflt_asm_file;
char	*dflt_pal_file;
int	bgfiles_open;
int	uni_file_num,frst_uni_flg;

void load_block (UI wid, UI ht,int dfield,int pad);
void	read_bgnd ();
void	read_univ ();
void	insert_palname ();
int	exist_imgpal();
void flush_buffer(long nxtsiz);
void expand_filespec(char *srcstr,char *dststr);

int	bgnd_cksum_match, fgnd_cksum_match;
int	palette_sup;   //, ani_sup, swap_ani;
long	raw_pos;
unsigned long	bgnd_cksum_bits, fgnd_cksum_bits;

unsigned int	host_seg, host_adrl, host_adrh, host_ctll, host_ctlh;
unsigned int	host_data;

FILE		*src,*txt,*glo,*bgndtbl,*bgndpal,*bgndequ,*imgpal, *frawfile;
FILE 	*univtbl,*univglo,*univseq;


ULI far BLOCK_TABLE[MAXBLKTBLS];	/* ptrs to blk tbls in image rom */
int blk_tbl_indx;		/* current block table index */
ULI far HEADER_TABLE[MAXHDRTBLS];	/* ptrs to hdr tbls in image rom */
int hdr_tbl_indx;

char ihdr_sect[20];

int othpal_indx;
char *othpal_table[MAX_IMG];

#define	MAX_DAM	128
FSEQSCR *damage[MAX_DAM];


struct DAMTBL {
	int damind;
	int num;
	char *undam_name;
	}  *dam_tbl[MAX_DAM];

int gbl_dam_num,dam_num;

// ED adjustment

int dual_bank,bank,sysctrl;		// for MKII dual banked image memory
#define SYS_CTL_REG  0x1b00000L
#define BANK_BIT	   0x80


struct RAW_FILE_HEADER	{
			char	version[32];				/* Version number that made this */
			unsigned int	ver_cksum;		/* checksum of the version # */
			unsigned int	magic_num;		/* Raw file magic number */
			long	spare1;
			long	spare2;
			};

struct RAW_FILE_RECORD	{
			unsigned long	start_addr;		/* Load address of this record */
			unsigned long	byte_count;		/* Count in bytes */
			unsigned long	checksum;		/* 32 bit checksum, add words */
			unsigned int	interleave;		/* 4 for compatibility */
			unsigned int	skipbytes;		/* 0 for compatibility */
			int bank; 							/* for bank switched T-unit */
			int spare1;
			long	spare2;
			};

#define RAW_MAGIC	0x64



// TEMPORARY TABLE to select auto globals

char temp_lib_name[64];
char temp_img_data[(MAX_IMG+3)>>1];
char temp_seq_data[(MAX_SEQ+3)>>1];

char tname[64];
void load_temp_table(char *fname);
void save_temp_table(char *fname);
int get_temp_mark(char *tbl,int indx);
void set_temp_mark(char *tbl,int indx,unsigned char data);
void change_temp_marks(void);
void adjust_temp_img(char *cptr,int num);

int frm_univ;				// where current wimp lib was opened from
long	tmppos;
int dbg_verbose;
