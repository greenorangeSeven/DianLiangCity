//
//  ChoiseCityViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChoiseProViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *locationCityBtn;
- (IBAction)locationCityAction:(id)sender;

@end
