//
//  GSProjectHeader.h
//  GSCommonProject
//
//  Created by ios on 14-7-11.
//  Copyright (c) 2014年 gs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSCommondef.h"

#import "UIViewController+uiInit.h"


//preject related
#if 0
#define Server_URL_Login @"http://122.224.80.134/login.htm"
#define Server_URL_AfterLogin @"http://122.224.80.134/index.html"
#define Server_BroswerSitesURL @"oa_ipad!jumbweb"
#define Server_BaseURL @"http://122.224.80.134/oa_ipad!"
#else
#define Server_URL_Login @"http://10.80.9.195:8080/welfare_lottery/login.htm"
#define Server_URL_AfterLogin @"http://10.80.9.195:8080/welfare_lottery/index.html"
#define Server_BroswerSitesURL @"oa_ipad!s_user!login.action"
#define Server_BaseURL @"http://10.80.9.195:8080/welfare_lottery/"
#endif
//oa_ipad!
//gettoken.action  getloginuser.action  getsites.action  getsite.action writeimage.action

//oa/shenji/ipad/lunbo.html?id= 4028810e42784a570142786cefd30135

#define Common_Font [UIFont systemFontOfSize:16.0]

@interface GSProjectHeader : NSObject

@end
