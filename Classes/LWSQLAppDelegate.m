//
//  LWSQLAppDelegate.m
//  LWSQL
//
//  Created by Lukasz Warchol on 10-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LWSQLAppDelegate.h"
#import "LWSQLViewController.h"

#import "SQLConnection.h"
#import "SQLMutableObjectsArray.h"

@implementation LWSQLAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *sqliteDirPath = [[NSString alloc] initWithFormat:@"%@/%@",documentsDirectory, @"sqlite2"];
	NSString *dbPath = [[NSString alloc] initWithFormat:@"%@/%@", sqliteDirPath, @"test.db"];
	
	SQLConnection* sqlConn = [[SQLConnection alloc] initWithDatabaseFilePath:dbPath];
//	SQLConnection* sqlConn = [[SQLConnection alloc] initWithDatabaseName:@"test.db"];
	NSError* error;
	if([sqlConn openDatabaseWithError:&error]){
		NSString* query = @"CREATE TABLE testTable (name VARCHAR(20), number INTEGER, date FLOAT, image BLOB)";
		//NSString* query = @"DROP TABLE demots";
		NSError* error2;
		if(![sqlConn executeNoReturnStatement:query error:&error2]){
			NSLog(@"%@", [error2 userInfo]);
		}
		
		query = @"INSERT INTO testTable VALUES('Test text', 2, 0, NULL)";
		NSError* error3;
		if(![sqlConn executeNoReturnStatement:query error:&error3]){
			NSLog(@"%@", [error3 userInfo]);
		}
		
		query = @"INSERT INTO testTable VALUES(?, ?, ?, ?)";
		NSError* error4;
		NSData* data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testImg" ofType:@"png"]];
		SQLMutableObjectsArray* objs =  [[SQLMutableObjectsArray alloc] init]; 
		[objs addObject:@"test text 2"];
		[objs addObject:[NSNumber numberWithLongLong:INT64_MAX]];
		[objs addObject:[NSDate date]];
		[objs addObject:data];
		if(![sqlConn executeNoReturnStatement:query objects:objs error:&error4]){
			NSLog(@"%@", [error4 userInfo]);
		}
		[data release];
		[objs release];
		
		query = @"UPDATE testTable SET image=? WHERE ROWID=1";
		data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testImg" ofType:@"png"]];
		objs = [[NSArray alloc] initWithObjects:data, nil];
		if(![sqlConn executeNoReturnStatement:query objects:objs error:&error4]){
			NSLog(@"%@", [error4 userInfo]);
		}
		[data release];
		[objs release];
		
		query = @"UPDATE testTable SET number = number + number WHERE ROWID=1";
		if(![sqlConn executeNoReturnStatement:query error:&error3]){
			NSLog(@"%@", [error3 userInfo]);
		}
		
		
		query = @"SELECT * FROM testTable";
		NSError* error5;
		SQLResultSet* resultSet = [sqlConn executeStatement:query error:&error5];
		if (!resultSet) {
			NSLog(@"%@", [error5 userInfo]);
		}
		NSLog(@"%@", resultSet);

		[resultSet first];
		
		NSInteger tmpInt = [resultSet integerAtColumnName:@"number" error:&error5];
		NSLog(@"%i", tmpInt);
		
		NSString* tmpObj = [resultSet stringAtColumnName:@"number" error:&error5];
		if(!tmpObj){
			NSLog(@"%@, %@", error5, [error5 userInfo]);
		}
		
		NSDate* tmpDate = [resultSet dateAtColumnName:@"date" error:&error5];
		if(!tmpDate){
			NSLog(@"%@, %@", error5, [error5 userInfo]);
		}
		NSLog(@"%@", tmpDate);
		
	}else {
		NSLog(@"%@", [error userInfo]);
	}
	[sqlConn release];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
