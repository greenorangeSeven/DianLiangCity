//
//  AssessViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "AssessViewController.h"
#import "AMRatingControl.h"

@interface AssessViewController ()
{
    NSString *totalRateValue;
    NSString *serviceRateValue;
    NSString *qualityRateValue;
    NSString *speekRateValue;
}

@end

@implementation AssessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    UIImage *dot, *star;
    dot = [UIImage imageNamed:@"star.png"];
    star = [UIImage imageNamed:@"star_h.png"];
    
    //星级评价
    AMRatingControl *totalControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
    totalControl.tag = 1;
    [totalControl setRating:5];
    [totalControl addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    totalRateValue = @"1";
    
    AMRatingControl *serviceControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
    serviceControl.tag = 2;
    [serviceControl setRating:5];
    [serviceControl addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    serviceRateValue = @"1";
    
    AMRatingControl *qualityControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
    qualityControl.tag = 3;
    [qualityControl setRating:5];
    [qualityControl addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    qualityRateValue = @"1";
    
    AMRatingControl *speekControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
    speekControl.tag = 4;
    [speekControl setRating:5];
    [speekControl addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    speekRateValue = @"1";
    
    [self.total_comm_rating addSubview:totalControl];
    [self.service_rating addSubview:serviceControl];
    [self.quality_rating addSubview:qualityControl];
    [self.speek_rating addSubview:speekControl];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateEndRating:(id)sender
{
    AMRatingControl *control = (AMRatingControl *)sender;
    NSString *rateValue = [NSString stringWithFormat:@"%d", [(AMRatingControl *)sender rating]];
    if(control.tag == 1)
    {
        totalRateValue = rateValue;
    }
    else if(control.tag == 2)
    {
        serviceRateValue = rateValue;
    }
    else if(control.tag == 3)
    {
        qualityRateValue = rateValue;
    }
    else if(control.tag == 4)
    {
        speekRateValue = rateValue;
    }
}

-(void)submitAction:(id)sender
{
    NSString *content = self.comm_content_label.text;
    
    if(content.length <= 0)
    {
        [Tool showCustomHUD:@"请输入评价内容" andView:self.view andImage:nil andAfterDelay:1.2f];
        return;
    }
    
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_comment_baoxiu];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:api_key forKey:@"APPKey"];
    [request setPostValue:content forKey:@"comment"];
    [request setPostValue:self.order_no forKey:@"order_no"];
    [request setPostValue:totalRateValue forKey:@"rate_total"];
    [request setPostValue:speekRateValue forKey:@"rate_speed"];
    [request setPostValue:serviceRateValue forKey:@"rate_service"];
    [request setPostValue:qualityRateValue forKey:@"rate_quality"];
    [request setPostValue:[NSString stringWithFormat:@"%i",userInfo.id] forKey:@"userid"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在提交评价" andView:self.view andHUD:request.hud];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"评价失败" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"评价成功" andView:self.view andImage:nil andAfterDelay:1.2];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"评价失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
