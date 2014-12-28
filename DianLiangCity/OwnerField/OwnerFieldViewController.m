//
//  OwnerFieldViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-2.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "OwnerFieldViewController.h"
#import "NewFieldViewController.h"
#import "EGOImageView.h"
#import "TQImageCache.h"
#import "BBSModel.h"
#import "BBSTableCell.h"
#import "OwnerFieldCell.h"
#import "BBSReplyView.h"
#import "BBSPostedView.h"
#import "UIViewController+CWPopup.h"
#import "UITap.h"
#import "MWPhotoBrowser.h"

@interface OwnerFieldViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,IconDownloaderDelegate, UIAlertViewDelegate>
{
    NSMutableArray *channelArray;
    Channel *currentChannel;
    NSString *sortName;
    OwnerScope *ownerScope;
    NSMutableArray *bbsArray;
    BOOL isLoading;
    BOOL isLoadOver;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    UIWebView *phoneCallWebView;
    
    MBProgressHUD *hud;
    int tableIndex;
    BBSReplyView *samplePopupViewController;
    NSArray *_photos;
    
    NSString *userId;
}
@property (nonatomic, weak) NSString *nextTitle;
@property (nonatomic, strong) NSMutableArray *messageArray;
@end

@implementation OwnerFieldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(myFieldAction:) title:@"我的帖子"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.messageArray = [NSMutableArray arrayWithObjects:@"cell", @"secondCell", nil];
    
    samplePopupViewController = [[BBSReplyView alloc] initWithNibName:@"BBSReplyView" bundle:nil];
    samplePopupViewController.parentView = self;
    //    [_replyTF becomeFirstResponder];
    
    //适配iOS7uinavigationbar遮挡问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    //下拉刷新
    if (_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [_refreshHeaderView refreshLastUpdatedDate];
    self.view.backgroundColor = [Tool getBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticReload) name:@"noticReload" object:nil];
    
    [self loadChannel];
}

- (void)noticReload
{
    isLoading = NO;
    isLoadOver= NO;
    [self reload:YES];
}

