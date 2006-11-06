/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#ifndef _NFS_H_RPCGEN
#define _NFS_H_RPCGEN

#define RPCGEN_VERSION	199506

#include <rpc/rpc.h>

/*
 * Sun RPC is a product of Sun Microsystems, Inc. and is provided for
 * unrestricted use provided that this legend is included on all tape
 * media and as a part of the software program in whole or part.  Users
 * may copy or modify Sun RPC without charge, but are not authorized
 * to license or distribute it to anyone else except as part of a product or
 * program developed by the user or with the express written consent of
 * Sun Microsystems, Inc.
 *
 * SUN RPC IS PROVIDED AS IS WITH NO WARRANTIES OF ANY KIND INCLUDING THE
 * WARRANTIES OF DESIGN, MERCHANTIBILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE, OR ARISING FROM A COURSE OF DEALING, USAGE OR TRADE PRACTICE.
 *
 * Sun RPC is provided with no support and without any obligation on the
 * part of Sun Microsystems, Inc. to assist in its use, correction,
 * modification or enhancement.
 *
 * SUN MICROSYSTEMS, INC. SHALL HAVE NO LIABILITY WITH RESPECT TO THE
 * INFRINGEMENT OF COPYRIGHTS, TRADE SECRETS OR ANY PATENTS BY SUN RPC
 * OR ANY PART THEREOF.
 *
 * In no event will Sun Microsystems, Inc. be liable for any lost revenue
 * or profits or other special, indirect and consequential damages, even if
 * Sun has been advised of the possibility of such damages.
 *
 * Sun Microsystems, Inc.
 * 2550 Garcia Avenue
 * Mountain View, California  94043
 */
/*
 * Copyright (c) 1987, 1990 by Sun Microsystems, Inc.
 */

/* from @(#)nfs_prot.x	1.3 91/03/11 TIRPC 1.0 */
#ifndef _rpcsvc_nfs_prot_h
#define _rpcsvc_nfs_prot_h
#define NFS_PORT 2049
#define NFS_MAXDATA 8192
#define NFS_MAXPATHLEN 1024
#define NFS_MAXNAMLEN 255
#define NFS_FHSIZE 32
#define NFS_COOKIESIZE 4
#define NFS_FIFO_DEV -1
#define NFSMODE_FMT 0170000
#define NFSMODE_DIR 0040000
#define NFSMODE_CHR 0020000
#define NFSMODE_BLK 0060000
#define NFSMODE_REG 0100000
#define NFSMODE_LNK 0120000
#define NFSMODE_SOCK 0140000
#define NFSMODE_FIFO 0010000

enum nfsstat {
	NFS_OK = 0,
	NFSERR_PERM = 1,
	NFSERR_NOENT = 2,
	NFSERR_IO = 5,
	NFSERR_NXIO = 6,
	NFSERR_ACCES = 13,
	NFSERR_EXIST = 17,
	NFSERR_NODEV = 19,
	NFSERR_NOTDIR = 20,
	NFSERR_ISDIR = 21,
	NFSERR_INVAL = 22,
	NFSERR_FBIG = 27,
	NFSERR_NOSPC = 28,
	NFSERR_ROFS = 30,
	NFSERR_NAMETOOLONG = 63,
	NFSERR_NOTEMPTY = 66,
	NFSERR_DQUOT = 69,
	NFSERR_STALE = 70,
	NFSERR_WFLUSH = 99,
};
typedef enum nfsstat nfsstat;
#ifdef __cplusplus
extern "C" bool_t xdr_nfsstat(XDR *, nfsstat*);
#elif __STDC__
extern  bool_t xdr_nfsstat(XDR *, nfsstat*);
#else /* Old Style C */
bool_t xdr_nfsstat();
#endif /* Old Style C */


