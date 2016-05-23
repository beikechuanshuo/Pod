//
//  HDevice+Location.m
//  Test
//
//  Created by C360_liyanjun on 15/12/14.
//  Copyright © 2015年 C360_liyanjun. All rights reserved.
//

#import "HDevice+Location.h"
#import <objc/runtime.h>

#if __has_include(<JZLocationConverter.h>)
#import <JZLocationConverter.h>
#endif

@implementation HDevice (Location)

static const void *temLocationManager = &temLocationManager;
static const void *temGeocoder = &temGeocoder;
static const void *temCurLocation = &temCurLocation;
static const void *temPlacemark = &temPlacemark;
static const void *temCurLocationServiceStatus = &temCurLocationServiceStatus;
static const void *temShouldTrackLocationOnBackground = &temShouldTrackLocationOnBackground;

@dynamic curLocation;
@dynamic placemark;
@dynamic curLocationServiceStatus;
@dynamic locationManager;
@dynamic geocoder;
@dynamic shouldTrackLocationOnBackground;

- (void)init_location
{
    //初始化地理位置manager
    CLLocationManager *locationManager = ([[CLLocationManager alloc] init]);
    self.locationManager = locationManager;
    self.locationManager.delegate= self;
    self.geocoder = [[CLGeocoder alloc] init];
    self.curLocationServiceStatus = [CLLocationManager authorizationStatus];
}

- (void)dealloc_location
{
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.geocoder = nil;
}

- (CLLocation *)curLocation
{
    return objc_getAssociatedObject(self, temCurLocation);
}

- (void)setCurLocation:(CLLocation *)curLocation
{
    objc_setAssociatedObject(self, temCurLocation, curLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLPlacemark *)placemark
{
    return objc_getAssociatedObject(self, temPlacemark);
}

- (void)setPlacemark:(CLPlacemark *)placemark
{
    objc_setAssociatedObject(self, temPlacemark, placemark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLAuthorizationStatus)curLocationServiceStatus
{
    return [CLLocationManager authorizationStatus];
}

- (void)setCurLocationServiceStatus:(CLAuthorizationStatus)curLocationServiceStatus
{
    objc_setAssociatedObject(self, temCurLocationServiceStatus, @(curLocationServiceStatus), OBJC_ASSOCIATION_ASSIGN);
}

- (CLLocationManager *)locationManager
{
    return objc_getAssociatedObject(self, temLocationManager);
}

- (void)setLocationManager:(CLLocationManager *)locationManager
{
    objc_setAssociatedObject(self, temLocationManager, locationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLGeocoder *)geocoder
{
    return objc_getAssociatedObject(self, temGeocoder);
}

- (void)setGeocoder:(CLGeocoder *)geocoder
{
    objc_setAssociatedObject(self, temGeocoder, geocoder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldTrackLocationOnBackground
{
    return [objc_getAssociatedObject(self, temShouldTrackLocationOnBackground) boolValue];
}

- (void)setShouldTrackLocationOnBackground:(BOOL)shouldTrackLocationOnBackground
{
    objc_setAssociatedObject(self, temShouldTrackLocationOnBackground, @(shouldTrackLocationOnBackground), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)curLocationServiceEnabled
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (BOOL)startUpdateLocation
{
    if (![CLLocationManager locationServicesEnabled])
    {
        return NO;
    }
    //iOS8之后需要先调用此方法，才能开启定位服务
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        if (self.shouldTrackLocationOnBackground)
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        else
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    if ((self.locationManager != nil) && ([CLLocationManager locationServicesEnabled]))
    {
        [self.locationManager startUpdatingLocation];
        return YES;
    }
    return NO;
}

#pragma mark 地理位置相关回调
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
     self.curLocationServiceStatus = status;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLocationUpdateError
                                                        object:error];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
#if __has_include(<JZLocationConverter.h>)
    CLLocation *wgs84Location  = locations.lastObject;
    
    // 世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
    CLLocationCoordinate2D gcj02Coordinate2d = [JZLocationConverter wgs84ToGcj02:wgs84Location.coordinate];
    
    self.curLocation = [[CLLocation alloc] initWithLatitude:gcj02Coordinate2d.latitude
                                              longitude:gcj02Coordinate2d.longitude];
#else
    self.curLocation = locations.lastObject;
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLocationUpdated
                                                        object:self.curLocation];
    
    [manager stopUpdatingLocation];
    
    [self reverseGeoCodeLocations];
}

- (void)reverseGeoCodeLocations
{
    if (self.curLocation)
    {
        __weak __typeof(self) weakSelf = self;
        [self.geocoder reverseGeocodeLocation:self.curLocation completionHandler:^(NSArray *placemarks,
                                                                               NSError *error)
         {
             __strong __typeof(weakSelf) strongSelf = weakSelf;
             if (placemarks.count > 0)
             {
                 strongSelf.placemark = (CLPlacemark *)placemarks.firstObject;
             }
             if (error || (placemarks == nil))
             {

             }
        }];
    }
}

@end
