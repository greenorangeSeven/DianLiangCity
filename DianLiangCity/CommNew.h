//
//  CommNew.h
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import <Foundation/Foundation.h>

//社区新闻实体类
@interface CommNew : NSObject

@property  int id;
@property  int cid;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *thumb;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *published;
@property (copy, nonatomic) NSString *source;
@property (retain, nonatomic) NSArray *piclist;
@end