enum ftype {
	NFNON = 0,
	NFREG = 1,
	NFDIR = 2,
	NFBLK = 3,
	NFCHR = 4,
	NFLNK = 5,
	NFSOCK = 6,
	NFBAD = 7,
	NFFIFO = 8,
};
typedef enum ftype ftype;
#ifdef __cplusplus
extern "C" bool_t xdr_ftype(XDR *, ftype*);
#elif __STDC__
extern  bool_t xdr_ftype(XDR *, ftype*);
#else /* Old Style C */
bool_t xdr_ftype();
#endif /* Old Style C */


struct nfs_fh {
	char data[NFS_FHSIZE];
};
typedef struct nfs_fh nfs_fh;
#ifdef __cplusplus
extern "C" bool_t xdr_nfs_fh(XDR *, nfs_fh*);
#elif __STDC__
extern  bool_t xdr_nfs_fh(XDR *, nfs_fh*);
#else /* Old Style C */
bool_t xdr_nfs_fh();
#endif /* Old Style C */


struct nfstime {
	u_int seconds;
	u_int useconds;
};
typedef struct nfstime nfstime;
#ifdef __cplusplus
extern "C" bool_t xdr_nfstime(XDR *, nfstime*);
#elif __STDC__
extern  bool_t xdr_nfstime(XDR *, nfstime*);
#else /* Old Style C */
bool_t xdr_nfstime();
#endif /* Old Style C */


struct fattr {
	ftype type;
	u_int mode;
	u_int nlink;
	u_int uid;
	u_int gid;
	u_int size;
	u_int blocksize;
	u_int rdev;
	u_int blocks;
	u_int fsid;
	u_int fileid;
	nfstime atime;
	nfstime mtime;
	nfstime ctime;
};
typedef struct fattr fattr;
#ifdef __cplusplus
extern "C" bool_t xdr_fattr(XDR *, fattr*);
#elif __STDC__
extern  bool_t xdr_fattr(XDR *, fattr*);
#else /* Old Style C */
bool_t xdr_fattr();
#endif /* Old Style C */


struct sattr {
	u_int mode;
	u_int uid;
	u_int gid;
	u_int size;
	nfstime atime;
	nfstime mtime;
};
typedef struct sattr sattr;
#ifdef __cplusplus
extern "C" bool_t xdr_sattr(XDR *, sattr*);
#elif __STDC__
extern  bool_t xdr_sattr(XDR *, sattr*);
#else /* Old Style C */
bool_t xdr_sattr();
#endif /* Old Style C */


typedef char *filename;
#ifdef __cplusplus
extern "C" bool_t xdr_filename(XDR *, filename*);
#elif __STDC__
extern  bool_t xdr_filename(XDR *, filename*);
#else /* Old Style C */
bool_t xdr_filename();
#endif /* Old Style C */


typedef char *nfspath;
#ifdef __cplusplus
extern "C" bool_t xdr_nfspath(XDR *, nfspath*);
#elif __STDC__
extern  bool_t xdr_nfspath(XDR *, nfspath*);
#else /* Old Style C */
bool_t xdr_nfspath();
#endif /* Old Style C */


struct attrstat {
	nfsstat status;
	union {
		fattr attributes;
	} attrstat_u;
};
typedef struct attrstat attrstat;
#ifdef __cplusplus
extern "C" bool_t xdr_attrstat(XDR *, attrstat*);
#elif __STDC__
extern  bool_t xdr_attrstat(XDR *, attrstat*);
#else /* Old Style C */
bool_t xdr_attrstat();
#endif /* Old Style C */


struct sattrargs {
	nfs_fh file;
	sattr attributes;
};
typedef struct sattrargs sattrargs;
#ifdef __cplusplus
extern "C" bool_t xdr_sattrargs(XDR *, sattrargs*);
#elif __STDC__
extern  bool_t xdr_sattrargs(XDR *, sattrargs*);
#else /* Old Style C */
bool_t xdr_sattrargs();
#endif /* Old Style C */


