/* nfs_server.c -- NFS RPC server routines.
   Copyright (C) 2006  Casey Marshall <csm@soe.ucsc.edu>
   
This file is a part of Birch.

Birch is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

Birch is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with Birch; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA. */

/*
 * Generated from nfs.x with rpcgen -Ss.
 */

#include "nfs.h"

#import "NFSServer.h"
#import <openssl/md5.h>

#import "Dentry.h"
#import "DentryDirectory.h"
#import "DentryEmptyfile.h"
#import "DentryFile.h"
#import "DentryMetafile.h"
#import "HeapBuffer.h"

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

const char kRootHandle[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

void *
nfsproc_null_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  NSLog(@"NFS NULL");
  return NULL;
}


attrstat *
nfsproc_getattr_2_svc(argp, rqstp)
	nfs_fh *argp;
	struct svc_req *rqstp;
{
  static attrstat  result;

  FileHandle *handle = [FileHandle handleWithBytes: argp->data];

  NSLog(@"NFS GETATTR %@", handle);
	
  if ([handle isEqual: [[DentryDirectory root] handle]])
  {
    NSLog(@"query is for root dir");
    fattr *attr = &(result.attrstat_u.attributes);
    result.status = NFS_OK;
    attr->type = NFDIR;
    attr->mode = NFSMODE_DIR | 0777;
    attr->nlink = 1;
    attr->uid = getuid();
    attr->gid = getgid();
    attr->size = 1;
    attr->blocksize = 1024;
    attr->rdev = 0;
    attr->blocks = 1;
    attr->fsid = 1;
    attr->fileid = [handle hash];
    Dentry *d = [DentryDirectory root];
    NSLog(@"root dentry = %@", d);
    attr->atime.seconds = [[d accessedTime] timeIntervalSince1970];
    attr->atime.useconds = 0;
    attr->ctime.seconds = [[d createdTime] timeIntervalSince1970];
    attr->ctime.useconds = 0;
    attr->mtime.seconds = [[d modifiedTime] timeIntervalSince1970];
    attr->mtime.useconds = 0;    
  }
  else
  {
    Dentry *d = [[NFSServer server] lookup: handle];
    if (d == nil)
    {
      result.status = NFSERR_STALE;
    }
    else if ([d isKindOfClass: [DentryDirectory class]])
    {
      result.status = NFS_OK;
      fattr *attr = &(result.attrstat_u.attributes);
      attr->type = NFDIR;
      attr->mode = NFSMODE_DIR | 0777;
      attr->nlink = 1;
      attr->uid = getuid();
      attr->gid = getgid();
      attr->size = 1;
      attr->blocksize = 1024;
      attr->rdev = 0;
      attr->blocks = 1;
      attr->fsid = 0;
      attr->fileid = [handle hash];
      attr->atime.seconds = [[d accessedTime] timeIntervalSince1970];
      attr->atime.useconds = 0;
      attr->ctime.seconds = [[d createdTime] timeIntervalSince1970];
      attr->ctime.useconds = 0;
      attr->mtime.seconds = [[d modifiedTime] timeIntervalSince1970];
      attr->mtime.useconds = 0;
    }
    else if ([d isKindOfClass: [DentryEmptyfile class]])
    {
      result.status = NFS_OK;
      fattr *attr = &(result.attrstat_u.attributes);
      attr->type = NFREG;
      attr->mode = NFSMODE_REG | 0444;
      attr->nlink = 1;
      attr->uid = getuid();
      attr->gid = getgid();
      attr->size = 0;
      attr->blocksize = 1024;
      attr->rdev = 0;
      attr->blocks = 1;
      attr->fsid = 1;
      attr->fileid = [handle hash];
      attr->atime.seconds = [[d accessedTime] timeIntervalSince1970];
      attr->atime.useconds = 0;
      attr->ctime.seconds = [[d createdTime] timeIntervalSince1970];
      attr->ctime.useconds = 0;
      attr->mtime.seconds = [[d modifiedTime] timeIntervalSince1970];
      attr->mtime.useconds = 0;
    }
    else if ([d isKindOfClass: [DentryMetafile class]])
    {
      result.status = NFS_OK;
      fattr *attr = &(result.attrstat_u.attributes);
      DentryMetafile *file = (DentryMetafile *) d;
      attr->type = NFREG;
      attr->mode = NFSMODE_REG | 0666;
      attr->nlink = 1;
      attr->uid = getuid();
      attr->gid = getgid();
      attr->size = [file size];
      attr->blocksize = 1024;
      attr->rdev = 0;
      attr->blocks = (attr->size + 1023) / 1024;
      attr->fsid = 1;
      attr->fileid = [handle hash];
      attr->atime.seconds = [[d accessedTime] timeIntervalSince1970];
      attr->atime.useconds = 0;
      attr->ctime.seconds = [[d createdTime] timeIntervalSince1970];
      attr->ctime.useconds = 0;
      attr->mtime.seconds = [[d modifiedTime] timeIntervalSince1970];
      attr->mtime.useconds = 0;
    }
    else
    {
      result.status = NFS_OK;
      fattr *attr = &(result.attrstat_u.attributes);
      DentryFile *file = (DentryFile *) d;
      attr->type = NFLNK;
      attr->mode = NFSMODE_LNK | 0444;
      attr->nlink = 1;
      attr->uid = getuid();
      attr->gid = getgid();
      attr->size = [[file realpath] length]; // XXX UTF-8?
      attr->blocksize = 1024;
      attr->rdev = 0;
      attr->blocks = (attr->size + 1023) / 1024;
      attr->fsid = 1;
      attr->fileid = [handle hash];
      attr->atime.seconds = [[d accessedTime] timeIntervalSince1970];
      attr->atime.useconds = 0;
      attr->ctime.seconds = [[d createdTime] timeIntervalSince1970];
      attr->ctime.useconds = 0;
      attr->mtime.seconds = [[d modifiedTime] timeIntervalSince1970];
      attr->mtime.useconds = 0;
    }
  }

