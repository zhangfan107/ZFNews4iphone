//
//  HomeViewController.m
//  ZFNews4iphone
//
//  Created by zfht on 14-3-14.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize slideSwitchView = _slideSwitchView;
@synthesize vc1 = _vc1;
@synthesize vc2 = _vc2;
@synthesize vc3 = _vc3;

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
    self.isHomeMain = YES;
    self.hasSureButton = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    //search
    UIImage *buttonNormalImage = [UIImage imageNamed:@"search.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
    [aButton setFrame:CGRectMake(0.0, 0.0, buttonNormalImage.size.width, buttonNormalImage.size.height)];
    [aButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = searchButton;
    
    //个人中心
    UIImage *ubuttonNormalImage = [UIImage imageNamed:@"user.png"];
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundImage:ubuttonNormalImage forState:UIControlStateNormal];
    [bButton setFrame:CGRectMake(0.0, 0.0, ubuttonNormalImage.size.width, ubuttonNormalImage.size.height)];
    [bButton addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc]initWithCustomView:bButton];
    self.navigationItem.rightBarButtonItem = userButton;
    
    //图标
    UIImage *cbuttonNormalImage = [UIImage imageNamed:@"logo.png"];
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cButton setImage:cbuttonNormalImage forState:UIControlStateNormal];
    [cButton setFrame:CGRectMake(0.0, 0.0,cbuttonNormalImage.size.width, cbuttonNormalImage.size.height)];
    self.navigationItem.titleView = cButton;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.vc1 = [[HomeListViewController alloc]init];
    self.vc1.title = @"头条";
    
    self.vc2 = [[HomeListViewController alloc]init];
    self.vc2.title = @"精选";
    
    self.vc3 = [[HomeListViewController alloc]init];
    self.vc3.title = @"本地";
    
    UIImage *rightImage = [UIImage imageNamed:@"lm_add.png"];
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:rightImage forState:UIControlStateNormal];
    [rightSideButton setImage:rightImage  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(300, 0,10.0f,14.0f );
    rightSideButton.userInteractionEnabled = NO;
    self.slideSwitchView.rigthSideButton = rightSideButton;

    [self.slideSwitchView buildUI];
    [self.view addSubview:rightSideButton];
    
}
-(IBAction)searchAction:(id)sender{
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

-(IBAction)userAction:(id)sender{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}


#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 6;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    }else {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    HomeListViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    } else if (number == 1) {
        vc = self.vc2;
    } else if (number == 2) {
        vc = self.vc3;
    }
    [vc viewDidCurrentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
