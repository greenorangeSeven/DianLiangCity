//
//  CommNoticCell.h
//  DianLiangCity
//
//  Created by mac on 14-11-28.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommNoticCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemTime;
@property (weak, nonatomic) IBOutlet UILabel *itemSource;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UILabel *itemSummary;

- (void)bindData:(CommNotic *)commNotic;
@end
