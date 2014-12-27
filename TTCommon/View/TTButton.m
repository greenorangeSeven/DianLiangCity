//
//  TTButton.m
//  EBCCard
//
//  Created by Ma Jianglin on 3/12/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTButton.h"

@implementation TTButton

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    self.titleLabel.textAlignment = UITextAlignmentLeft;
//}

- (CGRect)imageRectForContentRect:(CGRect)rect
{
    return self.iconRect;
}

- (CGRect)titleRectForContentRect:(CGRect)rect;
{
    return self.titleRect;
}

@end
