//
//  ViewController.m
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import "citywalkViewController.h"
#import "citywalkMapView.h"

@interface citywalkViewController() <UIPickerViewDataSource, UIPickerViewDelegate>{
UIPickerView *uiPicker;
}
-(void)releaseAllViews;
-(void)customInitialization;
@end


@implementation citywalkViewController

@synthesize sourceCity		= mSourceCity;
@synthesize destinationCity1 = mDestinationCity1;
@synthesize loadDirection	= mLoadDirection;
@synthesize travelMode		= mTravelMode;
@synthesize DestinationCityArray;
@synthesize locationsData;
@synthesize error;
@synthesize locationsDataArray;
@synthesize descriptionLabel;
@synthesize storeDataID;

static const CGFloat kPickerDismissViewHiddenOpacity = 0.89f;
//Invoked when the class is instantiated in XIB
-(id)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if( self)
	{
        
       	[self customInitialization];
        [self collectData];
	}
    locationsArray = [[NSMutableArray alloc] init];
    arrayForMenu = [[NSMutableArray alloc]init];
    descriptionArray = [[NSMutableArray alloc]init];
    
    storeDataID = 0;
    return self;
}

-(void)releaseAllViews
{
	//Release All views that are retained by this class.. Both Views retained from nib and views added programatically
	//eg:
	//self.mMyTextField = nil
	self.sourceCity			= nil;
	self.destinationCity1	= nil;
	self.loadDirection		= nil;
	self.travelMode			= nil;
}

-(void)customInitialization
{
	// do the initialization of class variables here..
}

-(void)collectData{
        
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *locationsPath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"json"];
        NSURL *url = [NSURL fileURLWithPath:locationsPath];
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
      
}

- (NSMutableArray *)fetchedData:(NSData *)responseData{
    
    NSDictionary *locationsArrays = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    // Get titles
   
  
    NSDictionary *allData = [locationsArrays valueForKey:@"trips"];// = [arraytouse valueForKeyPath:@"coordinates"];
    
    NSArray *allTripArray = [allData valueForKey:@"trip"];
    
    
    for (NSArray *diction in allTripArray) {
        [arrayForMenu addObject:[[diction objectAtIndex:0] valueForKey:@"routeTitle"]];
        [descriptionArray addObject:[[diction objectAtIndex:0] valueForKey:@"description"]];
    }
    
    
    jsonArray_mother = [locationsArrays valueForKeyPath:@"trips"];

    // find: first set of data as string
    firstLocationSet = [[jsonArray_mother valueForKeyPath:@"trip"] objectAtIndex:0];
    
    // get start position
    NSString *findFirstLocation = [[[[firstLocationSet valueForKey:@"coordinates" ] objectAtIndex:1] valueForKeyPath:@"googlePoint"] objectAtIndex:0];
    // get destination
     NSString *destinationLocation = [[[[firstLocationSet valueForKey:@"coordinates" ] objectAtIndex:1] valueForKeyPath:@"googlePoint"] lastObject];


    self.sourceCity.text = arrayForMenu[0];
    self.destinationCity1.text = destinationLocation;
    self.descriptionLabel.text = descriptionArray[0];

    firstLocation = findFirstLocation;
    lastLocation = [[[[firstLocationSet valueForKey:@"coordinates" ] objectAtIndex:1] valueForKeyPath:@"googlePoint"] lastObject];

  
    [locationsArray_stored  addObjectsFromArray:[[firstLocationSet valueForKey:@"coordinates"] objectAtIndex:1]];

  
    [self initUIPicker];
    
    locationsArray = locationsArray_stored;
    locationArrayToChange_stored = locationsArray_stored;
    
    [locationData_stored addObjectsFromArray:[jsonArray_mother valueForKeyPath:@"trip"]];

    
    return locationsArray_stored;
}

