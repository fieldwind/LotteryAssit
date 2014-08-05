//
//  GIMapViewController+Help.h
//  LotteryAssit
//
//  Created by ios on 14-8-5.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "GIMapViewController.h"

@interface GIMapViewController (Help)

-(long)spanWithMapLevel:(long)showMapLevel;
-(UIImage*)siteImage:(WSSite*)site;
-(void)checkLocationService;


@end
