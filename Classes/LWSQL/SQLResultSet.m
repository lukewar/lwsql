//
//  SQLResultSet.m
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-12.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLResultSet.h"

@interface SQLResultSet()
- (id) returnHandleWithObject:(id)object assertClass:(Class)class error:(NSError**)error;
- (NSDate*) returnDateHandle:(id)object error:(NSError**)error;

@end


@implementation SQLResultSet
- (id) init{
	self = [super init];
	if (self != nil) {
		readCurrentRow = -1;
		rows = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark Retreving data from ResultSet
- (BOOL) boolAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object boolValue];
	}
	return NO;
}
- (BOOL) boolAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object boolValue];
	}
	return NO;
}

- (int) intAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object intValue];
	}
	return 0;
}
- (int) intAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object intValue];
	}
	return 0;
}

- (NSInteger) integerAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object integerValue];
	}
	return 0;
}
- (NSInteger) integerAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object integerValue];
	}
	return 0;
}

- (long long) longLongAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object longLongValue];
	}
	return 0;
}
- (long long) longLongAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object longLongValue];
	}
	return 0;
}

- (float) floatAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object floatValue];
	}
	return 0;
}
- (float) floatAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object floatValue];
	}
	return 0;
}

- (double) doubleAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object doubleValue];
	}
	return 0;
}
- (double) doubleAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	if([self returnHandleWithObject:object assertClass:[NSNumber class] error:error]){
		return [object doubleValue];
	}
	return 0;
}


- (NSData*) dataAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	return [self returnHandleWithObject:object assertClass:[NSData class] error:error];
}
- (NSData*) dataAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	return [self returnHandleWithObject:object assertClass:[NSData class] error:error];
}

- (NSString*) stringAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	return [self returnHandleWithObject:object assertClass:[NSString class] error:error];
}
- (NSString*) stringAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	return [self returnHandleWithObject:object assertClass:[NSString class] error:error];
}
- (id) returnHandleWithObject:(id)object assertClass:(Class)class error:(NSError**)error{
	if(object){
		if([object isKindOfClass:class]){
			return object;
		}
		if(error){
			NSString* report = [[NSString alloc] initWithFormat:@"Object is not %@ kind, it is %@", class, [object class]];
			*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_TYPE_MISSMACH userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return nil;
	}
	return nil;
}

- (NSDate*) dateAtColumnName:(NSString*)columnName error:(NSError**)error{
	id object = [self objectAtColumnName:columnName error:error];
	return [self returnDateHandle:object error:error];
}
- (NSDate*) dateAtColumn:(NSInteger)column error:(NSError**)error{
	id object = [self objectAtColumn:column error:error];
	return [self returnDateHandle:object error:error];
}
- (NSDate*) returnDateHandle:(id)object error:(NSError**)error{
	if(object){
		if([object isKindOfClass:[NSNumber class]]){
			return [NSDate dateWithTimeIntervalSince1970:[object doubleValue]];
		}
		if(error){
			NSString* report = [[NSString alloc] initWithFormat:@"Object can not be represented as NSDate object."];
			*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_TYPE_MISSMACH userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
	}
	return nil;
}

- (id) objectAtColumnName:(NSString*)columnName error:(NSError**)error{
	NSInteger columnIndex = [self findColumn:columnName];
	if (columnIndex != NSNotFound) {
		return [self objectAtColumn:columnIndex error:error];
	}
	if(error){
		NSString* report = [[NSString alloc] initWithFormat:@"Column with name '%@' does not exists.", columnName];
		*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_NOT_FOUND userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
		[report release];
	}
	return nil;
}
- (id) objectAtColumn:(NSInteger)column error:(NSError**)error{
	if (readCurrentRow >= 0 && readCurrentRow < [rows count]) {
		if(column >= 0 && column < [[rows objectAtIndex:readCurrentRow] count]){
			SQLColumn* tmpColumn = [[rows objectAtIndex:readCurrentRow] columnAtNumber:column];
			if (tmpColumn) {
				return [tmpColumn columnValue]; 
			}
			if(error){
				NSString* report = [[NSString alloc] initWithFormat:@"Nil object at column %i.", column];
				*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_NIL_VALUE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
				[report release];
			}
			return nil;
		}
		if(error){
			if([[rows objectAtIndex:readCurrentRow] count]==0){
				*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_EMPTY_RESULT_ROW userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Empty result row.", @"message", nil]];
			}else{
				NSString* report = [[NSString alloc] initWithFormat:@"Trying to access column %i while values between [0, %i] possibe.", column, [[rows objectAtIndex:readCurrentRow] count]-1];
				*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_OUT_OF_BOUNDS userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
				[report release];
			}
		}
		return nil;
	}
	if(error){
		if(readCurrentRow==-1){
			*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_CURSOR_NOT_SET userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cursor not set at any row. Consider calling \"first\" or \"nextRow\"", @"message", nil]];
		}else if([rows count]==0){
			*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_EMPTY_RESULT_SET userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Empty result row.", @"message", nil]];
		}else{
			NSString* report = [[NSString alloc] initWithFormat:@"Trying to access row %i while values between [0, %i] possibe.", readCurrentRow, [rows count]-1];
			*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_OUT_OF_BOUNDS userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
	}
	return nil;
}

#pragma mark Inserting data to ResultSet
- (BOOL) insertLongLong:(long long)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSNumber* numberObject = [[NSNumber alloc] initWithLongLong:number];
	BOOL returnValue = [self insertValue:numberObject forColumnName:name atRow:row mode:mode error:error];
	[numberObject release];
	return returnValue;
}
- (BOOL) insertLongLong:(long long)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSString* tmpName = [[NSString alloc] initWithUTF8String:nullTerminatedName];
	BOOL returnValue = [self insertLongLong:number forColumnName:tmpName atRow:row mode:mode error:error];
	[tmpName release];
	return returnValue;
}

