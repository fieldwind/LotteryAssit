//
//  AppDelegate.m
//  LotteryAssit
//
//  Created by ios on 14-7-14.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "AppDelegate.h"
#import "GSProjectHeader.h"
#import "GSWebViewController.h"
#import "GIMapViewController.h"


@interface AppDelegate(){
    UINavigationController* _navContol;
}

@end

@implementation AppDelegate

-(void)loadVCFromStoyBoard
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
#if 1
    GSWebViewController* vc =  [sb instantiateViewControllerWithIdentifier:@"GSWebViewController"];
    vc.urlString = Server_URL_Login;
    
    _navContol = [[UINavigationController alloc] initWithRootViewController:vc];
    _navContol.navigationBarHidden = NO;
//    if (!isiOS7) {
//        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//        [_navContol.navigationBar setBackgroundImage:[UIImage imageNamed:@"EVP_navBarBackground2"] forBarMetrics:UIBarMetricsDefault];
//        if (isiOS6) {
//            [_navContol.navigationBar setShadowImage:[UIImage imageNamed:@"EVP_transparency"]];
//        }
//        [_navContol.navigationBar setTranslucent:NO];
//    }

    
   
#else
    GIMapViewController* vc =  [sb instantiateViewControllerWithIdentifier:@"GIMapViewController"];
#endif
    
    self.window.rootViewController = vc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    
//    [self loadVCFromStoyBoard];
//    
//    
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    GSWebViewController* vc =  [sb instantiateViewControllerWithIdentifier:@"GSWebViewController"];
    vc.urlString = Server_URL_Login;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"***************** didReceiveRemoteNotification");
    NSLog(@"\napns -> [EnvPostTipListData readJSonString:result],Receive Data:\n%@", userInfo);
    //把icon上的标记数字设置为0,
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //    AudioServicesPlaySystemSound(4095);
    //
    //    [self getNotification:[[userInfo valueForKey:@"hidedata"]intValue]];
    
    
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//    NSString* token1 = [NSString stringWithFormat:@"%@",deviceToken];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSString * token = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSLog(@"***************** apns -> 生成的devToken:%@", token);

    self.devicetoken = token;
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:self.devicetoken forKey:@"devicetoken"];
    [standardDefaults synchronize];
    //[_headerDic setValue:self.devicetoken forKey:@"devicetoken"];
    
    
    //send token to server.
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView* al = [[UIAlertView alloc] initWithTitle:nil
                                                 message:@"请去设置->通知中心->福彩信息系统设置为接收通知"
                                                delegate:self
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil, nil];
    
    [al show];
    self.devicetoken = nil;
}




@end