  return(&result);
}

attrstat *
nfsproc_setattr_2_svc(argp, rqstp)
	sattrargs *argp;
	struct svc_req *rqstp;
{
  static attrstat result;
  FileHandle *handle = [FileHandle handleWithBytes: argp->file.data];
  NFSServer *srv = [NFSServer server];
  Dentry *dentry = [srv lookup: handle];
  
  NSLog(@"NFS SETATTR %@", handle);
  
  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }

  [dentry access];
  if ([dentry isKindOfClass: [DentryMetafile class]])
  {
    [((DentryMetafile *) dentry) truncate: argp->attributes.size];
  }

  result.status = NFS_OK;
  fattr *attr = &(result.attrstat_u.attributes);
  attr->nlink = 1;
  attr->uid = getuid();
  attr->gid = getgid();
  attr->blocksize = 1024;
  attr->rdev = 0;
  attr->atime.seconds = [[dentry accessedTime] timeIntervalSince1970];
  attr->ctime.seconds = [[dentry createdTime] timeIntervalSince1970];
  attr->mtime.seconds = [[dentry modifiedTime] timeIntervalSince1970];
  if ([dentry isKindOfClass: [DentryDirectory class]])
  {
    attr->type = NFDIR;
    attr->mode = NFSMODE_DIR | 0777;
    attr->size = 1;
    attr->blocks = 1;
  }
  else if ([dentry isKindOfClass: [DentryEmptyfile class]])
  {
    attr->type = NFREG;
    attr->mode = NFSMODE_REG | 0444;
    attr->size = 0;
    attr->blocks = 1;
  }
  else if ([dentry isKindOfClass: [DentryMetafile class]])
  {
    DentryMetafile *m = (DentryMetafile *) dentry;
    attr->type = NFREG;
    attr->mode = NFSMODE_REG | 0666;
    attr->size = [m size];
    attr->blocks = (attr->size + 1023) / 1024;
  }
  else // A file
  {
    DentryFile *f = (DentryFile *) dentry;
    attr->type = NFLNK;
    attr->mode = NFSMODE_LNK | 0666;
    attr->size = [[f realpath] length]; // XXX UTF-8
    attr->blocks = (attr->size + 1023) / 1024;
  }

  return(&result);
}

void *
nfsproc_root_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static char* result = "/Birch";
  NSLog(@"NFS ROOT");
  return((void*) &result);
}

diropres *
nfsproc_lookup_2_svc(argp, rqstp)
	diropargs *argp;
	struct svc_req *rqstp;
{
  static diropres result;
  NSString *name = [NSString stringWithCString: argp->name
		    encoding: NSUTF8StringEncoding];
  NFSServer *srv = [NFSServer server];
  FileHandle *handle = [FileHandle handleWithBytes: argp->dir.data];
  Dentry *dirdentry = [srv lookup: handle];
  FileHandle *target = nil;
    
  if (dirdentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }

  DentryDirectory *dir = nil;
  if ([dirdentry isDir])
  {
    dir = (DentryDirectory *) dirdentry;
  }
  else
  {
    result.status = NFSERR_NOTDIR;
    return &result;
  }

#if DEBUG
  NSLog(@"NFS LOOKUP fh: %@ name: \"%@\"", handle, name);
#endif // DEBUG
  
