//
//  BBSTableCell.h
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSButton.h"
#import "MWPhotoBrowser.h"

@interface BBSTableCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>

@property (retain, nonatomic) NSArray *imgArray;

@property (weak, nonatomic) UINavigationController *navigationController;

@property (weak, nonatomic) IBOutlet UIImageView *facePic;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *replyLb;
@property (weak, nonatomic) IBOutlet BBSButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinglunBtn;
@property (weak, nonatomic) IBOutlet UIButton *zan_text_label;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;

@end
