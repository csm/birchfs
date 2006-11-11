/* DentryMetafile.h -- a meta-file.
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
#import "Dentry.h"

// This class is meant to support applications like Finder that need
// to store meta-info in a special file (for example, .DS_Store). Metafiles
// are pure-memory files only -- that is, the entire contents of the
// file only exist in virtual memory.
@interface DentryMetafile : Dentry
{
  NSMutableData *contents;
}

- (int) size;
- (void) truncate: (int) newSize;
- (void) writeData: (NSData *) data atOffset: (int) offset;
- (int) readData: (void *) buf atOffset: (int) offset length: (int) len;

@end
