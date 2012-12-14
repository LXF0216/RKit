//
//  RHTTPRequest.m
//  RFoundation
//
//  Created by Alex Rezit on 14/12/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import "NSString+URLCoding.h"
#import "RHTTPRequest.h"

@implementation RHTTPRequest

NSString * const HTTPMethodGET = @"GET";
NSString * const HTTPMethodPOST = @"POST";
NSString * const HTTPMethodPUT = @"PUT";
NSString * const HTTPMethodHEAD = @"HEAD";
NSString * const HTTPMethodDELETE = @"DELETE";

+ (NSDictionary *)sendSynchronousRequestForURL:(NSURL *)url
                                        method:(NSString *)method
                                       headers:(NSDictionary *)headers
                                   requestBody:(NSDictionary *)requestDictionary
                               responseHeaders:(NSDictionary **)responseHeaders
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:6];
    request.HTTPMethod = method;
    request.allHTTPHeaderFields = headers;
    request.HTTPBody = [[NSString stringWithURLEncodedDictionary:requestDictionary] dataUsingEncoding:NSUTF8StringEncoding];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request release];
    *responseHeaders = response.allHeaderFields;
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *responseDictionary = responseString.URLDecodedDictionary;
    [responseString release];
    return responseDictionary;
}

+ (void)sendAsynchronousRequestForURL:(NSURL *)url
                               method:(NSString *)method
                              headers:(NSDictionary *)headers
                          requestBody:(NSDictionary *)requestDictionary
                           completion:(void (^)(NSDictionary *responseHeaders, NSDictionary *responseDictionary))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *responseHeaders = nil;
        NSDictionary *responseDictionary = [self sendSynchronousRequestForURL:url
                                                                       method:method
                                                                      headers:headers
                                                                  requestBody:requestDictionary
                                                              responseHeaders:&responseHeaders];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseHeaders, responseDictionary);
        });
    });
}

@end
