//
//  HDevice+Location.h
//  Test
//
//  Created by C360_liyanjun on 15/12/14.
//  Copyright © 2015年 C360_liyanjun. All rights reserved.
//

#import "HDevice.h"
#import <CoreLocation/CoreLocation.h>

/**
 *  地理位置已经更新的通知key，返回的object是新的地理位置对象
 */
#define HLocationUpdated                                              @"HLocationUpdated"

/**
 *  地理位置更新出错通知key，返回的object是NSError对象
 */
#define HLocationUpdateError                                          @"HLocationUpdateError"

@interface HDevice (Location)<CLLocationManagerDelegate>

/**
 * 以下两个变量为扩展私有属性，请不要使用。
 */
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geocoder;

/**
 *  当前位置，没有取到时为nil，在下次获得更新之前为上次更新的位置
 */
@property (nonatomic, readonly) CLLocation *curLocation;

/**
 *  地理位置信息，城市、街道名等，当获取到当前位置后，自动到服务器查询，如果还未查询到则为nil
 */
@property (nonatomic, readonly) CLPlacemark *placemark;

/*
 * 当前地理位置服务状态
 */
@property (nonatomic, readonly) CLAuthorizationStatus curLocationServiceStatus;

/**
 * 当前地理位置是否可用
 */
@property (nonatomic, readonly) BOOL curLocationServiceEnabled;


/**
 * 请求后台地理位置权限
 */
@property (nonatomic, assign) BOOL shouldTrackLocationOnBackground;

/**
 *  开始更新地理位置信息
 *
 *  @return 成功开始更新返回YES 否则返回NO
 *  @ref 通过是使用 PGLocationUpdated 和 PGLocationUpdateError 进行监听，得到更新后的数据
 curLocation 为Notification Object 获取
 */
- (BOOL)startUpdateLocation;

@end
