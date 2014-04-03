//
//  FileManagerUtil.m
//  LKOA4iPhone
//
//  Created by  STH on 8/1/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "FileManagerUtil.h"


@implementation FileManagerUtil

+ (BOOL) fileExistWithName:(NSString *) fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+(NSMutableArray *) showFileList:(NSString *) name
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:name];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:filePath error:nil];//列出所有的，目录、文件名
    for (NSString* fileName in tempArray) {
        NSLog(@"temparr    %@",fileName);
        if ([fileName isEqualToString:@".DS_Store"]) {
            continue;
        }
        [array addObject:fileName];
    }
    return array;
}

+ (BOOL) deleteFileWithName:(NSString *) fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return NO;
}
//有多少文件（不包括目录）
+ (NSArray*) allFilesAtPath
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString* fileName in tempArray) {
        NSLog(@"temparr    %@",fileName);
        BOOL flag = YES;
        NSString* fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

+ (void) deleteAllFiles
{
    for (NSString *path in [self allFilesAtPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}




@end
