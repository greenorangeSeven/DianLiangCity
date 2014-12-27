//
//  UsingHelpInfomationViewController.m
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "UsingHelpInfomationViewController.h"
#import "BackButton.h"

@interface UsingHelpInfomationViewController ()
{
    Helps *details;
    MBProgressHUD *hud;
}
@end

@implementation UsingHelpInfomationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    [self loadHelpDetail];
}

- (void)loadHelpDetail
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&id=%i", api_base_url, api_get_help_info, api_key,self.help.id];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           details = [Tool readJsonStrToHelpDetail:operation.responseString];
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

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
