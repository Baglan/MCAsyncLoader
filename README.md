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

## License

This code is distributed under the MIT license.