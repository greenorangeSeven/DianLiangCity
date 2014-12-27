//
//  ChoiseIdentityViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChoiseIdentityViewController.h"
#import "BackButton.h"

@interface ChoiseIdentityViewController ()

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation ChoiseIdentityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.selectComm.title;
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
    if(indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"HouseViewController" sender:self];
    }
    else if(indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"MemberView" sender:self];
    }
    else if (indexPath.row == 2)
    {
        self.selectComm.customer_pro = 3;
        self.selectComm.areaList = nil;
        EGOCache *cache = [EGOCache globalCache];
        NSMutableArray *commDatas = (NSMutableArray *)[cache objectForKey:@"mycommunity-1"];
        if(!commDatas && commDatas.count <= 0)
        {
            commDatas = [[NSMutableArray alloc] init];
        }
        for(Community *comm in commDatas)
        {
            if(comm.id == self.selectComm.id)
            {
                [Tool showCustomHUD:@"您已经添加了该社区,不能重复添加" andView:self.view andImage:nil andAfterDelay:1.5];
                return;
            }
        }
        [commDatas addObject:self.selectComm];
        [cache setObjectForSync:commDatas forKey:@"mycommunity-1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyComm" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"HouseViewController"] ||
       [segue.identifier isEqualToString:@"MemberView"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:self.selectComm forKey:@"selectComm"];
    }
}

@end
