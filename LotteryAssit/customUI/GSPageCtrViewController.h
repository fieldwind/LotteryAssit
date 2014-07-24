//
//  GSPageCtrViewController.h
//  iProtection
//
//  Created by ios on 14-7-11.
//  Copyright (c) 2014年 zjhcsoftios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSProjectHeader.h"

@interface GSPageEleViewController : UIViewController
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textView;

@property (nonatomic, strong) id content;

-(void)loadContent;

@end

@interface GSPageCtrViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic) Class theClass;

@end
