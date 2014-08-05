//
//  GIMapViewController+Help.m
//  LotteryAssit
//
//  Created by ios on 14-8-5.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "GIMapViewController+Help.h"


#define province_span (500*1000)
#define city_span (5*1000)
#define town_span (1500)

@implementation GIMapViewController (Help)


-(long)spanWithMapLevel:(long)showMapLevel
{
    //return city_span;
    
    long span = province_span;
    switch (showMapLevel) {
        case 0:
            span = province_span;
            break;
            
        case 1:
            span = city_span;
            break;
            
        case 2:
            span = town_span;
            break;
            
        default:
            break;
    }
    
    return span;
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

BOOL hadCheckLocationService;

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

@end
