//
//  CommunityInfo.h
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

//小区简介实体类
@interface CommunityInfo : NSObject

/**
 * 社区ID
 */
@property int id;

/**
 * 社区名称
 */
@property (nonatomic,copy) NSString *title;

/**
 * 社区Logo
 */
@property (nonatomic,copy) NSString *logo;

/**
 * 社区地址
 */
@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *remark;

/**
 * 社区图片(介绍)
 */
@property (nonatomic,retain) NSMutableArray *piclist;

/**
 * 社区简介
 */
@property (nonatomic,copy) NSString *summary;

@end
