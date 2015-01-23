//
//  Bill.h
//  DianLiangCity
//
//  Created by mac on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject
/**
 * 账单ID
 */
@property (nonatomic, copy) NSString *id;

/**
 * 账单名称
 */
@property (nonatomic, copy) NSString *bill_name;

/**
 * 添加时间
 */
@property (nonatomic, copy) NSString *addtime;

/**
 * 金额
 */
@property (nonatomic, copy) NSString *amount;

/**
 * 账单类型
 */
@property (nonatomic, copy) NSString *bill_type;

/**
 * 状态
 */
@property int status;
@property (nonatomic, copy) NSString *status_text;

@end
