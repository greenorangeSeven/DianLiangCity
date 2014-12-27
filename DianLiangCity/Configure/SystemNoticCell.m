//
//  SystemInformCell.m
//  DianLiangCity
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "SystemNoticCell.h"

@implementation SystemNoticCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SystemInformCell" owner:self options:nil];
        
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
        NSLog(@"yuh");
        // 加载nib;
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)bindData:(id)form
{
    if([form isKindOfClass:[SystemInform class]])
    {
        SystemInform *sys = (SystemInform *)form;
        [self.summaryLabel setText:sys.summary];
        self.timeLabel.text = [Tool TimestampToDateStr:sys.published andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
    }
    else if([form isKindOfClass:[Helps class]])
    {
        Helps *help = (Helps *)form;
        [self.summaryLabel setText:help.summary];
        self.timeLabel.text = [Tool TimestampToDateStr:help.published andFormatterStr:@"yyyy年MM月dd日 hh:mm"];
    }
    
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
