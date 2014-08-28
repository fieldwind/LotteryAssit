//
//  UserDataManager.m
//  LotteryAssit
//
//  Created by ios on 14-7-17.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "UserDataManager.h"
#import "AFNetworking.h"
#import "GSProjectHeader.h"
#import "WSClass.h"
#import "NSString+JSON.h"

@implementation UserDataManager


+ (id)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}



-(id)init
{
    if(self = [super init]){
        
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber* obj = [standardDefaults objectForKey:@"isSentDeviceToken"];
        if(obj && [obj boolValue]){
            //self.isSentDeviceToken = YES;
        }
    }
    
    return self;
}

-(void)setSentFlage
{
    self.isSentDeviceToken = YES;

    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isSentDeviceToken"];
    [standardDefaults synchronize];
}

-(void)sendDevcieToken
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString* obj = [standardDefaults objectForKey:@"devicetoken"];
    if(!obj)
        return;
    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@oa_ipad!gettoken.action",Server_BaseURL];
    WSDeviceToken* deviceToken = [[WSDeviceToken alloc]init];
    deviceToken.deviceToken = obj;
    [manager POST:url parameters:[deviceToken toDict] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //set flag
        [self setSentFlage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)accessCurrUser
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@oa_ipad!getloginuser.action",Server_BaseURL];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WSUserInfo* userInfo = [[WSUserInfo alloc]initFromObj:responseObject];
        self.currUser = userInfo.userID;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}


-(void)accessSites:(void (^)(NSArray * , NSError* ))response userID:(NSString *)userID orgCode:(NSString*)orgCode
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@oa_ipad!getsites.action",Server_BaseURL];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"useid", orgCode,@"org_code", nil];
    
   
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WSSites* sites = [[WSSites alloc]initFromObj:responseObject];
        response(sites.siteArray,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        response(nil,error);
    }];
}

-(void)accessSite:(void (^)(id, NSError *))response siteInfo:(WSSite *)siteInfo
{
    if(!siteInfo || !siteInfo.siteID)
        return;
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@oa_ipad!getsite.action",Server_BaseURL];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          siteInfo.siteID,@"stationid",
                          nil];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [siteInfo valueFromObj:responseObject];
        response(siteInfo,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        response(siteInfo,error);
    }];
}

-(void)accessImage:(void (^)(NSData *, NSError *))response imageid:(NSString *)imageid
{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//        }
//    }];
//    [dataTask resume];


    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@getsite.action",Server_BaseURL];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          imageid,@"id",
                          nil];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *contents = [operation.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
        response(contents,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        response(nil,error);
    }];
}


-(void)accessCitys:(void (^)(WSCitys *, NSError *))response orgCode:(NSString *)orgCode
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@oa_ipad!getsheng.action",Server_BaseURL];
    NSDictionary* dict = nil;
    if(orgCode){
        //http://10.80.9.195:8080/welfare_lottery/oa_ipad!getqv.action
        url = [NSString stringWithFormat:@"%@oa_ipad!getqv.action",Server_BaseURL];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
         orgCode,@"org_code",
         nil];
    }
    
    

    
//    //dbg code
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"txt"];
//    NSString* respStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
//
//    id responseObject = [respStr JSONValue];
//    WSCitys* citys = [[WSCitys alloc]initFromObj:responseObject];
//    response(citys,nil);
//    return;
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WSCitys* citys = [[WSCitys alloc]initFromObj:responseObject];
        response(citys,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        response(nil,error);
    }];
}


@end
