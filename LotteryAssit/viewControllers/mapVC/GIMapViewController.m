//
//  GIMapViewController.m
//  LotteryAssit
//
//  Created by ios on 14-7-16.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "GIMapViewController.h"
#import "WSAnnotation.h"
#import "LocalCalloutMapAnnotationView.h"
#import "WSClass.h"
#import "UserDataManager.h"
#import <objc/runtime.h>
#import "MKMapView+Operation.h"
//#import "RegionAnnotationView.h"
//#import "RegionAnnotation.h"

typedef enum {
    rs_idle = 0,
    rs_routing,
    rs_finish
}routeStatus;

BOOL hadCheckLocationService;

@interface GIMapViewController (){
    CLPlacemark *thePlacemark;
    MKRoute *routeDetails;
    long spanX ; //meters
    long spanY ;
    
    CLLocationCoordinate2D currPos;
    CLLocationCoordinate2D desPos;
    routeStatus status;
}

@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) LocalCalloutAnnotation *localcalloutAnnotation;

@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
//@property (nonatomic, retain) BasicMapAnnotation *customAnnotation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation GIMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //default init map to hz
    currPos.latitude = 30.18;
    currPos.longitude = 120.16;
    desPos.latitude = 30.192; //bingJiang
    desPos.longitude = 120.170;
//    desPos.latitude = 30.192; //嘉兴
//    desPos.longitude = 120.970;
    
    [self checkLocationService];
    
    self.mapView.delegate = self;
    
    [self initLoadCoordinate];
    
    
    [self initSiteAnnotation];
    
}

-(void)initLoadCoordinate
{
    //init coordinate
    //CLLocationCoordinate2D coordinate = {30.25,120.2};
    spanX = 3000; //12500;
    spanY = spanX; // 2500;
    
    //coordinate with get city
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //dbg code
#if 1
    self.orgCode = @"杭州市滨江区创新大厦"; //@"杭州市滨江区彩虹城"; //@"ZIP CODE 310000";
    for(WSSite* site in self.dateSource){
        if([site.siteID isEqualToString:@"4028810e42784a570142786cdff50084"]){
            CLLocationCoordinate2D coordinate = {desPos.latitude,desPos.longitude};
            site.lat = coordinate.latitude;
            site.lng = coordinate.longitude;
            
            coordinate.latitude = site.lat;
            coordinate.longitude = site.lng;
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,spanX,spanY) animated:YES];
        }
    }
    
    LocalMapAnnotation* annotation = [[LocalMapAnnotation alloc] initWithLatitude:currPos.latitude andLongitude:currPos.longitude];
    [self.mapView addAnnotation:annotation];
    
    return;
#endif
    
    

    
    [geocoder geocodeAddressString:self.orgCode completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            CLPlacemark* place = [placemarks lastObject];
//            for(CLPlacemark* place in placemarks){
//                //NSLog(@"name:%@",place.name);
//                NSLog(@"%@",place);
//            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(place.location.coordinate,spanX,spanY) animated:YES]; //MKCoordinateRegionMake
            });
        }

    }];
    
}


-(void)initLocationManager
{
    //init localmanager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy =  kCLLocationAccuracyBest;//kCLLocationAccuracyBestForNavigation; //kCLLocationAccuracyHundredMeters
    [self.locationManager startUpdatingLocation];
}

