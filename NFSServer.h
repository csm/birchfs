/* NFSServer.h -- 
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

#import <Cocoa/Cocoa.h>
#import "BirchController.h"
#import "NFSServerState.h"
#import "Dentry.h"
#import "BirchQuery.h"
#import "RunningQuery.h"

#define kPoolFlushCount 1

#define kBirchRoot "/Birch"

@interface NFSServer : NSObject {
  NSMutableDictionary *dentry_cache;
  NSMutableDictionary *queries;
  BirchController *appController;
  NFSServerState state;
  NSAutoreleasePool *serverPool;
  int flushCount;
  int mounted;
}

+ (NFSServer *) server;
+ (NFSServer *) serverWithController: (BirchController *) aController;

- (NFSServerState) state;
- (void) setState: (NFSServerState) aState;

- (void) setController: (BirchController *) aController;
//- (void) serverEnteringLoop;

- (void) flushPool;

- (void) mount;
- (void) unmount;
- (bool) isMounted;

- (Dentry *) lookup: (FileHandle *) aHandle;
- (void) insert: (Dentry *) aDentry;

- (RunningQuery *) runningQuery: (int) cookie;
- (void) insertRunningQuery: (RunningQuery *) aQuery;
- (void) removeRunningQuery: (int) cookie;

- (BirchQuery *) queryForName: (NSString *) aName;

- (void) runServerLoop: (id) anArgument;

@end
