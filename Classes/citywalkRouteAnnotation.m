//
//  SBRouteAnnotation.m
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//


#import "citywalkRouteAnnotation.h"

@implementation citywalkRouteAnnotation

@synthesize coordinate = coordinate;
@synthesize title = mTitle;
@synthesize annotationType = annotationType;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)inTitle annotationType:(citywalkRouteAnnotationType)type {
	self = [super init];
	if (self != nil) {
		coordinate = coord;
		mTitle = [inTitle retain];
		annotationType = type;
	}
	return self;
}

- (void)dealloc {
	[mTitle release];	
	[super dealloc];
}

@end
