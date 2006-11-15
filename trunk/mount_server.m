/* mount_server.m -- mount service RPC functions.
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


#include "mount.h"

#import "NFSServer.h"

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
 * Copyright (c) 1985, 1990 by Sun Microsystems, Inc.
 */

/* from @(#)mount.x	1.3 91/03/11 TIRPC 1.0 */



void *
mountproc_null_1_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  NSLog(@"MOUNTD NULL(1)");
  return NULL;
}

fhstatus *
mountproc_mnt_1_svc(argp, rqstp)
	dirpath *argp;
	struct svc_req *rqstp;
{
  static fhstatus  result;

  NSLog(@"MOUNTD MNT(1) %s", *argp);
  // Use the null file handle for the root dir.
  memset (&(result.fhstatus_u.fhs_fhandle), 0, sizeof (fhstatus)); 
  if (strcmp (*argp, kBirchRootCstring) == 0)
  {
    [[NFSServer server] mount];
    result.fhs_status = 0;
  }
  else
  {
    result.fhs_status = 1; // FAILED XXX
  }

  return(&result);
}

mountlist *
mountproc_dump_1_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static mountlist result;
  static mountbody mb;
  
  NSLog(@"MOUNTD DUMP(1)");
  
  if ([[NFSServer server] isMounted])
  {
    mb.ml_hostname = "localhost";
    mb.ml_directory = "/Birch";
    mb.ml_next = NULL;
    result = &mb;
  }
  else
    result = NULL;

  return(&result);
}

void *
mountproc_umnt_1_svc(argp, rqstp)
	dirpath *argp;
	struct svc_req *rqstp;
{
  static char* result;

  NSLog(@"MOUNTD UMNT(1) %s", *argp);
  if (strcmp (*argp, kBirchRootCstring) == 0)
  {
    [[NFSServer server] unmount];
  }
  // Otherwise???

  return((void*) &result);
}

void *
mountproc_umntall_1_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static char* result;
  
  NSLog(@"MOUNTD UMNTALL(1)");
  [[NFSServer server] unmount];
  return((void*) &result);
}

exports *
mountproc_export_1_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static exports  result;
  static exportnode node;
  
  NSLog(@"MOUNTD EXPORT(1)");

  // XXX WTF goes in the groups list?
  node.ex_dir = kBirchRootCstring;
  node.ex_groups = NULL;
  node.ex_next = NULL;
  result = &node;

  return(&result);
}

exports *
mountproc_exportall_1_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static exports  result;
  static exportnode node;

  NSLog(@"MOUNTD EXPORTALL(1)");

  // XXX WTF goes in the groups list?
  node.ex_dir = kBirchRootCstring;
  node.ex_groups = NULL;
  node.ex_next = NULL;
  result = &node;

  return(&result);
}

void *
mountproc_null_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  NSLog(@"MOUNTD NULL(2)");
  return NULL;
}

fhstatus *
mountproc_mnt_2_svc(argp, rqstp)
	dirpath *argp;
	struct svc_req *rqstp;
{
  static fhstatus  result;

  NSLog(@"MOUNTD MNT(2) %s", *argp);
  // Use the null file handle for the root dir.
  memset (&(result.fhstatus_u.fhs_fhandle), 0, sizeof (fhstatus)); 
  if (strcmp (*argp, kBirchRootCstring) == 0)
  {
    [[NFSServer server] mount];
    result.fhs_status = 0;
  }
  else
  {
    result.fhs_status = 1; // FAILED XXX
  }  

  return(&result);
}

mountlist *
mountproc_dump_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static mountlist  result;
  static mountbody mb;

  NSLog(@"MOUNTD DUMP(2)");
  
  // XXX can't handle multiple mounts!
  if ([[NFSServer server] isMounted])
  {
    mb.ml_hostname = "localhost";
    mb.ml_directory = kBirchRootCstring;
    mb.ml_next = NULL;
    result = &mb;
  }
  else
    result = NULL;

  return(&result);
}

void *
mountproc_umnt_2_svc(argp, rqstp)
	dirpath *argp;
	struct svc_req *rqstp;
{
  static char* result;

  NSLog(@"MOUNTD UMNT(2) %s", *argp);
  if (strcmp (*argp, kBirchRootCstring) == 0)
  {
    [[NFSServer server] unmount];
  }
  // Otherwise???

  return((void*) &result);
}

void *
mountproc_umntall_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static char* result;

  NSLog(@"MOUNTD UMNTALL(2)");
  [[NFSServer server] unmount];
  return((void*) &result);
}

exports *
mountproc_export_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{
  static exports  result;
  static exportnode node;

  NSLog(@"MOUNTD EXPORT(2)");

  // XXX WTF goes in the groups list?
  node.ex_dir = kBirchRootCstring;
  node.ex_groups = NULL;
  node.ex_next = NULL;
  result = &node;

  return(&result);
}

exports *
mountproc_exportall_2_svc(argp, rqstp)
	void *argp;
	struct svc_req *rqstp;
{

  static exports  result;
  static exportnode node;

  NSLog(@"MOUNTD EXPORTALL(2)");

  // XXX WTF goes in the groups list?
  node.ex_dir = kBirchRootCstring;
  node.ex_groups = NULL;
  node.ex_next = NULL;
  result = &node;

  return(&result);
}

ppathcnf *
mountproc_pathconf_2_svc(argp, rqstp)
	dirpath *argp;
	struct svc_req *rqstp;
{
  static ppathcnf  result;
  
  NSLog(@"MOUNTD PATHCONF(2)");

  result.pc_link_max = 1;
  result.pc_max_canon = 256;
  result.pc_max_input = 256;
  result.pc_name_max = 256;
  result.pc_path_max = 4096;
  result.pc_pipe_buf = 4096;
  result.pc_vdisable = 0; // ?
  result.pc_xxx = 0; // ?
  result.pc_mask[0] = 0; // ?
  result.pc_mask[1] = 0; // ?

  return(&result);
}
