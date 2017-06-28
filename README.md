# HttpRequestClient

##### For more information, please refer to [简书链接](http://www.jianshu.com/p/e6e2a6e8855e)
##### If it helps, please star
##### If there's something wrong, please don't hesitate to let me know


主要请求部分如下：
======================
#### Model->HRModel 请求的地址、方法、参数、上传、进度等由这个模型来接收传递
```
typedef void (^Progress)(NSProgress *progress);
typedef void (^ConstructingBody)(id <AFMultipartFormData> formData);
@interface HRModel : NSObject
@property (nonatomic, readonly) NSString *URLString;
@property (nonatomic, readonly) HttpRequestMethod method;
@property (nonatomic, readonly) NSDictionary *parameters;
@property (nonatomic, readonly) Progress progress;
@property (nonatomic, readonly) ConstructingBody constructingBody;
+ (instancetype)modelWithURLString:(NSString *)string method:(HttpRequestMethod)method parameters:(NSDictionary *)parameters constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress;
@end
```
#### ViewModel->HRClient 发起请求，接收成功或失败回调
```
@interface HRClient : NSObject
// 大部分的请求都向一个base地址发起比如：http://www.baidu.com/
+ (instancetype)baseClient;
// 可能APP不只一个地址，比如某个接口查看APP更新内容用另一个base地址：http://www.update.com/
+ (instancetype)otherClient;
@property (nonatomic, readonly) NSString *baseURLString;
@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;
- (void)setHeaders:(NSDictionary<NSString *,NSString *> *)headers;
- (NSURLSessionDataTask *)requestWithModel:(HRModel *)model success:(void (^)(NSURLSessionDataTask *task, id data))success failure:(void (^)(NSURLSessionDataTask *task, HRError *error))failure;
@end
```
### 一个在MVVM模式下使用的例子：
假设有一个模块叫“女朋友”，需求是展示某个程序员所有的女朋友，还可以给他上传一个女朋友
#### Girlfriend
###### Utils:  此模块的工具类 扩展类
里面添加一个对HRClient的category，category里放这个模块的API和对应的请求方法（对应的API方法放在对应的模块里），这里不需要关心参数的名字，也不需要关心返回值的类型

```
@interface HRClient (GirlFriend)
//获取他所有的女朋友
#define getGirlFriendsApi @"/api/user/getGirlFriends"
- (void)getGirlFriendsWithParameters:(NSDictionary *)paras success:(void (^)(id data))success failure:(void (^)(HRError *error))failure;

//给他上传一个女朋友 需要显示上传进度
#define uploadImageApi @"/api/user/uploadImage"
- (void)uploadImageWithParameters:(NSDictionary *)paras constructingBody:(ConstructingBody)constructingBody progress:(Progress)progress success:(void (^)(id data))success failure:(void (^)(HRError *error))failure;
@end
```
###### ViewModel: 
获取他所有女朋友的参数要传一个他的userID，参数的传递由ViewModel控制，不需要由Controller传递，所以获取女朋友的方法“- (void)getGirlFriendsWithSuccess:(void (^)())success failure:(void (^)(HRError *error))failure;”不需要加withParameters:，Controller只需要做一些UI的事情

