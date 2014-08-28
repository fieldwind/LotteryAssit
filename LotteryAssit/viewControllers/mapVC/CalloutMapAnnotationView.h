#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GSProjectHeader.h"

#define CalloutMapAnnotationViewBottomShadowBufferSize 6.0f
#define CalloutMapAnnotationViewContentHeightBuffer 8.0f
#define CalloutMapAnnotationViewHeightAboveParent 2.0f

@protocol SiteAnoViewDelegate <NSObject>

@optional
-(void)trigerGotoCity:(id)cityInfo;
-(void)trigerGotoSite:(id)siteInfo;
-(void)triggerDistanceBtn:(double)distance annotation:(id)annotation;
@end

@interface CalloutMapAnnotationView : MKAnnotationView {
	MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
}

@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIColor *contentBkgColor;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) CGFloat contentWidth;
@property (assign) id delegate;
@property (nonatomic) BOOL notFitMap;
@property (nonatomic, readonly) CGFloat yShadowOffset;


- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;

- (void) preventParentSelectionChange;
- (void) allowParentSelectionChange ;

-(void)loadData;
-(void)uiInit;


@end
