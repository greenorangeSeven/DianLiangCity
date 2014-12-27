//
//  MyBankCardsViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyBankCardsViewController.h"
#import "BackButton.h"
#import "UnBindViewController.h"
#import "BindViewController.h"
@interface MyBankCardsViewController ()
{
    int indexPath;
}
@end

@implementation MyBankCardsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(bindAction:) title:@"绑定"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeStatus:)
                                                 name:@"MyBankCardsViewControllerChangeStatus"
                                               object:nil];
    indexPath = 2;
}

- (void) changeStatus:(NSNotification*) notification
{
    indexPath --;
    [self.tableView reloadData];
}

- (void)dealloc
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

- (void)bindAction:(id)sender
{
    BindViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"BindViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    if (indexPath.row == 1)
    {
        CellIdentifier = @"secondCell";
    }
    DAContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    return cell;
}


#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    UnBindViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"UnBindViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
