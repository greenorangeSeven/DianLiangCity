//
//  NewFieldViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-3.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface NewFieldViewController : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Community *commData;
@property (strong, nonatomic) Channel *currentChannel;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
