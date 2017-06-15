//
//  HRUserManager.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRUserModel.h"
#import "HRClient+User.h"

@interface HRUserManager : NSObject
- (instancetype)initWithUserId:(NSString *)userId;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) HRUserModel *user;
- (void)getUserWithSuccess:(void (^)(HRUserModel *model))success failure:(void (^)(HRError *error))failure;
@end
