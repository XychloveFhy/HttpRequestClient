//
//  UIAlertView+Handler.m
//  HttpRequestClient
//
//  Created by 张雁军 on 19/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "UIAlertView+Handler.h"
#import <objc/message.h>

@implementation UIAlertView (Handler)

static char key;

- (void)showWithHandler:(Handler)handler{
    if (handler) {
        objc_setAssociatedObject(self, &key, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Handler handler = objc_getAssociatedObject(self, &key);
    objc_removeAssociatedObjects(self);
    if (handler) {
        handler(alertView, buttonIndex);
    }
}

@end
