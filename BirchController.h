/* BirchController */

#import <Cocoa/Cocoa.h>

@interface BirchController : NSApplication
{
  IBOutlet NSPanel *mainPanel;
  IBOutlet NSButton *addButton;
  IBOutlet NSButton *removeButton;
  IBOutlet NSTextField *nameField;
  IBOutlet NSButton *showResults;
  IBOutlet NSComboBox *queryKey;
  IBOutlet NSComboBox *queryType;
  IBOutlet NSTextField *queryValue;
  IBOutlet NSTextField *isMounted;
  IBOutlet NSButton *mountOnLaunch;
  IBOutlet NSProgressIndicator *mountProgress;
  IBOutlet NSButton *mountNow;
  IBOutlet NSTableView *mainTable;
  
  BOOL automount;
  NSString *currentQueryName;
  NSDictionary *currentQueryParams;
  NSDictionary *mdKeys;
  NSArray *mdKeyNames;
  NSArray *mdComparisonsDates;
  NSArray *mdComparisonsNumbers;
  NSArray *mdComparisonsStrings;
  NSArray *mdComparisonsArrays;
  NSMutableArray *queries;
  int selectedQuery;
  BOOL doMountOnLaunch;
  NSUserDefaults *defaults;
  NSLock *queriesLock;
}

- (void) mainTableNotify: (NSNotification *) n;
- (void) updatePanelForSelection;

- (IBAction) tableItemSelected: (id) sender;
- (IBAction) addQueryClicked: (id) sender;
- (IBAction) delQueryClicked: (id) sender;
- (IBAction) enteredQueryName: (id) sender;
- (IBAction) selectedMetadataKey: (id) sender;
- (IBAction) selectedMetadataTest: (id) sender;
- (IBAction) enteredMetadataValue: (id) sender;
- (IBAction) showResultsClicked: (id) sender;
- (IBAction) mountOnLaunchClicked: (id) sender;
- (IBAction) mountNowClicked: (id) sender;

- (void) nfsServerStatusChanged: (id) aServer;
- (NSArray *) queryForName: (NSString *) aName;
- (NSArray *) queryNames;
- (void) newQueryWithName: (NSString *) aName;

- (void) syncDefaults;

// Combo Box methods. These handle both combo boxes in the window.
- (int) numberOfItemsInComboBox: (NSComboBox *) aComboBox;
- (id) comboBox: (NSComboBox *) aComboBox objectValueForItemAtIndex:(int)index;

// Table View methods.
- (id) tableView: (NSTableView *) aTableView
    objectValueForTableColumn: (NSTableColumn *) aTableColumn
                          row: (int) rowIndex;
- (int) numberOfRowsInTableView: (NSTableView *) aTableView;
			  
@end
