//
//  CUnit.h
//  DianLiangCity
//
//  Created by mac on 14-11-24.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUnit : NSObject

/**
 * 单元名称
 */
@property (copy,nonatomic) NSString *unitName;

/**
 * 房间信息
 */
@property (nonatomic) NSArray *houseList;

@end
