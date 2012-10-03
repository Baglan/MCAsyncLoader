//
//  MCAsyncLoader.m
//  MCAsyncLoader
//
//  Created by Baglan on 10/3/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCAsyncLoader.h"

@interface MCAsyncLoader () {
    NSCache *_imageCache;
}

@end

@implementation MCAsyncLoader

// Sound board singleton
// Taken from http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
+ (MCAsyncLoader *)sharedInstance
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
    }
    return self;
}

+ (UIImage *)renderImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (void)loadAndPrerenderImageFromURL:(NSURL *)url forKey:(id)key
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("MCAsyncLoader:loadAndPrerenderImageFromURL", NULL);
    
    dispatch_async(downloadQueue, ^(void) {
        UIImage *prerenderedImage = nil;
        
        prerenderedImage = [_imageCache objectForKey:url];
        if (prerenderedImage == NULL) {
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            prerenderedImage = [self.class renderImage:image];
        }
        
        if (prerenderedImage) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MC_ASYNC_LOADER_IMAGE_LOADED_AND_PRERENDERED_NOTIFICATION
                                                                    object:key
                                                                  userInfo:@{@"image" : prerenderedImage}];
            });
            [_imageCache setObject:prerenderedImage forKey:url];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MC_ASYNC_LOADER_IMAGE_LOADING_FAILED_NOTIFICATION
                                                                    object:key
                                                                  userInfo:nil];
            });
            
        }
    });
    
    // dispatch_release(downloadQueue);
}

+ (void)loadAndPrerenderImageFromURL:(NSURL *)url forKey:(id)key
{
    [[self sharedInstance] loadAndPrerenderImageFromURL:url forKey:key];
}

@end