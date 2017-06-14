//
//  HRClient.m
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRClient.h"

@interface HRClient ()

/**
 Http Request 管理器
 */
@property (nonatomic, strong, readwrite) HRManager *hrManager;
@property (nonatomic, copy, readwrite) NSString *baseURLString;

@end

static HRClient *sharedClient = nil;

@implementation HRClient

+ (instancetype)sharedClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
        sharedClient.baseURLString = API_Debug;
        sharedClient.hrManager = [[HRManager alloc] initWithBaseURLString:@"http://10.0.0.0:8080"];
        sharedClient.hrManager.headers = @{@"secret": @"af2ab55f5cfe4c269a7b726e7f3fdef9"};
        sharedClient.hrManager.timeoutInterval = 15;
    });
    return sharedClient;
}

@end
