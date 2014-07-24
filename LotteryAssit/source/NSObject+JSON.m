//
//  NSObject+JSON.m
//  LotteryAssit
//
//  Created by ios on 14-7-14.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

-(NSData*)JSONData
{
    NSError* error = nil;
    id result = nil;
    result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if(error){
        return nil;
    }
    
    return result;
}

-(NSString*)JSONString
{
    NSString* string = nil;
    
    NSData* data = [self JSONData];
    if(data){
        string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
    
    return string;
}

@end
