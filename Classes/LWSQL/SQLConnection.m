//
//  LWSql.m
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLConnection.h"
#include <math.h>

@implementation SQLConnection
@synthesize databasePath;

- (id) initWithDatabaseName:(NSString*) dbName{
	self = [super init];
	if (self != nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *sqliteDirPath = [[NSString alloc] initWithFormat:@"%@/%@",documentsDirectory, @"sqlite"];
		NSString *dbPath = [[NSString alloc] initWithFormat:@"%@/%@", sqliteDirPath, dbName];
		
		NSFileManager* fm = [NSFileManager defaultManager];
		BOOL isDir;
		if(![fm fileExistsAtPath:sqliteDirPath isDirectory:&isDir] || !isDir){
			if([fm createDirectoryAtPath:sqliteDirPath attributes:nil]){
				[self setDatabasePath:dbPath];
			}
		}else {
			[self setDatabasePath:dbPath];
		}
		[sqliteDirPath release];
		[dbPath release];
		state = StateClosed;
	}
	return self;
}

- (id) initWithDatabaseFilePath:(NSString*) path{
	self = [super init];
	if (self != nil) {
		NSString* pathDir = [path stringByDeletingLastPathComponent];
		NSFileManager* fm = [NSFileManager defaultManager];
		BOOL isDir;
		if(![fm fileExistsAtPath:pathDir isDirectory:&isDir] || !isDir){
			if([fm createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil]){
				if([fm createFileAtPath:path contents:nil attributes:nil]){
					[self setDatabasePath:path];
				}
			}
		}else {
			[self setDatabasePath:path];
		}
		state = StateClosed;
	}
	return self;
}

#pragma mark Opening and Closing DB
- (BOOL) openDatabaseWithError:(NSError**)error{	
	if(databasePath){
		if (databaseObject == NULL) {
			int retCode = sqlite3_open([databasePath UTF8String], &databaseObject);
			if (retCode != SQLITE_OK) {
				if (error) {
					NSString* report = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(databaseObject)];
					*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_OPENNING_ERROR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
					[report release];
				}
				sqlite3_close(databaseObject);
				return NO;
			}
			state = StateOpen;
		}else {
			if (error) {
				NSString* report = [[NSString alloc] initWithString:@"Can not assign two databases to one object, consider closing previous database before opening new one."];
				*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_DATABASE_OVERWRITE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
				[report release];
			}
			return NO;
		}
	}else{
		if (error) {
			NSString* report = [[NSString alloc] initWithString:@"No data base name set to open."];
			*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_NO_DB_NAME userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return NO;
	}
	return YES;
}

