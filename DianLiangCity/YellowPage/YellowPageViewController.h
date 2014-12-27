//
//  YellowPageViewController.h
//  DelightCity
//
//  Created by totem on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommSummaryView.h"
#import "CommNewView.h"
#import "CommHotlineView.h"

@interface YellowPageViewController : UIViewController

//社区介绍视图
@property (strong, nonatomic) CommSummaryView *commSummaryView;

//社区风采,动态视图
@property (strong, nonatomic) CommNewView *commNewView;

//社区热线服务视图
@property (strong, nonatomic) CommHotlineView *commHotlineView;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) Community *commData;
@end