  Dentry *dentry = nil;
  NSString *fullpath = [NSString stringWithFormat:
    @"%@/%@", [dir path], name];
  if ([name isEqual: @"."])
  {
    dentry = dir;
    target = handle;
  }
  else if ([name isEqual: @".."])
  {
    dentry = [dir parent];
    target = [dentry handle];
  }
  else if ([name isEqual: @".metadata_never_index"])
  {
    target = [FileHandle handleWithPath: fullpath];
    dentry = [srv lookup: target];
    if (dentry == nil)
    {
      DentryEmptyfile *empty = [[DentryEmptyfile alloc]
        initWithName: @".metadata_never_index"
        parent: dir
        handle: target];
      [srv insert: empty];
      dentry = empty;
    }
  }
  else if ([name isEqual: @".DS_Store"] || [name hasPrefix: @"._"])
  {
    target = [FileHandle handleWithPath: fullpath];
    dentry = [srv lookup: target];
    if (dentry == nil)
    {
      result.status = NFSERR_NOENT;
      return &result;
    }
  }
  else
  {
    // The file handle is always the MD5 sum of the full path.
    target = [FileHandle handleWithPath: fullpath];
    dentry = [srv lookup: target];
  }
  NSLog(@"target filehandle for %@ is %@", fullpath, target);
  
  if (dentry == nil)
  {
    NSLog(@"Nothing in dentry cache");
    BirchQuery *q = [srv queryForName: name];
    if (q == nil)
    {
      if ([dir isRoot])
      {
      	result.status = NFSERR_NOENT;
        return &result;
      }
      NSLog(@"looking up file named \"%@\"", name);
      NSPredicate *p = [NSCompoundPredicate andPredicateWithSubpredicates:
        [NSArray arrayWithObjects: [dir buildPredicate],
         [NSPredicate predicateWithFormat: @"kMDItemFSName == %@", name],
         nil]];
      NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
      [query setPredicate: p];
      [query startQuery];
      if ([query isGathering] && [query resultCount] == 0)
      {
        NSLog(@"query %@ is gathering...", [query predicate]);
        [[NSRunLoop currentRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow: 5]];
      }
      if ([query resultCount] == 0)
      {
        result.status = NFSERR_NOENT;
        return &result;
      }
      
      // Just take the first match.
      NSMetadataItem *item = [query resultAtIndex: 0];
      NSString *path = [item valueForAttribute: @"kMDItemPath"];
      DentryFile *file = [[DentryFile alloc] initWithName: name
        parent: dir
        handle: target
        realpath: path];
      dentry = file;
    }
    else
    {
      DentryDirectory *newdir = [[DentryDirectory alloc]
        initWithName: name
        parent: dir
        handle: target
        isLeaf: [q isLeaf]
        predicate: [q predicate]];
      dentry = newdir;
    }
    
    [srv insert: dentry];
  }
  
  NSLog(@"looked up dentry %@", dentry);
  
  memset (&result, 0, sizeof (struct diropres));
  [dentry access];
  result.status = NFS_OK;
  memcpy(result.diropres_u.diropres.file.data, [target handle], NFS_FHSIZE);
  fattr *attr = &(result.diropres_u.diropres.attributes);
  attr->nlink = 1;
  attr->uid = getuid();
  attr->gid = getgid();
  attr->blocksize = 1024;
  attr->rdev = 0;
  attr->atime.seconds = [[dentry accessedTime] timeIntervalSince1970];
  attr->ctime.seconds = [[dentry createdTime] timeIntervalSince1970];
  attr->mtime.seconds = [[dentry modifiedTime] timeIntervalSince1970];
  if ([dentry isKindOfClass: [DentryDirectory class]])
  {
    attr->type = NFDIR;
    attr->mode = NFSMODE_DIR | 0777;
    attr->size = 1;
    attr->blocks = 1;
  }
  else if ([dentry isKindOfClass: [DentryEmptyfile class]])
  {
    attr->type = NFREG;
    attr->mode = NFSMODE_REG | 0444;
    attr->size = 0;
    attr->blocks = 1;
  }
  else if ([dentry isKindOfClass: [DentryMetafile class]])
  {
    DentryMetafile *m = (DentryMetafile *) dentry;
    attr->type = NFREG;
    attr->mode = NFSMODE_REG | 0666;
    attr->size = [m size];
    attr->blocks = (attr->size + 1023) / 1024;
  }
  else // A file
  {
    DentryFile *f = (DentryFile *) dentry;
    attr->type = NFLNK;
    attr->mode = NFSMODE_LNK | 0666;
    attr->size = [[f realpath] length]; // XXX UTF-8
    attr->blocks = (attr->size + 1023) / 1024;
  }
  
  return(&result);
}

readlinkres *
nfsproc_readlink_2_svc(argp, rqstp)
	nfs_fh *argp;
	struct svc_req *rqstp;
{
  static readlinkres  result;

  FileHandle *handle = [FileHandle handleWithBytes: argp->data];
  Dentry *dentry = [[NFSServer server] lookup: handle];
  
