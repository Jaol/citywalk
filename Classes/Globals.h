//
//  Globals.h
//  Citywalk
//
//  Created by JAkob Højgård Olsen
//  Copyright 2013 Grafect All rights reserved.
//
#import <Foundation/Foundation.h>

extern NSMutableArray *locationsArray_stored;
extern NSMutableArray *locationData_stored;
extern NSString *firstLocation;
extern NSMutableArray *lastLocation;
extern NSMutableArray *locationArrayToChange_stored;

@interface Globals : NSObject {
    
}
@property (nonatomic, retain)NSMutableArray *locationArrayToChange_stored;
@end