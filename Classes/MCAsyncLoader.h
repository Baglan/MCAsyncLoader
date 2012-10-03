//
//  MCAsyncLoader.h
//  MCAsyncLoader
//
//  Created by Baglan on 10/3/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MC_ASYNC_LOADER_IMAGE_LOADED_AND_PRERENDERED_NOTIFICATION   @"MCAsyncLoaderImageLoadedAndPrerenderedNotification"
#define MC_ASYNC_LOADER_IMAGE_LOADING_FAILED_NOTIFICATION           @"MCAsyncLoaderImageLoadingFailedNotification"

@interface MCAsyncLoader : NSObject

+ (void)loadAndPrerenderImageFromURL:(NSURL *)url forKey:(id)key;

@end
