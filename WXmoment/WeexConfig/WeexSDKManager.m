//
// Created by 孙海阔 on 2018/2/23.
// Copyright (c) 2018 DW. All rights reserved.
//


#import "WeexSDKManager.h"
#import <WeexSDK/WeexSDK.h>
#import "WXImgLoaderDefaultImpl.h"

@implementation WeexSDKManager

+ (void)initWeexSDK {
    // 设置weex
    [WXAppConfiguration setAppGroup:@"AliApp"];
    [WXAppConfiguration setAppName:@"WeexDemo"];
    [WXAppConfiguration setAppVersion:@"1.8.3"];
    [WXAppConfiguration setExternalUserAgent:@"ExternalUA"];
    [WXSDKEngine initSDKEnvironment];
    // 设置图片加载
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
}

@end