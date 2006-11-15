/* DentryDirectory.m -- a directory (a query)
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

#import "DentryDirectory.h"


@implementation DentryDirectory

static DentryDirectory *gRoot = nil;
extern const char kRootHandle[];

- (id) initRoot
{
  char zero[32];
  memset (zero, 0, 32);
  if ((self = [super initWithName: @"/Birch" parent: nil
       handle: [FileHandle handleWithBytes: zero]]) != nil)
  {
    isRoot = YES;
    predicate = nil;
    isLeaf = NO;
    metafiles = [[NSMutableArray alloc] initWithCapacity: 10];
  }
  
  return self;
}

- (id) initWithName: (NSString *) aName
	     parent: (Dentry *) aParent
	     handle: (FileHandle *) aHandle
	     isLeaf: (bool) aBool
	  predicate: (NSPredicate *) aPredicate
{
  if ((self = [super initWithName: aName parent: aParent handle: aHandle]) != nil)
  {
    isRoot = NO;
    isLeaf = aBool;
    if (aPredicate != nil)
      predicate = [aPredicate copy];
    else
      predicate = nil;
    metafiles = [[NSMutableArray alloc] initWithCapacity: 10];
  }
  
  return self;
}

+ (DentryDirectory *) root
{
  if (gRoot == nil)
  {
    gRoot = [[DentryDirectory alloc] initRoot];
  }
  
  return gRoot;
}

- (bool) isRoot
{
  return isRoot;
}

- (void) dealloc
{
  if (predicate != nil)
    [predicate release];
  [metafiles release];
  [super dealloc];
}

- (NSPredicate *) predicate
{
  return [predicate copy];
}

- (NSPredicate *) buildPredicate
{
  if (parent == nil)
    return nil;
  if ([parent isRoot])
    return [[predicate copy] autorelease];
  if (predicate == nil)
    return [((DentryDirectory *) parent) buildPredicate];
  return [NSCompoundPredicate andPredicateWithSubpredicates:
          [NSArray arrayWithObjects: [((DentryDirectory *) parent) buildPredicate],
           predicate, nil]];
}

- (NSString *) description
{
  return [NSString stringWithFormat: @"DIR handle:%@ name:%@",
    handle, name];
}

- (bool) isDir
{
  return YES;
}

- (bool) isLeaf
{
  if (parent == nil)
    return isLeaf;
  return [parent isLeaf] || isLeaf;
}

- (NSArray *) metafiles
{
  return [NSArray arrayWithArray: metafiles];
}

- (void) addMetafile: (NSString *) aName
{
  if (![metafiles containsObject: aName])
  {
    [metafiles addObject: aName];
  }
}

- (void) removeMetafile: (NSString *) aName
{
  if ([metafiles containsObject: aName])
  {
    [metafiles removeObject: aName];
  }
}

@end
