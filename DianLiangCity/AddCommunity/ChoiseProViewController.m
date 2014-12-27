//
//  ChoiseCityViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChoiseProViewController.h"
#import "BackButton.h"

@interface ChoiseProViewController () <UITableViewDataSource>
{
    NSMutableArray *cityArray;
    MBProgressHUD *hud;
    int selectIndex;
}

@end

@implementation ChoiseProViewController


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
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EGOCache *cache = [EGOCache globalCache];
        cityArray = (NSMutableArray *)[cache objectForKey:@"procityarea"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!cityArray || cityArray.count == 0)
            {
                //如果有网络连接
                if ([UserModel Instance].isNetworkRunning)
                {
                    NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_get_region, api_key];
                    NSString *url = [NSString stringWithString:tempUrl];
                    [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                               success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                                   @try
                                                   {
                                                       EGOCache *cache = [EGOCache globalCache];
                                                       cityArray = [Tool readJsonStrToRegionArray:operation.responseString];
                                                       if(cityArray && cityArray.count > 0)
                                                       {
                                                           [cache setObject:cityArray forKey:@"procityarea"];
                                                       }
                                                       self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                       
                                                       [self.tableView reloadData];
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
            else
            {
                [hud hide:YES];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [self.tableView reloadData];
            }
        });
    });
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
    [self performSegueWithIdentifier:@"ChoiseCityView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChoiseCityView"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:[cityArray objectAtIndex:selectIndex] forKey:@"selectProvinceModel"];
    }
}

@end
