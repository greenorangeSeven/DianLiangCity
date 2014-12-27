//
//  SystemNoticeInfomationViewController.h
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface SystemNoticeInfomationViewController : TTBaseViewController

@property (strong, nonatomic) SystemInform *form;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
