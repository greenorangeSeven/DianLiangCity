//
//  RepairImgCell.m
//  DianLiangCity
//
//  Created by mac on 14-12-2.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "RepairImgCell.h"

@implementation RepairImgCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RepairImgCell" owner:self options:nil];
        
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

- (void)bindImg:(UIImage *)img andIndex:(NSInteger)index
{
    [self.repairImg setImage:img];
    self.repairImg.frame = CGRectMake(0, 0, 85, 85);
    if(index == 0)
    {
        self.deleteBtn.hidden = YES;
    }
    else
    {
        self.deleteBtn.hidden = NO;
        self.deleteBtn.tag = index;
        [self.deleteBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)deleteImg:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteImg" object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:sender.tag] forKey:@"index"]];
}

- (void)awakeFromNib
{
}

@end
