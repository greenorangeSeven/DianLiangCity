//
//  TTLocationService.h
//  TTLocationService
//
//  Created by Ma Jianglin on 2/22/14.
//  Copyright (c) 2014 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kNotificationLocationUpdated            @"totem.service.location.updated"
#define kNotificationReverseGeocodeFinished     @"totem.service.location.reversegeocode.finished"

@interface TTLocationService : NSObject<CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocation *location;  //位置信息

+(TTLocationService *)sharedService;    //单例

- (void)startUpdatingLocation;   //主动调用，更新当前位置

@end
