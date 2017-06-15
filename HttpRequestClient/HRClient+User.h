//
//  HRClient+User.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRClient.h"

@interface HRClient (User)
#define getUserApi @"/api/user/getUser"
- (void)getUserWithParameters:(NSDictionary *)paras success:(void (^)(id data))success failure:(void (^)(HRError *error))failure;
@end
