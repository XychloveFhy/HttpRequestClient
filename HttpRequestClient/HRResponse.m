//
//  HRResponse.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRResponse.h"

@implementation HRResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

@end
