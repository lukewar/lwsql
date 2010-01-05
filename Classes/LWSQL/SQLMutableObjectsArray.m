//
//  SQLObjectsList.m
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLMutableObjectsArray.h"


@implementation SQLMutableObjectsArray
- (id) init{
	self = [super init];
	if (self != nil) {
		objects = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) objectAtIndex:(NSUInteger)index{
	return [objects objectAtIndex:index];
}

- (NSUInteger) count{
	return [objects count];
}

- (void)addObject:(id)anObject{
	if(anObject){
		[objects addObject:anObject];
	}else {
		[objects addObject:[NSNull null]];
	}
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
	if (anObject) {
		[objects insertObject:anObject atIndex:index];
	}else {
		[objects insertObject:[NSNull null] atIndex:index];
	}
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
	if (anObject) {
		[objects replaceObjectAtIndex:index withObject:anObject];
	}else {
		[objects replaceObjectAtIndex:index withObject:[NSNull null]];
	}
}

- (void) removeObject:(id)anObject{
	[objects removeObject:anObject];
}

- (void) removeObjectAtIndex:(NSUInteger)index{
	[objects removeObjectAtIndex:index];
}

- (void) removeLastObject{
	[objects removeLastObject];
}

- (void)removeAllObjects{
	[objects removeAllObjects];
}

- (NSString *)description{
	return [NSString stringWithFormat:@"%@", objects];
}

- (void) dealloc{
	[objects release];
	[super dealloc];
}

@end
