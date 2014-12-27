//
//  FamilySetViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "FamilySetViewController.h"
#import "BackButton.h"
#import "FamilAddViewController.h"
#import "FamilyDetailViewController.h"

@interface FamilySetViewController ()

@property (nonatomic, strong) NSMutableArray *familyArray;

@end

@implementation FamilySetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(addAction:) title:@"添加"];
    [self initFamilys];
}

- (void)initFamilys
{
    UserModel *userModel = [UserModel Instance];
    if (userModel.isNetworkRunning && userModel.isLogin)
    {
        
        NSString *url;
        
        url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%i",api_base_url,api_my_familys,api_key,[userModel getUserInfo].id];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.tag = -100;
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
    //如果tag等于1代表当前为加载列表
    if(request.tag == -100)
    {
        [Tool showCustomHUD:@"列表加载失败" andView:self.view andImage:nil andAfterDelay:1.5];
    }
    //如果tag不等于2代表当前为删除家庭成员
    else
    {
        [Tool showCustomHUD:@"删除失败,请重试" andView:self.view andImage:nil andAfterDelay:1.5];
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    if(request.tag == -100)
    {
        self.familyArray = [Tool readJsonStrToFamilys:request.responseString];
    }
    else
    {
        [self.familyArray removeObjectAtIndex:request.tag];
    }
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addAction:(id)sender
{
    FamilAddViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"FamilAddViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (IBAction)deleteAction:(id)sender
{
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.familyArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Family *family = [self.familyArray objectAtIndex:indexPath.row];
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    name.text = family.member_name;
    UILabel *relation = (UILabel *)[cell viewWithTag:2];
    relation.text = family.relations;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"FamilyDetailView" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Family *family = [self.familyArray objectAtIndex:indexPath.row];
        [self deleteFamily:family.id andTheIndex:indexPath.row];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"FamilyDetailView"])
    {
        Family *family = [self.familyArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:family forKey:@"family"];
    }
}

- (IBAction)tableItemDelete:(id)sender
{
}

- (void)deleteFamily:(int)id andTheIndex:(int)index
{
    UserModel *userModel = [UserModel Instance];
    if (userModel.isNetworkRunning && userModel.isLogin)
    {
        
        NSString *url;
        
        url = [NSString stringWithFormat:@"%@%@?APPKey=%@&userid=%i&id=%i",api_base_url,api_remove_familys,api_key,[userModel getUserInfo].id,id];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.tag = index;
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:request.hud];
    }
}

@end
