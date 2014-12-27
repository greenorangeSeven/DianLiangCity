//
//  Community.h
//  DianLiangCity
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

//小区实体类
@interface Community : NSObject

/**
 * 这个用来标识角色(1:业主,2:家庭成员,3:访客)
 */
@property(nonatomic) int customer_pro;

/**
 * 小区ID
 */
@property(nonatomic) int id;

/**
 * 小区名称
 */
@property(nonatomic,copy) NSString *title;

/**
 * 小区Logo图片
 */
@property(nonatomic,copy) NSString *logo;

/**
 * 经度
 */
@property(nonatomic,copy) NSString *longitude;

/**
 * 纬度
 */
@property(nonatomic,copy) NSString *latitude;

/**
 * 地址
 */
@property(nonatomic,copy) NSString *address;

/**
 * 认证的区域名称
 */
@property(nonatomic,copy) NSString *areaName;

/**
 * 认证的楼栋名称
 */
@property(nonatomic,copy) NSString *buildName;

/**
 * 认证的单元名称
 */
@property(nonatomic,copy) NSString *unitName;

/**
 * 房间编号
 */
@property(nonatomic,copy) NSString *house_number;

/**
 * 区域列表
 */
@property(nonatomic) NSArray *areaList;

@end
