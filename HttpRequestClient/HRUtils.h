//
//  HRUtils.h
//  HttpRequestClient
//
//  Created by 张雁军 on 19/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRError.h"

@interface HRUtils : NSObject

+ (NSString *)getToken;

+ (void)showError:(HRError *)error;

/**
 show UIAlertView with 'OK'
 
 @param error <#error description#>
 @param handler something to do when clicked OK
 */
+ (void)showError:(HRError *)error alertHandler:(void(^)())handler;

@end
