//
//  Transfer.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-22.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^SuccessBlock) (id obj);
typedef void (^FailureBlock) (NSString *errMsg);
typedef void (^QueueCompleteBlock) (NSArray *operations);

@interface Transfer : NSObject <NSXMLParserDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) bool isCancelAction;
@property (nonatomic,strong) NSString *downloadFileName;
@property (nonatomic, strong) AFHTTPRequestOperation *downloadOperation;

@property (nonatomic,strong) NSString *downloadBookName;

@property (nonatomic, strong) UIAlertView *alert;


+(Transfer *) sharedTransfer;

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                             prompt:(NSString *) prompt
                                         alertError:(BOOL) alertError
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure;

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                           requesId:(NSString *)requesId
                                             prompt:(NSString *) prompt
                                          replaceId:(NSString *)replaceId
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure;

//发送请求
- (AFHTTPRequestOperation *) sendRequestWithRequestDic:(NSDictionary *)reqDic
                                              requesId:(NSString *)requestId
                                                messId:(NSString*)messId
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;


- (void) doQueueByOrder:(NSArray *) operationList
          completeBlock:(QueueCompleteBlock) completeBlock;

- (void) doQueueByTogether:(NSArray *) operationList
                    prompt:(NSString *) prompt
             completeBlock:(QueueCompleteBlock) completeBlock;
//下载（单个下载）
-(void) downloadFileWithName:(NSString *) name
                        link:(NSString *)link
              viewController:(UIViewController *) vc
                     success:(SuccessBlock) success
                     failure:(FailureBlock) failure;

-(void)downloadFileWithName:(NSString *)name
                        link:(NSString *) link
                        repeateDownload:(BOOL) repeateDownload
                        viewController:(UIViewController *) vc
                        success:(SuccessBlock) success
                        failure:(FailureBlock) failure;


//下载（（下载书，连续下载））
-(void) downloadBookWithName:(NSString *) name
                   bookArray:(NSMutableArray *)array
              viewController:(UIViewController *) vc
                     success:(SuccessBlock) success
                     failure:(FailureBlock) failure;

-(void)downloadBookWithName:(NSString *)name
                  bookArray:(NSMutableArray *)array
            repeateDownload:(BOOL) repeateDownload
             viewController:(UIViewController *) vc
                    success:(SuccessBlock) success
                    failure:(FailureBlock) failure;
@end
