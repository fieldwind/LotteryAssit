//
//  WSClass.m
//  LotteryAssit
//
//  Created by ios on 14-7-14.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "WSClass.h"
#import "NSString+JSON.h"
#import "NSObject+JSON.h"

@implementation WSClass

-(NSData*) toJson
{
    return nil;
}

-(NSDictionary*)toDict
{
    return nil;
}

-(id)initFromJson:(NSString*)string
{
    return nil;
}

-(id)initFromObj:(id)obj
{
    return nil;
}

@end


@implementation WSDeviceToken

-(id) initFromJson:(NSString*)string
{
    self = [super init];
    if(self)
    {
        NSDictionary* dict = [string JSONValue];
        self.deviceToken = [dict objectForKey:@"deviceToken"];
    }
    
    return self;
}

-(NSData*) toJson
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.deviceToken,@"deviceToken",
                          nil];
    
    NSData* res = [dict JSONData];
    
    return res;
}

-(NSDictionary*) toDict
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.deviceToken,@"deviceToken",
                          nil];
    
    return dict;
}

- (void)dealloc
{
    self.deviceToken = nil;
}

@end







@implementation WSUserInfo

-(id) initFromJson:(NSString*)string
{
    self = [super init];
    if(self)
    {
        NSDictionary* dict = [string JSONValue];
        self.userID = [dict objectForKey:@"useid"];
    }
    
    return self;
}

-(id) initFromObj:(id)obj
{
    self = [super init];
    if(self)
    {
        NSDictionary* dict = (NSDictionary*)obj;
        self.userID = [dict objectForKey:@"useid"];
    }
    
    return self;
}

@end







@implementation WSSites

-(id) initFromJson:(NSString*)string
{
    self = [super init];
    if(self)
    {
        NSArray* array = [string JSONValue];
        self.siteArray = [NSMutableArray array];
        for(NSDictionary* dic in array){
            WSSite* site = [[WSSite alloc]init];
            if ([dic valueForKey:@"id"] && ![[dic valueForKey:@"id"] isEqualToString:@"null"]) {
                site.siteID = [dic valueForKey:@"id"];
            }
            site.lat = [[dic valueForKey:@"lat"]doubleValue];
            site.lng = [[dic valueForKey:@"lng"]doubleValue];
            site.sitestatus = [[dic valueForKey:@"sitestatus"]intValue];
            
            [self.siteArray addObject:site];
        }
    }
    
    return self;
}


-(id) initFromObj:(id)obj
{
    self = [super init];
    if(self)
    {
        self.siteArray = [NSMutableArray array];

        NSDictionary* dict = (NSDictionary*)obj;
        NSArray* array = [dict objectForKey:@"list"];
        for(NSDictionary* dic in array){
            WSSite* site = [[WSSite alloc]init];
            if ([dic valueForKey:@"id"] && ![[dic valueForKey:@"id"] isEqualToString:@"null"]) {
                site.siteID = [dic valueForKey:@"id"];
            }
            site.lat = [[dic valueForKey:@"lat"]doubleValue];
            site.lng = [[dic valueForKey:@"lng"]doubleValue];
            site.sitestatus = [[dic valueForKey:@"sitestatus"]intValue];
            
            [self.siteArray addObject:site];

        }
    }
    
    return self;
}

@end


@implementation WSSite

-(id) valueFromJson:(NSString *)string
{
    NSDictionary* dict = [string JSONValue];
    
    self.logical_number = [dict valueForKey:@"logical_number"];
    self.org_code = [dict valueForKey:@"org_code"];
    self.address = [dict valueForKey:@"address"];
    self.phone = [dict valueForKey:@"phone"];
    self.Per_name = [dict valueForKey:@"Per_name"];
    self.link_phone = [dict valueForKey:@"link_phone"];
    self.card_no = [dict valueForKey:@"card_no"];
    self.create_date = [dict valueForKey:@"create_date"];
    self.pos_date = [dict valueForKey:@"pos_date"];
    self.imagelist = [dict valueForKey:@"imagelist"];

    
    return self;
}

-(id) valueFromObj:(id)obj
{
    NSDictionary* dict = [(NSDictionary*)obj valueForKey:@"detail"];
    
    self.logical_number = [dict valueForKey:@"logical_number"];
    self.org_code = [dict valueForKey:@"org_code"];
    self.address = [dict valueForKey:@"address"];
    self.phone = [dict valueForKey:@"phone"];
    self.Per_name = [dict valueForKey:@"Per_name"];
    self.link_phone = [dict valueForKey:@"link_phone"];
    self.card_no = [dict valueForKey:@"card_no"];
    self.create_date = [dict valueForKey:@"create_date"];
    self.pos_date = [dict valueForKey:@"pos_date"];
    self.imagelist = [dict valueForKey:@"imagelist"];
    
    
    return self;
}

@end





