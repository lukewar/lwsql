//
//  SQLResultSet.h
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLRow.h"

#define SQLRS_NIL_VALUE 3000
#define SQLRS_EMPTY_RESULT_SET 3001
#define SQLRS_EMPTY_RESULT_ROW 3002
#define SQLRS_OUT_OF_BOUNDS 3003
#define SQLRS_NOT_FOUND 3004
#define SQLRS_TYPE_MISSMACH 3005
#define SQLRS_CURSOR_NOT_SET 3006


@interface SQLResultSet : NSObject {
	NSInteger readCurrentRow;
	NSMutableArray* rows;
}
#pragma mark accessing data
- (BOOL) boolAtColumnName:(NSString*)columnName error:(NSError**)error;
- (BOOL) boolAtColumn:(NSInteger)column error:(NSError**)error;

- (int) intAtColumnName:(NSString*)columnName error:(NSError**)error;
- (int) intAtColumn:(NSInteger)column error:(NSError**)error;

- (NSInteger) integerAtColumnName:(NSString*)columnName error:(NSError**)error;
- (NSInteger) integerAtColumn:(NSInteger)column error:(NSError**)error;

- (long long) longLongAtColumnName:(NSString*)columnName error:(NSError**)error;
- (long long) longLongAtColumn:(NSInteger)column error:(NSError**)error;

- (float) floatAtColumnName:(NSString*)columnName error:(NSError**)error;
- (float) floatAtColumn:(NSInteger)column error:(NSError**)error;

- (double) doubleAtColumnName:(NSString*)columnName error:(NSError**)error;
- (double) doubleAtColumn:(NSInteger)column error:(NSError**)error;


- (NSData*) dataAtColumnName:(NSString*)columnName error:(NSError**)error;
- (NSData*) dataAtColumn:(NSInteger)column error:(NSError**)error;

- (NSString*) stringAtColumnName:(NSString*)columnName error:(NSError**)error;
- (NSString*) stringAtColumn:(NSInteger)column error:(NSError**)error;

- (NSDate*) dateAtColumnName:(NSString*)columnName error:(NSError**)error;
- (NSDate*) dateAtColumn:(NSInteger)column error:(NSError**)error;

- (id) objectAtColumnName:(NSString*)columnName error:(NSError**)error;
- (id) objectAtColumn:(NSInteger)column error:(NSError**)error;

#pragma mark inserting data
- (BOOL) insertLongLong:(long long)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;
- (BOOL) insertLongLong:(long long)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;

- (BOOL) insertInteger:(NSInteger)integer forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;
- (BOOL) insertInteger:(NSInteger)integer forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;

- (BOOL) insertFloat:(float)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;
- (BOOL) insertFloat:(float)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;

- (BOOL) insertDouble:(double)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;
- (BOOL) insertDouble:(double)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;

- (BOOL) insertDate:(NSDate*)date forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;
- (BOOL) insertDate:(NSDate*)date forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;

- (BOOL) insertValue:(id)value forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;
- (BOOL) insertValue:(id)value forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error;

#pragma mark navigating
- (NSInteger) findColumn:(NSString*) columnName;
- (BOOL) absolute:(NSInteger)index;

- (BOOL) nextRow;
- (BOOL) peviousRow;
- (BOOL) first;
- (BOOL) last;

- (BOOL) isFirst;
- (BOOL) isLast;
@end
