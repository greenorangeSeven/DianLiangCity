//
//  CommHotlineCell.m
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "CommHotlineCell.h"
#import "Hotline.h"

@implementation CommHotlineCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CommHotlineCell" owner:self options:nil];
        
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

- (void)bindData:(Hotline *)hotline
{
    self.itemTitle.text = hotline.telname;
    self.telTitle.text = hotline.tel;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
