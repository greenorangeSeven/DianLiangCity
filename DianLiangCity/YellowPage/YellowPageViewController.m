//
//  YellowPageViewController.m
//  DelightCity
//
//  Created by totem on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "YellowPageViewController.h"
#import "SMPageControl.h"
#import "BackButton.h"


#define KSCROLLVIEW_WIDTH [UIScreen mainScreen].applicationFrame.size.width

@interface YellowPageViewController ()
{
    int selectIndex;
}
@end

@implementation YellowPageViewController

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    for(UIView *view in self.mainView.subviews)
    {
        [view removeFromSuperview];
    }
    switch (segment.selectedSegmentIndex)
    {
        case 0:
            selectIndex = 0;
            [self.mainView addSubview:self.commSummaryView.view];
            break;
        case 1:
            selectIndex = 1;
            self.commNewView.type_id = 1;
            self.commNewView.isLoadOver = NO;
            [self.commNewView reload:NO];
            [self.mainView addSubview:self.commNewView.view];
            break;
        case 2:
            selectIndex = 2;
            self.commNewView.type_id = 2;
            self.commNewView.isLoadOver = NO;
            [self.commNewView reload:NO];
            [self.mainView addSubview:self.commNewView.view];
            break;
        case 3:
            selectIndex = 3;
            [self.mainView addSubview:self.commHotlineView.view];
            break;
    }
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    self.commSummaryView = [[CommSummaryView alloc] init];
    self.commSummaryView.commData = self.commData;
    self.commSummaryView.mainView = self.view;
    [self addChildViewController:self.commSummaryView];
    
    self.commNewView = [[CommNewView alloc] init];
    self.commNewView.commData = self.commData;
    self.commNewView.mainView = self.view;
    [self addChildViewController:self.commNewView];
    
    self.commHotlineView = [[CommHotlineView alloc] init];
    self.commHotlineView.commData = self.commData;
    self.commHotlineView.mainView = self.view;
    
    [self addChildViewController:self.commHotlineView];
}

- (void)viewDidAppear:(BOOL)animated
{
    switch (selectIndex) {
        case 0:
            [self.mainView addSubview:self.commSummaryView.view];
            break;
            
        case 1:
            self.commNewView.type_id = 1;
            [self.mainView addSubview:self.commNewView.view];
            break;
        case 2:
            self.commNewView.type_id = 2;
            [self.mainView addSubview:self.commNewView.view];
            break;
        case 3:
            [self.mainView addSubview:self.commHotlineView.view];
            break;
    }
    
}
@end
