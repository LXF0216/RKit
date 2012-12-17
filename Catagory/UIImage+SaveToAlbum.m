//
//  UIImage+SaveToAlbum.m
//  VMovier
//
//  Created by Alex Rezit on 17/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+SaveToAlbum.h"

@implementation UIImage (SaveToAlbum)

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    NSData *imageData = UIImagePNGRepresentation(self);
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    completionBlock();
                }
            } failureBlock:^(NSError *error) {
                failureBlock(error);
            }];
        } failureBlock:^(NSError *error) {
            failureBlock(error);
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        completionBlock();
                    } failureBlock:^(NSError *error) {
                        failureBlock(error);
                    }];
                } else {
                    AddAsset(assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
            }];
        } else {
            completionBlock();
        }
    }];
}

@end
