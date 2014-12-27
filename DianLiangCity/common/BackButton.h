//
//  BackButton.h
//  MYReporter
//
//  Created by jiaxiaochao on 14-3-7.
//  Copyright (c) 2014年 铭扬网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackButton : UIButton

+ (UIBarButtonItem *)backButton:(id)target action:(SEL)action title:(NSString *)title;
+ (UIBarButtonItem *)dismissButton:(id)target action:(SEL)action title:(NSString *)title;

+ (NSArray *)leftButton:(id)target action:(SEL)action title:(NSString *)title;
+ (NSArray *)rightButton:(id)target action:(SEL)action title:(NSString *)title;
+ (NSArray *)leftButton:(id)target action:(SEL)action image:(NSString *)image;
+ (NSArray *)rightButton:(id)target action:(SEL)action image:(NSString *)image;

@end
