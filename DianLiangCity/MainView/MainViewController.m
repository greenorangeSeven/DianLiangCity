//
//  MainViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MainViewController.h"
#import "UserModel.h"
#import "Community.h"
#import "MyCommCell.h"
#import "AreaMainViewController.h"
#import "ChoiseProViewController.h"
#import "SystemInformCell.h"
#import "LoginViewController.h"
#import "ProfileCenterViewController.h"
#import "XGPush.h"

@interface MainViewController () <SGFocusImageFrameDelegate, UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *hud;
    
    //首页广告集合
    NSMutableArray *advDatas;
    //当前选中的广告
    Advertisement *currentAdv;
    //轮播图控件
    SGFocusImageFrame *bannerView;
    //当前显示的广告索引
    int advIndex;
    
    //我的认证社区
    NSMutableArray *commDatas;
    //当前选中的社区
    Community *currentChooseComm;
    
    //系统通知集合
    NSMutableArray *sysInfos;
    //当前选中的系统信息
    SystemInform *currentSysInfo;
}
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[UserModel Instance] isLogin])
    {
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(goLogin:) image:@"personInfo"];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(goLogin:) title:@"登录"];
    }
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[MyCommCell class] forCellWithReuseIdentifier:@"myCommCell"];
    
    self.noticTableView.dataSource = self;
    self.noticTableView.delegate = self;
    
    //让tableView不显示分割线
    self.noticTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    [self initMainADV];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyCommunity) name:@"reloadMyComm" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logined) name:@"logined" object:nil];
}

- (void)goLogin:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"登录"])
    {
        LoginViewController *manager = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        if ([manager respondsToSelector:@selector(setDelegate:)])
        {
            [manager setValue:self forKey:@"delegate"];
        }
        [self.navigationController pushViewController:manager animated:YES];
    }
    else
    {
        ProfileCenterViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileCenterViewController"];
        
        [self.navigationController pushViewController:manager animated:YES];
    }
}

//登录成功回调方法
- (void)logined
{
    if([[UserModel Instance] isLogin])
    {
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(goLogin:) image:@"personInfo"];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(goLogin:) title:@"登录"];
    }
    commDatas = nil;
    [self initMyCommunity];
}

- (void)reloadMyCommunity
{
    commDatas = nil;
    EGOCache *cache = [EGOCache globalCache];
    if([[UserModel Instance] isLogin])
    {
        UserInfo *info = [[UserModel Instance] getUserInfo];
        NSString *name = [NSString stringWithFormat:@"mycommunity%i",info.id];
        commDatas = (NSMutableArray *)[cache objectForKey:name];
    }
    if(commDatas == nil)
        commDatas = [[NSMutableArray alloc] init];
    [commDatas addObjectsFromArray:(NSArray *)[cache objectForKey:@"mycommunity-1"]];
    if(!commDatas)
        commDatas = [[NSMutableArray alloc] init];
    Community *comm = [[Community alloc] init];
    comm.id = -1;
    [commDatas addObject:comm];
    [self.collectionView reloadData];
    [self reSizeMyCommPlan];
    [self reSizeTablePlan];
}

#pragma mark - 首页数据初始化
- (void)initMainADV
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&spaceid=2", api_base_url, api_get_adv, api_key];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           advDatas = [Tool readJsonStrToADV:operation.responseString];

                                           int length = [advDatas count];
                                           NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                           if (length > 1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:length-1];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           for (int i = 0; i < length; i++)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:i];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                               
                                           }
                                           //添加第一张图 用于循环
                                           if (length >1)
                                           {
                                               Advertisement *adv = [advDatas objectAtIndex:0];
                                               SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:adv.pic tag:-1];
                                               [itemArray addObject:item];
                                           }
                                           bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, 320, 165) delegate:self imageItems:itemArray isAuto:YES];
                                           [bannerView scrollToIndex:0];
                                           [self.screenImg addSubview:bannerView];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           [self initMyCommunity];
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

