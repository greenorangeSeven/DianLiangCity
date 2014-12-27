//
//  TTLicenseService.m
//  DelightCity
//
//  Created by totem on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "TTLicenseService.h"

#define kLicense @"com.totemtec.license"

#define kCodeSuccess    1

static TTLicenseService *_sharedService = nil;

@implementation TTLicenseService

+(id)alloc
{
    @synchronized([TTLicenseService class])
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
    }
    
    return self;
}

+ (TTLicenseService*)sharedService
{
    @synchronized([TTLicenseService class])
    {
        if (!_sharedService)
        {
            _sharedService = [[TTLicenseService alloc] init];
        }
    }
    return _sharedService;
}

- (void)checkLicense
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        //优先使用服务器的License
        NSURL *url = [NSURL URLWithString:@"https://idemo.sinaapp.com/delightcity/license.json"];
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            NSDictionary *license = nil;
            
            if (data)
            {
                license = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
            
            if (license)
            {
                [prefs setObject:license forKey:kLicense];
                [prefs synchronize];
            }
            else
            {
                //使用本地缓存的License
                license = [prefs dictionaryForKey:kLicense];
            }
            
            if (license)
            {
                int code = [[license objectForKey:@"code"] intValue];
                if (code != kCodeSuccess)
                {
                    [self invalidLicense];
                }
            }
//            else
//            {
//                [self networkNotAvailable];
//            }
        });
    });
}

- (void)invalidLicense
{
    NSLog(@"Invalid License");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"无效的证书"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)networkNotAvailable
{
    NSLog(@"Network Not Available");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"网络链接错误，请检查网络后重试"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

@end
