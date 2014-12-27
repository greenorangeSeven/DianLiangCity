//
//  MyBill.h
//  DianLiangCity
//
//  Created by mac on 14-11-30.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBill : NSObject

/**
 * 未支付账单
 */
@property (nonatomic, strong) NSMutableArray *nopay;

/**
 * 未支付账单
 */
@property (nonatomic, strong) NSMutableArray *pay;

/**
 * 未支付账单
 */
@property (nonatomic, strong) NSMutableArray *other;

@end
