//
//  HRManager.m
//  HttpRequestClient
//
//  Created by 张雁军 on 29/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRManager.h"

@interface HRManager ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;
@property (nonatomic, assign, readwrite) NSTimeInterval defaultTimeoutInterval;
@property (nonatomic, strong, readwrite) NSMutableArray *tasks;
@property (nonatomic, copy) NSDictionary *(^requiredParameters)();
@end

@implementation HRManager

+ (instancetype)defaultManager{
    static HRManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
        defaultManager.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        defaultManager.defaultTimeoutInterval = 15;
        defaultManager.tasks = [[NSMutableArray alloc] init];
        
        /**
         `AFJSONRequestSerializer` is a subclass of `AFHTTPRequestSerializer` that encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
         */
        defaultManager.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        defaultManager.sessionManager.requestSerializer.timeoutInterval = 15;
        defaultManager.headers = @{@"secret": @"af2ab55f5cfe4c269a7b726e7f3fdef9"};
        defaultManager.requiredParameters = ^NSDictionary *{
            return @{@"token": [HRUtils getToken]};
        };
    });
    return defaultManager;
}

+ (instancetype)otherManager{
    static HRManager *otherManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        otherManager = [[self alloc] init];
        otherManager.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:otherUrl]];
        otherManager.defaultTimeoutInterval = 15;
        otherManager.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        otherManager.sessionManager.requestSerializer.timeoutInterval = 15;
        otherManager.headers = @{@"secret": @"1d2ab55f5cfe4c269a7b726e7f3fdef9"};
        otherManager.requiredParameters = ^NSDictionary *{
            return @{@"other": @"something"};
        };
    });
    return otherManager;
}

#pragma mark -

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
    //    Also important to note is that a trailing slash will be added to any `baseURL` without one. This would otherwise cause unexpected behavior when constructing URLs using paths without a leading slash.
    return _sessionManager.baseURL.absoluteString;
}

#pragma mark - 

//- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model{
//    return [self requestWithURL:model.URLString method:model.method parameters:model.parameters timeoutInterval:model.timeoutInterval constructingBody:model.constructingBody progress:model.progress success:model.success failure:model.failure];
//}
//
//- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, HRError *))failure{
//    return [self requestWithURL:model.URLString method:model.method parameters:model.parameters timeoutInterval:model.timeoutInterval constructingBody:model.constructingBody progress:model.progress success:model.success failure:model.failure];
//}

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString method:(HttpRequestMethod)method parameters:(NSDictionary *)paras timeoutInterval:(NSTimeInterval)timeoutInterval constructingBody:(void (^)(id<AFMultipartFormData>))constructingBody progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, HRError *))failure{
    /*
     assume returned json data like this
     {
     "code": 10000,
     "msg": "login success"
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
        if ([self.tasks containsObject:task]) {
            [self.tasks removeObject:task];
        }
        success(task, nil);
    };
    
    /**
     *  server response data,
     */
    void (^serverResponse)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        /**
         code == 200 means success
         */
        if ([self.tasks containsObject:task]) {
            [self.tasks removeObject:task];
        }
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 200) {
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
    void (^httpFailure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask *task, NSError *error){
        if ([self.tasks containsObject:task]) {
            [self.tasks removeObject:task];
        }
        HRError *sessionError = [[HRError alloc] initWithCode:error.code message:error.localizedDescription];
        failure(task, sessionError);
    };
    
    
    //MARK: required/default parameters append model.parameters
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:self.requiredParameters()];
    [parameters addEntriesFromDictionary:paras];
    
    
    //MARK: - Request
    @synchronized (self) {
        if (timeoutInterval > 0) {
            self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
        } else {
            self.sessionManager.requestSerializer.timeoutInterval = self.defaultTimeoutInterval;
        }
        switch (method) {
            case GET:{
                NSURLSessionDataTask *task = [_sessionManager GET:URLString parameters:parameters progress:progress success:serverResponse failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }
                break;
                
            case HEAD:{
                NSURLSessionDataTask *task = [_sessionManager HEAD:URLString parameters:parameters success:HEADSuccess failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }
                break;
                
            case POST:
                if (constructingBody != nil) {
                    NSURLSessionDataTask *task = [_sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:constructingBody progress:progress success:serverResponse failure:httpFailure];
                    [self.tasks addObject:task];
                    return task;
                }else{
                    NSURLSessionDataTask *task = [_sessionManager POST:URLString parameters:parameters progress:progress success:serverResponse failure:httpFailure];
                    [self.tasks addObject:task];
                    return task;
                }
                break;
                
            case PUT:{
                NSURLSessionDataTask *task = [_sessionManager PUT:URLString parameters:parameters success:serverResponse failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }
                break;
                
            case PATCH:{
                NSURLSessionDataTask *task = [_sessionManager PATCH:URLString parameters:parameters success:serverResponse failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }
                break;
                
            case DELETE:{
                NSURLSessionDataTask *task = [_sessionManager DELETE:URLString parameters:parameters success:serverResponse failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }
                break;
                
            default:
                return nil;
                break;
        }
    }
}

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString method:(HttpRequestMethod)method parameters:(NSDictionary *)paras constructingBody:(void (^)(id<AFMultipartFormData>))constructingBody progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, HRError *))failure{
    /*
     assume returned json data like this
     {
     "code": 10000,
     "msg": "login success"
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
        if ([self.tasks containsObject:task]) {
            [self.tasks removeObject:task];
        }
        success(task, nil);
    };
    
    /**
     *  server response data,
     */
    void (^serverResponse)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        /**
         code == 200 means success
         */
        if ([self.tasks containsObject:task]) {
            [self.tasks removeObject:task];
        }
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 200) {
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
    void (^httpFailure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask *task, NSError *error){
        if ([self.tasks containsObject:task]) {
            [self.tasks removeObject:task];
        }
        HRError *sessionError = [[HRError alloc] initWithCode:error.code message:error.localizedDescription];
        failure(task, sessionError);
    };
    
    
    //MARK: required/default parameters append model.parameters
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:self.requiredParameters()];
    [parameters addEntriesFromDictionary:paras];
    
    
    //MARK: - Request
    switch (method) {
        case GET:{
            NSURLSessionDataTask *task = [_sessionManager GET:URLString parameters:parameters progress:progress success:serverResponse failure:httpFailure];
            [self.tasks addObject:task];
            return task;
        }
            break;
            
        case HEAD:{
            NSURLSessionDataTask *task = [_sessionManager HEAD:URLString parameters:parameters success:HEADSuccess failure:httpFailure];
            [self.tasks addObject:task];
            return task;
        }
            break;
            
        case POST:
            if (constructingBody != nil) {
                NSURLSessionDataTask *task = [_sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:constructingBody progress:progress success:serverResponse failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }else{
                NSURLSessionDataTask *task = [_sessionManager POST:URLString parameters:parameters progress:progress success:serverResponse failure:httpFailure];
                [self.tasks addObject:task];
                return task;
            }
            break;
            
        case PUT:{
            NSURLSessionDataTask *task = [_sessionManager PUT:URLString parameters:parameters success:serverResponse failure:httpFailure];
            [self.tasks addObject:task];
            return task;
        }
            break;
            
        case PATCH:{
            NSURLSessionDataTask *task = [_sessionManager PATCH:URLString parameters:parameters success:serverResponse failure:httpFailure];
            [self.tasks addObject:task];
            return task;
        }
            break;
            
        case DELETE:{
            NSURLSessionDataTask *task = [_sessionManager DELETE:URLString parameters:parameters success:serverResponse failure:httpFailure];
            [self.tasks addObject:task];
            return task;
        }
            break;
            
        default:
            return nil;
            break;
    }
}


@end
