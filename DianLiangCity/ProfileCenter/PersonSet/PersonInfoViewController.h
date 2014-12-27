//
//  PersonInfoViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface PersonInfoViewController : UITableViewController< UINavigationControllerDelegate>

@property (copy, nonatomic) NSString *titleStr;
@property (copy, nonatomic) NSString *identityStr;
@property (copy, nonatomic) NSString *nickNameStr;

@property (weak, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@end
