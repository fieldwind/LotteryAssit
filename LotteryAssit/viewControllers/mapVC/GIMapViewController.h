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

#define province_span (500*1000)
#define city_span (50*1000)
#define town_span (7*1000)

@interface GIMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,SiteAnoViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) NSArray* cityArray;
@property (nonatomic,retain) NSArray* townArray;
@property (nonatomic,retain) NSArray* siteArray;

//@property (nonatomic,retain) NSString* orgName;
@property (nonatomic,retain) NSString* orgCode;

@end
