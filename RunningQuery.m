/* RunningQuery.m --
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
    [theQuery retain];
    if (aPredicate != nil)
    {
      query = [[NSMetadataQuery alloc] init];
      [query setPredicate: aPredicate];
      [query startQuery];
    }
    else
    {
      query = nil;
    }
    index = 0;
    isDone = NO;
    listed = [[NSMutableSet alloc] initWithCapacity: 10];
    lastCount = -1;
  }
  
  return self;
}

- (id) queryInfo
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

- (bool) isDone
{
  return isDone;
}

- (void) setDone: (bool) aBool
{
  isDone = aBool;
}

- (void) dealloc
{
  [theQuery release];
  if (query != nil)
  {
    [query release];
  }
  [listed release];
  [super dealloc];
}

- (bool) hasListed: (NSString *) name
{
  return [listed containsObject: name];
}

- (void) listed: (NSString *) name
{
  [listed addObject: name];
}

- (void) loop
{
  if (query != nil)
  {
    int n = [query resultCount];
    if (n != lastCount)
    {
      if (lastDate != nil)
        [lastDate release];
      lastDate = [[NSDate alloc] init];
      lastCount = n;
    }
  }
}

// Give up if nothing new has happened in 30 seconds.
- (bool) shouldGiveUp
{
  if (lastDate == nil)
    return NO;
  return [lastDate timeIntervalSince1970] > 30;
}

@end
