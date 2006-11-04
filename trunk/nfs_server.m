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
#import "DentryFile.h"
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
    else
    {
      result.status = NFS_OK;
      fattr *attr = &(result.attrstat_u.attributes);
      DentryFile *file = (DentryFile *) d;
      attr->type = NFLNK;
      attr->mode = NFSMODE_LNK | 0666;
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
  NSLog(@"NFS SETATTR");
  result.status = NFSERR_PERM;
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
  DentryDirectory *dir = nil;

  NSLog(@"NFS LOOKUP fh: %@ name: %@", handle, name);
  
  // The file handle is always the MD5 sum (0-filled) of the full path.
  FileHandle *target = [FileHandle handleWithPath: [NSString stringWithFormat:
    @"%@/%@", [dir path], name]];
  
  Dentry *dentry = [srv lookup: handle];
  
  if (dentry == nil)
  {
    BirchQuery *q = [srv queryForName: name];
    if (q == nil)
    {
      NSPredicate *p = [[dir buildPredicateString] stringByAppendingFormat:
        @" && kMDItemFSName == \"%@\"", name];
      NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
      [query setPredicate: p];
      [query startQuery];
      while ([query isGathering])
      {
	[NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
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
  else
  {
    DentryFile *file = (DentryFile *) dentry;
    result.readlinkres_u.data = [[file realpath] UTF8String];
  }

  return(&result);
}

readres *
nfsproc_read_2_svc(argp, rqstp)
	readargs *argp;
	struct svc_req *rqstp;
{
  static readres  result;

  FileHandle *handle = [FileHandle handleWithBytes: argp->file.data];
  Dentry *dentry = [[NFSServer server] lookup: handle];

  NSLog(@"NFS READ %@", handle);
  
  if (dentry == nil)
  {
    result.status = NFSERR_STALE;
  }
  else if ([dentry isDir])
  {
    result.status = NFSERR_ISDIR;
  }
  else
  {
    // Can you read from a symlink?
    result.status = NFSERR_INVAL;
  }

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
  NSLog(@"NFS WRITE");
  result.status = NFSERR_PERM; // XXX suck a fuck
  return(&result);
}

diropres *
nfsproc_create_2_svc(argp, rqstp)
	createargs *argp;
	struct svc_req *rqstp;
{
  static diropres result;
  NSLog(@"NFS CREATE");
  result.status = NFSERR_PERM;
  return(&result);
}

nfsstat *
nfsproc_remove_2_svc(argp, rqstp)
	diropargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result = NFSERR_PERM;
  NSLog(@"NFS REMOVE");
  // FIXME: delete directories from subordinate sets/root set.
  return(&result);
}

nfsstat *
nfsproc_rename_2_svc(argp, rqstp)
	renameargs *argp;
	struct svc_req *rqstp;
{
  static nfsstat result = NFSERR_PERM;

  // Allow rename of directories?
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
  static diropres  result;
  result.status = NFSERR_PERM;
  NSLog(@"NFS MKDIR");
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

readdirres *
nfsproc_readdir_2_svc(argp, rqstp)
	readdirargs *argp;
	struct svc_req *rqstp;
{
  static readdirres  result;
  int i;
  int cookie = *((int *) (argp->cookie));
  NFSServer *srv = [NFSServer server];
  RunningQuery *query = [srv runningQuery: cookie];
  FileHandle *handle = [FileHandle handleWithBytes: argp->dir.data];
  Dentry *dentry = [srv lookup: handle];
  entry *current = NULL;
  
  NSLog(@"NFS READDIR handle: %@ count: %d", handle, argp->count);
  
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
  
  if (query == nil)
  {
    NSPredicate *pred = nil;
    bool isLeaf = [dentry isLeaf];
    if (isLeaf)
    {
      NSString *s = [((DentryDirectory *) dentry) buildPredicateString];
      pred = [NSPredicate predicateWithFormat: "%@", s];
    }
    BirchQuery *q = [srv queryForName: [dentry name]];
    query = [[RunningQuery alloc] initWithCookie: cookie query: q
	     predicate: pred];
    [srv insertRunningQuery: query];
    [query autorelease];
  }
  
  result.readdirres_u.reply.eof = NO;
  for (i = 0; i < argp->count; i++)
  {
    if ([query listingDirs])
    {
      int idx = [query index];
      NSArray *subordinates = [[query queryInfo] subordinates];
      if (idx >= [subordinates count])
      {
	if ([query query] == nil) // not leaf
	{
	  result.readdirres_u.reply.eof = YES;
	  break;
	}
	[query setListingDirs: NO];
      }
      else
      {
	NSString *name = [subordinates objectAtIndex: idx];
	entry *e = (entry *) malloc (sizeof (struct entry));
	e->fileid = 0; // ?
	e->name = [name UTF8String];
	*((int *) e->cookie) = cookie;
	e->nextentry = current;
	current = e;
	[HeapBuffer bufferWithPointer: e];
	idx++;
	[query setIndex: idx];
	NSLog(@"    READDIR %@ (DIR)", name);
      }
    }
    else
    {
      NSMetadataQuery *mdq = [query query];
      while ([mdq isGathering])
      {
	[NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1]];
      }
      
      int idx = [query index];
      if (idx >= [mdq resultCount])
      {
	result.readdirres_u.reply.eof = YES;
	break;
      }
      else
      {
	NSMetadataItem *item = [mdq resultAtIndex: idx];
	NSString *name = [[item valueForAttribute: @"kMDItemPath"] lastPathComponent];
	entry *e = (entry *) malloc (sizeof (struct entry));
	e->fileid = 0;
	e->name = [name UTF8String];
	*((int *) e->cookie) = cookie;
	e->nextentry = current;
	current = e;
	[HeapBuffer bufferWithPointer: e];
	idx++;
	[query setIndex: idx];
	NSLog(@"    READDIR %@ (LNK)", name);
      }
    }
  }
  
  if (result.readdirres_u.reply.eof)
  {
    [srv removeRunningQuery: cookie];
  }
  
  result.readdirres_u.reply.entries = current;

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
