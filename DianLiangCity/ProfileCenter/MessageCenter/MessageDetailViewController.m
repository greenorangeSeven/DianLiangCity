//
//  MessageDetailViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "BackButton.h"

@interface MessageDetailViewController ()

@property(nonatomic,strong)NSMutableArray *messageArray;
@property(nonatomic,strong)NSString *messageStr;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];

    self.messageView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 108, 320, 44);
    [self.view addSubview:self.messageView];
    
    self.messageArray = [NSMutableArray arrayWithObjects:@"cell_1", @"cell_2", @"cell_3", @"cell_4", @"cell_5",nil];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (IBAction)sendAction:(id)sender
{
    self.messageStr = self.messageTextField.text;
    self.messageTextField.text = @"";
    [self.messageTextField resignFirstResponder];
    [self.messageArray addObject:@"cell_3"];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.messageArray objectAtIndex:indexPath.row]];
    if (indexPath.row == 5)
    {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = self.messageStr;
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 3) {
        return 58;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