```
@interface HRGirlFriendsManager : NSObject
- (instancetype)initWithUserId:(NSString *)userId;
@property (nonatomic, readonly) NSString *userId;
//他所有的女朋友
@property (nonatomic, readonly) NSArray <HRGirlFriendModel *> *girlfriends;
- (void)getGirlFriendsWithSuccess:(void (^)())success failure:(void (^)(HRError *error))failure;
//要给他上传的女朋友
@property (nonatomic, strong) UIImage *girl;
- (void)uploadGirlProgress:(Progress)progress success:(void (^)(NSDictionary *girl))success failure:(void (^)(HRError *error))failure;
@end

@implementation HRGirlFriendsManager
- (instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)getGirlFriendsWithSuccess:(void (^)())success failure:(void (^)(HRError *))failure{
    NSAssert(_userId != nil, @"user id must not be nil");
    NSDictionary *paras = @{@"userId": _userId};
    [[HRClient baseClient] getGirlFriendsWithParameters:paras success:^(id data) {
        _girlfriends = [MTLJSONAdapter modelsOfClass:[HRGirlFriendModel class] fromJSONArray:data[@"girlFriendList"] error:nil];
        success();
    } failure:^(HRError *error) {
        failure(error);
    }];
}

- (void)uploadGirlProgress:(Progress)progress success:(void (^)(NSDictionary *))success failure:(void (^)(HRError *))failure{
    [[HRClient baseClient] uploadImageWithParameters:nil constructingBody:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(self.girl, 1);
        [formData appendPartWithFileData:data name:@"file" fileName:@"C.jpg" mimeType:@"image/jpeg"];
    } progress:progress success:^(id data) {
        success(data);
    } failure:^(HRError *error) {
        failure(error);
    }];
}
@end
```
###### Model: 
HRGirlFriendModel 女朋友的模型，HRResponse继承自Mantle
```
@interface HRGirlFriendModel : HRResponse
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic, copy) NSString *sanwei;
@end
```
###### View：
添加一个ViewModel：HRGirlFriendsManager *manager
```
@interface HRGirlFriendsController ()
@property (nonatomic, strong) HRGirlFriendsManager *manager;
@end
```
获取他的所有女朋友并显示在tableView上，获取中要显示loading
```
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager getGirlFriendsWithSuccess:^{
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    } failure:^(HRError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = error.message;
        [hud hideAnimated:YES afterDelay:1.8];
    }];
```
给他上传一个女朋友
```
    // he wants this girl: girl0
    _manager.girl = [UIImage imageNamed:@"girl0.jpg"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    [_manager uploadGirlProgress:^(NSProgress *progress) {
        // 上传进度
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress.fractionCompleted;
        });
    } success:^(NSDictionary *girl) {
        self.tableView.tableHeaderView = imageview;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = @"success";
        [hud hideAnimated:YES afterDelay:1.8];
    } failure:^(HRError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = error.message;
        [hud hideAnimated:YES afterDelay:1.8];
    }];
```



-----------------
English: still working ...
-----------------

- HRClient: to send a request use AFNetworking/AFHTTPSessionManager
- HRModel: a model which contains all the parameters used for the request
- HRResponse: a base Model extends Mantle/MTLModel used to take the request response data
- HRError: take errors from your server or the session

I use a HRClient category in charge of the current function module, define api here.
ViewModel used to pass parameters, send request, take response and make it a Model:HRResponse.
View show the loading , display the response Model.

Usage:
### Model：
```objc
@interface HRUserModel : HRResponse
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <NSString *> *hobbies;
@end
```
### View:
```objc
@interface HRUserController ()
@property (nonatomic, strong) HRUserManager *manager;
@end

static NSString * const identifier = @"Cell";
@implementation HRUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    _manager = [[HRUserManager alloc] initWithUserId:_userId];
    [self getUserDetail];
}

- (void)getUserDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager getUserWithSuccess:^(HRUserModel *model) {
        self.navigationItem.title = _manager.user.name;
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    } failure:^(HRError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = error.message;
        [hud hideAnimated:YES afterDelay:1.8];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _manager.user.hobbies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = _manager.user.hobbies[indexPath.row];
    // Configure the cell...
    return cell;
}
```
### ViewModel:
```objc
@interface HRUserManager : NSObject
- (instancetype)initWithUserId:(NSString *)userId;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) HRUserModel *user;
- (void)getUserWithSuccess:(void (^)(HRUserModel *model))success failure:(void (^)(HRError *error))failure;
@end
```
```objc
@implementation HRUserManager

- (instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)getUserWithSuccess:(void (^)(HRUserModel *))success failure:(void (^)(HRError *))failure{
    NSAssert(_userId != nil, @"user id must not be nil");
    NSDictionary *paras = @{@"userId": _userId};
    [[HRClient baseClient] getUserWithParameters:paras success:^(id data) {
        _user = [MTLJSONAdapter modelOfClass:[HRUserModel class] fromJSONDictionary:data error:nil];
        success(_user);
    } failure:^(HRError *error) {
        failure(error);
    }];
}

@end
```
### Utils
```objc
@interface HRClient (User)
#define getUserApi @"/api/user/getUser"
- (void)getUserWithParameters:(NSDictionary *)paras success:(void (^)(id data))success failure:(void (^)(HRError *error))failure;
@end
```
```objc
@implementation HRClient (User)
- (void)getUserWithParameters:(NSDictionary *)paras success:(void (^)(id))success failure:(void (^)(HRError *))failure{
    HRModel *model = [HRModel modelWithURLString:getUserApi method:GET parameters:paras constructingBody:nil progress:nil];
    [self requestWithModel:model success:^(NSURLSessionDataTask *task, id data) {
        success(data);
    } failure:^(NSURLSessionDataTask *task, HRError *error) {
        failure(error);
    }];
}
@end
```