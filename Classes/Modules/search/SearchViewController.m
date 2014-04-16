//
//  SearchViewController.m
//  ZFNews4iphone
//
//  Created by zfhtjs on 14-4-8.
//  Copyright (c) 2014年 com.zfht. All rights reserved.
//

#import "SearchViewController.h"
#import "NewsModel.h"
#import "ShowContentViewController.h"
#define TF_X1   10
#define TF_X2   10
#define TF_X3   90
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchTF = _searchTF;
@synthesize searchBT = _searchBT;
@synthesize mytableView = _mytableView;
@synthesize myarray = _myarray;

@synthesize searchIV = _searchIV;

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
        titleLabel.text = @"搜索";
        self.navigationItem.titleView = titleLabel;
    }
    _searchIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,height)];
    [_searchIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [_searchIV setUserInteractionEnabled:YES];
    [self.view addSubview:_searchIV];
    
    UIImage *sTextImage = [UIImage imageNamed:@"bg-search.png"];
    UIImageView *searchTextIV = [[UIImageView alloc]initWithImage:sTextImage];
    [searchTextIV setFrame:CGRectMake(TF_X1, 75, 240,40)];
    [searchTextIV setUserInteractionEnabled:YES];
    [_searchIV addSubview:searchTextIV];
    
    _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+30, 75, 215, 40)];
    _searchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTF.delegate = self;
    [_searchTF setPlaceholder:@""];
    [_searchTF setFont:[UIFont boldSystemFontOfSize:17]];
    _searchTF.returnKeyType = UIReturnKeyDone;
    _searchTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_searchIV addSubview:_searchTF];
    
    _searchBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBT setFrame:CGRectMake(TF_X1+245, 75, 60, 40)];
    [_searchBT setBackgroundImage:[UIImage imageNamed:@"bt-search.png"] forState:UIControlStateNormal];
    [_searchBT addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchIV addSubview:_searchBT];
    
    _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 120, 310, ScreenHeight-44-44-49-10) ];//style:UITableViewStylePlain
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    [_mytableView setBackgroundColor:[UIColor clearColor]];
    [_mytableView setBackgroundView:[[UIView alloc]init]];
    _mytableView.layer.cornerRadius = 8.0;
    [self setExtraCellLineHidden:_mytableView];
    //[self.view addSubview:_mytableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  页面输入合法性判断
 *
 *  @return
 */
