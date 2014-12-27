//
//  MyAccountViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyAccountViewController.h"
#import "BackButton.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path.row == 0)
    {
        [destination setValue:@"我的点券" forKey:@"title"];
    }
    else if (path.row == 1)
    {
        [destination setValue:@"我的红包" forKey:@"title"];
    }
    
}

@end
