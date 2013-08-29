//
//  City.h
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import <Foundation/Foundation.h>


@interface City : NSObject {
	NSString*	mCityName;
	NSString*	mCityDescription;
}
@property (nonatomic, retain) NSString* mCityName;
@property (nonatomic, retain) NSString* mCityDescription;

@end
