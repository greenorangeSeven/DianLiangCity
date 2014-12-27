//
//  CommHotlineView.m
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommHotlineView.h"
#import "CommHotlineCell.h"

@interface CommHotlineView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *hotlines;
    UIWebView *phoneCallWebView;
}

@end

@implementation CommHotlineView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initHotline];
}

- (void)initHotline
{
    if ([UserModel Instance].isNetworkRunning)
    {
        // 1是动态 2是风采
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%i",api_base_url,api_get_services_hotline,api_key,self.commData.id];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载" andView:self.mainView andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    hotlines = [Tool readJsonStrToHotline:request.responseString];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hotlines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommHotlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommHotlineCell"];
    if(!cell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommHotlineCell" owner:self options:nil];
        for(NSObject *o in objects)
        {
            if([o isKindOfClass:[CommHotlineCell class]])
            {
                cell = (CommHotlineCell *)o;
                break;
            }
        }
    }
    
    Hotline *hotline = [hotlines objectAtIndex:indexPath.row];
    [cell bindData:hotline];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Hotline *hotline = [hotlines objectAtIndex:indexPath.row];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", hotline.tel]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
