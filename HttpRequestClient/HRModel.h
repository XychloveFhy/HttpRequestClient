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
@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) HttpRequestMethod method;
@property (nonatomic, readonly) NSDictionary *parameters;
@property (nonatomic, readonly) constructingBody constructingBody;
@property (nonatomic, readonly) progress progress;

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(constructingBody)constructingBody progress:(progress)progress;

@end
