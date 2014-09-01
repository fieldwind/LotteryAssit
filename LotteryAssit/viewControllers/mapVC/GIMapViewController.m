//
//  GIMapViewController.m
//  LotteryAssit
//
//  Created by ios on 14-7-16.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "GIMapViewController.h"
#import "GIMapViewController+Help.h"
#import "WSAnnotation.h"
#import "LocalCalloutMapAnnotationView.h"
#import "CityCalloutMapAnnotationView.h"
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




@interface GIMapViewController (){
    CLPlacemark *thePlacemark;
    MKRoute *routeDetails;
    long spanX ; //meters
    long spanY ;
    long showMapLevel; //0,province, 1,city, 2,town
    
    CLLocationCoordinate2D currPos;
    CLLocationCoordinate2D desPos;
    routeStatus status;
    
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarItem;
@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) LocalCalloutAnnotation *localcalloutAnnotation;

@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
//@property (nonatomic, retain) BasicMapAnnotation *customAnnotation;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder* geocoder;

@property (nonatomic, strong) WSCity* city;
@property (nonatomic, strong) WSCity* town;
@property (nonatomic, strong) UIButton* cityBtn;
@property (nonatomic, strong) UIButton* townBtn;
@property (nonatomic, strong) UIButton* titleBtn;
@property (nonatomic, strong) UIButton* positionBtn;

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

CLLocationCoordinate2D coordinateHz = {30.18,120.16}; //杭州


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //default init map to hz
    currPos.latitude = 30.18;
    currPos.longitude = 120.16;
    desPos.latitude = 30.192; //bingJiang
    desPos.longitude = 120.170;
    desPos.latitude = 30.192; //嘉兴
    desPos.longitude = 120.970;
    
    [self checkLocationService];
    
    self.mapView.delegate = self;
    self.geocoder = [[CLGeocoder alloc] init];
    [self customeNavBar];
    
    //set defualt map region.
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinateHz,province_span,province_span) animated:YES]; //MKCoordinateRegionMake

    
    [self loacteCity:nil];
    

    //[self initLoadCoordinate];
    
}

-(void)customeNavBar
{
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat labelWidth = 55;
    
    UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(0, offsetY, 964, 44)];
    
    
    NSArray *segArray = @[@"浙江省",@"",@"",@"站点浏览",@"我的位置"];
    long i = 0;
    for(NSString* str in segArray){
        CGFloat offX = offsetX+labelWidth*i;
        CGFloat fontSize = 16.0;
        if(i == 2){
            labelWidth = 120;
        }
        if(i == 3){
            offX = 420;
            fontSize =  20.0;
            labelWidth = 220;
        }else if(i == 4){
            offX = 850;
            fontSize =  16.0;
            labelWidth = 100;
        }
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(offX, 10, labelWidth, 20)];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button addTarget:self action:@selector(tapGes:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        if(i == 1){
            self.cityBtn = button;
        }else if(i == 2){
            self.townBtn = button;
        }else if(i == 3){
            self.titleBtn = button;
        }else if(i == 4){
            self.positionBtn = button;
        }
        
        [leftView addSubview:button];

        i++;
    }
    
    
    self.navigationItem.titleView = leftView;
    
}



-(void)tapGes:(id)sender
{
    UIButton* view = (UIButton*) sender;
    //CGPoint pt = [tapGest locationInView:view];
    //NSLog(@"tapGEs:%@",[sender class]);
    
    switch (view.tag) {
        case 0:
            [self loacteCity:nil];
            [self.cityBtn setTitle:@"" forState:UIControlStateNormal];
            [self.townBtn setTitle:@"" forState:UIControlStateNormal];

            break;
            
        case 1:
            [self loacteCity:self.city];
            [self.townBtn setTitle:@"" forState:UIControlStateNormal];
            break;
            
        case 2:
            [self trigerGotoCity:self.town];
            break;
            
        case 4:
            if(rs_routing != status)
                [self locatePosition];
            break;
            
        default:
            break;
    }
    
//    if(CGRectContainsPoint(self.distButton.frame, pt)){
//        //NSLog(@"---tapGEs:%@",[sender class]);
//        if([self.delegate respondsToSelector:@selector(triggerDistanceBtn: annotation:)]){
//            [self.delegate triggerDistanceBtn:[self.distanceTxt.text doubleValue] annotation:self.annotation];
//        }
//    }
    
    
}

