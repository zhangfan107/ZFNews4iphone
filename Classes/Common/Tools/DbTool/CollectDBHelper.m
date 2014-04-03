//
//  CollectViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-10.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "CollectDBHelper.h"
#import "FMDatabase.h"
#import "ContentModel.h"

@interface CollectDBHelper ()

@end

@implementation CollectDBHelper

+ (BOOL) createTable:(FMDatabase *) db
{
    BOOL flag = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, fileName TEXT)", kCollectTableName]];
    return flag;
}
- (NSArray*) queryAll
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    @try {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT url, fileName FROM %@", kCollectTableName]];
        while ([resultSet next]) {
            ContentModel *book = [[ContentModel alloc] init];
            [book setUrl:[resultSet stringForColumnIndex:0]];
            [book setFileName:[resultSet stringForColumnIndex:1]];
            [array addObject:book];
        }
        return array;
    }
    @finally {
        [db close];
    }
}

- (BOOL) insertCollect:(ContentModel *) model
{
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    @try {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (url, fileName) VALUES (?,?)",kCollectTableName];
        
        BOOL flag = [db executeUpdate:sql, [model url], [model fileName]];
        
        return flag;
    }
    @finally {
        [db close];
    }
}

- (BOOL) deleteCollect:(ContentModel *) model
{
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE url = ?", kCollectTableName];
    BOOL result = true;
    @try {
            BOOL flag = [db executeUpdate:sql, [model url]];
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
- (BOOL) findCollect:(ContentModel *) model
{
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    int count = 0;
    @try {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT url, fileName FROM %@ WHERE url = ?", kCollectTableName],[model url]];
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
