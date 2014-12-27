//
//  BackButton.m
//  MYReporter
//
//  Created by jiaxiaochao on 14-3-7.
//  Copyright (c) 2014年 铭扬网. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

+ (UIBarButtonItem*)backButton:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    [button setBackgroundImage:[UIImage imageNamed:@"yelloButton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, button.frame.size.width + 20, button.frame.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return leftItem;
}
+ (UIBarButtonItem*)dismissButton:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    [button setBackgroundImage:[UIImage imageNamed:@"yelloButton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, button.frame.size.width + 20, button.frame.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return rightItem;
}

+ (NSArray *) leftButton:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    [button setBackgroundImage:[UIImage imageNamed:@"yelloButton"] forState:UIControlStateNormal];
    [button setTitleColor:UIColorHSL(38, 38, 38) forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, button.frame.size.width + 20, button.frame.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];


    negativeSpacer.width = -12;

//
    return [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
}

+(NSArray *) rightButton:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    
    [button setBackgroundImage:[UIImage imageNamed:@"yelloButton"] forState:UIControlStateNormal];
    [button setTitleColor:UIColorHSL(38, 38, 38) forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, button.frame.size.width + 20, button.frame.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -12;

    return [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
}

+ (NSArray *)leftButton:(id)target action:(SEL)action image:(NSString *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:UIColorHSL(38, 38, 38) forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -6)];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    
    negativeSpacer.width = -6;
    
    //
    return [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
}

+ (NSArray *)rightButton:(id)target action:(SEL)action image:(NSString *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.frame.size.width, 60);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -6;
    return [NSArray arrayWithObjects:negativeSpacer, rightButton, nil];
}

@end
