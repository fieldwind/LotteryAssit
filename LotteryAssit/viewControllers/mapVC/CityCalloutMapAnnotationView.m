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
        self.notFitMap = YES;
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:tapGes];
       // [self uiInit];
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
    if(!self.cityInfo)
        label.text = @"55"; //
    else
        label.text = self.cityInfo.betting_num;
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [self.contentView addSubview:label];
    
}




- (void)drawRect:(CGRect)rect {
    
	CGFloat stroke = 1.0;
	CGFloat radius = 2.0; //7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat parentX = self.contentWidth-40; //[self relativeParentXPosition];
	
    
	rect = self.bounds;
	rect.size.width -= stroke + 14;
	rect.size.height -= stroke + CalloutMapAnnotationViewHeightAboveParent - self.offsetFromParent.y + CalloutMapAnnotationViewBottomShadowBufferSize;
	rect.origin.x += stroke / 2.0 + 7;
	rect.origin.y += stroke / 2.0;
	
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
				 radius, M_PI, M_PI / 2, 1);
    
    
    CGPathAddLineToPoint(path, NULL, parentX - 15,
						 rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX,
						 rect.origin.y + rect.size.height + 15);
	CGPathAddLineToPoint(path, NULL, parentX + 15,
						 rect.origin.y + rect.size.height);
    
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius,
						 rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius,
				 rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
				 radius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius,
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(path);
    
    
	
	//Fill Callout Bubble & Add Shadow
	color = self.contentBkgColor;
    //color = [[UIColor blackColor] colorWithAlphaComponent:.6];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
    
    
	//Stroke Callout Bubble
	color = self.contentBkgColor;
    //color = [[UIColor darkGrayColor] colorWithAlphaComponent:.9];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	
	//Determine Size for Gloss
	CGRect glossRect = self.bounds;
	glossRect.size.width = rect.size.width - stroke;
	glossRect.size.height = (rect.size.height - stroke) / 2;
	glossRect.origin.x = rect.origin.x + stroke / 2;
	glossRect.origin.y += rect.origin.y + stroke / 2;
	
	CGFloat glossTopRadius = radius - stroke / 2;
	CGFloat glossBottomRadius = radius / 1.5;
	
	//Create Path For Gloss
	CGMutablePathRef glossPath = CGPathCreateMutable();
	CGPathMoveToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossTopRadius);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossRect.size.height - glossBottomRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius,
				 glossBottomRadius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius,
						 glossRect.origin.y + glossRect.size.height);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius,
				 glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width, glossRect.origin.y + glossTopRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossTopRadius, glossRect.origin.y + glossTopRadius,
				 glossTopRadius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius,
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(glossPath);
	
	//Fill Gloss Path
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	CGFloat colors[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
	};
	CGFloat locations[] = { 0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 2);
	CGPoint startPoint = glossRect.origin;
	CGPoint endPoint = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	//Gradient Stroke Gloss Path
	CGContextAddPath(context, glossPath);
	CGContextSetLineWidth(context, 2);
	CGContextReplacePathWithStrokedPath(context);
	CGContextClip(context);
	CGFloat colors2[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
		1, 1, 1, .0,
	};
	CGFloat locations2[] = { 0, .1, 1.0 };
	CGGradientRef gradient2 = CGGradientCreateWithColorComponents(space, colors2, locations2, 3);
	CGPoint startPoint2 = glossRect.origin;
	CGPoint endPoint2 = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient2, startPoint2, endPoint2, 0);
	
	//Cleanup
	CGPathRelease(path);
	CGPathRelease(glossPath);
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
	CGGradientRelease(gradient2);
}


#pragma mark - Action
-(void)tapGes:(id)sender
{
//    UITapGestureRecognizer* tapGest = (UITapGestureRecognizer*)sender;
//    UIView* view = tapGest.view;
//    CGPoint pt = [tapGest locationInView:view];
//    //NSLog(@"tapGEs:%@",[sender class]);
    
    if([self.delegate respondsToSelector:@selector(trigerGotoSite:)]){
        [self.delegate trigerGotoCity:self.cityInfo];
    }
    
}

@end
