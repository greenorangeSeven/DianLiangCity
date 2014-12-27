//
//  TTNotificationService.m
//  TTCommon
//
//  Created by Ma Jianglin on 3/20/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTNotificationService.h"
#import "AFNetworking.h"
#import "UIDevice+Extensions.h"
#import "micro.h"

static TTNotificationService *_sharedService = nil;

@implementation TTNotificationService

+(id)alloc
{
    @synchronized([TTNotificationService class])
    {
        NSAssert(_sharedService == nil, @"Attempted to allocate a second instance of a singleton.");
        return [super alloc];
    }
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

+ (TTNotificationService *)sharedService
{
    @synchronized([TTNotificationService class])
    {
        if (!_sharedService)
        {
            _sharedService = [[TTNotificationService alloc] init];
        }
    }
    return _sharedService;
}

-(void)registerForRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge
      | UIRemoteNotificationTypeSound
      | UIRemoteNotificationTypeAlert)];
    
#endif
}

- (void)successRegisterWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    self.deviceToken = token;
    
    TTLog(@"device token: %@", self.deviceToken);
    
    [self postDeviceToken];
}

- (void)failedRegisterWithError:(NSError*)error
{
    TTLog(@"%@", error);
    
    self.deviceToken = @"";
    [self postDeviceToken];
}

- (void)postDeviceToken
{
    //拿到deviceToken后才进行发送给服务器
    if (self.deviceToken == nil)
    {
        return;
    }
    
//    NSString *userId = @"";
//    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
//    NSString *deviceType = @"iOS";
//    NSDictionary *params =
//    @{@"device_id":deviceId
//      , @"device_type":deviceType
//      , @"device_token":self.deviceToken
//      , @"userid":userId};
    
//    NSURL *url = [NSURL URLWithString:SERVER_URL];
//    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
//    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:DEVICE_TOKEN_PATH parameters:params];
//    
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//     {
//         id code = [JSON objectForKey:@"code"];
//         if (code && [code intValue] == SUCCESS_CODE)
//         {
//             TTLog(@"设备令牌登记成功");
//         }
//         else
//         {
//             TTLog(@"设备令牌登记失败，服务器错误");
//         }
//     }
//     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
//     {
//         TTLog(@"设备令牌登记失败，网络错误");
//     }];
//    [operation start];
}

- (void)applicationDidEnterBackground:(NSNotification*)notification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(NSNotification*)notification
{
    [self postDeviceToken];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
