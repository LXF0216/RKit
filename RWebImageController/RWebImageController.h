//
//  RWebImageController.h
//  VMovier
//
//  Created by Alex Rezit on 19/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWebImageController : NSObject

typedef enum {
    RWebImageControllerModeDefault = 0,
    RWebImageControllerModeForceRefresh,
    RWebImageControllerModeOfflineOnly
} RWebImageControllerMode;

@property (nonatomic, assign) RWebImageControllerMode mode;

+ (RWebImageController *)sharedController;

- (UIImage *)getImageFromURL:(NSURL *)url;
- (void)getImageFromURL:(NSURL *)url completion:(void (^)(UIImage *image))completion;

- (UIImage *)getImageFromURL:(NSURL *)url forceRefresh:(BOOL)forceRefresh;
- (void)getImageFromURL:(NSURL *)url forceRefresh:(BOOL)forceRefresh completion:(void (^)(UIImage *image))completion;

@end
