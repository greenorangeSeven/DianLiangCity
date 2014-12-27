//
//  FieldReplyViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-3.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "FieldReplyViewController.h"
#include "AppDelegate.h"

@interface FieldReplyViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation FieldReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    
    self.imageArray = [NSMutableArray array];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLong:)];
    longPress.minimumPressDuration = 0.5;
    [self.photoImageView addGestureRecognizer:longPress];
    self.photoImageView.userInteractionEnabled = YES;
    [self.imageArray addObject:self.photoImageView];
    [self.imageArray addObject:self.addButton];
    [self setUI];
}

-(void)setUI
{
    for (int i = 0; i < self.imageArray.count; i++)
    {
        if (i == self.imageArray.count - 1)
        {
            UIButton *button = [self.imageArray lastObject];
            button.frame = CGRectMake((i%3 + 1) * 10 + i%3 * 75, 55 + i/3*65, button.frame.size.width, button.frame.size.height);
            [self.scrollView addSubview:button];
        }
        else
        {
            UIImageView *imageView = [self.imageArray objectAtIndex:i];
            imageView.frame = CGRectMake((i%3 + 1) * 10 + i%3 * 75, 55 + i/3*65, 75, 55);
            imageView.tag = i + 1000;
            [self.scrollView addSubview:imageView];
        }
    }
}


-(void)submitAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)deleteAction:(id)sender
{
    self.deleteButton.hidden = YES;
    [self.imageArray removeObjectAtIndex:(self.deleteButton.tag - 1000)];
    UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:self.deleteButton.tag];
    [imageView removeFromSuperview];
    [self setUI];
}

- (IBAction)addAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"从手机照片选择", nil];
    [actionSheet showInView:SharedAppDelegate.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                return;
            }
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [SharedAppDelegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SharedAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = self.photoImageView.frame;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLong:)];
        longPress.minimumPressDuration = 0.5;
        [imageView addGestureRecognizer:longPress];
        imageView.userInteractionEnabled = YES;
        
        [self.imageArray insertObject:imageView atIndex:self.imageArray.count - 1];
        [self setUI];
    }
}

-(void)imageLong:(UILongPressGestureRecognizer*)gestureRecognizer{
    
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        self.deleteButton.tag = imageView.tag;
        self.deleteButton.hidden = NO;
        self.deleteButton.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width - 5, imageView.frame.origin.y + 5);
        [self.scrollView bringSubviewToFront:self.deleteButton];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [SharedAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