- (void)initMyCommunity
{
    EGOCache *cache = [EGOCache globalCache];
    UserModel *userModel = [UserModel Instance];
    if([userModel isLogin])
    {
        UserInfo *info = [[UserModel Instance] getUserInfo];
        NSString *name = [NSString stringWithFormat:@"mycommunity%i",info.id];
        commDatas = (NSMutableArray *)[cache objectForKey:name];
        if(!commDatas && commDatas.count <= 0)
        {
            [self loadMyCommByBack];
            return;
        }
        userModel.validateComms = commDatas ;
    }
    if(!commDatas)
        commDatas = [[NSMutableArray alloc] init];
    [commDatas addObjectsFromArray:(NSArray *)[cache objectForKey:@"mycommunity-1"]];
    Community *comm = [[Community alloc] init];
    comm.id = -1;
    [commDatas addObject:comm];
    [self.collectionView reloadData];
    [self reSizeMyCommPlan];
    [self initSystemNotify];
}

//从后台加载我的小区信息
- (void)loadMyCommByBack
{
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning && userInfo)
    {
        //Tool showHUD:@"数据加载" andView:self.view andHUD:hud];
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@&userid=%i", api_base_url, api_my_community_list, api_key,userInfo.id];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try
                                       {
                                           EGOCache *cache = [EGOCache globalCache];
                                           commDatas = [Tool readJsonStrToMyComm:operation.responseString];
                                           
                                           if(!commDatas)
                                           {
                                               commDatas = [[NSMutableArray alloc] init];
                                           }
                                           else if(commDatas.count > 0)
                                           {
                                               UserModel *userModel = [UserModel Instance];
                                               userModel.validateComms = commDatas;
                                               NSString *name = [NSString stringWithFormat:@"mycommunity%i",userInfo.id];
                                               [cache setObject:commDatas forKey:name withTimeoutInterval:3600 * 24 * 30];
                                               
                                               for (Community *comm in commDatas) {
                                                   if (comm.id >0) {
                                                       [XGPush setTag:[NSString stringWithFormat:@"%d", comm.id]];
                                                       if ([comm.area length] > 0) {
                                                           [XGPush setTag:[NSString stringWithFormat:@"%d_%@", comm.id, comm.area]];
                                                           if ([comm.build length] > 0) {
                                                               [XGPush setTag:[NSString stringWithFormat:@"%d_%@_%@", comm.id, comm.area, comm.build]];
                                                               if ([comm.units length] > 0) {
                                                                   [XGPush setTag:[NSString stringWithFormat:@"%d_%@_%@_%@", comm.id, comm.area, comm.build, comm.units]];
                                                                   if ([comm.house_number length] > 0) {
                                                                       [XGPush setTag:[NSString stringWithFormat:@"%d_%@_%@_%@_%@", comm.id, comm.area, comm.build, comm.units, comm.house_number]];
                                                                   }
                                                               }
                                                           }
                                                       }
                                                   }
                                                   
                                               }
                                               
                                           }
                                           [commDatas addObjectsFromArray:(NSArray *)[cache objectForKey:@"mycommunity-1"]];
                                           if(!commDatas)
                                               commDatas = [[NSMutableArray alloc] init];
                                           Community *comm = [[Community alloc] init];
                                           comm.id = -1;
                                           [commDatas addObject:comm];
                                           [self.collectionView reloadData];
                                           [self reSizeMyCommPlan];
                                           [self initSystemNotify];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           [self initSystemNotify];
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
    else
    {
        commDatas = [[NSMutableArray alloc] init];
        Community *comm = [[Community alloc] init];
        comm.id = -1;
        [commDatas addObject:comm];
        [self.collectionView reloadData];
        [self reSizeMyCommPlan];
        [self initSystemNotify];
    }
}

- (void)reSizeMyCommPlan
{
    //这里根据小区个数自动调整高度
    int size = (commDatas.count - 1)/4;
    
    int height = size * 90 + 120;
    
    float x = self.myCommPlanView.frame.origin.x;
    float y = self.myCommPlanView.frame.origin.y;
    float width = self.myCommPlanView.frame.size.width;
    //调整面板高度
    self.myCommPlanView.frame = CGRectMake(x, y, width, height);
    
    float xx = self.collectionView.frame.origin.x;
    float yy = self.collectionView.frame.origin.y;
    float wwidth = self.collectionView.frame.size.width;
    
    //调整网格布局高度
    self.collectionView.frame = CGRectMake(xx, yy, wwidth, height-20);
}

//初始化系统通知
- (void)initSystemNotify
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_get_system_notice_top, api_key];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           sysInfos = [Tool readJsonStrToSystemInfo:operation.responseString];
                                           [self.noticTableView reloadData];
                                           [self reSizeTablePlan];
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

