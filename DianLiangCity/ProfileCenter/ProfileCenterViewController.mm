//
//  ProfileCenterViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-5.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ProfileCenterViewController.h"
#import "BackButton.h"
#import "MainViewController.h"
#import "PersonInfoViewController.h"

@interface ProfileCenterViewController ()

@end

@implementation ProfileCenterViewController

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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        return 55;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"SystemConfigure" bundle:nil] instantiateViewControllerWithIdentifier:@"SystemConfigureViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"FamilySetView" sender:self];
    }
    else if(indexPath.row == 4)
    {
        UserInfo *info = [[UserModel Instance] getUserInfo];
        NSString *name = [NSString stringWithFormat:@"mycommunity%i",info.id];
        [[EGOCache globalCache] removeCacheForKey:name];
        [[UserModel Instance] logoutUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logined" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
