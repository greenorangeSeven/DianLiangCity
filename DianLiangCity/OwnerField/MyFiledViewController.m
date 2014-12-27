//
//  MyFiledViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-3.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyFiledViewController.h"

@interface MyFiledViewController ()

@end

@implementation MyFiledViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    if (indexPath.row == 1)
    {
        identifier = @"secondCell";
    }
    if (indexPath.row == 2) {
        identifier = @"thirdCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 56;
    }
    return 77;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
