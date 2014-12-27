//
//  RepairListCell.h
//  DianLiangCity
//
//  Created by mac on 14-12-1.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemStatusImg;
- (void)bindData:(BaoXiuCase *)baoxiuCase;

@end
