//
//  UtilityBillsViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-27.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "UtilityBillsViewController.h"
#import "BillCell.h"
#import "BackButton.h"
#import "BillsDetialViewController.h"

@interface UtilityBillsViewController ()
{
    int showIndex;
    MyBill *myBill;
    NSMutableArray *billTypes;
    NSMutableArray *allBills;
    
    int selectRow;
}

@property (strong, nonatomic) DAContextMenuCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) DAOverlayView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;

@end

@implementation UtilityBillsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customEditing = self.customEditingAnimationInProgress = NO;
    
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(showAllBillsAction:) title:@"分类"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.billsClassTableView.delegate = self;
    self.billsClassTableView.dataSource = self;
    self.billsListTableView.delegate = self;
    self.billsListTableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeStatus:)
                                                 name:@"UtilityBillsViewControllerChangeStatus"
                                               object:nil];
    [self initBillType];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initBillType
{
    if([UserModel Instance].isNetworkRunning)
    {
        NSString *url = [NSString stringWithFormat:@"%@%@?APPKey=%@&cid=%i",api_base_url,api_get_bill_items,api_key,self.commData.id];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestBillTypeOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载账单类型" andView:self.view andHUD:request.hud];
    }
}

- (void)initMyBills:(NSString *)type
{
    UserModel *userMode = [UserModel Instance];
    UserInfo *userInfo = [userMode getUserInfo];
    if(userMode.isNetworkRunning)
    {
        NSString *url;
        if(type && ![type isEqualToString:@"全部"])
        {
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&mobile=%@&type=%@",api_base_url,api_get_my_bills,api_key,userInfo.tel,type];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@%@?APPKey=%@&mobile=%@",api_base_url,api_get_my_bills,api_key,userInfo.tel];
        }
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestMyBillOK:)];
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
    if(allBills)
    {
        [allBills removeAllObjects];
        [self.billsListTableView reloadData];
    }
}

- (void)requestMyBillOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    myBill = [Tool readJsonStrToMyBill:request.responseString];
    allBills = [[NSMutableArray alloc] init];
    [allBills addObjectsFromArray:myBill.nopay];
    [allBills addObjectsFromArray:myBill.pay];
    [allBills addObjectsFromArray:myBill.other];
    [self.billsListTableView reloadData];
}

- (void)requestBillTypeOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    billTypes = [[NSMutableArray alloc] init];
    [billTypes addObject:@"全部"];
    [billTypes addObjectsFromArray:[Tool readJsonStrToBillType:request.responseString]];
    [self initMyBills:nil];
    [self.billsClassTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) changeStatus:(NSNotification*) notification
{
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    showIndex = segment.selectedSegmentIndex;
    [self billsStatus];
}

-(void)showAllBillsAction:(id)sender
{
    self.billsClassTableView.hidden = NO;
}

-(void)billsStatus
{
    [allBills removeAllObjects];
    switch (showIndex)
    {
        case 0:
            [allBills addObjectsFromArray:myBill.nopay];
            [allBills addObjectsFromArray:myBill.pay];
            [allBills addObjectsFromArray:myBill.other];
            break;
        case 1:
            [allBills addObjectsFromArray:myBill.pay];
            break;
        case 2:
            [allBills addObjectsFromArray:myBill.nopay];
            break;
        case 3:
            [allBills addObjectsFromArray:myBill.other];
            break;
    }
    [self.billsListTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.billsClassTableView)
    {
        return billTypes.count;
    }
    return allBills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.billsClassTableView)
    {
        NSString *identifier = @"billsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = [billTypes objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.billsListTableView)
    {
        BillCell *billCell = [tableView dequeueReusableCellWithIdentifier:@"MBillCell"];
        if(!billCell)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BillCell" owner:self options:nil];
            for(NSObject *o in objects)
            {
                if([o isKindOfClass:[BillCell class]])
                {
                    billCell = (BillCell *)o;
                    break;
                }
            }
        }
        Bill *bill = [allBills objectAtIndex:indexPath.row];
        [billCell bindData:bill];
        return billCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.billsClassTableView)
    {
        NSString *type = [billTypes objectAtIndex:indexPath.row];
        self.billsClassTableView.hidden = YES;
        [self initMyBills:type];
    }
    else if(tableView == self.billsListTableView)
    {
        selectRow = [indexPath row];
        [self performSegueWithIdentifier:@"BillsDetialView" sender:self];
    }
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UtilityBillsViewControllerChangeStatus" object:@"已忽略"];
        
    }
}

#pragma mark - Private

- (void)hideMenuOptionsAnimated:(BOOL)animated
{
    __block UtilityBillsViewController *weakSelf = self;
    [self.cellDisplayingMenuOptions setMenuOptionsViewHidden:YES animated:animated completionHandler:^{
        weakSelf.customEditing = NO;
    }];
}

- (void)setCustomEditing:(BOOL)customEditing
{
    if (_customEditing != customEditing) {
        _customEditing = customEditing;
        self.billsListTableView.scrollEnabled = !customEditing;
        if (customEditing) {
            if (!_overlayView) {
                _overlayView = [[DAOverlayView alloc] initWithFrame:self.billsListTableView.bounds];
                _overlayView.backgroundColor = [UIColor clearColor];
                _overlayView.delegate = self;
            }
            self.overlayView.frame = self.billsListTableView.bounds;
            [self.billsListTableView addSubview:_overlayView];
            if (self.shouldDisableUserInteractionWhileEditing) {
                for (UIView *view in self.billsListTableView.subviews) {
                    if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                        view.userInteractionEnabled = NO;
                    }
                }
            }
        } else {
            self.cellDisplayingMenuOptions = nil;
            [self.overlayView removeFromSuperview];
            for (UIView *view in self.billsListTableView.subviews) {
                if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                    view.userInteractionEnabled = YES;
                }
            }
        }
    }
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuDidHideInCell:(DAContextMenuCell *)cell
{
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuDidShowInCell:(DAContextMenuCell *)cell
{
    self.cellDisplayingMenuOptions = cell;
    self.customEditing = YES;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuWillHideInCell:(DAContextMenuCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuWillShowInCell:(DAContextMenuCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(DAContextMenuCell *)cell
{
    return self.customEditing && !self.customEditingAnimationInProgress;
}

#pragma mark * DAOverlayView delegate

- (UIView *)overlayView:(DAOverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL shouldIterceptTouches = YES;
    CGPoint location = [self.billsListTableView convertPoint:point fromView:view];
    CGRect rect = [self.billsListTableView convertRect:self.cellDisplayingMenuOptions.frame toView:self.billsListTableView];
    shouldIterceptTouches = CGRectContainsPoint(rect, location);
    if (!shouldIterceptTouches) {
        [self hideMenuOptionsAnimated:YES];
    }
    return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
}

#pragma mark * UITableView delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath] == self.cellDisplayingMenuOptions) {
        [self hideMenuOptionsAnimated:YES];
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *statusLabel =  (UILabel *)[cell viewWithTag:4];
    if (![statusLabel.text isEqualToString:@"未支付"])
    {
        return  UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"忽略";
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {
        //[self.billsStatusListArray removeObjectAtIndex:indexPath.row];
        [self.billsListTableView reloadData];
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"BillsDetialView"])
    {
//        NSIndexPath *indexPath = [self.billsListTableView indexPathForSelectedRow];
        Bill *bill = [allBills objectAtIndex:selectRow];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:[NSString stringWithFormat:@"%d", bill.id] forKey:@"billId"];
    }
}
@end