  NSLog(@"NFS READLINK %@", handle);
  
  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
  }
  else if ([dentry isKindOfClass: [DentryDirectory class]])
  {
    result.status = NFSERR_ISDIR;
  }
  else if ([dentry isKindOfClass: [DentryFile class]])
  {
    DentryFile *file = (DentryFile *) dentry;
    result.readlinkres_u.data = [[file realpath] UTF8String];
  }
  else // Not a symbolic link.
  {
    result.status = NFSERR_INVAL;
  }

  return(&result);
}

readres *
nfsproc_read_2_svc(argp, rqstp)
	readargs *argp;
	struct svc_req *rqstp;
{
  static readres  result;
  static char databuf[1024];

  FileHandle *handle = [FileHandle handleWithBytes: argp->file.data];
  NFSServer *srv = [NFSServer server];
  Dentry *dentry = [srv lookup: handle];

  NSLog(@"NFS READ %@", handle);
  
  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }
  
  if ([dentry isDir])
  {
    result.status = NFSERR_ISDIR;
    return &result;
  }
  else if ([dentry isKindOfClass: [DentryFile class]])
  {
    // Can you read from a symlink?
    result.status = NFSERR_INVAL;
    return &result;
  }
  
  [dentry access];
  if ([dentry isKindOfClass: [DentryEmptyfile class]])
  {
    if (argp->offset != 0)
    {
      result.status = NFSERR_INVAL;
      return &result;
    }
    
    result.status = NFS_OK;
    readokres *okres = &(result.readres_u.reply);
    fattr *attr = &(result.readres_u.reply.attributes);
    attr->type = NFREG;
    attr->mode = NFSMODE_REG | 0444;
    attr->nlink = 1;
    attr->uid = getuid();
    attr->gid = getgid();
    attr->size = 0;
    attr->blocksize = 1024;
    attr->rdev = 0;
    attr->blocks = 1;
    attr->fsid = 1;
    attr->fileid = [handle hash];
    attr->atime.seconds = [[dentry accessedTime] timeIntervalSince1970];
    attr->atime.useconds = 0;
    attr->ctime.seconds = [[dentry createdTime] timeIntervalSince1970];
    attr->ctime.useconds = 0;
    attr->mtime.seconds = [[dentry modifiedTime] timeIntervalSince1970];
    attr->mtime.useconds = 0;
    
    okres->data.data_len = 0;
    okres->data.data_val = databuf;
    
    return &result;
  }
  
  DentryMetafile *mfile = (DentryMetafile *) dentry;
  result.status = NFS_OK;
  readokres *okres = &(result.readres_u.reply);
  fattr *attr = &(result.readres_u.reply.attributes);

  int len = sizeof(databuf);
  if (len > argp->count)
    len = argp->count;
  okres->data.data_len = [mfile readData: databuf atOffset: argp->offset length: len];
  okres->data.data_val = databuf;

  attr->type = NFREG;
  attr->mode = NFSMODE_REG | 0666;
  attr->nlink = 1;
  attr->uid = getuid();
  attr->gid = getgid();
  attr->size = [mfile size];
  attr->blocksize = 1024;
  attr->rdev = 0;
  attr->blocks = (attr->size + 1023) / 1024;
  attr->fsid = 1;
  attr->fileid = [handle hash];
  attr->atime.seconds = [[dentry accessedTime] timeIntervalSince1970];
  attr->atime.useconds = 0;
  attr->ctime.seconds = [[dentry createdTime] timeIntervalSince1970];
  attr->ctime.useconds = 0;
  attr->mtime.seconds = [[dentry modifiedTime] timeIntervalSince1970];
  attr->mtime.useconds = 0;

  return(&result);
}

void *
nfsproc_writecache_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static char* result;
  NSLog(@"NFS WRITECACHE");
  return((void*) &result);
}

