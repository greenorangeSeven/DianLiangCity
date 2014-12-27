//
//  HouseNumber.h
//  DianLiangCity
//
//  Created by mac on 14-11-24.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseNumber : NSObject
/**
 * 房间编号
 */
@property (nonatomic,copy) NSString *house_number;
/**
 * 所有者
 */
@property (nonatomic,copy) NSString *owner;

/**
 * 联系电话
 */
@property (nonatomic,copy) NSString *mobile;

/**
 * 身份证号码
 */
@property (nonatomic,copy) NSString *card_id;
@end
