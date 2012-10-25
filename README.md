# MCAsyncLoader

## Goal of this project

Create an easy to use asychronous loader based on nitifications.

## Installation

1. Drag files from the "Classes" folder to your project;
2. #import "MCAsyncLoader.h"

## Usage

### Load and pre-render image

In case of success, userInfo parameter of the notificatin object will contain an "image" field which will point to a pre-rendered (in other words, ready to use without any additional operations) UIImage object.

Register an observer for the MC_ASYNC_LOADER_IMAGE_LOADED_AND_PRERENDERED_NOTIFICATION notification:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageLoaded:) name:MC_ASYNC_LOADER_IMAGE_LOADED_AND_PRERENDERED_NOTIFICATION object:nil];

Add a method to process notifications:

    - (void)onImageLoaded:(NSNotification *)loadedNotification
    {
        UIImageView *imageView = [_imageViews objectForKey:loadedNotification.object];
        UIImage *image = [loadedNotification.userInfo objectForKey:@"image"];
        imageView.image = image;
    }

Call the loadAndPrerenderImageFromURL:forKey: method:

    [MCAsyncLoader loadAndPrerenderImageFromURL:imageURL forKey:key];
    
### Load data

In case of success, userInfo parameter of the notificatin object will contain an "data" field which will point to an NSData object containing the loaded data.

Register an observer for the MC_ASYNC_LOADER_DATA_LOADED_NOTIFICATION notification:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataLoaded:) name:MC_ASYNC_LOADER_DATA_LOADED_NOTIFICATION object:nil];

Add a method to process notifications:

    - (void)onDataLoaded:(NSNotification *)loadedNotification
    {
        NSData *data = [loadedNotification.userInfo objectForKey:@"data"];
        // ...
    }

Call the loadAndPrerenderImageFromURL:forKey: method:

    [MCAsyncLoader loadDataFromURL:daraURL forKey:key];
    
### Load and parse JSON

In case of success, userInfo parameter of the notificatin object will contain an "json" field which will point to an NSArray or NSDictionary object containing the loaded and parsed JSON data.

Register an observer for the MC_ASYNC_LOADER_JSON_LOADED_NOTIFICATION notification:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onJSONLoaded:) name:MC_ASYNC_LOADER_JSON_LOADED_NOTIFICATION object:nil];

Add a method to process notifications:

    - (void)onJSONLoaded:(NSNotification *)loadedNotification
    {
        id json = [loadedNotification.userInfo objectForKey:@"json"];
        // ...
    }

Call the loadAndPrerenderImageFromURL:forKey: method:

    [MCAsyncLoader loadJSONFromURL:jsonURL forKey:key];
    
### Load large files

Register observers for various loading events:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingStarted:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_STARTED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingUpdated:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_UPDATED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingFailed:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FAILED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingFinished:) name:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FINISHED_NOTIFICATION object:nil];

Implement methods to handle those events. Additional info is available through the notification.userInfo[@"controller"]:

    - (void)loadingStarted:(NSNotification *)notification
    {
        // ...
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
        MCAsyncLoaderProgressiveLoadingController * controller = notification.userInfo[@"controller"];
        NSString * temporaryFilePath = controller.temporaryFilePath;
        
        // Do something with the temporary file
    }

    - (void)loadingFailed:(NSNotification *)notification
    {
        // ...
    }

Call the +loadProgressivelyFromURL:forKey: method

    NSURL * videoURL = [NSURL URLWithString:@"http://www.example.com/large_file.mp4"];
    [MCAsyncLoader loadProgressivelyFromURL:videoURL forKey:@"video"];

## License

This code is distributed under the MIT license.