//
//  CommHotlineCell.h
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommHotlineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *telTitle;

- (void)bindData:(Hotline *)hotline;
@end
