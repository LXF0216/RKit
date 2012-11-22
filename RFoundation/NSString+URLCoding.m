//
//  NSString+URLCoding.m
//  VMovier
//
//  Created by Alex Rezit on 22/11/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import "NSString+URLCoding.h"

@implementation NSString (URLCoding)

- (NSString *)URLEncodedString
{
    CFStringRef resultString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (CFStringRef)self,
                                                                          NULL,
                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                          kCFStringEncodingUTF8);
    return [(NSString *)resultString autorelease];
}

- (NSString *)URLDecodedString
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (id)stringWithURLEncodedDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:dictionary.count];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *component = [NSString stringWithFormat:@"%@=%@",
                               [key URLEncodedString],
                               [obj URLEncodedString]];
        [components addObject:component];
    }];
    NSString *resultString = [components componentsJoinedByString:@"&"];
    [components release];
    return resultString;
}

- (NSDictionary *)URLDecodedDictionary
{
    NSArray *components = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *decodedDictionary = [[NSMutableDictionary alloc] initWithCapacity:components.count];
    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *component = (NSString *)obj;
        NSUInteger dividerLocation = [component rangeOfString:@"="].location;
        if (dividerLocation != NSNotFound &&
            dividerLocation > 0 &&
            dividerLocation < component.length - 1) {
            NSString *key = [component substringToIndex:dividerLocation].URLDecodedString;
            NSString *value = [component substringFromIndex:dividerLocation + 1].URLDecodedString;
            if (![decodedDictionary.allKeys containsObject:key]) {
                [decodedDictionary setValue:value forKey:key];
            } else {
                NSString *oldValue = [decodedDictionary valueForKey:key];
                [decodedDictionary setValue:@[value, oldValue] forKey:key];
            }
        } else {
            NSLog(@"NSString (URLCoding): Wrong param: \"%@\"", component);
        }
    }];
    return decodedDictionary;
}

@end
