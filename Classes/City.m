//
//  City.m
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import "City.h"


@implementation City

@synthesize mCityName;
@synthesize mCityDescription;

-(id) init
{
	self = [super init];
	if (self != nil) {
		self.mCityName = @"";
		self.mCityDescription = @"";
	}
	return self;
}
- (void) dealloc
{
	[mCityName release];
	[mCityDescription release];
	[super dealloc];
}


@end