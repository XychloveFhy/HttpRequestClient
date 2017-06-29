//
//  HRModel.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
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

typedef void (^ConstructingBody)(id <AFMultipartFormData> formData);
typedef void (^Progress)(NSProgress *progress);

@interface HRModel : NSObject
@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) HttpRequestMethod method;
@property (nonatomic, readonly) NSDictionary *parameters;
@property (nonatomic, readonly) ConstructingBody constructingBody;
@property (nonatomic, readonly) Progress progress;
@property (nonatomic, readonly) NSTimeInterval timeoutInterval;

//MARK:CONVENIENCE
+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method;
+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters;
+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody;
+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress;
//MARK:FULL METHOD
+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress timeoutInterval:(NSTimeInterval)timeoutInterval;

@end
