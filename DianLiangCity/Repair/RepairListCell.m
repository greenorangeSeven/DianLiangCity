//
//  RepairListCell.m
//  DianLiangCity
//
//  Created by mac on 14-12-1.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "RepairListCell.h"

@implementation RepairListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RepairListCell" owner:self options:nil];
        
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

- (void)bindData:(BaoXiuCase *)baoxiuCase
{
    
    self.itemTitleLabel.text = [NSString stringWithFormat:@"【%@】",baoxiuCase.order_no];
    self.itemSummaryLabel.text = baoxiuCase.summary;
    self.itemTimeLabel.text = [Tool TimestampToDateStr:baoxiuCase.published andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
    if(baoxiuCase.status == 1)
    {
        [self.itemStatusImg setImage:[UIImage imageNamed:@"bill_ignore"]];
        self.itemStatusLabel.text = @"待处理";
    }
    else if(baoxiuCase.status == 2)
    {
        [self.itemStatusImg setImage:[UIImage imageNamed:@"bill_unpay"]];
        self.itemStatusLabel.text = @"处理中";
    }
    else if(baoxiuCase.status == 3)
    {
        [self.itemStatusImg setImage:[UIImage imageNamed:@"bill_unpay"]];
        self.itemStatusLabel.text = @"未评价";
    }
    else if(baoxiuCase.status == 4)
    {
        [self.itemStatusImg setImage:[UIImage imageNamed:@"bill_pay"]];
        self.itemStatusLabel.text = @"已处理";
    }
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
