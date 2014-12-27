//
//  UserModel.h
//  zhxq
//
//  Created by Seven on 13-9-21.
//
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserModel : NSObject
+(UserModel *) Instance;
+(id)allocWithZone:(NSZone *)zone;

-(BOOL)isLogin;

//是否具备网络链接
@property BOOL isNetworkRunning;

-(void)saveAccount:(NSString *)account
             andPwd:(NSString *)pwd;

-(UserInfo *)getUserInfo;

-(void)saveUserInfo:(UserInfo *)userinfo;
-(void)logoutUser;

//用户信息
@property (strong, nonatomic) UserInfo *userInfo;

//业主认证的社区(如果存在则不为空)
@property (nonatomic, strong) NSMutableArray *validateComms;

-(NSString *)getIOSGuid;

@end
