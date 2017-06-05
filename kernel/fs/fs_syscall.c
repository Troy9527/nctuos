/* This file use for NCTU OSDI course */


// It's handel the file system APIs 
#include <inc/stdio.h>
#include <inc/syscall.h>
#include <fs.h>
#include <fat/ff.h>

/*TODO: Lab7, file I/O system call interface.*/
/*Note: Here you need handle the file system call from user.
 *       1. When user open a new file, you can use the fd_new() to alloc a file object(struct fs_fd)
 *       2. When user R/W or seek the file, use the fd_get() to get file object.
 *       3. After get file object call file_* functions into VFS level
 *       4. Update the file objet's position or size when user R/W or seek the file.(You can find the useful marco in ff.h)
 *       5. Remember to use fd_put() to put file object back after user R/W, seek or close the file.
 *       6. Handle the error code, for example, if user call open() but no fd slot can be use, sys_open should return -STATUS_ENOSPC.
 *
 *  Call flow example:
 *        ┌──────────────┐
 *        │     open     │
 *        └──────────────┘
 *               ↓
 *        ╔══════════════╗
 *   ==>  ║   sys_open   ║  file I/O system call interface
 *        ╚══════════════╝
 *               ↓
 *        ┌──────────────┐
 *        │  file_open   │  VFS level file API
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │   fat_open   │  fat level file operator
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │    f_open    │  FAT File System Module
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │    diskio    │  low level file operator
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │     disk     │  simple ATA disk dirver
 *        └──────────────┘
 */

// Below is POSIX like I/O system call 
extern struct fs_fd fd_table[FS_FD_MAX];

int sys_open(const char *file, int flags, int mode)
{
    //We dont care the mode.
/* TODO */
	int i,ret;
	int find_flag = 0;
	struct fs_fd *fds;

	// find file descriptor structure
/*	for(i = 0 ; i < FS_FD_MAX ; i++){
		if((strcmp(fd_table[i].path, file) == 0) && (fd_table[i].flags == flags)){
			fds = &(fd_table[i]);
			find_flag = 1;
			break;
		}
	}*/

	if(find_flag == 0){
		i = fd_new();
		if(i == -1) return -1;
		fds = fd_get(i);  	// increase ref_count
		fd_put(fds);		// decrease ref_count
		if(i != -1) find_flag = 1;
	}

	// open file
	if(find_flag == 1){
		ret = file_open(fds, file, flags);
	}
	else return -1;

	// error code
	if(ret == 0) return i;
	else return ret;
}

int sys_close(int fd)
{
/* TODO */
	// error code 
	if(fd >= FS_FD_MAX) return -STATUS_EINVAL;
	
	int ret;
	struct fs_fd *fds = &(fd_table[fd]);
	ret = file_close(fds);

	if(ret == 0){
		fd_put(fds);
	}
	return ret;
}
int sys_read(int fd, void *buf, size_t len)
{
/* TODO */
	// error code
	if(len < 0 || buf == NULL) return -STATUS_EINVAL;
	if(fd >= FS_FD_MAX) return -STATUS_EBADF;


	int ret;
	struct fs_fd *fds = &(fd_table[fd]);

	ret = file_read(fds, buf, len);

	return ret;
}
int sys_write(int fd, const void *buf, size_t len)
{
/* TODO */
	// error code
	if(len < 0 || buf == NULL) return -STATUS_EINVAL;
	if(fd >= FS_FD_MAX) return -STATUS_EBADF;

	int ret;
	struct fs_fd *fds = &(fd_table[fd]);

	ret = file_write(fds, buf, len);

	return ret;

}

/* Note: Check the whence parameter and calcuate the new offset value before do file_seek() */
off_t sys_lseek(int fd, off_t offset, int whence)
{
/* TODO */
	int ret;
	struct fs_fd *fds = &(fd_table[fd]);

	off_t new_offset;
	if(whence == SEEK_SET) new_offset = offset;
	else if(whence == SEEK_CUR) new_offset = fds->pos + offset;
	else if(whence == SEEK_END) new_offset = fds->size + offset;

	ret = file_lseek(fds, new_offset);
	return ret;
}

int sys_unlink(const char *pathname)
{
/* TODO */
	file_unlink(pathname);
}

int sys_list(const char *pathname){
	DIR dir;
	FILINFO fno;
	int res;
	int ret;

	//printk("ls folder = %s\n", pathname);
 	ret = f_opendir(&dir, pathname);
	if(ret != 0){
		printk("path doesn't exist\n");
		return -1;
	}

	res = f_readdir(&dir, &fno);
	while (strlen(fno.fname)) {
//		printk("[%s] ret = %d, filename = %s, fsize = %d, date = %d, time = %d\n",__func__, res, fno.fname, fno.fsize, fno.fdate, fno.ftime);
		printk("%s type = FILE size = %d\n", fno.fname, fno.fsize);
		res = f_readdir(&dir, &fno);
	}
	f_closedir(&dir);

	return 0;
}
              

