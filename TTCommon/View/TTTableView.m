//
//  TTTableView.m
//  ReadTV
//
//  Created by Ma Jianglin on 12/26/13.
//  Copyright (c) 2013 readtv.cn. All rights reserved.
//

#import "TTTableView.h"

@implementation TTTableView

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        self.delaysContentTouches = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delaysContentTouches = NO;
    }
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView: (UIView*)view
{
    if (view.userInteractionEnabled == YES)
    {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
