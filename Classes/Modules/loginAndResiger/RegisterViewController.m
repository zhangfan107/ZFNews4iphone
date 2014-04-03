//
//  RegisterViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-26.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#define TF_X1   10
#define TF_X2   10
#define TF_X3   90

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize userTF = _userTF;
@synthesize pwdTF = _pwdTF;
@synthesize phoneTF = _phoneTF;
@synthesize regIV = _regIV;
@synthesize isAgree = _isAgree;
@synthesize agreeIB = _agreeIB;

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
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"注册帐号";
        self.navigationItem.titleView = titleLabel;
    }
    _regIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,height)];
    [_regIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [_regIV setUserInteractionEnabled:YES];
    [self.view addSubview:_regIV];
    
    UIImage *ubuttonNormalImage = [UIImage imageNamed:@"userPwd.png"];
    UIImageView *userPwIV = [[UIImageView alloc]initWithImage:ubuttonNormalImage];
    [userPwIV setFrame:CGRectMake(TF_X1, 130, 300,90)];
    [userPwIV setUserInteractionEnabled:YES];
    [_regIV addSubview:userPwIV];
    
    UILabel *zhLab = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+TF_X2, 130+height_2, 60, 45)];
    [zhLab setBackgroundColor:[UIColor clearColor]];
    [zhLab setFont:[UIFont boldSystemFontOfSize:17]];
    [zhLab setTextColor:[UIColor blackColor]];
    [zhLab setText:@"用户名"];
    [_regIV addSubview:zhLab];
    _userTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+TF_X3, 130+height_2, 210, 45)];
    _userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTF.delegate = self;
    [_userTF setPlaceholder:@"仅支持中英文，数字和下划线"];
    [_userTF setText:[[NSUserDefaults standardUserDefaults]stringForKey:KUSERNAME]];
    [_userTF setFont:[UIFont boldSystemFontOfSize:17]];
    _userTF.returnKeyType = UIReturnKeyDone;
    [_regIV addSubview:_userTF];
    
    UILabel *pwLab = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+TF_X2, 130+height_2+45, 60, 45)];
    [pwLab setBackgroundColor:[UIColor clearColor]];
    [pwLab setFont:[UIFont boldSystemFontOfSize:17]];
    [pwLab setTextColor:[UIColor blackColor]];
    [pwLab setText:@"密    码"];
    [_regIV addSubview:pwLab];
    _pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+TF_X3, 130+height_2+45, 210, 45)];
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTF.delegate = self;
    [_pwdTF setPlaceholder:@"6-14位，字母区分大小写"];
    [_pwdTF setText:[[NSUserDefaults standardUserDefaults]stringForKey:kPASSWORD]];
    [_pwdTF setFont:[UIFont boldSystemFontOfSize:17]];
    [_pwdTF setSecureTextEntry:YES];
    _pwdTF.returnKeyType = UIReturnKeyDone;
    [_regIV addSubview:_pwdTF];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(TF_X1, 255+height_2, 300, 44)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"resiger_n.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_regIV addSubview:loginButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+10, 310+height_2, 260, 17)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"点击注册表示已阅读并同意《用户服务协议》"];
    [_regIV addSubview:label];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
     //   [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return NO;
    }else if([@"" isEqualToString:[_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
   //     [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return  NO;
    }
    return YES;
}


#pragma mark-
#pragma mark--按钮点击事件

/**
 *  点击注册
 *
 *  @param sender 
 */
-(IBAction)registerAction:(id)sender{
    if(![self checkValue]){
        return;
    }
    NSString *userName = [_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"username",password,@"password",nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]TransferWithRequestDic:requestDic requesId:REGISTER prompt:nil replaceId:nil success:^(id obj) {
        [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
        if([[obj objectForKey:@"rs"]intValue]== 1){
            HomeViewController *homeViewController = [[HomeViewController alloc]init];
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:homeViewController animated:YES];
        }else if([[obj objectForKey:@"rs"]intValue] == 0){
            [SVProgressHUD showErrorWithStatus:@"注册失败！"];
        }else if([[obj objectForKey:@"rs"]intValue] == 2){
            [SVProgressHUD showErrorWithStatus:@"用户名已存在！"];
        }
    } failure:^(NSString *errMsg) {
        
    }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在注册..." completeBlock:^(NSArray *operations) {
        
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
}

/**
 *  跳转到首页
 */
-(void)homeView
{
    
    
}

@end
