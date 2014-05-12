//
//  Util.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "Util.h"

@implementation Util

// Check if the current operaitn system is equal or larger from 7.0
+ (BOOL)isGreaterOrEqualToiOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

+ (NSString*)formatedDateFromSeconds:(int)totalSeconds
{
    int minutes = totalSeconds / 60;
    int seconds = totalSeconds % 60;
    
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

+ (NSString*)stringFromDeviceToken:(NSData*)deviceTokenData
{
    NSString *deviceToken = [[deviceTokenData description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return deviceToken;
}

+ (BOOL)isDeviceScreenBigerThanThreeFiveInches
{
    return [UIScreen mainScreen].bounds.size.height > 480;
}

@end
