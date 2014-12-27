//
//  AboutUsViewController.m
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "AboutUsViewController.h"
#import "BackButton.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
