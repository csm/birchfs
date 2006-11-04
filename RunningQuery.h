//
//  RunningQuery.h
//  Birch
//
//  Created by C. Scott Marshall on 11/3/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BirchQuery.h"

@interface RunningQuery : NSObject {
  BirchQuery *theQuery;
  bool listing_dirs;
  int cookie;
  NSMetadataQuery *query;
  int index;
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

@end
