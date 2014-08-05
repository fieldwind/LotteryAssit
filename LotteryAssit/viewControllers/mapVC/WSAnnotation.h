//
//  WSAnnotation.h
//  LotteryAssit
//
//  Created by ios on 14-7-23.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMapAnnotation.h"
#import "WSClass.h"


@interface LocalMapAnnotation : GSMapAnnotation

@end



@interface LocalCalloutAnnotation : GSMapAnnotation

@end


@interface CityMapAnnotation : GSMapAnnotation

@property (nonatomic, retain) WSCity* city;

@end


@interface BasicMapAnnotation : GSMapAnnotation

@property (nonatomic, retain) WSSite* site;

@end




@interface CalloutMapAnnotation : GSMapAnnotation

@property (nonatomic, retain) WSSite* site;

@end