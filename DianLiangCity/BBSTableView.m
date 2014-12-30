//
//  BBSTableView.m
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BBSTableView.h"
#import "EGOImageView.h"
#import "BackButton.h"
#import "BBSButton.h"

@interface BBSTableView ()
{
    NSString *userId;
    BBSButton *showBBSBtn;
}
@end

@implementation BBSTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"社区共建";
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(publishAction) title:@"+发帖"];
        self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction) image:@"back_bg"];
        
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishAction
{
    if ([UserModel Instance].isLogin == NO)
    {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    BBSPostedView *publishView = [[BBSPostedView alloc] init];
    publishView.commData = self.commData;
    publishView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    samplePopupViewController = [[BBSReplyView alloc] initWithNibName:@"BBSReplyView" bundle:nil];
    samplePopupViewController.parentView = self;
    samplePopupViewController.noticStr = Notification_RefreshBBS;
    samplePopupViewController.type = [NSNumber numberWithInt:1];
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
    userId = [NSString stringWithFormat:@"%i",[[UserModel Instance] getUserInfo].id];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    allCount = 0;
    [_refreshHeaderView refreshLastUpdatedDate];
    self.view.backgroundColor = [Tool getBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData) name:Notification_RefreshBBS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableDataAll) name:Notification_ADDBBS object:nil];
}


- (void)refreshTableData
{
    showBBSBtn.bbs.isShowMenu = NO;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:showBBSBtn.indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    showBBSBtn = nil;
}

