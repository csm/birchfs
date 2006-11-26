//
//  DentryTempDirectory.h
//  Birch
//
//  Created by C. Scott Marshall on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DentryDirectory.h"

@interface DentryTempDirectory : DentryDirectory {
}

- (id) initWithName: (NSString *) aName
             parent: (Dentry *) aParent
             handle: (FileHandle *) aHandle;

@end
