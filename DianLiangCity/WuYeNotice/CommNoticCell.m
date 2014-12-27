//
//  CommNoticCell.m
//  DianLiangCity
//
//  Created by mac on 14-11-28.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommNoticCell.h"

@implementation CommNoticCell
{
    CommNotic *currentNotic;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CommNoticCell" owner:self options:nil];
        
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

- (void)bindData:(CommNotic *)commNotic
{
    self.itemSource.text = commNotic.source;
    self.itemTitle.text = commNotic.title;
    self.itemSummary.text = commNotic.summary;
    self.itemTime.text = [Tool TimestampToDateStr:commNotic.published andFormatterStr:@"yyyy年MM月dd hh:mm"];
 
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