- (BOOL) insertInteger:(NSInteger)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSNumber* numberObject = [[NSNumber alloc] initWithInteger:number];
	BOOL returnValue = [self insertValue:numberObject forColumnName:name atRow:row mode:mode error:error];
	[numberObject release];
	return returnValue;
}
- (BOOL) insertInteger:(NSInteger)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSString* tmpName = [[NSString alloc] initWithUTF8String:nullTerminatedName];
	BOOL returnValue = [self insertInteger:number forColumnName:tmpName atRow:row mode:mode error:error];
	[tmpName release];
	return returnValue;
}

- (BOOL) insertFloat:(float)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSNumber* numberObject = [[NSNumber alloc] initWithFloat:number];
	BOOL returnValue = [self insertValue:numberObject forColumnName:name atRow:row mode:mode error:error];
	[numberObject release];
	return returnValue;
}
- (BOOL) insertFloat:(float)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSString* tmpName = [[NSString alloc] initWithUTF8String:nullTerminatedName];
	BOOL returnValue = [self insertFloat:number forColumnName:tmpName atRow:row mode:mode error:error];
	[tmpName release];
	return returnValue;
}

- (BOOL) insertDouble:(double)number forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSNumber* numberObject = [[NSNumber alloc] initWithDouble:number];
	BOOL returnValue = [self insertValue:numberObject forColumnName:name atRow:row mode:mode error:error];
	[numberObject release];
	return returnValue;
}
- (BOOL) insertDouble:(double)number forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSString* tmpName = [[NSString alloc] initWithUTF8String:nullTerminatedName];
	BOOL returnValue = [self insertDouble:number forColumnName:tmpName atRow:row mode:mode error:error];
	[tmpName release];
	return returnValue;
}

