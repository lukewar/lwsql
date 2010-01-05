//
//  SQLRow.m
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLRow.h"

@interface SQLRow()
- (NSInteger) indexOfRecordForColumnName:(NSString*)columnName;

@end


@implementation SQLRow
- (id) init{
	self = [super init];
	if (self != nil) {
		columns = [[NSMutableArray alloc] init];
	}
	return self;
}
- (BOOL) addColumn:(SQLColumn*)column mode:(SQLRowInsertionMode)mode error:(NSError**)error{
	if(column){
		NSInteger index = [self indexOfRecordForColumnName:[column columnName]];
		if (index != -1) {
			switch (mode) {
				case SQLRowInsertionModeReplace:
					[columns replaceObjectAtIndex:index withObject:column];
					return YES;
					break;
				case SQLRowInsertionModeDontReplace:{
					if(error){
						NSString* report = [[NSString alloc] initWithString:@"Attempt of valye replacing in SQLRowInsertionModeDontReplace mode."];
						*error = [NSError errorWithDomain:@"SQLRow" code:4201 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
						[report release];
					}
					return NO;
				}
					break;
				default:
					break;
			}
		}else{
			[columns addObject:column];
			return YES;
		}
	}
	if(error){
		NSString* report = [[NSString alloc] initWithString:@"SQLColumn obiect can not be nil."];
		*error = [NSError errorWithDomain:@"SQLRow" code:4200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
		[report release];
	}
	return NO;
}

- (NSInteger) indexOfRecordForColumnName:(NSString*)columnName{
	NSInteger index = 0;
	for(SQLColumn* columnRecord in columns){
		if([[columnRecord columnName] isEqualToString:columnName]){
			return index;
		}
		index++;
	}
	return -1;
}

- (NSString *)description{
	return [NSString stringWithFormat:@"%@", columns];
}
- (SQLColumn*) columnAtNumber:(NSUInteger)column{
	return [columns objectAtIndex:column];
}

- (NSUInteger) count{
	return [columns count];
}

- (void) dealloc{
	[columns release];
	[super dealloc];
}

@end
