//
//  Transfer.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-22.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "Transfer.h"
#import "RequestModel.h"
#import "AppDataCenter.h"
#import "Reachability.h"
#import "FileManagerUtil.h"
#import "MyProgressView.h"
#import "MProgressAlertView.h"

#define KB      (1024.0)
#define MB      (1024.0 * 1024.0)

@implementation Transfer

static Transfer *instance = nil;
static AFHTTPClient *client = nil;
static NSString *totalSize = nil;

static bool alertShowing = false;

@synthesize isCancelAction;
@synthesize downloadFileName = _downloadFileName;
@synthesize downloadOperation = _downloadOperation;

@synthesize downloadBookName = _downloadBookName;

@synthesize alert = _alert;

+(Transfer *) sharedTransfer{
    @synchronized(self){
        if(nil == instance){
            instance = [[Transfer alloc] init];
        }
    }
    return instance;
}
+(AFHTTPClient *) sharedClient{
    if(nil == client){
        NSURL *url = [[NSURL alloc]initWithString:DEFAULTHOST];
        client = [[AFHTTPClient alloc]initWithBaseURL:url];
    }
    return  client;
}

-(void) doQueueByOrder:(NSArray *) operationList
         completeBlock:(QueueCompleteBlock) completeBlock
{
    isCancelAction = NO;
    
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:1];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByOrder"];
    
    for (int i=0; i< [operationList count] - 1; i++) {
        [[operationList objectAtIndex:i+1] addDependency:[operationList objectAtIndex:i]];
    }
    
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        [SVProgressHUD dismiss];
        
        if (completeBlock) {
            completeBlock(operations);
        }
    }];
}

-(void)doQueueByTogether:(NSArray *)operationList prompt:(NSString *)prompt completeBlock:(QueueCompleteBlock) completeBlock{
    isCancelAction = NO;
    if(prompt){
        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender) {
            NSLog(@"用户取消操作...");
            isCancelAction = YES;
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
            [SVProgressHUD dismiss];
        }];
    }
    [[Transfer sharedClient].operationQueue setMaxConcurrentOperationCount:[operationList count]];
    [[Transfer sharedClient].operationQueue setName:@"doQueueByTogether"];
    [[Transfer sharedClient] enqueueBatchOfHTTPRequestOperations:operationList progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        //[SVProgressHUD dismiss];
        if(completeBlock){
            completeBlock(operations);
        }
    }];
}


/**
 不要直接使用该方法的返回值调用start方法执行联网请求。而是使用上面的队列方式来请求数据。。。
 
 如果使用doQueueByTogether则prompt失效
 
 **/

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *)reqDic
                                           requesId:(NSString *)requesId
                                             prompt:(NSString *) prompt
                                          replaceId:(NSString *)replaceId
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure


{
    return [self TransferWithRequestDic:reqDic
                               requesId:requesId
                                 prompt:prompt
                              replaceId:replaceId
                             alertError:YES
                                success:^(id obj) {
                                    success(obj);
                                } failure:^(NSString *errMsg) {
                                    failure(errMsg);
                                }];
}

