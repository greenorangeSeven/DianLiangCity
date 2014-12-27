//
//  CommNewViews.h
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;

@interface CommNewView : UIViewController

@property int type_id;
@property (weak, nonatomic) UIView *mainView;
@property (strong, nonatomic) Community *commData;
@property BOOL isLoadOver;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet EGOImageView *itemImgView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UIView *firstView;

- (void)reload:(BOOL)noRefresh;
@end
