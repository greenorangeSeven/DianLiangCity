//
//  CustomizedButton.m
//  DiabetesManager
//
//  Created by ZhangChuntao on 7/1/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "CustomizedButton.h"

@implementation CustomizedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat spacing = 6.0f;
    
    CGSize imageSize = self.imageView.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    
    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, 0.0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