struct diropargs {
	nfs_fh dir;
	filename name;
};
typedef struct diropargs diropargs;
#ifdef __cplusplus
extern "C" bool_t xdr_diropargs(XDR *, diropargs*);
#elif __STDC__
extern  bool_t xdr_diropargs(XDR *, diropargs*);
#else /* Old Style C */
bool_t xdr_diropargs();
#endif /* Old Style C */


struct diropokres {
	nfs_fh file;
	fattr attributes;
};
typedef struct diropokres diropokres;
#ifdef __cplusplus
extern "C" bool_t xdr_diropokres(XDR *, diropokres*);
#elif __STDC__
extern  bool_t xdr_diropokres(XDR *, diropokres*);
#else /* Old Style C */
bool_t xdr_diropokres();
#endif /* Old Style C */


struct diropres {
	nfsstat status;
	union {
		diropokres diropres;
	} diropres_u;
};
typedef struct diropres diropres;
#ifdef __cplusplus
extern "C" bool_t xdr_diropres(XDR *, diropres*);
#elif __STDC__
extern  bool_t xdr_diropres(XDR *, diropres*);
#else /* Old Style C */
bool_t xdr_diropres();
#endif /* Old Style C */


struct readlinkres {
	nfsstat status;
	union {
		nfspath data;
	} readlinkres_u;
};
typedef struct readlinkres readlinkres;
#ifdef __cplusplus
extern "C" bool_t xdr_readlinkres(XDR *, readlinkres*);
#elif __STDC__
extern  bool_t xdr_readlinkres(XDR *, readlinkres*);
#else /* Old Style C */
bool_t xdr_readlinkres();
#endif /* Old Style C */


struct readargs {
	nfs_fh file;
	u_int offset;
	u_int count;
	u_int totalcount;
};
typedef struct readargs readargs;
#ifdef __cplusplus
extern "C" bool_t xdr_readargs(XDR *, readargs*);
#elif __STDC__
extern  bool_t xdr_readargs(XDR *, readargs*);
#else /* Old Style C */
bool_t xdr_readargs();
#endif /* Old Style C */


struct readokres {
	fattr attributes;
	struct {
		u_int data_len;
		char *data_val;
	} data;
};
typedef struct readokres readokres;
#ifdef __cplusplus
extern "C" bool_t xdr_readokres(XDR *, readokres*);
#elif __STDC__
extern  bool_t xdr_readokres(XDR *, readokres*);
#else /* Old Style C */
bool_t xdr_readokres();
#endif /* Old Style C */


struct readres {
	nfsstat status;
	union {
		readokres reply;
	} readres_u;
};
typedef struct readres readres;
#ifdef __cplusplus
extern "C" bool_t xdr_readres(XDR *, readres*);
#elif __STDC__
extern  bool_t xdr_readres(XDR *, readres*);
#else /* Old Style C */
bool_t xdr_readres();
#endif /* Old Style C */


struct writeargs {
	nfs_fh file;
	u_int beginoffset;
	u_int offset;
	u_int totalcount;
	struct {
		u_int data_len;
		char *data_val;
	} data;
};
typedef struct writeargs writeargs;
#ifdef __cplusplus
extern "C" bool_t xdr_writeargs(XDR *, writeargs*);
#elif __STDC__
extern  bool_t xdr_writeargs(XDR *, writeargs*);
#else /* Old Style C */
bool_t xdr_writeargs();
#endif /* Old Style C */


struct createargs {
	diropargs where;
	sattr attributes;
};
typedef struct createargs createargs;
#ifdef __cplusplus
extern "C" bool_t xdr_createargs(XDR *, createargs*);
#elif __STDC__
extern  bool_t xdr_createargs(XDR *, createargs*);
#else /* Old Style C */
bool_t xdr_createargs();
#endif /* Old Style C */


struct renameargs {
	diropargs from;
	diropargs to;
};
typedef struct renameargs renameargs;
#ifdef __cplusplus
extern "C" bool_t xdr_renameargs(XDR *, renameargs*);
#elif __STDC__
extern  bool_t xdr_renameargs(XDR *, renameargs*);
#else /* Old Style C */
bool_t xdr_renameargs();
#endif /* Old Style C */


