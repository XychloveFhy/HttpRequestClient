//
//  HRFriendsManager.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRFriendsManager.h"

@implementation HRFriendsManager

- (instancetype)init{
    if (self = [super init]) {
        _friends = [[NSMutableArray alloc] init];
        _pageIndex = 1;
        _pageSize = 10;
    }
    return self;
}

- (void)getFriendsWithSuccess:(void (^)(NSArray<HRFriendModel *> *))success failure:(void (^)(HRError *))failure{
    NSDictionary *paras = @{@"pageIndex": @(_pageIndex),
                            @"pageSize": @(_pageSize)};
    [[HRClient baseClient] getFriendsWithParameters:paras success:^(id body) {
        _Count = [body[@"Count"] intValue];
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[HRFriendModel class] fromJSONArray:body[@"Friends"] error:nil];
        success(temp);
    } failure:^(HRError *error) {
        failure(error);
    }];
}

@end
