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
#define MC_ASYNC_LOADER_DATA_LOADED_NOTIFICATION                    @"MCAsyncLoaderDataLoadedNotification"
#define MC_ASYNC_LOADER_DATA_LOADING_FAILED_NOTIFICATION            @"MCAsyncLoaderDataLoadingFailedNotification"
#define MC_ASYNC_LOADER_JSON_LOADED_NOTIFICATION                    @"MCAsyncLoaderJSONLoadedNotification"
#define MC_ASYNC_LOADER_JSON_LOADING_FAILED_NOTIFICATION            @"MCAsyncLoaderJSONLoadingFailedNotification"

@interface MCAsyncLoader : NSObject

+ (void)loadAndPrerenderImageFromURL:(NSURL *)url forKey:(id)key;
+ (void)loadDataFromURL:(NSURL *)url forKey:(id)key;
+ (void)loadJSONFromURL:(NSURL *)url forKey:(id)key;

@end
