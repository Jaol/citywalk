//
//  UICGDirections.h
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICGDirectionsOptions.h"
#import "UICGRoute.h"
#import "UICGPolyline.h"
#import "UICGCheckPoint.h"
#import "UICGoogleMapsAPI.h"

@class UICGDirections;

@protocol UICGDirectionsDelegate<NSObject>
@optional
- (void)directionsDidFinishInitialize:(UICGDirections *)directions;
- (void)directions:(UICGDirections *)directions didFailInitializeWithError:(NSError *)error;
- (void)directionsDidUpdateDirections:(UICGDirections *)directions;
- (void)directions:(UICGDirections *)directions didFailWithMessage:(NSString *)message;
@end

@interface UICGDirections : NSObject<UIWebViewDelegate> {
	id<UICGDirectionsDelegate> delegate;
	UICGoogleMapsAPI *googleMapsAPI;
	NSArray *routes;
	NSArray *geocodes;
	UICGPolyline *polyline;
	NSDictionary *distance;
	NSDictionary *duration;
	NSDictionary *status;
	NSArray *routeWayPoints;
	NSArray *routeDict;
	BOOL isInitialized;
	NSMutableArray *routeArray;
	UICGCheckPoint *checkPoint;
	NSString *mstr;
}

@property (nonatomic, assign) id<UICGDirectionsDelegate> delegate;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSArray *geocodes;
@property (nonatomic, retain) UICGPolyline *polyline;
@property (nonatomic, retain) NSDictionary *distance;
@property (nonatomic, retain) NSDictionary *duration;
@property (nonatomic, retain) NSDictionary *status;
@property (nonatomic, readonly) BOOL isInitialized;
@property (nonatomic, retain) NSArray *routeWayPoints;
@property (nonatomic, retain) NSArray *routeDict;
@property (nonatomic, retain) NSMutableArray *routeArray;
@property (nonatomic, retain) UICGCheckPoint *checkPoint; 

+ (UICGDirections *)sharedDirections;
- (id)init;
- (void)makeAvailable;
- (void)loadWithQuery:(NSString *)query options:(UICGDirectionsOptions *)options;
- (void)loadWithStartPoint:(NSString *)startPoint endPoint:(NSMutableArray *)endPoints options:(UICGDirectionsOptions *)options; 
- (void)loadFromWaypoints:(NSArray *)waypoints options:(UICGDirectionsOptions *)options;
- (NSInteger)numberOfRoutes;
- (UICGRoute *)routeAtIndex:(NSInteger)index;
- (NSInteger)numberOfGeocodes;
- (NSDictionary *)geocodeAtIndex:(NSInteger)index;
-(void)loadDirections:(NSString *)message;

@end
