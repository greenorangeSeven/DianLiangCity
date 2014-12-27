//
//  TTGridButton.m
//  EBCCard
//
//  Created by Ma Jianglin on 3/9/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTGridButton.h"

@implementation TTGridButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    TTGridButton *button = [super buttonWithType:buttonType];
    
    UIFont *font = [UIFont systemFontOfSize:12.0];
    UIColor *titleColor = [UIColor colorWithRed:115/255.0 green:109/255.0 blue:100/255.0 alpha:1];
    UIColor *titleColorH = [UIColor blackColor];
    UIColor *shadowColor = [UIColor whiteColor];
    
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColorH forState:UIControlStateHighlighted];
    [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    button.titleLabel.font = font;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    
    return button;
}

- (CGRect)imageRectForContentRect:(CGRect)rect
{
//    NSLog(@"rect=%.1f, %.1f, %.1f, %.1f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    rect.size.height = 55;
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)rect;
{
//    NSLog(@"rect=%.1f, %.1f, %.1f, %.1f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    rect.origin.y = 55;
    rect.size.height = 20;
    
    return rect;
}

@end
