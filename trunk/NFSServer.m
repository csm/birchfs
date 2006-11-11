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
#import "constants.h"

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
    cacheFlushCount = 0;
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

- (void) flushCache
{
  if (cacheFlushCount > kCacheFlushCount)
  {
    NSArray *values = [dentry_cache allValues];
    NSMutableArray *stale = [NSMutableArray arrayWithCapacity: 10];
    int i;
    const int n = [values count];
    
    for (i = 0; i < n; i++)
    {
      Dentry *d = (Dentry *) [values objectAtIndex: i];
      
      // If the dentry is retained by a child dentry, we can't remove it.
      if ([d retainCount] > 1)
      {
        continue;
      }
      
      if ([[d accessedTime] timeIntervalSinceNow] < -kDentryLifetime)
      {
        [stale addObject: [d handle]];
      }
    }
    
    [dentry_cache removeObjectsForKeys: stale];

    cacheFlushCount = 0;
  }
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
  FileHandle *handle = [aDentry handle];
  [dentry_cache setObject: aDentry forKey: [aDentry handle]];
}

- (RunningQuery *) runningQueryForHandle: (FileHandle *) aHandle
{
  return (RunningQuery *) [queries objectForKey: aHandle];
}

- (void) insertRunningQuery: (RunningQuery *) aQuery
                  forHandle: (FileHandle *) aHandle
{
  [queries setObject: aQuery forKey: aHandle];
}

- (void) removeRunningQueryForHandle: (FileHandle *) aHandle
{
  [queries removeObjectForKey: aHandle];
}

- (BirchQuery *) queryForName: (NSString *) aName
{
  NSArray *array = nil;
  if (appController != nil)
  {
    if ([aName isEqual: @"/Birch"])
      array = [NSArray arrayWithObjects: aName,
	       [NSNumber numberWithBool: NO],
	       kWildcard, @"", @"",
	       [appController queryNames], nil];
    else
    {
      array = [appController queryForName: aName];
      [array replaceObjectAtIndex: 5 withObject: [appController queryNames]];
    }
  }
  
  if (array != nil)
  {
    NSLog(@"looked up query array %@ for name %@", array, aName);
  
    return [BirchQuery queryWithArray: array];
  }
  return nil;
}

- (void) addQueryWithName: (NSString *) aName
                    toDir: (NSString *) aDirname
{
  if ([aDirname isEqual: kBirchRoot])
  {
    [appController newQueryWithName: aName];
  }
  else
  {
    NSArray *parent = [appController queryForName: aDirname];
    if (parent == nil)
    {
      return; // Maybe, this should not happen.
    }
    NSArray *child = [appController queryForName: aName];
    if (child == nil)
    {
      [appController newQueryWithName: aName];
    }
    NSMutableArray *subordinates = [parent objectAtIndex: 5];
    if (![subordinates containsObject: aName])
    {
      [subordinates addObject: aName];
    }
  }
  [appController syncDefaults];
}

- (void) runServerLoop: (id) anAgrument
{
  [self flushPool];
  NSLog(@"launching NFS server thread");
  [self setState: NFSServerStarting];
  NSLog(@"setting up MOUNT server...");
  int ret = mount_setup (0, NULL);
  NSLog(@"mount_setup returns status %d", ret);
  ret = nfs_main (0, NULL);
  NSLog(@"server thread exited with status %d!", ret);
  [self setState: NFSServerExited];
}

@end
