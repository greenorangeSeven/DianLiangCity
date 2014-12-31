//
//  AppDelegate.h
//  DianLiangCity
//
//  Created by Seven on 14-9-29.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property BOOL isForeground;
@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) NSDictionary *pushInfo;

@property (nonatomic, assign) BOOL isFirst;

@end
