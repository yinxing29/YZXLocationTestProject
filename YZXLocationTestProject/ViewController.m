//
//  ViewController.m
//  YZXLocationTestProject
//
//  Created by 尹星 on 2019/5/16.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "ViewController.h"
#import "YZXLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[YZXLocationManager shareManager] setAddressDetailsSuccessBlock:^(YZXLocationInfoModel *locationInfo, double longitude, double latitude) {
        NSLog(@"%@",locationInfo);
    } failBlock:^(NSError *error) {
        
    }];
    
    [[YZXLocationManager shareManager] startUpdateLocation];
}

@end
