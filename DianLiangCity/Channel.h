//
//  Channel.h
//  DianLiangCity
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property int id;

@property int cid;

@property (nonatomic, copy) NSString *channel_name;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, copy) NSString *status;
@end
