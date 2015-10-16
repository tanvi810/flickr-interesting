//
//  ImageViewController.m
//  ImageBrowser
//
//  Created by Tanvi Bhardwaj on 10/16/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import "ImageViewController.h"

#import "AppDelegate.h"
#import "FlickrKit.h"
#import "GalleryViewController.h"
#import "UtilsManager.h"

@implementation ImageViewController

UIActivityIndicatorView *activity;
UtilsManager *utilManager;
NSMutableArray *imageURLs;

@synthesize imageIndex, imageView, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utilManager = [AppDelegate getUtilsManager];
    imageURLs = [GalleryViewController getPhotoURLs];
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = [UIColor blackColor];
    
    // Back button without text.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    // Adding left swipe gesture
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeDone:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    // Adding right swipe gesture
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeDone:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    
    // Adding double tap gesture
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapZoomIn:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:doubleTap];
    
    // Loading image
    [utilManager loadImageAsyncInImageView:imageView picUrl:[imageURLs objectAtIndex:imageIndex]];
    [self.imageView sizeToFit];
    
    // Setting scroll view attributes
    scrollView.contentSize = imageView.image.size;
    self.scrollView.delegate = self;
    scrollView.maximumZoomScale = 2.5f;
    scrollView.minimumZoomScale = 1.0f;
    
    // Navigation bar title
    self.navigationItem.title = @"Image";
}

#pragma mark Gestures
- (void)leftSwipeDone:(id)sender
{
    if (imageIndex + 1 < [[GalleryViewController getPhotoURLs] count])
    {
        [self showNextImage];
    }
    else
    {
        [self fetchMoreImages];
    }
}

- (void)rightSwipeDone:(id)sender
{
    if (imageIndex - 1 >= 0)
    {
        ImageViewController *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageVC"];
        imageVC.imageIndex = imageIndex - 1;
        
        // To show a pop animation effect
        CATransition *animation = [CATransition animation];
        [self.navigationController pushViewController:imageVC animated:NO];
        [animation setDuration:0.45];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [[imageVC.view layer] addAnimation:animation forKey:@"ViewFromLeft"];
        
        // Removing the previous controller from stack.
        UIViewController *previousViewController = [AppDelegate previousViewController:self.navigationController];
        NSMutableArray *navigationStack = [[NSMutableArray alloc] initWithArray:
                                           self.navigationController.viewControllers];
        [navigationStack removeObject:previousViewController];
        self.navigationController.viewControllers = navigationStack;
    }
}

- (void)doubleTapZoomIn:(UITapGestureRecognizer*)recognizer
{
    CGPoint tapOnPoint = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 2.0f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = tapOnPoint.x - (w / 2.0f);
    CGFloat y = tapOnPoint.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark fetchMoreImages
- (void)fetchMoreImages
{
    activity.center = self.view.center;
    [self.view addSubview:activity];
    [activity startAnimating];
    
    [[AppDelegate getUtilsManager] fetchFlickrImagesWithFetchListener:^(BOOL foundImages)
    {
        [activity stopAnimating];
        [activity removeFromSuperview];
        if (foundImages && imageIndex + 1 < [imageURLs count])
        {
            [self showNextImage];
        }
    }];
}

- (void)showNextImage
{
    ImageViewController *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageVC"];
    imageVC.imageIndex = imageIndex + 1;
    
    // To show a push animation effect
    CATransition *animation = [CATransition animation];
    [self.navigationController pushViewController:imageVC animated:NO];
    [animation setDuration:0.45];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[imageVC.view layer] addAnimation:animation forKey:@"ViewFromLeft"];
    
    // Removing the previous controller from stack.
    UIViewController *previousViewController = [AppDelegate previousViewController:self.navigationController];
    NSMutableArray *navigationStack = [[NSMutableArray alloc] initWithArray:
                                       self.navigationController.viewControllers];
    [navigationStack removeObject:previousViewController];
    self.navigationController.viewControllers = navigationStack;
}

#pragma mark Scroll View delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end