struct linkargs {
	nfs_fh from;
	diropargs to;
};
typedef struct linkargs linkargs;
#ifdef __cplusplus
extern "C" bool_t xdr_linkargs(XDR *, linkargs*);
#elif __STDC__
extern  bool_t xdr_linkargs(XDR *, linkargs*);
#else /* Old Style C */
bool_t xdr_linkargs();
#endif /* Old Style C */


struct symlinkargs {
	diropargs from;
	nfspath to;
	sattr attributes;
};
typedef struct symlinkargs symlinkargs;
#ifdef __cplusplus
extern "C" bool_t xdr_symlinkargs(XDR *, symlinkargs*);
#elif __STDC__
extern  bool_t xdr_symlinkargs(XDR *, symlinkargs*);
#else /* Old Style C */
bool_t xdr_symlinkargs();
#endif /* Old Style C */


typedef char nfscookie[NFS_COOKIESIZE];
#ifdef __cplusplus
extern "C" bool_t xdr_nfscookie(XDR *, nfscookie);
#elif __STDC__
extern  bool_t xdr_nfscookie(XDR *, nfscookie);
#else /* Old Style C */
bool_t xdr_nfscookie();
#endif /* Old Style C */


struct readdirargs {
	nfs_fh dir;
	nfscookie cookie;
	u_int count;
};
typedef struct readdirargs readdirargs;
#ifdef __cplusplus
extern "C" bool_t xdr_readdirargs(XDR *, readdirargs*);
#elif __STDC__
extern  bool_t xdr_readdirargs(XDR *, readdirargs*);
#else /* Old Style C */
bool_t xdr_readdirargs();
#endif /* Old Style C */


struct entry {
	u_int fileid;
	filename name;
	nfscookie cookie;
	struct entry *nextentry;
};
typedef struct entry entry;
#ifdef __cplusplus
extern "C" bool_t xdr_entry(XDR *, entry*);
#elif __STDC__
extern  bool_t xdr_entry(XDR *, entry*);
#else /* Old Style C */
bool_t xdr_entry();
#endif /* Old Style C */


struct dirlist {
	entry *entries;
	bool_t eof;
};
typedef struct dirlist dirlist;
#ifdef __cplusplus
extern "C" bool_t xdr_dirlist(XDR *, dirlist*);
#elif __STDC__
extern  bool_t xdr_dirlist(XDR *, dirlist*);
#else /* Old Style C */
bool_t xdr_dirlist();
#endif /* Old Style C */


struct readdirres {
	nfsstat status;
	union {
		dirlist reply;
	} readdirres_u;
};
typedef struct readdirres readdirres;
#ifdef __cplusplus
extern "C" bool_t xdr_readdirres(XDR *, readdirres*);
#elif __STDC__
extern  bool_t xdr_readdirres(XDR *, readdirres*);
#else /* Old Style C */
bool_t xdr_readdirres();
#endif /* Old Style C */


struct statfsokres {
	u_int tsize;
	u_int bsize;
	u_int blocks;
	u_int bfree;
	u_int bavail;
};
typedef struct statfsokres statfsokres;
#ifdef __cplusplus
extern "C" bool_t xdr_statfsokres(XDR *, statfsokres*);
#elif __STDC__
extern  bool_t xdr_statfsokres(XDR *, statfsokres*);
#else /* Old Style C */
bool_t xdr_statfsokres();
#endif /* Old Style C */


struct statfsres {
	nfsstat status;
	union {
		statfsokres reply;
	} statfsres_u;
};
typedef struct statfsres statfsres;
#ifdef __cplusplus
extern "C" bool_t xdr_statfsres(XDR *, statfsres*);
#elif __STDC__
extern  bool_t xdr_statfsres(XDR *, statfsres*);
#else /* Old Style C */
bool_t xdr_statfsres();
#endif /* Old Style C */

