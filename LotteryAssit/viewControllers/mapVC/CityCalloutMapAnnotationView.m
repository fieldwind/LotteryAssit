//
//  CityCalloutMapAnnotationView.m
//  LotteryAssit
//
//  Created by ios on 14-8-5.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "CityCalloutMapAnnotationView.h"

@implementation CityCalloutMapAnnotationView{
    CGFloat offsetX ;
    CGFloat offsetY ;
    CGFloat imgHeight ;
    CGFloat labelHeight ;
    long labelIndx ;
    CGFloat width;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.contentBkgColor = HexColor2UIColor(192, 119, 202, 1); //[UIColor orangeColor];
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:tapGes];
        [self uiInit];
	}
	return self;
}




-(void)uiInit
{
    self.contentHeight = 28.0f;
    self.contentWidth = 70.0f;
    
    offsetX = 5.0f;
    offsetY = 5.0f;
    labelHeight = 25.0f;
    labelIndx = 0;
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, offsetY, self.contentWidth-offsetX*3, labelHeight)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.text = @"55"; //self.cityInfo.betting_num;
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:label];
    
}


#pragma mark - Action
-(void)tapGes:(id)sender
{
    UITapGestureRecognizer* tapGest = (UITapGestureRecognizer*)sender;
    UIView* view = tapGest.view;
    CGPoint pt = [tapGest locationInView:view];
    //NSLog(@"tapGEs:%@",[sender class]);
    
//    if([self.delegate respondsToSelector:@selector(triggerDistanceBtn: annotation:)]){
//        [self.delegate triggerDistanceBtn:[self.distanceTxt.text doubleValue] annotation:self.annotation];
//    }
    
}

@end
