//
//  TTGuideView.m
//  Common
//
//  Created by Wang Yanan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTGuideView.h"
#import "TTPageControl.h"

#define GUIDE_PAGE_WIDTH    320
#define GUIDE_PAGE_COUNT    4

@interface TTGuideView()
{
    BOOL pageControlUsed;
    UIScrollView    *_scrollView;
    TTPageControl   *_pageControl;
}

@end

@implementation TTGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        NSBundle *bundle = [NSBundle mainBundle];
        for (int i = 0; i < GUIDE_PAGE_COUNT; i++)
        {
            UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*GUIDE_PAGE_WIDTH, 0, GUIDE_PAGE_WIDTH, self.bounds.size.height)];
            NSString *imageName = [NSString stringWithFormat:@"guide%i.jpg", i];
            
            NSString *imagePath = [bundle pathForResource:imageName ofType:nil];
            guideImageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
            [_scrollView addSubview:guideImageView];
            if (i == GUIDE_PAGE_COUNT - 1) {
                UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 102, 33)];
                [button setBackgroundImage:[UIImage imageNamed:@"guide_in.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
                button.center = CGPointMake(320*3 + 160, 240);
                [_scrollView addSubview:button];
            }
        }
        
        _scrollView.contentSize = CGSizeMake(GUIDE_PAGE_WIDTH*GUIDE_PAGE_COUNT, 0);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(GUIDE_PAGE_WIDTH*(GUIDE_PAGE_COUNT-1) + 35, 345, 250, 50);
        //button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
        _pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(30, 415, 260, 50)];
        _pageControl.imageNormal = [UIImage imageNamed:@"page_indicator.png"];
        _pageControl.imageCurrent = [UIImage imageNamed:@"page_indicator_h.png"];
        _pageControl.numberOfPages = GUIDE_PAGE_COUNT;
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)enter:(id)sender
{
    [UIView animateWithDuration:0.35
                     animations:
    ^{
        self.alpha = 0.0;
    }
    completion:
    ^(BOOL completed)
    {
        if(completed)
        {
            [self removeFromSuperview];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>GUIDE_PAGE_WIDTH*(GUIDE_PAGE_COUNT-1)+64)
    {
		[self enter:nil];
    }
    else
    {
        if (pageControlUsed)
        {
            return;
        }
        
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

@end
