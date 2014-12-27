//
//  ChoiseCityViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiseCityViewController : UITableViewController

@property (weak,nonatomic) ProvinceModel *selectProvinceModel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
