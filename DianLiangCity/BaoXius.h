//
//  BaoXius.h
//  DianLiangCity
//
//  Created by mac on 14-12-1.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoXius : NSObject

/**
 * 已完成报修
 */
@property (nonatomic, strong) NSMutableArray *no;

/**
 * 未完成报修
 */
@property (nonatomic, strong) NSMutableArray *yes;

@end
