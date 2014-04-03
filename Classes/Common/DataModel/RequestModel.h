//
//  RequestModel.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-25.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject
@property (nonatomic,strong) NSString *requestId;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *method;

-(RequestModel *)initWhitId:(NSString *)requestId url:(NSString *)url method:(NSString *)method;

@end
