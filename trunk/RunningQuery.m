//
//  RunningQuery.m
//  Birch
//
//  Created by C. Scott Marshall on 11/3/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "RunningQuery.h"


@implementation RunningQuery

			     // I want a raise
			     // I want to go home
			     // I want sex
			     // I want a cookie

- (id) initWithCookie: (int) aCookie query: (BirchQuery *) aQuery
  predicate: (NSPredicate *) aPredicate
{
  if ((self = [super init]) != nil)
  {
    listing_dirs = YES;
    cookie = aCookie;
    theQuery = aQuery;
    if (aPredicate != nil)
    {
      query = [[NSMetadataQuery alloc] init];
      [query setPredicate: aPredicate];
      [query start];
    }
    else
    {
      query = nil;
    }
    index = 0;
  }
  
  return self;
}

- (BirchQuery *) queryInfo
{
  return theQuery;
}

- (bool) listingDirs
{
  return listing_dirs;
}

- (void) setListingDirs: (bool) aBool
{
  listing_dirs = aBool;
}

- (int) cookie
{
  return cookie;
}

- (NSMetadataQuery *) query
{
  return query;
}

- (int) index
{
  return index;
}

- (void) setIndex: (int) anIndex
{
  index = anIndex;
}

- (void) dealloc
{
  if (query != nil)
  {
    [query release];
  }
  [super dealloc];
}

@end
