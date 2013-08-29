//
//  SBRouteAnnotation.h
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum citywalkRouteAnnotationType {
	citywalkRouteAnnotationTypeStart,
	citywalkRouteAnnotationTypeEnd,
	citywalkRouteAnnotationTypeWayPoint,
} citywalkRouteAnnotationType;

@interface citywalkRouteAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	citywalkRouteAnnotationType annotationType;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) citywalkRouteAnnotationType annotationType;

#pragma mark -
#pragma mark Instance Methods

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)inTitle  annotationType:(citywalkRouteAnnotationType)type;

@end
