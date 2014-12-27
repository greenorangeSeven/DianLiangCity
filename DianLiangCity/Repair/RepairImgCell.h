//
//  RepairImgCell.h
//  DianLiangCity
//
//  Created by mac on 14-12-2.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairImgCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *repairImg;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (void)bindImg:(UIImage *)img andIndex:(NSInteger)index;
@end
