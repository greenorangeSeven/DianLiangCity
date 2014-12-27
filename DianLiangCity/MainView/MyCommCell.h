//
//  MyCommCell.h
//  DianLiangCity
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"

@interface MyCommCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *commTitle;
@property (weak, nonatomic) IBOutlet UIImageView *commTagImg;
- (void)bindCommunity:(Community *)comm;
@end
