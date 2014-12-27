//
//  CommNotic.h
//  DianLiangCity
//
//  Created by mac on 14-11-28.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

//物业通知
@interface CommNotic : NSObject

/**
 * 通知的ID
 */
@property (copy, nonatomic) NSString *id;

/**
 * 标题
 */
@property (copy, nonatomic) NSString *title;

/**
 * 摘要
 */
@property (copy, nonatomic) NSString *summary;

/**
 * 时间戳
 */
@property (copy, nonatomic) NSString *published;

/**
 * 来源
 */
@property (copy, nonatomic) NSString *source;

/**
 * 内容
 */
@property (copy, nonatomic) NSString *content;

/**
 * 图片
 */
@property (strong, nonatomic) NSMutableArray *piclist;
@end
