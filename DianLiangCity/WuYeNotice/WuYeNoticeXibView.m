//
//  WuYeNoticeXibView.m
//  DianLiangCity
//
//  Created by Seven on 14-12-31.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "WuYeNoticeXibView.h"

@interface WuYeNoticeXibView ()
{
    MBProgressHUD *hud;
    CommNotic *notic;
}

@end

@implementation WuYeNoticeXibView

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"通告详情";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle: @"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeAction)];
    leftBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    [self initNoticDetail];
}

- (void)closeAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)initNoticDetail
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_get_notice_info, api_key,self.noticId];

        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           notic = [Tool readJsonStrToCommNoticDetail:operation.responseString];
                                           if(notic)
                                           {
                                               [self showHtml];
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
    NSString *date = [Tool TimestampToDateStr:notic.published andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
    NSString *html;
    NSString *html_line = HTML_Splitline;
    if(notic.source.length == 0)
    {
        html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div><div id='web_date'>%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style,notic.title,date,html_line,notic.content];
    }
    else
    {
        html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div><div id='web_date'>来源:%@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style,notic.title,notic.source,date,html_line,notic.content];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