- (void)reSizeTablePlan
{
    //这里根据小区个数自动调整高度
    int height = sysInfos.count * 86 + 20;
    if(height == 0)
        height = 100;
    float y = self.myCommPlanView.frame.origin.y + self.myCommPlanView.frame.size.height + 30;
    float width = self.noticPlanView.frame.size.width;
    //调整面板高度
    self.noticPlanView.frame = CGRectMake(0, y, width, height);
    
    float xx = self.noticTableView.frame.origin.x;
    float yy = self.noticTableView.frame.origin.y;
    float wwidth = self.noticTableView.frame.size.width;
    //调整网格布局高度
    self.noticTableView.frame = CGRectMake(xx, yy, wwidth, height-10);
    //动态调整scrollView的高度
    float scrollHeight = self.noticPlanView.frame.origin.y + self.noticPlanView.frame.size.height + 280;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, scrollHeight);
    self.scrollView.hidden = NO;
}

#pragma mark - 轮播图事件处理
//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    currentAdv = (Advertisement *)[advDatas objectAtIndex:advIndex];
    [self performSegueWithIdentifier:@"DetailViewController" sender:self];
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    advIndex = index;
}

#pragma mark - 中间我的小区列表显示函数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return commDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCommCell" forIndexPath:indexPath];
    if (!cell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyCommCell" owner:self options:nil];
        for (NSObject *o in objects)
        {
            if ([o isKindOfClass:[MyCommCell class]])
            {
                cell = (MyCommCell *)o;
                break;
            }
        }
    }
    Community *comm = [commDatas objectAtIndex:[indexPath row]];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commDelete:)];
    longPress.minimumPressDuration = 1.5;
    cell.commLogoImg.tag = indexPath.row;
    [cell.commLogoImg addGestureRecognizer:longPress];
    
    
    [cell bindCommunity:comm];
    return cell;
}

//长按我的社区图片删除该社区
- (void)commDelete:(UILongPressGestureRecognizer*)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        int row = gestureRecognizer.view.tag;
        Community *comm = [commDatas objectAtIndex:row];
        if(comm.id == -1)
            return;
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"是否删除该社区" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alerView.tag = row;
        [alerView show];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        //长按事件结束
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果是点击的删除按钮则删除社区
    if(buttonIndex == 1)
    {
        Community *comm = [commDatas objectAtIndex:alertView.tag];
        if(comm.customer_pro == 1)
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"户主不能被删除！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alerView show];
            return;
        }
        [commDatas removeObjectAtIndex:alertView.tag];
        EGOCache *cache = [EGOCache globalCache];
        NSMutableArray *comms = [[NSMutableArray alloc] initWithArray:commDatas];
        [comms removeObjectsAtIndexes:[[NSIndexSet alloc] initWithIndex:comms.count - 1]];
        [cache setObject:comms forKey:@"mycommunity-1"];
        [self.collectionView reloadData];
        [self reSizeMyCommPlan];
        [self reSizeTablePlan];
    }
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
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


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int indexRow = [indexPath row];
    currentChooseComm = [commDatas objectAtIndex:indexRow];
    if(currentChooseComm.id == -1)
    {
        ChoiseProViewController *manager = [[UIStoryboard storyboardWithName:@"AddCommunity" bundle:nil] instantiateViewControllerWithIdentifier:@"ChoiseProViewController"];
        [self.navigationController pushViewController:manager animated:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"AreaMainViewController" sender:self];
    }
}

#pragma mark - tableView的数据源适配方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sysInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemInformCell *sysCell = [tableView dequeueReusableCellWithIdentifier:@"SystemInformCell"];
    if(!sysCell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SystemInformCell" owner:self options:nil];
        for(NSObject *o in objects)
        {
            if([o isKindOfClass:[SystemInformCell class]])
            {
                sysCell = (SystemInformCell *)o;
                break;
            }
        }
    }

    SystemInform *form = [sysInfos objectAtIndex:indexPath.row];
    [sysCell bindData:form];
    return sysCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentSysInfo = [sysInfos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"DetailViewController" sender:self];
}
#pragma mark - 当使用segue跳转页面时会先调用该方法,这里进行传值操作
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AreaMainViewController"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:currentChooseComm forKey:@"commData"];
        
    }
    else if([segue.identifier isEqualToString:@"DetailViewController"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:currentAdv forKey:@"adv"];
        [controller setValue:currentSysInfo forKey:@"sysInfo"];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
