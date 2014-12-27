//
//  MainViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-24.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTBaseViewController.h"
#import "CustomizedButton.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface MainViewController:TTBaseViewController
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *screenImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *myCommPlanView;
@property (weak, nonatomic) IBOutlet UITableView *noticTableView;
@property (weak, nonatomic) IBOutlet UIView *noticPlanView;

@end