attrstat *
nfsproc_write_2_svc(argp, rqstp)
	writeargs *argp;
	struct svc_req *rqstp;
{
  static attrstat result;
  FileHandle *handle = [FileHandle handleWithBytes: argp->file.data];
  NFSServer *srv = [NFSServer server];
  Dentry *dentry = [srv lookup: handle];
  NSLog(@"NFS WRITE %@", handle);
  
  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }
  
  if ([dentry isDir])
  {
    result.status = NFSERR_ISDIR;
    return &result;
  }
  else if (![dentry isKindOfClass: [DentryMetafile class]])
  {
    result.status = NFSERR_PERM; // XXX suck a fuck
    return &result;
  }
  
  DentryMetafile *mfile = (DentryMetafile *) dentry;
  [mfile writeData: [NSData dataWithBytesNoCopy: argp->data.data_val
                     length: argp->data.data_len
                     freeWhenDone: NO] atOffset: argp->offset];
  [mfile access];
  [mfile modify];
           
  result.status = NFS_OK;
  fattr *attr = &(result.attrstat_u.attributes);
  attr->type = NFREG;
  attr->mode = NFSMODE_REG | 0666;
  attr->nlink = 1;
  attr->uid = getuid();
  attr->gid = getgid();
  attr->size = [mfile size];
  attr->blocksize = 1024;
  attr->rdev = 0;
  attr->blocks = (attr->size + 1023) / 1024;
  attr->fsid = 1;
  attr->fileid = [[mfile handle] hash];
  attr->atime.seconds = [[mfile accessedTime] timeIntervalSince1970];
  attr->atime.useconds = 0;
  attr->mtime.seconds = [[mfile modifiedTime] timeIntervalSince1970];
  attr->mtime.useconds = 0;
  attr->ctime.seconds = [[mfile createdTime] timeIntervalSince1970];
  attr->ctime.useconds = 0;
  return(&result);
}

diropres *
nfsproc_create_2_svc(argp, rqstp)
	createargs *argp;
	struct svc_req *rqstp;
{
  static diropres result;
  FileHandle *handle = [FileHandle handleWithBytes: argp->where.dir.data];
  NFSServer *srv = [NFSServer server];
  NSString *name = [NSString stringWithUTF8String: argp->where.name];
  Dentry *dentry = [srv lookup: handle];

#if DEBUG
  NSLog(@"NFS CREATE where:%@ name:%@", handle, name);
#endif // DEBUG

  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }
  
  if (![dentry isDir])
  {
    result.status = NFSERR_NOTDIR;
    return &result;
  }
  DentryDirectory *dir = (DentryDirectory *) dentry;
  
  FileHandle *target = [FileHandle handleWithPath:
    [NSString stringWithFormat: @"%@/%@", [dir path], name]];
  Dentry *targetDentry = [srv lookup: target];
  if (targetDentry != nil)
  {
    result.status = NFSERR_EXIST;
  }
  else
  {
    DentryMetafile *newfile = [[DentryMetafile alloc]
      initWithName: name
      parent: dir
      handle: target];
    [newfile autorelease];
    [srv insert: newfile];
    result.status = NFS_OK;
    
    diropokres *ok = &(result.diropres_u.diropres);
    memcpy (ok->file.data, [target handle], 32);
    fattr *attr = &(ok->attributes);
    attr->type = NFREG;
    attr->mode = NFSMODE_REG | 0666;
    attr->nlink = 1;
    attr->uid = getuid();
    attr->gid = getgid();
    attr->size = [newfile size];
    attr->blocksize = 1024;
    attr->rdev = 0;
    attr->blocks = (attr->size + 1023) / 1024;
    attr->fsid = 1;
    attr->fileid = [target hash];
    attr->atime.seconds = [[newfile accessedTime] timeIntervalSince1970];
    attr->atime.useconds = 0;
    attr->mtime.seconds = [[newfile modifiedTime] timeIntervalSince1970];
    attr->mtime.useconds = 0;
    attr->ctime.seconds = [[newfile createdTime] timeIntervalSince1970];
    attr->ctime.useconds = 0;    
  }

  return(&result);
}

nfsstat *
nfsproc_remove_2_svc(argp, rqstp)
	diropargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result;
  FileHandle *handle = [FileHandle handleWithBytes: argp->dir.data];
  NFSServer *srv = [NFSServer server];
  Dentry *dentry = [srv lookup: handle];
  NSString *name = [NSString stringWithUTF8String: argp->name];

#if DEBUG
  NSLog(@"NFS REMOVE fh:%@ name:%@", handle, name);
#endif // DEBUG
  
  if (dentry == nil)
  {
    result = NFSERR_STALE;
    return &result;
  }
  if (![dentry isDir])
  {
    result = NFSERR_NOTDIR;
    return &result;
  }
  
  NSString *fullpath = [NSString stringWithFormat: @"%@/%@", [dentry path], name];
  FileHandle *target = [FileHandle handleWithPath: fullpath];
  Dentry *toRemove = [srv lookup: target];
  if (toRemove == nil)
  {
    // Probably not OK, because you may be trying to remove a match file.
    // But whatever.
    result = NFS_OK;
    return &result;
  }
  
  if ([toRemove isKindOfClass: [DentryMetafile class]])
  {
    [srv remove: target];
    [toRemove release]; // clear self-retain.
    result = NFS_OK;
  }
  else
  {
    result = NFSERR_PERM;
  }

  return(&result);
}

