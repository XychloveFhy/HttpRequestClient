//
//  HRClient.m
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRClient.h"

@interface HRClient ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;
@end

static HRClient *baseClient = nil;
static HRClient *otherClient = nil;

@implementation HRClient

+ (instancetype)baseClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseClient = [[self alloc] init];
        baseClient.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        /**
         `AFJSONRequestSerializer` is a subclass of `AFHTTPRequestSerializer` that encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
         */
        baseClient.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];;
        baseClient.headers = @{@"secret": @"af2ab55f5cfe4c269a7b726e7f3fdef9"};
        baseClient.sessionManager.requestSerializer.timeoutInterval = 15;
    });
    return baseClient;
}

+ (instancetype)otherClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        otherClient = [[self alloc] init];
        otherClient.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:otherUrl]];
        otherClient.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];;
        otherClient.headers = @{@"secret": @"1d2ab55f5cfe4c269a7b726e7f3fdef9"};
        otherClient.sessionManager.requestSerializer.timeoutInterval = 15;
    });
    return otherClient;
}

- (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers{
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (_sessionManager.requestSerializer.HTTPRequestHeaders[key] != nil) {
            [_sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }else{
            /**
             Default HTTP header field values to be applied to serialized requests. By default, these include the following:
             
             - `Accept-Language` with the contents of `NSLocale +preferredLanguages`
             - `User-Agent` with the contents of various bundle identifiers and OS designations
             
             @discussion To add or remove default request headers, use `setValue:forHTTPHeaderField:`.
             */
            if (![key isEqualToString:@"Accept-Language"] || ![key isEqualToString:@"User-Agent"]) {
                [_sessionManager.requestSerializer setValue:nil forHTTPHeaderField:key];
            }
        }
    }];
}

- (NSString *)baseURLString{
    return _sessionManager.baseURL.absoluteString;
}

- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, HRError *))failure{
    
    /*
     假设返回数据是这样的格式
     {
     "code": 10000,
     "msg": "接口调用成功"
     "data":{
            "Name": "",
            "Token": "b1da5ca7-fd61-4537-9361-92163d9e43d8",
            }
     }
    */
    
    
    /**
     response for HEAD method
     */
    void (^HEADSuccess)(NSURLSessionDataTask *task) = ^(NSURLSessionDataTask *task){
        success(task, nil);
    };
    
    /**
     *  server response data,
     */
    void (^serverResponse)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        /**
         code == 0 成功
         */
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            id data = responseObject[@"data"];
            success(task, data);
        }else{
            HRError *error = [[HRError alloc] initWithCode:code message:responseObject[@"msg"]];
            failure(task, error);
        }
    };
    
    /*
     error: 
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
    void (^URLSessionFailure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask *task, NSError *error){
        HRError *sessionError = [[HRError alloc] initWithCode:error.code message:error.localizedDescription];
        failure(task, sessionError);
    };
    
    
    //MARK: 默认参数
    NSDictionary *defaultParas = @{@"AppVersion": @"1.0.0",
                                   @"AppType": @(2),
                                   @"ApiType":@(1),
                                   @"Token": @"3403980-fmsod23-32f-32-2fs"};
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:defaultParas];
    [parameters addEntriesFromDictionary:model.parameters];
    
    //MARK: - Request
    switch (model.method) {
        case GET:{
            return [_sessionManager GET:model.URLString parameters:parameters progress:model.progress success:serverResponse failure:URLSessionFailure];
        }
            break;
            
        case HEAD:{
            return [_sessionManager HEAD:model.URLString parameters:parameters success:HEADSuccess failure:URLSessionFailure];
        }
            break;
            
        case POST:
            if (model.constructingBody) {
                return [_sessionManager POST:model.URLString parameters:parameters constructingBodyWithBlock:model.constructingBody progress:model.progress success:serverResponse failure:URLSessionFailure];
            }else{
                return [_sessionManager POST:model.URLString parameters:parameters progress:model.progress success:serverResponse failure:URLSessionFailure];
            }
            break;
            
        case PUT:
            return [_sessionManager PUT:model.URLString parameters:parameters success:serverResponse failure:URLSessionFailure];
            break;
            
        case PATCH:
            return [_sessionManager PATCH:model.URLString parameters:parameters success:serverResponse failure:URLSessionFailure];
            break;
            
        case DELETE:
            return [_sessionManager DELETE:model.URLString parameters:parameters success:serverResponse failure:URLSessionFailure];
            break;
            
        default:
            return nil;
            break;
    }
}

@end
