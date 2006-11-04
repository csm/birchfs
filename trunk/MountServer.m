/* MountServer.m -- mountd server
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

#import "MountServer.h"


@implementation MountServer

static MountServer *gServer = nil;

- (id) init
{
  if ((self = [super init]) != nil)
  {
    serverPool = nil;
    flushCount = 0;
  }
  
  return self;
}

+ (MountServer *) server
{
  if (gServer == nil)
    gServer = [[MountServer alloc] init];
  return gServer;
}

- (void) flushPool
{
  if (serverPool != nil)
  {
    if (--flushCount > 0)
      return;
    [serverPool release];
  }
  serverPool = [[NSAutoreleasePool alloc] init];
  flushCount = kMountPoolFlushCount;
}

- (void) runServerLoop: (id) anArgument
{
  [self flushPool];
  NSLog(@"mount server launching");
  int ret = mount_main(0, NULL);
  NSLog(@"mount server exitid with status %d", ret);
  [self flushPool];
}

@end
