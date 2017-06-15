//
//  HRUserManager.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRUserManager.h"

@implementation HRUserManager

- (instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)getUserWithSuccess:(void (^)(HRUserModel *))success failure:(void (^)(HRError *))failure{
    NSAssert(_userId != nil, @"user id must not be nil");
    NSDictionary *paras = @{@"userId": _userId};
    [[HRClient baseClient] getUserWithParameters:paras success:^(id data) {
        _user = [MTLJSONAdapter modelOfClass:[HRUserModel class] fromJSONDictionary:data error:nil];
        success(_user);
    } failure:^(HRError *error) {
        failure(error);
    }];
}

@end
