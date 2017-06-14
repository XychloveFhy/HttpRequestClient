//
//  HRResponse.h
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HRResponse : MTLModel <MTLJSONSerializing>

@end

@interface HRHead : HRResponse
@property (nonatomic, readonly) NSInteger Ret;
@property (nonatomic, readonly) NSInteger Code;
@property (nonatomic, copy, readonly) NSString *Msg;
@property (nonatomic, copy, readonly) NSString *Token;
@end
