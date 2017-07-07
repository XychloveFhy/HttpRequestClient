//
//  HRError.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HRError : MTLModel <MTLJSONSerializing>
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message;
@property (nonatomic, readonly) NSInteger code;
@property (nonatomic, readonly) NSString *message;
@end
