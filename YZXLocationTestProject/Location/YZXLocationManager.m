//
//  YZXLocationManager.m
//  YZXLocationTestProject
//
//  Created by 尹星 on 2019/5/16.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface YZXLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager       *locationManager;

@property (nonatomic, assign) BOOL                    isStartUpdateLocation;

@property (nonatomic, copy) YZXLocationSuccessBlock          successBlock;

@property (nonatomic, copy) YZXLocationFailBlock             failBlock;

@end

@implementation YZXLocationManager

+ (instancetype)shareManager
{
    static YZXLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YZXLocationManager alloc] init];
    });
    return manager;
}

#pragma mark - 公共方法
- (void)getStatusPermission
{
    // 用户已决定
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
        return;
    }
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)startUpdateLocation
{
    // 判断定位服务是否开启
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    self.locationManager.delegate = self;
    self.isStartUpdateLocation = NO;
    // 判断app定位功能状态
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未决定");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"定位服务授权状态受限制，用户不能改变。");
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"定位服务授权被用户明确禁止");
            [self p_showToolTip];
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            self.isStartUpdateLocation = YES;
            [self.locationManager startUpdatingLocation];
            NSLog(@"定位服务授权状态被用户允许在任何状态下获取位置信息");
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            self.isStartUpdateLocation = YES;
            [self.locationManager startUpdatingLocation];
            NSLog(@"定位服务授权状态仅被允许在使用程序的时候");
        }
            break;
    }
}

- (void)setAddressDetailsSuccessBlock:(YZXLocationSuccessBlock)successBlock
                            failBlock:(YZXLocationFailBlock)failBlock
{
    self.successBlock = successBlock;
    self.failBlock = failBlock;
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 私有方法
- (void)p_showToolTip
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否打开\"定位服务\"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (self.failBlock) {
            self.failBlock(nil);
        }
        [self p_removeBlock];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
        [vc presentViewController:alertController animated:YES completion:nil];
    });
}

// 移除block，防止内存泄漏
- (void)p_removeBlock
{
    self.successBlock = nil;
    self.failBlock = nil;
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // 用户已允许定位的情况下，刚启动第一次定位的时候，调用"startUpdatingLocation"方法会触发该方法，导致重复走 "startUpdatingLocation" 方法。
    if (!self.isStartUpdateLocation && (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"longitude = %lf, latitude = %lf",locations.lastObject.coordinate.longitude,locations.lastObject.coordinate.latitude);
    
    CLLocation *newLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                
                NSString *city = placemark.locality;
                if (!city) {
                    city = placemark.administrativeArea;
                }
                if (self.successBlock) {
                    YZXLocationInfoModel *infoModel = [[YZXLocationInfoModel alloc] init];
                    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
                        infoModel.name = placemark.name;
                        infoModel.thoroughfare = placemark.thoroughfare;
                        infoModel.subThoroughfare = placemark.subThoroughfare;
                        infoModel.locality = placemark.locality;
                        infoModel.subLocality = placemark.subLocality;
                        infoModel.administrativeArea = placemark.administrativeArea;
                        infoModel.subAdministrativeArea = placemark.subAdministrativeArea;
                        infoModel.postalCode = placemark.postalCode;
                        infoModel.ISOcountryCode = placemark.ISOcountryCode;
                        infoModel.country = placemark.country;
                        infoModel.inlandWater = placemark.inlandWater;
                        infoModel.ocean = placemark.ocean;
                        infoModel.areasOfInterest = placemark.areasOfInterest;
                        infoModel.FormattedAddressLines = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country ? : @"",placemark.administrativeArea ? : @"",placemark.locality ? : @"",placemark.subLocality ? : @"",placemark.thoroughfare ? : @"",placemark.subThoroughfare ? : @""];
                        self.successBlock(infoModel, locations.lastObject.coordinate.longitude,locations.lastObject.coordinate.latitude);
                    }else {
                        NSDictionary *dic = placemark.addressDictionary;
                        infoModel.name = dic[@"Name"];
                        infoModel.country = dic[@"Country"];
                        infoModel.ISOcountryCode = dic[@"CountryCode"];
                        infoModel.subLocality = dic[@"SubLocality"];
                        infoModel.thoroughfare = dic[@"Thoroughfare"];
                        if ([dic[@"FormattedAddressLines"] isKindOfClass:[NSArray class]]) {
                            infoModel.FormattedAddressLines = [dic[@"FormattedAddressLines"] firstObject];
                        }
                        self.successBlock(infoModel, locations.lastObject.coordinate.longitude,locations.lastObject.coordinate.latitude);
                    }
                }
                [self p_removeBlock];
            }else if ([placemarks count] == 0) {
                NSLog(@"定位城市失败");
            }else {
                NSLog(@"请检查您的网络");
            }
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];

    if (self.failBlock) {
        self.failBlock(error);
    }
    [self p_removeBlock];
    NSLog(@"定位失败");
}


#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
