//
//  WuYeNoticeViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-2.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "WuYeNoticeViewController.h"
#import "BackButton.h"
#import "CommNoticCell.h"
#import "WuYeNoticeDetailViewController.h"

@interface WuYeNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *commNotics;
    BOOL isShowFirst;
    BOOL isLoading;
    BOOL noRefresh;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@end

@implementation WuYeNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    commNotics = [[NSMutableArray alloc] initWithCapacity:20];
    NSLog(@"the size:%i",commNotics.count);
    [self reload:NO];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning)
    {
        return commNotics.count + 1;
    }
    else
        return commNotics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([commNotics count] > 0)
    {
        if ([indexPath row] < [commNotics count])
        {
            CommNoticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommNoticCell"];
            if(!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommNoticCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[CommNoticCell class]])
                    {
                        cell = (CommNoticCell *)o;
                        break;
                    }
                }
            }
            CommNotic *commNew = [commNotics objectAtIndex:indexPath.row];
            [cell bindData:commNew];
            return cell;
        }
        else
        {
            UITableViewCell *cell = [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
            cell.backgroundColor = UIColorRGB(252, 247, 229);
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"没有信息,请尝试下拉刷新" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        cell.backgroundColor = UIColorRGB(252, 247, 229);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    //点击“下面20条”
    if (row >= [commNotics count]) {
        //启动刷新
        if (!isLoading) {
            [self performSelector:@selector(reload:)];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"WuYeNoticeViewDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WuYeNoticeViewDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CommNotic *notic = [commNotics objectAtIndex:indexPath.row];
        WuYeNoticeDetailViewController *controller = [segue destinationViewController];
        controller.type_id = self.type_id;
        [controller setValue:notic.id forKey:@"noticId"];
    }
}

#pragma mark - 下拉刷新回调函数
#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//手指下拉然后松开(这时调用刷新)
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加下拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
}

//数据源是否已经加载
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning)
    {
        isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)reload:(BOOL)noRefreshs
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver)
        {
            return;
        }
        if (!noRefreshs)
        {
            allCount = 0;
        }
        noRefresh = noRefreshs;
        int pageIndex = allCount / 20;
        if(pageIndex <= 0)
            pageIndex = 1;
        NSString *url;
        //如果为1则是物业通告
        if(self.type_id == 1)
        {
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&p=%i",api_base_url,api_get_notice_list,api_key,self.commData.id,pageIndex];
        }
        //如果为2则是政务通告
        else if(self.type_id == 2)
        {
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&p=%i",api_base_url,api_get_zhengwutg_list,api_key,self.commData.id,pageIndex];
        }
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"列表加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
    
    //如果是刷新
    [self doneLoadingTableViewData];
    
    if ([UserModel Instance].isNetworkRunning == NO)
    {
        return;
    }
    isLoading = NO;
    if ([UserModel Instance].isNetworkRunning)
    {
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSMutableArray *newNews = [Tool readJsonStrToCommNotics:request.responseString];
    isLoading = NO;
    if (!noRefresh)
    {
        [self clear];
    }
    int count = [newNews count];
    allCount += count;
    if (count < 20)
    {
        isLoadOver = YES;
    }
    [commNotics addObjectsFromArray:newNews];
    [self.tableView reloadData];
    [self doneLoadingTableViewData];
}

- (void)clear
{
    allCount = 0;
    [commNotics removeAllObjects];
    isLoadOver = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
