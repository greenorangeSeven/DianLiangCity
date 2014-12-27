//
//  BillCell.h
//  DianLiangCity
//
//  Created by mac on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *billTitle;
@property (weak, nonatomic) IBOutlet UILabel *billDate;
@property (weak, nonatomic) IBOutlet UILabel *billPrice;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;

- (void)bindData:(Bill *)bill;

@end
