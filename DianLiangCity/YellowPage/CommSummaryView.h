//
//  CommSummaryViewViewController.h
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommSummaryView : UIViewController

@property (weak, nonatomic) UIView *mainView;
@property (weak, nonatomic) Community *commData;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imgScroller;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
