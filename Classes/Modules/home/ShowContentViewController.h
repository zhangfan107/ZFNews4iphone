//
//  ShowContentViewController.h
//  ZFNews4iphone
//
//  Created by zfhtjs on 14-4-10.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsModel.h"
#import "ZS_Share.h"

@interface ShowContentViewController : BaseViewController<UIWebViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,ZS_ShareDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NewsModel *news;

@property (nonatomic,strong) UIWebView *newsWV;
@property (nonatomic,strong) UIImageView *newsIV;

-(id) initWithNews:(NewsModel *) News;
@end
