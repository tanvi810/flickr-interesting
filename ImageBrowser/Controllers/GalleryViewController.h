//
//  GalleryViewController.h
//  ImageViewer
//
//  Created by Tanvi Bhardwaj on 10/14/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrKit.h"

@interface GalleryViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *galleryView;

+ (NSMutableArray *)getPhotoURLs;

@end

