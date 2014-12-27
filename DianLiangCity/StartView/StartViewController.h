//
//  StartViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface StartViewController : TTBaseViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *intoButton;

- (IBAction)enterAction:(id)sender;
@end
