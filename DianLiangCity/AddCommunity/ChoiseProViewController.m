//
//  ChoiseCityViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-25.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "ChoiseProViewController.h"
#import "BackButton.h"
#import <CoreLocation/CoreLocation.h>
#import "CityModel.h"

@interface ChoiseProViewController () <UITableViewDataSource, CLLocationManagerDelegate>
{
    NSMutableArray *cityArray;
    MBProgressHUD *hud;
    int selectIndex;
    
    double latitude;
    double longitude;
    
    NSArray *regionModelArray;
    
    ProvinceModel *selectProvinceModel;
    CityModel     *selectCityModel;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ChoiseProViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        if (IS_IOS8) {
            [self.locationManager requestAlwaysAuthorization];
        }
        self.locationManager.delegate = self;
    }else {
        //提示用户无法进行定位操作
    }
    
    
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableHeaderView:self.headerView];
    [self initCitys];
    
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    latitude =  coor.latitude;
    longitude = coor.longitude;
    if(latitude > 0 || longitude > 0)
    {
        [self locationCity];
        [self.locationManager stopUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

}

//初始化省市区信息
- (void)initCitys
{
    [Tool showHUD:@"正在加载" andView:self.view andHUD:hud];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EGOCache *cache = [EGOCache globalCache];
        cityArray = (NSMutableArray *)[cache objectForKey:@"procityarea"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!cityArray || cityArray.count == 0)
            {
                //如果有网络连接
                if ([UserModel Instance].isNetworkRunning)
                {
                    NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"%@%@?APPKey=%@", api_base_url, api_get_region, api_key];
                    NSString *url = [NSString stringWithString:tempUrl];
                    [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                               success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                                   @try
                                                   {
                                                       EGOCache *cache = [EGOCache globalCache];
                                                       cityArray = [Tool readJsonStrToRegionArray:operation.responseString];
                                                       if(cityArray && cityArray.count > 0)
                                                       {
                                                           [cache setObject:cityArray forKey:@"procityarea"];
                                                       }
                                                       self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                       
                                                       [self.tableView reloadData];
                                                       // 开始定位
                                                       [self.locationManager startUpdatingLocation];
                                                   }
                                                   @catch (NSException *exception) {
                                                       [NdUncaughtExceptionHandler TakeException:exception];
                                                   }
                                                   @finally
                                                   {
                                                       [hud hide:YES];
                                                   }
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   if ([UserModel Instance].isNetworkRunning == NO) {
                                                       return;
                                                   }
                                                   if ([UserModel Instance].isNetworkRunning) {
                                                       [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                                   }
                                               }];
                }
            }
            else
            {
                [hud hide:YES];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [self.tableView reloadData];
                // 开始定位
                [self.locationManager startUpdatingLocation];
            }
        });
    });
}

//初始化定位城市信息
- (void)locationCity
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning)
    {
        [Tool showHUD:@"正在定位" andView:self.view andHUD:hud];
        //                    "http://api.map.baidu.com/geocoder?output=json&location=" + latitude + "," + longitude;
        NSMutableString *tempUrl = [NSMutableString stringWithFormat:@"http://api.map.baidu.com/geocoder?output=json&location=%f,%f", latitude, longitude];
        NSString *url = [NSString stringWithString:tempUrl];
        [[AFOSCClient sharedClient]getPath:url parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                       @try
                                       {
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSError *error;
                                           NSDictionary *locationDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           NSString *provinceStr = [[[locationDic objectForKey:@"result"] objectForKey:@"addressComponent"] objectForKey:@"province"];
                                           NSString *cityStr = [[[locationDic objectForKey:@"result"] objectForKey:@"addressComponent"] objectForKey:@"city"];
                                           NSString *provinceTmpStr = [provinceStr substringWithRange:NSMakeRange(0, [provinceStr length] -1)];
                                           NSString *cityTmpStr = [cityStr substringWithRange:NSMakeRange(0, [provinceStr length] -1)];
                                           [self.locationCityBtn setTitle:[NSString stringWithFormat:@"%@->%@", provinceStr, cityStr] forState:UIControlStateNormal];
                                           NSArray *city2Array = [[NSArray alloc] init];
                                           
                                           //遍历省获得定位省的城市数据
                                           for (ProvinceModel *pro in cityArray) {
                                               if ([pro.name isEqualToString:provinceTmpStr]) {
                                                   selectProvinceModel = pro;
                                                   city2Array = pro.cityArray;
                                                   //遍历市获得定位市的区数据
                                                   for (CityModel *city in city2Array) {
                                                       if ([city.name isEqualToString:cityTmpStr]) {
                                                           selectCityModel = city;
                                                           break;
                                                       }
                                                   }
                                                   break;
                                               }
                                           }
                                           RegionModel *reg = [regionModelArray objectAtIndex:0];
                                           NSLog(@"%@", reg.name);
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally
                                       {
                                           [hud hide:YES];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                       }
                                   }];
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"chooseCommCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCommCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    ProvinceModel *provinceModel = [cityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = provinceModel.name;
    cell.imageView.image = [UIImage imageNamed:@"jzfw_arrow"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ChoiseCityView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChoiseCityView"])
    {
        UIViewController *controller = [segue destinationViewController];
        [controller setValue:[cityArray objectAtIndex:selectIndex] forKey:@"selectProvinceModel"];
    }
    if([segue.identifier isEqualToString:@"ChoiseAreaViewController"])
    {
        UIViewController *viewController = [segue destinationViewController];
        [viewController setValue:selectProvinceModel forKey:@"selectProvinceModel"];
        [viewController setValue:selectCityModel forKey:@"selectCityModel"];
    }
}

- (IBAction)locationCityAction:(id)sender {
    if([self.locationCityBtn.titleLabel.text length] > 0)
    {
        [self performSegueWithIdentifier:@"ChoiseAreaViewController" sender:self];
    }
}
@end