#endif /*!_rpcsvc_nfs_prot_h*/

#define NFS_PROGRAM ((u_long)100003)
#define NFS_VERSION ((u_long)2)

#ifdef __cplusplus
#define NFSPROC_NULL ((u_long)0)
extern "C" void * nfsproc_null_2(void *, CLIENT *);
extern "C" void * nfsproc_null_2_svc(void *, struct svc_req *);
#define NFSPROC_GETATTR ((u_long)1)
extern "C" attrstat * nfsproc_getattr_2(nfs_fh *, CLIENT *);
extern "C" attrstat * nfsproc_getattr_2_svc(nfs_fh *, struct svc_req *);
#define NFSPROC_SETATTR ((u_long)2)
extern "C" attrstat * nfsproc_setattr_2(sattrargs *, CLIENT *);
extern "C" attrstat * nfsproc_setattr_2_svc(sattrargs *, struct svc_req *);
#define NFSPROC_ROOT ((u_long)3)
extern "C" void * nfsproc_root_2(void *, CLIENT *);
extern "C" void * nfsproc_root_2_svc(void *, struct svc_req *);
#define NFSPROC_LOOKUP ((u_long)4)
extern "C" diropres * nfsproc_lookup_2(diropargs *, CLIENT *);
extern "C" diropres * nfsproc_lookup_2_svc(diropargs *, struct svc_req *);
#define NFSPROC_READLINK ((u_long)5)
extern "C" readlinkres * nfsproc_readlink_2(nfs_fh *, CLIENT *);
extern "C" readlinkres * nfsproc_readlink_2_svc(nfs_fh *, struct svc_req *);
#define NFSPROC_READ ((u_long)6)
extern "C" readres * nfsproc_read_2(readargs *, CLIENT *);
extern "C" readres * nfsproc_read_2_svc(readargs *, struct svc_req *);
#define NFSPROC_WRITECACHE ((u_long)7)
extern "C" void * nfsproc_writecache_2(void *, CLIENT *);
extern "C" void * nfsproc_writecache_2_svc(void *, struct svc_req *);
#define NFSPROC_WRITE ((u_long)8)
extern "C" attrstat * nfsproc_write_2(writeargs *, CLIENT *);
extern "C" attrstat * nfsproc_write_2_svc(writeargs *, struct svc_req *);
#define NFSPROC_CREATE ((u_long)9)
extern "C" diropres * nfsproc_create_2(createargs *, CLIENT *);
extern "C" diropres * nfsproc_create_2_svc(createargs *, struct svc_req *);
#define NFSPROC_REMOVE ((u_long)10)
extern "C" nfsstat * nfsproc_remove_2(diropargs *, CLIENT *);
extern "C" nfsstat * nfsproc_remove_2_svc(diropargs *, struct svc_req *);
#define NFSPROC_RENAME ((u_long)11)
extern "C" nfsstat * nfsproc_rename_2(renameargs *, CLIENT *);
extern "C" nfsstat * nfsproc_rename_2_svc(renameargs *, struct svc_req *);
#define NFSPROC_LINK ((u_long)12)
extern "C" nfsstat * nfsproc_link_2(linkargs *, CLIENT *);
extern "C" nfsstat * nfsproc_link_2_svc(linkargs *, struct svc_req *);
#define NFSPROC_SYMLINK ((u_long)13)
extern "C" nfsstat * nfsproc_symlink_2(symlinkargs *, CLIENT *);
extern "C" nfsstat * nfsproc_symlink_2_svc(symlinkargs *, struct svc_req *);
#define NFSPROC_MKDIR ((u_long)14)
extern "C" diropres * nfsproc_mkdir_2(createargs *, CLIENT *);
extern "C" diropres * nfsproc_mkdir_2_svc(createargs *, struct svc_req *);
#define NFSPROC_RMDIR ((u_long)15)
extern "C" nfsstat * nfsproc_rmdir_2(diropargs *, CLIENT *);
extern "C" nfsstat * nfsproc_rmdir_2_svc(diropargs *, struct svc_req *);
#define NFSPROC_READDIR ((u_long)16)
extern "C" readdirres * nfsproc_readdir_2(readdirargs *, CLIENT *);
extern "C" readdirres * nfsproc_readdir_2_svc(readdirargs *, struct svc_req *);
#define NFSPROC_STATFS ((u_long)17)
extern "C" statfsres * nfsproc_statfs_2(nfs_fh *, CLIENT *);
extern "C" statfsres * nfsproc_statfs_2_svc(nfs_fh *, struct svc_req *);

