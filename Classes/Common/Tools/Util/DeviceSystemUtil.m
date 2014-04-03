//
//  DeviceSystemUtil.m
//  LKOA4iPhone
//
//  Created by  STH on 11/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "DeviceSystemUtil.h"

@implementation DeviceSystemUtil

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@end
