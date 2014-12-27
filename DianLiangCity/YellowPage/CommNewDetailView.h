//
//  CommNewDetailView.h
//  DianLiangCity
//
//  Created by mac on 14-11-27.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommNewDetailView : UIViewController

@property int commId;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *imgScroller;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
