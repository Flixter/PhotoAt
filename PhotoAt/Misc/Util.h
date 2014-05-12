//
//  Util.h
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
// Check if the current operaitn system is equal or larger from 7.0
+ (BOOL)isGreaterOrEqualToiOS7;

+ (NSString*)formatedDateFromSeconds:(int)totalSeconds;

+ (NSString*)stringFromDeviceToken:(NSData*)deviceTokenData;

+ (BOOL)isDeviceScreenBigerThanThreeFiveInches;

@end
