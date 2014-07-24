//
//  NSString+JSON.m
//  LotteryAssit
//
//  Created by ios on 14-7-14.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil){
        return nil;
    }
    return result;
}

@end
