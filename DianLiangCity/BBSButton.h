//
//  BBSButton.h
//  DianLiangCity
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSButton : UIButton

@property (nonatomic, weak)BBSModel *bbs;
@property NSIndexPath *indexPath;
@property (nonatomic, weak) UIView *popView;

@end
