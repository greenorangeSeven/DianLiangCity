//
//  NewRepairViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-30.
//  Copyright (c) 2014年 totem. All rights reserved.
//


@interface NewRepairViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Community *commData;

@property (weak, nonatomic) IBOutlet UITextField *contextTextField;
@property (weak, nonatomic) IBOutlet UITextField *peopleTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextFiled;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)deleteAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
