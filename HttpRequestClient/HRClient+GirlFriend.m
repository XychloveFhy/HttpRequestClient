//
//  HRClient+GirlFriend.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRClient+GirlFriend.h"

@implementation HRClient (GirlFriend)
- (void)getGirlFriendsWithParameters:(NSDictionary *)paras success:(void (^)(id))success failure:(void (^)(HRError *))failure{
    HRModel *model = [HRModel modelWithURLString:getGirlFriendsApi method:GET parameters:paras constructingBody:nil progress:nil];
    [self requestWithModel:model success:^(NSURLSessionDataTask *task, id data) {
        success(data);
    } failure:^(NSURLSessionDataTask *task, HRError *error) {
        failure(error);
    }];
}

- (void)uploadImageWithParameters:(NSDictionary *)paras constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress success:(void (^)(id))success failure:(void (^)(HRError *))failure{
    HRModel *model = [HRModel modelWithURLString:uploadImageApi method:POST parameters:paras constructingBody:constructingBody progress:progress];
    [self requestWithModel:model success:^(NSURLSessionDataTask *task, id data) {
        success(data);
    } failure:^(NSURLSessionDataTask *task, HRError *error) {
        failure(error);
    }];
}

@end
