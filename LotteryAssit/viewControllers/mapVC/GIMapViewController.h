//
//  GIMapViewController.h
//  LotteryAssit
//
//  Created by ios on 14-7-16.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SiteCalloutMapAnnotationView.h"


@interface GIMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,SiteAnoViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) NSArray* dateSource;
@property (nonatomic,retain) NSString* orgCode;

@end
