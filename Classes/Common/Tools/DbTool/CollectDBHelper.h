//
//  CollectViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-12-10.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseDBHelper.h"

@class NewsModel;

@interface  CollectDBHelper:BaseDBHelper

+ (BOOL) createTable:(FMDatabase *) db;

// 查询出所有的数据
- (NSArray*) queryAll;

// 插入一条数据
- (BOOL) insertCollect:(NewsModel *) model;
// 删除一条数据
- (BOOL) deleteCollect:(NewsModel *) model;

- (BOOL) findCollect:(NewsModel *) model;

@end