- (AFHTTPRequestOperation *) TransferWithRequestDic:(NSDictionary *) reqDic
                                           requesId:(NSString *) requestId
                                             prompt:(NSString *) prompt
                                          replaceId:(NSString *)replaceId
                                         alertError:(BOOL) alertError
                                            success:(SuccessBlock) success
                                            failure:(FailureBlock) failure
{
    if (![self checkNetAvailable]) {
        [SVProgressHUD dismiss];
        return nil;
    }
    
    RequestModel *requestModel = [[AppDataCenter sharedAppDataCenter] getModelWithRequestId:requestId];
    if (prompt && [[Transfer sharedClient].operationQueue.name isEqualToString:@"doQueueByOrder"]) {
        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:prompt maskType:SVProgressHUDMaskTypeClear cancelBlock:^(id sender){
            NSLog(@"用户取消操作...");
            isCancelAction = YES;
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:requestModel.method path:DEFAULTHOST];
            
            [SVProgressHUD dismiss];
        }];
    }
    
    [[Transfer sharedClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"application/json"];
    [Transfer sharedClient].parameterEncoding = AFJSONParameterEncoding;
    
    NSString *path = [NSString stringWithFormat:@"/zjzfWebApp%@", requestModel.url];
    
    NSMutableURLRequest *request = [client requestWithMethod:requestModel.method path:path parameters:reqDic];
    [request setTimeoutInterval:20];
    NSLog(@"request: %@", request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
             [SVProgressHUD dismiss];
            NSLog(@"respose: %@", JSON);
            success(JSON);
            
           
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                    NSError *error, id JSON) {
            [SVProgressHUD dismiss];
            [[Transfer sharedClient].operationQueue cancelAllOperations];
            [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
            
            NSLog(@"--%@", [NSString stringWithFormat:@"%@",error]);
            NSString *message = [Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            if (!isCancelAction && message && alertError) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
            
        }
    ];
    
    return operation;
}
#pragma mark-
#pragma mark--发送请求
/**
 *	@brief	发送请求
 *
 *	@param 	reqDic 	post请求时传递数据 发送get请求时传nil
 *	@param 	requestId 	请求标志
 *	@param 	messId 	需要填充的参数 暂时只有id要填充 不需填充时传nil
 *	@param 	success 	成功回调
 *	@param 	failure 	失败回调 不需要处理失败时传nil
 *
 *	@return
 */
- (AFHTTPRequestOperation *) sendRequestWithRequestDic:(NSDictionary *)reqDic
                                              requesId:(NSString *)requestId
                                                messId:(NSString*)messId
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure

{
    //没有网络连接时给出提示 直接返回
    if (![self checkNetAvailable])
    {
        [SVProgressHUD dismiss];
        return nil;
    }
    RequestModel *requestModel = [[AppDataCenter sharedAppDataCenter] getModelWithRequestId:requestId];
    [[Transfer sharedClient]  registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [[Transfer sharedClient] setDefaultHeader:@"Content-Type" value:@"application/json"];
    [Transfer sharedClient].parameterEncoding = AFJSONParameterEncoding;
    
    NSString *path = [NSString stringWithFormat:@"/zjzfWebApp%@", requestModel.url];
    
    NSMutableURLRequest *request = [client requestWithMethod:requestModel.method path:path parameters:reqDic];
    [request setTimeoutInterval:20];
    NSLog(@"request: %@", request.URL);
    if (reqDic!=nil)
    {
        NSLog(@"requestDict: %@",reqDic);
    }
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request,
            NSHTTPURLResponse *response,
            id JSON)
         {
             [SVProgressHUD dismiss]; //add by wenbin 20131213 21:27
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:JSON
                                                            options:0
                                                              error:nil];
             NSLog(@"请求返回数据:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             success(JSON);
             
         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                     NSError *error, id JSON)
         {
             [SVProgressHUD dismiss];
             
             [[Transfer sharedClient].operationQueue cancelAllOperations];
             [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
             
             NSLog(@"请求失败--err:%@", [NSString stringWithFormat:@"%@",error]);
            // 点击取消的时候会报（The operation couldn’t be completed）,但是UserInfo中不存在NSLocalizedDescription属性，说明这不是一个错误，现用一BOOL值进行简单特殊控制,。。。
             NSString *message = [Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
             if (!isCancelAction && message)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
             if (failure!=nil)
             {
                 failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
             }
         }
         ];
    
    return operation;
    
}
//下载
-(void)downloadFileWithName:(NSString *)name
                       link:(NSString *)link
             viewController:(UIViewController *)vc
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
{
    [self downloadFileWithName:name
                          link:link
               repeateDownload:NO
                viewController:vc
                       success:success
                       failure:failure];
}
//repeatDownload参数控制是否需要重新下载,如果需要重新下载，则不检查是否存在原文件，直接下载
-(void)downloadFileWithName:(NSString *)name
                       link:(NSString *)link
            repeateDownload:(BOOL)repeateDownload
             viewController:(UIViewController *)vc
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
{
    self.downloadFileName = [NSString stringWithFormat:@"%@",name];
    if (!repeateDownload && [FileManagerUtil fileExistWithName:name]) {
        success(nil);
        return;
    }
    if(![self checkNetAvailable]){
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:20];
    self.downloadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    //保存文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@" pahts %@",paths);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    self.downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [self.downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"88888downloadComplete!");
        [SVProgressHUD dismiss];
        success(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure! %@",error);
        [operation cancel];
        totalSize = nil;
        failure([Transfer getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
    }];
    [self.downloadOperation start];
}


//下载书
-(void)downloadBookWithName:(NSString *)name
                  bookArray:(NSMutableArray *)array
             viewController:(UIViewController *)vc
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
{
    [self downloadBookWithName:name
                     bookArray:array
               repeateDownload:NO
                viewController:vc
                       success:success
                       failure:failure];
}
//repeatDownload参数控制是否需要重新下载,如果需要重新下载，则不检查是否存在原文件，直接下载
-(void)downloadBookWithName:(NSString *)name
                  bookArray:(NSMutableArray *)array
            repeateDownload:(BOOL)repeateDownload
             viewController:(UIViewController *)vc
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
{
    self.downloadBookName = [NSString stringWithFormat:@"%@",name];
    if (!repeateDownload && [FileManagerUtil fileExistWithName:name]) {
        success(nil);
        return;
    }
    if(![self checkNetAvailable]){
        return;
    }
   
    //显示进度条
    if (IS_IOS_7) {
        __block MyProgressView *progressView = [[MyProgressView alloc]initWithTitle:@"正在下载"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"取消下载"
                                                                          otherButtonTitles:nil, nil];
        progressView.tag = 100;
        [progressView show];
        
        __block float percent = 0;
        __block int j = 0;
        __block BOOL issuccess = YES;
        
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        [fileMgr createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:name] withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSLog(@"arrycount %d  bookname %@",array.count,name);
        for (int i = 0;i< array.count;i++) {
            NSString *path = [NSString stringWithFormat:@"%@/zjzfWebApp/upload/%@/%@",DEFAULTHOST,name,array[i]];
            NSLog(@"arry %@",array[i]);
            //保存文件
            NSString *fileName = [NSString stringWithFormat:@"/%@/%@",name,array[i]];
            NSString *dicname = [NSString stringWithFormat:@"%@",name];
            if ([array[i] rangeOfString:@"/"].location != NSNotFound) {
                NSArray *dicArray = [array[i] componentsSeparatedByString:@"/"];
                for (int j = 0; j<dicArray.count-1; j++) {
                    dicname = [NSString stringWithFormat:@"%@/%@",dicname,dicArray[j]];
                    NSLog(@"dicname %@",dicname);
                    if (![FileManagerUtil fileExistWithName:dicname]) {
                        [fileMgr createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:dicname] withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                }
            }
            [self downloadFileWithName:fileName link:path viewController:self success:^(id obj) {
                //更新进度条
                percent = ++j ;
                NSLog(@"$$$$$ %.0f %d",percent,j);
                progressView.progressView.progress = percent/[array count];
                progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f / %d",percent,[array count]];
                if (percent == [array count]) {
                    NSLog(@"downloadComplete!");
                    [SVProgressHUD dismiss];
                    [progressView dismiss];
               //      BookMuLuViewController *bookMulu = [[BookMuLuViewController alloc]initWithBookName:name];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载完成！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSString *errMsg) {
                NSLog(@"failllll");
                
                if (!alertShowing) {
                    _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertShowing = YES;
                    [self.alert setTag:101];
                    
                    [progressView dismiss];
                    
                    [self.alert show];
                }
                
                [[Transfer sharedClient].operationQueue cancelAllOperations];
                [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
                [SVProgressHUD dismiss];
                [FileManagerUtil deleteFileWithName:name];
            }];
        }
        
    } else {
        __block MProgressAlertView *progressView = [[MProgressAlertView alloc]initWithTitle:@"正在下载"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"取消下载"
                                                                          otherButtonTitles:nil, nil];
        progressView.tag = 100;
        [progressView show];
        
        __block float percent = 0;
        __block int j = 0;
        __block BOOL issuccess = YES;
        
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        [fileMgr createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:name] withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSLog(@"arrycount %d  bookname %@",array.count,name);
        for (int i = 0;i< array.count;i++) {
            NSString *path = [NSString stringWithFormat:@"%@/zjzfWebApp/upload/%@/%@",DEFAULTHOST,name,array[i]];
            NSLog(@"arry %@",array[i]);
            //保存文件
            NSString *fileName = [NSString stringWithFormat:@"/%@/%@",name,array[i]];
            NSString *dicname = [NSString stringWithFormat:@"%@",name];
            if ([array[i] rangeOfString:@"/"].location != NSNotFound) {
                NSArray *dicArray = [array[i] componentsSeparatedByString:@"/"];
                for (int j = 0; j<dicArray.count-1; j++) {
                    dicname = [NSString stringWithFormat:@"%@/%@",dicname,dicArray[j]];
                    NSLog(@"dicname %@",dicname);
                    if (![FileManagerUtil fileExistWithName:dicname]) {
                        [fileMgr createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:dicname] withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                }
            }
            [self downloadFileWithName:fileName link:path viewController:self success:^(id obj) {
                //更新进度条
                percent = ++j ;
                NSLog(@"$$$$$ %.0f %d",percent,j);
                progressView.progressView.progress = percent/[array count];
                progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f / %d",percent,[array count]];
                if (percent == [array count]) {
                    NSLog(@"downloadComplete!");
                    [SVProgressHUD dismiss];
                    [progressView dismissWithClickedButtonIndex:0 animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载完成！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSString *errMsg) {
                NSLog(@"failllll");
                
                if (!alertShowing) {
                    _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertShowing = YES;
                    [self.alert setTag:101];
                    
                    [progressView dismissWithClickedButtonIndex:0 animated:NO];
                    
                    [self.alert show];
                }
                
                [[Transfer sharedClient].operationQueue cancelAllOperations];
                [[Transfer sharedClient] cancelAllHTTPOperationsWithMethod:@"POST" path:DEFAULTHOST];
                [SVProgressHUD dismiss];
                [FileManagerUtil deleteFileWithName:name];
            }];
        }
    }
   
}

+ (NSString *) formatDownloadData:(long long)length
{
    if (length < (MB/10.0)) {
        return [NSString stringWithFormat:@"%.2f K", length/KB];
    } else {
        return [NSString stringWithFormat:@"%.2f M", length/MB];
    }
}


// 检测网络
- (BOOL) checkNetAvailable
{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"无法链接到互联网，请检查您的网络设置"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}


+ (NSString *) getErrorMsg:(NSString *)enMsg
{
    // 如果enMsg为nil，则[nil rangeOfString:@"111"].location != NSNotFound
    if (enMsg) {
        if ([enMsg rangeOfString:@"The request timed out"].location != NSNotFound) {
            // The request timed outtimed out
            return @"服务器响应超时";
        } else if ([enMsg rangeOfString:@"got 500"].location != NSNotFound) {
            //Expected status code in (200-299), got 500
            return [NSString stringWithFormat:@"服务器异常[%@]", enMsg];
        } else if ([enMsg rangeOfString:@"The Internet connection appears to be offline"].location != NSNotFound) {
            // The Internet connection appears to be offline
            return @"无法连接服务器，请检查网络设置";
        } else if ([enMsg rangeOfString:@"Could not connect to the server"].location != NSNotFound) {
            // Could not connect to the server
            return @"无法连接服务器，请检查网络设置";
        } else if ([enMsg rangeOfString:@"got 404"].location != NSNotFound) {
            // Expected status code in (200-299), got 404
            return @"服务器无法响应功能请求(404)";
        }
    }
    
    //return @"未知错误，请重试";
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        alertShowing = false;
    } else if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self.downloadOperation cancel];
            [SVProgressHUD dismiss];
            
            // 文件下载失败直接删除缓存文件
            [FileManagerUtil deleteFileWithName:self.downloadFileName];
            
            totalSize = nil;
            if (!IS_IOS_7) {
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            }
        }
    }
}

@end
