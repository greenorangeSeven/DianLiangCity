//
//  UserModel.m
//  zhxq
//
//  Created by Seven on 13-9-21.
//
//

#import "UserModel.h"
#import "AESCrypt.h"

@implementation UserModel

@synthesize isNetworkRunning;

static UserModel * instance = nil;
+(UserModel *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

-(BOOL)isLogin
{
    if(self.userInfo)
        return YES;
    else
    {
        EGOCache *cache = [EGOCache globalCache];
        self.userInfo = (UserInfo *)[cache objectForKey:@"userinfo"];
        if(self.userInfo)
            return YES;
    }
    return NO;
}

-(void)saveAccount:(NSString *)account andPwd:(NSString *)pwd
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user removeObjectForKey:@"Account"];
    [user setObject:account forKey:@"Account"];
    
    [user removeObjectForKey:@"Password"];
    pwd = [AESCrypt encrypt:pwd password:@"pwd"];
    [user setObject:pwd forKey:@"Password"];
    
    [user synchronize];
}

-(void)logoutUser
{
    if(self.isLogin)
    {
        EGOCache *cache = [EGOCache globalCache];
        [cache removeCacheForKey:@"userinfo"];
        self.userInfo = nil;
    }
}

-(void)saveUserInfo:(UserInfo *)userinfo
{
    self.userInfo = userinfo;
    EGOCache *cache = [EGOCache globalCache];
    [cache setObjectForSync:userinfo forKey:@"userinfo"];
}

-(UserInfo *)getUserInfo
{
    if(!self.userInfo)
    {
        EGOCache *cache = [EGOCache globalCache];
        self.userInfo = (UserInfo *)[cache objectForKey:@"userinfo"];
    }
    return self.userInfo;
}

-(NSString *)getIOSGuid
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"guid"];
    if (value && [value isEqualToString:@""] == NO) {
        return value;
    }
    else
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        [settings setObject:uuidString forKey:@"guid"];
        [settings synchronize];
        return uuidString;
    }
}

@end
