/* Dentry.m -- a directory entry.
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

#import "Dentry.h"


@implementation Dentry

- (id) initWithName: (NSString *) aName
	     parent: (Dentry *) aParent
	     handle: (FileHandle *) aHandle
{
  NSLog(@"Dentry initWithName:parent:handle");
  if ((self = [super init]) != nil)
  {
    name = [[NSString alloc] initWithString: aName];
    parent = aParent;
    handle = [[FileHandle alloc] initWithBytes: [aHandle handle]];
    modified = [[NSDate alloc] init];
    created = [[NSDate alloc] init];
    accessed = [[NSDate alloc] init];
  }
  
  NSLog(@"Dentry init ok");
  
  return self;
}

- (void) dealloc
{
  [name release];
  [handle release];
  [accessed release];
  [modified release];
  [created release];
  [super dealloc];
}

- (NSString *) name
{
  return name;
}

- (Dentry *) parent
{
  return parent;
}

- (FileHandle *) handle
{
  return handle;
}

- (void) access
{
  NSDate *now = [[NSDate alloc] init];
  NSDate *then = accessed;
  accessed = now;
  [accessed release];
}

- (NSDate *) accessedTime
{
  return [[accessed copy] autorelease];
}

- (NSDate *) modifiedTime
{
  return [[modified copy] autorelease];
}

- (NSDate *) createdTime
{
  return [[created copy] autorelease];
}

- (bool) isDir
{
  return NO;
}

- (bool) isFile
{
  return NO;
}

- (NSString *) path
{
  if (parent == nil)
    return [NSString stringWithString: name];
  return [NSString stringWithFormat: @"%@/%@", [parent path], name];
}

@end
