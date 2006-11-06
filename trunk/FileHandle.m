/* FileHandle.m -- NFS file handle.
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

#import "FileHandle.h"
#import <openssl/md5.h>
#import "HeapBuffer.h"

@implementation FileHandle

- (id) initWithBytes: (char *) someBytes
{
  if ((self = [super init]) != nil)
  {
    memcpy (handle, someBytes, 32);
  }

  return self;
}

+ (FileHandle *) handleWithBytes: (char *) someBytes
{
  FileHandle *h = [[FileHandle alloc] initWithBytes: someBytes];
  if (h != nil)
    [h autorelease];
  return h;
}

+ (FileHandle *) handleWithPath: (NSString *) path
{
  char hash[32];
  char *str = [path UTF8String];
 
  memset (hash, 0, 32); 
  MD5 (str, strlen (str), hash);
  
  return [FileHandle handleWithBytes: hash];
}

- (char *) handle
{
  char *h = malloc (32);
  memcpy (h, handle, 32);
  [HeapBuffer bufferWithPointer: h];
  return h;
}

- (id) copyWithZone: (NSZone *) aZone
{
  return [[FileHandle allocWithZone: aZone] initWithBytes: handle];
}

- (BOOL) isEqual: (id) anObject
{
  if ([anObject isKindOfClass: [FileHandle class]])
  {
    FileHandle *that = (FileHandle *) anObject;
    if (memcmp (handle, [that handle], 32) == 0)
    {
      return YES;
    }
  }
  return NO;
}

- (unsigned) hash
{
  // XXX whatever.
  return (*((int32_t *) handle)
	  ^ *((int32_t *) (handle + 4))
	  ^ *((int32_t *) (handle + 8))
	  ^ *((int32_t *) (handle + 12)));
}

- (NSString *) description
{
  return [NSString stringWithFormat: @"FileHandle %08x %08x %08x %08x",
	  *((int32_t *) handle), *((int32_t *) (handle + 4)),
	  *((int32_t *) (handle + 8)), *((int32_t *) (handle + 12))];
}

@end