- (void)refreshTableDataAll
{
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    isLoading = NO;
    isLoadOver= NO;
    [self reload:YES];
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
    allCount = 0;
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
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver)
        {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount / 20 + 1;
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&cid=%i&p=%i", api_base_url, api_bbslist, api_key, self.commData.id, pageIndex];
        
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient] getPath:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try {
                isLoading = NO;
                if (!noRefresh)
                {
                    [self clear];
                }
                bbsArray = [Tool readJsonStrToBBSArray:operation.responseString];
                int count = [bbsArray count];
                allCount += count;
                if (count < 20) {
                    isLoadOver = YES;
                }
                [self.tableView reloadData];
                [self doneLoadingTableViewData];
            }
            @catch (NSException *exception) {
                [NdUncaughtExceptionHandler TakeException:exception];
            }
            @finally {
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
    if(showBBSBtn)
    {
        showBBSBtn.bbs.isShowMenu = NO;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:showBBSBtn.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        showBBSBtn = nil;
    }
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
    if (iconDownloader == nil)
    {
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
        int height = 211 + bbs.contentHeight - 33 + bbs.replyHeight - 42;
        if ([bbs.thumb count] == 0)
        {
            height -= 62;
        }
        else
        {
            int size = bbs.thumb.count / 3;
            if(bbs.thumb.count % 3 == 0)
            {
                size -= 1;
            }
            if(size < 1)
                size = 0;
            
            int thumbExtraHeight = size * 62;
            height += thumbExtraHeight;
        }
        if (bbs.replysStr != nil && [bbs.replysStr isEqualToString:@""] == YES)
        {
            height -= 22;
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
            BBSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSTableCell"];
            if (!cell)
            {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BBSTableCell" owner:self options:nil];
                for (NSObject *o in objects)
                {
                    if ([o isKindOfClass:[BBSTableCell class]])
                    {
                        cell = (BBSTableCell *)o;
                        break;
                    }
                }
            }
            BBSModel *bbs = [bbsArray objectAtIndex:[indexPath row]];
            cell.navigationController = self.navigationController;
            //内容
            cell.contentLb.text = bbs.content;
            CGRect contentLb = cell.contentLb.frame;
            cell.contentLb.frame = CGRectMake(contentLb.origin.x, contentLb.origin.y, contentLb.size.width, bbs.contentHeight -10);
            if ([bbs.thumb count] > 0)
            {
                cell.imgCollectionView.hidden = NO;
                double size = bbs.thumb.count / 3;
                if(bbs.thumb.count % 3 == 0)
                {
                    size -= 1;
                }
                if(size < 1)
                    size = 0;
                int thumbHeight = 62;
                thumbHeight += size * 62;
                cell.imgCollectionView.frame = CGRectMake(cell.imgCollectionView.frame.origin.x, cell.contentLb.frame.origin.y + cell.contentLb.frame.size.height, cell.imgCollectionView.frame.size.width, thumbHeight);
                
                cell.timeView.frame = CGRectMake(cell.timeView.frame .origin.x, cell.imgCollectionView.frame.origin.y + cell.imgCollectionView.frame.size.height + 2, cell.timeView.frame.size.width, cell.timeView.frame.size.height);
                
                cell.imgArray = bbs.thumb;
                
                [cell.imgCollectionView reloadData];
            }
            else
            {
                cell.imgCollectionView.hidden = YES;
                cell.timeView.frame = CGRectMake(cell.timeView.frame .origin.x, cell.contentLb.frame.origin.y + cell.contentLb.frame.size.height + 2, cell.timeView.frame.size.width, cell.timeView.frame.size.height);
            }
            cell.zan_text_label.frame = CGRectMake(cell.zan_text_label.frame .origin.x, cell.timeView.frame.origin.y + cell.timeView.frame.size.height, cell.zan_text_label.frame.size.width, cell.zan_text_label.frame.size.height);
            
            //评论
            cell.replyLb.attributedText = bbs.reply_str;
            NSString *replysStr = [NSString stringWithString:bbs.reply_str.string];
            if (replysStr != nil && [replysStr isEqualToString:@""] == NO)
            {
                cell.replyLb.frame = CGRectMake(cell.replyLb.frame .origin.x, cell.replyLb.frame.origin.y, cell.replyLb.frame.size.width, bbs.replyHeight -10);
                cell.replyView.frame = CGRectMake(cell.replyView.frame .origin.x, cell.zan_text_label.frame.origin.y + cell.zan_text_label.frame.size.height + 2, cell.replyView.frame.size.width, cell.replyLb.frame.size.height);
                cell.replyView.hidden = NO;
            }
            else
            {
                cell.replyView.hidden = YES;
            }
            //赞
            if(bbs.point_str && bbs.point_str.length > 0)
            {
                cell.zan_text_label.hidden = NO;
                [cell.zan_text_label setTitle:bbs.point_str forState:UIControlStateNormal];
            }
            else
            {
                cell.zan_text_label.hidden = YES;
                cell.replyView.frame = CGRectMake(cell.zan_text_label.frame.origin.x, cell.zan_text_label.frame.origin.y, cell.replyView.frame.size.width, cell.replyView.frame.size.height);
            }
            //时间
            cell.timeLb.text = bbs.timeStr;
            NSString *nickname = @"匿名用户";
            if (bbs.nickname != nil && [bbs.nickname isEqualToString:@""] == NO)
            {
                nickname = bbs.nickname;
            }
            else if (bbs.nickname != nil && [bbs.name isEqualToString:@""] == NO)
            {
                nickname = bbs.name;
            }
            //昵称
            cell.nickNameLb.text = nickname;
            
            //评论按钮
            [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.replyBtn.bbs = bbs;
            cell.replyBtn.indexPath = indexPath;
            
            [cell.zanBtn addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.pinglunBtn addTarget:self action:@selector(pinglunAction:) forControlEvents:UIControlEventTouchUpInside];
            if(bbs.isShowMenu)
            {
                cell.popView.hidden = NO;
            }
            else
            {
                cell.popView.hidden = YES;
            }
            
            //删除按钮
            if (bbs.customer_id != nil && [userId isEqualToString:bbs.customer_id])
            {
                cell.delBtn.hidden = NO;
            }
            else
            {
                cell.delBtn.hidden = YES;
            }
            [cell.delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.delBtn.tag = [indexPath row];
            
            //头像
            if (bbs.imgData) {
                cell.facePic.image = bbs.imgData;
            }
            else
            {
                if ([bbs.avatar isEqualToString:@""]) {
                    bbs.imgData = [UIImage imageNamed:@"userface"];
                }
                else
                {
                    NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:bbs.avatar]];
                    if (imageData)
                    {
                        bbs.imgData = [UIImage imageWithData:imageData];
                        cell.facePic.image = bbs.imgData;
                    }
                    else
                    {
                        IconDownloader *downloader = [_imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d", [indexPath row]]];
                        if (downloader == nil) {
                            ImgRecord *record = [ImgRecord new];
                            record.url = bbs.avatar;
                            [self startIconDownload:record forIndexPath:indexPath];
                        }
                    }
                }
            }
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

- (void)replyAction:(id)sender
{
    BBSButton *button = (BBSButton *)sender;
    button.bbs.isShowMenu = !button.bbs.isShowMenu;
    if(showBBSBtn && showBBSBtn.indexPath.row != button.indexPath.row)
    {
        showBBSBtn.bbs.isShowMenu = NO;
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:button.indexPath,showBBSBtn.indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        showBBSBtn = button;
    }
    else
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:button.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        showBBSBtn = button;
    }
}

#pragma mark 点赞事件
- (void)zanAction:(id)sender
{
    if([UserModel Instance].isNetworkRunning)
    {
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_points];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setPostValue:api_key forKey:@"APPKey"];
        [request setPostValue:showBBSBtn.bbs.id forKey:@"id"];
        [request setPostValue:[NSString stringWithFormat:@"%i",userInfo.id] forKey:@"userid"];
        [request setPostValue:@"shequgj" forKey:@"model"];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        [request startAsynchronous];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"正在点赞" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    
    [Tool showCustomHUD:@"点赞失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSLog(@"the status:%@",request.responseString);
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"点赞成功" andView:self.view andImage:nil andAfterDelay:1.2];
        showBBSBtn.bbs.isShowMenu = NO;
//        NSMutableArray *points = [NSMutableArray arrayWithArray:showBBSBtn.bbs.points_list];
        
        
        BBSModel *bbs = [bbsArray objectAtIndex:[showBBSBtn.indexPath row]];
        NSMutableArray *points = [NSMutableArray arrayWithArray:bbs.points_list];
        
        BBSPoint *point = [[BBSPoint alloc] init];
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        if(userInfo.nickname)
        {
            point.nickname = userInfo.nickname;
            [points addObject:point];
            bbs.points_list = points;
            if (!bbs.point_str) {
                bbs.point_str = [[NSMutableString alloc] init];
                [bbs.point_str appendString:point.nickname];
            }
            else
            {
                [bbs.point_str appendString:[NSString stringWithFormat:@",%@", point.nickname]];
            }
        }
        
        [self.tableView reloadData];
        showBBSBtn = nil;
    }
    else if(status.intValue == 2)
    {
        [Tool showCustomHUD:@"不能重复点赞" andView:self.view andImage:nil andAfterDelay:1.2];
        showBBSBtn.bbs.isShowMenu = NO;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:showBBSBtn.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        showBBSBtn = nil;
    }
    else
    {
        [Tool showCustomHUD:@"点赞失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

- (void)pinglunAction:(id)sender
{
    samplePopupViewController.bbs = showBBSBtn.bbs;
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void)
    {
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