//加载频道
- (void)loadChannel
{
    if ([UserModel Instance].isNetworkRunning)
    {
        [Tool showHUD:@"正在加载频道" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&cid=%i", api_base_url, api_bbs_channel, api_key, self.commData.id];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try
            {
                
                channelArray = [Tool readJsonStrToChannels:operation.responseString];
                if(channelArray && channelArray.count > 0)
                {
                    [self.channelSegment removeSegmentAtIndex:0 animated:NO];
                    [self.channelSegment removeSegmentAtIndex:1 animated:NO];
                    NSMutableArray *segs = [[NSMutableArray alloc] init];
                    for(int i = 0;i < channelArray.count; ++i)
                    {
                        Channel *channel =[channelArray objectAtIndex:i];
                        [segs addObject:channel.channel_name];
                        [self.channelSegment insertSegmentWithTitle:channel.channel_name atIndex:i animated:YES];
                    }
                    currentChannel = [channelArray objectAtIndex:0];
                    [self.channelSegment setSelectedSegmentIndex:0];
                    if (isInitialize == NO)
                    {
                        isInitialize = YES;
                        [self reload:YES];
                    }
                }
                else
                {
                    [Tool showCustomHUD:@"当前社区没有频道" andView:self.view andImage:nil andAfterDelay:2.0];
                }
            }
            @catch (NSException *exception) {
                [NdUncaughtExceptionHandler TakeException:exception];
            }
            @finally
            {
                if(!hud.hidden)
                {
                    hud.hidden = YES;
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取出错");
            //刷新错误
            if ([UserModel Instance].isNetworkRunning == NO) {
                return;
            }
            if ([UserModel Instance].isNetworkRunning) {
                [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
            }
        }];
    }
}

- (void)refreshTableData
{
    
}

- (void)refreshTableDataAll
{
    [self refresh];
}

- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma 生命周期
- (void)viewDidUnload
{
    [self setTableView:nil];
    _refreshHeaderView = nil;
    [bbsArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    bbsArray = nil;
    _iconCache = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    //清空
    for (BBSModel *c in bbsArray) {
        c.imgData = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (void)clear
{
    [bbsArray removeAllObjects];
    [_imageDownloadsInProgress removeAllObjects];
    isLoadOver = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.imageDownloadsInProgress != nil) {
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
}

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

- (void)reload:(BOOL)noRefresh
{
    if ([UserModel Instance].isNetworkRunning)
    {
        hud.hidden = NO;
        [Tool showHUD:@"正在加载帖子" andView:self.view andHUD:hud];
        NSMutableString *tempUrl;
        if(sortName&&sortName.length > 0)
        {
            tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&channel_id=%i&sort=%@", api_base_url, api_bbs_bbs, api_key, self.commData.id,currentChannel.id,sortName];
        }
        else
        {
            tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&channel_id=%i", api_base_url, api_bbs_bbs, api_key, self.commData.id,currentChannel.id];
        }
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try {
                [self clear];
                ownerScope = [Tool readJsonStrToOwnerScopes:operation.responseString];
                bbsArray = ownerScope.list;
                int count = [bbsArray count];
                if (count < 20)
                {
                    isLoadOver = YES;
                }
                self.topicSizeLabel.text = [NSString stringWithFormat:@"共%i个帖子",count];
                [self.tableView reloadData];
                [self doneLoadingTableViewData];
            }
            @catch (NSException *exception) {
                [NdUncaughtExceptionHandler TakeException:exception];
            }
            @finally
            {
                if(!hud.hidden)
                {
                    hud.hidden = YES;
                }
                [self doneLoadingTableViewData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取出错");
            //刷新错误
            [self doneLoadingTableViewData];
            isLoading = NO;
            if ([UserModel Instance].isNetworkRunning == NO) {
                return;
            }
            if ([UserModel Instance].isNetworkRunning) {
                [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
            }
        }];
        
        isLoading = YES;
        //        [self.tableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

//2013.12.18song. tableView添加上拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading)
    {
        NSLog(@"lp;");
        [self performSelector:@selector(reload:)];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return NSDate.date;
}

#pragma 下载图片
- (void)startIconDownload:(ImgRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",[indexPath row]];
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:key];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgRecord = imgRecord;
        iconDownloader.index = key;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:key];
        [iconDownloader startDownload];
    }
}

- (void)appImageDidLoad:(NSString *)index
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:index];
    if (iconDownloader)
    {
        int _index = [index intValue];
        if (_index >= [bbsArray count])
        {
            return;
        }
        BBSModel *c = [bbsArray objectAtIndex:[index intValue]];
        if (c) {
            c.imgData = iconDownloader.imgRecord.img;
            // cache it
            NSData * imageData = UIImagePNGRepresentation(c.imgData);
            [_iconCache putImage:imageData withName:[TQImageCache parseUrlForCacheName:c.avatar]];
            [self.tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoadOver) {
            return bbsArray.count == 0 ? 1 : bbsArray.count;
        }
        else
            return bbsArray.count + 1;
    }
    else
        return bbsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < bbsArray.count)
    {
        BBSModel *bbs = [bbsArray objectAtIndex:[indexPath row]];
        int height = 144;
        if ([bbs.thumb count] == 0)
        {
            height -= 63;
        }
        else
        {
            int size = bbs.thumb.count / 3;
            if(size < 1)
                size = 0;
            
            int thumbExtraHeight = size * 63;
            height += thumbExtraHeight;
        }
        return height;
    }
    else
    {
        return 62;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([bbsArray count] > 0)
    {
        if (indexPath.row < [bbsArray count])
        {
            OwnerFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OwnerFieldCell"];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OwnerFieldCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[OwnerFieldCell class]])
                    {
                        cell = (OwnerFieldCell *)o;
                        break;
                    }
                }
            }
            
            BBSModel *bbs = [bbsArray objectAtIndex:[indexPath row]];
            [cell bindData:bbs];
            return cell;
        }
        else
        {
            return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"已经加载全部内容" andLoadingString:(isLoading ? loadingTip : loadNext20Tip) andIsLoading:isLoading];
        }
    }
    else
    {
        return [[DataSingleton Instance] getLoadMoreCell:tableView andIsLoadOver:isLoadOver andLoadOverString:@"暂无数据" andLoadingString:(isLoading ? loadingTip : loadNext20Tip)  andIsLoading:isLoading];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"FieldDetailView" sender:self];
}

- (void)delAction:(id)sender
{
    UIButton *tap = (UIButton *)sender;
    if (tap)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"删除提醒"
                                                     message:@"您确定要删除这篇贴子？"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
        av.tag =tap.tag;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        int tag = alertView.tag;
        BBSModel *bbs = [bbsArray objectAtIndex:tag];
        if (bbs) {
            NSString *delUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%@&id=%@", api_base_url, api_delbbs, api_key, userId, bbs.id];
            NSURL *url = [ NSURL URLWithString : delUrl];
            // 构造 ASIHTTPRequest 对象
            ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
            // 开始同步请求
            [request startSynchronous ];
            NSError *error = [request error ];
            assert (!error);
            // 如果请求成功，返回 Response
            NSString *response = [request responseString ];
            NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            int status = 0;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (json) {
                status = [[json objectForKey:@"status"] intValue];
                if (status == 1) {
                    [Tool showCustomHUD:@"删除成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:1];
                    [bbsArray removeObjectAtIndex:tag];
                    [self.tableView reloadData];
                }
                else
                {
                    [Tool showCustomHUD:@"删除失败" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                }
            }
        }
    }
}


-(void)myFieldAction:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"myFiledIdentifier" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewFieldView"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:self.commData forKey:@"commData"];
        [controller setValue:currentChannel forKey:@"currentChannel"];
    }
    else if([segue.identifier isEqualToString:@"FieldDetailView"])
    {
        BBSModel *bbs = [bbsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:bbs forKey:@"bbs"];
    }
}

- (IBAction)huifuMoreAction:(UIButton *)sender
{
    sortName = @"replys";
    [self reload:YES];
}
- (IBAction)hintMoreAction:(UIButton *)sender
{
    sortName = @"hits";
    [self reload:YES];
}

- (IBAction)chooseChannel:(UISegmentedControl *)sender
{
    currentChannel = [channelArray objectAtIndex:sender.selectedSegmentIndex];
    [self reload: YES];
}

- (IBAction)pushAction:(id)sender
{
    [self performSegueWithIdentifier:@"NewFieldView" sender:self];
}


@end
