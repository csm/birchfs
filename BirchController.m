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
#import "MountServer.h"
#import "BirchMetadataKind.h"

@implementation BirchController

const NSString *kWildcard = @"All files (perform no test)";

const NSString *kBirchAutomountDefault = @"automount";
const NSString *kBirchQueriesDefault = @"queries";

const NSString *kMDComparisonDateBefore = @"Is before";
const NSString *kMDComparisonDateAfter  = @"Is after";
const NSString *kMDComparisonDateEqual  = @"Is";

const NSString *kMDComparisonNumberEqual       = @"Equals";
const NSString *kMDComparisonNumberNotEqual    = @"Does not equal";
const NSString *kMDComparisonNumberLessThan    = @"Is less than";
const NSString *kMDComparisonNumberGreaterThan = @"Is greater than";

// FIXME, add a damn control for toggling case insensitivity.
const NSString *kMDComparisonStringEqual    = @"Is";
const NSString *kMDComparisonStringNotEqual = @"Is not";
const NSString *kMDComparisonStringStarts   = @"Starts with";
const NSString *kMDComparisonStringEnds     = @"Ends with";
const NSString *kMDComparisonStringContains = @"Contains";

const NSString *kMDComparisonArrayContains    = @"Contains";
const NSString *kMDComparisonArrayNotContains = @"Does not contain";

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
      mdpair (nil,                               kBirchMetadataKindWildcard),
	kWildcard,
      //mdpair (@"kMDItemAudience",                kBirchMetadataKindArray),
	//@"Audience",
      mdpair (@"kMDItemAuthors",                 kBirchMetadataKindArray),
	@"Authors",
      //mdpair (@"kMDItemCity",                    kBirchMetadataKindString),
	//@"City of origin",
      mdpair (@"kMDItemComment",                 kBirchMetadataKindString),
	@"Comment",
      mdpair (@"kMDItemContactKeywords",         kBirchMetadataKindArray),
	@"Contacts",
      mdpair (@"kMDItemContentType",             kBirchMetadataKindString),
	@"Content type",
      //mdpair (@"kMDItemContentTypeTree",         kBirchMetadataKindArray),
        //@"Content type tree",
      mdpair (@"kMDItemContentCreationDate",     kBirchMetadataKindDate),
	@"Creation date",
      mdpair (@"kMDItemTextContent",             kBirchMetadataKindString),
        @"Content",
      mdpair (@"kMDItemContributors",            kBirchMetadataKindArray),
        @"Contributors",
      mdpair (@"kMDItemCopyright",               kBirchMetadataKindString),
        @"Copyright Owner",
      mdpair (@"kMDItemCountry",                 kBirchMetadataKindString),
        @"Country",
      //mdpair (@"kMDItemCoverage",                kBirchMetadataKindString),
        //@"Coverage",
      mdpair (@"kMDItemCreator",                 kBirchMetadataKindString),
        @"Creator",
      mdpair (@"kMDItemAttributeChangeDate",     kBirchMetadataKindDate),
	@"Date of attribute change",
      mdpair (@"kMDItemDescription",             kBirchMetadataKindString),
        @"Description",
      mdpair (@"kMDItemDisplayName",             kBirchMetadataKindString),
        @"Display name",
      mdpair (@"kMDItemDueDate",                 kBirchMetadataKindDate),
        @"Due date",
      mdpair (@"kMDItemDurationSeconds",         kBirchMetadataKindNumber),
        @"Duration in seconds",
      mdpair (@"kMDItemEmailAddresses",          kBirchMetadataKindArray),
        @"Email addresses",
      mdpair (@"kMDItemEncodingApplications",    kBirchMetadataKindArray),
        @"Encoding applications",
      mdpair (@"kMDItemFinderComment",           kBirchMetadataKindString),
        @"Finder comment",
      //mdpair (@"kMDItemFonts",                   kBirchMetadataKindArray),
        //@"Fonts",
      mdpair (@"kMDItemHeadline",                kBirchMetadataKindString),
        @"Headline",
      mdpair (@"kMDItemIdentifier",              kBirchMetadataKindString),
	@"Identifer",
      //mdpair (@"kMDItemInstantMessageAddress",   kBirchMetadataKindArray),
        //@"Instant message address",
      //mdpair (@"kMDItemInstructions",            kBirchMetadataKindString),
        //@"Instructions",
      mdpair (@"kMDItemKeywords",                kBirchMetadataKindArray),
        @"Keywords",
      mdpair (@"kMDItemKind",                    kBirchMetadataKindString),
        @"Kind",
      mdpair (@"kMDItemLanguages",               kBirchMetadataKindArray),
        @"Languages",
      mdpair (@"kMDItemContentModificationDate", kBirchMetadataKindDate),
	@"Last modified date",
      mdpair (@"kMDItemLastUsedDate",            kBirchMetadataKindDate),
        @"Last used date",
      mdpair (@"kMDItemNumberOfPages",           kBirchMetadataKindNumber),
        @"Number of pages",
      //mdpair (@"kMDItemOrganizations",           kBirchMetadataKindArray),
        //@"Organizations",
      // kMDItemPageHeight
      // kMDItemPageWidth
      // kMDItemPhoneNumbers
      mdpair (@"kMDItemProjects",                kBirchMetadataKindArray),
        @"Projects",
      mdpair (@"kMDItemPublishers",              kBirchMetadataKindArray),
        @"Publishers",
      // kMDItemRecipients
      // kMDItemRights
      // kMDItemSecurityMethod
      mdpair (@"kMDItemStarRating",              kBirchMetadataKindNumber),
        @"Star rating",
      // kMDItemStateOrProvince
      mdpair (@"kMDItemTitle",                   kBirchMetadataKindString),
        @"Title",
      mdpair (@"kMDItemVersion",                 kBirchMetadataKindString),
        @"Version",
      mdpair (@"kMDItemWhereFroms",              kBirchMetadataKindArray),
        @"Where from",
      mdpair (@"kMDItemFSName",                  kBirchMetadataKindString),
        @"Name",
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
    NSMutableArray *b = [NSMutableArray arrayWithCapacity: [a count]];
    [b addObjectsFromArray: a];
    [queries addObject: b];
  }
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver: self selector:@selector(mainTableNotify:)
   name: NSTableViewSelectionDidChangeNotification object: mainTable];
   
  MountServer *mountd = [MountServer server];
  [NSThread detachNewThreadSelector: @selector(runServerLoop:)
   toTarget: mountd withObject: nil];
   
  NFSServer *server = [NFSServer serverWithController: self];
  [NSThread detachNewThreadSelector: @selector(runServerLoop:)
   toTarget: server withObject: nil];
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
// zero length, and may not contain the character '/'.
static BOOL
isValidPathname (NSString *name)
{
  if ([name length] == 0)
    return NO;
  NSRange r = [name rangeOfString: @"/"];
  if (r.location != NSNotFound)
    return NO;
  return YES;
}

