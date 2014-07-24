//
//  MKMapView+Operation.m
//  LotteryAssit
//
//  Created by ios on 14-7-23.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "MKMapView+Operation.h"

@implementation MKMapView (Operation)


-(void)opremoveOverlay:(Class)theClass
{
    for (id overlay in [self overlays]) {
		if ([overlay isKindOfClass:theClass]) {
            [self removeOverlay:overlay];
		}
	}
}

-(void)opremoveAnnotation:(Class)theClass
{
    for (id annotation in [self annotations]) {
		if ([annotation isKindOfClass:theClass]) {
            [self removeAnnotation:annotation];
		}
	}
}

@end
