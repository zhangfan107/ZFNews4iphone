//
//  RegisterViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-26.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：注册页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController<UIAlertViewDelegate>

@property (nonatomic,strong) UITextField *userTF;
@property (nonatomic,strong) UITextField *pwdTF;
@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UIButton *agreeIB;
@property (nonatomic,assign) BOOL isAgree;

@property(nonatomic,strong) UIImageView *regIV;


@end
