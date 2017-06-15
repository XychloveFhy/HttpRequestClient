//
//  HRClient+Friends.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRClient.h"

@interface HRClient (Friends)
#define GetFriendsApi @"/api/User/GetFriends"
- (void)getFriendsWithParameters:(NSDictionary *)paras success:(void (^)(id body))success failure:(void (^)(HRError *error))failure;
@end
