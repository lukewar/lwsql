//
//  LWSql.h
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "SQLResultSet.h"
#import "SQLMutableObjectsArray.h"
typedef enum tagConnectionState{
	StateClosed,
	StateOpen
} ConnectionState;

#define SQLC_OPENNING_ERROR 4000
#define SQLC_DATABASE_OVERWRITE 4001
#define SQLC_NO_DB_NAME 4002
#define SQL_CLOSED_DATABASE 4005
#define SQLC_EXECIUTION_ERROR 4003
#define SQLC_NIL_VALUE 4004
#define SQLC_QUERY_ERROR 4007

@interface SQLConnection : NSObject {
	ConnectionState state;
	
	sqlite3* databaseObject;
	NSString* databasePath;
}
@property(nonatomic, retain) NSString* databasePath;

- (id) initWithDatabaseName:(NSString*) dbName;
- (id) initWithDatabaseFilePath:(NSString*) path;

- (BOOL) openDatabaseWithError:(NSError**)error;
- (BOOL) closeDatabaseWithError:(NSError**)error;
- (BOOL) isOpened;

- (BOOL) executeNoReturnStatement:(NSString*) sqlQuery error:(NSError**)error;
- (BOOL) executeNoReturnStatement:(NSString*)sqlQuery objects:(SQLMutableObjectsArray*)objects error:(NSError**)error;
- (SQLResultSet*) executeStatement:(NSString*)sqlQuery error:(NSError**)error;

@end
