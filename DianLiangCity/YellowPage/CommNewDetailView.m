//
//  CommNewDetailView.m
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommNewDetailView.h"
#import "BackButton.h"
#import "UIImageView+WebCache.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface CommNewDetailView ()<SGFocusImageFrameDelegate,UIWebViewDelegate>
{
    MBProgressHUD *hud;
    CommNew *commNew;
    //轮播图控件
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@end

@implementation CommNewDetailView


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction) image:@"back_bg"];
    self.navigationItem.title = @"详情";
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    
    [self.webView sizeToFit];
    self.webView.delegate = self;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    [self loadSystemDetail];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadSystemDetail
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%i", api_base_url, api_get_news_info, api_key,self.commId];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           commNew = [Tool readJsonStrToCommNew:operation.responseString];
                                           if(commNew)
                                           {
                                            [self showHtml];
                                            int length = [commNew.piclist count];
                                             if(length <= 0)
                                             {
                                                 self.imgScroller.hidden = YES;
                                                 self.webView.frame = CGRectMake(self.imgScroller.frame.origin.x,self.imgScroller.frame.origin.y , self.webView.frame.size.width, self.webView.frame.size.height);
                                                 return;
                                             }
                                            self.imgScroller.hidden = NO;
                                            NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                               if (length > 1)
                                               {
                                                   SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:commNew.piclist[length-1] tag:-1];
                                                   [itemArray addObject:item];
                                               }
                                               
                                               for (int i = 0; i < length; ++i)
                                               {
                                                   SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:commNew.piclist[i] tag:-1];
                                                   [itemArray addObject:item];
                                               }
                                               
                                               //添加第一张图 用于循环
                                               if (length >1)
                                               {
                                                   SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:commNew.piclist[0] tag:-1];
                                                   [itemArray addObject:item];
                                               }
                                               
                                               bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 165) delegate:self imageItems:itemArray isAuto:YES];
                                               [bannerView scrollToIndex:0];
                                               [self.imgScroller addSubview:bannerView];
                                           }
                                           else
                                           {
                                               [Tool ToastNotification:@"未找到该信息.可能已过期" andView:self.view andLoading:NO andIsBottom:NO];
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

- (void)showHtml
{
    NSString *date = [Tool TimestampToDateStr:commNew.published andFormatterStr:@"   yyyy年MM月dd日 hh:mm"];
    NSString *html;
    if(commNew.source.length == 0)
    {
        html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div><div id='web_date'>%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style,commNew.title,date,HTML_Splitline,commNew.content];
    }
    else
    {
        html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div><div id='web_date'>来源:%@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style,commNew.title,commNew.source,date,HTML_Splitline,commNew.content];
    }
    
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
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, webViewP.frame.origin.y + [webViewScroll contentSize].height + 30);
    
    [webViewP setFrame:CGRectMake(webViewP.frame.origin.x, webViewP.frame.origin.y, webViewP.frame.size.width, [webViewScroll contentSize].height)];
}

- (void)didReceiveMemoryWarning {
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