#elif __STDC__
#define NFSPROC_NULL ((u_long)0)
extern  void * nfsproc_null_2(void *, CLIENT *);
extern  void * nfsproc_null_2_svc(void *, struct svc_req *);
#define NFSPROC_GETATTR ((u_long)1)
extern  attrstat * nfsproc_getattr_2(nfs_fh *, CLIENT *);
extern  attrstat * nfsproc_getattr_2_svc(nfs_fh *, struct svc_req *);
#define NFSPROC_SETATTR ((u_long)2)
extern  attrstat * nfsproc_setattr_2(sattrargs *, CLIENT *);
extern  attrstat * nfsproc_setattr_2_svc(sattrargs *, struct svc_req *);
#define NFSPROC_ROOT ((u_long)3)
extern  void * nfsproc_root_2(void *, CLIENT *);
extern  void * nfsproc_root_2_svc(void *, struct svc_req *);
#define NFSPROC_LOOKUP ((u_long)4)
extern  diropres * nfsproc_lookup_2(diropargs *, CLIENT *);
extern  diropres * nfsproc_lookup_2_svc(diropargs *, struct svc_req *);
#define NFSPROC_READLINK ((u_long)5)
extern  readlinkres * nfsproc_readlink_2(nfs_fh *, CLIENT *);
extern  readlinkres * nfsproc_readlink_2_svc(nfs_fh *, struct svc_req *);
#define NFSPROC_READ ((u_long)6)
extern  readres * nfsproc_read_2(readargs *, CLIENT *);
extern  readres * nfsproc_read_2_svc(readargs *, struct svc_req *);
#define NFSPROC_WRITECACHE ((u_long)7)
extern  void * nfsproc_writecache_2(void *, CLIENT *);
extern  void * nfsproc_writecache_2_svc(void *, struct svc_req *);
#define NFSPROC_WRITE ((u_long)8)
extern  attrstat * nfsproc_write_2(writeargs *, CLIENT *);
extern  attrstat * nfsproc_write_2_svc(writeargs *, struct svc_req *);
#define NFSPROC_CREATE ((u_long)9)
extern  diropres * nfsproc_create_2(createargs *, CLIENT *);
extern  diropres * nfsproc_create_2_svc(createargs *, struct svc_req *);
#define NFSPROC_REMOVE ((u_long)10)
extern  nfsstat * nfsproc_remove_2(diropargs *, CLIENT *);
extern  nfsstat * nfsproc_remove_2_svc(diropargs *, struct svc_req *);
#define NFSPROC_RENAME ((u_long)11)
extern  nfsstat * nfsproc_rename_2(renameargs *, CLIENT *);
extern  nfsstat * nfsproc_rename_2_svc(renameargs *, struct svc_req *);
#define NFSPROC_LINK ((u_long)12)
extern  nfsstat * nfsproc_link_2(linkargs *, CLIENT *);
extern  nfsstat * nfsproc_link_2_svc(linkargs *, struct svc_req *);
#define NFSPROC_SYMLINK ((u_long)13)
extern  nfsstat * nfsproc_symlink_2(symlinkargs *, CLIENT *);
extern  nfsstat * nfsproc_symlink_2_svc(symlinkargs *, struct svc_req *);
#define NFSPROC_MKDIR ((u_long)14)
extern  diropres * nfsproc_mkdir_2(createargs *, CLIENT *);
extern  diropres * nfsproc_mkdir_2_svc(createargs *, struct svc_req *);
#define NFSPROC_RMDIR ((u_long)15)
extern  nfsstat * nfsproc_rmdir_2(diropargs *, CLIENT *);
extern  nfsstat * nfsproc_rmdir_2_svc(diropargs *, struct svc_req *);
#define NFSPROC_READDIR ((u_long)16)
extern  readdirres * nfsproc_readdir_2(readdirargs *, CLIENT *);
extern  readdirres * nfsproc_readdir_2_svc(readdirargs *, struct svc_req *);
#define NFSPROC_STATFS ((u_long)17)
extern  statfsres * nfsproc_statfs_2(nfs_fh *, CLIENT *);
extern  statfsres * nfsproc_statfs_2_svc(nfs_fh *, struct svc_req *);

