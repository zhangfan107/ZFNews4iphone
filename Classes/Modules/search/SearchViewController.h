//
//  SearchViewController.h
//  ZFNews4iphone
//
//  Created by zfhtjs on 14-4-8.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITextField *searchTF;           //搜索输入框
@property (nonatomic,strong) UIButton *searchBT;
@property (nonatomic,strong) UITableView *mytableView;
@property (nonatomic,strong) NSMutableArray *myarray;

@property (nonatomic,strong) UIImageView *searchIV;

@end
