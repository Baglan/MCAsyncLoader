# MCAsyncLoader

## Goal of this project

Create an easy to use asychronous loader based on nitifications.

## Installation

1. Drag files from the "Classes" folder to your project;
2. #import "MCAsyncLoader.h"

## Usage

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

## License

This code is distributed under the MIT license.