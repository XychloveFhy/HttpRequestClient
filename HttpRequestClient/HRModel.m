//
//  HRModel.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRModel.h"

@implementation HRModel

+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(constructingBody)constructingBody progress:(progress)progress{
    HRModel *hrm = [[self alloc] init];
    [hrm setValue:string forKey:@"URLString"];
    [hrm setValue:@(method) forKey:@"method"];
    [hrm setValue:parameters forKey:@"parameters"];
    [hrm setValue:[constructingBody copy] forKey:@"constructingBody"];
    [hrm setValue:[progress copy] forKey:@"progress"];
    return hrm;
}

@end
