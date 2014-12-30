//
//  FieldDetailViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-3.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSReplyView.h"
#import "TQImageCache.h"

@interface FieldDetailViewController : UIViewController
{
    BBSReplyView *samplePopupViewController;
    TQImageCache * _iconCache;
    NSMutableArray *_photos;
}

@property (nonatomic, retain) NSMutableArray *photos;

@property (retain, nonatomic) NSArray *imgArray;

@property (retain, nonatomic) BBSModel *bbs;

@property (weak, nonatomic) IBOutlet UIImageView *facePic;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *replyLb;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
