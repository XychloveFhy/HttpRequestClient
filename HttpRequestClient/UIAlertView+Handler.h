//
//  UIAlertView+Handler.h
//  HttpRequestClient
//
//  Created by 张雁军 on 19/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Handler)(UIAlertView *alertView, NSUInteger buttonIndex);

@interface UIAlertView (Handler)
- (void)showWithHandler:(Handler)handler;
@end
