//
//  ImgCell.h
//  DianLiangCity
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ImgCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *imgView;

- (void)setImg:(NSString *)imgURL;

@end
