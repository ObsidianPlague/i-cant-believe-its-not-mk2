struct UNIHDR {
	int version;
	int nlibs;
	int objcnt;
	int	halfy;
	long zclose;
	long	zfar;
	long	world_y;
	long xbase;
	long ybase;
	long zbase;
	int gnd_colr;
	int sky_colr;
	int	nmods;		// vers .60 and above
	int	spare1;
	int	spare2;
	int	spare3;
	int	spare4;
	int	spare5;
	}  uni_hdr;


struct OBJHDR {
	int lib_indx;		// if negative, use indx to get damage table
	char iname[16];	// img or sequence depending on ANIM bit
	int indx;			// same as above 
	long	worldx;
	long	worldy;
	long	worldz;
	int flags;			// see below
	int	oid;			// vers .60 and above
	int	objinfo;		// vers .96 and above
							//   bit 4 = 1 means WALL, nice idea, not really used
							//   bit 3 = 1 means FG obj, do not load to ROM
							//   bit 2 = 1 means USE AND LOAD DAMAGE TABLE
							//   bit 1 = 1 means DELAY ANIMATION if sequence
							//   bit 0 = 1 means this is a SEQUENCE

//	int	damage;		// vers .80 and above. If >=0, represents damage frame
							// decoded as follows upper 4 bits = lib_indx,
							//                    LSB = 0 (img) or 1 (seq)
							//							 other 10 bits = img or seq indx
	int	gameoid;		// OID to be used in game
	int	spare1;
	int	spare2;
	int	spare3;
	int	spare4;
	} ;

struct DAMAGE_FILE {		// definition not used as yet
	char	num_levls;
	char	lib_indx;		
	int	indx[16]; 		// when saving damage table to file, replace ptr with indx.
	int	flags;
	} ;	

typedef struct {
	char name[INAMELEN+1];
	char flags;
	int  num_objs;			// number of objects which make up module
	int	copy_num;		// how many copies of the object exist?
	int	spare1;
	int	spare2;
	struct OBJHDR far *(far *objtbl);
	}	MODULE;


//	FLAGS in OBJHDR

#define	M_NOSCALE	1			// Display Full Size regardless of Z pos.
#define	M_DBLSCL		2			// Enemy can jump over this obj
#define	M_BLOCK		4			// Enemy can't go through this obj
#define	M_GRND		8			// Object is on the ground
// flip bits are 0x10 and 0x20

#define	M_TYPE		0x07c0	// 5 bits allow for 32 different types
#define	B_TYPE		6

#define	OLD_M_FG			0x0800	// This is a foreground object (load2 will ignore)
#define	OLD_M_DANIM		0x1000	// if M_ANIM set, this says keep static at start
#define	OLD_M_WALL		0x2000	// This is a foreground object (load2 will ignore)
#define	OLD_M_ANIM		0x4000

#define  M_DAMG_ENEMY	0x40   // This flag is used internally in load20 ONLY!
										 // It indicates that some object of an image
										 // with its damage flag set can be an
										 // enemy generator.

#define	M_WALL		0x10	// This is a wall piece (not really supported)
#define	M_FG			   8	// This is a foreground object (load2 will ignore)
#define	M_DAMAGE  		4	// Use the damage table if there is one.
#define	M_DANIM		   2  // if M_ANIM set, this says keep static at start
#define	M_UANIM		   1  // This is a sequence


#define	M_ONESHOT	0x0800	// This object is to be deleted forever
										//  when it goes offscreen.
#define	M_NOPIXSCAN 0x1000	// don't perform a pixel scan on this image
#define	M_PORTAL		0x2000	// This object is a portal to another univ
#define	M_NOVECTOR	0x4000	// Don't give this object a gun vector
#define  M_ENEMY		0x8000	// Dispatch enemies from behind this obj.


#define	OIDVSN	((0<<8)+93)	// First version to store OID NAMES in file
#define	NUFLGVSN	((0<<8)+96)	// Flags changed, objinfo field added to objhdr
