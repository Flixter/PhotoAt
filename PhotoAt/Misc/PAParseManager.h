//
//  PAParseManager.h
//  PhotoAt
//
//  Created by Viktor on 8/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

@protocol PAParseManagerPostsDelegate <NSObject>
- (void)didFinishFetchingPosts:(NSArray *) posts;
@end

#import <Foundation/Foundation.h>
#import <Parse-iOS-SDK/Parse.h>

@interface PAParseManager : NSObject
+ (id)parseManager;
- (void)checkInWithComment:(NSString *)commentText checkInPlace:(NSString *)checkInPlce Image:(UIImage *)image userRating:(NSNumber*) rating Longitude:(float) longitude Latitude:(float)latitude countryName:(NSString *)countryName;

- (void)fetchPlaces;
- (void)fetchPlacesForCountry:(NSString*) country;
- (void)createPushNotification;
- (void)fetchPlacesForPlace:(PFObject*) place;

@property (nonatomic, weak) id <PAParseManagerPostsDelegate> postsFetchedDelegate;
@end
