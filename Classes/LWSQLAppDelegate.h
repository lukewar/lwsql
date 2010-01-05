//
//  LWSQLAppDelegate.h
//  LWSQL
//
//  Created by Lukasz Warchol on 10-01-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWSQLViewController;

@interface LWSQLAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LWSQLViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LWSQLViewController *viewController;

@end

