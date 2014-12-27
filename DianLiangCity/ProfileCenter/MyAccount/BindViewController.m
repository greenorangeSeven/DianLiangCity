//
//  BindViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-10.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "BindViewController.h"
#import "BindSecondViewController.h"
@interface BindViewController ()

@end

@implementation BindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(nextAction:) title:@"下一步"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

-(void)nextAction:(id)sender
{
    BindSecondViewController *manager = [[UIStoryboard storyboardWithName:@"ProfileCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"BindSecondViewController"];
    [self.navigationController pushViewController:manager animated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
