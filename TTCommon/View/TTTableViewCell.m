//
//  TTTableViewCell.m
//  ReadTV
//
//  Created by Ma Jianglin on 12/26/13.
//  Copyright (c) 2013 readtv.cn. All rights reserved.
//

#import "TTTableViewCell.h"

@implementation TTTableViewCell

- (void)disableDelaysContentTouches
{
    // for ios7 or newer
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        for (id obj in self.subviews)
        {
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.frame = CGRectZero;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
    }
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self disableDelaysContentTouches];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self disableDelaysContentTouches];
    }
    return self;
}


@end
