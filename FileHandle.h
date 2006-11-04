/* FileHandle.h -- NFS file handle.
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


@interface FileHandle : NSObject {
  char handle[32];
}

- (id) initWithBytes: (char *) someBytes;

+ (FileHandle *) handleWithBytes: (char *) someBytes;
+ (FileHandle *) handleWithPath: (NSString *) aPath;

// Fetch the handle bytes. Note that this pointer is freed on the
// next autorelease cycle, so it must be copied if it is to be used
// longer than the current loop iteration.
- (char *) handle;

@end
