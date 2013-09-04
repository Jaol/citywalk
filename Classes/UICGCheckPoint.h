//
//  UICGCheckPoint.h
//  SBMapWithRoute
//
//  Created by Surya Kant on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UICGCheckPoint : NSObject {
	
	NSDictionary *dictionaryRepresentation;
	NSArray *step;
    NSArray *sumStep;
	NSString *summaryHtml;
	NSMutableArray *wayPoints;
	NSMutableArray *mPlaceTitle;
    NSMutableArray *mPlaceDistance;
    NSMutableArray *summaryArray;
    NSString *removeSome;
}

@property (nonatomic, retain, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, retain) NSArray *step;
@property (nonatomic, retain, readonly) NSString *summaryHtml;
@property (nonatomic, retain, readonly) NSString *removeSome;
@property (nonatomic, retain) NSMutableArray *wayPoints;
@property (nonatomic, retain) NSMutableArray *mPlaceTitle;
@property (nonatomic, retain) NSMutableArray *mPlaceDistance;

+ (UICGCheckPoint *)CheckPointWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary;
@end
