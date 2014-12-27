//
//  AssessViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"
@interface AssessViewController : UIViewController

@property (weak, nonatomic) NSString *order_no;

@property (weak, nonatomic) IBOutlet UILabel *total_comm_rating;
@property (weak, nonatomic) IBOutlet UILabel *service_rating;
@property (weak, nonatomic) IBOutlet UILabel *quality_rating;
@property (weak, nonatomic) IBOutlet UILabel *speek_rating;
@property (weak, nonatomic) IBOutlet UITextField *comm_content_label;


@end
