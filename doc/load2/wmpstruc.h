//     IMG, SEQSCR AND ENTRY STRUCTURES AS WELL AS PALETTE DATA MUST ALL BE
//			ALLOCATED IN THE DEFAULT DATA SEGMENT AS THEY REQUIRE NEAR POINTERS.


/* The following programs read wimp .img libs and must be looked at whenever the
	.img file format changes...
	WIMP,  WLIB,  BGTOOL,  BLIMP,  LOAD2
*/

#define  NUM_DEF_PAL	3
#define 	MAX_LIB	12

#define	MAX_SCR	64
#define	MAX_SEQ	128
#define	MAX_FRM	300
#define	MAX_IMG	500
#define	MAX_PAL	200
#define  NUM_BUF  4

#define round_x(x)	((x+3)&(~3))	/* perform rounding of an x size to
													 a mult of 4 */

typedef unsigned char UCHAR;

struct LIB_HEADER	{
			int	num_images;	/* Number of images in library */
			int	num_palettes;	/* Number of palettes */
			long	offset;		/* Offset in file to IMAGE and PALETTE */
			int	version;		/* NEW FOR WIMP 5.0 and above! (was spare3) */
			int	num_seq;		/* size of sequence pool */
//			char	activbuf;		/* flags to tell us which buffers are activ */
//		In WIMP >= 5.0, activbuf is changed to num_scripts
			int num_scripts;
			int	num_dam;		/* Number of damage tables
										used to be char cspare1  */
			int	temp;			/* = 0xabcd if version is valid  */
//	The bufscr field is new for WIMP 5+ and adds 4 bytes to the size
//              of the library header
			UCHAR	bufscr[NUM_BUF];		/* 8 bits defines the script for each buffer */
										/* 0xff means buffer is not in use */	
			int	spare1;
			int	spare2;
			int	spare3;
			};

#define PNAMELEN 9
#define INAMELEN 15

char  defltname[INAMELEN+1];

struct PALETTE {
			char name[PNAMELEN+1];			/* name of palette */
			char flags;		
  			char	bits_pr_pxl;		/* bits per pixel used */
			unsigned int num_cols;	/* number of colors used */
			long	offset;			/* offset in file of image */
			int   near *data;		/* pointer to palette data */
			int	lib;			/* index into library handle array */
			unsigned char colind; /* pointer to start color in CRAM */ 
			char	cmap;		/* Which color map to use (0-F) */	
			int	ispare1;
         };


struct IMG	{
			char	name[INAMELEN+1];			/* image name */
			int	xoff, yoff;		/* animation offsets */
			unsigned int xsize, ysize;		/* size in pixels */
			char palind;			/* pointer to palette data */
			char	flags;			/* i.e. range selected */
			long	offset;			/* offset in file of image */
			char	far *data;		/* pointer to image data */
			int	lib;				/* index into library handle array */
			int	pword1;			/* packed collision box */
			int	pword2;			/* packed collision box */
			char	frame;			/* frame number for anim. purposes */
			char pbyte1;			/* packed collision box */
			};

/* Flags in IMAGE structure */

#define	MARKED	1		/* Marked in a range command */
#define	LOADED	2		/* Current version is loaded in memory */
#define	CHANGED 	4		/* Image data differs from when it was loaded */
#define	DELETE 	8		/* Image will not be saved when lib is saved (not used) */
#define	DOWN		0x10		/* Image or palette is currently in GSP mem */
#define	NEW		0x20	/* Img or pal was created in this Wimp session */
#define	SEQFLG	0x40	/* For ENTRYs and SEQSCRS only. distinguishes bet. img/seq or seq/scr  */

#define	M_COPIES   0x300 // tells LOADIMG how many copies to make
			    					// if this image is loaded from a universe
				   				// 0-3 means 1-4
#define	B_COPIES   8 // tells LOADIMG how many copies to make


struct ANIM_ENTRY	{
		struct	IMAGE	near *image;
		UCHAR		imgind;
		UCHAR		ticks;
		int		deltax;
		int		deltay;
		char		cspare2;
		char		cspare1;
		int		spare1;
		int		spare2;
		int		spare3;
		}  ;

typedef struct ANIM_ENTRY FRAME;

struct	ANIM_SEQ	{
		int		num_frames;				/* number of frames in seq */
		FRAME		near *frame[16];	/* 16 frames in seq */
		char		name[INAMELEN+1];
		int		spare2;			  /* so seq can be marked */
		int		spare1;
		};


