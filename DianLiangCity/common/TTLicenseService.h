//
//  TTLicenseService.h
//  DelightCity
//
//  Created by totem on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLicenseService : NSObject

+ (id)sharedService;

- (void)checkLicense;

@end
