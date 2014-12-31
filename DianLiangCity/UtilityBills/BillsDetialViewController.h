//
//  BillsDetialViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-27.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface BillsDetialViewController : UIViewController

@property (strong, nonatomic) NSString *present;

@property (strong, nonatomic) NSString *billId;
@property (strong, nonatomic) BillDetail *billDetails;
@property (weak, nonatomic) IBOutlet UILabel *billTime;
@property (weak, nonatomic) IBOutlet UILabel *billPrice;
@property (weak, nonatomic) IBOutlet UILabel *billName;
@property (weak, nonatomic) IBOutlet UILabel *billDetail;
@property (weak, nonatomic) IBOutlet UIButton *pay;
@property (weak, nonatomic) IBOutlet UIButton *ignore;

@end
