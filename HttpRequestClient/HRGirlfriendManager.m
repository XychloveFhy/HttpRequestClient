//
//  HRGirlfriendManager.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRGirlfriendManager.h"

@implementation HRGirlfriendManager

- (instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)fake:(void(^)())success failure:(void(^)())failure{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            success();
        });
    });
}

- (NSURLSessionDataTask *)getGirlFriendsWithSuccess:(void (^)())success failure:(void (^)(HRError *))failure{
    NSAssert(_userId != nil, @"user id must not be nil");
    NSDictionary *paras = @{@"userId": _userId};
    return [[HRManager defaultManager] getGirlFriendsWithParameters:paras success:^(id data) {
        _girlfriends = [MTLJSONAdapter modelsOfClass:[HRGirlfriend class] fromJSONArray:data[@"girlFriendList"] error:nil];
        success();
    } failure:^(HRError *error) {
        failure(error);
    }];
}

- (NSURLSessionDataTask *)uploadGirlProgress:(void (^)(NSProgress *))progress success:(void (^)(NSDictionary *))success failure:(void (^)(HRError *))failure{
    return [[HRManager defaultManager] uploadImageWithParameters:nil constructingBody:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(self.girl, 1);
        [formData appendPartWithFileData:data name:@"file" fileName:@"C.jpg" mimeType:@"image/jpeg"];
    } progress:progress success:^(id data) {
        success(data);
    } failure:^(HRError *error) {
        failure(error);
    }];
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}

@end
