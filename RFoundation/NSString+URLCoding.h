//
//  NSString+URLCoding.h
//  VMovier
//
//  Created by Alex Rezit on 22/11/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLCoding)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

+ (id)stringWithURLEncodedDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)URLDecodedDictionary;

@end
