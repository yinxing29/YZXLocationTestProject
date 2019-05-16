//
//  YZXLocationInfoModel.h
//  YZXLocationTestProject
//
//  Created by 尹星 on 2019/5/16.
//  Copyright © 2019 尹星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZXLocationInfoModel : NSObject

/**
 name(eg:民主西路472号)
 */
@property (nonatomic, copy, nullable) NSString *name;

/**
 街
 */
@property (nonatomic, copy, nullable) NSString *thoroughfare;
@property (nonatomic, copy, nullable) NSString *subThoroughfare;

/**
 城市
 */
@property (nonatomic, copy, nullable) NSString *locality;

/**
 县(区)
 */
@property (nonatomic, copy, nullable) NSString *subLocality;

/**
 省份(州)
 */
@property (nonatomic, copy, nullable) NSString *administrativeArea;
@property (nonatomic, copy, nullable) NSString *subAdministrativeArea;

/**
 邮编
 */
@property (nonatomic, copy, nullable) NSString *postalCode;

/**
 国家国际编码
 */
@property (nonatomic, copy, nullable) NSString *ISOcountryCode;

/**
 国家
 */
@property (nonatomic, copy, nullable) NSString *country;

/**
 内河
 */
@property (nonatomic, copy, nullable) NSString *inlandWater;

/**
 海
 */
@property (nonatomic, copy, nullable) NSString *ocean;

/**
 附近的热门地区
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *areasOfInterest;

/**
 格式化地址（完整地址）
 */
@property (nonatomic, copy, nullable) NSString *FormattedAddressLines;

/**
 纬度
 */
@property (nonatomic, assign) double           lat;

/**
 经度
 */
@property (nonatomic, assign) double           lon;

@end
