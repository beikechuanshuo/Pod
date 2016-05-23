//
//  HDevice+Camera.h
//  Test
//
//  Created by C360_liyanjun on 15/12/14.
//  Copyright © 2015年 C360_liyanjun. All rights reserved.
//

#import "HDevice.h"

//设备是否有摄像头
typedef NS_ENUM(NSInteger, HDeviceCameraType)
{
    HDeviceCameraType_None,         //设备不含摄像头
    HDeviceCameraType_OnlyFront,    //设置只含前置摄像头
    HDeviceCameraType_OnlyBack,     //设备只含后置摄像头
    HDeviceCameraType_FrontAndBack, //设备含有前置和后置摄像头
};

@interface HDevice (Camera)

/**
 *  获取当前设备的摄像头存在情况
 */
@property (nonatomic, readonly) HDeviceCameraType deviceCameraType;
/**
 * 检查当前是否有系统相册权限，如果第一次安装调用此方法会弹出提示框
 */
@property (nonatomic, readonly) BOOL checkSysAlbumEnable;

/**
 *  检测相机是否有权限，只能在iOS7以上才能使用，iOS7以下直接返回YES
 */
@property (nonatomic, readonly) BOOL checkCameraEnable;

/*
 * 是否支持相机动画，主要根据低端机器和高端机器区分
 */
@property (nonatomic, readonly) BOOL supportedCaptureAnimation;

/*
 * 是否支持夜景 主要针对于夜景相机
 */
@property (nonatomic, readonly) BOOL supportedLowNight;

/*
 * 是否支持实时预览，主要针对于特效相机
 */
@property (nonatomic, readonly) BOOL supportedRealTimeDisplayedDevice;

/**
 *是否支持照片电影 
 */
@property (nonatomic, readonly) BOOL supportedGalleryCinema;

@end
