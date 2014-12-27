//
//  MyDianQuanOrHongBaoViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "MyDianQuanOrHongBaoViewController.h"

@interface MyDianQuanOrHongBaoViewController ()
{
    int showIndex;
}
@end

@implementation MyDianQuanOrHongBaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showIndex != 0) {
        return 1;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"firstCell";
    if ([self.title isEqualToString:@"我的点券"])
    {
        if (indexPath.row == 0)
        {
            identifier = @"firstCell";
        }
        else
        {
            identifier = @"secondCell";
        }
        if (showIndex == 1)
        {
            identifier = @"secondCell";
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            identifier = @"thirdCell";
        }
        else
        {
            identifier = @"fourthCell";
        }
        if (showIndex == 1)
        {
            identifier = @"fourthCell";
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    showIndex = segment.selectedSegmentIndex;
    
    [self.tableView reloadData];
}

@end
