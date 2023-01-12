

void if_exists_make_backup(char *fname)
{
char bname[80];

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
	ext = strrchr(bname,'\\')+1;
	rename(fname,ext);	/* rename original file to backup name */
	}
}



