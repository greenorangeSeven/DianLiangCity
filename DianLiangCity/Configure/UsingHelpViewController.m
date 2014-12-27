//
//  UsingHelpViewController.m
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "UsingHelpViewController.h"
#import "BackButton.h"
#import "SystemNoticCell.h"

@interface UsingHelpViewController ()
{
    MBProgressHUD *hud;
    NSMutableArray *helps;
}

@end

@implementation UsingHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    [self initHelps];
}

//初始化系统通知
- (void)initHelps
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_get_help_list, api_key];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           helps = [Tool readJsonStrToHelps:operation.responseString];
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

#pragma mark - tableView的数据源适配方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return helps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNoticCell *sysCell = [tableView dequeueReusableCellWithIdentifier:@"SystemNoticCell"];
    if(!sysCell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SystemNoticCell" owner:self options:nil];
        for(NSObject *o in objects)
        {
            if([o isKindOfClass:[SystemNoticCell class]])
            {
                sysCell = (SystemNoticCell *)o;
                break;
            }
        }
    }
    
    Helps *help = [helps objectAtIndex:indexPath.row];
    [sysCell bindData:help];
    return sysCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"HelpDetailView" sender:self];
}

#pragma mark - 当使用segue跳转页面时会先调用该方法,这里进行传值操作
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"HelpDetailView"])
    {
        Helps *help = [helps objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:help forKey:@"help"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
