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
  NSLog(@"initialize the root");
  if ((self = [super initWithName: @"/Birch" parent: nil
       handle: [FileHandle handleWithBytes: zero]]) != nil)
  {
    isRoot = YES;
    predicate = nil;
    isLeaf = NO;
  }
  
  return self;
}

- (id) initWithName: (NSString *) aName
	     parent: (Dentry *) aParent
	     handle: (FileHandle *) aHandle
	     isLeaf: (bool) aBool
	  predicate: (NSString *) aPredicate
{
  if ((self = [super initWithName: aName parent: aParent handle: aHandle]) != nil)
  {
    isRoot = NO;
    isLeaf = aBool;
    predicate = [[NSString alloc] initWithString: aPredicate];
  }
  
  return self;
}

+ (DentryDirectory *) root
{
  NSLog(@"returning root dir entry");
  if (gRoot == nil)
  {
    gRoot = [[DentryDirectory alloc] initRoot];
  }
  
  NSLog(@"the root is %p", gRoot);
  NSLog(@"the root is %@", gRoot);
  
  return gRoot;
}

- (bool) isRoot
{
  return isRoot;
}

- (void) dealloc
{
  [predicate release];
  [super dealloc];
}

- (NSString *) predicate
{
  return [NSString stringWithString: predicate];
}

- (NSPredicate *) buildPredicate
{
  if (predicate == nil)
    return nil;
    
  return [NSPredicate predicateWithFormat: @"%@", [self buildPredicateString]];
}

- (NSString *) buildPredicateString
{
  if (predicate == nil)
    return nil;
  if (parent == nil)
    return [NSString stringWithString: predicate];
  
  NSString *p = [parent buildPredicateString];
  if (p == nil)
    return [NSString stringWithString: predicate];
  else
    return [NSString stringWithFormat: @"%@ && %@", p, predicate];
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

@end
