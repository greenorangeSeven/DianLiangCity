//
//  ChoiseCommunityViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface ChoiseCommunityViewController : TTBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak,nonatomic) ProvinceModel *selectProvinceModel;
@property (weak,nonatomic) CityModel *selectCityModel;
@property (weak,nonatomic) RegionModel *selectRegionModel;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)searchAction:(id)sender;
@end
