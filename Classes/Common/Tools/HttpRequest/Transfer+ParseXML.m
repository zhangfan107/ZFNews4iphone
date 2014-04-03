//
//  Transfer+ParseXML.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-25.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "Transfer+ParseXML.h"
#import "TBXML.h"
#import "RequestModel.h"

@implementation Transfer (ParseXML)

+(NSArray *)paseRequestParamXML{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc]initWithXMLFile:@"http_request_param" fileExtension:@"xml" error:&error];
    if(error){
        NSLog(@"%@->ParseXML:%@",[self class],[error localizedDescription]);
        return nil;
    }
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if(rootElement){
        NSMutableArray *array = [[NSMutableArray alloc]init];
        TBXMLElement *listElement = [TBXML childElementNamed:@"request" parentElement:rootElement];
        while (listElement) {
            RequestModel *model = [[RequestModel alloc]init];
            [model setRequestId:[TBXML textForElement:[TBXML childElementNamed:@"requestId" parentElement:listElement]]];
            [model setUrl:[TBXML textForElement:[TBXML childElementNamed:@"url" parentElement:listElement]]];
            [model setMethod:[TBXML textForElement:[TBXML childElementNamed:@"method" parentElement:listElement]]];
            [array addObject:model];
            listElement = [TBXML nextSiblingNamed:@"request" searchFromElement:listElement];
        }
        return array;
    }
    return  nil;
}

@end
