//
//  CBuild.h
//  DianLiangCity
//
//  Created by mac on 14-11-24.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBuild : NSObject

/**
 * 区域名称
 */
@property (copy,nonatomic) NSString *buildName;

/**
 * 单元信息
 */
@property (nonatomic) NSArray *uintList;

@end
