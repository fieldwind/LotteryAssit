//
//  SiteCalloutMapAnnotationView.m
//  CustomMapAnnotationExample
//
//  Created by ios on 14-7-15.
//
//

#import "SiteCalloutMapAnnotationView.h"
#import "UIImageView+AFNetworking.h"
#import "GSProjectHeader.h"
#import "GIEleViewController.h"
#import "UserDataManager.h"

@interface SiteCalloutMapAnnotationView(){
    
    CGFloat offsetX ;
    CGFloat offsetY ;
    CGFloat imgHeight ;
    CGFloat labelHeight ;
    long labelIndx ;
}

@property (nonatomic,retain) UIImageView* imageView;


@property (nonatomic,retain) UILabel* IdLabel;
@property (nonatomic,retain) UILabel* telLabel;

@property (nonatomic,retain) UILabel* addressLabel;

@property (nonatomic,retain) UILabel* nameLabel;
@property (nonatomic,retain) UILabel* phoneLabel;


@property (nonatomic,retain) UILabel* cardNoLabel;

@property (nonatomic,retain) UILabel* startLabel;
@property (nonatomic,retain) UILabel* salerLabel;

@property (nonatomic,retain) UILabel* submitLabel;

@property (nonatomic,retain) UILabel* fromTxt;
@property (nonatomic,retain) UILabel* goLabel;
@property (nonatomic,retain) UILabel* toTxt;

@property (nonatomic,retain) UILabel* navLabel;

@property (nonatomic,retain) UIWebView* imageWebView;



@property (nonatomic,retain) GSPageCtrViewController* pageCtrVC;
@end

@implementation SiteCalloutMapAnnotationView

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
	}
	return self;
}




-(UILabel*)createLabel:(NSString*)string
{
    CGFloat labelOffsetY = offsetY+imgHeight+labelHeight*labelIndx;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(offsetX, labelOffsetY, self.contentWidth-2*offsetX, labelHeight)];
    label.text = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Common_Font;
    
    labelIndx++;
    
    return label;
}

#define sencond_Label_Width 166
-(UILabel*)createLabel1:(NSString*)string
{
    CGFloat labelOffsetY = offsetY+imgHeight+labelHeight*labelIndx;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(offsetX, labelOffsetY, self.contentWidth-2*offsetX-sencond_Label_Width, labelHeight)];
    label.text = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Common_Font;
    
    
    return label;
}

-(UILabel*)createLabel2:(NSString*)string
{
    CGFloat labelOffsetY = offsetY+imgHeight+labelHeight*labelIndx;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.contentWidth-offsetX-sencond_Label_Width, labelOffsetY, sencond_Label_Width, labelHeight)];
    label.text = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Common_Font;
    
    labelIndx++;

    return label;
}

-(void)uiInit
{
    self.contentWidth = 350.0f;
    self.contentHeight = 340.0f;
    
    offsetX = 5.0f;
    offsetY = 5.0f;
    imgHeight = 180.0f;
    labelHeight = 20.0f;
    labelIndx = 0;
   
    
#if 0
    UIImage *image = [UIImage imageNamed:@"asynchrony-logo-small.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image] ;
    self.imageView.frame = CGRectMake(offsetX, offsetY, width, imgHeight); //asynchronyLogoView.frame.size.height
    NSString* imageid = [self.siteInfo.imagelist objectAtIndex:0];
    
    [[UserDataManager sharedManager]accessImage:^(NSData *img, NSError *error) {
        //set image
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [UIImage imageWithData:img];
            self.imageView.image = image;
        });
    } imageid:imageid];
    
    [self.contentView addSubview:self.imageView];


