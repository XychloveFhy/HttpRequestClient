//
//  HRGirlfriendsController.m
//  HttpRequestClient
//
//  Created by 张雁军 on 15/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRGirlfriendsController.h"
#import "HRGirlfriendManager.h"
#import <MBProgressHUD.h>
#import "HRUtils.h"
#import <UIImageView+WebCache.h>
#import "HRGirlfriendCell.h"

@interface HRGirlfriendsController ()
@property (nonatomic, strong) HRGirlfriendManager *manager;
@end

static NSString * const identifier = @"Cell";
@implementation HRGirlfriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Detail";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload Girl" style:0 target:self action:@selector(uploadAvatar)];
    [self.tableView registerClass:[HRGirlfriendCell class] forCellReuseIdentifier:identifier];
    self.tableView.rowHeight = 90;
    _manager = [[HRGirlfriendManager alloc] initWithUserId:_userId];
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

- (void)uploadAvatar{
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"girl0.jpg"]];
    imageview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/250 *190.5);
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    UIViewController *pickImageController = [[UIViewController alloc] init];
    pickImageController.view.backgroundColor = [UIColor whiteColor];
    [pickImageController.view addSubview:imageview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pickImageController dismissViewControllerAnimated:YES completion:^{
            _manager.girl = [UIImage imageNamed:@"girl0.jpg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeDeterminate;
            [_manager uploadGirlProgress:^(NSProgress *progress) {
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
        }];
    });
    [self presentViewController:pickImageController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _manager.girlfriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HRGirlfriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //not very vm, just for example
    HRGirlfriend *model = _manager.girlfriends[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"Name:%@  Age:%ld  B/W/H:%@", model.name, model.age, model.sanwei];
    cell.detailTextLabel.text = string;
    cell.detailTextLabel.numberOfLines = 0;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.url]];

    // Configure the cell...
    return cell;
}

#pragma mark - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
