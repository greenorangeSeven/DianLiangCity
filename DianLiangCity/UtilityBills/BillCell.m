//
//  BillCell.m
//  DianLiangCity
//
//  Created by mac on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BillCell.h"

@implementation BillCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BillCell" owner:self options:nil];
        
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

- (void)bindData:(Bill *)bill
{
    self.billTitle.text = bill.bill_name;
    self.billPrice.text = [NSString stringWithFormat:@"￥%@",bill.amount];
    self.billDate.text = [Tool TimestampToDateStr:bill.addtime andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
    self.payStatus.text = bill.status_text;
    if(bill.status == 0)
    {
        [self.statusImg setImage:[UIImage imageNamed:@"bill_unpay"]];
    }
    else if(bill.status == 1)
    {
        [self.statusImg setImage:[UIImage imageNamed:@"bill_pay"]];
    }
    else
    {
        [self.statusImg setImage:[UIImage imageNamed:@"bill_ignore"]];
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
