//
//  OwnerCertificationViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-14.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "OwnerCertificationViewController.h"
#import "BackButton.h"

@interface OwnerCertificationViewController ()

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation OwnerCertificationViewController

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

#pragma mark
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.lastIndexPath = indexPath;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    [destination setValue:self.title forKey:@"communityName"];
}


@end
