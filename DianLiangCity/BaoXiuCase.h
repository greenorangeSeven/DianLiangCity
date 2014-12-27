//
//  BaoXiuCase.h
//  DianLiangCity
//
//  Created by mac on 14-12-1.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoXiuCase : NSObject

@property int id;

@property (nonatomic, copy) NSString *order_no;

@property (nonatomic, copy) NSString *build;
@property (nonatomic, copy) NSString *units;
@property (nonatomic, copy) NSString *house_number;
@property (nonatomic, copy) NSString *summary;
@property int status;
@property (nonatomic, copy) NSString *published;
@end
