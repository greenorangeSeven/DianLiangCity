//
//  MessageDetailViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
- (IBAction)sendAction:(id)sender;
@end
