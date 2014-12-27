//
//  FieldSetViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-4.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface FieldSetViewController : TTBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *setButton1;
@property (weak, nonatomic) IBOutlet UIButton *setButton2;
@property (weak, nonatomic) IBOutlet UIButton *setButton3;
@property (strong, nonatomic) NSMutableArray *setButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (weak, nonatomic) IBOutlet UIImageView *removeImageView;

@end
