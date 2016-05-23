//
//  ViewController.m
//  PAuthorizationCenter
//
//  Created by C360_liyanjun on 16/2/28.
//  Copyright © 2016年 C360_liyanjun. All rights reserved.
//

#import "ViewController.h"
#import "PAuthorizationCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addMenu:@"测试权限" callback:^(id sender, id data) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [PAuthorizationCenter requestAudioAuthorization];
                [PAuthorizationCenter requestCaptureAuthorization];
             
            });
            [PAuthorizationCenter requestNotificationsAuthorization];
            [PAuthorizationCenter requestSysAlbumAuthorization];
            [PAuthorizationCenter requestLocationAuthorization];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
