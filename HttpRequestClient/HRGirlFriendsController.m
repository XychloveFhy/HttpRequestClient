//
//  HRGirlFriendsController.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRGirlFriendsController.h"
#import "HRGirlFriendsManager.h"
#import <MBProgressHUD.h>
#import "HRUtils.h"

@interface HRGirlFriendsController ()
@property (nonatomic, strong) HRGirlFriendsManager *manager;
@end

static NSString * const identifier = @"Cell";
@implementation HRGirlFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"No.2333's Girlfriends";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.rowHeight = 90;
    _manager = [[HRGirlFriendsManager alloc] initWithUserId:_userId];
    [self getUserDetail];
}

- (void)getUserDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_manager getGirlFriendsWithSuccess:^{
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
    return _manager.girlfriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    HRGirlFriendModel *model = _manager.girlfriends[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"Name:%@ Age:%ld B/W/H:%@", model.name, model.age, model.sanwei];
    cell.textLabel.text = string;
    cell.textLabel.numberOfLines = 0;
    // Configure the cell...
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
