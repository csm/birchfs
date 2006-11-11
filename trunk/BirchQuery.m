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
#import "constants.h"

extern NSDictionary *gMdKeys;

@implementation BirchQuery

- (id) initWithName: (NSString *) aName
             isLeaf: (bool) aBool
          predicate: (NSPredicate *) aPredicate
       subordinates: (NSArray *) anArray
{
  if ((self = [super init]) != nil)
  {
    name = [[NSString alloc] initWithString: aName];
    isLeaf = aBool;
    predicate = [aPredicate copy];
    subordinates = [[NSArray alloc] initWithArray: anArray];
  }
  
  return self;
}

+ (NSPredicate *) predicateForKey: (NSString *) aKey
                             test: (NSString *) aTest
                            value: (NSString *) aValue
{
  NSArray *pair = [gMdKeys objectForKey: aKey];
  if (pair == nil)
  {
    return [NSPredicate predicateWithFormat: @"kMDItemFSName == ':'"];
  }

  //NSLog(@"gMdKeys are %@", gMdKeys);
  //NSLog(@"predicateForKey %@ %@ %@ %@", aKey, aTest, aValue, pair);
  
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
      return nil;
//      return [NSPredicate predicateWithFormat: @"kMDItemFSName like %@", @"*"];
      
    case kBirchMetadataKindArray:
      if ([aTest isEqual: kMDComparisonArrayContains] && [aValue length] > 0)
      {
        test = @"like";
        valPrefix = @"*";
        valSuffix = @"*";
        value = aValue;
        suffix = @"c";
      }
      else if ([aTest isEqual: kMDComparisonArrayNotContains]
               && [aValue length] > 0)
      {
        test = @"!="; // XXX
        valPrefix = @"*";
        valSuffix = @"*";
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
        if ([aValue length] == 0)
        {
          key = @"kMDItemFSName";
          test = @"==";
          value = @":";
        }
        else
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
        if ([aTest isEqual: kMDComparisonStringNotEqual])
        {
          test = @"!=";
          valPrefix = @"";
          valSuffix = @"";
        }
        else if ([aTest isEqual: kMDComparisonStringStarts])
        {
          test = @"like";
          valPrefix = @"";
          valSuffix = @"*";
        }
        else if ([aTest isEqual: kMDComparisonStringEnds])
        {
          test = @"like";
          valPrefix = @"*";
          valSuffix = @"";
        }
        else if ([aTest isEqual: kMDComparisonStringContains])
        {
          test = @"like";
          valPrefix = @"*";
          valSuffix = @"*";
        }
        else
        {
          test = @"==";
          valPrefix = @"";
          valSuffix = @"";
        }
      }
      break;

    case kBirchMetadataKindNumber:
      if ([aValue length] == 0)
      {
        // Choose something always false.
        key = @"kMDItemFSName";
        test = @"==";
        value = @":";      
      }
      else
      {
        value = aValue;
        if ([aTest isEqual: kMDComparisonNumberNotEqual])
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
        else
        {
          test = @"==";
        }
      }
      break;
  }
  
  NSMutableString *mvalue = [NSMutableString stringWithCapacity: [value length]];
  [mvalue appendString: value];
  [mvalue replaceOccurrencesOfString: @"\""
   withString: @"\\\""
   options: 0
   range: NSMakeRange(0, [mvalue length])];
  [mvalue replaceOccurrencesOfString: @"%"
   withString: @"%%"
   options: 0
   range: NSMakeRange(0, [mvalue length])];

  NSLog(@"formatting predicate %@ %@ %@%@%@", key, test, valPrefix,
        value, valSuffix);
  
  return [NSPredicate predicateWithFormat:
//    [NSString stringWithFormat: @"%@ %@ %@%@%@", key, test, valPrefix,
//     mvalue, valSuffix]];
    [NSString stringWithFormat: @"%@ %@ %@", key, test, @"%@"],
    [NSString stringWithFormat: @"%@%@%@", valPrefix, value, valSuffix]];
}

+ (BirchQuery *) queryWithArray: (NSArray *) anArray
{
  NSString *name = [anArray objectAtIndex: 0];
  bool isLeaf = [((NSNumber *) [anArray objectAtIndex: 1]) boolValue];
  NSString *key = [anArray objectAtIndex: 2];
  NSString *test = [anArray objectAtIndex: 3];
  NSString *value = [anArray objectAtIndex: 4];
  NSArray *subordinates = [anArray objectAtIndex: 5];
  
  NSPredicate *predicate = [BirchQuery predicateForKey: key test: test value: value];
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

- (NSPredicate *) predicate
{
  return [[predicate copy] autorelease];
}

- (NSArray *) subordinates
{
  return [NSArray arrayWithArray: subordinates];
}

@end
