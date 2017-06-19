//
//  ViewController.m
//  HttpRequestClient
//
//  Created by 张雁军 on 14/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "ViewController.h"
#import "HRGirlFriendsController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Programmer No.2333";
    self.navigationItem.rightBarButtonItem.title = @"His Girlfriends";
}

- (IBAction)showGirlFriends:(id)sender {
    HRGirlFriendsController *vc = [[HRGirlFriendsController alloc] init];
    vc.userId = @"666";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
