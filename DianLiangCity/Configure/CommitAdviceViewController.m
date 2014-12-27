//
//  CommitAdviceViewController.m
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "CommitAdviceViewController.h"
#import "BackButton.h"

@interface CommitAdviceViewController ()

@end

@implementation CommitAdviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    self.commentTextView.delegate = self;
    self.commentTextView.text = @"请输入您的反馈意见";
    self.commentTextView.textColor = [UIColor grayColor];
    self.commentTextView.layer.cornerRadius = 5;
    self.commentTextView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - call back keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.commentTextView resignFirstResponder];
}

#pragma mark - textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (IBAction)commit:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
