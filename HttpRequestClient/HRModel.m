//
//  HRModel.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRModel.h"

@implementation HRModel

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method{
    return [self modelWithURLString:string method:method parameters:nil constructingBody:nil progress:nil timeoutInterval:-1];
}

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters{
    return [self modelWithURLString:string method:method parameters:parameters constructingBody:nil progress:nil timeoutInterval:-1];
}

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody{
    return [self modelWithURLString:string method:method parameters:parameters constructingBody:constructingBody progress:nil timeoutInterval:-1];
}

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress{
    return [self modelWithURLString:string method:method parameters:parameters constructingBody:constructingBody progress:progress timeoutInterval:0];
}

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress timeoutInterval:(NSTimeInterval)timeoutInterval{
    return [self modelWithURLString:string method:method parameters:parameters constructingBody:constructingBody progress:progress timeoutInterval:timeoutInterval success:nil failure:nil];
}

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress timeoutInterval:(NSTimeInterval)timeoutInterval success:(Success)success failure:(Failure)failure{
    HRModel *hrm = [[self alloc] init];
    [hrm setValue:string.copy forKey:@"URLString"];
    [hrm setValue:@(method) forKey:@"method"];
    [hrm setValue:parameters.copy forKey:@"parameters"];
    [hrm setValue:[constructingBody copy] forKey:@"constructingBody"];
    [hrm setValue:[progress copy] forKey:@"progress"];
    [hrm setValue:[success copy] forKey:@"success"];
    [hrm setValue:[failure copy] forKey:@"failure"];
    if (timeoutInterval <= 0) {
        [hrm setValue:@(defaultTimeoutInterval) forKey:@"timeoutInterval"];
    }else{
        [hrm setValue:@(timeoutInterval) forKey:@"timeoutInterval"];
    }
    return hrm;
}

@end








