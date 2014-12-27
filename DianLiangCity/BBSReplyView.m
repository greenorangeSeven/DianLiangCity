//
//  BBSReplyView.m
//  NanNIng
//
//  Created by Seven on 14-9-12.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BBSReplyView.h"

@interface BBSReplyView ()

@end

@implementation BBSReplyView

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
    [Tool roundTextView:self.contentTV andBorderWidth:1 andCornerRadius:3.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender {
    [_parentView dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
}

- (IBAction)publishAction:(id)sender
{
    NSString *contentStr = self.contentTV.text;
    
    if (contentStr == nil || [contentStr length] == 0)
    {
        [Tool showCustomHUD:@"请填写回复内容" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }

    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *updateUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_replybbs];
    //判断是否为业主园地回帖
    if(self.type.intValue == 2)
    {
        updateUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_reply_subject];
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:api_key forKey:@"APPKey"];
    UserModel *userModel = [UserModel Instance];
    UserInfo *userInfo = [userModel getUserInfo];
    [request setPostValue:[NSString stringWithFormat:@"%i",userInfo.id] forKey:@"userid"];
    [request setPostValue:_bbs.id forKey:@"subject_id"];
    [request setPostValue:contentStr forKey:@"reply_content"];

    request.delegate = self;
    request.tag = 11;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在提交..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    UserModel *usermodel = [UserModel Instance];
    UserInfo *userInfo = [usermodel getUserInfo];
    int errorCode = userInfo.status;
    NSString *errorMessage = userInfo.info;
    switch (errorCode) {
        case 1:
        {
//            [Tool showCustomHUD:@"提交成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            
            NSString *rname = @"匿名用户:";
            if ([userInfo.nickname isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", userInfo.nickname];
            }
            else if ([userInfo.name isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", userInfo.name];
            }
            NSString *rcontent = [NSString stringWithFormat:@"%@%@\n", rname, self.contentTV.text];
            NSMutableAttributedString *lien_str = [[NSMutableAttributedString alloc] initWithString:rcontent];
            
            [lien_str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.49 blue:0.89 alpha:1] range:NSMakeRange(0,[rcontent rangeOfString:@":"].location)];
            [_bbs.reply_str appendAttributedString:lien_str];
            int replyHeight = [Tool getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:rcontent];
            _bbs.replyHeight += replyHeight;
//            [_parentView refreshTableData];
            [[NSNotificationCenter defaultCenter] postNotificationName:self.noticStr object:nil];
            [_parentView dismissPopupViewControllerAnimated:YES completion:^{
                NSLog(@"popup view dismissed");
            }];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
        }
            break;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view = nil;
}

@end