-(void)setNewRoute:(int *)data{

    storeDataID = data;
    
    // get start position
    firstLocation = [[[[[locationData_stored objectAtIndex:data] valueForKey:@"coordinates"] objectAtIndex:1] valueForKeyPath:@"googlePoint"] objectAtIndex:0];
    
    // get destination
    lastLocation = [[[[[locationData_stored objectAtIndex:data] valueForKey:@"coordinates"] objectAtIndex:1] valueForKeyPath:@"googlePoint"] lastObject];

    self.sourceCity.text = [arrayForMenu objectAtIndex:data];
      
    NSString *getDesc = [descriptionArray objectAtIndex:data];
    self.descriptionLabel.text = getDesc;
    
    if(locationArrayToChange_stored != nil){
        if([locationArrayToChange_stored count]){
        [locationArrayToChange_stored removeAllObjects];
        }
    }
    
    [locationArrayToChange_stored addObjectsFromArray:[[[locationData_stored objectAtIndex:data] valueForKey:@"coordinates"]objectAtIndex:1]];

    locationsArray = locationsArray_stored;
    
          
    // ISOLATE ANNOTATION PINS FROM START-END
    [locationArrayToChange_stored removeLastObject];
    [locationArrayToChange_stored removeObjectAtIndex:0];

}

-(void)initUIPicker{
        
    CGFloat height = floorf(self.view.bounds.size.height / 2.0);

    uiPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+480, self.view.bounds.size.width, height)];
    [uiPicker setShowsSelectionIndicator:YES];
    [uiPicker setDelegate:self];
    [uiPicker setDataSource:self];
    [self.view.window addSubview:uiPicker];
    
}

- (IBAction)openPicker:(id)sender {
    
    
    checkInOut=!checkInOut;
    if(checkInOut)
    {
        
    [UIView animateWithDuration:0.3 animations:^{
        uiPicker.frame = CGRectMake(0.0,
                                    self.view.bounds.size.height-uiPicker.frame.size.height+65,
                                    uiPicker.frame.size.width,
                                    uiPicker.frame.size.height);
    }];
        
        self.touchRecognizer = [[UIControl alloc]initWithFrame:self.view.window.bounds];
        
        UILabel *txt_dismisPicker= [[UILabel alloc]initWithFrame:CGRectMake(100, 200, self.view.bounds.size.width/2, 310)];
        UILabel *txt_youPicked= [[UILabel alloc]initWithFrame:CGRectMake(60, 90, self.view.bounds.size.width/2, 310)];
        txt_dismisPicker.textAlignment = NSTextAlignmentCenter;
        //txt_youPicked.textAlignment = NSTextAlignmentCenter;
        [self.touchRecognizer addTarget:self action:@selector(touchedOutsidePicker:) forControlEvents:UIControlEventTouchUpInside];
        self.touchRecognizer.backgroundColor = [UIColor whiteColor];
        txt_dismisPicker.backgroundColor = [UIColor whiteColor];
        //txt_dismisPicker.alpha = kPickerDismissViewHiddenOpacity;
        txt_dismisPicker.textColor = [UIColor blackColor];
        txt_dismisPicker.font = [UIFont boldSystemFontOfSize:12.0f];
        self.touchRecognizer.alpha = kPickerDismissViewHiddenOpacity;
        txt_dismisPicker.text = @"TAP HERE TO CLOSE";
        txt_youPicked.text = @"YOUR ROUTE OF CHOICE:";


       
        [self.touchRecognizer addSubview:txt_dismisPicker];
         [self.touchRecognizer addSubview:txt_youPicked];
        [txt_youPicked sizeToFit];
        [txt_dismisPicker sizeToFit];
        [self.view addSubview:self.touchRecognizer];
        
    }else{
      
        [UIView animateWithDuration:0.3 animations:^{
            uiPicker.frame = CGRectMake(uiPicker.frame.origin.x,
                                           self.view.bounds.size.height+286, //Displays the view off the screen
                                           uiPicker.frame.size.width,
                                           uiPicker.frame.size.height);
        }];
    }
    
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
	self.title = @"Home";
	mTravelMode.selectedSegmentIndex = 1;    // AS App will launch, Index 0 of segmented control will be selected
    checkInOut = false;
    storeDataID = 0;
    
    //NSLog(@"[arrayForMenu objectAtIndex:0] %@",[arrayForMenu objectAtIndex:0]);
   }


- (IBAction)touchedOutsidePicker:(id)sender {
    [self.touchRecognizer removeFromSuperview];
    self.touchRecognizer = nil;
    [self openPicker:nil];
}


