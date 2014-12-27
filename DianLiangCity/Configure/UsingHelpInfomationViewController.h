//
//  UsingHelpInfomationViewController.h
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsingHelpInfomationViewController : UIViewController

@property (nonatomic, strong) Helps *help;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
