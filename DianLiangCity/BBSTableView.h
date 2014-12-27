//
//  BBSTableView.h
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQImageCache.h"
#import "BBSModel.h"
#import "BBSTableCell.h"
#import "BBSReplyView.h"
#import "BBSPostedView.h"
#import "UIViewController+CWPopup.h"

@interface BBSTableView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,IconDownloaderDelegate, UIAlertViewDelegate>
{
    NSMutableArray *bbsArray;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    BOOL isInitialize;
    TQImageCache * _iconCache;
    
    UIWebView *phoneCallWebView;
    
    MBProgressHUD *hud;
    int tableIndex;
    BBSReplyView *samplePopupViewController;
    NSArray *_photos;
}

@property (nonatomic, retain) NSArray *photos;
@property (strong, nonatomic) IBOutlet UIView *popview;

- (void)refreshTableData;

@property (weak, nonatomic) Community *commData;

//异步加载图片专用
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *replyTF;

@end