- (BOOL) closeDatabaseWithError:(NSError**)error{
	if (databaseObject !=  NULL) {
		sqlite3_close(databaseObject);
		databaseObject = NULL;
	}else {
		if (error) {
			NSString* report = [[NSString alloc] initWithString:@"You have to open database first."];
			*error = [NSError errorWithDomain:@"SQLConnection" code:SQL_CLOSED_DATABASE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return NO;
	}
	state = StateClosed;
	return YES;
}

- (BOOL) isOpened{
	if (state == StateOpen) {
		return YES;
	}
	return NO;
}

#pragma mark Operations on DB
//Usefull for executing queres with no return like INSERT, DROP, CREATE
- (BOOL) executeNoReturnStatement:(NSString*) sqlQuery error:(NSError**)error{
	if (databaseObject !=  NULL) {
		if (sqlQuery && ![sqlQuery isEqualToString:@""]) {
			char* errorMsg;
			int retCode = sqlite3_exec(databaseObject, [sqlQuery UTF8String], NULL, NULL, &errorMsg);
			if(retCode != SQLITE_OK){
				if (error) {
					NSString* report = [[NSString alloc] initWithUTF8String:errorMsg];
					*error = [NSError errorWithDomain:@"LWSql-executeStatement" code:SQLC_EXECIUTION_ERROR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
					[report release];
				}
				sqlite3_free(errorMsg);
				return NO;
			}
		}else {
			if(error){
				NSString* report = [[NSString alloc] initWithString:@"Query statement must not be nil or empty."];
				*error = [NSError errorWithDomain:@"LWSql-executeStatement" code:SQLC_NIL_VALUE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
				[report release];
			}
			return NO;
		}
	}else {
		if (error) {
			NSString* report = [[NSString alloc] initWithString:@"You have to open database first."];
			*error = [NSError errorWithDomain:@"LWSql-executeStatement" code:SQL_CLOSED_DATABASE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return NO;
	}
	return YES;
}

//queries like "INSERT INTO cars VALUES(?,?,?)" and passing 3 object which will be placed in "?" places
- (BOOL) executeNoReturnStatement:(NSString*)sqlQuery objects:(SQLMutableObjectsArray*)objects error:(NSError**)error{
	if (databaseObject !=  NULL) {
		if (sqlQuery && ![sqlQuery isEqualToString:@""]) {
			
			sqlite3_stmt* statementHandle;
			int retCode = sqlite3_prepare_v2(databaseObject, [sqlQuery UTF8String], -1, &statementHandle, 0);
			if(retCode != SQLITE_OK){
				if (error) {
					NSString* report = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(databaseObject)];
					*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_EXECIUTION_ERROR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
					[report release];
				}
				return NO;
			}
			int count = [objects count];
			for (int i=0; i<count; i++){
				id object = [objects objectAtIndex:i];
				if(!object || [object isKindOfClass:[NSNull class]]){
					sqlite3_bind_null(statementHandle, (i+1));
				}	
				else if ([object isKindOfClass:[NSString class]]) {
					sqlite3_bind_text(statementHandle, (i+1), [object UTF8String], -1, SQLITE_STATIC);
				}
				else if([object isKindOfClass:[NSNumber class]]){
					double value = [object doubleValue];
					if(floor(value)==value){//checking if value is double or integer (if is 5 there is no issue because it will be inserted in REAL column as 5.0
						sqlite3_bind_int64(statementHandle, (i+1), [object longLongValue]);
					}else {
						sqlite3_bind_double(statementHandle, (i+1), value);
					}
				}
				else if([object isKindOfClass:[NSData class]]){
					NSUInteger dataLength = [object length];
					const void* buffer = [object bytes];
					
					sqlite3_bind_blob(statementHandle, (i+1), buffer, dataLength, SQLITE_STATIC);
				}
				else if([object isKindOfClass:[NSDate class]]){
					sqlite3_bind_double(statementHandle, (i+1), [object timeIntervalSince1970]);
				}
			}
			retCode = sqlite3_step(statementHandle);
			if(retCode != SQLITE_DONE){
				if(error){
					NSString* report = [[NSString alloc] initWithFormat:@"Error in query: \"%@\" with objects: %@", sqlQuery, objects];
					*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_QUERY_ERROR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
					[report release]; 
				}
				return NO;
			}
			retCode = sqlite3_finalize(statementHandle);
			if (retCode != SQLITE_OK) {
				if(error){
					NSString* report = [[NSString alloc] initWithFormat:@"Error in query: \"%@\" with objects: %@", sqlQuery, objects];
					*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_QUERY_ERROR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
					[report release]; 
				}
				return NO;
			}
		}else {
			if(error){
				NSString* report = [[NSString alloc] initWithString:@"Query statement must not be nil or empty."];
				*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_NIL_VALUE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
				[report release];
			}
			return NO;
		}
	}else {
		if (error) {
			NSString* report = [[NSString alloc] initWithString:@"You have to open database first."];
			*error = [NSError errorWithDomain:@"SQLConnection" code:SQL_CLOSED_DATABASE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return NO;
	}
	return YES;
}


- (SQLResultSet*) executeStatement:(NSString*)sqlQuery error:(NSError**)error{
	if (databaseObject !=  NULL) {
		if (sqlQuery && ![sqlQuery isEqualToString:@""]) {
			const char* sqlStatement = [sqlQuery UTF8String];
			sqlite3_stmt* statementHandle;
			int returnCode;
			
			returnCode =  sqlite3_prepare_v2(databaseObject, sqlStatement, strlen(sqlStatement), &statementHandle, NULL);
			if(returnCode != SQLITE_OK){
				if (error) {
					NSString* report = [[NSString alloc] initWithUTF8String:sqlite3_errmsg(databaseObject)];
					*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_EXECIUTION_ERROR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
					[report release];
				}
				return nil;
			}
			
			int row = 0;
			SQLResultSet* resultSet = [[SQLResultSet alloc] init];
			[resultSet autorelease];
			returnCode = sqlite3_step(statementHandle);
			while (returnCode == SQLITE_ROW) {
				int columntCount = sqlite3_column_count(statementHandle);
				for (int i = 0; i<columntCount; i++) {
					switch (sqlite3_column_type(statementHandle, i)) {
						case SQLITE_INTEGER:
							[resultSet insertLongLong:sqlite3_column_int64(statementHandle, i) 
									  forColumnCName:sqlite3_column_name(statementHandle, i) 
											   atRow:row mode:SQLRowInsertionModeReplace error:nil];
							break;
						case SQLITE_FLOAT:
							[resultSet insertDouble:sqlite3_column_double(statementHandle, i)
									  forColumnCName:sqlite3_column_name(statementHandle, i) 
											   atRow:row mode:SQLRowInsertionModeReplace error:nil];
							break;
						case SQLITE_NULL:
							[resultSet insertValue:[NSNull null] forColumnCName:sqlite3_column_name(statementHandle, i) 
											 atRow:row mode:SQLRowInsertionModeReplace error:nil];
							break;
						case SQLITE_TEXT:{
							const unsigned char* textC = sqlite3_column_text(statementHandle, i);
							NSString* text = [[NSString alloc] initWithUTF8String:(const char*)textC];
							[resultSet insertValue:text forColumnCName:sqlite3_column_name(statementHandle, i) 
											 atRow:row mode:SQLRowInsertionModeReplace error:nil];
							[text release];
							break;
						}
						case SQLITE_BLOB:{
							NSData* data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statementHandle, i) length:sqlite3_column_bytes(statementHandle, i)];
							[resultSet insertValue:data forColumnCName:sqlite3_column_name(statementHandle, i) 
											 atRow:row mode:SQLRowInsertionModeReplace error:nil];
							[data release];
							break;
						}
						default:
							break;
					}
				}
				row++;
				returnCode = sqlite3_step(statementHandle);
			}
			sqlite3_finalize(statementHandle);
			return resultSet;
		}else {
			if (error) {
				NSString* report = [[NSString alloc] initWithString:@"Query statement must not be nil or empty."];
				*error = [NSError errorWithDomain:@"SQLConnection" code:SQLC_NIL_VALUE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
				[report release];
			}
			return nil;
		}
	}else {
		if (error) {
			NSString* report = [[NSString alloc] initWithString:@"You have to open database first."];
			*error = [NSError errorWithDomain:@"LWSql-executeStatement" code:SQL_CLOSED_DATABASE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:report, @"message", nil]];
			[report release];
		}
		return nil;
	}
	return nil;
}


- (void) dealloc{
	if (databaseObject != NULL) {
		sqlite3_close(databaseObject);
	}
	[databasePath release];
	[super dealloc];
}


@end
