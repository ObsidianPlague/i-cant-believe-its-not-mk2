**************************** PROCESS STRUCTURE **************************

*struct prc
PLINK		.SET	0		;LINK TO NEXT 32 BITS
PROCID		.SET	20H		;UHW PROCESS ID 16 BITS
pdata		.SET	100H
p_slave		.set	pdata+090h	; (32) - slave object
p_action		.set	pdata+0f0h	; (16) - current action
p_otherguy	.set	pdata+040h	;UHL - other guys object
PTIME		.SET	30H		;UHW SLEEP TIME X 16MSEC 16 BITS
PSPTR		.SET	40H		;UHL PROCESS STACK POINTER
PA11		.SET	60H		;UHL	REGISTERS SAVED
PA10		.SET	80H		;UHL
PA9		.SET	0A0H		;UHL
PA8		.SET	0C0H		;UHL
PWAKE		.SET	0E0H		;UHL
*endstruct

************************ PROCESS DATA STRUCTURE ***********************
* MAKE SURE pdata = 100H (EJB)

*struct prcdata
PLINK		.SET    0		;LINK TO NEXT PROCESS
PROCID	       	.SET    20H		;UHW - PROCESS ID 16 BITS
PWAKE		.SET	0E0H		;UHL -
P_JOYPORT	.SET	pdata		;UHL - JOYSTICK SWITCH PORT LOCATION
P_BUTPORT	.SET	pdata+020H	;UHL - BUTTON PORT
P_OTHERGUY	.SET	pdata+040H	;UHL - OTHER GUYS OBJECT
P_OTHERACT	.SET	pdata+060H	;UHW - DRONE INFO: OTHER DUDES LAST ACTION
P_OTHERPROC	.SET	pdata+070H	;UHL - OTHER GUYS PROCESS
P_SLAVE		.SET	pdata+090H	;UHL - SLAVE OBJECT
P_ANITAB		.SET	pdata+0B0H	;UHL - CURRENT ANIMATION TABLE
P_ANIRATE	.SET	pdata+0D0H	;UHW - ANIMATION SPEED
P_ANICOUNT	.SET	pdata+0E0H	;UHW - ANIMATION COUNTER
P_ACTION		.SET	pdata+0F0H	;UHW - CURRENT ACTION
P_GANIY		.SET	pdata+100H	;UHW - GROUNDED ANIMATION POINT Y
P_FLAGS		.SET	pdata+110H	;UHW - MORE FLAGS
P_DOWNCOUNT	.SET	pdata+120H	;UHW - # TICKS I HAVE BEEN DUCKING
P_DRONEVAR1	.SET	pdata+230H	;UHL - DRONE VARIABLE #1
P_HITBY		.SET	pdata+250H	;UHW - I WAS "HIT BY" THIS LAST
*endstruct

*************************** OBJECT STRUCTURE *****************************

*struct OBJ
olink	.set	0
oid	.set	1c0h	;UHW - (16) bit object id			
oflags	.set	0f0h	;UHW - (16) bits 0 - 5 dma control
oflags2	.set	160h	;UHW - (32) game flags
oimg	.set	1a0h	;UHL - (32) bit pointer to image data table	
osag	.set	100h	;UHL - (32) bit source address (unclipped, adjusted for flips)
oxval	.set	080h	;UHL - (32) bit x position
oyval	.set	0a0h	;UHL - (32) bit y position			
ozval	.set	0c0h	;UHL - (32) bit z position
oxvel	.set	040h	;UHL - (32) bit x velocity 16.16
oyvel	.set	060h	;UHL - (32) bit y velocity 16.16
ograv	.set	020h	;UHL - (32) bit y gravity
osizex	.set	120h	;UHW - (16) x size
osizey	.set	130h	;UHW - (16) y size
opal	.set	140h	;UHL - (16) bit b(0-15) palette
oscale	.set	180h	;UHL - (32) scale factor for dma
oshape	.set	1d0h	;UHL - (32) multipart "ani shape"
ochar	.set	1f0h	;UHW - (16) character i.d.
ofset	.set	0e0h	;UHW - (16) bits 16-31 precomputed offset
*endstruct

*********************** BACKGROUND OBJECT LIST ***************************

*struct BAK
OLINK	.SET	0	;32 BIT Link to next object block
OID	.SET	190H	;UHW 16 BIT Object ID			
OFLAGS	.SET	0E0H	;UHW 32 BIT bits 0 - 5 DMA CONTROL; B16-31= OFFSET PRECOMPUTED
OSAG	.SET	100H	;UHL BIT SOURCE ADDRESS (UNCLIPPED, ADJUSTED FOR FLIPS)
OSCALE	.SET	240H	;UHL SCALE FACTOR FOR DMA
OXVAL	.SET	080H	;UHL (32) BIT X POSITION
OYVAL	.SET	0A0H	;UHL (32) BIT Y POSITION			
OZVAL	.SET	0C0H	;UHL (32) BIT Z POSITION
OPAL	.SET	140h	;UHW 32 BIT B(0-15) PALETTE; B(16-31) CONSTANT COLOR
OIMG	.SET	160H	;UHL 32 BIT Pointer to image data table	
OPLINK	.SET	1A0H	;UHL 32 BIT Link to controlling process
OSLINK	.SET	020H	;UHL 32 BIT SPECIAL LIST
*endstruct

*************************** PALETTE STRUCTURE *****************************

*struct PAL
PALID	.SET	0	;UHL 32 BIT PALETTE I.D. (ADDRESS OF ACTUAL PALETTE)
PALCNT	.SET	>20	;UHW 16 BIT COUNT (# OF OBJECTS USING THIS PALETTE)
PALTIME	.SET	>30	;UHW 16 @TICK VALUE WHEN THIS PALETTE WAS DELETED
*endstruct

************************ BACKGROUND STRUCTURE *****************************

*struct PLANES
BAKPNT	.SET	0	;UHL 32 BIT POINTER TO 1ST OBJECT IN LIST
BAKWX	.SET	-32	;UHL 32
*endstruct
