//
//  HRGirlfriendManager.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRGirlfriend.h"
#import "HRManager+Girlfriend.h"

@interface HRGirlfriendManager : NSObject
- (instancetype)initWithUserId:(NSString *)userId;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSArray <HRGirlfriend *> *girlfriends;
- (NSURLSessionDataTask *)getGirlFriendsWithSuccess:(void (^)())success failure:(void (^)(HRError *error))failure;

@property (nonatomic, strong) UIImage *girl;
- (NSURLSessionDataTask *)uploadGirlProgress:(void(^)(NSProgress *progress))progress success:(void (^)(NSDictionary *girl))success failure:(void (^)(HRError *error))failure;

- (void)fake:(void(^)())success failure:(void(^)())failure;

@end
