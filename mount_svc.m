/* mount_svc.m -- mount service.
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
#include <sys/ioctl.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <signal.h>
#include <sys/ttycom.h>
#include <memory.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <syslog.h>
#include <errno.h>
#include <string.h>
#include <ifaddrs.h>

#import <Foundation/Foundation.h>
#import "MountServer.h"

#ifdef __STDC__
#define SIG_PF void(*)(int)
#endif

#ifdef DEBUG
#define RPC_SVC_FG
#endif

#define _RPCSVC_CLOSEDOWN 120
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
static int _rpcpmstart;		/* Started by a port monitor ? */
static int _rpcfdtype;		/* Whether Stream or Datagram ? */
static int _rpcsvcdirty;	/* Still serving ? */

static
void _msgout(char *fmt, ...)
{
  va_list ap;
  char msgbuf[256];

  va_start(ap, fmt);
  vsnprintf (msgbuf, sizeof (msgbuf), fmt, ap);
  NSString *str = [NSString stringWithCString: msgbuf
                   encoding: NSASCIIStringEncoding];
  NSLog(@"%@", str);
  va_end(ap);
}

static void
closedown()
{
	if (_rpcsvcdirty == 0) {
		extern fd_set svc_fdset;
		static int size;
		int i, openfd;

		if (_rpcfdtype == SOCK_DGRAM)
			exit(0);
		if (size == 0) {
			size = getdtablesize();
		}
		for (i = 0, openfd = 0; i < size && openfd < 2; i++)
			if (FD_ISSET(i, &svc_fdset))
				openfd++;
		if (openfd <= (_rpcpmstart?0:1))
			exit(0);
	}
	(void) alarm(_RPCSVC_CLOSEDOWN);
}

static void
mountprog_1(rqstp, transp)
	struct svc_req *rqstp;
	SVCXPRT *transp;
{
	union {
		dirpath mountproc_mnt_1_arg;
		dirpath mountproc_umnt_1_arg;
	} argument;
	char *result;
	bool_t (*xdr_argument)(), (*xdr_result)();
	char *(*local)();

	_rpcsvcdirty = 1;
	switch (rqstp->rq_proc) {
	case MOUNTPROC_NULL:
		xdr_argument = xdr_void;
		xdr_result = xdr_void;
		local = (char *(*)()) mountproc_null_1_svc;
		break;

	case MOUNTPROC_MNT:
		xdr_argument = xdr_dirpath;
		xdr_result = xdr_fhstatus;
		local = (char *(*)()) mountproc_mnt_1_svc;
		break;

	case MOUNTPROC_DUMP:
		xdr_argument = xdr_void;
		xdr_result = xdr_mountlist;
		local = (char *(*)()) mountproc_dump_1_svc;
		break;

	case MOUNTPROC_UMNT:
		xdr_argument = xdr_dirpath;
		xdr_result = xdr_void;
		local = (char *(*)()) mountproc_umnt_1_svc;
		break;

	case MOUNTPROC_UMNTALL:
		xdr_argument = xdr_void;
		xdr_result = xdr_void;
		local = (char *(*)()) mountproc_umntall_1_svc;
		break;

	case MOUNTPROC_EXPORT:
		xdr_argument = xdr_void;
		xdr_result = xdr_exports;
		local = (char *(*)()) mountproc_export_1_svc;
		break;

	case MOUNTPROC_EXPORTALL:
		xdr_argument = xdr_void;
		xdr_result = xdr_exports;
		local = (char *(*)()) mountproc_exportall_1_svc;
		break;

	default:
		svcerr_noproc(transp);
		_rpcsvcdirty = 0;
		return;
	}
	(void) memset((char *)&argument, 0, sizeof (argument));
	if (!svc_getargs(transp, xdr_argument, (caddr_t) &argument)) {
		svcerr_decode(transp);
		_rpcsvcdirty = 0;
		[[MountServer server] flushPool];
		return;
	}
	result = (*local)(&argument, rqstp);
	if (result != NULL && !svc_sendreply(transp, xdr_result, result)) {
		svcerr_systemerr(transp);
	}
	if (!svc_freeargs(transp, xdr_argument, (caddr_t) &argument)) {
		_msgout("unable to free arguments");
	        [[MountServer server] flushPool];
		return;
	}
	[[MountServer server] flushPool];
	_rpcsvcdirty = 0;
	return;
}

