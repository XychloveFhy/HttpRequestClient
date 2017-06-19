//
//  HRGirlFriendModel.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRResponse.h"

@interface HRGirlFriendModel : HRResponse
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic, copy) NSString *sanwei;
@end
