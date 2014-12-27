//
//  ChoiseCommunityViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChoiseCommunityViewController.h"

@interface ChoiseCommunityViewController ()
{
    NSArray *communityArray;
    MBProgressHUD *hud;
}
@end

@implementation ChoiseCommunityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initCommunityInfo];
}

- (void)initCommunityInfo
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&province=%@&city=%@&town=%@", api_base_url, api_community, api_key,self.selectProvinceModel.id,self.selectCityModel.id,self.selectRegionModel.id];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           communityArray = [Tool readJsonStrToComms:operation.responseString];
                                           if(communityArray && communityArray.count > 0)
                                           {
                                               [self.tableView reloadData];
                                           }
                                           else
                                           {
                                               [Tool showCustomHUD:@"该地区没有社区信息" andView:self.view  andImage:nil andAfterDelay:2];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           [hud hide:YES];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
}

- (IBAction)searchAction:(id)sender
{
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return communityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    Community *comm = [communityArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = comm.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ChoiseIdentitySegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChoiseIdentitySegue"])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:[communityArray objectAtIndex:path.row] forKey:@"selectComm"];
    }
}

@end
