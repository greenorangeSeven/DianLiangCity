//
//  CommNewCell.h
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsTime;

- (void)bindData:(CommNew *)commNew;
@end
