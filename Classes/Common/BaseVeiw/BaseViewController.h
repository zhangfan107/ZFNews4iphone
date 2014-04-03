//
//  BaseViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-18.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, assign)BOOL hasSureButton;//是否有确定按钮
@property(nonatomic, assign)BOOL hasHomeButton;

@property(assign, nonatomic)BOOL isBackMain;
@property(assign, nonatomic)BOOL isHomeMain;
@property(assign, nonatomic)BOOL hasSendButton;
@property(assign, nonatomic)float tableViewHeight_1;
@property(assign, nonatomic)float tableViewHeight_2;
@property(assign, nonatomic)float height;


- (BaseViewController *) selectedTab;
- (void) setSelectedTab:(BaseViewController *)vc;

- (void) refresh;

- (void)setExtraCellLineHidden:(UITableView *)tableView;
- (void)setAjustHeight:(UIFont *)font Label:(UILabel *)label;
-(float)getAjustHeight:(UIFont *)font Text:(NSString *)text Width:(float)width;

-(IBAction)homeAction:(id)sender;
-(UIImage *)stretchImage:(UIImage *) image;
-(void)buttonBgWithNomal:(NSString*) nomal Selected:(NSString*) selected Button:(UIButton*)button;


@end
