//
//  BBSModel.h
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSModel : NSObject

//是否显示点赞和评论按钮(默认不显示)
@property BOOL isShowMenu;

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *cid;
@property (nonatomic,retain) NSString *channel_id;
@property (nonatomic,retain) NSString *subject;

@property (nonatomic,retain) NSArray *thumb;

@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *customer_id;
@property (nonatomic,retain) NSString *addtime;
@property (nonatomic,retain) NSString *replys;
@property (nonatomic,retain) NSString *istop;
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *avatar;
@property (nonatomic,retain) NSString *comm_name;

@property (nonatomic, retain) NSArray *reply_list;
@property (nonatomic, retain) NSArray *replyArray;
@property (nonatomic, retain) NSMutableAttributedString *reply_str;

@property (nonatomic, retain) NSArray *points_list;
@property (nonatomic, retain) NSMutableString *point_str;
@property (retain,nonatomic) UIImage * imgData;
@property (nonatomic,retain) NSString *timeStr;
@property int contentHeight;
@property (nonatomic,retain) NSMutableString *replysStr;
@property int replyHeight;

@end
