//
//  RepairThumbCell.m
//  DianLiangCity
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "RepairThumbCell.h"

@implementation RepairThumbCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RepairThumbCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UITableViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib;
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)bindImg:(NSString *)img
{
    [self.thumbImg setPlaceholderImage:[UIImage imageNamed:@"area_icon.png"]];
    self.thumbImg.imageURL = [NSURL URLWithString:img];
}

- (void)awakeFromNib
{
}

@end
