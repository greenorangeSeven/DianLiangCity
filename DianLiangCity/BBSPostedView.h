//
//  BBSPostedView.h
//  NanNIng
//
//  Created by Seven on 14-9-14.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSPostedView : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Community *commData;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
