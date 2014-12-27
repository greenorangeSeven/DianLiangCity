//
//  TTPopoverView.m
//  EBCCard
//
//  Created by Ma Jianglin on 3/11/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTPopoverView.h"

@interface TTPopoverView()

@property(nonatomic, strong) UIButton *backgroundButton;

@end

@implementation TTPopoverView

- (void)popoverFromView:(UIView*)view
{
    if (self.backgroundButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [button addTarget:self action:@selector(dismissModalView) forControlEvents:UIControlEventTouchDown];
        self.backgroundButton = button;
    }
    
    CGRect rect = view.bounds;
    rect.origin.y = 44;
    rect.size.height -= 44;
    self.backgroundButton.frame = rect;
    self.backgroundButton.alpha = 0;
    self.alpha = 0;
    [view addSubview:self.backgroundButton];
    [view addSubview:self];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.backgroundButton.alpha = 1;
                         self.alpha = 1;
                     }];
}

- (void)dismissModalView
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.alpha = 0;
                         self.backgroundButton.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.backgroundButton removeFromSuperview];
                     }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
