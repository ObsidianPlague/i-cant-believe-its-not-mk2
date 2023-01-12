
/*************************************************************************
*																							    *
* zcom_analysis																			 *
* 																								 *
* this routine examines an image using zero-compression and returns the  *
*  control word and the leading and trailing zero list                   * 																								 *
*																							    *
* image          - image																 *
* ysize          - y size of the image												 *
* xsize          - x size of the image (not padded)							 *
* bits_per_pixel - number of bits per pixel to pack							 *
*																							    *
*************************************************************************/

int zcom_analysis(char far *image,int ysize,int xsize,int bits_per_pixel)
{
char far *srcaddr;
unsigned int pinhead, zlc, ztc;
int lm, tm, x0, x1, k, lf, tf, zeros;
int factor0, factor1, x, y, zero_pad, ctrl_word;
ULI	imgsize;

struct	zero_thing leftover[4];

imgsize = 0;
zero_pad = (4 - xsize) & 3;

for(k=0; k<4; k++)
    leftover[k].lead = leftover[k].trail = 0;

srcaddr = image;

for(y=0; y<ysize; y++)
	{
	zlc = ztc = 0;
   lf = 1;	
   for (x=0; x<xsize; x++)
		{
		pinhead = *srcaddr++ & 0xFF;
      if (lf)
			{
       	if (zlc != 8*15)
				{
				if (!pinhead)   zlc++;
				else lf = 0;
				}
			else lf = 0;
			}
		else if (x > xsize-8*15)
			{
			if (!pinhead)  ztc++;
			else  ztc = 0;
			}
		}
	 srcaddr += zero_pad;
    for(k=0; k<4; k++)
		{
		factor0 = 1 << k;
	   factor1 = zlc / factor0;
      if (factor1>15) 
				 factor1 = 15;
      leftover[k].lead += zlc - factor1 * factor0;

      factor1 = ztc / factor0;
      if (factor1>15) 
		        factor1 = 15;
      leftover[k].trail += ztc - factor1 * factor0;
		}  
	zero_array[y].lead  = zlc;
	zero_array[y].trail = ztc;
	}

lm = tm = 0;
for(k=1; k<4; k++)
	{
	if (leftover[k].lead<leftover[lm].lead) 
   	   lm = k;
	if (leftover[k].trail<leftover[tm].trail) 
   		tm = k;
	}
ctrl_word = ((bits_per_pixel & 0x07) << 12) | (tm << 10) | (lm << 8)| ( 1 << 7);
lm = 1 << (lf=lm);
tm = 1 << (tf=tm);
if (do_verbose > 4)
    printf("\n\nbits per pixel = %d\nleading factor = %d\ntrailing factor = %d\n\n",bits_per_pixel,lm,tm);
 
for(y=0; y<ysize; y++)
	{
	zlc = zero_array[y].lead;
   ztc = zero_array[y].trail;
   if (zlc > lm*15)
	      zlc = 15;
   else
  		   zlc = zlc / lm;
   if (ztc>tm*15)    ztc = 15;
	else  ztc = ztc / tm;
	x0 = zlc * lm;
   x1 = xsize - 1 - ztc * tm;
   if ((x1 - x0 + 1) < ZCOMPIXELS)				//need non-zero pixels minimum
		{
		zeros = ZCOMPIXELS - (x1 - x0 + 1);   
		if (zeros > x0)   zeros -= x0;
		else				   x0 = zeros;
      zlc = (zlc * lm - x0) / lm;
      x0 = zlc * lm;
		if ((x1 - x0 + 1) < ZCOMPIXELS)
			{
			ztc = (ztc * tm - zeros) / tm;
			x1 = xsize - 1 - ztc * tm;
			}
		}
   imgsize += (xsize - (ztc<<tf) - (zlc<<lf)) * bits_per_pixel;
	zero_array[y].lead  = (ztc << 4) | zlc;
	}
	
imgsize += ysize << 3; 		// 8 bits per line
if (destbits < imgsize)
			    ctrl_word = 0;
else destbits = imgsize;

if (do_verbose > 4)
	{
	printf("\n\n");
   for(k=0; k<4; k++)
      printf("leftover zeros for x%d, %d leading, %d trailing\n", (1 << k), 
              leftover[k].lead, leftover[k].trail);
   printf("\n\n");
	}

return ctrl_word;
}

