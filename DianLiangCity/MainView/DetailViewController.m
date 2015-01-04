//
//  DetailViewController.m
//  DianLiangCity
//
//  Created by mac on 14-11-21.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "DetailViewController.h"
#import "BackButton.h"
@interface DetailViewController ()
{
    SystemDetails *details;
    MBProgressHUD *hud;
}

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction) image:@"back_bg"];
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    
    if (!IS_IPHONE_5) {
        self.webView.frame = CGRectMake(0, 0, self.webView.frame.size.width, self.view.frame.size.height);
    }
    
    NSString *html = nil;
    if(self.adv)
    {
        
        html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style, self.adv.title, HTML_Splitline, self.adv.content];
        [self showHtml:html];
    }
    else if(self.sysInfo)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        [self loadSystemDetail];
    }
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
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_get_system_notice_info, api_key,self.sysInfo.id];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           details = [Tool readJsonStrToSystemDetails:operation.responseString];
                                           if(details)
                                           {
                                               NSString *date = [Tool TimestampToDateStr:details.published andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
                                               NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div><div id='web_date'>%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style,details.title,
                                                                 date,HTML_Splitline,details.content];
                                               [self showHtml:html];
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
//    //适配iOS7uinavigationbar遮挡的问题
//    if(IS_IOS7)
//    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
