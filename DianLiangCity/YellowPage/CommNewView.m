//
//  CommNewView.m
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommNewView.h"
#import "CommNewCell.h"
#import "EGOImageView.h"
#import "CommNewDetailView.h"

@interface CommNewView () <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *commNews;
    CommNew *firstCommNew;
    UIView *tableHeaderView;
    BOOL isShowFirst;
    BOOL isLoading;
    BOOL noRefresh;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@end

@implementation CommNewView

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    tableHeaderView = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;
    commNews = [[NSMutableArray alloc] initWithCapacity:20];
    self.type_id = 1;
}

- (void) firstClick
{
    CommNewDetailView *detailView = [[CommNewDetailView alloc] init];
    detailView.commId = firstCommNew.id;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning)
    {
//        if (_isLoadOver)
//        {
//            NSLog(@"yun7777");
//            return commNews.count == 0 ? 1 : commNews.count;
//        }
//        else
//        {
//            NSLog(@"yun8888");
            return commNews.count + 1;
        //}
    }
    else
        return commNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([commNews count] > 0)
    {
        if ([indexPath row] < [commNews count])
        {
            CommNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommNewCell"];
            if(!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommNewCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[CommNewCell class]])
                    {
                        cell = (CommNewCell *)o;
                        break;
                    }
                }
            }
            CommNew *commNew = [commNews objectAtIndex:indexPath.row];
            [cell bindData:commNew];
            return cell;
        }
        else
        {
            UITableViewCell *cell = [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:_isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
            cell.backgroundColor = UIColorRGB(252, 247, 229);
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:_isLoadOver andLoadOverString:@"已经加载全部" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        cell.backgroundColor = UIColorRGB(252, 247, 229);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommNew *commNew = [commNews objectAtIndex:indexPath.row];
    CommNewDetailView *detailView = [[CommNewDetailView alloc] init];
    detailView.commId = commNew.id;
    [self.navigationController pushViewController:detailView animated:YES];
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
//    if (!isLoading)
//    {
//        NSLog(@"ppppp");
//        [self performSelector:@selector(reload:)];
//    }
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
        self.isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)reload:(BOOL)noRefreshs
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        if (isLoading || self.isLoadOver)
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
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&type_id=%i&p=%i",api_base_url,api_get_news_list,api_key,self.commData.id,self.type_id,pageIndex];
        // 1是动态 2是风采
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
    [Tool showCustomHUD:@"列表加载失败" andView:self.mainView andImage:nil andAfterDelay:1.5];
    
    //如果是刷新
    [self doneLoadingTableViewData];
    
    if ([UserModel Instance].isNetworkRunning == NO) {
        return;
    }
    isLoading = NO;
    if ([UserModel Instance].isNetworkRunning) {
        
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSMutableArray *newNews = [Tool readJsonStrToCommNews:request.responseString];
    isLoading = NO;
    if (!noRefresh)
    {
        [self clear];
        if(newNews && newNews.count > 1 && ((CommNew *)newNews[0]).thumb.length > 0)
        {
            self.tableView.tableHeaderView = tableHeaderView;
            firstCommNew = [newNews objectAtIndex:0];
            [self.itemImgView setPlaceholderImage:[UIImage imageNamed:@"area_icon.png"]];
            self.itemImgView.imageURL = [NSURL URLWithString:firstCommNew.thumb];
            [self.itemTitle setText:firstCommNew.title];
            //添加一个点击手势
            UITapGestureRecognizer *topic1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstClick)];
            [self.firstView addGestureRecognizer:topic1Tap];
            [newNews removeObjectAtIndex:0];
        }
        else
        {
            self.tableView.tableHeaderView.frame = CGRectMake(self.tableView.tableHeaderView.frame.origin.x, self.tableView.tableHeaderView.frame.origin.y, self.tableView.tableHeaderView.frame.size.width, 0);
            self.tableView.tableHeaderView = nil;
            self.tableView.tableHeaderView.hidden = YES;
            
        }
    }
    int count = [newNews count];
    allCount += count;
    if (count < 20)
    {
        self.isLoadOver = YES;
    }
    [commNews addObjectsFromArray:newNews];
    [self.tableView reloadData];
    [self doneLoadingTableViewData];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSLog(@"change=%@",change);
//    static int  b=0;
//    if (_tableView.contentOffset.y<=-20 && b%2==0) {
//        //_tableView.tableHeaderView = view;
//    }else if (_tableView.contentOffset.y >=20 && b%2==1){
//        _tableView.tableHeaderView = nil;
//    }
//    b++;
//}

- (void)clear
{
    allCount = 0;
    [commNews removeAllObjects];
    self.isLoadOver = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
