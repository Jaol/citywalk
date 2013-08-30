//
//  SBGoogleMap.m
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import "citywalkGoogleMap.h"
#import "citywalkMapView.h"
#import "citywalkRouteAnnotation.h"
#import "City.h"
#import "UICGRoutes.h"
#import "citywalkCheckPointViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface citywalkGoogleMap()<CLLocationManagerDelegate>
-(void)releaseAllViews;
-(void)customInitialization;

@end



@implementation citywalkGoogleMap

@synthesize map				= mMap;
@synthesize startPoint		= mStartPoint;
@synthesize endPoint		= mEndPoint;
@synthesize loadBtn		= mLoadBtn;
@synthesize annotationArray = mAnnotationArray;
@synthesize travelMode		= mTravelMode;
@synthesize destination;
@synthesize routes;
@synthesize mAnnotations;
@synthesize mRouteArray;
@synthesize mRouteDetail;
@synthesize locArray;
@synthesize annotationContent;
@synthesize firstController;
@synthesize wayPoints;
//Invoked when the class is instantiated in XIB
-(id)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if( self)
	{
		[self customInitialization];
	}
	return self;
}

-(void)releaseAllViews
{
	//Release All views that are retained by this class.. Both Views retained from nib and views added programatically
	
	self.loadBtn = nil;
    
}
-(void)customInitialization
{
	// do the initialization of class variables here..
	
	mDirections			 = [UICGDirections sharedDirections];
	mDirections.delegate = self;
    
    
    //SBMapWithRouteAppDelegate *appDelegate = (SBMapWithRouteAppDelegate *)[[UIApplication sharedApplication] delegate];
    // locationArray_forward = [appDelegate reloadData];
    // NSLog(@"fecth: %@",locArray);
    
    
    
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self customInitialization];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Google Maps";
	self.map = [[citywalkMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:mMap];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.annotationArray = [[NSMutableArray alloc]init];
	self.routes			 = [[UICGRoutes alloc]init];
    
	
	if (mDirections.isInitialized) {
       
		[self updateRoute];
	}
   

       /* */
    MKCoordinateRegion region;
	region.span.longitudeDelta = 0.1;
	region.span.latitudeDelta = 0.1;
	region.center.latitude = 55.729551;
	region.center.longitude = 12.476606;
    
    
   // NSLog(@"collectData:%@", annotationContent);
    //citywalkViewController *mainController = [[citywalkViewController alloc]init];
    //NSMutableArray *newarray = mainController->locationsArray;
    //SecondViewController *secondViewController = [[SecondViewController alloc] initWithMutableArray:self.mytableinfo];
    //[mainController showmethedata];
   NSLog(@"collectData:%@", locationsArray_stored);
    

}
    


   
          

 
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

    [super viewDidUnload];
	
	[self releaseAllViews];
}
- (void)viewDidAppear:(BOOL)animated
{

	[super viewDidAppear:YES];

}
- (void)viewWillDisappear:(BOOL)animated; 
{
	[super viewWillDisappear:YES];

}

#pragma mark -
#pragma mark Instance Methods

- (void)updateRoute
{	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	UICGDirectionsOptions *options = [[[UICGDirectionsOptions alloc] init] autorelease];
	options.travelMode = mTravelMode;
	City *mFirstCity = [[[City alloc]init] autorelease];
	mFirstCity.mCityName = mStartPoint;
    
    
    
    if ([wayPoints count] > 0) {
        NSArray *routePoints = [NSArray arrayWithObject:mFirstCity.mCityName];
		routePoints = [routePoints arrayByAddingObjectsFromArray:wayPoints];
		routePoints = [routePoints arrayByAddingObject:destination];
		[mDirections loadFromWaypoints:routePoints options:options];
	} else {
		[mDirections loadWithStartPoint:mFirstCity.mCityName endPoint:destination options:options];
	}

    
    
	//[mDirections loadWithStartPoint:mFirstCity.mCityName endPoint:destination options:options];
       
}

-(void)loadRouteAnnotations
{
	self.mRouteArray = [mDirections routeArray];
    NSLog(@"mRouteArray %@",mRouteArray);
	self.mAnnotations = [[NSMutableArray alloc]init];
	for (int idx = 0; idx < [mRouteArray count]; idx++) {
		NSArray *_routeWayPoints1 = [[mRouteArray objectAtIndex:idx] wayPoints];
		NSArray *mPlacetitles = [[mRouteArray objectAtIndex:idx] mPlaceTitle]; 
		self.annotationArray = [NSMutableArray arrayWithCapacity:[_routeWayPoints1 count]-2];
                        
		mLoadBtn.title = @"OFF";
		mLoadBtn.target = self;
		mLoadBtn.action = @selector(removeRouteAnnotations);
		
		for(int idx = 0; idx < [_routeWayPoints1 count]-1; idx++)
		{
			
			mBetweenAnnotation = [[[citywalkRouteAnnotation alloc] initWithCoordinate:[[_routeWayPoints1 objectAtIndex:idx]coordinate]
																		  title:[mPlacetitles objectAtIndex:idx]
																 annotationType:citywalkRouteAnnotationTypeWayPoint] autorelease];
			[self.annotationArray addObject:mBetweenAnnotation];
		}
		[mAnnotations addObject:mAnnotationArray];
	//	[self.map.mapView addAnnotation:[mAnnotations objectAtIndex:idx]];
        NSLog(@"map %@",mMap);

	}	
	[mAnnotations release];
}

