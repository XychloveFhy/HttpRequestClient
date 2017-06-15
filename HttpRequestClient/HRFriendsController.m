//
//  HRFriendsController.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRFriendsController.h"
#import "HRFriendsManager.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>

@interface HRFriendsController ()
@property (nonatomic) HRFriendsManager *manager;
@end

@implementation HRFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [[HRFriendsManager alloc] init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _manager.pageIndex = 1;
        [self getFriends];
    }];

    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        _manager.pageIndex ++;
        [self getFriends];
    }];
}

- (void)getFriends{
    int pageIndex = _manager.pageIndex;
    [_manager getFriendsWithSuccess:^(NSArray<HRFriendModel *> *friends) {
        if (pageIndex == 1) {
            [self.manager.friends removeAllObjects];
            [self.manager.friends addObjectsFromArray:friends];
            if (self.manager.friends.count >= self.manager.Count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.manager.friends addObjectsFromArray:friends];
            if (self.manager.friends.count >= self.manager.Count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [self.tableView reloadData];
    } failure:^(HRError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    return _manager.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"location"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"location"];
    }
    HRFriendModel *model = _manager.friends[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
