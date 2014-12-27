//
//  TTLocationService.m
//  TTLocationService
//
//  Created by Ma Jianglin on 2/22/14.
//  Copyright (c) 2014 totemtec.com. All rights reserved.
//

#import "TTLocationService.h"

#define TIMEOUT_SECONDS     10.0    //超时秒数
#define UPDATE_SECONDS      0   //位置更新时间，如果是0，则不主动更新

//北京市西单地铁站的经纬度坐标
#define DEFAULT_LOCATION_LATITUDE       39.9074
#define DEFAULT_LOCATION_LONGITUDE      116.3742

#define kStateLocationTimeout           @"定位超时"
#define kStateLocationDenied            @"未打开定位服务"
#define kStateLocationFailure           @"定位失败"


#pragma mark - Private

@interface TTLocationService()
{
    CLLocationManager *_locationManager;
}

@end


#pragma mark - Singleton

static TTLocationService *_sharedService = nil;

@implementation TTLocationService

@synthesize location=_location;

+(id)alloc
{
    @synchronized([TTLocationService class])
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

+ (TTLocationService *)sharedService
{
    @synchronized([TTLocationService class])
    {
        if (!_sharedService)
        {
            _sharedService = [[TTLocationService alloc] init];
        }
    }
    return _sharedService;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation:");
    //水平精度小于0，无效的位置
	if (newLocation.horizontalAccuracy < 0)
    {
        NSLog(@"水平精度小于0，无效的位置");
        return;
    }
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > TIMEOUT_SECONDS)
    {
        NSLog(@"位置信息时间戳太老，无效的位置 locationAge > %.1f", TIMEOUT_SECONDS);
        return;
    }
    
    //水平精度小于期望的精度，合格！
    if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy)
    {
        NSLog(@"new location:%f-----%f, accuracy:%f, server accuracy:%f", newLocation.coordinate.longitude, newLocation.coordinate.latitude, newLocation.horizontalAccuracy, _locationManager.desiredAccuracy);
        
        self.location = newLocation;
        
        // after recieving a location, stop updating
        [self stopUpdatingLocation:nil];
        
        //自动更新位置信息
        if (UPDATE_SECONDS > 0.1)
        {
            [self performSelector:@selector(startUpdatingLocation) withObject:nil afterDelay:UPDATE_SECONDS];
        }
    }
    else
    {
        NSLog(@"newLocation.horizontalAccuracy > _locationManager.desiredAccuracy");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    // 用户拒绝App访问位置信息
    if ([error code] == kCLErrorDenied)
    {
        [self handleUserDenied];
    }
    else if ([error code] == kCLErrorLocationUnknown)
    {
        //位置不可用，继续尝试定位
        return;
    }
    
    // stop updating
    [self stopUpdatingLocation:kStateLocationFailure];
    
    // 定位失败，使用默认地址
    self.location = [self defaultLocation];
}

#pragma mark - Start and Stop

- (void)startUpdatingLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationUpdated object:kStateLocationDenied];
        
        return;
    }
    
    // if locationManager does not currently exist, create it
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.headingFilter = kCLHeadingFilterNone;
//        _locationManager.purpose = @"定位所在城市";
    }
    
    [_locationManager startUpdatingLocation];
    
    //处理超时
    [self performSelector:@selector(stopUpdatingLocation:) withObject:kStateLocationTimeout afterDelay:TIMEOUT_SECONDS];
}

- (void)stopUpdatingLocation:(id)state
{
    //取消处理超时
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationUpdated object:state];
    
    [_locationManager stopUpdatingLocation];
    
    //进行反地理编码
    [self performSelectorInBackground:@selector(reverseGeocode:) withObject:nil];
}

#pragma mark - Location Failure

#define kCoordinate         @"totem.service.location.coordinate"
#define kLatitude           @"latitude"
#define kLongitude          @"longitude"

//存储成功定位的经纬度
- (void)setLocation:(CLLocation *)location
{
    _location = location;
    if (_location)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        NSNumber *longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        NSDictionary *coor = @{ kLatitude: latitude,  kLongitude: longitude};
        [prefs setObject:coor forKey:kCoordinate];
        [prefs synchronize];
    }
}


//获取定位坐标
- (CLLocation*)location
{
    //超时的错误处理
    if (_location == nil)
    {
        //使用默认位置或上次位置
        _location = [self defaultLocation];
    }
    
    return _location;
}

//读取上次定位的经纬度
- (CLLocation*)defaultLocation
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    double latitude = DEFAULT_LOCATION_LATITUDE;
    double longitude = DEFAULT_LOCATION_LONGITUDE;
    
    //取上次定位的坐标
    NSDictionary *coordinate = [prefs dictionaryForKey:kCoordinate];
    if (coordinate)
    {
        latitude = [[coordinate objectForKey:kLatitude] doubleValue];
        longitude = [[coordinate objectForKey:kLongitude] doubleValue];
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                      longitude:longitude];
    
    return location;
}

- (void)handleUserDenied
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开启定位服务"
                                                    message:@"请通过 [设置]->[隐私]->[定位服务] 来打开定位服务"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Apple Map Reverse Geocoder

//- (void)reverseGeocode:(id)sender
//{
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    [geocoder reverseGeocodeLocation:self.location
//                   completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//        if (error)
//        {
//            NSLog(@"Geocode failed with error: %@", error);
//            return;
//        }
//        NSLog(@"Received placemarks: %@", placemarks);
//    }];
//}

#pragma mark - Reverse Geocoder using Baidu HTTP

- (void)reverseGeocode:(id)sender
{
    if (self.location == nil) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        CLLocationCoordinate2D coor = self.location.coordinate;
        NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?location=%.4f,%.4f&output=json&key=user_key", coor.latitude, coor.longitude];
        NSURL *url = [NSURL URLWithString:str];
        
        id info = nil;
        
        
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:url
                                             options:NSDataReadingMappedIfSafe
                                               error:&error];
        
        
        if (error || data == nil)
        {
            NSLog(@"reverseGeocode: request error = %@", error);
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            if (error || dict == nil)
            {
                NSLog(@"reverseGeocode: data error: %@", error);
            }
            else
            {
                NSString *status = [dict objectForKey:@"status"];
                if ([status isEqualToString:@"OK"])
                {
                    NSString *city = [[[dict objectForKey:@"result"] objectForKey:@"addressComponent"] objectForKey:@"city"];
                    
                    info = city;
                }
            }
        }
        
        NSLog(@"reverseGeocode: info = %@", info);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReverseGeocodeFinished object:info];
    });
}


#pragma mark - Baidu Map Reverse Geocoder

//- (void) reverseGeocode:(id)sender
//{
//    @autoreleasepool
//    {
//        if (_search == nil)
//        {
//            _search = [[BMKSearch alloc] init];
//            _search.delegate = self;
//        }
//        [_search reverseGeocode:self.location.coordinate];
//    }
//}
//
//- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
//{
//	if (error == BMKErrorOk && result)
//    {
//        self.addressComponent = [result addressComponent];
//	}
//    else
//    {
//        TTLog(@"Baidu Map Reverse Geocoder has failed. error = %i", error);
//    }
//    
//    NSNotification *notification = [NSNotification notificationWithName:kNotificationReverseGeocoderDidFinish object:self.addressComponent];
//    
//    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
//                                               postingStyle:NSPostWhenIdle
//                                               coalesceMask:NSNotificationNoCoalescing
//                                                   forModes:nil];
//}

@end
