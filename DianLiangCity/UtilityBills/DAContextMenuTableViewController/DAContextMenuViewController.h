//
//  DAContextMenuViewController.h
//  DAContextMenuTableViewControllerDemo
//
//  Created by Jia Xiaochao on 14-6-30.
//  Copyright (c) 2014年 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAContextMenuCell.h"
#import "DAOverlayView.h"

@interface DAContextMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DAContextMenuCellDelegate, DAOverlayViewDelegate>

@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
