//
//  GalleryViewController.m
//  ImageViewer
//
//  Created by Tanvi Bhardwaj on 10/14/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import "GalleryViewController.h"

#import "AppDelegate.h"
#import "FlickrKit.h"
#import "GalleryImageCellView.h"
#import "ImageViewController.h"
#import "UtilsManager.h"

#define CELL_IDENTIFIER @"galleryCell"

@implementation GalleryViewController

@synthesize galleryView;

NSMutableArray *photoURLs;
UIActivityIndicatorView *activityIndicator;
UtilsManager *utilsManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBarForController:self.navigationController withItem:self.navigationItem withTitle:@"Gallery"];
    
    utilsManager = [AppDelegate getUtilsManager];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.color = [UIColor blackColor];
    
    photoURLs = [[NSMutableArray alloc] init];
    
    // Fetch images from Flickr
    [self fetchImageURLs];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [galleryView reloadData];
}

# pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Added one extra to trigger fetchMoreImages
    return [photoURLs count];
}

- (GalleryImageCellView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self imageCellForIndexPath:indexPath];
}

- (GalleryImageCellView *)imageCellForIndexPath:(NSIndexPath *)indexPath
{
    GalleryImageCellView *cell = [galleryView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [utilsManager loadImageAsyncInImageView:cell.imageHolder picUrl:[photoURLs objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    NSInteger imageWidth = screenWidth / 2.0 - 3;
    return CGSizeMake(imageWidth, imageWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewController *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageVC"];
    imageVC.imageIndex = indexPath.row;
    [self.navigationController pushViewController:imageVC animated:YES];
}

#pragma mark - Flickr API
- (void)fetchImageURLs
{
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [utilsManager fetchFlickrImagesWithFetchListener:^(BOOL foundImages)
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        if (foundImages)
        {
            [galleryView reloadData];
        }
    }];
}

- (void)fetchMoreImages
{
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [utilsManager fetchFlickrImagesWithFetchListener:^(BOOL foundImages)
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        if (foundImages)
        {
            [galleryView reloadData];
        }
    }];
}

#pragma Scroll view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Calculate where the collection view should be at the right-hand end item
    float contentOffsetWhenFullyScrolledRight = galleryView.frame.size.width * ([photoURLs count] -1);
    
    if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        [self fetchMoreImages];
        
    } else if (scrollView.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        [self fetchMoreImages];
    }
}

#pragma mark Navigation Bar
- (void)initNavigationBarForController:(UINavigationController *)navigationController withItem:(UINavigationItem *) navigationItem withTitle:(NSString *)title
{
    [navigationController setNavigationBarHidden:NO];
    navigationController.navigationBar.translucent = NO;
    
    // Setting navigation bar color
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(253/256.0) green:(92/256.0) blue:(99/256.0) alpha:1.0]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = title;
    
    // back button without text
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

+ (NSMutableArray *)getPhotoURLs
{
    return photoURLs;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
