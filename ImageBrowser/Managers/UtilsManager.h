//
//  UtilsManager.h
//  ImageBrowser
//
//  Created by Tanvi Bhardwaj on 10/16/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilsManager : NSObject

- (void)fetchFlickrImagesWithFetchListener:(void(^)(BOOL foundImages))listener;
- (void)loadImageAsyncInImageView:(UIImageView *)imageView picUrl:(NSURL *)picUrl;

@end