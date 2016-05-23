//
//  ViewController.m
//  HDevice
//
//  Created by C360_liyanjun on 15/12/25.
//  Copyright © 2015年 C360_liyanjun. All rights reserved.
//

#import "ViewController.h"
//#import "HDevice.h"
//#import "HDevice+Camera.h"
//#import "HDevice+Location.h"
//#import "HDevice+Network.h"
//#import "HDevice+Sound.h"
//#import "HDevice+Motion.h"
#import "HDeviceHeader.h"
#import <objc/runtime.h>
//#import "HAppInfo.h"
#import <ReactiveCocoa.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVCaptureSession.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [HDevice class]);
    unsigned int count = 0;
    Method *methods = class_copyMethodList([HDevice class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"方法 名字 ==== %@",name);
        if (name)
        {

        }
        
        NSLog(@"Test '%@' completed successfuly", name);
    }
    
    NSArray *propertys = [self getAllProperties];
    NSLog(@"%@",propertys);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[HDevice shareInstance] startUpdateLocation];
    if([HDevice shareInstance].curLocationServiceEnabled){
        [[HDevice shareInstance] curLocation];
        [[HDevice shareInstance] startUpdateLocation];
    }
    
    [[HDevice shareInstance]  networkType];
    
    [RACObserve([HDevice shareInstance], networkType) subscribeNext:^(id x) {
        NSLog(@"network changed");
    }];
    //读取PushToken
    NSLog(@"pushToken:%@", [HAppInfo shareInstance].pushToken);
    //保存PushToken
    [HAppInfo shareInstance].pushToken = @"111111";
     //读取PushToken
    NSLog(@"pushToken:%@", [HAppInfo shareInstance].pushToken);
    
    [[HDevice shareInstance] startAccelerometer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(readAcceleration:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
        
    });
    
    NSString *str = [[HDevice shareInstance] localizedModelString];
    NSLog(@"%@",str);
   
}


- (void)readAcceleration:(id)sender
{
    AVCaptureVideoOrientation *orientation = (AVCaptureVideoOrientation *)[[HDevice shareInstance] captureOrientation];
    NSLog(@"");
}

- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([HDevice class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i< count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

@end
