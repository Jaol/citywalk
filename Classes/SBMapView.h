//
//  SBMapView.h
//  SBMapWithRoute
//
//  Created by Surya Kant on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKPolyline.h>
#import <AVFoundation/AVFoundation.h>
#import "Globals.h"
@interface SBMapView : UIView<MKMapViewDelegate> 
{
	MKMapView*			mMapView;			  	    // the view we create for the map
	MKPolyline*			mrouteLine;			 	    // An Instance of Line (MKPolyline)  on the map
	MKPolylineView*		mrouteLineView;				// the view we create for the line on the map
    
    AVAudioPlayer *AudioPlayer;
    NSMutableArray *distanceArray;
    
    NSMutableArray *annotationContents;
   
}
@property (nonatomic, retain)UILabel *yourLabel;
@property  (nonatomic, retain) NSMutableArray* annotationContents;
@property (nonatomic, retain) MKMapView*		mapView;
@property (nonatomic, retain) MKPolyline*		routeLine;
@property (nonatomic, retain) MKPolylineView*	routeLineView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property   (nonatomic, retain) NSArray *fetchedData;
@property   (nonatomic, retain) NSNumber *idxx;
@property (nonatomic, strong)NSArray*locArray;
#pragma mark Instance Methods
-(void)loadRoutes:(NSArray *)inArray;

@end
