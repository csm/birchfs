/* BirchController.m -- 
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

#import "BirchController.h"
#import "NFSServer.h"
#import "BirchMetadataKind.h"
#import "constants.h"

#import <sys/types.h>
#import <sys/stat.h>

@implementation BirchController

NSDictionary *gMdKeys = nil;

static id _e (enum BirchMetadataKind kind)
{
  return [NSNumber numberWithInt: (int) kind];
}

static enum BirchMetadataKind _d (id n)
{
  return (enum BirchMetadataKind) [((NSNumber *) n) intValue];
}

static id mdpair (NSString *str, enum BirchMetadataKind kind)
{
  return [NSArray arrayWithObjects: str, [NSNumber numberWithInt: kind], nil];
}

- (id) init
{
  NSLog(@"init");
  if ((self = [super init]) != nil)
  {
    // FIXME - manage these keys in a plist or something.
    mdKeys = [[NSDictionary dictionaryWithObjectsAndKeys:
      mdpair (@"",                               kBirchMetadataKindWildcard),
        kWildcard,
      //mdpair (@"kMDItemAudience",                kBirchMetadataKindArray),
      //@"Audience",
      mdpair ((NSString *) kMDItemAuthors,                 kBirchMetadataKindArray),
      @"Authors",
      //mdpair (kMDItemCity,                    kBirchMetadataKindString),
      //@"City of origin",
      mdpair ((NSString *) kMDItemComment,                 kBirchMetadataKindString),
        @"Comment",
      mdpair ((NSString *) kMDItemContactKeywords,         kBirchMetadataKindArray),
        @"Contacts",
      mdpair ((NSString *) kMDItemContentType,             kBirchMetadataKindString),
        @"Content type",
      //mdpair (kMDItemContentTypeTree,         kBirchMetadataKindArray),
      //@"Content type tree",
      mdpair ((NSString *) kMDItemContentCreationDate,     kBirchMetadataKindDate),
        @"Creation date",
      mdpair ((NSString *) kMDItemTextContent,             kBirchMetadataKindString),
        @"Content",
      mdpair ((NSString *) kMDItemContributors,            kBirchMetadataKindArray),
        @"Contributors",
      mdpair ((NSString *) kMDItemCopyright,               kBirchMetadataKindString),
        @"Copyright Owner",
      mdpair ((NSString *) kMDItemCountry,                 kBirchMetadataKindString),
        @"Country",
      //mdpair (kMDItemCoverage,                kBirchMetadataKindString),
      //@"Coverage",
      mdpair ((NSString *) kMDItemCreator,                 kBirchMetadataKindString),
        @"Creator",
      mdpair ((NSString *) kMDItemAttributeChangeDate,     kBirchMetadataKindDate),
        @"Date of attribute change",
      mdpair ((NSString *) kMDItemDescription,             kBirchMetadataKindString),
        @"Description",
      mdpair ((NSString *) kMDItemDisplayName,             kBirchMetadataKindString),
        @"Display name",
      mdpair ((NSString *) kMDItemDueDate,                 kBirchMetadataKindDate),
        @"Due date",
      mdpair ((NSString *) kMDItemDurationSeconds,         kBirchMetadataKindNumber),
        @"Duration in seconds",
      mdpair ((NSString *) kMDItemEmailAddresses,          kBirchMetadataKindArray),
        @"Email addresses",
      mdpair ((NSString *) kMDItemEncodingApplications,    kBirchMetadataKindArray),
        @"Encoding applications",
      mdpair ((NSString *) kMDItemFinderComment,           kBirchMetadataKindString),
        @"Finder comment",
      //mdpair (kMDItemFonts,                   kBirchMetadataKindArray),
        //@"Fonts",
      mdpair ((NSString *) kMDItemHeadline,                kBirchMetadataKindString),
        @"Headline",
      mdpair ((NSString *) kMDItemIdentifier,              kBirchMetadataKindString),
        @"Identifer",
      //mdpair (kMDItemInstantMessageAddress,   kBirchMetadataKindArray),
        //@"Instant message address",
      //mdpair (kMDItemInstructions,            kBirchMetadataKindString),
        //@"Instructions",
      mdpair ((NSString *) kMDItemKeywords,                kBirchMetadataKindArray),
        @"Keywords",
      mdpair ((NSString *) kMDItemKind,                    kBirchMetadataKindString),
        @"Kind",
      mdpair ((NSString *) kMDItemLanguages,               kBirchMetadataKindArray),
        @"Languages",
      mdpair ((NSString *) kMDItemContentModificationDate, kBirchMetadataKindDate),
        @"Last modified date",
      mdpair ((NSString *) kMDItemLastUsedDate,            kBirchMetadataKindDate),
        @"Last used date",
      mdpair ((NSString *) kMDItemNumberOfPages,           kBirchMetadataKindNumber),
        @"Number of pages",
      //mdpair (kMDItemOrganizations,           kBirchMetadataKindArray),
        //@"Organizations",
      // kMDItemPageHeight
      // kMDItemPageWidth
      // kMDItemPhoneNumbers
      mdpair ((NSString *) kMDItemProjects,                kBirchMetadataKindArray),
        @"Projects",
      mdpair ((NSString *) kMDItemPublishers,              kBirchMetadataKindArray),
        @"Publishers",
      // kMDItemRecipients
      // kMDItemRights
      // kMDItemSecurityMethod
      mdpair ((NSString *) kMDItemStarRating,              kBirchMetadataKindNumber),
        @"Star rating",
      // kMDItemStateOrProvince
      mdpair ((NSString *) kMDItemTitle,                   kBirchMetadataKindString),
        @"Title",
      mdpair ((NSString *) kMDItemVersion,                 kBirchMetadataKindString),
        @"Version",
      mdpair ((NSString *) kMDItemWhereFroms,              kBirchMetadataKindArray),
        @"Where from",
      mdpair ((NSString *) kMDItemFSName,                  kBirchMetadataKindString),
        @"Name",
      mdpair ((NSString *) kMDItemAlbum,      kBirchMetadataKindString),
        @"Album",
      mdpair ((NSString *) kMDItemFSSize,     kBirchMetadataKindNumber),
        @"Size",
      nil ] retain];
    gMdKeys = mdKeys;
    mdKeyNames = [[[mdKeys allKeys]
                   sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]
		              retain];

    mdComparisonsDates = [[NSArray arrayWithObjects:
      kMDComparisonDateBefore, kMDComparisonDateAfter,
      kMDComparisonDateEqual, nil ] retain];
    mdComparisonsNumbers = [[NSArray arrayWithObjects:
      kMDComparisonNumberEqual, kMDComparisonNumberNotEqual,
      kMDComparisonNumberLessThan, kMDComparisonNumberGreaterThan,
      nil] retain];
    mdComparisonsStrings = [[NSArray arrayWithObjects:
      kMDComparisonStringEqual, kMDComparisonStringNotEqual,
      kMDComparisonStringStarts, kMDComparisonStringEnds,
      kMDComparisonStringContains, nil] retain];
    mdComparisonsArrays = [[NSArray arrayWithObjects:
      kMDComparisonArrayContains, kMDComparisonArrayNotContains,
      nil] retain];

    queries = [[NSMutableArray arrayWithCapacity: 10] retain];
    automount = NO;
    defaults = [[NSUserDefaults standardUserDefaults] retain];
    [defaults registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithBool: NO], kBirchAutomountDefault,
     [NSMutableArray arrayWithCapacity: 10], kBirchQueriesDefault,
     nil]];
    selectedQuery = -1;
    queriesLock = [[NSLock alloc] init];
  }
  
  NSLog(@"init out");
  
  return self;
}

- (void) awakeFromNib
{
  NSLog(@"awaking from nib");
  doMountOnLaunch = [defaults boolForKey: kBirchAutomountDefault];
  if (doMountOnLaunch)
  {
    [mountOnLaunch setState: NSOnState];
    NSLog(@"stub - automount the file system here");
  }
  else
    [mountOnLaunch setState: NSOffState];
  [mainTable deselectAll: self];
  [nameField setEnabled: NO];
  [showResults setEnabled: NO];
  [queryKey setEnabled: NO];
  [queryType setEnabled: NO];
  [queryValue setEnabled: NO];
  [removeButton setEnabled: NO];
  
  NSArray *arr = [defaults arrayForKey: kBirchQueriesDefault];
  int i;
  const int n = [arr count];
  for (i = 0; i < n; i++)
  {
    NSArray *a = [arr objectAtIndex: i];
    NSArray *sub = [a objectAtIndex: 5];
    NSMutableArray *b = [NSMutableArray arrayWithCapacity: [a count]];
    [b addObjectsFromArray: a];
    NSMutableArray *msub = [NSMutableArray arrayWithCapacity: [sub count]];
    [msub addObjectsFromArray: sub];
    [b replaceObjectAtIndex: 5 withObject: msub];
    [queries addObject: b];
  }
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver: self selector:@selector(mainTableNotify:)
   name: NSTableViewSelectionDidChangeNotification object: mainTable];
   
  //MountServer *mountd = [MountServer server];
  //[NSThread detachNewThreadSelector: @selector(runServerLoop:)
  // toTarget: mountd withObject: nil];
   
  NFSServer *server = [NFSServer serverWithController: self];
  [NSThread detachNewThreadSelector: @selector(runServerLoop:)
   toTarget: server withObject: nil];
   
  [mainTable reloadData];
  NSLog(@"awoken!");
}

- (void) mainTableNotify: (NSNotification *) n
{
  NSLog([NSString stringWithFormat: @"notified! %@", n]);
  selectedQuery = [mainTable selectedRow];
  [self updatePanelForSelection];
}

- (void) updatePanelForSelection
{
  if (selectedQuery == -1)
  {
    [nameField setStringValue: @""];
    [nameField setEnabled: NO];
    [showResults setState: NSOffState];
    [showResults setEnabled: NO];
    [queryKey setEnabled: NO];
    [queryType setEnabled: NO];
    [queryValue setEnabled: NO];
    return;
  }

  NSArray *query = [queries objectAtIndex: selectedQuery];
  [nameField setEnabled: YES];
  [nameField setStringValue: (NSString *) [query objectAtIndex: 0]];
  NSLog([NSString stringWithFormat: @"query name %@", query]);

  NSNumber *isLeaf = [query objectAtIndex: 1];
  [showResults setState: ([isLeaf boolValue] ? NSOnState : NSOffState)];
  [showResults setEnabled: YES];
  NSLog([NSString stringWithFormat: @"is leaf %d", [isLeaf intValue]]);
  
  NSString *kind = [query objectAtIndex: 2];
  NSLog([NSString stringWithFormat: @"kind %@", kind]);
  int idx = [mdKeyNames indexOfObject: kind];
  NSLog([NSString stringWithFormat: @"index of that %d", idx]);
  [queryKey selectItemAtIndex: idx];
  [queryKey setEnabled: YES];
  
  if ([kind isEqualToString: kWildcard])
  {
    NSLog(@"clear for wildcard");
    [queryType setEnabled: NO];
    [queryValue setStringValue: @""];
    [queryValue setEnabled: NO];
  }
  else
  {
    [queryType reloadData];
    NSArray *pair = [mdKeys objectForKey: kind];
    if (pair == nil)
    {
      return;
    }
    enum BirchMetadataKind kind = _d([pair objectAtIndex: 1]);
    NSString *test = [query objectAtIndex: 3];
    int idx;
    switch (kind)
    {
      case kBirchMetadataKindWildcard:
	idx = -1;
	break;

      case kBirchMetadataKindArray:
	[queryType setNumberOfVisibleItems: [mdComparisonsArrays count]];
	idx = [mdComparisonsArrays indexOfObject: test];
	break;

      case kBirchMetadataKindDate:
	[queryType setNumberOfVisibleItems: [mdComparisonsDates count]];
	idx = [mdComparisonsArrays indexOfObject: test];
	break;

      case kBirchMetadataKindString:
	[queryType setNumberOfVisibleItems: [mdComparisonsStrings count]];
	idx = [mdComparisonsStrings indexOfObject: test];
	break;

      case kBirchMetadataKindNumber:
	[queryType setNumberOfVisibleItems: [mdComparisonsNumbers count]];
	idx = [mdComparisonsNumbers indexOfObject: test];
	break;
    }
    
    if (idx != -1)
      [queryType selectItemAtIndex: idx];
    else
      {
	idx = [queryType indexOfSelectedItem];
	if (idx != -1)
	  [queryType deselectItemAtIndex: idx];
      }
    [queryType setEnabled: YES];
    
    [queryValue setStringValue: [query objectAtIndex: 4]];
    [queryValue setEnabled: YES];
  }
  
  NSLog(@"enable remove button");
  [removeButton setEnabled: YES];
}

- (IBAction) tableItemSelected: (id) sender
{
  selectedQuery = [mainTable selectedRow];
  [self updatePanelForSelection];
}

static BOOL
nameTaken (NSString *name, NSArray *queries)
{
  int i;
  const int n = [queries count];
  for (i = 0; i < n; i++)
  {
    NSArray *a = [queries objectAtIndex: i];
    if ([name isEqualToString: [a objectAtIndex: 0]])
    {
      return YES;
    }
  }
  return NO;
}

// Valid query names must be valid path names, and thus may not be of
// zero length, may not contain the character '/', and may not equal "."
// or ".."
static BOOL
isValidPathname (NSString *name)
{
  if ([name length] == 0)
    return NO;
  NSRange r = [name rangeOfString: @"/"];
  if (r.location != NSNotFound)
    return NO;
  if ([name isEqual: @"."])
    return NO;
  if ([name isEqual: @".."])
    return NO;
  return YES;
}

- (IBAction) addQueryClicked: (id) sender
{
  NSLog(@"LOCK %@", queriesLock);
  [queriesLock lock];
  NSMutableArray *newQuery = [NSMutableArray arrayWithCapacity: 6];
  NSString *name = @"New Query";
  int i = 1;
  while (nameTaken (name, queries))
    name = [NSString stringWithFormat: @"New Query %d", i++];
  [newQuery addObject: name];
  [newQuery addObject: [NSNumber numberWithBool: NO]];
  [newQuery addObject: kWildcard];
  [newQuery addObject: @""];
  [newQuery addObject: @""];
  [newQuery addObject: [NSMutableArray arrayWithCapacity: 10]];

  [queries addObject: newQuery];
  [mainTable reloadData];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
  
  selectedQuery = [queries count] - 1;
  [mainTable selectRow: selectedQuery byExtendingSelection: NO];
  [self updatePanelForSelection];
  NSLog(@"UNLOCK %@", queriesLock);
  [queriesLock unlock];
}

- (IBAction) delQueryClicked: (id) sender
{
  if (selectedQuery != -1)
  {
    if (selectedQuery < 0 || selectedQuery >= [queries count])
    {
      NSLog(@"invalid query index %d", selectedQuery);
      return;
    }
    NSLog(@"LOCK %@", queriesLock);
    [queriesLock lock];
    NSArray *removed = [queries objectAtIndex: selectedQuery];
    NSString *oldname = [removed objectAtIndex: 0];
    [queries removeObjectAtIndex: selectedQuery];
    [mainTable reloadData];
    [defaults setObject: queries forKey: kBirchQueriesDefault];
    [defaults synchronize];
    
    // FIXME! Dentry cache consistency!!
    int i;
    const int n = [queries count];
    for (i = 0; i < n; i++)
    {
      NSArray *q = [queries objectAtIndex: i];
      NSMutableArray *sub = [q objectAtIndex: 5];
      if ([sub containsObject: oldname])
      {
        [sub removeObject: oldname];
      }
    }
    
    // removal changes selection.
    selectedQuery = [mainTable selectedRow];
    [self updatePanelForSelection];
    NSLog(@"UNLOCK %@", queriesLock);
    [queriesLock unlock];
  }
}

- (IBAction) enteredQueryName: (id) sender
{
  if (selectedQuery == -1)
    return;
  NSLog(@"LOCK %@", queriesLock);
  [queriesLock lock];
  NSString *name = [nameField stringValue];
  NSMutableArray *query = [queries objectAtIndex: selectedQuery];
  NSString *oldname = [query objectAtIndex: 0];

  if ([name isEqualToString: oldname])
  {
    NSLog(@"UNLOCK %@", queriesLock);
    [queriesLock unlock];
    return; // didn't change
  }
  if (nameTaken (name, queries) || !isValidPathname(name))
  {
    NSBeep();
    NSLog(@"UNLOCK %@", queriesLock);
    [queriesLock unlock];
    return;
  }
  
  [query replaceObjectAtIndex: 0 withObject: name];

  // FIXME! this will wreak havoc on cached dentries!!
  int i;
  const int n = [queries count];
  for (i = 0; i < n; i++)
  {
    NSArray *q = [queries objectAtIndex: i];
    NSMutableArray *sub = [q objectAtIndex: 5];
    if ([sub containsObject: oldname])
    {
      [sub removeObject: oldname];
      [sub addObject: name];
    }
  }
  
  [mainTable reloadData];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
  NSLog(@"UNLOCK %@", queriesLock);
  [queriesLock unlock];
}

- (IBAction) selectedMetadataKey: (id) sender
{
  if (selectedQuery == -1)
    return; // XXX bitch about it
  int idx = [queryKey indexOfSelectedItem];
  NSMutableArray *query = [queries objectAtIndex: selectedQuery];
  NSString *key = [mdKeyNames objectAtIndex: idx];
  if ([key isEqualToString: [query objectAtIndex: 2]])
    return; // Did not change.
  [query replaceObjectAtIndex: 2 withObject: [mdKeyNames objectAtIndex: idx]];
  [queryType reloadData];
  if ([key isEqualToString: kWildcard])
  {
    [query replaceObjectAtIndex: 3 withObject: @""];
    [query replaceObjectAtIndex: 4 withObject: @""];
    [queryType setEnabled: NO];
    [queryValue setEnabled: NO];
  }
  else
  {
    NSArray *pair = [mdKeys objectForKey: key];
    switch (_d([pair objectAtIndex: 1]))
    {
      case kBirchMetadataKindWildcard:
        break;

      case kBirchMetadataKindArray:
        [query replaceObjectAtIndex: 3 withObject: kMDComparisonArrayContains];
        break;

      case kBirchMetadataKindDate:
        [query replaceObjectAtIndex: 3 withObject: kMDComparisonDateEqual];
        break;

      case kBirchMetadataKindString:
        [query replaceObjectAtIndex: 3 withObject: kMDComparisonStringEqual];
        break;

      case kBirchMetadataKindNumber:
        [query replaceObjectAtIndex: 3 withObject: kMDComparisonNumberEqual];
        break;
    }
    [queryType setEnabled: YES];
    [queryValue setEnabled: YES];  
  }
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
}

- (IBAction) selectedMetadataTest: (id) sender
{
  if (selectedQuery == -1)
    return;
  int idx = [queryType indexOfSelectedItem];
  NSMutableArray *query = [queries objectAtIndex: selectedQuery];
  NSString *key = [query objectAtIndex: 2];
  NSString *type = nil;
  switch (_d([[mdKeys objectForKey: key] objectAtIndex: 1]))
  {
    case kBirchMetadataKindWildcard:
      break;

    case kBirchMetadataKindArray:
      type = [mdComparisonsArrays objectAtIndex: idx];
      break;

    case kBirchMetadataKindDate:
      type = [mdComparisonsDates objectAtIndex: idx];
      break;

    case kBirchMetadataKindString:
      type = [mdComparisonsStrings objectAtIndex: idx];
      break;

    case kBirchMetadataKindNumber:
      type = [mdComparisonsNumbers objectAtIndex: idx];
      break;
  }
  
  [query replaceObjectAtIndex: 3 withObject: type];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
}

- (IBAction) enteredMetadataValue: (id) sender
{
  if (selectedQuery == -1)
    return;
  NSMutableArray *query = [queries objectAtIndex: selectedQuery];
  [query replaceObjectAtIndex: 4 withObject: [queryValue stringValue]];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
}

- (IBAction) showResultsClicked: (id) sender
{
  if (selectedQuery == -1)
    return;
  NSMutableArray *query = [queries objectAtIndex: selectedQuery];
  [query replaceObjectAtIndex: 1
   withObject: [NSNumber numberWithBool: ([showResults state] == NSOnState)]];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
}

- (IBAction) mountOnLaunchClicked: (id) sender
{
  [defaults setBool: ([mountOnLaunch state] == NSOnState)
   forKey: kBirchAutomountDefault];
  [defaults synchronize];
}

- (void) mountIt
{
  if (isMounting)
    return;
  isMounting = YES;
  [mountProgress setUsesThreadedAnimation: YES];
  [mountProgress startAnimation: self];
  struct stat st;
  if (stat ("/tmp/BirchMount", &st) == 0)
  {
    if ((st.st_mode & S_IFMT) != S_IFDIR)
    {
      NSLog(@"ERROR! /tmp/BirchMount not a directory!");
      [mountProgress stopAnimation];
      isMounting = NO;
      return;
    }
  }
  else
  {
    mkdir ("/tmp/BirchMount", 0755);
  }
  NSTask *task = [NSTask launchedTaskWithLaunchPath: @"/sbin/mount_nfs"
    arguments: [NSArray arrayWithObjects: @"-2", @"localhost:/Birch",
      @"/tmp/BirchMount", nil ]];
  [task waitUntilExit];
  int ret = [task teminationStatus];
  if (ret != 0)
  {
    NSLog(@"mount_nfs returned with status %d", ret);
    isMounting = NO;
    return;
  }
  
  task = [NSTask launchedTaskWithLaunchPath: @"/usr/bin/open"
    arguments: [NSArray arrayWithObjects: @"/tmp/BirchMount"]];
  [task waitUntilExit];
  [mountProgress stopAnimation: self];
  isMounting = NO;
}

- (IBAction) mountNowClicked: (id) sender
{
  [self mountIt];
}

- (void) nfsServerStatusChanged: (id) aServer
{
  switch ([aServer state])
  {
    case NFSServerNotStarted:
      [isMounted setStringValue: @"File server has not been started."];
      break;
      
    case NFSServerStarting:
      [isMounted setStringValue: @"File server starting."];
      break;
      
    case NFSServerRunning:
      [isMounted setStringValue: @"File server running."];
      [mountNow setEnabled: YES];
      break;
      
    case NFSServerExited:
      [isMounted setStringValue: @"File server has exited!"];
      [isMounted setTextColor: [NSColor redColor]];
      [mountNow setEnabled: NO];
      break;
      
    case NFSServerMounted:
      [isMounted setStringValue: @"File system mounted."];
      [mountNow setEnabled: NO];
      break;
  }
}

- (NSArray *) queryForName: (NSString *) aName
{
  int i;
  const int n = [queries count];
  for (i = 0; i < n; i++)
  {
    NSArray *a = [queries objectAtIndex: i];
    NSString *s = [a objectAtIndex: 0];
    if ([aName isEqual: s])
    {
      return a;
    }
  }
  return nil;
}

- (NSArray *) queryNames
{
  NSLog(@"LOCK %@", queriesLock);
  [queriesLock lock];
  int i;
  const int n = [queries count];
  NSMutableArray *list = [NSMutableArray arrayWithCapacity: n];

  for (i = 0; i < n; i++)
  {
    NSArray *a = (NSArray *) [queries objectAtIndex: i];
    [list addObject: [a objectAtIndex: 0]];
  }
  
  NSLog(@"UNLOCK %@", queriesLock);
  [queriesLock unlock];
  return list;
}

- (void) newQueryWithName: (NSString *) aName
{
  NSLog(@"LOCK %@", queriesLock);
  [queriesLock lock];
  int i;
  const int n = [queries count];
  
  for (i = 0; i < n; i++)
  {
    NSArray *a = [queries objectAtIndex: i];
    if ([[a objectAtIndex: 0] isEqual: aName])
    {
      [queriesLock unlock];
      return;
    }
  }
  
  NSMutableArray *newQuery = [NSMutableArray arrayWithCapacity: 6];
  [newQuery addObject: aName];
  [newQuery addObject: [NSNumber numberWithBool: NO]];
  [newQuery addObject: kWildcard];
  [newQuery addObject: @""];
  [newQuery addObject: @""];
  [newQuery addObject: [NSMutableArray arrayWithCapacity: 10]];
  [queries addObject: newQuery];
  
  NSLog(@"UNLOCK %@", queriesLock);
  [queriesLock unlock];
}

- (void) syncDefaults
{
  [defaults synchronize];
}

- (int) numberOfItemsInComboBox: (NSComboBox *) aComboBox
{
  if (aComboBox == queryKey)
  {
    return [mdKeyNames count];
  }
  else if (aComboBox == queryType)
  {
    if (selectedQuery == -1)
      return 0;

    NSLog([NSString stringWithFormat: @"queries %@", queries]);
    NSArray *query = [queries objectAtIndex: selectedQuery];
    NSArray *pair = [mdKeys objectForKey: [query objectAtIndex: 2]];
    if (pair == nil)
    {
      return 0;
    }
    enum BirchMetadataKind kind = _d([pair objectAtIndex: 1]);
    switch (kind)
    {
      case kBirchMetadataKindWildcard:
	return 0;

      case kBirchMetadataKindArray:
	return [mdComparisonsArrays count];

      case kBirchMetadataKindDate:
	return [mdComparisonsDates count];

      case kBirchMetadataKindString:
	return [mdComparisonsStrings count];

      case kBirchMetadataKindNumber:
	return [mdComparisonsNumbers count];
    }
  }
  return -1;
}

- (id) comboBox: (NSComboBox *) aComboBox objectValueForItemAtIndex:(int)index
{
  if (aComboBox == queryKey)
  {
    return [mdKeyNames objectAtIndex: index];
  }
  else if (aComboBox == queryType)
  {
    if (selectedQuery == -1)
      return 0;

    NSArray *query = [queries objectAtIndex: selectedQuery];
    NSArray *pair = [mdKeys objectForKey: [query objectAtIndex: 2]];
    if (pair == nil)
    {
      return nil;
    }
    enum BirchMetadataKind kind = _d([pair objectAtIndex: 1]);
    switch (kind)
    {
      case kBirchMetadataKindWildcard:
	return nil;

      case kBirchMetadataKindArray:
	return [mdComparisonsArrays objectAtIndex: index];

      case kBirchMetadataKindDate:
	return [mdComparisonsDates objectAtIndex: index];

      case kBirchMetadataKindString:
	return [mdComparisonsStrings objectAtIndex: index];

      case kBirchMetadataKindNumber:
	return [mdComparisonsNumbers objectAtIndex: index];
    }
  }
  return nil;
}

- (id) tableView: (NSTableView *) aTableView
    objectValueForTableColumn: (NSTableColumn *) aTableColumn
                          row: (int) rowIndex
{
  NSArray *query = [queries objectAtIndex: rowIndex];
  return [query objectAtIndex: 0];
}

- (int) numberOfRowsInTableView: (NSTableView *) aTableView
{
  return [queries count];
}

@end
