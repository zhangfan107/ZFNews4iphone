//
//  AppDataCenter.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-25.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "AppDataCenter.h"
#import "RequestModel.h"
#import "Transfer.h"
#import "Transfer+ParseXML.h"

@implementation AppDataCenter
@synthesize version = _version;
@synthesize sid = _sid;
@synthesize clientId = _clientId;

static AppDataCenter *instance = nil;

+(AppDataCenter *) sharedAppDataCenter
{
    @synchronized(self)
    {
       if(nil == instance)
       {
           instance = [[AppDataCenter alloc]init];
       }
    }
    return  instance;
}
-(id)init
{
    if (self = [super init]) {
        _version = @"1";
        _sid = @"-1";
        _clientId = @"3";//1、网站 2、Android 3、ios
    }
    return self;
}
-(RequestModel *)getModelWithRequestId:(NSString *)name
{
    NSArray *array = [Transfer paseRequestParamXML];
    for(RequestModel* model in array){
        if([model.requestId isEqualToString:name]){
            return model;
        }
    }
    return nil;
    
}


@end
