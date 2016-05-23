//
//  PAuthorizationCenter.h
//  PAuthorizationCenter
//
//  Created by C360_liyanjun on 16/2/26.
//  Copyright © 2016年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

//需要在AppDeletage中post这个通知才能完成请求推送通知权限
#define kRegisterNotificationFinished @"kRegisterNotificationFinished"

/** 权限管理 **/
@interface PAuthorizationCenter : NSObject

/* 请求推送通知权限 */
+ (void)requestNotificationsAuthorization;

/* 请求相机权限 */
+ (BOOL)requestCaptureAuthorization;

/* 请求系统相册权限 */
+ (void)requestSysAlbumAuthorization;

/* 请求地理位置权限 */
+ (void)requestLocationAuthorization;

/* 请求麦克风权限 */
+ (BOOL)requestAudioAuthorization;

@end
