//
//  CArea.h
//  DianLiangCity
//
//  Created by mac on 14-11-24.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CArea : NSObject

/**
 * 区域名称
 */
@property (copy,nonatomic) NSString *areaName;

/**
 * 楼栋列表
 */
@property (nonatomic) NSArray *buildList;
@end
