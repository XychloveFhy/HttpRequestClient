//
//  HRError.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRError.h"

@implementation HRError

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message{
    if (self = [super init]) {
        _code = code;
        _message = message.copy;
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"code": @"Code",
             @"message": @"Msg"};
}

@end
