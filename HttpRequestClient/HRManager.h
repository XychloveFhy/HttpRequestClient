//
//  HRManager.h
//  HttpRequestClient
//
//  Created by 张雁军 on 29/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRClient.h"

typedef NS_ENUM(NSUInteger, HttpRequestMethod) {
    GET = 0,
    HEAD,
    POST,
    PUT,
    PATCH,
    DELETE
};

@interface HRManager : NSObject

+ (instancetype)defaultManager;
+ (instancetype)otherManager;

@property (nonatomic, readonly) NSString *baseURLString;
@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;
@property (nonatomic, readonly) NSTimeInterval defaultTimeoutInterval;
@property (nonatomic, readonly) NSMutableArray *tasks;

/**
 by default:{"Accept-Language" = "zh-Hans;q=1";
 "User-Agent" = "HttpRequestClient/1.3.5 (iPhone; iOS 10.3.2; Scale/3.00)";}
 */
- (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers;

//...

//- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model;
//
//- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *task, id data))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;
//
//- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model constructingBody:(void (^)(id <AFMultipartFormData> formData))constructingBody progress:(void(^)(NSProgress *progress))progress success:(void (^)(NSURLSessionDataTask *task, id data))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString method:(HttpRequestMethod)method parameters:(NSDictionary *)paras timeoutInterval:(NSTimeInterval)timeoutInterval constructingBody:(void (^)(id <AFMultipartFormData> formData))constructingBody progress:(void(^)(NSProgress *progress))progress success:(void (^)(NSURLSessionDataTask *task, id data))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString method:(HttpRequestMethod)method parameters:(NSDictionary *)paras constructingBody:(void (^)(id <AFMultipartFormData> formData))constructingBody progress:(void(^)(NSProgress *progress))progress success:(void (^)(NSURLSessionDataTask *task, id data))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;

@end
