//
//  UIImageView+LoadWebImage.m
//  VMovier
//
//  Created by Alex Rezit on 18/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+LoadWebImage.h"

#define kImageViewLoadWebImageDefaultRetryCount 3
#define kRWebImageLoadAnimationKey @"RWebImageLoadAnimationKey"

@implementation UIImageView (LoadWebImage)

+ (void)setRefreshMode:(RWebImageControllerMode)mode
{
    [RWebImageController sharedController].mode = mode;
}

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage
{
    [self setImageWithURL:imageURL placeholderImage:placeholderImage retryCount:kImageViewLoadWebImageDefaultRetryCount];
}

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage retryCount:(NSUInteger)retryCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSUInteger retry = 0; retry < retryCount; retry++) {
                UIImage *image = [[RWebImageController sharedController] getImageFromURL:imageURL];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CATransition *animation = [CATransition animation];
                        animation.type = kCATransitionFade;
                        [self.layer addAnimation:animation forKey:kRWebImageLoadAnimationKey];
                        self.image = image;
                    });
                    break;
                }
            }
        });
    });
}

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage forceRefresh:(BOOL)forceRefresh
{
    [self setImageWithURL:imageURL placeholderImage:placeholderImage forceRefresh:forceRefresh retryCount:kImageViewLoadWebImageDefaultRetryCount];
}

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage forceRefresh:(BOOL)forceRefresh retryCount:(NSUInteger)retryCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSUInteger retry = 0; retry < retryCount; retry++) {
                UIImage *image = [[RWebImageController sharedController] getImageFromURL:imageURL forceRefresh:forceRefresh];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CATransition *animation = [CATransition animation];
                        animation.type = kCATransitionFade;
                        [self.layer addAnimation:animation forKey:kRWebImageLoadAnimationKey];
                        self.image = image;
                    });
                    break;
                }
            }
        });
    });
}

@end
