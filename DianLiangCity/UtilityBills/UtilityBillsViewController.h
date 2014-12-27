//
//  UtilityBillsViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-27.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "DAContextMenuCell.h"
#import "DAOverlayView.h"

@interface UtilityBillsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DAContextMenuCellDelegate, DAOverlayViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Community *commData;
@property (weak, nonatomic) IBOutlet UITableView *billsClassTableView;
@property (weak, nonatomic) IBOutlet UITableView *billsListTableView;
@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;

@end
