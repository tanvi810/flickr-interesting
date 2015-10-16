//
//  ImageViewController.h
//  ImageBrowser
//
//  Created by Tanvi Bhardwaj on 10/16/15.
//  Copyright © 2015 Tanvi Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger imageIndex;

@end