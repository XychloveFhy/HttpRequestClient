//
//  HRManager.h
//  HttpRequestClient
//
//  Created by 张雁军 on 29/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRClient.h"

@interface HRManager : NSObject

+ (instancetype)defaultManager;
+ (instancetype)otherManager;

@property (nonatomic, readonly) NSString *baseURLString;
@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;

/**
 by default:{"Accept-Language" = "zh-Hans;q=1";
 "User-Agent" = "HttpRequestClient/1.3.5 (iPhone; iOS 10.3.2; Scale/3.00)";}
 */
- (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers;

/**
 start a url session request
 
 @param model which contain parameters for the request
 @param success <#success description#>
 @param failure <#failure description#>
 @return <#return value description#>
 */
- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *task, id data))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;
@end
