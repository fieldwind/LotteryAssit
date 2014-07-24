//
//  GSCommondef.h
//  GSCommonProject
//
//  Created by ios on 14-7-11.
//  Copyright (c) 2014年 gs. All rights reserved.
//

#ifndef GSCommonProject_GSCommondef_h
#define GSCommonProject_GSCommondef_h


#define isiOS7 ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0 ? YES : NO)
#define isiOS6 ([[UIDevice currentDevice] systemVersion].floatValue >= 6.0 ? YES : NO)

#define GSRunInMainThread(code) \
do{ \
if ([NSThread isMainThread]) { \
code; \
} \
else { \
dispatch_async(dispatch_get_main_queue(), ^{ \
code; \
}); \
} \
}\
while(NO);



#define GSAssert(expression, ...) \
do { \
if (!(expression)) { \
NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); \
} \
} while(NO)



#ifdef DEBUG
#define GSFunctionPerformancePeriodTest(func, expectedLife, msg) \
{ \
NSDate *start = [NSDate date]; \
{ \
func; \
} \
NSDate *end = [NSDate date]; \
NSTimeInterval cost = [end timeIntervalSinceDate:start]; \
if (cost > expectedLife) { \
[PCLogControl outputLog:@"%@ Cost: %f", msg, cost]; \
NSAssert(0, @"GSFunctionPerformancePeriodTest failed!!!"); \
} \
}
#else
#define GSFunctionPerformancePeriodTest(func, expectedLife, msg) \
{ \
func; \
}
#endif


#define HexColor2UIColor(r,g,b,apa) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:apa]


#endif


