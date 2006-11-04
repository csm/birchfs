/* NFSServer.m -- 
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


#import "NFSServer.h"
#import "BirchController.h"
#import "DentryDirectory.h"

@implementation NFSServer

static NFSServer *gServer = nil;

- (id) init
{
  if ((self = [super init]) != nil)
  {
    dentry_cache = [[NSMutableDictionary alloc] init];
    queries = [[NSMutableDictionary alloc] init];
    state = NFSServerNotStarted;
    serverPool = nil;
    flushCount = 0;
  }
  return self;
}

+ (NFSServer *) server
{
  if (gServer == nil)
  {
    gServer = [[NFSServer alloc] init];
  }
  return gServer;
}

+ (NFSServer *) serverWithController: (BirchController *) aController
{
  NFSServer *srv = [NFSServer server];
  [srv setController: aController];
  return srv;
}

- (NFSServerState) state
{
  return state;
}

- (void) setState: (NFSServerState) aState
{
  state = aState;
  if (appController != nil)
  {
    [appController nfsServerStatusChanged: self];
  }
}

- (void) setController: (BirchController *) aController
{
  appController = aController;
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
  flushCount = kPoolFlushCount;
}

- (void) mount
{
  if (mounted > 0)
  {
    NSLog(@"warning: already mounted %d times", mounted);
  }
  mounted++;
  [self setState: NFSServerMounted];
}

- (void) unmount
{
  if (mounted == 0)
  {
    NSLog(@"warning: not mounted");
  }
  if (--mounted < 0)
    mounted = 0;
  [self setState: NFSServerRunning];
}

- (bool) isMounted
{
  return (mounted > 0);
}

- (Dentry *) lookup: (FileHandle *) aHandle
{
  Dentry *root = [DentryDirectory root];
  if ([aHandle isEqual: [root handle]])
  {
    return root;
  }
  return [dentry_cache objectForKey: aHandle];
}

- (void) insert: (Dentry *) aDentry
{
  [dentry_cache setObject: aDentry forKey: [aDentry handle]];
}

- (RunningQuery *) runningQuery: (int) cookie
{
  return (BirchQuery *) [queries objectForKey: [NSNumber numberWithInt: cookie]];
}

- (void) insertRunningQuery: (RunningQuery *) aQuery
{
  [queries setObject: aQuery forKey: [NSNumber numberWithInt: [aQuery cookie]]];
}

- (void) removeRunningQuery: (int) cookie
{
  [queries removeObjectForKey: [NSNumber numberWithInt: cookie]];
}

- (BirchQuery *) queryForName: (NSString *) aName
{
  NSArray *array = nil;
  if (appController != nil)
  {
    extern const NSString *kWildcard;
    if ([aName isEqual: @"/Birch"])
      array = [NSArray arrayWithObjects: aName,
	       [NSNumber numberWithBool: NO],
	       kWildcard, @"", @"",
	       [appController queryNames]];
    else
      array = [appController queryForName: aName];
  }
  
  if (array != nil)
  {
    return [BirchQuery queryWithArray: array];
  }
  return nil;
}

- (void) runServerLoop: (id) anAgrument
{
  [self flushPool];
  NSLog(@"launching NFS server thread");
  [self setState: NFSServerStarting];
  int ret = nfs_main (0, NULL);
  NSLog(@"server thread exited with status %d!", ret);
  [self setState: NFSServerExited];
}

@end
