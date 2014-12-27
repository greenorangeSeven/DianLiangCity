//
//  MyCoinViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyCoinViewController.h"
#import "BackButton.h"
@interface MyCoinViewController ()

@end

@implementation MyCoinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    if (indexPath.row == 1)
    {
        identifier = @"secondCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
