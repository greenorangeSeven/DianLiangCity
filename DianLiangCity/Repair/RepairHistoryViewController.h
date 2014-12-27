//
//  RepairHistoryViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-1.
//  Copyright (c) 2014年 totem. All rights reserved.
//

@interface RepairHistoryViewController : UIViewController

@property (weak, nonatomic) NSString *order_no;

@property (weak, nonatomic) IBOutlet UIImageView *baoxiuImg;
@property (weak, nonatomic) IBOutlet UIImageView *paigongImg;
@property (weak, nonatomic) IBOutlet UIImageView *weixiuImg;
@property (weak, nonatomic) IBOutlet UIImageView *pingjiaImg;
@property (weak, nonatomic) IBOutlet UIImageView *paigongProImg;
@property (weak, nonatomic) IBOutlet UIImageView *weixiuProImg;
@property (weak, nonatomic) IBOutlet UIImageView *pingjiaProImg;

@property (weak, nonatomic) IBOutlet UILabel *order_no_label;
@property (weak, nonatomic) IBOutlet UILabel *summary_label;
@property (weak, nonatomic) IBOutlet UICollectionView *weixiu_img_collection;
@property (weak, nonatomic) IBOutlet UITableView *progress_tableView;
@property (weak, nonatomic) IBOutlet UILabel *progress_none_label;

@property (weak, nonatomic) IBOutlet UILabel *rating_label;
@property (weak, nonatomic) IBOutlet UILabel *comment_label;


@property (weak, nonatomic) IBOutlet UILabel *weixiu_cailiao_label;
@property (weak, nonatomic) IBOutlet UILabel *weixiu_time_label;
@property (weak, nonatomic) IBOutlet UILabel *cailiao_cost_label;



@property (weak, nonatomic) IBOutlet UIView *summary_view;
@property (weak, nonatomic) IBOutlet UIView *progress_view;
@property (weak, nonatomic) IBOutlet UIView *commment_view;
@property (weak, nonatomic) IBOutlet UIView *cailiao_view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *baoxiulabel;
@property (weak, nonatomic) IBOutlet UILabel *paigonglabel;
@property (weak, nonatomic) IBOutlet UILabel *pingjialabel;

@property (weak, nonatomic) IBOutlet UILabel *weixiulabel;



- (IBAction)toComm:(UIButton *)sender;

@end
