//
//  HRManager.h
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "HRModel.h"
#import "HRError.h"
@interface HRManager : NSObject

- (instancetype)initWithBaseURLString:(NSString *)baseURLString;

@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;


/**
 by default:{"Accept-Language" = "zh-Hans;q=1";
             "User-Agent" = "HttpRequestClient/1.3.5 (iPhone; iOS 10.3.2; Scale/3.00)";}
 
 to remove some value for special key, use - [*.manager.requestSerializer setValue:nil forHTTPHeaderField:key];
 
 setHeaders only insert or replace some value for key because value can not be nil in a NSDictionary
 */
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *headers;

/**
 The timeout interval, in seconds, for created requests. The default timeout interval is * seconds.
 
 @see NSMutableURLRequest -setTimeoutInterval:
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *task, NSDictionary *head, id body))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;

@end
