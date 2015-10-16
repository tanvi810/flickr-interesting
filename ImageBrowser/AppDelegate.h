//
//  AppDelegate.h
//  ImageBrowser
//
//  Created by Tanvi Bhardwaj on 10/15/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UtilsManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (UtilsManager *)getUtilsManager;
+ (UIViewController *)previousViewController:(UINavigationController *)navController;

@end

