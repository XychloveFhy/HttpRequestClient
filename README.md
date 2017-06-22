# HttpRequestClient

for more information, please refer to [简书链接](http://www.jianshu.com/p/e6e2a6e8855e)

I made it last year for our projects, and it suits MVVM I think

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