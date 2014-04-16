//
//  CollectViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-10.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "CollectDBHelper.h"
#import "FMDatabase.h"
//#import "ContentModel.h"
#import "NewsModel.h"

@interface CollectDBHelper ()

@end

@implementation CollectDBHelper

+ (BOOL) createTable:(FMDatabase *) db
{
    BOOL flag = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, newsid TEXT, newstitle TEXT,newstime TEXT)", kCollectTableName]];
    return flag;
}
- (NSArray*) queryAll
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    @try {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT newsid, newstitle,newstime FROM %@", kCollectTableName]];
        while ([resultSet next]) {
            NewsModel *news = [[NewsModel alloc] init];
            [news setNewsid:[resultSet stringForColumnIndex:0]];
            [news setTitle:[resultSet stringForColumnIndex:1]];
            [news setPublishtime:[resultSet stringForColumnIndex:2]];
            [array addObject:news];
        }
        return array;
    }
    @finally {
        [db close];
    }
}

- (BOOL) insertCollect:(NewsModel *) model
{
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    @try {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (newsid, newstitle,newstime) VALUES (?,?,?)",kCollectTableName];
        
        BOOL flag = [db executeUpdate:sql, [model newsid], [model title],[model publishtime]];
        
        return flag;
    }
    @finally {
        [db close];
    }
}

- (BOOL) deleteCollect:(NewsModel *) model
{
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE newsid = ?", kCollectTableName];
    BOOL result = true;
    @try {
            BOOL flag = [db executeUpdate:sql, [model newsid]];
            result = result && flag;
            return result;
    }
    @catch (NSException *exception) {
        return false;
    }
    @finally {
        [db close];
    }

}
- (BOOL) findCollect:(NewsModel *) model
{
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    int count = 0;
    @try {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT newsid, newstitle,newstime FROM %@ WHERE newsid = ?", kCollectTableName],[model newsid]];
        while ([resultSet next]) {
            count = count + 1;
        }
        if (count>0) {
            return true;
        }else{
            return false;
        }
    }
    @finally {
        [db close];
    }
}
@end
