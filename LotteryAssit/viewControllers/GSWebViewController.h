//
//  GSWebViewController.h
//  EOffice
//
//  Created by ios on 14-7-1.
//  Copyright (c) 2014年 Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic) NSString* urlString;

//-(void)loadWebContent:(NSURL*)url;

@end
