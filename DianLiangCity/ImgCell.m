//
//  ImgCell.m
//  DianLiangCity
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "ImgCell.h"
#import "UIImageView+WebCache.h"

@implementation ImgCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImgCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)setImg:(NSString *)imgURL
{
     [self.imgView setImageWithURL:[NSURL URLWithString:imgURL]placeholderImage:[UIImage imageNamed:@"area_icon.png"]];
}

- (void)awakeFromNib
{
}

@end
