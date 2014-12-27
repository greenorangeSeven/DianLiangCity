//
//  RepairProgressCell.m
//  DianLiangCity
//
//  Created by mac on 14-12-6.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "RepairProgressCell.h"
#import "BaoxiuPro.h"

@implementation RepairProgressCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RepairProgressCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UITableViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
        {
            return nil;
        }
        // 加载nib;
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)bindData:(BaoxiuPro *)baoxiuPro
{
    self.progress_summary.text = baoxiuPro.result;
    self.progress_name.text = baoxiuPro.operator_name;
    self.progress_time.text = [Tool TimestampToDateStr:baoxiuPro.time andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
