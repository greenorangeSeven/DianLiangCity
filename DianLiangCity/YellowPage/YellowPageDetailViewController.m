//
//  YellowPageDetailViewController.m
//  DelightCity
//
//  Created by totem on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "YellowPageDetailViewController.h"
#import "SMPageControl.h"
#import "BackButton.h"

#define KSCROLLVIEW_WIDTH [UIScreen mainScreen].applicationFrame.size.width

@interface YellowPageDetailViewController ()
{
    SMPageControl *_pageControl;
    int GlobalPageControlNumber;
}

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIScrollView *photoScrollView;

@end

@implementation YellowPageDetailViewController


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
    
    self.photoScrollView.contentSize=CGSizeMake(KSCROLLVIEW_WIDTH*3, 0);
    
    self.scrollView.contentSize = CGSizeMake(0, 580);
    
    [self buildUI];
}

- (void)buildUI
{
    _pageControl = [[SMPageControl alloc] init];
    _pageControl.frame = CGRectMake(120, 285, 80, 37);
    _pageControl.pageIndicatorImage = [UIImage imageNamed:@"pagecontrol2"];
    _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pagecontrol2_h"];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    
    [self.scrollView addSubview:_pageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

@end