-(void)initLoadCoordinate
{
    
    WSSite* site = [[WSSite alloc]init];
    site.lat = currPos.latitude;
    site.lng = currPos.longitude;
    BasicMapAnnotation* annotation = [[BasicMapAnnotation alloc] initWithLatitude:site.lat andLongitude:site.lng];
    annotation.site = site;
    //annotation.site = site;
    [self.mapView addAnnotation:annotation];
    
    return;
    
    //init coordinate
    //CLLocationCoordinate2D coordinate = {30.25,120.2};
    spanX = 5000*100; //12500;
    spanY = spanX; // 2500;
    
    
    //dbg code
#if 1
    //NSString* orgName = @"杭州市滨江区创新大厦"; //@"杭州市滨江区彩虹城"; //@"ZIP CODE 310000";
    for(WSSite* site in self.siteArray){
        if([site.siteID isEqualToString:@"4028810e42784a570142786cdff50084"]){
            
        }
    }
    
//    CityMapAnnotation* annotation = [[CityMapAnnotation alloc] initWithLatitude:city.center_lat andLongitude:city.center_lon];
//    annotation.city = city;
//    [self.mapView addAnnotation:annotation];
    
    
//    site.lat = coordinate.latitude;
//    site.lng = coordinate.longitude;
//    
//    coordinate.latitude = site.lat;
//    coordinate.longitude = site.lng;
    
    
    
    NSString* orgName = @"浙江省杭州市";
    [self.geocoder geocodeAddressString:orgName completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            CLPlacemark* place = [placemarks lastObject];
            for(CLPlacemark* place in placemarks){
                //NSLog(@"name:%@",place.name);
                NSLog(@"%@",place);
            }
            
            //spanX = [self spanWithMapLevel:showMapLevel];
            spanY = spanX;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(place.location.coordinate,spanX,spanY) animated:YES]; //MKCoordinateRegionMake
                dispatch_after(2.0, dispatch_get_main_queue(), ^{
                    CityMapAnnotation* annotation = [[CityMapAnnotation alloc] initWithLatitude:currPos.latitude andLongitude:currPos.longitude];
                   // LocalMapAnnotation* annotation = [[LocalMapAnnotation alloc] initWithLatitude:currPos.latitude andLongitude:currPos.longitude];

                    [self.mapView addAnnotation:annotation];
                });
                
            });
        }
        
    }];
    
    
    
//    CLLocationCoordinate2D coordinate = {desPos.latitude,desPos.longitude};
//    
//    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,spanX,spanY) animated:YES];
    
    

    
    return;
#endif
    
    
    
}




-(void)loacteCity:(WSCity*)city
{
    [[UserDataManager sharedManager]accessCitys:^(WSCitys *citys, NSError *error) {
        NSString* orgName = city.org_name;;
        if(!city){
            if(citys.level == 1){
                orgName = @"浙江省杭州市";
                showMapLevel = 0;
            }else if([citys.cityArray count]){
                WSCity* acity = [citys.cityArray objectAtIndex:0];
                orgName = acity.org_name;
                showMapLevel = 1;
            }
        }else{
            showMapLevel = 1;
        }
//        if(showMapLevel == 0){
//        }else{
//            self.city = citys.cityArray;
//        }
        
        self.cityArray = citys.cityArray;

        
        
        if(!orgName || [orgName isEqualToString:@""]){
            orgName = city.name;
        }
        
        spanX = [self spanWithMapLevel:showMapLevel];
        spanY = spanX;
        CLLocationCoordinate2D coordinate = coordinateHz;

        if(showMapLevel == 0)
        {
//            [self.geocoder geocodeAddressString:orgName completionHandler:^(NSArray *placemarks, NSError *error) {
//                if(error){
//                    NSLog(@"%@",error);
//                }else{
//                    CLPlacemark* place = [placemarks lastObject];
//                    for(CLPlacemark* place in placemarks){
//                        //NSLog(@"name:%@",place.name);
//                        NSLog(@"%@",place);
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(place.location.coordinate,spanX,spanY) animated:YES]; //MKCoordinateRegionMake
//                        [self addAnnotation:[CityMapAnnotation class]];
//                    });
//                }
//                
//            }];
            
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,spanX,spanY) animated:YES];
            [self addAnnotation:[CityMapAnnotation class]];
        }else{
            coordinate.latitude = city.center_lat;
            coordinate.longitude = city.center_lon;
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,spanX,spanY) animated:YES];
            [self addAnnotation:[CityMapAnnotation class]];
        }
        
    } orgCode:city.org_code];
    
   
    
    
}


-(void)locatePosition
{
    //init localmanager
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy =  kCLLocationAccuracyBest;//kCLLocationAccuracyBestForNavigation; //kCLLocationAccuracyHundredMeters
    }
    
    [self.locationManager startUpdatingLocation];
}

