//
//  LocalCalloutMapAnnotationView.m
//  LotteryAssit
//
//  Created by ios on 14-7-18.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "LocalCalloutMapAnnotationView.h"

@interface LocalCalloutMapAnnotationView(){
    CGFloat offsetX ;
    CGFloat offsetY ;
    CGFloat imgHeight ;
    CGFloat labelHeight ;
    long labelIndx ;
    CGFloat width;
}

@property (nonatomic,retain) UITextField* distanceTxt;
@property (nonatomic,retain) UILabel* distButton;


@end

@implementation LocalCalloutMapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:tapGes];
        [self uiInit];
	}
	return self;
}




-(void)uiInit
{
    self.contentHeight = 38.0f;
    self.contentWidth = 138.0f; //140.0f;
    
    offsetX = 5.0f;
    offsetY = 5.0f;
    labelHeight = 25.0f;
    labelIndx = 0;
    
    
    self.distanceTxt = [[UITextField alloc]initWithFrame:CGRectMake(offsetX*2, offsetY, 60, labelHeight)];
    self.distanceTxt.text = @"500";
    self.distanceTxt.backgroundColor = [UIColor whiteColor];
    self.distanceTxt.font = Common_Font;
    self.distanceTxt.textAlignment = NSTextAlignmentCenter;
    self.distanceTxt.tag = 1;
    self.distanceTxt.clearsOnBeginEditing = YES;
    self.distanceTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    self.distButton = [[UILabel alloc]initWithFrame:CGRectMake(offsetX*2+70, offsetY, 50, labelHeight)];
    self.distButton.text = @"确定";
    self.distButton.font = Common_Font;
    self.distButton.tag = 2;
    //[self.distButton setTitle:@"确定" forState:UIControlStateNormal];

    
    [self.contentView addSubview:self.distanceTxt];
    [self.contentView addSubview:self.distButton];
    
}

#pragma mark - Action
-(void)tapGes:(id)sender
{
    UITapGestureRecognizer* tapGest = (UITapGestureRecognizer*)sender;
    UIView* view = tapGest.view;
    CGPoint pt = [tapGest locationInView:view];
    //NSLog(@"tapGEs:%@",[sender class]);
    
    if(CGRectContainsPoint(self.distButton.frame, pt)){
        //NSLog(@"---tapGEs:%@",[sender class]);
        if([self.delegate respondsToSelector:@selector(triggerDistanceBtn: annotation:)]){
            [self.delegate triggerDistanceBtn:[self.distanceTxt.text doubleValue] annotation:self.annotation];
        }
    }else{
        [self preventParentSelectionChange];
        [self performSelector:@selector(allowParentSelectionChange) withObject:nil afterDelay:1.0];
    }
    
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    

    
    
//    if(hitView.tag == 2){ //button
//        if([self.delegate respondsToSelector:@selector(triggerDistanceBtn:)]){
//            [self.delegate triggerDistanceBtn:[self.distanceTxt.text doubleValue]];
//        }
//    }
    
    if(hitView.tag == 1){
        [self preventParentSelectionChange];
        [self performSelector:@selector(allowParentSelectionChange) withObject:nil afterDelay:1.0];
    }
    
    
    return hitView;
}


@end
