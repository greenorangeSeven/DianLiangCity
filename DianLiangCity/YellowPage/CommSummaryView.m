//
//  CommSummaryViewViewController.m
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommSummaryView.h"
#import "CommunityInfo.h"
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface CommSummaryView ()<SGFocusImageFrameDelegate,UIWebViewDelegate>
{
    //轮播图控件
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@end

@implementation CommSummaryView

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    self.webView.delegate = self;
    if ([UserModel Instance].isNetworkRunning)
    {
        NSString *ids = [NSString stringWithFormat:@"%i",self.commData.id];
        NSString *regUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url,api_get_community_info,api_key,ids];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regUrl]];
        
        [request setUseCookiePersistence:NO];
        
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载社区简介" andView:self.mainView andHUD:request.hud];
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
    
    CommunityInfo *commInfo = [Tool readJsonStrToCommInfo:request.responseString];
    int length = [commInfo.piclist count];
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:commInfo.piclist[length-1] tag:-1];
        [itemArray addObject:item];
    }
    
    for (int i = 0; i < length; ++i)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:commInfo.piclist[i] tag:-1];
        [itemArray addObject:item];
    }
    
    //添加第一张图 用于循环
    if (length >1)
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:commInfo.piclist[0] tag:-1];
        [itemArray addObject:item];
    }
    
    bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 165) delegate:self imageItems:itemArray isAuto:YES];
    [bannerView scrollToIndex:0];
    [self.imgScroller addSubview:bannerView];
    
    NSString *html = [NSString stringWithFormat:@"<body>%@<div></div><div id='web_body'>%@</div></body>", HTML_Style, commInfo.summary];
    
    [self showHtml:html];
}

#pragma mark - 轮播图事件处理
//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    advIndex = index;
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    NSArray *arr = [webViewP subviews];
    UIScrollView *webViewScroll = [arr objectAtIndex:0];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, webViewP.frame.origin.y + [webViewScroll contentSize].height + 120);
    
    [webViewP setFrame:CGRectMake(webViewP.frame.origin.x, webViewP.frame.origin.y, webViewP.frame.size.width, [webViewScroll contentSize].height)];
}

- (void)showHtml:(NSString *)html
{
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    self.webView.opaque = YES;
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)subView).bounces = YES;
        }
    }
    
    self.view.backgroundColor = [Tool getBackgroundColor];
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
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
