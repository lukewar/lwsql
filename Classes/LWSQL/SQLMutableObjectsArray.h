//
//  SQLObjectsList.h
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQLMutableObjectsArray : NSObject {
	NSMutableArray* objects;
}
- (id) objectAtIndex:(NSUInteger)index;
- (NSUInteger) count;

- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void) removeObject:(id)anObject;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) removeLastObject;
- (void) removeAllObjects;

@end