static void
mountprog_2(rqstp, transp)
	struct svc_req *rqstp;
	SVCXPRT *transp;
{
	union {
		dirpath mountproc_mnt_2_arg;
		dirpath mountproc_umnt_2_arg;
		dirpath mountproc_pathconf_2_arg;
	} argument;
	char *result;
	bool_t (*xdr_argument)(), (*xdr_result)();
	char *(*local)();

	NSLog(@"mountprog_2 %d", rqstp->rq_proc);

	_rpcsvcdirty = 1;
	switch (rqstp->rq_proc) {
	case MOUNTPROC_NULL:
		xdr_argument = xdr_void;
		xdr_result = xdr_void;
		local = (char *(*)()) mountproc_null_2_svc;
		break;

	case MOUNTPROC_MNT:
		xdr_argument = xdr_dirpath;
		xdr_result = xdr_fhstatus;
		local = (char *(*)()) mountproc_mnt_2_svc;
		break;

	case MOUNTPROC_DUMP:
		xdr_argument = xdr_void;
		xdr_result = xdr_mountlist;
		local = (char *(*)()) mountproc_dump_2_svc;
		break;

	case MOUNTPROC_UMNT:
		xdr_argument = xdr_dirpath;
		xdr_result = xdr_void;
		local = (char *(*)()) mountproc_umnt_2_svc;
		break;

	case MOUNTPROC_UMNTALL:
		xdr_argument = xdr_void;
		xdr_result = xdr_void;
		local = (char *(*)()) mountproc_umntall_2_svc;
		break;

	case MOUNTPROC_EXPORT:
		xdr_argument = xdr_void;
		xdr_result = xdr_exports;
		local = (char *(*)()) mountproc_export_2_svc;
		break;

	case MOUNTPROC_EXPORTALL:
		xdr_argument = xdr_void;
		xdr_result = xdr_exports;
		local = (char *(*)()) mountproc_exportall_2_svc;
		break;

	case MOUNTPROC_PATHCONF:
		xdr_argument = xdr_dirpath;
		xdr_result = xdr_ppathcnf;
		local = (char *(*)()) mountproc_pathconf_2_svc;
		break;

	default:
		svcerr_noproc(transp);
		_rpcsvcdirty = 0;
		[[MountServer server] flushPool];
		return;
	}
	(void) memset((char *)&argument, 0, sizeof (argument));
	if (!svc_getargs(transp, xdr_argument, (caddr_t) &argument)) {
		svcerr_decode(transp);
		_rpcsvcdirty = 0;
		[[MountServer server] flushPool];
		return;
	}
	result = (*local)(&argument, rqstp);
	if (result != NULL && !svc_sendreply(transp, xdr_result, result)) {
		svcerr_systemerr(transp);
	}
	if (!svc_freeargs(transp, xdr_argument, (caddr_t) &argument)) {
		_msgout("unable to free arguments");
		[[MountServer server] flushPool];
		return;
	}
	_rpcsvcdirty = 0;
	[[MountServer server] flushPool];
	return;
}



int
mount_main(argc, argv)
int argc;
char *argv[];
{
  SVCXPRT *transp = NULL;
  int sock;
  int proto = 0;
  struct sockaddr_in saddr;
  int asize = sizeof (saddr);	
  struct sockaddr_in localhost;
  struct ifaddrs *ifap, *i;
  
  memset(&localhost, 0, sizeof (localhost));

  _msgout("entering nfs_main...");
  sock = socket(AF_INET, SOCK_DGRAM, 0);
  if (sock == -1)
  {
    _msgout("socket: %s", strerror(errno));
    return 1;
  }
  
  if (getifaddrs (&ifap) == -1)
  {
    _msgout("getifaddrs: %s", strerror(errno));
    return -1;
  }
	
  for (i = ifap; i != NULL; i = i->ifa_next)
  {
    if (strncmp (i->ifa_name, "lo", 2) == 0
	&& i->ifa_addr->sa_family == AF_INET)
    {
      memcpy(&(localhost.sin_addr.s_addr),
	     &(((struct sockaddr_in *) i->ifa_addr)->sin_addr.s_addr),
	     4);
      localhost.sin_port = 0;
      localhost.sin_family = AF_INET;
      break;
    }
  }
  if (i == NULL)
  {
    _msgout("could not find localhost address");
    freeifaddrs (ifap);
    return -2;
  }
  freeifaddrs (ifap);
	
  _msgout("binding socket to %d.%d.%d.%d:%d",
	  ((unsigned char *) &localhost.sin_addr.s_addr)[0],
	  ((unsigned char *) &localhost.sin_addr.s_addr)[1],
	  ((unsigned char *) &localhost.sin_addr.s_addr)[2],
	  ((unsigned char *) &localhost.sin_addr.s_addr)[3],
	  ntohs(localhost.sin_port));

  if (bind (sock, &localhost, sizeof (struct sockaddr_in)) == -1)
  {
    _msgout("bind: %s", strerror(errno));
    return -3;
  }
  getsockname(sock, &localhost, sizeof (struct sockaddr_in));
  
  _msgout("bound socket to %d.%d.%d.%d:%d",
	  ((unsigned char *) &localhost.sin_addr.s_addr)[0],
	  ((unsigned char *) &localhost.sin_addr.s_addr)[1],
	  ((unsigned char *) &localhost.sin_addr.s_addr)[2],
	  ((unsigned char *) &localhost.sin_addr.s_addr)[3],
	  ntohs(localhost.sin_port));
	  
  setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (void *) 1, sizeof (int));

  (void) pmap_unset(MOUNTPROG, MOUNTVERS);
  (void) pmap_unset(MOUNTPROG, MOUNTVERS_POSIX);
  
  transp = svcudp_create(sock);
  if (transp == NULL)
  {
    _msgout("cannot create UDP service");
    return -4;
  }

  if (!svc_register(transp, MOUNTPROG, MOUNTVERS, mountprog_1, IPPROTO_UDP))
  {
    _msgout("unable to register (MOUNTPROG, MOUNTVERS, udp).");
    return -5;
  }
  if (!svc_register(transp, MOUNTPROG, MOUNTVERS_POSIX, mountprog_2, IPPROTO_UDP))
  {
    _msgout("unable to register (MOUNTPROG, MOUNTVERS_POSIX, udp).");
    return -6;
  }

  _msgout("beginning svc_run...");
  svc_run();
  _msgout("svc_run returned");
  return -7;
}
