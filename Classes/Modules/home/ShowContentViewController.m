//
//  ShowContentViewController.m
//  ZFNews4iphone
//
//  Created by zfhtjs on 14-4-10.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "ShowContentViewController.h"
#import "CollectDBHelper.h"
#import "NewsModel.h"

@interface ShowContentViewController ()

@end


@implementation ShowContentViewController

@synthesize news = _news;

@synthesize newsWV = _newsWV;
@synthesize newsIV = _newsIV;

-(id) initWithNews:(NewsModel *)News
{
    if (self = [super init]) {
        _news = News;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float height = 480.0f;
    float height_2 = 0.0f;
    if(iPhone5){
        height = 568.0f;
        height_2 = 20.0f;
    }
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
        NSString *column = _news.column;
        titleLabel.text = [NSString stringWithFormat:@"%@",column];
        self.navigationItem.titleView = titleLabel;
    }
    _newsIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,height)];
    [_newsIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-bottom.png"]]];
    [_newsIV setUserInteractionEnabled:YES];
    [self.view addSubview:_newsIV];
    
    _newsWV = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, 310, ScreenHeight-70)];
    [self.newsWV setUserInteractionEnabled:YES];
    //NSLog(@"ScreenHeight %f", ScreenHeight);
    // YES, 初始太小，但是可以放大；NO，初始可以，但是不再支持手势。 FUCK！！！
    _newsWV.scalesPageToFit = YES; // 设置网页和屏幕一样大小，使支持缩放操作
    
    NSString *content = _news.content;
    NSString *scontent = [NSString stringWithFormat:@"%@",content];
    [_newsWV loadHTMLString:scontent baseURL:nil];
    [_newsWV setDelegate:self];
    [_newsIV addSubview:_newsWV];
    
    UIImage *sLine = [UIImage imageNamed:@"line.png"];
    UIImageView *sLineIV = [[UIImageView alloc]initWithImage:sLine];
    [sLineIV setFrame:CGRectMake(5, ScreenHeight-55, 310,2)];
    [sLineIV setUserInteractionEnabled:YES];
    [_newsIV addSubview:sLineIV];
    
    UIImage *back = [UIImage imageNamed:@"bt-back1.png"];
    UIImageView *backIV = [[UIImageView alloc]initWithImage:back];
    [backIV setFrame:CGRectMake(10, ScreenHeight-36, 10,18)];
    [backIV setUserInteractionEnabled:YES];
    [_newsIV addSubview:backIV];
    
    UIImage *plct = [UIImage imageNamed:@"pl-count.png"];
    UIImageView *plctIV = [[UIImageView alloc]initWithImage:plct];
    [plctIV setFrame:CGRectMake(33, ScreenHeight-40, 10, 10)];
    //[plctBT setBackgroundImage:[UIImage imageNamed:@"pl-count.png"] forState:UIControlStateNormal];
    //[plBT addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_newsIV addSubview:plctIV];
    
    UIButton *plNM = [UIButton buttonWithType:UIButtonTypeCustom];
    [plNM setFrame:CGRectMake(17, ScreenHeight-38, 25, 30)];
    //plNM.backgroundColor = [UIColor clearColor];
    NSString *discount = _news.discount;
    [plNM setTitle:[NSString stringWithFormat:@"%@",discount] forState:UIControlStateNormal];
    plNM.titleLabel.font = [UIFont systemFontOfSize: 20.0];
    [plNM setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    //[plNM setBackgroundColor: [UIColor blueColor]];
    //[plNM setBackgroundImage:[UIImage imageNamed:@"pl-count.png"] forState:UIControlStateNormal];
    //[plNM addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_newsIV addSubview:plNM];
    
    UIButton *plBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [plBT setFrame:CGRectMake(47, ScreenHeight-42, 80, 30)];
    [plBT setBackgroundImage:[UIImage imageNamed:@"bt-pl.png"] forState:UIControlStateNormal];
    //[plBT addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_newsIV addSubview:plBT];
    
    UIButton *scBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [scBT setFrame:CGRectMake(134, ScreenHeight-42, 80, 30)];
    [scBT setBackgroundImage:[UIImage imageNamed:@"bt-sc.png"] forState:UIControlStateNormal];
    [scBT addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_newsIV addSubview:scBT];
    
    UIButton *fxBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [fxBT setFrame:CGRectMake(221, ScreenHeight-42, 80, 30)];
    [fxBT setBackgroundImage:[UIImage imageNamed:@"bt-fx.png"] forState:UIControlStateNormal];
    [fxBT addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_newsIV addSubview:fxBT];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareAction:(id)sender//分享
{
    // Do any additional setup after loading the view, typically from a nib.
    ZS_Share  *share = [[ZS_Share alloc] init];
    
    ZS_ShareResult * result = [share shareContent:nil
                                      withShareBy:NSClassFromString(@"ZS_ShareByMessage")
                                withShareDelegate:self];
    
    if (!result.shState) {
        NSLog(@"------失败-------");
    }else{
        NSLog(@"------成功------");
    }
    
}

-(void)collectAction:(id)sender//收藏
{
    NSLog(@"news.title %@",_news.title);
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    [CollectDBHelper createTable:db];
    CollectDBHelper *cdb = [[CollectDBHelper alloc]init];
    
    if ([cdb findCollect:_news]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消收藏" message:@"您确定要取消收藏吗？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消" ,nil];
        [cdb deleteCollect:_news];
        [alert show];
    }else{
        [cdb insertCollect:_news];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil ,nil];
        [alert show];
    }
}

@end
