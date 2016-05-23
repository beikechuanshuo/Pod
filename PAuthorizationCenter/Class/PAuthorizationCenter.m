//
//  PAuthorizationCenter.m
//  PAuthorizationCenter
//
//  Created by C360_liyanjun on 16/2/26.
//  Copyright © 2016年 C360_liyanjun. All rights reserved.
//

#import "PAuthorizationCenter.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>

@implementation PAuthorizationCenter

static CLLocationManager *locationManager = nil;
static bool didRegisterNotification = NO;

+ (void)requestNotificationsAuthorization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegisterNotification) name:kRegisterNotificationFinished object:nil];
    
    didRegisterNotification = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert
        | UIRemoteNotificationTypeBadge
        | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    while (!didRegisterNotification)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}


+ (BOOL)requestCaptureAuthorization
{
    __block BOOL captureEnable = NO;
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusNotDetermined:
        {
            __block BOOL isComplete = NO;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 isComplete = YES;
                 captureEnable = granted;
             }];
            
            while (!isComplete)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
            break;
        case AVAuthorizationStatusAuthorized:
            captureEnable = YES;
            break;
        default:
            break;
    }
    return captureEnable;
}

+ (void)requestSysAlbumAuthorization
{

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined)
        {
            __block BOOL isComplete = NO;
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                isComplete = YES;
            }];
            
            while (!isComplete)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
    }
    else
    {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined)
        {
            __block BOOL isComplete = NO;
            //第一次调用的时候 会弹出权限框
            [[ALAssetsLibrary new] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                isComplete = YES;
            } failureBlock:^(NSError *error) {
                isComplete = YES;
            }];
            
            while (!isComplete)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
    }
}

+ (void)requestLocationAuthorization
{
    if (![CLLocationManager locationServicesEnabled])
    {
        return ;
    }
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        if (!locationManager)
        {
            locationManager = [CLLocationManager new];
        }
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        {
            [locationManager requestWhenInUseAuthorization];
        }
        
        BOOL isComplete = NO;
        while (!isComplete)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined)
            {
                isComplete = YES;
            }
        }
    }
}

+ (BOOL)requestAudioAuthorization
{
    __block BOOL enable = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)])
    {
        __block BOOL isComplete = NO;
        [session requestRecordPermission:^(BOOL granted) {
            
            isComplete = YES;
            enable = granted;
            
        }];
        
        while (!isComplete)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    else
    {
        enable = YES;
    }
    
    return enable;
}

#pragma mark - 私有方法

//仅仅用于传值
+ (void)didRegisterNotification
{
    didRegisterNotification = YES;
}



@end
