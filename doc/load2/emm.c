int emm_handle;

void free_emm64K(void far *emmptr)
{
if (test_for_emm() >= 0)
	{
	release_pages(emm_handle);
	}
else _ffree(emmptr);
}
	

void set_emm_handle(void)
{
		map_pages(0x0000,emm_handle);
		map_pages(0x0101,emm_handle);
		map_pages(0x0202,emm_handle);
		map_pages(0x0303,emm_handle);
}

void far *emm64K(void)
{
int emmflag;
void far *emmptr;

if ((emmflag = (char)test_for_emm()) >= 0)
	{
   if (get_free_page_count() < 4) emmflag = -1;
	else {
		printf("Using a page of expanded memory.\n\n");
		emm_handle = allocate_pages(4);
		set_emm_handle();
		FP_SEG(emmptr) = get_page_frame_base();
		FP_OFF(emmptr) = 0;
		}
	}
if (emmflag < 0)	emmptr = _fmalloc((size_t)65500);
	
return(emmptr);
}
