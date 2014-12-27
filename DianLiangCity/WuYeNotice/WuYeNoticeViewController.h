//
//  WuYeNoticeViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-2.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuYeNoticeViewController : UIViewController

//当前社区
@property (strong, nonatomic) Community *commData;
//1:是物业通告,2:是政务通告
@property int type_id;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
