//
//  HomeListViewController.h
//  ZFNews4iphone
//
//  Created by zfht on 14-4-2.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
- (void)viewDidCurrentView;

@end
