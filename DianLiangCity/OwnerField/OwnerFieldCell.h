//
//  OwnerFieldCell.h
//  DianLiangCity
//
//  Created by mac on 14-12-23.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface OwnerFieldCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (retain, nonatomic) NSArray *imgArray;

@property (weak, nonatomic) IBOutlet UILabel *summary_label;
@property (weak, nonatomic) IBOutlet UICollectionView *img_collection;

@property (weak, nonatomic) IBOutlet UILabel *nick_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UIButton *comment_size_label;


- (void)bindData:(BBSModel *)bbsModel;
@end
