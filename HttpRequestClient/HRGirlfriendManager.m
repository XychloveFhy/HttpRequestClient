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

- (void)getGirlFriendsWithSuccess:(void (^)())success failure:(void (^)(HRError *))failure{
    NSAssert(_userId != nil, @"user id must not be nil");
    NSDictionary *paras = @{@"userId": _userId};
    [[HRManager defaultManager] getGirlFriendsWithParameters:paras success:^(id data) {
        _girlfriends = [MTLJSONAdapter modelsOfClass:[HRGirlfriend class] fromJSONArray:data[@"girlFriendList"] error:nil];
        success();
    } failure:^(HRError *error) {
        failure(error);
    }];
}

- (void)uploadGirlProgress:(Progress)progress success:(void (^)(NSDictionary *))success failure:(void (^)(HRError *))failure{
    [[HRManager defaultManager] uploadImageWithParameters:nil constructingBody:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(self.girl, 1);
        [formData appendPartWithFileData:data name:@"file" fileName:@"C.jpg" mimeType:@"image/jpeg"];
    } progress:progress success:^(id data) {
        success(data);
    } failure:^(HRError *error) {
        failure(error);
    }];
}

@end