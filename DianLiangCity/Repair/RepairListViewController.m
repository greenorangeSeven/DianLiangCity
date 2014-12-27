//
//  RepairListViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-30.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "RepairListViewController.h"
#import "RepairListCell.h"

@interface RepairListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int showIndex;
    BaoXius *myBaoXius;
    NSMutableArray *baoXius;
}

@property (nonatomic, strong)NSMutableArray *repairArray;

@end

@implementation RepairListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(toBaoxiu) title:@"报修"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    showIndex = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.segment.selectedSegmentIndex = showIndex;
    [self initMyRepairs];
}

- (void)toBaoxiu
{
    [self performSegueWithIdentifier:@"newRepair" sender:self];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initMyRepairs
{
    UserModel *userMode = [UserModel Instance];
    if(userMode.isNetworkRunning)
    {
        UserInfo *userInfo = [userMode getUserInfo];
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%i&cid=%i",api_base_url,api_my_baoxiu_list,api_key,userInfo.id,self.commData.id];
        
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
    [Tool showCustomHUD:@"列表加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
    if(baoXius)
    {
        [baoXius removeAllObjects];
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    myBaoXius = [Tool readJsonStrToBaoXius:request.responseString];
    baoXius = [[NSMutableArray alloc] init];
    if(showIndex == 0)
    {
        [baoXius addObjectsFromArray:myBaoXius.no];
        [baoXius addObjectsFromArray:myBaoXius.yes];
    }
    else if(showIndex == 1)
    {
        [baoXius addObjectsFromArray:myBaoXius.yes];
    }
    else if(showIndex == 2)
    {
        [baoXius addObjectsFromArray:myBaoXius.no];
    }
    [self.tableView reloadData];
}

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    showIndex = segment.selectedSegmentIndex;
    [baoXius removeAllObjects];
    switch (showIndex)
    {
        case 0:
            [baoXius addObjectsFromArray:myBaoXius.no];
            [baoXius addObjectsFromArray:myBaoXius.yes];
            break;
        case 1:
            [baoXius addObjectsFromArray:myBaoXius.yes];
            break;
        case 2:
            [baoXius addObjectsFromArray:myBaoXius.no];
            break;
    }
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return baoXius.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RepairListCell *repairCell = [tableView dequeueReusableCellWithIdentifier:@"RepairListCell"];
    if(!repairCell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairListCell" owner:self options:nil];
        for(NSObject *o in objects)
        {
            if([o isKindOfClass:[RepairListCell class]])
            {
                repairCell = (RepairListCell *)o;
                break;
            }
        }
    }
    BaoXiuCase *baoxiuCase = [baoXius objectAtIndex:indexPath.row];
    [repairCell bindData:baoxiuCase];
    return repairCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"RepairDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"newRepair"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:self.commData forKey:@"commData"];
    }
    else if([segue.identifier isEqualToString:@"RepairDetailSegue"])
    {
        BaoXiuCase *cases = [baoXius objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:cases.order_no forKey:@"order_no"];
    }
}
@end
