//
//  LoginViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-18.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"


#define TF_X1   10
#define TF_X2   10
#define TF_X3   80

#define kDuration 0.9   // 动画持续时间(秒)



@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userTF = _userTF;
@synthesize pwdTF = _pwdTF;
@synthesize rememberPwdButton = _rememberPwdButton;
@synthesize rememberLabel = _rememberLabel;
@synthesize autoLoginButton = _autoLoginButton;
@synthesize loginIV = _loginIV;

static bool checkUpate = false;

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
    //注册
    UIImage *buttonNormalImage = [UIImage imageNamed:@"resiger.png"];
    UIImage *buttonSelectedImage = [UIImage imageNamed:@"resiger.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitle:@"注册" forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [aButton setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
    [aButton setBackgroundImage:buttonSelectedImage forState:UIControlStateSelected];
    [aButton setFrame:CGRectMake(0.0, 0.0, 50,30)];
    [aButton addTarget:self action:@selector(regsigerAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *zcButton = [[UIBarButtonItem alloc]initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = zcButton;
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"帐号登录";
        self.navigationItem.titleView = titleLabel;
    }
    
    _loginIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [_loginIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [_loginIV setUserInteractionEnabled:YES];
    [self.view addSubview:_loginIV];
    
    UIImage *ubuttonNormalImage = [UIImage imageNamed:@"userPwd.png"];
    UIImageView *userPwIV = [[UIImageView alloc]initWithImage:ubuttonNormalImage];
    [userPwIV setFrame:CGRectMake(TF_X1, 130, 300,90)];
    [userPwIV setUserInteractionEnabled:YES];
    [_loginIV addSubview:userPwIV];
    
    UILabel *zhLab = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+TF_X2, 130+height_2, 50, 45)];
    [zhLab setBackgroundColor:[UIColor clearColor]];
    [zhLab setFont:[UIFont boldSystemFontOfSize:17]];
    [zhLab setTextColor:[UIColor blackColor]];
    [zhLab setText:@"帐  号"];
    [_loginIV addSubview:zhLab];
    _userTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+TF_X3, 130+height_2, 227, 45)];
    _userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTF.delegate = self;
    [_userTF setPlaceholder:@"用户帐号"];
    [_userTF setText:[[NSUserDefaults standardUserDefaults]stringForKey:KUSERNAME]];
    [_userTF setFont:[UIFont boldSystemFontOfSize:17]];
    _userTF.returnKeyType = UIReturnKeyDone;
    [_loginIV addSubview:_userTF];
    
    
    UILabel *pwLab = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+TF_X2, 130+height_2+45, 50, 45)];
    [pwLab setBackgroundColor:[UIColor clearColor]];
    [pwLab setFont:[UIFont boldSystemFontOfSize:17]];
    [pwLab setTextColor:[UIColor blackColor]];
    [pwLab setText:@"密  码"];
    [_loginIV addSubview:pwLab];
    _pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+TF_X3, 130+height_2+45, 227, 45)];
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTF.delegate = self;
    [_pwdTF setPlaceholder:@"输入密码"];
    [_pwdTF setText:[[NSUserDefaults standardUserDefaults]stringForKey:kPASSWORD]];
    [_pwdTF setFont:[UIFont boldSystemFontOfSize:17]];
    [_pwdTF setSecureTextEntry:YES];
    _pwdTF.returnKeyType = UIReturnKeyDone;
    [_loginIV addSubview:_pwdTF];
  
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(TF_X1, 255+height_2, 300, 44)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_s.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginIV addSubview:loginButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数


/**
 *  页面输入合法性判断
 *
 *  @return
 */
-(BOOL) checkValue{
    if([@"" isEqualToString:[_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return NO;
    }else if([@"" isEqualToString:[_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return  NO;
    }
    return YES;
}


#pragma mark-
#pragma mark--按钮点击
/**
 *  注册按钮被点击
 *
 *  @param sender
 */
-(IBAction)regsigerAction:(id)sender {
        RegisterViewController *regViewController = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:regViewController animated:YES];
}


/**
 *  登陆
 *
 *  @param sender
 */
-(IBAction)loginAction:(id)sender{
    if(![self checkValue]){
        return;
    }
    NSString *userName = [_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //保存页面的信息
    [UserDefaults setObject:userName forKey:KUSERNAME];
    [UserDefaults synchronize];//保存到disk
    
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,KUSERNAME,password,kPASSWORD, nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         TransferWithRequestDic:requestDic
                                         requesId:LOGIN
                                         prompt:@"hello"
                                         replaceId:nil
                                         success:^(id obj) {
                                             [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
                                             if([[obj objectForKey:@"rs"]intValue] == 1){
                                                    HomeViewController *homeViewController = [[HomeViewController alloc]init];
                                                    [self.navigationController pushViewController:homeViewController animated:YES];
                                             }else if([[obj objectForKey:@"rs"]intValue] == 0){
                                                 [SVProgressHUD showErrorWithStatus:@"用户名或密码错误！"];
                                             }
                                         } failure:^(NSString *errMsg) {
                                             
                                         }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在登录..." completeBlock:^(NSArray *operations) {
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
}

@end
