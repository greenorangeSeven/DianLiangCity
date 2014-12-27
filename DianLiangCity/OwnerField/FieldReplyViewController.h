//
//  FieldReplyViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-3.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface FieldReplyViewController : TTBaseViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)deleteAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
