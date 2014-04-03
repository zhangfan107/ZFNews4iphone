//
//  Constant.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-17.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFNews4iphoneAppDelegate.h"
#import "DeviceSystemUtil.h"
//宏定义，方便调用
#define ApplicationDelegate ((ZFNews4iphoneAppDelegate *)[UIApplication sharedApplication].delegate)

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define LKCOLOR  ([UIColor colorWithRed:46/225.0f green:137/225.0f blue:224/225.0f alpha:1.0f])

#define kVERSION                        @"1" // 当前程序的版本号，以此值与服务器进行比对，确定版本更新

#define kREMEBERPWD                     @"remeberPWD"
#define kAUTOLOGIN                      @"autoLogin"
#define KUSERNAME                       @"userName"
#define kPASSWORD                       @"password" // 保存用户输入的密码

#define kCOUNT_HOME                     @"count_HOME"
#define kCOUNT_SECH                     @"count_SECH"
#define kCOUNT_GRZX                     @"count_GRZX"
#define kCOUNT_BCAR                     @"count_BCAR"
#define kCOUNT_MORE                     @"count_MORE"
#define kURL                            @"http://220.231.55.105" //下载地址


// 注意此值并不是真正的联网地址，真正的地址在登录成功后返回，存于 kREALHOST 中
#define DEFAULTHOST                     @"http://220.231.55.105"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define STRETCH                                5

#define IS_IOS_7 (DeviceSystemMajorVersion() >= 7)

#define kCollectTableName  @"CollectTable"  //收藏表名
#define kDataBaseName      @"zjzfDB"        //数据库文件夹

@interface Constant : NSObject

@end
