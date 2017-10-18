//
//  HRClient.h
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
//#import "HRModel.h"
#import "HRError.h"
#import "HRUtils.h"

//debug
//inhouse
//adhoc
//release

//MARK: Configure the environment
#define debug

#ifdef debug
    static NSString * const baseUrl = @"http://10.40.4.223:80";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

#ifdef inhouse
    static NSString * const baseUrl = @"http://10.40.5.30:8000";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

#ifdef adhoc
    static NSString * const baseUrl = @"http://10.40.5.30:8000";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

#ifdef release
    static NSString * const baseUrl = @"http://10.40.5.30:8000";
    static NSString * const otherUrl = @"http://10.40.5.30:8000";
#endif

