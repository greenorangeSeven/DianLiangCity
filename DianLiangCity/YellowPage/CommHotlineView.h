//
//  CommHotlineView.h
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommHotlineView : UIViewController

@property (weak, nonatomic) UIView *mainView;
@property (strong, nonatomic) Community *commData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
