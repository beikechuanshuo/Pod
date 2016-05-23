//
//  HDevice+Camera.m
//  Test
//
//  Created by C360_liyanjun on 15/12/14.
//  Copyright © 2015年 C360_liyanjun. All rights reserved.
//

#import "HDevice+Camera.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation HDevice (Camera)

- (HDeviceCameraType)deviceCameraType
{
    static HDeviceCameraType ret = HDeviceCameraType_None;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        if (devices == nil)
        {
            ret = HDeviceCameraType_None;
        }
        
        if ([devices count] == 1)
        {
            if ([(AVCaptureDevice *)[devices lastObject] position] == AVCaptureDevicePositionBack)
            {
                ret = HDeviceCameraType_OnlyBack;
            }
            else if ([(AVCaptureDevice *)[devices lastObject] position] == AVCaptureDevicePositionFront)
            {
                ret = HDeviceCameraType_OnlyFront;
            }
        }
        else if ([devices count] == 2)
        {
            ret = HDeviceCameraType_FrontAndBack;
        }
    });
    
    return ret;
}

/**
 *  检测是否有系统相册的权限
 *
 *  @return 权限正常返回YES 权限关闭返回NO
 */
- (BOOL)checkSysAlbumEnable
{
    BOOL isEnable = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined ||
           [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted ||
           [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied)
        {
            isEnable = NO;
        }
        else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized)
        {
            isEnable = YES;
        }
    }
    else
    {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined ||
            [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted ||
            [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied)
        {
            isEnable = NO;
        }
        else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
        {
            isEnable = YES;
        }
    }
    return isEnable;
}

- (BOOL)checkCameraEnable
{
    __block BOOL isEnable = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status)
        {
            case AVAuthorizationStatusNotDetermined:
            {
                __block BOOL isComplete = NO;
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
                 {
                     if (granted)
                     {
                         isEnable = YES;
                         isComplete = YES;
                     }
                     else
                     {
                         isEnable = NO;
                         isComplete = YES;
                     }
                 }];
                
                while (!isComplete)
                {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
            }
                break;
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
            {
                isEnable = NO;
            }
                break;
            case AVAuthorizationStatusAuthorized:
            {
                isEnable = YES;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        isEnable = YES;
    }
    return isEnable;
}


- (BOOL)supportedCaptureAnimation
{
    static BOOL supported = NO;
    static dispatch_once_t onceToken;
    __weak __typeof(self) weakSelf = self;
    dispatch_once(&onceToken,^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        switch (strongSelf.localizedModel)
        {
            case HDeviceLocalizedModel_iPhone1:
            case HDeviceLocalizedModel_iPhone3G:
            case HDeviceLocalizedModel_iPhone3GS:
            case HDeviceLocalizedModel_iPhone4:
            case HDeviceLocalizedModel_iPhone4S:
            case HDeviceLocalizedModel_iPad1:
            case HDeviceLocalizedModel_iPad2:
            case HDeviceLocalizedModel_iPad3:
            case HDeviceLocalizedModel_iPad4:
            case HDeviceLocalizedModel_iPadMini1:
            case HDeviceLocalizedModel_iPodTouch1:
            case HDeviceLocalizedModel_iPodTouch2:
            case HDeviceLocalizedModel_iPodTouch3:
            case HDeviceLocalizedModel_iPodTouch4:
            case HDeviceLocalizedModel_iWatch:
            case HDeviceLocalizedModel_AppleTV2:
            case HDeviceLocalizedModel_AppleTV3:
            case HDeviceLocalizedModel_Unknown:
            case HDeviceLocalizedModel_Simulator:
            {
                return;
            }
            default:
            {
                supported = YES;
                return;
            }
        }
    });
    
   return supported;
}


- (BOOL)supportedLowNight
{
    static BOOL supported = NO;
    static dispatch_once_t onceToken;
    __weak __typeof(self) weakSelf = self;
    dispatch_once(&onceToken,^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        switch (strongSelf.localizedModel)
        {
            case HDeviceLocalizedModel_iPhone1:
            case HDeviceLocalizedModel_iPhone3G:
            case HDeviceLocalizedModel_iPhone3GS:
            case HDeviceLocalizedModel_iPhone4:
            case HDeviceLocalizedModel_iPad1:
            case HDeviceLocalizedModel_iPad2:
            case HDeviceLocalizedModel_iPodTouch1:
            case HDeviceLocalizedModel_iPodTouch2:
            case HDeviceLocalizedModel_iPodTouch3:
            case HDeviceLocalizedModel_iPodTouch4:
            case HDeviceLocalizedModel_iWatch:
            case HDeviceLocalizedModel_AppleTV2:
            case HDeviceLocalizedModel_AppleTV3:
            case HDeviceLocalizedModel_Unknown:
            case HDeviceLocalizedModel_Simulator:
                return;
            default:
            {
                supported = YES;
                return;
            }
        }
    });
    return supported;
}

- (BOOL)supportedRealTimeDisplayedDevice
{
    static BOOL supported = NO;
    static dispatch_once_t onceToken;
    __weak __typeof(self) weakSelf = self;
    dispatch_once(&onceToken,^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        switch (strongSelf.localizedModel)
        {
            case HDeviceLocalizedModel_iPhone1:
            case HDeviceLocalizedModel_iPhone3G:
            case HDeviceLocalizedModel_iPhone3GS:
            case HDeviceLocalizedModel_iPhone4:
            case HDeviceLocalizedModel_iPad1:
            case HDeviceLocalizedModel_iPad2:
            case HDeviceLocalizedModel_iPodTouch1:
            case HDeviceLocalizedModel_iPodTouch2:
            case HDeviceLocalizedModel_iPodTouch3:
            case HDeviceLocalizedModel_iPodTouch4:
            case HDeviceLocalizedModel_iWatch:
            case HDeviceLocalizedModel_AppleTV2:
            case HDeviceLocalizedModel_AppleTV3:
            case HDeviceLocalizedModel_Unknown:
            case HDeviceLocalizedModel_Simulator:
                return;
            default:
            {
                supported = YES;
                return;
            }
        }
    });
    return supported;
}

- (BOOL)supportedGalleryCinema
{
    static BOOL supported = NO;
    static dispatch_once_t onceToken;
    __weak __typeof(self) weakSelf = self;
    dispatch_once(&onceToken,^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        switch (strongSelf.localizedModel)
        {
            case HDeviceLocalizedModel_iPhone1:
            case HDeviceLocalizedModel_iPhone3G:
            case HDeviceLocalizedModel_iPhone3GS:
            case HDeviceLocalizedModel_iPhone4:
            case HDeviceLocalizedModel_iPhone4S:
            case HDeviceLocalizedModel_iPad1:
            case HDeviceLocalizedModel_iPad2:
            case HDeviceLocalizedModel_iPadMini1:
            case HDeviceLocalizedModel_iPodTouch1:
            case HDeviceLocalizedModel_iPodTouch2:
            case HDeviceLocalizedModel_iPodTouch3:
            case HDeviceLocalizedModel_iPodTouch4:
            case HDeviceLocalizedModel_iPodTouch5:
            case HDeviceLocalizedModel_iWatch:
            case HDeviceLocalizedModel_AppleTV2:
            case HDeviceLocalizedModel_AppleTV3:
            case HDeviceLocalizedModel_Unknown:
            case HDeviceLocalizedModel_Simulator:
                supported = NO;
                break;
            default:
                supported = YES;
                break;
        }
    });
    return supported;
}

@end
