//
//  YZXLocationInfoModel.m
//  YZXLocationTestProject
//
//  Created by 尹星 on 2019/5/16.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXLocationInfoModel.h"

@implementation YZXLocationInfoModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n name: %@, \n thoroughfare: %@, \n subThoroughfare: %@, \n locality: %@, \n subLocality: %@, \n administrativeArea: %@, \n subAdministrativeArea: %@, \n postalCode: %@, \n ISOcountryCode: %@, \n country: %@, \n inlandWater: %@, \n ocean: %@, \n areasOfInterest: %@, \n FormattedAddressLines: %@",_name, _thoroughfare, _subThoroughfare, _locality, _subLocality, _administrativeArea, _subAdministrativeArea, _postalCode, _ISOcountryCode, _country, _inlandWater, _ocean, _areasOfInterest, _FormattedAddressLines];
}

@end
