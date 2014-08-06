//
//  UserDataManager.h
//  LotteryAssit
//
//  Created by ios on 14-7-17.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSClass.h"

@class WSSite;

@interface UserDataManager : NSObject
+ (UserDataManager *)sharedManager;

@property (nonatomic) BOOL isSentDeviceToken;
@property (nonatomic,retain) NSString* currUser;


-(void)sendDevcieToken;
-(void)accessCurrUser;
-(void)accessSites:(void (^)(NSArray* array, NSError* error))response userID:(NSString*)userID orgCode:(NSString*)orgCode;
-(void)accessSite:(void(^)(id siteInfo, NSError* error))response siteInfo:(WSSite*)siteInfo;
-(void)accessImage:(void(^)(NSData* img, NSError* error))response imageid:(NSString*)imageid;
-(void)accessCitys:(void (^)(WSCitys* array, NSError* error))response orgCode:(NSString*)orgCode;


@end
