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
#define Server_BaseGetURL @"http://122.224.80.134/oa_ipad!"
#define Server_BaseURL @"http://122.224.80.134/oa_ipad!"
#define Server_BroswerSitesURL @"oa_ipad!jumbweb"
#else
//#define Server_BaseGetURL @"http://10.80.9.195:8080/welfare_lottery/oa/shenji/ipad/"
//#define Server_BaseURL @"http://10.80.9.195:8080/welfare_lottery/"
#define Server_BaseGetURL @"http://115.238.117.195:80/welfare_lottery/oa/shenji/ipad/"
#define Server_BaseURL @"http://115.238.117.195:80/welfare_lottery/"
#define Server_BroswerSitesURL @"oa/shenji/ipad/mapframe.html"
#endif



#define Server_URL_Login [NSString stringWithFormat:@"%@login.html",Server_BaseGetURL]
#define Server_URL_AfterLogin [NSString stringWithFormat:@"%@index.html",Server_BaseGetURL]

//oa_ipad!
//gettoken.action  getloginuser.action  getsites.action  getsite.action writeimage.action

//oa/shenji/ipad/lunbo.html?id= 4028810e42784a570142786cefd30135

#define Common_Font [UIFont systemFontOfSize:16.0]

@interface GSProjectHeader : NSObject

@end