-(void)addAnnotation:(Class)theClass
{
    [self.mapView opremoveAnnotation:[LocalCalloutAnnotation class]];
    [self.mapView opremoveAnnotation:[BasicMapAnnotation class]];
    [self.mapView opremoveAnnotation:[CityMapAnnotation class]];
    
    
    if([NSStringFromClass(theClass) isEqualToString: NSStringFromClass([LocalCalloutAnnotation class])]){
        
    }else if([NSStringFromClass(theClass) isEqualToString: NSStringFromClass([BasicMapAnnotation class])]){
        for(WSSite* site in self.siteArray){
//            site.lat = currPos.latitude;
//            site.lng = currPos.longitude;
            
            BasicMapAnnotation* annotation = [[BasicMapAnnotation alloc] initWithLatitude:site.lat andLongitude:site.lng];
            //dbg code.
#if 0
            if([site.siteID isEqualToString:@"2c90818142f9a6ba0142fa476d940061"]){
                site.lat = currPos.latitude;
                site.lng = currPos.longitude;
                annotation.site = site;
                [self.mapView addAnnotation:annotation];
                break;
            }
            else{
                continue;
            }
#endif
            annotation.site = site;
            [self.mapView addAnnotation:annotation];
           // break;
        }
    }else if([NSStringFromClass(theClass) isEqualToString: NSStringFromClass([CityMapAnnotation class])]){
        for(WSCity* city in self.cityArray){
            CityMapAnnotation* annotation = [[CityMapAnnotation alloc] initWithLatitude:city.center_lat andLongitude:city.center_lon];
            annotation.city = city;
            [self.mapView addAnnotation:annotation];
        }
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BOOL isReused = YES;

	
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    if([annotation isKindOfClass:[LocalMapAnnotation class]]){
        MKPinAnnotationView* view = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotationView"];
        if(!view)
        {
            view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotationView"] ;
        }else{
            view.annotation = annotation;
        }
		view.canShowCallout = NO;
		view.pinColor = MKPinAnnotationColorGreen;
        
        return view;
    }
    else if([annotation isKindOfClass:[LocalCalloutAnnotation class]]){
        LocalCalloutMapAnnotationView* view = (LocalCalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"LocalCalloutMapAnnotationView"];
        if(!view)
        {
            view = [[LocalCalloutMapAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"LocalCalloutMapAnnotationView"] ;
        }else{
            view.annotation = annotation;
        }

        view.parentAnnotationView = self.selectedAnnotationView;
        view.mapView = self.mapView;
        view.delegate = self;
        [view loadData];
        return view;
    }
    else if([annotation isKindOfClass:[CityMapAnnotation class]]){
        CityCalloutMapAnnotationView* view = (CityCalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CityCalloutMapAnnotationView"];
        if(!view)
        {
            view = [[CityCalloutMapAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"CityCalloutMapAnnotationView"] ;
        }else{
            view.annotation = annotation;
        }
        view.parentAnnotationView = self.selectedAnnotationView;
        view.mapView = self.mapView;
        view.delegate = self;
        
        CityMapAnnotation* ano = (CityMapAnnotation*)annotation;
        view.cityInfo = ano.city;
        [view loadData];
        return view;
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]] ) {
        SiteCalloutMapAnnotationView *calloutMapAnnotationView = (SiteCalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"SiteCalloutMapAnnotationView"];
		if (!calloutMapAnnotationView) {
            isReused = NO;
			calloutMapAnnotationView = [[SiteCalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SiteCalloutMapAnnotationView"] ;
		}else{
            calloutMapAnnotationView.annotation = annotation;
        }
        
        CalloutMapAnnotation* calloutAno = (CalloutMapAnnotation*)annotation;
        calloutMapAnnotationView.siteInfo = calloutAno.site;
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
        calloutMapAnnotationView.delegate = self;
        [calloutMapAnnotationView loadData];
		return calloutMapAnnotationView;
	}
    else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"BasicMapAnnotationView"];
        if(!annotationView){
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BasicMapAnnotationView"] ;
        }
        else{
            annotationView.annotation = annotation;
        }
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

#pragma mark - AnoViewDelegate
-(void)trigerGotoCity:(id)cityInfo
{
    WSCity* city = (WSCity*)cityInfo;
    
    if(showMapLevel == 0){
        self.city = city;
        [self.cityBtn setTitle:city.name forState:UIControlStateNormal];
        [self.townBtn setTitle:@"" forState:UIControlStateNormal];


        [self loacteCity:city];
    }else {
        self.town = city;
        [self.townBtn setTitle:city.name forState:UIControlStateNormal];


        //locate city
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = city.center_lat;
        coordinate.longitude = city.center_lon;
        spanX = [self spanWithMapLevel:2];
        spanY = spanX;
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,spanX,spanY) animated:YES]; //MKCoordinateRegionMake

        
        //show siteInfo.
        [[UserDataManager sharedManager]accessSites:^(NSArray *array, NSError *error) {
            if(!error && array){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.siteArray = array;
                    [self addAnnotation:[BasicMapAnnotation class]];
                });
            }
        } userID:[UserDataManager sharedManager].currUser orgCode:city.org_code];


    }
    
    //refresh titleview.
}

-(void)trigerGotoSite:(id)siteInfo
{
    [self resetRouteStatus];
    
    [self locatePosition];

    WSSite* site = (WSSite*)siteInfo;
    desPos.latitude = site.lat;
    desPos.longitude = site.lng;
    status = rs_routing;
    
    //[self route];
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
            
            NSString* titleString = [NSString stringWithFormat:@"距离目的地: %.1f米",routeDetails.distance];
            [self.titleBtn setTitle:titleString forState:UIControlStateNormal];

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
    //self.navigationItem.title = @"站点浏览";
    [self.titleBtn setTitle:@"站点浏览" forState:UIControlStateNormal];
    
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
