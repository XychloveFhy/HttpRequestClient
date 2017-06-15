# HttpRequestClient

去年做的一个比较适合于MVVM模式的Http请求框架 摘出来整理整理

- HRClient: 发起请求 AFNetworking
- HRModel: 请求参数模型
- HRResponse: 继承Mantle的模型基类
- HRError: 错误

每个模块做一个HRClient类别负责当前模块请求，当前模块的接口定义在当前分类，避免混乱
ViewModel负责传递参数发起请求接收返回结果并转成HRResponse模型
View(VC)展现ViewModel获取的RResponse模型数据

用法举例:
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