/* DentryMetafile.m -- a meta-file.
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

#import "DentryMetafile.h"


@implementation DentryMetafile

- (id) initWithName: (NSString *) aName
	           parent: (Dentry *) aParent
	           handle: (FileHandle *) aHandle
{
  if ((self = [super initWithName: aName parent: aParent handle: aHandle]) != nil)
  {
    contents = [[NSMutableData alloc] initWithCapacity: 256];
    if (contents == nil)
    {
      return nil;
    }
    
    // Retain self; this will leak, but we don't want to drop this on the
    // floor.
    [self retain];
  }
  
  return self;
}

- (void) dealloc
{
  [contents release];
  [super dealloc];
}

- (int) size
{
  return [contents length];
}

- (void) truncate: (int) newSize
{
  [contents setLength: newSize];
}

- (void) writeData: (NSData *) data atOffset: (int) offset
{
  if ([contents length] < offset + [data length])
  {
    [self truncate: offset + [data length]];
  }
  [contents replaceBytesInRange: NSMakeRange(offset, [data length])
   withBytes: [data bytes]];
}

- (int) readData: (void *) buf atOffset: (int) offset length: (int) len
{
  if (offset < 0 || offset >= [contents length])
    return 0;
  if (len > [contents length] - offset)
    len = [contents length] - offset;
  [contents getBytes: buf range: NSMakeRange(offset, len)];
  return len;
}

@end
