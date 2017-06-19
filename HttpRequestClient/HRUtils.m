//
//  HRUtils.m
//  HttpRequestClient
//
//  Created by 张雁军 on 19/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "HRUtils.h"
#import "UIAlertView+Handler.h"
#import "UIAlertController+Helper.h"

@implementation HRUtils

+ (NSString *)getToken{
    return @"2333";
}

+ (void)showError:(HRError *)error{
    [self showError:error alertHandler:nil];
}

+ (void)showError:(HRError *)error alertHandler:(void (^)())handler{
    switch (error.code) {
        case 10039://token out of date
        case 10040://authorization denied
        case 10041:{//forced logout
            //please login again
        }
            break;
            
        case 10046:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you want to try another tiem?", nil) message:error.message delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Retry", nil), nil];
            [alert showWithHandler:handler];
        }
            break;
            
        default:{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Request failed", nil) message:error.message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler();
                }
            }];
            [alertController addAction:action];
            [alertController show];
#else
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Request failed", nil) message:error.message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert showWithHandler:handler];
#endif
        }
            break;
    }
}

@end