nfsstat *
nfsproc_rename_2_svc(argp, rqstp)
	renameargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result;
  FileHandle *handleFrom = [FileHandle handleWithBytes: argp->from.dir.data];
  FileHandle *handleTo = [FileHandle handleWithBytes: argp->to.dir.data];
  NFSServer *srv = [NFSServer server];
  Dentry *dentryFrom = [srv lookup: handleFrom];
  Dentry *dentryTo = [srv lookup: handleTo];
  NSString *nameFrom = [NSString stringWithUTF8String: argp->from.name];
  NSString *nameTo = [NSString stringWithUTF8String: argp->to.name];

#if DEBUG
  NSLog(@"NFS RENAME (from fh:%@ name:%@) (to fh:%@ name:%@)", handleFrom,
        nameFrom, handleTo, nameTo);
#endif // DEBUG
  
  if (dentryFrom == nil || dentryTo == nil)
  {
    result = NFSERR_STALE;
    return &result;
  }
  if (![dentryFrom isDir] || ![dentryTo isDir])
  {
    result = NFSERR_NOTDIR;
    return &result;
  }
  
  NSString *fullpathFrom = [NSString stringWithFormat: @"%@/%@",
    [dentryFrom path], nameFrom];
  NSString *fullpathTo = [NSString stringWithFormat: @"%@/%@",
    [dentryTo path], nameTo];
  FileHandle *targetFrom = [FileHandle handleWithPath: fullpathFrom];
  FileHandle *targetTo = [FileHandle handleWithPath: fullpathTo];
  Dentry *toRemove = [srv lookup: target];
  if (toRemove == nil)
  {
    // Probably not OK, because you may be trying to remove a match file.
    // But whatever.
    result = NFS_OK;
    return &result;
  }
  
  if ([toRemove isKindOfClass: [DentryMetafile class]])
  {
    [srv remove: target];
    [toRemove release]; // clear self-retain.
    result = NFS_OK;
  }
  else
  {
    result = NFSERR_PERM;
  }

  // XXX Allow rename of directories.
  NSLog(@"NFS RENAME");

  return(&result);
}

nfsstat *
nfsproc_link_2_svc(argp, rqstp)
	linkargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result = NFSERR_INVAL;
  NSLog(@"NFS LINK");
  return(&result);
}

nfsstat *
nfsproc_symlink_2_svc(argp, rqstp)
	symlinkargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result = NFSERR_INVAL;
  NSLog(@"NFS SYMLINK");
  return(&result);
}

diropres *
nfsproc_mkdir_2_svc(argp, rqstp)
	createargs *argp;
	struct svc_req *rqstp;
{
  static diropres result;
  FileHandle *handle = [FileHandle handleWithBytes: argp->where.dir.data];
  NFSServer *srv = [NFSServer server];
  Dentry *dentry = [srv lookup: handle];
  NSString *name = [NSString stringWithUTF8String: argp->where.name];
  
  NSLog(@"NFS MKDIR handle:%@ name:%@", handle, name);

  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }
  
  if (![dentry isDir])
  {
    result.status = NFSERR_NOTDIR;
    return &result;
  }

  [srv addQueryWithName: name toDir: [dentry name]];
  
  result.status = NFS_OK;
  return(&result);
}

nfsstat *
nfsproc_rmdir_2_svc(argp, rqstp)
	diropargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result = NFSERR_PERM;
  NSLog(@"NFS RMDIR");
  return(&result);
}

#define NUM_SPECIALS 3

readdirres *
nfsproc_readdir_2_svc(argp, rqstp)
	readdirargs *argp;
	struct svc_req *rqstp;
{
  static readdirres  result;
  int i;
  int cookie = *((int *) (argp->cookie));
  NFSServer *srv = [NFSServer server];
  FileHandle *handle = [FileHandle handleWithBytes: argp->dir.data];
  Dentry *dentry = [srv lookup: handle];
  entry *current = NULL;
  entry *bottom = NULL;
  
