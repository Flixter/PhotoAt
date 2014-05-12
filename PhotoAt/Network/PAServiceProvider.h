//
//  PAServiceProvider.h
//  PhotoAt
//
//  Created by Viktor on 5/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAServiceProvider : NSObject

+ (id)sharedProvider;

- (NSMutableURLRequest*)imageRequestForURL:(NSString *)url;

@end
