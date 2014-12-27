//
//  SystemInformCell.h
//  DianLiangCity
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemInformCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)bindData:(SystemInform *)form;
@end
