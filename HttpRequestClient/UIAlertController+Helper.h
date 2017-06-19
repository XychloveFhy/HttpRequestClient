//
//  UIAlertController+Helper.h
//  HttpRequestClient
//
//  Created by 张雁军 on 19/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import <UIKit/UIKit.h>

//https://stackoverflow.com/questions/26554894/how-to-present-uialertcontroller-when-not-in-a-view-controller
//At WWDC, I stopped in at one of the labs and asked an Apple Engineer this same question: "What was the best practice for displaying a UIAlertController?" And he said they had been getting this question a lot and we joked that they should have had a session on it. He said that internally Apple is creating a UIWindow with a transparent UIViewController and then presenting the UIAlertController on it. Basically what is in Dylan Betterman's answer.
//
//But I didn't want to use a subclass of UIAlertController because that would require me changing my code throughout my app. So with the help of an associated object, I made a category on UIAlertController that provides a show method in Objective-C.
@interface UIAlertController (Helper)
- (void)show;
- (void)show:(BOOL)animated;
@end
