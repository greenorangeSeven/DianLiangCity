//
//  MyCommCell.m
//  DianLiangCity
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "MyCommCell.h"
#import "EGOImageView.h"

@implementation MyCommCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MyCommCell" owner:self options:nil];
        
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

- (void)bindCommunity:(Community *)comm
{
    if(!comm)
        return;
    if(comm.id == -1)
    {
        [self.commTagImg setImage:nil];
        for (UIView * subview in [self.commLogoImg subviews])
        {
            [subview removeFromSuperview];
        }
        [self.commLogoImg setImage:[UIImage imageNamed:@"添加社区"]];
        [self.commTitle setText:@"添加社区"];
        return;
    }
    else
    {
        EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"area_icon.png"]];
        imageView.imageURL = [NSURL URLWithString:comm.logo];
        imageView.frame = CGRectMake(0.0f, 0.0f, 70.0f, 70.0f);
        [self.commLogoImg addSubview:imageView];
        [self.commTitle setText:comm.title];
        //业主
        if(comm.customer_pro == 1)
        {
            [self.commTagImg setImage:[UIImage imageNamed:@"area_house"]];
        }
        //家庭成员
        else if(comm.customer_pro == 2)
        {
            [self.commTagImg setImage:[UIImage imageNamed:@"area_family"]];
        }
        //访客
        else if(comm.customer_pro == 3)
        {
            [self.commTagImg setImage:[UIImage imageNamed:@"area_guest"]];
        }
    }
}

- (void)awakeFromNib
{
}

@end