#endif
    
    //use webview.
    self.imageWebView = [[UIWebView alloc]initWithFrame:CGRectMake(offsetX, offsetY, self.contentWidth-offsetX*2-30, imgHeight)]; //-30 is the offset for contentview.
    self.imageWebView.backgroundColor = [UIColor yellowColor];
    NSString* imageURL = [NSString stringWithFormat:@"%@oa/shenji/ipad/lunbo.html?id=%@",Server_BaseURL,self.siteInfo.siteID];
    NSURL *requestURL = [NSURL URLWithString:imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [self.contentView addSubview:self.imageWebView];
    
    [self.imageWebView loadRequest:request];
    
    

    
    NSString* str = nil;
    
    str = [NSString stringWithFormat:@"编号: %@",self.siteInfo.logical_number];
    self.IdLabel = [self createLabel1:str];
    str = [NSString stringWithFormat:@"电话: %@",self.siteInfo.phone];
    str = [NSString stringWithFormat:@"电话: 13322221111"];
    self.telLabel = [self createLabel2:str];
    
    str = [NSString stringWithFormat:@"地址: %@", self.siteInfo.address];
    self.addressLabel = [self createLabel:str];
    
    str = [NSString stringWithFormat:@"代销者: %@", self.siteInfo.Per_name];
    self.nameLabel = [self createLabel1:str];
    str = [NSString stringWithFormat:@"电话: %@", self.siteInfo.link_phone];
    self.phoneLabel = [self createLabel2:str];
    
    str = [NSString stringWithFormat:@"身份证号: %@", self.siteInfo.card_no];
    self.cardNoLabel = [self createLabel:str];
    
    str = [NSString stringWithFormat:@"开机日期: %@", self.siteInfo.create_date];
    self.startLabel = [self createLabel:str];
    
//    str = [NSString stringWithFormat:@"销售员: %@", self.siteInfo.Per_name];
//    self.salerLabel = [self createLabel:str];
    
    str = [NSString stringWithFormat:@"上报日期: %@", self.siteInfo.pos_date];
    self.submitLabel = [self createLabel:str];
    
#define form_width 80
#define go_width 30
#define to_width 70
#define nav_width 60
    
    CGFloat offX = offsetX;
    CGFloat offY = offsetY+imgHeight+labelHeight*labelIndx;
    self.fromTxt = [[UILabel alloc]initWithFrame:CGRectMake(offX, offY, form_width, labelHeight)];
    self.fromTxt.text = @"出发地";
    
    offX += form_width+offsetX;
    self.goLabel = [[UILabel alloc]initWithFrame:CGRectMake(offX, offY, go_width, labelHeight)];
    self.goLabel.text = @"到";
    
    offX += go_width+offsetX;
    self.toTxt = [[UILabel alloc]initWithFrame:CGRectMake(offX, offY, to_width, labelHeight)];
    self.toTxt.text = @"当前位置";
    
    offX += to_width+50;
    self.navLabel = [[UILabel alloc]initWithFrame:CGRectMake(offX, offY, nav_width, labelHeight)];
    self.navLabel.text = @"确定";
    

    [self.contentView addSubview:self.IdLabel];
    [self.contentView addSubview:self.telLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.cardNoLabel];
    [self.contentView addSubview:self.startLabel];
 //   [self.contentView addSubview:self.salerLabel];
    [self.contentView addSubview:self.submitLabel];
    
    [self.contentView addSubview:self.fromTxt];
    [self.contentView addSubview:self.goLabel];
    [self.contentView addSubview:self.toTxt];
    
    [self.contentView addSubview:self.navLabel];

}

#pragma mark - Action
-(void)tapGes:(id)sender
{
    UITapGestureRecognizer* tapGest = (UITapGestureRecognizer*)sender;
    UIView* view = tapGest.view;
    CGPoint pt = [tapGest locationInView:view];
//    NSLog(@"tapGEs:%@",[sender class]);
//    
//    if(CGRectContainsPoint(self.imageView.frame, pt)){
//        NSLog(@"---tapGEs:%@",[sender class]);
//    }
    
    if(CGRectContainsPoint(self.navLabel.frame, pt)){
        if([self.delegate respondsToSelector:@selector(trigerGotoSite:)]){
            [self.delegate trigerGotoSite:self.siteInfo];
        }
    }else{
        [self preventParentSelectionChange];
        [self performSelector:@selector(allowParentSelectionChange) withObject:nil afterDelay:1.0];
    }
}

@end
