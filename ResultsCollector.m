//
//  ResultsCollector.m
//  Birch
//
//  Created by C. Scott Marshall on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ResultsCollector.h"
#import "NFSServer.h"
#import "FileHandle.h"
#import "RunningQuery.h"
#import "BirchQuery.h"

@implementation ResultsCollector

- (id) initWithController: (id) aController
{
  if ((self = [super init]) != nil)
  {
    bc = aController;
  }
  
  return self;
}

- (void) makeQueriesWithDentry: (DentryDirectory *) dir name: (NSString *) aName
  server: (id) aServer
{
#if DEBUG
  NSLog(@"makeQueriesWithDentry: %@ name: %@", [dir path], aName);
#endif // DEBUG
  NFSServer *srv = aServer;
  NSArray *pathComps = [[dir path] pathComponents];
#if DEBUG
  NSLog(@"pathComps = %@ count %d for path %@", pathComps, [pathComps count],
        [dir path]);
#endif // DEBUG
  if ([pathComps count] >= 2)
  {
    pathComps = [pathComps subarrayWithRange: NSMakeRange(2, [pathComps count] - 2)];
  }
  if ([pathComps containsObject: aName])
  {
    return;
  }

  BirchQuery *q = [srv queryForName: aName];
  NSString *path = [[dir path] stringByAppendingPathComponent: aName];
  FileHandle *target = [FileHandle handleWithPath: path];
  DentryDirectory *newdir = (DentryDirectory *) [srv lookup: target];
  
  if (newdir == nil)
  {
    newdir = [[DentryDirectory alloc]
               initWithName: aName
                     parent: dir
                     handle: [FileHandle handleWithPath: path]
                     isLeaf: [q isLeaf]
                  predicate: [q predicate]];
    [newdir autorelease];
    [srv insert: newdir];
  }
  RunningQuery *rq = [srv runningQueryForHandle: target];
#if DEBUG
  NSLog(@"<<>> rq:%@ isLeaf:%d", rq, [newdir isLeaf]);
#endif // DEBUG
  if (rq == nil && [newdir isLeaf])
  {
    NSPredicate *pred = [newdir buildPredicate];
    if (pred != nil)
    {
      rq = [[RunningQuery alloc] initWithCookie: 0 query: q
        predicate: pred];
      [srv insertRunningQuery: rq forHandle: target];
      [rq autorelease];
    }
  }
    
  NSArray *subs = [q subordinates];
#if DEBUG
  NSLog(@"subordinates: %@", subs);
#endif // DEBUG
  int j;
  for (j = 0; j < [subs count]; j++)
  {
    NSString *sub = [subs objectAtIndex: j];
#if DEBUG
    NSLog(@"recursively calling makeQueriesWithDentry for subordinate %@", sub);
#endif // DEBUG
    [self makeQueriesWithDentry: newdir name: sub server: srv];
  }
}

- (void) run: (id) arg
{
  for (;;)
  {
#if DEBUG
    NSLog(@"ResultsCollector loops");
#endif // DEBUG
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NFSServer *srv = [NFSServer server];
    int i;
    NSArray *names = [bc queryNames];
    for (i = 0; i < [names count]; i++)
    {
      NSString *name = [names objectAtIndex: i];
      [self makeQueriesWithDentry: [DentryDirectory root] name: name server: srv];
    }
    
    NSArray *runningQueries = [srv runningQueries];
    for (i = 0; i < [runningQueries count]; i++)
    {
      RunningQuery *q = [runningQueries objectAtIndex: i];
      NSMetadataQuery *mdq = [q query];
      if (mdq == nil)
      {
        continue;
      }
#if DEBUG
      NSLog(@"looking at query %@ started:%d gathering:%d", [mdq predicate],
            [mdq isStarted], [mdq isGathering]);
#endif // DEBUG
      if (![mdq isStarted])
      {
        [mdq startQuery];
      }
      /*if (![mdq isGathering])
      {
        // XXX Is this doing what I expect?
        [mdq stopQuery];
        [mdq startQuery];
      }*/
    }

    NSDate *date = [NSDate date];
#if DEBUG
    NSLog(@"running the run loop");
#endif // DEBUG
    [[NSRunLoop currentRunLoop] runUntilDate:
      [NSDate dateWithTimeIntervalSinceNow: 60]];
#if DEBUG
    NSLog(@"sleeping");
#endif // DEBUG
    [NSThread sleepUntilDate: [date addTimeInterval: 60]];
    [pool release];
  }
}

@end
