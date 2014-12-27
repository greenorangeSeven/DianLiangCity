//
//  AreaMainViewController.h
//  DianLiangCity
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Community;

@interface AreaMainViewController : UIViewController

@property (weak,nonatomic) Community *commData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)billAction:(UIButton *)sender;
- (IBAction)repairAction:(UIButton *)sender;
- (IBAction)propertyNoticAction:(UIButton *)sender;
- (IBAction)scopeAction:(UIButton *)sender;
- (IBAction)buildAction:(UIButton *)sender;
- (IBAction)governmentAction:(UIButton *)sender;
- (IBAction)yellowAction:(UIButton *)sender;

@end
