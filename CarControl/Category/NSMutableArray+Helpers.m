//
//  NSMutableArray+Helpers.m
//  CarControl
//
//  Created by Dan Attali on 12/25/13.
//  Copyright (c) 2013 Dan Attali. All rights reserved.
//

#import "NSMutableArray+Helpers.h"

@implementation NSMutableArray (Helpers)

- (NSMutableArray *) shuffled
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
    
	for (id anObject in self)
	{
		NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
    
	return tmpArray;
}

@end
