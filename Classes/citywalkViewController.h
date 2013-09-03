//
//  ViewController.h
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import <UIKit/UIKit.h>
#import "citywalkAppDelegate.h"
#import "citywalkGoogleMap.h"
#import "Globals.h"

@interface citywalkViewController : UIViewController <UITextFieldDelegate>{

	UITextField			*mSourceCity;		//TextField for the Source city
	UITextField			*mDestinationCity1;	//TextField for the Destination city1
	UIButton			*mLoadDirection;	//Button for moving in next controller ie. GoogleMapController
	UISegmentedControl	*mTravelMode;		//SegmentController for the option of the travelling mode
	NSMutableArray *DestinationCityArray;

  
    @public
    NSMutableArray *jsonArray_mother;
    NSMutableArray *locationsArray;
    NSMutableArray *locationsDataArray;
    BOOL *checkInOut;
    NSMutableArray *arrayForMenu;
    NSMutableArray *descriptionArray;
    NSInteger *newint;
   
}

@property (nonatomic)  int *storeDataID;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UIButton *chooseroute;
@property (retain, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (strong, nonatomic) UIControl *touchRecognizer;
- (IBAction)openPicker:(id)sender;
@property (nonatomic, retain)NSError *error;
@property (nonatomic, retain)NSData *locationsData;
//@property (nonatomic, retain) NSMutableArray *locationsArray;
@property (nonatomic, retain) NSMutableArray *locationsDataArray;
@property (nonatomic, retain) IBOutlet UITextField *sourceCity;
@property (nonatomic, retain) IBOutlet UITextField *destinationCity1;
@property (nonatomic, retain) IBOutlet UIButton *loadDirection;
@property (nonatomic, retain) IBOutlet UISegmentedControl *travelMode;
@property (nonatomic, retain) NSMutableArray *DestinationCityArray;
@property   (nonatomic, retain)NSArray *locationArray_forward;

#pragma mark ButtonAction

-(IBAction)showGoogleMap:(id)sender;		//Action for moving in next controller ie. GoogleMapController

@end