  NSLog(@"NFS READDIR handle: %@ count: %d cookie: %x", handle, argp->count,
        cookie);
  
  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
    return &result;
  }
  if (![dentry isDir])
  {
    result.status = NFSERR_NOTDIR;
    return &result;
  }
  [dentry access];
  
  DentryDirectory *dir = (DentryDirectory *) dentry;
  RunningQuery *query = [srv runningQueryForHandle: handle];

  if (query == nil)
  {
    NSPredicate *pred = nil;
    bool isLeaf = [((DentryDirectory *) dentry) isLeaf];
    if (isLeaf)
    {
      pred = [((DentryDirectory *) dentry) buildPredicate];
    }
    BirchQuery *q = [srv queryForName: [dentry name]];
    query = [[RunningQuery alloc] initWithCookie: cookie query: q
	     predicate: pred];
    [srv insertRunningQuery: query forHandle: handle];
    [query autorelease];
  }
  NSString *pwd = [dentry path];

  [query setListingMode: (cookie & LISTING_MODE_MASK)];
  int cookieIndex = (cookie & ~LISTING_MODE_MASK);
  if ([query listingMode] != LISTING_MODE_DIRS || cookieIndex != 0)
    cookieIndex++;
  [query setIndex: cookieIndex];
  
  result.readdirres_u.reply.eof = NO;
  bool updatedQuery = NO;
  bool gaveUp = NO;
  for (i = 0; i < argp->count; )
  {
    NSLog(@"i:%d", i);
    if ([query listingMode] == LISTING_MODE_DIRS)
    {
      int idx = [query index];
      NSLog(@"DIRS idx:%d", idx);
      if (idx == 0)
      {
        entry *e = (entry *) malloc (sizeof (struct entry));
        e->fileid = [[FileHandle handleWithPath:
          [NSString stringWithFormat: @"%@/.", pwd]] hash];
        e->name = ".";
        *((int *) e->cookie) = idx;
        e->nextentry = NULL;
        if (current == NULL)
        {
          current = e;
          bottom = current;
        }
        else
        {
          current->nextentry = e;
          current = e;
        }
        [NSData dataWithBytesNoCopy: e
         length: sizeof(entry)
         freeWhenDone: YES];
        idx++;
        [query setIndex: idx];
        NSLog(@"    READDIR . (DIR)");
        i += 1;
        continue;
      }
      if (idx == 1)
      {
        entry *e = (entry *) malloc (sizeof (struct entry));
        e->fileid = [[FileHandle handleWithPath:
          [NSString stringWithFormat: @"%@/..", pwd]] hash];
        e->name = "..";
        *((int *) e->cookie) = idx;
        e->nextentry = NULL;
        if (current == NULL)
        {
          current = e;
          bottom = current;
        }
        else
        {
          current->nextentry = e;
          current = e;
        }
        [NSData dataWithBytesNoCopy: e
         length: sizeof(entry)
         freeWhenDone: YES];
        idx++;
        [query setIndex: idx];
        NSLog(@"    READDIR .. (DIR)");
        i += 2;
        continue;
      }
      if (idx == 2)
      {
        entry *e = (entry *) malloc (sizeof (struct entry));
        e->fileid = [[FileHandle handleWithPath:
          [NSString stringWithFormat: @"%@/.metadata_never_index", pwd]] hash];
        e->name = ".metadata_never_index";
        *((int *) e->cookie) = idx;
        e->nextentry = NULL;
        if (current == NULL)
        {
          current = e;
          bottom = current;
        }
        else
        {
          current->nextentry = e;
          current = e;
        }
        [NSData dataWithBytesNoCopy: e
         length: sizeof(entry)
         freeWhenDone: YES];
        idx++;
        [query setIndex: idx];
        NSLog(@"    READDIR .metadata_never_index (EFILE)");
        i += strlen(".metadata_never_index");
        continue;
      }

      NSArray *subordinates = [[query queryInfo] subordinates];
      NSLog(@"looking at subordintes %@", subordinates);
      if ((idx - NUM_SPECIALS) >= [subordinates count])
      {
        [query setListingMode: LISTING_MODE_METAFILES];
        [query setIndex: 0];
      }
      else
      {
        NSString *name = [subordinates objectAtIndex: (idx - NUM_SPECIALS)];
        entry *e = (entry *) malloc (sizeof (struct entry));
        e->fileid = [[FileHandle handleWithPath: [NSString stringWithFormat: @"%@/%@", pwd, name]] hash];
        e->name = [name UTF8String];
        *((int *) e->cookie) = idx;
        e->nextentry = NULL;
        if (current == NULL)
        {
          current = e;
          bottom = current;
        }
        else
        {
          current->nextentry = e;
          current = e;
        }
        [NSData dataWithBytesNoCopy: e
         length: sizeof(entry)
         freeWhenDone: YES];
        idx++;
        [query setIndex: idx];
        NSLog(@"    READDIR %@ (DIR)", name);
        i += strlen(e->name);
      }
    }
    else if ([query listingMode] == LISTING_MODE_METAFILES)
    {
      int idx = [query index];
      NSArray *metafiles = [dir metafiles];
      if (idx >= [metafiles count])
      {
        if ([query query] == nil) // not leaf
        {
          result.readdirres_u.reply.eof = YES;
          break;
        }
        [query setListingMode: LISTING_MODE_FILES];
        [query setIndex: 0];        
      }
      else
      {
        NSString *name = [metafiles objectAtIndex: idx];
        entry *e = (entry *) malloc (sizeof (struct entry));
        e->fileid = [[FileHandle handleWithPath: [NSString stringWithFormat: @"%@/%@", pwd, name]] hash];
        e->name = [name UTF8String];
        *((int *) e->cookie) = idx;
        e->nextentry = NULL;
        if (current == NULL)
        {
          current = e;
          bottom = current;
        }
        else
        {
          current->nextentry = e;
          current = e;
        }
        [NSData dataWithBytesNoCopy: e
         length: sizeof(entry)
         freeWhenDone: YES];
        idx++;
        [query setIndex: idx];
#if DEBUG
        NSLog(@"    READDIR %@ (REG)", name);
#endif // DEBUG
        i += strlen(e->name);
      }
    }
    else
    {
      //NSLog(@"listing query matches...");
      NSMetadataQuery *mdq = [query query];
      gaveUp = [query shouldGiveUp];
      if (!gaveUp && [mdq isGathering] && !updatedQuery)
      {
#if DEBUG
        NSLog(@"query is gathering; running NSRunLoop...");
#endif // DEBUG
        [[NSRunLoop currentRunLoop] runUntilDate:
          [NSDate dateWithTimeIntervalSinceNow: 1]];
#if DEBUG
        NSLog(@"we have %d maches for %@", [mdq resultCount], [mdq predicate]);
#endif // DEBUG
        updatedQuery = YES;
        [query loop];
      }

      int idx = [query index];
#if DEBUG
      NSLog(@"FILES:%d", idx);
#endif // DEBUG
      //NSLog(@"idx is now %d of a possible", idx, [mdq resultCount]);
      if (idx >= [mdq resultCount])
      {
        if (![mdq isGathering] || gaveUp)
          result.readdirres_u.reply.eof = YES;
        break;
      }
      else
      {
        NSMetadataItem *item = [mdq resultAtIndex: idx];
        NSString *realpath = [item valueForAttribute: @"kMDItemPath"];
        NSString *name = [realpath lastPathComponent];
        NSString *mypath = [NSString stringWithFormat: @"%@/%@", pwd, name];
        FileHandle *filehandle = [FileHandle handleWithPath: mypath];
                
        // Bleah.
        //NSLog(@"DentryFile initWithName: %@ parent: %@ handle: %@ realpath: %@",
        //      name, dentry, filehandle, realpath);
        Dentry *existing = [srv lookup: filehandle];
        if (existing == nil)
        {
          DentryFile *newfile = [[DentryFile alloc] initWithName: name
            parent: dentry
            handle: filehandle
            realpath: realpath];
          [newfile autorelease];
          //NSLog(@"created file dentry %@", newfile);
          [srv insert: newfile];
        }
        else if ([dentry isDir])
        {
          // We know we already listed this.
          continue;
        }
        
        entry *e = (entry *) malloc (sizeof (struct entry));
        e->fileid = [filehandle hash];
        e->name = [name UTF8String];
        *((int *) e->cookie) = 0x80000000 | idx;
        e->nextentry = NULL;
        if (current == NULL)
        {
          current = e;
          bottom = current;
        }
        else
        {
          current->nextentry = e;
          current = e;
        }
        [NSData dataWithBytesNoCopy: e
         length: sizeof(entry)
         freeWhenDone: YES];
        idx++;
        [query setIndex: idx];
#if DEBUG
        NSLog(@"    READDIR %@ (LNK)", name);
#endif // DEBUG
        i += strlen(e->name);
      }
    }
  }
  
  if (result.readdirres_u.reply.eof)
  {
    NSLog(@"readdir EOF; removing the query");
    [srv removeRunningQueryForHandle: handle];
  }
  
