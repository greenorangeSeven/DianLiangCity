//
//  BindSecondViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "BindSecondViewController.h"
#import "BindThirdViewController.h"

@interface BindSecondViewController ()

@property (strong, nonatomic) NSArray *bindArray;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation BindSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(nextAction:) title:@"下一步"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.bindArray = @[@"工商银行 储蓄卡", @"中国银行 储蓄卡", @"建设银行 储蓄卡", @"农业银行 储蓄卡"];
}

-(void)nextAction:(id)sender
{
    BindThirdViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"BindThirdViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (IBAction)choiseBindAction:(id)sender
{
    self.tableView.hidden = NO;
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [self.bindArray objectAtIndex:indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.bindTextField.text = newCell.textLabel.text;
    self.lastIndexPath = indexPath;
    tableView.hidden = YES;

}
@end