- (IBAction) addQueryClicked: (id) sender
{
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
  [newQuery addObject: [NSArray array]];

  [queries addObject: newQuery];
  [mainTable reloadData];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
  
  selectedQuery = [queries count] - 1;
  [mainTable selectRow: selectedQuery byExtendingSelection: NO];
  [self updatePanelForSelection];
}

- (IBAction) delQueryClicked: (id) sender
{
  if (selectedQuery != -1)
  {
    [queries removeObjectAtIndex: selectedQuery];
    [mainTable reloadData];
    [defaults setObject: queries forKey: kBirchQueriesDefault];
    [defaults synchronize];
    
    // removal changes selection.
    selectedQuery = [mainTable selectedRow];
    [self updatePanelForSelection];
  }
}

- (IBAction) enteredQueryName: (id) sender
{
  if (selectedQuery == -1)
    return;
  NSString *name = [nameField stringValue];
  NSMutableArray *query = [queries objectAtIndex: selectedQuery];

  if ([name isEqualToString: [query objectAtIndex: 0]])
  {
    return; // didn't change
  }
  if (nameTaken (name, queries) || !isValidPathname(name))
  {
    NSBeep();
    return;
  }
    
  [query replaceObjectAtIndex: 0 withObject: name];
  [mainTable reloadData];
  [defaults setObject: queries forKey: kBirchQueriesDefault];
  [defaults synchronize];
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
  NSArray *query = [queries objectAtIndex: selectedQuery];
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

- (IBAction) mountNowClicked: (id) sender
{
  NSLog(@"stub - mountNowClicked");
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
  int i;
  NSMutableArray *list = [NSMutableArray arrayWithCapacity: [queries count]];

  for (i = 0; i < [queries count]; i++)
  {
    NSArray *a = (NSArray *) [queries objectAtIndex: i];
    [list addObject: [a objectAtIndex: 0]];
  }
  
  return list;
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
