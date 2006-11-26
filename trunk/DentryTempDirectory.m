//
//  DentryTempDirectory.m
//  Birch
//
//  Created by C. Scott Marshall on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "DentryTempDirectory.h"


@implementation DentryTempDirectory

- (id) initWithName: (NSString *) aName
             parent: (Dentry *) aParent
             handle: (FileHandle *) aHandle
{
  if ((self = [super initWithName: aName parent: aParent handle: aHandle
               isLeaf: NO predicate: nil]) != nil)
  {
    [self retain];
  }
  
  return self;
}

- (bool) isDir
{
  return YES;
}

- (bool) isFile
{
  return NO;
}

@end
