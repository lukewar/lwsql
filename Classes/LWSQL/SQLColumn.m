//
//  SQLColumn.m
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLColumn.h"


@implementation SQLColumn
@synthesize columnName, columnValue;

- (id) init{
	return nil;
}

- (id) initWithName:(NSString*)colName value:(id)colvalue{
	if(!colName || !colvalue){
		return nil;
	}
	self = [super init];
	if (self != nil) {
		columnName = [colName retain];
		columnValue = [colvalue retain];
	}
	return self;
}

- (NSString *)description{
	return [NSString stringWithFormat:@"%@ : %@", columnName, columnValue];
}

- (void) dealloc{
	[columnName release];
	[columnValue release];
	[super dealloc];
}


@end
