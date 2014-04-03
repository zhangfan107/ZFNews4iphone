//
//  AppDataCenter.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-25.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"

@interface AppDataCenter : NSObject
@property (nonatomic, strong) NSArray *requestParamList;

@property (nonatomic, strong)NSString *version;//版本号
@property (nonatomic, strong)NSString *sid;//sessionid
@property (nonatomic, strong)NSString *clientId;//用户访问的来源

+ (AppDataCenter *) sharedAppDataCenter;

- (RequestModel*) getModelWithRequestId:(NSString*) name;


@end
