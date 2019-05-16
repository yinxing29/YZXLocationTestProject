# YZXLocationTestProject - 定位服务

## YZXLocationManager （定位管理类）
> 公共方法
* `+shareManager`: 单例
* `-getStatusPermission`: 获取定位权限，**需要在AppDelegate中调用该方法，告诉系统我需要获取定位权限，否则系统不会自动弹出“是否允许获取位置信息的弹窗”**
* `-startUpdateLocation`: 开始定位，当用户允许获取定位，则开始定位，如果未允许，则会弹窗提示用户前往设置允许定位。
* `-setAddressDetailsSuccessBlock:failBlock:`: 设置定位成功和失败的block。**需要在`-startUpdateLocation`方法之前调用，否则可能导致无法实现回调**

## YZXLocationInfoModel: 定位信息model.
```Objc-C
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
```