- (BOOL) insertDate:(NSDate*)date forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSNumber* numberObject = [[NSNumber alloc] initWithDouble:[date timeIntervalSince1970]];
	BOOL returnValue = [self insertValue:numberObject forColumnName:name atRow:row mode:mode error:error];
	[numberObject release];
	return returnValue;
}
- (BOOL) insertDate:(NSDate*)date forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSString* tmpName = [[NSString alloc] initWithUTF8String:nullTerminatedName];
	BOOL returnValue = [self insertDate:date forColumnName:tmpName atRow:row mode:mode error:error];
	[tmpName release];
	return returnValue;
}

- (BOOL) insertValue:(id)value forColumnCName:(const char*)nullTerminatedName atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	NSString* tmpName = [[NSString alloc] initWithUTF8String:nullTerminatedName];
	BOOL returnValue = [self insertValue:value forColumnName:tmpName atRow:row mode:mode error:error];
	[tmpName release];
	return returnValue;
}
- (BOOL) insertValue:(id)value forColumnName:(NSString*)name atRow:(NSUInteger)row mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	if (!value || !name) {
		if (error) {
			NSString* report = [[NSString alloc] initWithString:@"Column name and column value can not be nil or empty."];
			*error = [NSError errorWithDomain:@"SQLResultSet" code:SQLRS_NIL_VALUE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return NO;
	}
	BOOL returnValue = YES;
	SQLColumn* newColumn = [[SQLColumn alloc] initWithName:name value:value];
	
	if (row < [rows count]) {
		SQLRow* tmpRow = [rows objectAtIndex:row];
		if (tmpRow) {
			returnValue &= [tmpRow addColumn:newColumn mode:mode error:error];
		}else {
			SQLRow* newRow = [[SQLRow alloc] init];
			returnValue &= [newRow addColumn:newColumn mode:mode error:error];
			[rows replaceObjectAtIndex:row withObject:newRow];
			[newRow release];
		}
	}else if(row == [rows count]){
		SQLRow* newRow = [[SQLRow alloc] init];
		returnValue &= [newRow addColumn:newColumn mode:mode error:error];
		[rows addObject:newRow];
		[newRow release];
	}else {
		SQLRow* newRow = [[SQLRow alloc] init];
		returnValue &= [newRow addColumn:newColumn mode:mode error:error];
		[rows addObject:newRow];
		[newRow release];
	}
	[newColumn release];
	return returnValue;
}

#pragma mark Navigation
- (NSInteger) findColumn:(NSString*) columnName{
	if(readCurrentRow >= 0 && readCurrentRow<[rows count]){
		int cout = [[rows objectAtIndex:readCurrentRow] count];
		for (int i=0; i<cout; i++){
			SQLColumn* col = [[rows objectAtIndex:readCurrentRow] columnAtNumber:i];
			if(col && [[col columnName] isEqualToString:columnName]){
				return i;
			}
		}
	}
	return NSNotFound;
}
- (BOOL) absolute:(NSInteger)index{
	if (index>=0 && index<[rows count]) {
		readCurrentRow = index;
		return YES;
	}
	return NO;
}
- (BOOL) nextRow{
	if(readCurrentRow != ([rows count]-1)){
		readCurrentRow++;
		return YES;
	}
	return NO;
}
- (BOOL) peviousRow{
	if(readCurrentRow != 0){
		readCurrentRow--;
		return YES;
	}
	return NO;
}
- (BOOL)first{
	if([rows count]>0){
		readCurrentRow = 0;
		return YES;
	}
	return NO;
}
- (BOOL)last{
	if([rows count]>0){
		readCurrentRow = [rows count]-1;
		return YES;
	}
	return NO;
}

- (BOOL) isFirst{
	if([rows count]>0 && (readCurrentRow == 0)){
		return YES;
	}
	return NO;
}
- (BOOL) isLast{
	if([rows count]>0 && (readCurrentRow == ([rows count]-1))){
		return YES;
	}
	return NO;
}

- (NSString *)description{
	return [NSString stringWithFormat:@"%@", rows];
}

- (void) dealloc{
	[rows release];
	[super dealloc];
}



@end
