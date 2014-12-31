//
//  SysInfoDetailView.h
//  DianLiangCity
//
//  Created by Seven on 14-12-31.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SysInfoDetailView : UIViewController

@property (copy, nonatomic) NSString *infoId;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
