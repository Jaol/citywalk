//
//  SBMapView.m
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import "citywalkMapView.h"
#import "citywalkRouteAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "citywalkViewController.h"

@interface citywalkMapView()<CLLocationManagerDelegate>
@end
@implementation citywalkMapView
@synthesize mapView = mMapView;
@synthesize routeLine = mrouteLine;
@synthesize routeLineView = mrouteLineView;
@synthesize fetchedData;
@synthesize annotationContents;
@synthesize distanceLabel;
@synthesize locArray;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        // Initialization code.
		mMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mMapView.showsUserLocation = YES;
		[mMapView setDelegate:self];
		[self addSubview:mMapView];
				
		if (nil != self.routeLine) {
			[self.mapView addOverlay:self.routeLine];
        }
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"notisfiction" ofType:@"mp3"];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        AudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:nil];
	
       
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 510, 300, 130)];
        
        [distanceLabel setTextColor:[UIColor whiteColor]];
        [distanceLabel setBackgroundColor:[UIColor blackColor]];
        distanceLabel.alpha = 0.8f;
        [distanceLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f ]];
        distanceLabel.numberOfLines= 0;
        [self addSubview:distanceLabel];
        distanceToggle = false;
        
        
                
    }
    //if (nil == self.locationManager)
    //    self.locationManager = [[CLLocationManager alloc] init];
    
      
    return self;
}


-(void)showDistance{
    
    distanceToggle=!distanceToggle;
    if(distanceToggle)
    {
        [UIView animateWithDuration:0.3 animations:^{
            distanceLabel.frame = CGRectMake(10,
                                        280,
                                        300,
                                        130);
        }];
       
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            distanceLabel.frame = CGRectMake(10,
                                             510,
                                             300,
                                             130);
        }];
           }
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
#pragma mark Instance Methods

-(void)loadRoutes:(NSArray *)routePoints
{


	
	MKMapPoint northEastPoint; 
	MKMapPoint southWestPoint; 
		
	// create a c array of points. 
	MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * [routePoints count]);
	NSLog(@" routepoints COUNT: %d",[routePoints count]);
	
	for(int idx = 0; idx < [routePoints count]; idx++)
	{
		CLLocation *location = (CLLocation *)[routePoints objectAtIndex:idx];
		
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
		
		// break the string down even further to latitude and longitude fields. 
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
	
		// if it is the first point, just use them, since we have nothing to compare to yet. 
		if (idx == 0)
		{
			northEastPoint = point;
			southWestPoint = point;
		}
		else 
		{
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}
		pointArr[idx] = point;
	}
	
	CLLocationDegrees maxLat = -90.0f;
	CLLocationDegrees maxLon = -180.0f;
	CLLocationDegrees minLat = 90.0f;
	CLLocationDegrees minLon = 180.0f;

	for (int i = 0; i < [routePoints count]; i++) {
		CLLocation *currentLocation = [routePoints  objectAtIndex:i];
		if(currentLocation.coordinate.latitude > maxLat) {
			maxLat = currentLocation.coordinate.latitude;
		}
		if(currentLocation.coordinate.latitude < minLat) {
			minLat = currentLocation.coordinate.latitude;
		}
		if(currentLocation.coordinate.longitude > maxLon) {
			maxLon = currentLocation.coordinate.longitude;
		}
		if(currentLocation.coordinate.longitude < minLon) {
			minLon = currentLocation.coordinate.longitude;
		}
	}
	
  
  /*  */


   
    
    
	MKCoordinateRegion region;
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
     [self.mapView setRegion:region animated:YES];
		
	// create the polyline based on the array of points. 
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count:[routePoints count]];
	[self.mapView addOverlay:self.routeLine];
		
	// clear the memory allocated earlier for the points
	free(pointArr);

    //[self setupLocationManager];
     [self performSelector:@selector(setupLocationManager:)  withObject:nil afterDelay:2];
}

-(void)setupLocationManager:sidekick{
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 50;
    
    [self.locationManager startUpdatingLocation];
}


-(void)findMe:(BOOL *)check{

    toggle = check;
   
    if(toggle)
        [self checkLocation];
    
}

