//
//  BillDetail.h
//  DianLiangCity
//
//  Created by mac on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDetail : NSObject
/**
 * 账单ID
 */
@property int id;

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
 * 账单备注
 */
@property (nonatomic, copy) NSString *remark;

/**
 * 状态
 */
@property int status;
@property (nonatomic, copy) NSString *status_text;


@end
