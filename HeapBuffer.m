//
//  HeapBuffer.m
//  Birch
//
//  Created by C. Scott Marshall on 11/3/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "HeapBuffer.h"
#import <stdlib.h>

@implementation HeapBuffer

- (id) initWithPointer: (void *) aPointer
{
  if ((self = [super init]) != nil)
  {
    pointer = aPointer;
  }
  
  return self;
}

+ (id) bufferWithPointer: (void *) aPointer
{
  HeapBuffer *buffer = [[HeapBuffer alloc] initWithPointer: aPointer];
  return [buffer autorelease];
}

- (void) dealloc
{
  if (pointer != NULL)
  {
    free (pointer);
  }
  [super dealloc];
}

@end
