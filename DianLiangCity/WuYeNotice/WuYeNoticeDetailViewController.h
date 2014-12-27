//
//  WuYeNoticeDetailViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-2.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface WuYeNoticeDetailViewController : TTBaseViewController

@property int type_id;

@property (copy, nonatomic) NSString *noticId;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
