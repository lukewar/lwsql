//
//  SQLColumn.h
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQLColumn : NSObject {
	NSString* columnName;
	id columnValue;
}
@property(nonatomic, readonly) NSString* columnName;
@property(nonatomic, readonly) id columnValue;

- (id) initWithName:(NSString*)colName value:(id)colvalue;
@end
