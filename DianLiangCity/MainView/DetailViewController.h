//
//  DetailViewController.h
//  DianLiangCity
//
//  Created by mac on 14-11-21.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic) Advertisement *adv;
@property (nonatomic) SystemInform *sysInfo;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