-(void)initSiteAnnotation
{
    for(WSSite* site in self.dateSource){
        BasicMapAnnotation* annotation = [[BasicMapAnnotation alloc] initWithLatitude:site.lat andLongitude:site.lng];
        annotation.site = site;
        [self.mapView addAnnotation:annotation];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkLocationService
{
    if(hadCheckLocationService)
        return;
    
    hadCheckLocationService = YES;
    
    UIAlertView* alView;
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    switch (authStatus) {
        case kCLAuthorizationStatusAuthorized:
            break;
            
        case kCLAuthorizationStatusRestricted:
            break;
            
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusDenied:
            alView = [[UIAlertView alloc] initWithTitle:nil
                                                message:@"请去设置->隐私->定位服务->福彩信息系统打开定位服务"
                                               delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil, nil];
            
            [alView show];
            break;
            
        default:
            break;
    }
}

-(BOOL)isArrived:(CLLocation*)location
{
    CLLocation* desLocation = [[CLLocation alloc]initWithLatitude:desPos.latitude longitude:desPos.longitude];
    CLLocationDistance distance = [location distanceFromLocation:desLocation];
    if(distance < 10){ //meters
        return YES;
    }
    
    return NO;
}

//状态“1”增，“2”：变，“3”退，“4”移，“5”售，“6”停，“7”退灰色
-(UIImage*)siteImage:(WSSite*)site
{
    UIImage *image = [UIImage imageNamed:@"dotsz_sale"];
    long siteStatus = site.sitestatus;
    
    switch (siteStatus) {
        case 1:
            image = [UIImage imageNamed:@"dotsz_proc_add"];
            break;
            
        case 2:
            image = [UIImage imageNamed:@"dotsz_proc_change"];
            break;
            
        case 3:
            image = [UIImage imageNamed:@"dotsz_proc_del"];
            break;
            
        case 4:
            image = [UIImage imageNamed:@"dotsz_move"];
            break;
            
        case 5:
            image = [UIImage imageNamed:@"dotsz_sale"];
            break;
            
        case 6:
            image = [UIImage imageNamed:@"dotsz_stop"];
            break;
            
        case 7:
            image = [UIImage imageNamed:@"dotsz_del_gray"];
            break;
            
        default:
            break;
    }
    
    return image;
}


-(CLLocationDistance)distance:(BOOL)isLangititude
{
    CLLocationDistance dist;
    
    if(isLangititude){
        CLLocation* curLocation = [[CLLocation alloc]initWithLatitude:currPos.latitude longitude:currPos.longitude];
        CLLocation* desLocation = [[CLLocation alloc]initWithLatitude:desPos.latitude longitude:currPos.longitude];
        dist = [curLocation distanceFromLocation:desLocation];
    }else{
        CLLocation* curLocation = [[CLLocation alloc]initWithLatitude:currPos.latitude longitude:currPos.longitude];
        CLLocation* desLocation = [[CLLocation alloc]initWithLatitude:currPos.latitude longitude:desPos.longitude];
        dist = [curLocation distanceFromLocation:desLocation];
    }
    
    dist += dist*3/10;
    return dist;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.mapView opremoveAnnotation:[LocalMapAnnotation class]];
    
    CLLocation* location = [locations lastObject];
    currPos.latitude = location.coordinate.latitude;
    currPos.longitude = location.coordinate.longitude;
    
    
    LocalMapAnnotation* annotation = [[LocalMapAnnotation alloc] initWithLatitude:currPos.latitude andLongitude:currPos.longitude];
    [self.mapView addAnnotation:annotation];
    

    CLLocation* centerLocation = [[CLLocation alloc]initWithLatitude:(currPos.latitude+desPos.latitude)/2 longitude:(currPos.longitude+desPos.longitude)/2];
    CLLocationDistance longiDistance = [self distance:NO];
    CLLocationDistance latiDistance = [self distance:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, latiDistance, longiDistance);
    [self.mapView setRegion:region animated:YES];
    
    if(rs_routing == status){
        if([self isArrived:location]){
            [self resetRouteStatus];
        }else{
            [self route];
        }
    }
}



#pragma mark - mapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        BasicMapAnnotation* basicAnno = (BasicMapAnnotation*)view.annotation;
        [[UserDataManager sharedManager]accessSite:^(id siteInfo, NSError *error) {
            if(!error){
                if (self.calloutAnnotation == nil) {
                    self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                               andLongitude:view.annotation.coordinate.longitude];
                } else {
                    self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
                    self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
                }
                self.calloutAnnotation.site = basicAnno.site;
                [self.mapView addAnnotation:self.calloutAnnotation];
                self.selectedAnnotationView = view;
            }
        } siteInfo:basicAnno.site];
	}else if([view.annotation isKindOfClass:[LocalMapAnnotation class]]){
        if (self.localcalloutAnnotation == nil) {
            self.localcalloutAnnotation = [[LocalCalloutAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                       andLongitude:view.annotation.coordinate.longitude];
        } else {
            self.localcalloutAnnotation.latitude = view.annotation.coordinate.latitude;
            self.localcalloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
        [self.mapView addAnnotation:self.localcalloutAnnotation];
        self.selectedAnnotationView = view;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
	if (self.calloutAnnotation && [view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        NSNumber* isPrevent = objc_getAssociatedObject(view, @"preFlag");
        if(![isPrevent boolValue]){
            [self.mapView removeAnnotation: self.calloutAnnotation];
        }
	}
    
    if (self.localcalloutAnnotation && [view.annotation isKindOfClass:[LocalMapAnnotation class]]) {
        NSNumber* isPrevent = objc_getAssociatedObject(view, @"preFlag");
        if(![isPrevent boolValue]){
            [self.mapView removeAnnotation: self.localcalloutAnnotation];
        }
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	/*if([annotationView isKindOfClass:[RegionAnnotationView class]]) {
		RegionAnnotationView *regionView = (RegionAnnotationView *)annotationView;
		RegionAnnotation *regionAnnotation = (RegionAnnotation *)regionView.annotation;
		
		// If the annotation view is starting to be dragged, remove the overlay and stop monitoring the region.
		if (newState == MKAnnotationViewDragStateStarting) {
			[regionView removeRadiusOverlay];
			
			[self.locationManager stopMonitoringForRegion:regionAnnotation.region];
		}
		
		// Once the annotation view has been dragged and placed in a new location, update and add the overlay and begin monitoring the new region.
		if (oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding) {
			[regionView updateRadiusOverlay];
			
			CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:regionAnnotation.coordinate radius:1000.0 identifier:[NSString stringWithFormat:@"%f, %f", regionAnnotation.coordinate.latitude, regionAnnotation.coordinate.longitude]];
			regionAnnotation.region = newRegion;
			
			[self.locationManager startMonitoringForRegion:regionAnnotation.region desiredAccuracy:kCLLocationAccuracyBest];
		}
	}*/
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    if([annotation isKindOfClass:[LocalMapAnnotation class]]){
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
        
        return annotationView;
    }
    else if([annotation isKindOfClass:[LocalCalloutAnnotation class]]){
        LocalCalloutMapAnnotationView* view = [[LocalCalloutMapAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"LocalCalloutMapAnnotationView"] ;
        view.parentAnnotationView = self.selectedAnnotationView;
        view.mapView = self.mapView;
        view.delegate = self;
        return view;
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]] ) {
        BOOL isReused = YES;
        SiteCalloutMapAnnotationView *calloutMapAnnotationView = (SiteCalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
		if (!calloutMapAnnotationView) {
            isReused = NO;
			calloutMapAnnotationView = [[SiteCalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"] ;
		}
        
        CalloutMapAnnotation* calloutAno = (CalloutMapAnnotation*)annotation;
        calloutMapAnnotationView.siteInfo = calloutAno.site;
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
        calloutMapAnnotationView.delegate = self;
        if(!isReused)
            [calloutMapAnnotationView uiInit];
		return calloutMapAnnotationView;
	}
    else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
		MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation"] ;
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
        
        BasicMapAnnotation* basicAno = (BasicMapAnnotation*)annotation;
        UIImage *flagImage = [self siteImage:basicAno.site];
        
        // size the flag down to the appropriate size
        CGRect resizeRect;
        resizeRect.size = flagImage.size;
        CGSize maxSize = CGRectInset(self.view.bounds,10.0f,10.0f).size;
        maxSize.height -= self.navigationController.navigationBar.frame.size.height + 40.0f;
        if (resizeRect.size.width > maxSize.width)
            resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
        if (resizeRect.size.height > maxSize.height)
            resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
        
        resizeRect.origin = CGPointMake(0.0, 0.0);
        UIGraphicsBeginImageContext(resizeRect.size);
        [flagImage drawInRect:resizeRect];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        annotationView.image = resizedImage;
        annotationView.opaque = NO;
        
        // offset the flag annotation so that the flag pole rests on the map coordinate
        annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2 );
        
		return annotationView;
	}
	
	
	return nil;
}

#pragma mark - SiteAnoViewDelegate
-(void)trigerGotoSite:(id)siteInfo
{
    [self resetRouteStatus];
    
    [self initLocationManager];

    WSSite* site = (WSSite*)siteInfo;
    desPos.latitude = site.lat;
    desPos.longitude = site.lng;
    status = rs_routing;
    
//    [self route];
}

-(void)triggerDistanceBtn:(double)distance annotation:(id)annotation
{
    if (self.localcalloutAnnotation) {
		[self.mapView removeAnnotation: self.localcalloutAnnotation];
	}
    
    //draw circle
    LocalCalloutAnnotation* theAnnotation = (LocalCalloutAnnotation*)annotation;
    [self removeRadiusOverlay:theAnnotation];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:theAnnotation.coordinate radius:distance]];
    
    
}

- (void)removeRadiusOverlay:(LocalCalloutAnnotation*)theAnnotation
{
	// Find the overlay for this annotation view and remove it if it has the same coordinates.
	for (id overlay in [self.mapView overlays]) {
		if ([overlay isKindOfClass:[MKCircle class]]) {
			MKCircle *circleOverlay = (MKCircle *)overlay;
			CLLocationCoordinate2D coord = circleOverlay.coordinate;
			
			if (coord.latitude == theAnnotation.coordinate.latitude && coord.longitude == theAnnotation.coordinate.longitude) {
				[self.mapView removeOverlay:overlay];
			}
		}
	}
}



#pragma mark - mapNavigation
- (void)route
{
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    
    
    MKPlacemark *source = [[MKPlacemark alloc] initWithCoordinate:currPos addressDictionary:nil];
    MKPlacemark *dest = [[MKPlacemark alloc] initWithCoordinate:desPos addressDictionary:nil];
    
    
    [directionsRequest setSource:[[MKMapItem alloc]initWithPlacemark:source]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:dest]];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            //clear old route overlay
            [self clearRoute];
            
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
            self.navigationItem.title = [NSString stringWithFormat:@"距离目的地: %.1f米",routeDetails.distance];
//            self.destinationLabel.text = [placemark.addressDictionary objectForKey:@"Street"];
//            self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f Miles", routeDetails.distance/1609.344];
//            self.transportLabel.text = [NSString stringWithFormat:@"%u" ,routeDetails.transportType];
//            self.allSteps = @"";
//            for (int i = 0; i < routeDetails.steps.count; i++) {
//                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
//                NSString *newStep = step.instructions;
//                self.allSteps = [self.allSteps stringByAppendingString:newStep];
//                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
//                self.steps.text = self.allSteps;
//            }
        }
    }];
}


- (void)clearRoute
{
    [self.mapView removeOverlay:routeDetails.polyline];
    routeDetails = nil;
}

-(void)resetRouteStatus
{
    status = rs_idle;
    self.navigationItem.title = @"站点浏览";
    
    [self clearRoute];
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
		circleRenderer.strokeColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.6];
		circleRenderer.fillColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
		circleRenderer.lineWidth = 2;
        
		return circleRenderer;
	}
    else{
        MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
        routeLineRenderer.strokeColor = [UIColor redColor];
        routeLineRenderer.lineWidth = 5;
        return routeLineRenderer;
    }
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backAct:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
