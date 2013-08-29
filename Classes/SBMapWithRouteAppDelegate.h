//
//  SBMapWithRouteAppDelegate.h
//  SBMapWithRoute
//
//  Created by Surya Kant on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
@class SBMapWithRouteViewController;

@interface SBMapWithRouteAppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    SBMapWithRouteViewController *viewController;
	UINavigationController *nav;

}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SBMapWithRouteViewController *viewController;


@end

