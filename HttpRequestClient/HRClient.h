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

//debug
//inhouse
//adhoc
//release

//MARK: Configure the environment
#define debug

#ifdef debug
    static NSString * const baseUrl = @"http://10.40.4.223:80";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

#ifdef inhouse
    static NSString * const baseUrl = @"http://10.40.5.30:8000";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

#ifdef adhoc
    static NSString * const baseUrl = @"http://10.40.5.30:8000";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

#ifdef release
    static NSString * const baseUrl = @"http://10.40.5.30:8000";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif


@interface HRClient : NSObject

+ (instancetype)baseClient;

+ (instancetype)otherClient;

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
