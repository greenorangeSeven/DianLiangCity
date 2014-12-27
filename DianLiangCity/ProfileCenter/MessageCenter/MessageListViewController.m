//
//  MessageListViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MessageListViewController.h"
#import "BackButton.h"

@interface MessageListViewController ()

@property (nonatomic, strong)NSMutableArray *messageArray;

@end

@implementation MessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.messageArray = [NSMutableArray arrayWithObjects:@"firstCell", @"secondCell", nil];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.messageArray objectAtIndex:indexPath.row]];
    return cell;
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
        [self.messageArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    
}


@end