-(void)showCheckpoints
{
	citywalkCheckPointViewController *_Controller	= [[citywalkCheckPointViewController alloc]initWithNibName:@"citywalkCheckPoints" bundle:nil];
	[self.navigationController pushViewController:_Controller animated:YES];
	NSMutableArray *arr = [[mDirections checkPoint] mPlaceTitle];
	_Controller.mCheckPoints = arr ;
    NSLog(@"mPlaceTitle: %@", [mDirections routeArray]);
	//NSLog(@"mCheckPoints: %@",arr);
	[_Controller release];
}
-(void)removeRouteAnnotations
{
	NSMutableArray *mTempAnnotation = [mAnnotations retain];
	for (int idx = 0; idx < [mTempAnnotation count]; idx++) {
		[mMap.mapView removeAnnotations:[mTempAnnotation objectAtIndex:idx] ];
	}	
	mLoadBtn.title = @"ON";
	mLoadBtn.target = self;
	mLoadBtn.action = @selector(loadRouteAnnotations);
	[mTempAnnotation release];
}


#pragma mark <UICGDirectionsDelegate> Methods

- (void)directionsDidFinishInitialize:(UICGDirections *)directions {
	[self updateRoute];
}

- (void)directions:(UICGDirections *)directions didFailInitializeWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Map Directions" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}

- (void)directionsDidUpdateDirections:(UICGDirections *)indirections {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UICGPolyline *polyline = [indirections polyline];
	NSArray *routePoints = [polyline routePoints];
	
	[mMap loadRoutes:routePoints]; // Loads route by getting the array of all coordinates in the route.
    
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 85, 44.01f)]; // 44.01 shifts it up 1px for some reason
    
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.4f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = -1; // clear background
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    // Create a standard Load button.
    
    self.loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"ON" 
                                                style:UIBarButtonItemStyleBordered 
                                               target:self 
                                               action:@selector(loadRouteAnnotations)];
    
   // [buttons addObject:mLoadBtn];
    
    // Add Go button.
    UIBarButtonItem *mGoBtn = [[UIBarButtonItem alloc] initWithTitle:@"Check points" 
                                          style:UIBarButtonItemStyleBordered 
                                         target:self 
                                         action:@selector(showCheckpoints)];
    [buttons addObject:mGoBtn];
    [mGoBtn release];
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    [buttons release];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];
    self.navigationItem.rightBarButtonItem = twoButtons;
    [twoButtons release];
	
	//Add annotations of different colors based on initial and final places.
	citywalkRouteAnnotation *startAnnotation = [[[citywalkRouteAnnotation alloc] initWithCoordinate:[[routePoints objectAtIndex:0] coordinate]
																					title:mStartPoint
																		   annotationType:citywalkRouteAnnotationTypeStart] autorelease];
	citywalkRouteAnnotation *endAnnotation = [[[citywalkRouteAnnotation alloc] initWithCoordinate:[[routePoints lastObject] coordinate]
																				  title:mEndPoint
																		 annotationType:citywalkRouteAnnotationTypeEnd] autorelease];
	
    // NEW setup
    
    if ([wayPoints count] > 0) {
		NSInteger numberOfRoutes = [mDirections numberOfRoutes];
		for (NSInteger index = 0; index < numberOfRoutes; index++) {
			UICGRoute *route = [mDirections routeAtIndex:index];
			CLLocation *location = [route endLocation];
			citywalkRouteAnnotation *annotation = [[[citywalkRouteAnnotation alloc] initWithCoordinate:[location coordinate]
																					   title:[[route endGeocode] objectForKey:@"address"]
																			  annotationType:citywalkRouteAnnotationTypeWayPoint] autorelease];
			[mMap.mapView addAnnotation:annotation];
		}
	}
    
	[mMap.mapView addAnnotations:[NSArray arrayWithObjects:startAnnotation, endAnnotation, nil]];

    
    
	// ORG ADD
	//[mMap.mapView addAnnotations:[NSArray arrayWithObjects:startAnnotation, endAnnotation,nil]];
    
    
    // ADD ALL ANNONTATIONS
    

    //NSLog(@"annotationContent: %@",locationsArray_stored);
    
    for (id object in locationsArray_stored) {
        
        //CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        
        CLLocationCoordinate2D annotationCoord;
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        
        NSNumber *longitude = object[@"longitude"];
        NSNumber *latitude = object[@"latitude"];
        NSString *locationName = object[@"annotationTitle"];
        
        
        annotationCoord.longitude = [longitude doubleValue];
        annotationCoord.latitude = [latitude doubleValue];
        annotationPoint.title = locationName;
        annotationPoint.coordinate = annotationCoord;
        
        
        [self.map.mapView addAnnotation:annotationPoint];
        annotationPoint = nil;
    }

}

- (void)directions:(UICGDirections *)directions didFailWithMessage:(NSString *)message {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Map Directions" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}



#pragma mark -
#pragma mark releasing instances
- (void)dealloc {
	//remove as Observer from NotificationCenter, if this class has registered for any notifications
	//release all you member variables and appropriate caches
	[routes release];
	[mAnnotationArray release];
    [mLoadBtn release];
    [mMap release];
	[self releaseAllViews];
[wayPoints release];
    [super dealloc];
}


@end
