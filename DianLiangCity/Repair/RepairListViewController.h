//
//  RepairListViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-30.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface RepairListViewController : UIViewController

@property (strong, nonatomic) Community *commData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)segmentValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end
