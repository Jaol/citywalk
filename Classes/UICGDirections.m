//
//  UICGDirections.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "UICGDirections.h"
#import "UICGRoute.h"
#import "JSON.h"


static UICGDirections *sharedDirections;

@implementation UICGDirections

@synthesize routes;
@synthesize geocodes;
@synthesize delegate;
@synthesize polyline;
@synthesize distance;
@synthesize duration;
@synthesize status;
@synthesize isInitialized;
@synthesize routeWayPoints;
@synthesize routeDict;
@synthesize routeArray; 
@synthesize checkPoint;

+ (UICGDirections *)sharedDirections {
	if (!sharedDirections) {
		sharedDirections = [[UICGDirections alloc] init];
	}
	return sharedDirections;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		googleMapsAPI = [[UICGoogleMapsAPI alloc] init];
		routes = [[NSArray alloc] init];
		routeArray = [[NSMutableArray alloc] init];
		googleMapsAPI.delegate = self;
	}
	return self;
}

- (void)dealloc {
	[googleMapsAPI release];
	[geocodes release];
	[polyline release];
	[distance release];
	[duration release];
	[status release];
	[routeDict release];
	[routeWayPoints release];
	[routeArray release];
	[super dealloc];
}

- (void)makeAvailable {
	[googleMapsAPI makeAvailable];
}

- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didGetObject:(NSObject *)object {
	NSDictionary *dictionary = (NSDictionary *)object;
	NSArray *routeDics = [dictionary objectForKey:@"routes"];
	//routes = [[NSMutableArray alloc] initWithCapacity:[routeDics count]];
	//for (NSDictionary *routeDic in routeDics) {
//		[(NSMutableArray *)routes addObject:[UICGRoute routeWithDictionaryRepresentation:routeDic]];
//		NSLog(@"routes %d  routeDics %d",[routes count],[routeDics count]);
//	}
	self.geocodes = [dictionary objectForKey:@"geocodes"];
	self.polyline = [UICGPolyline polylineWithDictionaryRepresentation:[dictionary objectForKey:@"polyline"]];
	self.distance = [dictionary objectForKey:@"distance"];
	self.duration = [dictionary objectForKey:@"duration"];
	self.status =   [dictionary objectForKey:@"status"];
	
	NSDictionary *mCheckPointDic = [routeDics objectAtIndex:0];
	self.checkPoint = [UICGCheckPoint CheckPointWithDictionaryRepresentation:mCheckPointDic];
	[self.routeArray  addObject:checkPoint];
	NSLog(@" routeArray %d",[routeArray count]);
	if ([self.delegate respondsToSelector:@selector(directionsDidUpdateDirections:)]) {
		[self.delegate directionsDidUpdateDirections:self];
	}
}

- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message {
	if ([self.delegate respondsToSelector:@selector(directions:didFailWithMessage:)]) {
		[self.delegate directions:self didFailWithMessage:message];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	isInitialized = YES;
	if ([self.delegate respondsToSelector:@selector(directionsDidFinishInitialize:)]) {
		[self.delegate directionsDidFinishInitialize:self];
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if ([self.delegate respondsToSelector:@selector(directions:didFailInitializeWithError:)]) {
		[self.delegate directions:self didFailInitializeWithError:error];
	}
}

- (void)loadWithQuery:(NSString *)query options:(UICGDirectionsOptions *)options {
	[googleMapsAPI stringByEvaluatingJavaScriptFromString:
	 [NSString stringWithFormat:@"loadDirections(%@, %@)", query, [options JSONRepresentation]]];
}

- (void)loadWithStartPoint:(NSString *)startPoint endPoint:(NSMutableArray *)endPoints options:(UICGDirectionsOptions *)options {
	for (int idx = 0; idx < [endPoints count];idx ++) 
	{
		NSString* msg = [NSString stringWithFormat:@"loadDirections('%@', '%@', %@)", startPoint, [endPoints objectAtIndex:idx], [options JSONRepresentation]];
		mstr = [msg retain];
		[self performSelector:@selector(loadDirections:)  withObject:msg afterDelay:idx+1];
	}
}
-(void)loadDirections:(NSString *)message
{
	[googleMapsAPI stringByEvaluatingJavaScriptFromString:message];
}
- (void)loadFromWaypoints:(NSArray *)waypoints options:(UICGDirectionsOptions *)options {
	[googleMapsAPI stringByEvaluatingJavaScriptFromString:
	 [NSString stringWithFormat:@"loadFromWaypoints(%@, %@)", [waypoints JSONRepresentation], [options JSONRepresentation]]];
}

- (NSInteger)numberOfRoutes {
	return [routes count];
}

- (UICGRoute *)routeAtIndex:(NSInteger)index {
	return [routes objectAtIndex:index];
}

- (NSInteger)numberOfGeocodes {
	return [geocodes count];
}

- (NSDictionary *)geocodeAtIndex:(NSInteger)index {
	return [geocodes objectAtIndex:index];;
}

@end
