//
//  UIImageView+LoadWebImage.h
//  VMovier
//
//  Created by Alex Rezit on 18/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWebImageController.h"

@interface UIImageView (LoadWebImage)

/*
 * Available modes:
 * * RWebImageControllerModeDefault
 * Use local cache if exists, otherwise download it.
 * * RWebImageControllerModeForceRefresh (Recommended when a Wi-Fi network is available.)
 * Ignore local cache, always download and update local cache.
 * - RWebImageControllerModeOfflineOnly (Recommended when there is no network connection.)
 * Use local cache if exists, otherwise use placeholder image, never download.
 */

+ (void)setRefreshMode:(RWebImageControllerMode)mode;

/*
 * Retry count is 3 if not specified. This will only be used when download is needed.
 * Cache policy is decided by current refresh mode while not using forceRefresh param.
 * You can use `+setRefreshMode:` method to specify a refresh mode, default is RWebImageControllerModeDefault.
 * You can use methods with `forceRefresh:(BOOL)forceRefresh` param to decide whether to force refresh or not, and current refresh mode will be ignored.
 */

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage retryCount:(NSUInteger)retryCount;

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage forceRefresh:(BOOL)forceRefresh;
- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage forceRefresh:(BOOL)forceRefresh retryCount:(NSUInteger)retryCount;

@end
