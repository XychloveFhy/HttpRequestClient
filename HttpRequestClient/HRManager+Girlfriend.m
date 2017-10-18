//
//  HRManager+Girlfriend.m
//  HttpRequestClient
//
//  Created by 张雁军 on 29/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRManager+Girlfriend.h"

@implementation HRManager (Girlfriend)

- (NSURLSessionDataTask *)getGirlFriendsWithParameters:(NSDictionary *)paras success:(void (^)(id))success failure:(void (^)(HRError *))failure{
    return [self requestWithURL:getGirlFriendsApi method:GET parameters:paras timeoutInterval:-1 constructingBody:nil progress:nil success:^(NSURLSessionDataTask *task, id data) {
        success(data);
    } failure:^(NSURLSessionDataTask *task, HRError *error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)uploadImageWithParameters:(NSDictionary *)paras constructingBody:(void (^)(id<AFMultipartFormData>))constructingBody progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(HRError *))failure{
    return [self requestWithURL:uploadImageApi method:POST parameters:paras timeoutInterval:-1 constructingBody:nil progress:nil success:^(NSURLSessionDataTask *task, id data) {
        success(data);
    } failure:^(NSURLSessionDataTask *task, HRError *error) {
        failure(error);
    }];
}

@end
