//
//  HeapBuffer.h
//  Birch
//
//  Created by C. Scott Marshall on 11/3/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// An object wrapping a pointer to temporary memory space. The
// pointer owned by this object is freed (with free) when this
// object is deallocated.
@interface HeapBuffer : NSObject {
  void *pointer;
}

- (id) initWithPointer: (void *) aPointer;

// Creates a new buffer that is added to the autorelease pool.
+ (id) bufferWithPointer: (void *) aPointer;

@end
