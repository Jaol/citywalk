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
}
@property (nonatomic,retain) UITableView *mTable;
@property (nonatomic,retain) NSMutableArray *mCheckPoints;

@end