-(BOOL) checkValue{
    if([@"" isEqualToString:[_searchTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"输入内容为空"];
        return NO;
    }
    return YES;
}

/**
 *  搜索
 *
 *  @param sender
 */
-(IBAction)searchAction:(id)sender{
    if(![self checkValue]){
        return;
    }
    _myarray = [[NSMutableArray array]init];
    NSString *searchword = [_searchTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         TransferWithRequestDic:@{@"searchword":[searchword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
                                         requesId:SEARCH
                                         prompt:@"hello"
                                         replaceId:nil
                                         success:^(id obj) {
                                             //[_searchBT removeFromSuperview];
                                             [_searchTF resignFirstResponder];
                                             if([[obj objectForKey:@"rs"]intValue] == 1){
                                                 if (!self.navigationItem.title) {
                                                     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
                                                     titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
                                                     titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
                                                     titleLabel.textColor = [UIColor whiteColor];
                                                     titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
                                                     titleLabel.text = @"搜索结果";
                                                     self.navigationItem.titleView = titleLabel;
                                                 }
                                                 NSArray *listArray = obj[@"rsList"];
                                                 for(int i = 0;i<listArray.count;i++){
                                                     NSArray *listArray1 = listArray[i];
                                                     for(int i = 0;i<listArray1.count;i++)
                                                     {
                                                     NSDictionary *dic = listArray1[i];
                                                     NewsModel *news = [[NewsModel alloc]init];
                                                     news.newsid = dic[@"ID"];
                                                     news.title = dic[@"TITLE"];
                                                     news.publisher = dic[@"PUBLISHER"];
                                                     news.publishtime = dic[@"PUBLISHTIME"];
                                                     news.flag = dic[@"FLAG"];
                                                     news.discount = dic[@"DISCOUNT"];
                                                     NSLog(@"news.title %@",news.title);
                                                     [self.myarray addObject:news];
                                                     }
                                             }
                                              NSLog(@"self.myarray count %d",[self.myarray count]);
                                             [_searchIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-bottom.png"]]];
                                             _mytableView.hidden=NO;
                                             [self.view addSubview:_mytableView];
                                                 
                                                 UIImage *sLine = [UIImage imageNamed:@"line.png"];
                                                 UIImageView *sLineIV = [[UIImageView alloc]initWithImage:sLine];
                                                 [sLineIV setFrame:CGRectMake(TF_X1, 5, 300,2)];
                                                 [sLineIV setUserInteractionEnabled:YES];
                                                 [_mytableView addSubview:sLineIV];
                                                 
                                             [self.mytableView reloadData];
                                             }else if([[obj objectForKey:@"rs"]intValue] == 0){
                                                 if (!self.navigationItem.title) {
                                                     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
                                                     titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
                                                     titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
                                                     titleLabel.textColor = [UIColor whiteColor];
                                                     titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
                                                     titleLabel.text = @"搜索";
                                                     self.navigationItem.titleView = titleLabel;
                                                 }
                                                 _mytableView.hidden=YES;
                                                 [SVProgressHUD showErrorWithStatus:@"无此类新闻！"];
                                             }
                                         } failure:^(NSString *errMsg) {
                                             
                                         }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在搜索..." completeBlock:^(NSArray *operations) {
        
    }];
}

#pragma mark-
#pragma mark--TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.myarray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    static NSString *cellIdentifier = @"CellIdenti";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //避免重叠
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NewsModel *news = [self.myarray objectAtIndex:indexPath.row];
    if (news.title!=nil&&news.title!=NULL) {
        UILabel *bnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 275, 50)];//50
        bnameLabel.backgroundColor = [UIColor clearColor];
//      bnameLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentLeft;
        bnameLabel.font = [UIFont boldSystemFontOfSize:15];
        bnameLabel.textColor = [UIColor blackColor];
        bnameLabel.textAlignment = UITextAlignmentLeft;
        bnameLabel.numberOfLines = 0;//表示label可以多行显示
        bnameLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        bnameLabel.text = news.title;
        [cell.contentView addSubview:bnameLabel];
        
        UILabel *publisher = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 275, 5)];
        publisher.backgroundColor = [UIColor clearColor];
        publisher.font = [UIFont boldSystemFontOfSize:15];
        publisher.textColor = [UIColor blackColor];
        publisher.textAlignment = UITextAlignmentLeft;
        publisher.text = news.publisher;
        [bnameLabel addSubview:publisher];
        
        UIImage *more = [UIImage imageNamed:@"more.png"];
        UIImageView *moreIV = [[UIImageView alloc]initWithImage:more];
        [moreIV setFrame:CGRectMake(293, 20, 10,20)];
        [moreIV setUserInteractionEnabled:YES];
        [cell.contentView addSubview:moreIV];
        
        return cell;
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *news = [self.myarray objectAtIndex:indexPath.row];
    NSString *newsid = news.newsid;
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         sendRequestWithRequestDic:@{@"newsid":newsid}
                                         requesId:OPENNEWS messId:nil success:^(id obj) {
                                             if([[obj objectForKey:@"rs"]intValue] == 1){
                                                 NSString *content=obj[@"content"];
                                                 NSString *column=obj[@"newscolumn"];
                                                 news.content = content;
                                                 news.column = column;
                                                 ShowContentViewController *vc = [[ShowContentViewController alloc] initWithNews:news];
                                                 vc.hidesBottomBarWhenPushed = YES;
                                                 [self.navigationController pushViewController:vc animated:YES];

                                             }else if([[obj objectForKey:@"rs"]intValue] == 0){
                                                 [SVProgressHUD showErrorWithStatus:@"打开新闻失败！"];
                                             }
                                         } failure:^(NSString *errMsg) {
                                             
                                         }];
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"打开中..."
                                   completeBlock:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchTF resignFirstResponder];
}
@end
