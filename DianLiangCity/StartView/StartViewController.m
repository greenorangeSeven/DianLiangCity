//
//  StartViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "StartViewController.h"
#import "SMPageControl.h"
#import "AppDelegate.h"
@interface StartViewController ()
{
    UIImageView *_imageView;
    NSArray *_permissions;
    int GlobalPageControlNumber;
    
    SMPageControl *_pageControl;
}
@end

@implementation StartViewController

#define KSCROLLVIEW_WIDTH [UIScreen mainScreen].applicationFrame.size.width

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self buildUI];
    [self createScrollView];
}
#pragma mark - privite method
#pragma mark
- (void)buildUI
{
    _pageControl = [[SMPageControl alloc] init];
    _pageControl.frame = CGRectMake(120, (iPhone5?472:384), 100, 37);
    _pageControl.pageIndicatorImage = [UIImage imageNamed:@"pagecontrol"];
    _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pagecontrol_h"];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    [self.view addSubview:_pageControl];
    [self.view bringSubviewToFront:_pageControl];
}
#pragma mark createScrollView
-(void)createScrollView
{
    self.scrollView.delegate=self;
    self.scrollView.contentSize=CGSizeMake(KSCROLLVIEW_WIDTH*5, 0);
    for (int i=0; i<5; i++) {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*KSCROLLVIEW_WIDTH, 0, KSCROLLVIEW_WIDTH, self.scrollView.frame.size.height)];
        NSString *str = [NSString stringWithFormat:@"v引导_%d.png",i+1];
        photoImageView.image=[UIImage imageNamed:str];
        [photoImageView setContentMode:UIViewContentModeTop];
        [self.scrollView addSubview:photoImageView];
    }
}

#pragma mark - scrollView delegate Method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.x >= KSCROLLVIEW_WIDTH*4) {
        scrollView.contentOffset = CGPointMake(KSCROLLVIEW_WIDTH*4, 0);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    GlobalPageControlNumber = scrollView.contentOffset.x/KSCROLLVIEW_WIDTH;
    _pageControl.currentPage=GlobalPageControlNumber;
    if (GlobalPageControlNumber == 4)
    {
        self.intoButton.hidden = NO;
    }
    else
    {
        self.intoButton.hidden = YES;
    }
}

- (IBAction)enterAction:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *controll=[storyBoard instantiateInitialViewController];
    self.intoButton.hidden = YES;
    [UIView transitionWithView:SharedAppDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        SharedAppDelegate.window.rootViewController = controll;
                    }
                    completion:nil];
}
@end
