//
//  HRManager.m
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRManager.h"

@implementation HRManager

- (instancetype)initWithBaseURLString:(NSString *)baseURLString{
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        /**
         `AFJSONRequestSerializer` is a subclass of `AFHTTPRequestSerializer` that encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
         */
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers{
    if (_headers != headers) {
        _headers = headers.copy;
        [_headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval{
    _manager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *, NSDictionary *, id))success failure:(void (^)(NSURLSessionDataTask *, HRError *))failure{
        
    /*
     Printing description of responseObject:
     {
     Content =     {
     Name = "\U7528\U6237\U540d";
     };
     Head =     {
     Code = 10000;
     Msg = "\U63a5\U53e3\U8c03\U7528\U6210\U529f";
     Ret = 0;
     Token = "7d5b89cf-51ef-44e3-89ed-32aae17de9fc";
     };
     }
     
     Printing description of responseObject:
     {
     Content = "<null>";
     Head =     {
     Code = 10011;
     Msg = "\U8f93\U5165\U7684\U624b\U673a\U53f7\U7801\U4e0d\U80fd\U4e3a\U7a7a";
     Ret = "-1";
     Token = "<null>";
     };
     }
     */
    
    void (^headSuccessBlock)(NSURLSessionDataTask *task) = ^(NSURLSessionDataTask *task){
        success(task, nil, nil);
    };
    
    /**
     *  服务器返回数据 包括成功或失败的信息
     */
    void (^serverResponseBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        NSDictionary *head = responseObject[@"Head"];
        if ([head[@"Ret"] integerValue] != 0) {
            HRError *error = [MTLJSONAdapter modelOfClass:[HRError class] fromJSONDictionary:responseObject[@"Head"] error:nil];
            failure(task, error);
            switch (error.code) {
                case 1000:
                    NSLog(@"force logout");
                    break;
                    
                default:
                    break;
            }
        }else{
            id body = responseObject[@"Content"];
            success(task, head, body);
        }
    };
    
    /*
     error: 非服务器返回错误
     Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline."
     UserInfo = {
     NSUnderlyingError=0x7fa5f9f21520 {Error Domain=kCFErrorDomainCFNetwork Code=-1009 "(null)" UserInfo={_kCFStreamErrorCodeKey=50, _kCFStreamErrorDomainKey=1}},
     NSErrorFailingURLStringKey=http://10.51.3.30:80/api/UserInfoApi/Login,
     NSErrorFailingURLKey=http://10.51.3.30:80/api/UserInfoApi/Login,
     _kCFStreamErrorDomainKey=1,
     _kCFStreamErrorCodeKey=50,
     NSLocalizedDescription=The Internet connection appears to be offline.
     }
     */
    void (^URLSessionFailureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask *task, NSError *error){
        HRError *sessionError = [[HRError alloc] initWithCode:error.code message:error.localizedDescription];
        failure(task, sessionError);
    };
    
    //MARK: 默认参数
    NSDictionary *head = @{@"AppVersion": @"1.0.0",
                           @"AppType": @(2),
                           @"ApiType":@(1),
                           @"Token": @"3403980-fmsod23-32f-32-2fs"};
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"Head"] = head;
    parameters[@"Body"] = model.parameters? model.parameters: @"";
    
    //MARK: - Request
    switch (model.method) {
        case GET:{
            /**
             *  parameters -> model.parameters + head
             */
            NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
            [content addEntriesFromDictionary:model.parameters];
            /**
             *  可能有parameters传了token, key可能为"Token""token"
             */
            [content.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *key = obj;
                if ([key.lowercaseString isEqualToString:@"token"]) {
                    [content removeObjectForKey:key];
                }
            }];
            [content setValuesForKeysWithDictionary:head];
            return [_manager GET:model.URLString parameters:content progress:model.progress success:serverResponseBlock failure:URLSessionFailureBlock];
        }
            break;
            
        case HEAD:{
            return [_manager HEAD:model.URLString parameters:parameters success:headSuccessBlock failure:URLSessionFailureBlock];
        }
            break;
            
        case POST:
            if (model.constructingBody) {
                return [_manager POST:model.URLString parameters:parameters constructingBodyWithBlock:model.constructingBody progress:model.progress success:serverResponseBlock failure:URLSessionFailureBlock];
            }else{
                return [_manager POST:model.URLString parameters:parameters progress:model.progress success:serverResponseBlock failure:URLSessionFailureBlock];
            }
            break;
            
        case PUT:
            return [_manager PUT:model.URLString parameters:parameters success:serverResponseBlock failure:URLSessionFailureBlock];
            break;
            
        case PATCH:
            return [_manager PATCH:model.URLString parameters:parameters success:serverResponseBlock failure:URLSessionFailureBlock];
            break;
            
        case DELETE:
            return [_manager DELETE:model.URLString parameters:parameters success:serverResponseBlock failure:URLSessionFailureBlock];
            break;
            
        default:
            return nil;
            break;
    }
}

@end
