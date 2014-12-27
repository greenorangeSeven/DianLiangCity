//
//  FieldSetViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-4.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "FieldSetViewController.h"

@interface FieldSetViewController ()


@end

@implementation FieldSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress1.minimumPressDuration = 0.5; //定义按的时间
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress2.minimumPressDuration = 0.5; //定义按的时间
    UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress3.minimumPressDuration = 0.5; //定义按的时间
    
    self.setButtons = [NSMutableArray array];
    [self.setButton1 addGestureRecognizer:longPress1];
    [self.setButtons addObject:self.setButton1];
    [self.setButton2 addGestureRecognizer:longPress2];
    [self.setButtons addObject:self.setButton2];
    [self.setButton3 addGestureRecognizer:longPress3];
    [self.setButtons addObject:self.setButton3];
    [self setUI];
}

-(void)submitAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OwnerFieldViewController" object:self.setButtons];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fieldSetAction:(UIButton *)sender
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    button.titleLabel.font = sender.titleLabel.font;
    [button setTitleColor:UIColorRGB(51, 51, 51) forState:UIControlStateNormal];
    button.frame = sender.frame;
    button.tag = sender.tag;
    [button setBackgroundImage:[UIImage imageNamed:@"field_button_bg"] forState:UIControlStateNormal];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];

    longPress.minimumPressDuration = 0.5; //定义按的时间
    [button addGestureRecognizer:longPress];
    
    [self.setButtons addObject:button];
    
    
    [sender setBackgroundImage:[UIImage imageNamed:@"field_button_bg_h"] forState:UIControlStateNormal];
    [sender removeTarget:self action:@selector(fieldSetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setUI];
}

-(void)setUI
{
    for (int i = 0; i < self.setButtons.count; i++)
    {
        
        UIButton *button = [self.setButtons objectAtIndex:i];
        button.frame = CGRectMake((i%4 + 1) * 10 + i%4 * button.frame.size.width, 252 + i/4*41, button.frame.size.width, button.frame.size.height);
        [self.view addSubview:button];
    }
}

-(IBAction)removeAction:(UIButton *)sender
{
    self.removeImageView.hidden = YES;
    UIButton *button = [self.allButtons objectAtIndex:sender.tag];
    [button addTarget:self action:@selector(fieldSetAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"field_button_bg"] forState:UIControlStateNormal];
    [self.setButtons removeObject:sender];
    [sender removeFromSuperview];
    [self setUI];
}

-(void)btnLong:(UILongPressGestureRecognizer*)gestureRecognizer{

    UIButton *button = (UIButton *)gestureRecognizer.view;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        self.removeImageView.hidden = NO;
        self.removeImageView.center = CGPointMake(button.frame.origin.x + button.frame.size.width - 5, button.frame.origin.y + 5);
        [self.view bringSubviewToFront:self.removeImageView];
        [button addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
