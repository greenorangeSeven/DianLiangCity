//
//  Family.h
//  DianLiangCity
//
//  Created by mac on 14-12-8.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Family : NSObject

/**
 * ID
 */
@property int id;

/**
 * 所在社区ID
 */
@property (nonatomic, copy) NSString *cid;

/**
 * 成员姓名
 */
@property (nonatomic, copy) NSString *member_name;

/**
 * 成员电话号码
 */
@property (nonatomic, copy) NSString *member_tel;

/**
 * 成员身份证号码
 */
@property (nonatomic, copy) NSString *member_card;

/**
 * 邀请码
 */
@property (nonatomic, copy) NSString *invite_code;

/**
 * 与成员关系
 */
@property (nonatomic, copy) NSString *relations;

/**
 * 所在小区名称
 */
@property (nonatomic, copy) NSString *comm_name;

/**
 * 绑定的用户ID(用来判断该家庭成员是否激活)
 */
@property (nonatomic, copy) NSString *customer_id;

/**
 * 邀请者的ID
 */
@property (nonatomic, copy) NSString *father_id;

@end
