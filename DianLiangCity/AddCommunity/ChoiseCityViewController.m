//
//  ChoiseCityViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChoiseCityViewController.h"
#import "BackButton.h"

@interface ChoiseCityViewController () <UITableViewDataSource>
{
    NSArray *cityArray;
    MBProgressHUD *hud;
    int selectIndex;
}

@end

@implementation ChoiseCityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initCitys];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//初始化省市区信息
- (void)initCitys
{
    cityArray = self.selectProvinceModel.cityArray;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"chooseCommCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCommCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    ProvinceModel *provinceModel = [cityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = provinceModel.name;
    cell.imageView.image = [UIImage imageNamed:@"jzfw_arrow"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ChoiseAreaViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChoiseAreaViewController"])
    {
        CityModel *cityModel = [cityArray objectAtIndex:selectIndex];
        UIViewController *viewController = [segue destinationViewController];
        [viewController setValue:self.selectProvinceModel forKey:@"selectProvinceModel"];
        [viewController setValue:cityModel forKey:@"selectCityModel"];
    }
}

@end
