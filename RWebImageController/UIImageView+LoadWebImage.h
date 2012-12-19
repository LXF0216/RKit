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

+ (void)setRefreshMode:(RWebImageControllerMode)mode;

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage retryCount:(NSUInteger)retryCount;

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage forceRefresh:(BOOL)forceRefresh;
- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage forceRefresh:(BOOL)forceRefresh retryCount:(NSUInteger)retryCount;

@end
