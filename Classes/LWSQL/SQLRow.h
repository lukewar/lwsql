//
//  SQLRow.h
//  Demotywatory
//
//  Created by Lukasz Warchol on 09-12-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLColumn.h"

typedef enum SQLRowInsertionMode_{
	SQLRowInsertionModeReplace,
	SQLRowInsertionModeDontReplace
} SQLRowInsertionMode;

@interface SQLRow : NSObject {
	NSMutableArray* columns;
}

- (BOOL) addColumn:(SQLColumn*)column mode:(SQLRowInsertionMode)mode error:(NSError**)error;

- (SQLColumn*) columnAtNumber:(NSUInteger)column;
@end
