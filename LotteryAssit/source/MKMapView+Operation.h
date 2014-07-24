//
//  MKMapView+Operation.h
//  LotteryAssit
//
//  Created by ios on 14-7-23.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Operation)

-(void)opremoveOverlay:(Class)theClass;
-(void)opremoveAnnotation:(Class)theClass;


@end
