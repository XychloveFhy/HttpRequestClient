//
//  HRClient.h
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "HRModel.h"
#import "HRError.h"

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

+ (instancetype)baseClient;

+ (instancetype)otherClient;

@property (nonatomic, readonly) NSString *baseURLString;

@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;

/**
 by default:{"Accept-Language" = "zh-Hans;q=1";
 "User-Agent" = "HttpRequestClient/1.3.5 (iPhone; iOS 10.3.2; Scale/3.00)";}
 
 to remove some value for special key, use - [*.manager.requestSerializer setValue:nil forHTTPHeaderField:key];
 
 setHeaders only insert or replace some value for key because value can not be nil in a NSDictionary
 */
- (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers;

- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *task, NSDictionary *head, id body))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;

@end
