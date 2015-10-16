//
//  UtilsManager.m
//  ImageBrowser
//
//  Created by Tanvi Bhardwaj on 10/16/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import "UtilsManager.h"

#import "FlickrKit.h"
#import "GalleryViewController.h"
#import "UIImageView+WebCache.h"

#define IMAGES_PER_PAGE 10

@implementation UtilsManager

NSInteger pageNumber;

- (id)init
{
    self = [super init];
    if (self)
    {
        pageNumber = 1;
    }
    return self;
}

- (void)fetchFlickrImagesWithFetchListener:(void(^)(BOOL foundImages))listener
{
    NSMutableArray *photoURLs = [GalleryViewController getPhotoURLs];
    
    // Fetching the most interesting photos for the day.
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.per_page = [NSString stringWithFormat:@"%d", IMAGES_PER_PAGE];
    interesting.page = [NSString stringWithFormat:@"%ld", pageNumber];
    pageNumber = pageNumber + 1;
    FKFlickrNetworkOperation *todaysInterestingOperation = [[FlickrKit sharedFlickrKit] call:interesting completion:^(NSDictionary *response, NSError *error)
    {
        if (response)
        {
            for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
            {
                NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                [photoURLs addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                if (listener)
                {
                    listener(YES);
                }
            });
        }
        else
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorAlert show];
            if (listener)
            {
                listener(NO);
            }
        }
    }];
}

- (void)loadImageAsyncInImageView:(UIImageView *)imageView picUrl:(NSURL *)picUrl
{
    [imageView sd_setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

@end
