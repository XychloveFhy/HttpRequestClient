//
//  HRManager+Girlfriend.h
//  HttpRequestClient
//
//  Created by 张雁军 on 29/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRManager.h"

@interface HRManager (Girlfriend)
#define getGirlFriendsApi @"/api/user/getGirlFriends"
- (void)getGirlFriendsWithParameters:(NSDictionary *)paras success:(void (^)(id data))success failure:(void (^)(HRError *error))failure;
#define uploadImageApi @"/api/user/uploadImage"
- (void)uploadImageWithParameters:(NSDictionary *)paras constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress success:(void (^)(id data))success failure:(void (^)(HRError *error))failure;
@end
