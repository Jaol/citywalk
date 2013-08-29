//
//  citywalkAppDelegate.h
//  citywalk
//
//  Created by Jakob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
@class citywalkViewController;

@interface citywalkAppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    citywalkViewController *viewController;
	UINavigationController *nav;

}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet citywalkViewController *viewController;


@end

