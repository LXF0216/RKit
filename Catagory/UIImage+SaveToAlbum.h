//
//  UIImage+SaveToAlbum.h
//  VMovier
//
//  Created by Alex Rezit on 17/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SaveToAlbum)

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock;

@end
