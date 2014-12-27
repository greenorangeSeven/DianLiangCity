//
//  ChoiseAreaViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiseAreaViewController : UITableViewController

@property (weak,nonatomic) ProvinceModel *selectProvinceModel;
@property (weak,nonatomic) CityModel     *selectCityModel;

@end
