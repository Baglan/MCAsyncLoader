//
//  MCAsyncLoaderProgressiveLoadingController.h
//  MCAsyncLoader
//
//  Created by Baglan on 10/24/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MC_ASYNC_LOADER_PROGRESSIVE_LOADING_STARTED_NOTIFICATION    @"MCAsyncLoaderProgressiveLoadingStartedNotification"
#define MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FAILED_NOTIFICATION     @"MCAsyncLoaderProgressiveLoadingFailedNotification"
#define MC_ASYNC_LOADER_PROGRESSIVE_LOADING_UPDATED_NOTIFICATION    @"MCAsyncLoaderProgressiveLoadingUpdatedNotification"
#define MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FINISHED_NOTIFICATION   @"MCAsyncLoaderProgressiveLoadingFinishedNotification"

enum MCAsyncLoaderStatus {
    MCAsyncLoader_Started,
    MCAsyncLoader_ResponseReceived,
    MCAsyncLoader_Loading,
    MCAsyncLoader_Finished,
    MCAsyncLoader_Failed
};

@interface MCAsyncLoaderProgressiveLoadingController : NSObject

- (id)initWithURL:(NSURL *)url key:(id)key;

@property (nonatomic, readonly) id key;
@property (nonatomic, readonly) NSURLResponse * response;
@property (nonatomic, readonly) long long receivedBytes;
@property (nonatomic, readonly) NSString * temporaryFilePath;
@property (nonatomic, readonly) enum MCAsyncLoaderStatus status;

@end
