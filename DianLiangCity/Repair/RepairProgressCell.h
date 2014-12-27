//
//  RepairProgressCell.h
//  DianLiangCity
//
//  Created by mac on 14-12-6.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaoxiuPro;

@interface RepairProgressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *progress_summary;
@property (weak, nonatomic) IBOutlet UILabel *progress_time;
@property (weak, nonatomic) IBOutlet UILabel *progress_name;

- (void)bindData:(BaoxiuPro *)baoxiuPro;

@end
