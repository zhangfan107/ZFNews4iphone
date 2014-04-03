//
//  MyProgressView.m
//  LKOA4iPhone
//
//  Created by  STH on 11/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "MyProgressView.h"
#import "LMAlertView.h"

@implementation MyProgressView

@synthesize progressView = _progressView;
@synthesize progressLabel = _progressLabel;

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	[self setSize:CGSizeMake(280.0, 150.0)];
	
	UIView *contentView = self.contentView;
    
    // add progress view
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(10, 70, 180, 50);
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [contentView addSubview:self.progressView];
    
    // add progress view
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 53, 70, 30)];
    self.progressLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.progressLabel.backgroundColor = [UIColor clearColor];//comment it to look label's position
    self.progressLabel.textColor = LKCOLOR;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    // Add By STH 20130808
    self.progressLabel.text = @"正在链接...";
    self.progressLabel.adjustsFontSizeToFitWidth = YES;
    [contentView addSubview:self.progressLabel];
    
    return self;
}

@end
