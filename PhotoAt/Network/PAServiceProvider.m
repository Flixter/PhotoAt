//
//  PAServiceProvider.m
//  PhotoAt
//
//  Created by Viktor on 5/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAServiceProvider.h"

@implementation PAServiceProvider

+ (id)sharedProvider{
    static PAServiceProvider *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSMutableURLRequest*)imageRequestForURL:(NSString*)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    return request;
}

@end
