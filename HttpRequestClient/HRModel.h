//
//  HRModel.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, HttpRequestMethod) {
    GET = 0,
    HEAD,
    POST,
    PUT,
    PATCH,
    DELETE
};

typedef void (^progress)(NSProgress *progress);
typedef void (^constructingBody)(id <AFMultipartFormData> formData);

@interface HRModel : NSObject
@property (nonatomic, copy, readonly) NSString *URLString;
@property (nonatomic, assign, readonly) HttpRequestMethod method;
@property (nonatomic, copy, readonly) NSDictionary *parameters;
@property (nonatomic, copy, readonly) constructingBody constructingBody;
@property (nonatomic, copy, readonly) progress progress;

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(constructingBody)constructingBody progress:(progress)progress;

@end
