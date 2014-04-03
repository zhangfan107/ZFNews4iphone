//
//  HomeViewController.h
//  ZFNews4iphone
//
//  Created by zfht on 14-3-14.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "BaseViewController.h"
#import "SUNSlideSwitchView.h"
#import "HomeListViewController.h"

@interface HomeViewController : BaseViewController<SUNSlideSwitchViewDelegate>


@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) HomeListViewController *vc1;
@property (nonatomic, strong) HomeListViewController *vc2;
@property (nonatomic, strong) HomeListViewController *vc3;

@end
