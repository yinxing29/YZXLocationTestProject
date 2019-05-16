# YZXLocationTestProject - 定位服务

## YZXLocationManager （定位管理类）
> 公共方法
* `+shareManager`: 单例
* `-getStatusPermission`: 获取定位权限，**需要在AppDelegate中调用该方法，告诉系统我需要获取定位权限，否则系统不会自动弹出“是否允许获取位置信息的弹窗”**
* `-startUpdateLocation`: 开始定位，当用户允许获取定位，则开始定位，如果未允许，则会弹窗提示用户前往设置允许定位。
* `-setAddressDetailsSuccessBlock:failBlock:`: 设置定位成功和失败的block。**需要在`-startUpdateLocation`方法之前调用，否则可能导致无法实现回调**

> 遇到的坑
    1. **问题1:**在`startUpdateLocation`方法中，会判断app的定位权限状态，当用户允许定位的时候才调用`CLLocationManager`的`startUpdatingLocation`方法开始定位。 导致第一次启动app时，如果app在启动的时候就需要获取定位，在调用`startUpdateLocation`时状态判断为`kCLAuthorizationStatusNotDetermined`用户为决定，致使如果用户允许了定位，而第一次无法定位。
    **解决办法：实现`CLLocationManagerDelegate`的代理方法`locationManager:didChangeAuthorizationStatus:`，在用户允许定位的时候，在该方法中判断权限状态，允许时调用`[self.locationManager startUpdatingLocation]`开始定位。**
    2. **问题2：** 为了满足`1`，在用户允许了获取定位后，每次进入app第一次定位的时候，都会触发一次`CLLocationManagerDelegate`的代理方法`locationManager:didChangeAuthorizationStatus:`，导致`CLLocationManager`的`startUpdatingLocation`会走两次。
     **解决办法：添加一个属性记录是否已经调用了`CLLocationManager`的`startUpdatingLocation`方法，如果调用了，则不重复调用。**
    3. **问题2：**因为`YZXLocationManager`是单例，所以设置了`YZXLocationSuccessBlock`和`YZXLocationFailBlock`后，在其回调中如果使用了`其他对象`会形成相互引用，导致内存泄漏。
    **解决办法：在`YZXLocationManager`中，调用了block之后，就将`YZXLocationSuccessBlock`和`YZXLocationFailBlock`置为nil**
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