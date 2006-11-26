//
//  ResultsCollector.h
//  Birch
//
//  Created by C. Scott Marshall on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DentryDirectory.h"

@interface ResultsCollector : NSObject {
  id bc;
}

- (id) initWithController: (id) aController;

- (void) makeQueriesWithDentry: (DentryDirectory *) dir
  name: (NSString *) aName
  server: (id) srv; 
- (void) run: (id) arg;

@end
