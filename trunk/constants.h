/* constants.h -- 
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

#define kWildcard @"All files (perform no test)"

#define kBirchAutomountDefault @"automount"
#define kBirchQueriesDefault   @"queries"

#define kMDComparisonDateBefore @"Is before"
#define kMDComparisonDateAfter  @"Is after"
#define kMDComparisonDateEqual  @"Is"

#define kMDComparisonNumberEqual       @"Equals"
#define kMDComparisonNumberNotEqual    @"Does not equal"
#define kMDComparisonNumberLessThan    @"Is less than"
#define kMDComparisonNumberGreaterThan @"Is greater than"

// FIXME, add a damn control for toggling case insensitivity.
#define kMDComparisonStringEqual    @"Is"
#define kMDComparisonStringNotEqual @"Is not"
#define kMDComparisonStringStarts   @"Starts with"
#define kMDComparisonStringEnds     @"Ends with"
#define kMDComparisonStringContains @"Contains"

#define kMDComparisonArrayContains    @"Contains"
#define kMDComparisonArrayNotContains @"Does not contain"
