//
//  NewsModel.h
//  ZFNews4iphone
//
//  Created by zfhtjs on 14-4-9.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic,strong) NSString *newsid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *column;
@property (nonatomic,strong) NSString *publishtime;
@property (nonatomic,strong) NSString *publisher;
@property (nonatomic,strong) NSString *flag;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *imagename;
@end
