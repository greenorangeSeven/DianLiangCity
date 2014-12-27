//
//  BaoXiuInfo.h
//  DianLiangCity
//
//  Created by mac on 14-12-3.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoXiuInfo : NSObject

/**
 * 维修编号
 */
@property (nonatomic, copy) NSString *order_no;


/**
 * 维修描述
 */
@property (nonatomic, copy) NSString *summary;

/**
 * 维修状态
 */
@property int status;

/**
 * 维修时间
 */
@property (nonatomic, copy) NSString *weixiu_time;

/**
 * 维修材料
 */
@property (nonatomic, copy) NSString *weixiu_cailiao;

/**
 * 维修金额
 */
@property (nonatomic, copy) NSString *weixiu_cost;

/**
 * 维修图片
 */
@property (nonatomic, strong) NSMutableArray *weixiu_pics;

/**
 * 评论时间
 */
@property (nonatomic, copy) NSString *comment_time;

/**
 * 评论内容
 */
@property (nonatomic, copy) NSString *comment;

/**
 * 整体评价
 */
@property int rate_total;

/**
 * 速度评价
 */
@property int rate_speed;

/**
 * 服务评价
 */
@property int rate_service;

/**
 * 质量评价
 */
@property int rate_quality;

/**
 * 图片
 */
@property (nonatomic, strong) NSMutableArray *thumb;

/**
 * 维修过程
 */
@property (nonatomic, strong) NSMutableArray *baoxiu_process;

@end
