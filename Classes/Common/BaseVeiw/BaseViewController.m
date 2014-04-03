//
//  BaseViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-18.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDataCenter.h"


#define kSCNavBarImageTag       10

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize tableViewHeight_1 = _tableViewHeight_1;
@synthesize tableViewHeight_2 = _tableViewHeight_2;
@synthesize height = _height;
@synthesize isBackMain = _isBackMain;
@synthesize isHomeMain = _isHomeMain;
@synthesize hasSureButton = _hasSureButton;


static BaseViewController *selectedTab = nil;
- (BaseViewController *) selectedTab
{
    return selectedTab;
}

- (void) setSelectedTab:(BaseViewController *)vc
{
    selectedTab = vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(IS_IPHONE_5){
            _tableViewHeight_1 = 420.0f;
            _tableViewHeight_2 = 370.0f;
            _height = 90.0f;
        }else{
            _tableViewHeight_1 = 330.0f;
            _tableViewHeight_2 = 280.0f;
            _height = 0.0f;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        //if iOS 5.0 and later
        [navBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if(imageView == nil){
            imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header.png"]];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
    if(!self.navigationItem.hidesBackButton){
        // 返回按纽
        UIImage *buttonNormalImage = [UIImage imageNamed:@"backbutton_normal.png"];
        UIImage *buttonSelectedImage = [UIImage imageNamed:@"backbutton_normal.png"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setTitle:@"返回" forState:UIControlStateNormal];
        aButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [aButton setBackgroundImage:buttonNormalImage forState:UIControlStateNormal];
        [aButton setBackgroundImage:buttonSelectedImage forState:UIControlStateSelected];
        [aButton setFrame:CGRectMake(0.0, 0.0, 50,30)];
        [aButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:aButton];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    if (_hasSureButton) {
       
    }else{
        for (UIView *view in self.navigationController.navigationBar.subviews) {
            int tag = ((UIButton*)view).tag;
            if (tag == 1010) {
                [view removeFromSuperview];
            }
        }
    }
    
}

#pragma mark -

#pragma mark 解决虚拟键盘挡住UITextField的方法

- (void)keyboardWillShow:(NSNotification *)noti

{
    
    //键盘输入的界面调整
    
    //键盘的高度
    
    float height = 216.0;
    
    CGRect frame = self.view.frame;
    
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    
    [UIView setAnimationDuration:0.30];
    
    [UIView setAnimationDelegate:self];
    
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    //CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    return YES;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    CGRect frame = textField.frame;
    
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    if(offset > 0)
        
    {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        self.view.frame = rect;
        
    }
    
    [UIView commitAnimations];
    
}

#pragma mark -

-(IBAction)backButtonAction:(id)sender{
    if (self.isBackMain) {
        [ApplicationDelegate.rootNavigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)homeAction:(id)sender{
    if (self.isHomeMain) {
        [ApplicationDelegate.rootNavigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

//tableview 去掉多余分隔线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    //NSLog(@"%f   %f", view.frame.size.width, view.frame.size.height);
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)setAjustHeight:(UIFont *)font Label:(UILabel *)label{
    [label setFont:font];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    CGSize size = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(label.frame.size.width, 2000.0f)
                             lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect=label.frame;
    rect.size=size;
    [label setFrame:rect];
}

-(float)getAjustHeight:(UIFont *)font Text:(NSString *)text Width:(float)width{
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 2000.0f)
                       lineBreakMode:UILineBreakModeWordWrap];
    return  size.height;
}

-(UIImage *)stretchImage:(UIImage *) image
{
    UIImage *returnImage = nil;
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion == 5.0) {
        returnImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, STRETCH, STRETCH, STRETCH)];
    }else if(systemVersion >= 6.0){
        returnImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, STRETCH, STRETCH, STRETCH)resizingMode:UIImageResizingModeTile];
    }
    return returnImage;
}

-(void)buttonBgWithNomal:(NSString*) nomal Selected:(NSString*) selected Button:(UIButton*)button{
    [button setImage:[UIImage imageNamed:nomal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];
}

@end