#else /* Old Style C */
#define NFSPROC_NULL ((u_long)0)
extern  void * nfsproc_null_2();
extern  void * nfsproc_null_2_svc();
#define NFSPROC_GETATTR ((u_long)1)
extern  attrstat * nfsproc_getattr_2();
extern  attrstat * nfsproc_getattr_2_svc();
#define NFSPROC_SETATTR ((u_long)2)
extern  attrstat * nfsproc_setattr_2();
extern  attrstat * nfsproc_setattr_2_svc();
#define NFSPROC_ROOT ((u_long)3)
extern  void * nfsproc_root_2();
extern  void * nfsproc_root_2_svc();
#define NFSPROC_LOOKUP ((u_long)4)
extern  diropres * nfsproc_lookup_2();
extern  diropres * nfsproc_lookup_2_svc();
#define NFSPROC_READLINK ((u_long)5)
extern  readlinkres * nfsproc_readlink_2();
extern  readlinkres * nfsproc_readlink_2_svc();
#define NFSPROC_READ ((u_long)6)
extern  readres * nfsproc_read_2();
extern  readres * nfsproc_read_2_svc();
#define NFSPROC_WRITECACHE ((u_long)7)
extern  void * nfsproc_writecache_2();
extern  void * nfsproc_writecache_2_svc();
#define NFSPROC_WRITE ((u_long)8)
extern  attrstat * nfsproc_write_2();
extern  attrstat * nfsproc_write_2_svc();
#define NFSPROC_CREATE ((u_long)9)
extern  diropres * nfsproc_create_2();
extern  diropres * nfsproc_create_2_svc();
#define NFSPROC_REMOVE ((u_long)10)
extern  nfsstat * nfsproc_remove_2();
extern  nfsstat * nfsproc_remove_2_svc();
#define NFSPROC_RENAME ((u_long)11)
extern  nfsstat * nfsproc_rename_2();
extern  nfsstat * nfsproc_rename_2_svc();
#define NFSPROC_LINK ((u_long)12)
extern  nfsstat * nfsproc_link_2();
extern  nfsstat * nfsproc_link_2_svc();
#define NFSPROC_SYMLINK ((u_long)13)
extern  nfsstat * nfsproc_symlink_2();
extern  nfsstat * nfsproc_symlink_2_svc();
#define NFSPROC_MKDIR ((u_long)14)
extern  diropres * nfsproc_mkdir_2();
extern  diropres * nfsproc_mkdir_2_svc();
#define NFSPROC_RMDIR ((u_long)15)
extern  nfsstat * nfsproc_rmdir_2();
extern  nfsstat * nfsproc_rmdir_2_svc();
#define NFSPROC_READDIR ((u_long)16)
extern  readdirres * nfsproc_readdir_2();
extern  readdirres * nfsproc_readdir_2_svc();
#define NFSPROC_STATFS ((u_long)17)
extern  statfsres * nfsproc_statfs_2();
extern  statfsres * nfsproc_statfs_2_svc();
#endif /* Old Style C */

#endif /* !_NFS_H_RPCGEN */