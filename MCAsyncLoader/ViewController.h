//
//  ViewController.h
//  MCAsyncLoader
//
//  Created by Baglan on 10/3/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UIProgressView *_loadingProgressView;
    __weak IBOutlet UILabel *_loadingStatusLabel;
}

@end
