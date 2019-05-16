//
//  YZXLocationManager.h
//  YZXLocationTestProject
//
//  Created by 尹星 on 2019/5/16.
//  Copyright © 2019 尹星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZXLocationInfoModel.h"

typedef void (^YZXLocationSuccessBlock)(YZXLocationInfoModel *locationInfo);
typedef void (^YZXLocationFailBlock)(NSError *error);

@interface YZXLocationManager : NSObject

+ (instancetype)shareManager;

/**
 获取定位权限
 */
- (void)getStatusPermission;

/**
 开始定位
 */
- (void)startUpdateLocation;

/**
 定位结果回调

 @param successBlock 定位成功
 @param failBlock 定位失败
 */
- (void)setAddressDetailsSuccessBlock:(YZXLocationSuccessBlock)successBlock
                            failBlock:(YZXLocationFailBlock)failBlock;

@end
