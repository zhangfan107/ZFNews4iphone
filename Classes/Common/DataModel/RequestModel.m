//
//  RequestModel.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-25.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel
@synthesize requestId = _requestId;
@synthesize url = _url;
@synthesize method = _method;

-(RequestModel *)initWhitId:(NSString *)requestId url:(NSString *)url method:(NSString *)method{
    _requestId = requestId;
    _url = url;
    _method = method;
    return self;
}
@end
