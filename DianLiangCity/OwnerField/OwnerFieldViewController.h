//
//  OwnerFieldViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-2.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"

@interface OwnerFieldViewController : TTBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Community *commData;
//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSArray *photos;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *channelSegment;
@property (weak, nonatomic) IBOutlet UILabel *topicSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *huifuMoreBtn;
- (IBAction)huifuMoreAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *hintMoreBtn;
- (IBAction)hintMoreAction:(UIButton *)sender;
- (IBAction)chooseChannel:(UISegmentedControl *)sender;
- (IBAction)pushAction:(id)sender;

@end
