//
//  UserInfo.h
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding,NSCopying>

/**
 * 用户ID
 */
@property int id;

/**
 * 用户姓名
 */
@property (nonatomic,copy) NSString *name;

/**
 * 用户手机号码
 */
@property (nonatomic,copy) NSString *tel;

/**
 * 密码
 */
@property (nonatomic,copy) NSString *pwd;

/**
 * 头像URL
 */
@property (nonatomic,copy) NSString *avatar;

/**
 * 昵称
 */
@property (nonatomic,copy) NSString *nickname;

/**
 * 邮箱
 */
@property (nonatomic,copy) NSString *email;

/**
 * 地址
 */
@property (nonatomic,copy) NSString *address;

/**
 * 身份证号码
 */
@property (nonatomic,copy) NSString *card_id;

/**
 * 注册时间
 */
@property (nonatomic,copy) NSString *reg_time;

/**
 * 登录状态
 */
@property int status;

/**
 * 登录信息
 */
@property (nonatomic,copy) NSString *info;

@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *login_times;
@property (nonatomic,copy) NSString *last_login_time;

/**
 * 社区名称
 */
@property (nonatomic,copy) NSString *comm_name;


@end