-(void)checkLocation{
 
    if(toggle)
    [self.mapView setCenterCoordinate:[self.mapView.userLocation coordinate] animated:YES];

    
   NSString *testText = @"";
           
    
       for (NSDictionary *locationEntry in locationArrayToChange_stored)
    {
       // NSLog(@"locationsArray_stored: %@",locationsArray_stored);
        NSNumber *longitude = locationEntry[@"longitude"];
        NSNumber *latitude = locationEntry[@"latitude"];
        NSString *locationName = locationEntry[@"annotationTitle"];
        
         CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        NSAssert(location, @"failure to create location");
        
        CLLocationDistance distance = [location distanceFromLocation:self.locationManager.location];
        
        NSMutableString   *toText = [NSString stringWithFormat:@"distance %.0f meters to %@", distance, locationName];
        
        [distanceArray addObject:location];
        
        if (distance <= 10)
        {
            //NSLog(@"You are within 10 meters (actually %.0f meters) of %@", distance, locationName);
            [AudioPlayer play];
            toText = [NSString stringWithFormat:@"distance %.0f meters to %@", distance, locationName];
        }
        else
        {
            //NSLog(@"distance %.0f meters to %@", distance, locationName);
            toText = [NSString stringWithFormat:@"distance %.0f meters to %@", distance, locationName];
        }
        
                   
        testText = [testText stringByAppendingFormat:@"%@\n", toText];
 distanceLabel.text = testText;
         }


    


// from currentlocation find nearest annotation point and meassure that until within 10-20m. When its reached play a sound and begin finding next nearest, and so on


}

#pragma mark - the CLLocationManagerDelegate Methods

// this is used in iOS 6 and later

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self checkLocation];
}

// this is used in iOS 5 and earlier

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        [self checkLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s error = %@", __FUNCTION__, error);
}


#pragma mark <MKMapViewDelegate> Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	static NSString *identifier = @"RoutePinAnnotation";
	
	if ([annotation isKindOfClass:[citywalkRouteAnnotation class]]) {
		MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		if(!pinAnnotation) {
			pinAnnotation = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
		}
		
		if ([(citywalkRouteAnnotation *)annotation annotationType] == citywalkRouteAnnotationTypeWayPoint) {
			pinAnnotation.pinColor = MKPinAnnotationColorRed;
		} else if ([(citywalkRouteAnnotation *)annotation annotationType] == citywalkRouteAnnotationTypeEnd) {
			pinAnnotation.pinColor = MKPinAnnotationColorGreen;
		} else {
			pinAnnotation.pinColor = MKPinAnnotationColorGreen;
		}
		pinAnnotation.animatesDrop = YES;
		pinAnnotation.enabled = YES;
		pinAnnotation.canShowCallout = YES;
		pinAnnotation.canShowCallout = YES;
		pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		return pinAnnotation;
	} else {
		return [mMapView viewForAnnotation:mMapView.userLocation];
	}
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSArray *pinTitle=mMapView.annotations;
	for (int idx = 0 ; idx < [pinTitle count]; idx ++) {
		citywalkRouteAnnotation *pinTitle1 = [pinTitle objectAtIndex:idx];
		NSString *pinTitle11 = pinTitle1.title;
		NSLog(@" pinTitle1 %@",pinTitle11);

	}
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	if(overlay == self.routeLine)
	{
		//self.routeLineView = nil;		
//		//if we have not yet created an overlay view for this overlay, create it now. 
//		if(nil == self.routeLineView)
//		{
			self.routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
			self.routeLineView.fillColor = [UIColor redColor];
			self.routeLineView.strokeColor = [UIColor redColor];
			self.routeLineView.lineWidth = 5;
		//}
		overlayView = self.routeLineView;
		
		//NSLog(@"overlayView %@",annotationContents);
	}
	return overlayView;
}

#pragma mark -
#pragma mark releasing instances

- (void)dealloc {
	self.mapView		= nil;
	self.routeLine		= nil;
	self.routeLineView	= nil;
    [super dealloc];
}

@end
