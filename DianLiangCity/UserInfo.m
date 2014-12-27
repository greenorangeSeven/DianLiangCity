//
//  UserInfo.m
//  DianLiangCity
//
//  Created by mac on 14-11-26.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_id forKey:@"id"];
    [aCoder encodeInteger:_status forKey:@"status"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_tel forKey:@"tel"];
    [aCoder encodeObject:_pwd forKey:@"pwd"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_card_id forKey:@"card_id"];
    [aCoder encodeObject:_reg_time forKey:@"reg_time"];
    [aCoder encodeObject:_info forKey:@"info"];
    [aCoder encodeObject:_remark forKey:@"remark"];
    [aCoder encodeObject:_login_times forKey:@"login_times"];
    [aCoder encodeObject:_last_login_time forKey:@"last_login_time"];
    [aCoder encodeObject:_comm_name forKey:@"comm_name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _id = [aDecoder decodeIntegerForKey:@"id"];
    _status = [aDecoder decodeIntegerForKey:@"status"];
    _name = [aDecoder decodeObjectForKey:@"name"];
    _tel = [aDecoder decodeObjectForKey:@"tel"];
    _pwd = [aDecoder decodeObjectForKey:@"avatar"];
    _avatar = [aDecoder decodeObjectForKey:@"tel"];
    _nickname = [aDecoder decodeObjectForKey:@"nickname"];
    _email = [aDecoder decodeObjectForKey:@"email"];
    _address = [aDecoder decodeObjectForKey:@"address"];
    _card_id = [aDecoder decodeObjectForKey:@"card_id"];
    _reg_time = [aDecoder decodeObjectForKey:@"reg_time"];
    _info = [aDecoder decodeObjectForKey:@"info"];
    _remark = [aDecoder decodeObjectForKey:@"remark"];
    _login_times = [aDecoder decodeObjectForKey:@"login_times"];
    _last_login_time = [aDecoder decodeObjectForKey:@"last_login_time"];
    _comm_name = [aDecoder decodeObjectForKey:@"comm_name"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    UserInfo *info = [[self class] allocWithZone:zone];
    info.id = _id;
    info.name = [_name copyWithZone:zone];
    info.tel = [self.tel copyWithZone:zone];
    info.pwd = [_pwd copyWithZone:zone];
    info.avatar = [_avatar copyWithZone:zone];
    info.nickname = [_nickname copyWithZone:zone];
    info.email = [_email copyWithZone:zone];
    info.address = [_address copyWithZone:zone];
    info.card_id = [_card_id copyWithZone:zone];
    info.reg_time = [_reg_time copyWithZone:zone];
    info.status = _status;
    info.info = [_info copyWithZone:zone];
    info.remark = [_remark copyWithZone:zone];
    info.login_times = [_login_times copyWithZone:zone];
    info.last_login_time = [_last_login_time copyWithZone:zone];
    info.comm_name = [_comm_name copyWithZone:zone];
    return info;
}

@end