#pragma mark - Pickerview

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return [arrayForMenu count];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setNewRoute:row];
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
       return 250;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayForMenu objectAtIndex:row];
}

/*
- (UIImage *)pickerView:(DSTPickerView *)pickerView imageForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 2) {
        return [UIImage imageNamed:@"demo"];
    }
    return nil;
}

- (UIFont *)pickerView:(DSTPickerView *)pickerView fontForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return [UIFont fontWithName:@"SnellRoundhand" size:20.0];
    }
    return nil; // default
}

- (UIColor *)pickerView:(UIPickerView *)pickerView colorForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 1) {
        return [UIColor blueColor];
    }
    return nil;
}
*/
#pragma mark ButtonAction

-(IBAction)showGoogleMap:(id)sender
{
	//[mSourceCity resignFirstResponder];
	//[mDestinationCity1 resignFirstResponder];
	
	citywalkGoogleMap *_Controller	= [[citywalkGoogleMap alloc]initWithNibName:@"citywalkGoogleMap" bundle:nil];
	
	//_Controller.startPoint = mSourceCity.text;
	_Controller.startPoint  = firstLocation;//[[[[[locationData_stored objectAtIndex:data] valueForKey:@"coordinates"] objectAtIndex:1] valueForKeyPath:@"name"] objectAtIndex:0];
    //NSLog(@"_Controller.startPoint: %@",_Controller.startPoint);
    
    self.DestinationCityArray = [[NSMutableArray alloc]init];
	/*
    if (mDestinationCity1.text != NULL ) {
		[DestinationCityArray addObject:mDestinationCity1.text];
		
	}
	*/
    [DestinationCityArray addObject:lastLocation];
	//_Controller.destination = DestinationCityArray;
    _Controller.destination = DestinationCityArray;
	
    // insert waypoints
    
    // add display name for annotation and a direction name for google to use
    //NSLog(@"storeDataID: %i",storeDataID);
    NSMutableArray *WP = [[[[locationData_stored objectAtIndex:storeDataID] valueForKey:@"coordinates"] objectAtIndex:1] valueForKeyPath:@"googlePoint"];
    
    NSMutableArray *wayPoints = [NSMutableArray arrayWithCapacity:[WP count]];
    
 //  NSLog(@"wayPoints: %@", WP);

    for (id wayPoint in WP) {
       
       [wayPoints addObject:wayPoint];
     
    }
[wayPoints removeLastObject];
[wayPoints removeObjectAtIndex:0];
_Controller.startPoint  = [[[[[locationData_stored objectAtIndex:storeDataID] valueForKey:@"coordinates"] objectAtIndex:1] valueForKeyPath:@"annotationTitle"] objectAtIndex:0];
 _Controller.endPoint = [[[[[locationData_stored objectAtIndex:storeDataID] valueForKey:@"coordinates"] objectAtIndex:1] valueForKeyPath:@"annotationTitle"] lastObject];
    _Controller.wayPoints = wayPoints;
    
    //NSLog(@"wayPoints: %@", wayPoints);
    
    
		_Controller.travelMode	= UICGTravelModeWalking;
	   
       
	[self.navigationController pushViewController:_Controller animated:YES];
	[_Controller release];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	//self.destinationCity1.text = nil;
//	self.destinationCity2.text = nil;
//	self.sourceCity.text = nil;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
   // [cityPicker release];
    //cityPicker = nil;
    [self setChooseroute:nil];
    //[self setCityPicker:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self releaseAllViews];
}


#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ( textField == mSourceCity) {
		[mSourceCity resignFirstResponder];
		[mDestinationCity1 becomeFirstResponder];
	}
	if ( textField == mDestinationCity1) {
		[mDestinationCity1 resignFirstResponder];
	}
	return YES;
}

- (void)dealloc {
	
    //[cityPicker release];
    [_chooseroute release];
    //[locationArrayToChange_stored release];
    [descriptionLabel release];
    [self releaseAllViews];
    [UIScrollView release];
    [super dealloc];
}
/*
- (IBAction)showScrollView:(id)sender {
    
    ScrollViewController *scrollView	= [[ScrollViewController alloc]initWithNibName:@"ScrollViewController" bundle:nil];
    [self.navigationController pushViewController:scrollView animated:YES];
	[scrollView release];
}
 */
 @end
