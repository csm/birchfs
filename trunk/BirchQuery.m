/* BirchQuery.m
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

#import "BirchQuery.h"
#import "BirchMetadataKind.h"

extern const NSString *kWildcard;

extern const NSString *kMDComparisonDateBefore;
extern const NSString *kMDComparisonDateAfter;
extern const NSString *kMDComparisonDateEqual;

extern const NSString *kMDComparisonNumberEqual;
extern const NSString *kMDComparisonNumberNotEqual;
extern const NSString *kMDComparisonNumberLessThan;
extern const NSString *kMDComparisonNumberGreaterThan;

extern const NSString *kMDComparisonStringEqual;
extern const NSString *kMDComparisonStringNotEqual;
extern const NSString *kMDComparisonStringStarts;
extern const NSString *kMDComparisonStringEnds;
extern const NSString *kMDComparisonStringContains;

extern const NSString *kMDComparisonArrayContains;
extern const NSString *kMDComparisonArrayNotContains;

extern NSDictionary *gMdKeys;

@implementation BirchQuery

- (id) initWithName: (NSString *) aName
             isLeaf: (bool) aBool
          predicate: (NSString *) aPredicate
       subordinates: (NSArray *) anArray
{
  if ((self = [super init]) != nil)
  {
    name = [[NSString alloc] initWithName: aName];
    isLeaf = aBool;
    predicate = [[NSString alloc] initWithName: aPredicate];
    subordinates = [[NSArray alloc] initWithArray: anArray];
  }
  
  return self;
}

+ (NSString *) predicateForKey: (NSString *) aKey
  test: (NSString *) aTest
  value: (NSString *) aValue
{
  NSArray *pair = [gMdKeys objectForKey: aKey];
  if (pair == nil)
  {
    return @"kMDItemFSName == ':'";
  }
  
  enum BirchMetadataKind kind = (enum BirchMetadataKind)
    [((NSNumber *) [pair objectAtIndex: 1]) intValue];
  NSString *key = [pair objectAtIndex: 0];
  NSString *test = @"==";
  NSString *valPrefix = @"";
  NSString *valSuffix = @"";
  NSString *value = @":";
  NSString *suffix = @"";

  switch (kind)
  {
    case kBirchMetadataKindWildcard:
      return @"kMDItemFSName == '*'";
      
    case kBirchMetadataKindArray:
      if ([aTest isEqual: kMDComparisonArrayContains] && [aValue length] > 0)
      {
	test = @"==";
	valPrefix = @"\"*";
	valSuffix = @"*\"";
	value = aValue;
	suffix = @"c";
      }
      else if ([aTest isEqual: kMDComparisonArrayNotContains]
               && [aValue length] > 0)
      {
	test = @"!=";
	valPrefix = @"\"*";
	valSuffix = @"*\"";
	value = aValue;
	suffix = @"c";
      }
      else
      {
	// Choose something always false.
	key = @"kMDItemFSName";
	test = @"==";
	value = @":";
      }
      break;
    
    case kBirchMetadataKindDate:
      {
	NSDate *date = [NSDate dateWithNaturalLanguageString: aValue];
	NSTimeInterval seconds = [date timeIntervalSince1970];
	value = [NSString stringWithFormat: @"%f", seconds];
	
	if ([aTest isEqual: kMDComparisonDateBefore])
	{
	  test = @"<";
	}
	else if ([aTest isEqual: kMDComparisonDateAfter])
	{
	  test = @">";
	}
	else
	{
	  test = @"==";
	}
      }
      break;

    case kBirchMetadataKindString:
      if ([aValue length] == 0)
      {
	// Choose something always false.
	key = @"kMDItemFSName";
	test = @"==";
	value = @":";      
      }
      else
      {
	suffix = @"c";
	value = aValue;
	if ([aTest isEqual: kMDComparisonStringEqual])
	{
	  test = @"==";
	}
	else if ([aTest isEqual: kMDComparisonStringNotEqual])
	{
	  test = @"!=";
	}
	else if ([aTest isEqual: kMDComparisonStringStarts])
	{
	  test = @"==";
	  valSuffix = @"*";
	}
	else if ([aTest isEqual: kMDComparisonStringEnds])
	{
	  test = @"==";
	  valPrefix = @"*";
	}
	else if ([aTest isEqual: kMDComparisonStringContains])
	{
	  test = @"==";
	  valPrefix = @"*";
	  valSuffix = @"*";
	}
      }
      break;

    case kBirchMetadataKindNumber:
      value = aValue;
      if ([aTest isEqual: kMDComparisonNumberEqual])
      {
	test = @"==";
      }
      else if ([aTest isEqual: kMDComparisonNumberNotEqual])
      {
	test = @"!=";
      }
      else if ([aTest isEqual: kMDComparisonNumberLessThan])
      {
	test = @"<";
      }
      else if ([aTest isEqual: kMDComparisonNumberGreaterThan])
      {
	test = @">";
      }
      break;
  }
  
  return [NSString stringWithFormat: @"%@ %@ \"%@%@%@\"%@", key, test, valPrefix,
          value, valSuffix, suffix];
}

+ (BirchQuery *) queryWithArray: (NSArray *) anArray
{
  NSString *name = [anArray objectAtIndex: 0];
  bool isLeaf = [((NSNumber *) [anArray objectAtIndex: 1]) boolValue];
  NSString *key = [anArray objectAtIndex: 2];
  NSString *test = [anArray objectAtIndex: 3];
  NSString *value = [anArray objectAtIndex: 4];
  NSArray *subordinates = [anArray objectAtIndex: 5];
  
  NSString *predicate = [BirchQuery predicateForKey: key test: test value: value];
  BirchQuery *query = [[BirchQuery alloc] initWithName: name isLeaf: isLeaf
    predicate: predicate subordinates: subordinates];
  return [query autorelease];
}

- (void) dealloc
{
  [name release];
  [predicate release];
  [subordinates release];
  [super dealloc];
}

- (NSString *) name
{
  return [NSString stringWithString: name];
}

- (bool) isLeaf
{
  return isLeaf;
}

- (NSString *) predicate
{
  return [NSString stringWithString: predicate];
}

- (NSArray *) subordinates
{
  return [NSArray arrayWithArray: subordinates];
}

@end
