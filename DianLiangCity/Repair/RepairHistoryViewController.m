//
//  RepairHistoryViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "RepairHistoryViewController.h"
#import "AppDelegate.h"
#import "BackButton.h"
#import "RepairThumbCell.h"
#import "RepairProgressCell.h"
#import "BaoxiuPro.h"
#import "AMRatingControl.h"

@interface RepairHistoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BaoXiuInfo *baoxiuInfo;
    NSString *rateValue;
}
@end

@implementation RepairHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.weixiu_img_collection.dataSource = self;
    self.weixiu_img_collection.delegate = self;
    self.progress_tableView.dataSource = self;
    self.progress_tableView.delegate = self;
    [self.weixiu_img_collection registerClass:[RepairThumbCell class] forCellWithReuseIdentifier:@"RepairThumbCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadRepairDetail];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadRepairDetail
{
    UserModel *userMode = [UserModel Instance];
    if(userMode.isNetworkRunning)
    {
        UserInfo *userInfo = [userMode getUserInfo];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%i&order_no=%@",api_base_url,api_get_baoxiu_info,api_key,userInfo.id,self.order_no];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    baoxiuInfo = [Tool readJsonStrToBaoXiuInfo:request.responseString];
    [self initBaoXiuInfo];
}

- (void)initBaoXiuInfo
{
    self.order_no_label.text = [NSString stringWithFormat:@"【%@】",baoxiuInfo.order_no];
    self.summary_label.text = baoxiuInfo.remark;
    //判断当前报修的程度
    if(baoxiuInfo.status >= 1)
    {
        [self.baoxiulabel setTextColor:[UIColor colorWithRed:0.97 green:0.45 blue:0 alpha:1]];
        [self.baoxiuImg setImage:[UIImage imageNamed:@"repair_dot_h"]];
    }
    if(baoxiuInfo.status >= 2)
    {
        [self.paigonglabel setTextColor:[UIColor colorWithRed:0.97 green:0.45 blue:0 alpha:1]];
        [self.paigongImg setImage:[UIImage imageNamed:@"repair_dot_h"]];
        [self.paigongProImg setImage:[UIImage imageNamed:@"repair_line_h"]];
    }
    if(baoxiuInfo.status >= 3)
    {
        [self.weixiulabel setTextColor:[UIColor colorWithRed:0.97 green:0.45 blue:0 alpha:1]];
        [self.weixiuImg setImage:[UIImage imageNamed:@"repair_dot_h"]];
        [self.weixiuProImg setImage:[UIImage imageNamed:@"repair_line_h"]];
    }
    if(baoxiuInfo.status >= 4)
    {
        [self.pingjialabel setTextColor:[UIColor colorWithRed:0.97 green:0.45 blue:0 alpha:1]];
        [self.pingjiaImg setImage:[UIImage imageNamed:@"repair_dot_h"]];
        [self.pingjiaProImg setImage:[UIImage imageNamed:@"repair_line_h"]];
    }
    
    //判断是否存在报修图片
    if(baoxiuInfo.thumb && baoxiuInfo.thumb.count > 0)
    {
        [self.weixiu_img_collection reloadData];
    }
    else
    {
        //没有维修图片则缩减高度
        self.summary_view.frame = CGRectMake(self.summary_view.frame.origin.x, self.summary_view.frame.origin.y, self.summary_view.frame.size.width, self.summary_view.frame.size.height - self.weixiu_img_collection.frame.size.height);
        
        self.progress_view.frame = CGRectMake(self.progress_view.frame.origin.x, self.summary_view.frame.origin.y + self.summary_view.frame.size.height + 6, self.progress_view.frame.size.width, self.progress_view.frame.size.height);
    }
    
    if(baoxiuInfo.baoxiu_process && baoxiuInfo.baoxiu_process.count > 0)
    {
        int height = (baoxiuInfo.baoxiu_process.count - 1) * 81;
        self.progress_view.frame = CGRectMake(self.progress_view.frame.origin.x, self.progress_view.frame.origin.y, self.progress_view.frame.size.width, self.progress_view.frame.size.height + height);
        self.progress_tableView.frame = CGRectMake(self.progress_tableView.frame.origin.x, self.progress_tableView.frame.origin.y, self.progress_tableView.frame.size.width, self.progress_tableView.frame.size.height + height);
        [self.progress_tableView reloadData];
        self.progress_none_label.hidden = YES;
    }
    else
    {
        self.progress_none_label.hidden = NO;
    }
    
    self.cailiao_view.frame = CGRectMake(self.cailiao_view.frame.origin.x, self.progress_view.frame.origin.y + self.progress_view.frame.size.height + 6, self.cailiao_view.frame.size.width, self.cailiao_view.frame.size.height);
    if(baoxiuInfo.weixiu_cailiao.length > 0)
    {
        self.weixiu_cailiao_label.text = baoxiuInfo.weixiu_cailiao;
        self.weixiu_time_label.text = [Tool TimestampToDateStr:baoxiuInfo.weixiu_time andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        self.cailiao_cost_label.text = [NSString stringWithFormat:@"￥%@",baoxiuInfo.weixiu_cost];
    }
    else
    {
        CGRect frame = self.weixiu_cailiao_label.frame;
        frame.size.width = self.view.frame.size.width;
        self.weixiu_cailiao_label.frame = frame;
        self.weixiu_cailiao_label.textAlignment = UITextAlignmentCenter;
        self.weixiu_cailiao_label.text = @"无材料";
    }
    
    self.commment_view.frame = CGRectMake(self.commment_view.frame.origin.x, self.cailiao_view.frame.origin.y + self.cailiao_view.frame.size.height + 6, self.commment_view.frame.size.width, self.commment_view.frame.size.height);
    
    if(baoxiuInfo.comment.length > 0)
    {
        self.comment_label.text = baoxiuInfo.comment;
    }
    else
    {
        self.comment_label.text = @"还未评价";
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.commment_view.frame.origin.y + self.commment_view.frame.size.height + 6);

    UIImage *dot, *star;
    dot = [UIImage imageNamed:@"star.png"];
    star = [UIImage imageNamed:@"star_h.png"];
    
    //星级评价
    AMRatingControl *gradeControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0) emptyImage:dot solidImage:star andMaxRating:5];
    
    [gradeControl setRating:baoxiuInfo.rate_total];
    [self.rating_label addSubview:gradeControl];
}

- (IBAction)toComm:(UIButton *)sender
{
    if(baoxiuInfo.status == 3)
    {
        [self performSegueWithIdentifier:@"AssessViewController" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AssessViewController"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:baoxiuInfo.order_no forKey:@"order_no"];
    }
}

#pragma mark - 报修图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return baoxiuInfo.thumb.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RepairThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RepairThumbCell" forIndexPath:indexPath];
    if (!cell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairThumbCell" owner:self options:nil];
        for (NSObject *o in objects)
        {
            if ([o isKindOfClass:[RepairThumbCell class]])
            {
                cell = (RepairThumbCell *)o;
                break;
            }
        }
    }
    
    NSString *img = [baoxiuInfo.thumb objectAtIndex:[indexPath row]];
    [cell bindImg:img];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 处理过程列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return baoxiuInfo.baoxiu_process.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairProgressCell"];
    if(!cell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairProgressCell" owner:self options:nil];
        for (NSObject *o in objects)
        {
            if ([o isKindOfClass:[RepairProgressCell class]])
            {
                cell = (RepairProgressCell *)o;
                break;
            }
        }
    }
    
    BaoxiuPro *pro = [baoxiuInfo.baoxiu_process objectAtIndex:indexPath.row];
    [cell bindData:pro];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