#if 1
  entry *xx;
  i = 0;
  for (xx = bottom; xx != NULL; xx = xx->nextentry)
  {
    NSLog(@"  name: %s cookie: %x fileid: %d next: %p", xx->name,
          *((int *) xx->cookie), xx->fileid, xx->nextentry);
    i++;
  }
  NSLog(@"send reply with %d entries; eof %d", i, result.readdirres_u.reply.eof);
#endif
  
  result.readdirres_u.reply.entries = bottom;

  return(&result);
}

statfsres *
nfsproc_statfs_2_svc(argp, rqstp)
	nfs_fh *argp;
	struct svc_req *rqstp;
{
  static statfsres result;
  FileHandle *handle = [FileHandle handleWithBytes: argp->data];
  NSLog(@"NFS STATFS %@", handle);
  Dentry *d = [[NFSServer server] lookup: handle];
  if (d == nil)
  {
    result.status = NFSERR_STALE;
  }
  else
  {
    result.status = NFS_OK;
    result.statfsres_u.reply.tsize = 1024;
    result.statfsres_u.reply.bsize = 1024;
    result.statfsres_u.reply.blocks = 5 * 1024 * 1024;
    result.statfsres_u.reply.bfree = 4 * 1024 * 1024;
    result.statfsres_u.reply.bavail = 5 * 1024 * 1024;
  }
  return(&result);
}
