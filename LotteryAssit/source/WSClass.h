//
//  WSClass.h
//  LotteryAssit
//
//  Created by ios on 14-7-14.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSClass : NSObject

-(NSData*) toJson;
-(NSDictionary*) toDict;
-(id) initFromJson:(NSString*)string;
-(id) initFromObj:(id)obj;

@end


@interface WSDeviceToken : WSClass
@property (nonatomic, retain) NSString* deviceToken;

@end


@interface WSUserInfo : WSClass
@property (nonatomic, retain) NSString* userID;

@end


@interface WSSites : WSClass
@property (nonatomic, retain) NSMutableArray* siteArray;

@end


@interface WSSite : WSClass
@property (nonatomic, retain) NSString* siteID;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic) int    sitestatus;
@property (nonatomic, retain) NSString* logical_number; //
@property (nonatomic, retain) NSString* org_code;       //
@property (nonatomic, retain) NSString* address;        //
@property (nonatomic, retain) NSString* phone;          //
@property (nonatomic, retain) NSString* Per_name;       //
@property (nonatomic, retain) NSString* link_phone;     //
@property (nonatomic, retain) NSString* card_no;        //
@property (nonatomic, retain) NSString* create_date;    //
@property (nonatomic, retain) NSString* pos_date;       //
@property (nonatomic, retain) NSArray* imagelist;       //

-(id) valueFromJson:(NSString*)string;
-(id) valueFromObj:(id)obj;

@end

