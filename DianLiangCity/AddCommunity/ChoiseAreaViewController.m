//
//  ChoiseAreaViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChoiseAreaViewController.h"
#import "BackButton.h"

@interface ChoiseAreaViewController ()
{
    NSArray *areaArray;
    int selectIndex;
}
@end

@implementation ChoiseAreaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initArea];
}

- (void)initArea
{
    areaArray = self.selectCityModel.regionArray;
}
- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return areaArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"chooseAreaCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseArea"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    RegionModel *regionModel = [areaArray objectAtIndex:indexPath.row];
    cell.textLabel.text = regionModel.name;
    cell.imageView.image = [UIImage imageNamed:@"jzfw_arrow"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ChoiseCommSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChoiseCommSegue"])
    {
        RegionModel *regionModel = [areaArray objectAtIndex:selectIndex];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:self.selectProvinceModel forKey:@"selectProvinceModel"];
        [controller setValue:self.selectCityModel forKey:@"selectCityModel"];
        [controller setValue:regionModel forKey:@"selectRegionModel"];
    }
}

@end
