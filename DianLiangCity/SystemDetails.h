//
//  SystemDetails.h
//  DianLiangCity
//
//  Created by mac on 14-11-21.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

//系统通知详情
@interface SystemDetails : NSObject

/**
 * 通知id
 */
@property(nonatomic,copy) NSString *id;

/**
 * 标题
 */
@property(nonatomic,copy) NSString *title;

/**
 * 图片
 */
@property(nonatomic,copy) NSString *thumb;

/**
 * 详细
 */
@property(nonatomic,copy) NSString *summary;

/**
 * 时间戳
 */
@property(nonatomic,copy) NSString *published;

/**
 * 内容
 */
@property(nonatomic,copy) NSString *content;

@end