struct	BUF_ENTRY	{
		struct	ANIM_SEQ		near *sequence;
		int		deltax;
		int		deltay;
		char		seqind; 	  // used only when saving to file
		char		cspare1;
		int		spare1;
		int		spare2;
		};

struct	ANIM_BUF	{
		int		num_seq;
		struct	BUF_ENTRY		near *entry[16];	/* 16 sequences in buffer */
		int		startx;
		int		starty;
		int		spare1;
		int		spare2;
		};


// *******************  NEW FOR NEWWIMP 

#define NUM_DAM	6		// number of possible damage tables

typedef struct	{
			char	name[INAMELEN+1];			/* image name */
			int	flags;			/* i.e. range selected */
			int	xoff, yoff;		/* animation offsets */
			unsigned int xsize, ysize;		/* size in pixels */
			int   palind;			/* pointer to palette data */
			long	offset;			/* offset in file of image */
			char	far *data;		/* pointer to image data */
			int	lib;				/* index into library handle array */
			char	dam[NUM_DAM];		/* damage tables */
			int	frame;	/* frame number for anim. purposes */
			int  pt_tbl;		/* NEW for WIMP >= 6.01 
                                 This field used to be spare1.
										When reading .img files...
                                 If this field >= 0, then
											it means that a point table
											is associated with this image, and follows
											at the end of the .img file.
                              When writing images, the index numbers are sorted in
                                 image order.  The tables are written in order at
											the end of the image file.  		*/
			int othpals;		// Ver 6.30 and greater.
									// Ability to associate alternate palettes to an image.
									// When saved to a file, this field is the number of 
									// 		other palettes minus 1.
									// When read from a file, this field becomes the index of 
									// 		the other palette table.
			int	spare1;
			int	spare2;
			int	spare3;
			} IMAGE;

struct POINT {
	int	x,y;
	};

typedef struct {
	struct POINT	pt[10];
	}  POINT_TABLE;

#define PTTBL_VER	0x60a			// point tables added
#define OTHPALVSN	0x61d			// alternate palettes supported
#define LGMODLVSN	0x632			// WIMP converted to large model, damage tables supported
#define REVERTVSN	0x634			// Write imgs and palettes for backward compatibility


typedef	struct  {
		void		near *itemptr;	// points to an IMAGE or sequence
		int		indx; 	  // used only when saving to file
		UCHAR		ticks;
		int		deltax;
		int		deltay;
		int		spare1;
		int		spare2;
		int		spare3;
		}  ENTRY;


typedef struct	{
		char		name[INAMELEN+1];				/* script name  */
		int		flags;
		int		num;
		ENTRY		near *entry[16];	/* 16 sequences in buffer */
		int		startx;			//start x pos in scripts, seq ctr in seqs
		int		starty;
		int		spare2;
		}  SEQSCR;


typedef struct {				// THIS IS NOT BEING USED!
	char	num_levls;			// number of damage levels defined.
	char	lib_indx;		
	int	flags;				// each bit represents img (0) or seq (1)
	void  *ditem[16];			// These could be images or sequences
	} DAMAGE_WIMP;



char dirbuf[40];
struct LIB_HEADER	lib_hdr;



// AS OF VER 6.50, WIMP FILES WILL NEED TO STORE FAR POINTERS
//	(when WIMP moves to large model)

typedef	struct  {
		void		far *itemptr;	// points to an IMAGE or sequence
		int		indx; 	  // used only when saving to file
		UCHAR		ticks;
		int		deltax;
		int		deltay;
		int		spare1;
		int		spare2;
		int		spare3;
		}  FENTRY;


typedef struct	{
		char		name[INAMELEN+1];	// script name 
		int		flags;				//
		int		num;
		FENTRY	far *entry[16];	// 16 sequences in buffer 
		int		startx;			   //start x pos in scripts, seq ctr in seqs
		int		starty;
		char		dam[NUM_DAM];		// damage table index (seqs only, -1 if none)
		int		spare1;
		int		spare2;
		}  FSEQSCR;





typedef struct {
			char name[PNAMELEN+1];			/* name of palette */
			char flags;		
  			char	bits_pr_pxl;		/* bits per pixel used */
			unsigned int num_cols;	/* number of colors used */
			long	offset;			/* offset in file of image */
			int   *data;		/* pointer to palette data */
			int	lib;			/* index into library handle array */
			unsigned char colind; /* pointer to start color in CRAM */ 
			char	cmap;		/* Which color map to use (0-F) */	
			int	spare1;
			int	spare2;
			int	spare3;
         } PAL;


