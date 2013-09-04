//
//  SBCheckPoints.h
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//

#import <UIKit/UIKit.h>


@interface citywalkCheckPointViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

	IBOutlet UITableView *mTable;
	NSMutableArray *mCheckPoints;
    NSMutableArray *mPlaceDistance;
}
@property (nonatomic,retain) UITableView *mTable;
@property (nonatomic,retain) NSMutableArray *mCheckPoints;
@property (nonatomic, retain) NSMutableArray *mPlaceDistance;

@end
