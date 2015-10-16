//
//  AppDelegate.m
//  ImageViewer
//
//  Created by Tanvi Bhardwaj on 10/14/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import "AppDelegate.h"

#import "FlickrKit.h"
#import "GalleryViewController.h"
#import "UtilsManager.h"

static UtilsManager *utilsManager;

@implementation AppDelegate
{
    UINavigationController *navController;
    GalleryViewController *galleryVC;
}

@synthesize window;

NSString *FlickrApiKey = @"c07a3751619c0e5d91cee829abd5d975";
NSString *FlickrSecret = @"a549fa60451ab3c5";

+ (void)initialize
{
    utilsManager = [[UtilsManager alloc] init];
}

+ (UtilsManager *)getUtilsManager
{
    return utilsManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialising FlickrKit with the flickr api key and shared secret
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:FlickrApiKey sharedSecret:FlickrSecret];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    galleryVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GalleryVC"];
    navController = [[UINavigationController alloc] initWithRootViewController:galleryVC];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (UIViewController *)previousViewController:(UINavigationController *)navController
{
    NSInteger numControllersInStack = navController.viewControllers.count;
    return (numControllersInStack < 2) ? nil : [navController.viewControllers objectAtIndex:(numControllersInStack - 2)];
}

@end
