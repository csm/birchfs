/* RunningQuery.h --
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
#import "BirchQuery.h"

@interface RunningQuery : NSObject {
  BirchQuery *theQuery;
  bool listing_dirs;
  int cookie;
  NSMetadataQuery *query;
  int index;
  bool isDone;
  NSMutableSet *listed;
  int lastCount;
  NSDate *lastDate;
}

- (id) initWithCookie: (int) aCookie query: (BirchQuery *) aQuery
  predicate: (NSPredicate *) aPredicate;

- (bool) listingDirs;
- (void) setListingDirs: (bool) aBool;
- (id) queryInfo;
- (int) cookie;
- (NSMetadataQuery *) query;
- (int) index;
- (void) setIndex: (int) anIndex;
- (bool) isDone;
- (void) setDone: (bool) aBool;

- (bool) hasListed: (NSString *) name;
- (void) listed: (NSString *) name;

- (void) loop;
- (bool) shouldGiveUp;

@end
