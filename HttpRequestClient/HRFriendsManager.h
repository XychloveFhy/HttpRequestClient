//
//  HRFriendsManager.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRClient+Friends.h"
#import "HRFriendModel.h"

@interface HRFriendsManager : NSObject

@property (nonatomic) int pageIndex;///<int 分页页码 from 1
@property (nonatomic) int pageSize;///<default 10

@property (nonatomic, readonly) int Count;
@property (nonatomic, readonly) NSMutableArray <HRFriendModel *> *friends;

- (void)getFriendsWithSuccess:(void (^)(NSArray <HRFriendModel *> *friends))success failure:(void (^)(HRError *error))failure;

@end
