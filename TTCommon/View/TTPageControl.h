//
//  TTPageControl.h
//  CustomUIKit
//
//  Created by Ma Jianglin on 11-6-27.
//  Copyright 2011 Totem. All rights reserved.
//

/**
 * 自定义翻页控件，用来替代UIPageControl
 */

#import <UIKit/UIKit.h>

@interface TTPageControl : UIPageControl

@property (nonatomic, strong) UIImage *imageNormal;
@property (nonatomic, strong) UIImage *imageCurrent;

@end