//
//  HRClient.h
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRManager.h"


#define API_Key @"API_Key"
#define AppVersion_Key @"AppVersion_Key"

/** 开发环境*/
static NSString * const API_Debug = @"http://10.40.5.30:8000";
static NSString * const AppVersion_Debug = @"http://10.40.5.30:8011";

/** 测试环境*/
static NSString * const API_AdHoc = @"http://100.242.169.60:40080/";
static NSString * const AppVersion_AdHoc = @"http://100.242.169.60:48010/";

/** 生产环境*/
static NSString * const API_Release = @"https://baidu.com";
static NSString * const API_IP_Release = @"https://100.242.169.60";
static NSString * const AppVersion_Release = @"https://version.baidu.com";


@interface HRClient : NSObject

+ (instancetype)sharedClient;

+ (instancetype)otherClient;

@property (nonatomic, strong, readonly) HRManager *hrManager;

@property (nonatomic, copy, readonly) NSString *baseURLString;

@end
