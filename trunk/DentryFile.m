/* DentryFile.m
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

#import "DentryFile.h"


@implementation DentryFile

- (id) initWithName: (NSString *) aName
             parent: (Dentry *) aParent
	     handle: (FileHandle *) aHandle
	   realpath: (NSString *) aPath
{
  if ((self = [super initWithName: aName parent: aParent handle: aHandle]) != nil)
  {
    realpath = [[NSString alloc] initWithString: aPath];
  }
  
  return self;
}

- (void) dealloc
{
  [realpath release];
  [super dealloc];
}

- (NSString *) realpath
{
  return [NSString stringWithString: realpath];
}

- (bool) isFile
{
  return YES;
}

@end
