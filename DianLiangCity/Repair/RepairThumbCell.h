//
//  RepairThumbCell.h
//  DianLiangCity
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface RepairThumbCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet EGOImageView *thumbImg;

- (void)bindImg:(NSString *)img;
@end
