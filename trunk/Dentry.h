/* Dentry.h
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
#import "FileHandle.h"

@interface Dentry : NSObject {
  NSString *name;
  Dentry *parent;
  FileHandle *handle;
  NSDate *created;
  NSDate *accessed;
  NSDate *modified;
}

- (id) initWithName: (NSString *) aName
	     parent: (Dentry *) aParent
	     handle: (FileHandle *) handle;
	     
- (NSString *) name;
- (Dentry *) parent;
- (FileHandle *) handle;

- (void) access;

- (NSDate *) accessedTime;
- (NSDate *) modifiedTime;
- (NSDate *) createdTime;

- (bool) isDir;
- (bool) isFile;

- (NSString *) path;

@end
