//
//  MCAsyncLoaderProgressiveLoadingController.m
//  MCAsyncLoader
//
//  Created by Baglan on 10/24/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCAsyncLoaderProgressiveLoadingController.h"

@interface MCAsyncLoaderProgressiveLoadingController () <NSURLConnectionDelegate> {
    NSFileHandle * _temporaryFileHandle;
    
}

@end

@implementation MCAsyncLoaderProgressiveLoadingController

- (id)initWithURL:(NSURL *)url key:(id)key
{
    self = [super init];
    if (self) {
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        _key = key;
        _status = MCAsyncLoader_Started;
    }
    return self;
}

- (double)receivedRatio
{
    double ratio = 0.0;
    @try {
        double received = _receivedBytes;
        double expected = _response.expectedContentLength;
        ratio = received / expected;
    }
    @catch (NSException *exception) {
        // Do nothing
    }
    return ratio;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Save response
    _response = response;
    
    // Create unique file path
    NSString * tempPath = NSTemporaryDirectory();
    NSString * uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    _temporaryFilePath = [tempPath stringByAppendingPathComponent:uniqueString];
    
    // Create file
    [[NSFileManager defaultManager] createFileAtPath:_temporaryFilePath contents:nil attributes:nil];
    
    // Open file fow writing
    _temporaryFileHandle = [NSFileHandle fileHandleForWritingAtPath:_temporaryFilePath];
    
    // Reset number of bytes
    _receivedBytes = 0;
    
    // Change status
    _status = MCAsyncLoader_ResponseReceived;
    
    // Send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_STARTED_NOTIFICATION object:_key  userInfo:@{@"controller" : self}];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_temporaryFileHandle writeData:data];
    _receivedBytes += data.length;
    _status = MCAsyncLoader_Loading;
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_UPDATED_NOTIFICATION object:_key userInfo:@{@"controller" : self}];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_temporaryFileHandle closeFile];
    [[NSFileManager defaultManager] removeItemAtPath:_temporaryFilePath error:nil];
    _status = MCAsyncLoader_Failed;
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FAILED_NOTIFICATION object:_key userInfo:@{@"controller" : self}];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_temporaryFileHandle closeFile];
    _status = MCAsyncLoader_Finished;
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_ASYNC_LOADER_PROGRESSIVE_LOADING_FINISHED_NOTIFICATION object:_key userInfo:@{@"controller" : self}];
}

- (void)dealloc
{
    [_temporaryFileHandle closeFile];
    [[NSFileManager defaultManager] removeItemAtPath:_temporaryFilePath error:nil];
}

@end
