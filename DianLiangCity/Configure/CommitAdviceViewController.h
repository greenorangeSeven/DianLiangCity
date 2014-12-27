//
//  CommitAdviceViewController.h
//  DelightCity
//
//  Created by qiaohaibin on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitAdviceViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)commit:(id)sender;
@end
