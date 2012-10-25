//
//  ViewController.m
//  MCAsyncLoader
//
//  Created by Baglan on 10/3/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "ViewController.h"
#import "MCAsyncLoader.h"

@interface ViewController () {
    NSMutableDictionary *_imageViews;
}

@end

#define NUMBER_OF_IMAGES        20
#define IMAGE_URL_FORMAT        @"http://mobicreators.com/experiments/MCAsyncLoader/%d.jpg"
#define PLACEHOLDER_IMAGE_NAME  @"placeholder.jpg"

@implementation ViewController

- (void)onImageLoaded:(NSNotification *)loadedNotification
{
    UIImageView *imageView = [_imageViews objectForKey:loadedNotification.object];
    UIImage *image = [loadedNotification.userInfo objectForKey:@"image"];
    imageView.image = image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGSize imageViewSize = _scrollView.frame.size;
    
    // Set content size
    CGSize contentSize = _scrollView.frame.size;
    contentSize.width = contentSize.width * NUMBER_OF_IMAGES;
    _scrollView.contentSize = contentSize;
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageLoaded:) name:MC_ASYNC_LOADER_IMAGE_LOADED_AND_PRERENDERED_NOTIFICATION object:nil];
    
    // Add images
    _imageViews = [NSMutableDictionary dictionary];
    for (int i=0; i<NUMBER_OF_IMAGES; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_NAME]];
        [imageView setFrame:CGRectMake(imageViewSize.width * i, 0, imageViewSize.width, imageViewSize.height)];
        [_scrollView addSubview:imageView];
        imageView.backgroundColor = [UIColor redColor];
        id key = [NSString stringWithFormat:@"%d", i];
        [_imageViews setObject:imageView forKey:key];
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_URL_FORMAT, i]];
        [MCAsyncLoader loadAndPrerenderImageFromURL:imageURL forKey:key];
    }
    
    // Loading a large file
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingStarted:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_STARTED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingUpdated:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_UPDATED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingFailed:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FAILED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingFinished:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FINISHED_NOTIFICATION object:nil];
    
    NSURL * videoURL = [NSURL URLWithString:@"http://tools.mobicreators.com/video/intro.mp4"];
    [MCAsyncLoader loadProgressivelyFromURL:videoURL forKey:@"video"];
    
}

#pragma mark -
#pragma mark Loading a large file

- (void)loadingStarted:(NSNotification *)notification
{
    _loadingStatusLabel.text = @"Started";
}

- (void)loadingUpdated:(NSNotification *)notification
{
    MCAsyncLoaderProgressiveLoadingController * controller = notification.userInfo[@"controller"];
    int mb = 1024 * 1024;
    float received = controller.receivedBytes;
    float expected = controller.response.expectedContentLength;
    _loadingProgressView.progress = received / expected;
    _loadingStatusLabel.text = [NSString stringWithFormat:@"%.1f of %.1f Mb", received / mb, expected / mb];
}

- (void)loadingFinished:(NSNotification *)notification
{
    _loadingStatusLabel.text = @"Finished";
    
    MCAsyncLoaderProgressiveLoadingController * controller = notification.userInfo[@"controller"];
    NSString * temporaryFilePath = controller.temporaryFilePath;
}

- (void)loadingFailed:(NSNotification *)notification
{
    _loadingStatusLabel.text = @"Failed";
}

@end
