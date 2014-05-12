//
//  PAFacebookManager.h
//  PhotoAt
//
//  Created by Viktor on 5/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PAFacebookManager : NSObject

@property (nonatomic, retain) NSArray* permissions;
@property (nonatomic, retain) NSString* gender;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* dateBorn;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userProfilePicUrl;
@property (nonatomic, retain) NSString* userCoverPicUrl;
@property bool isUserSpammer;

+ (id)facebookManager;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState )state error:(NSError *)error;
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
- (BOOL)isUserLoggedIn;
- (void)attemptToLogIn;
- (void)logOutUser;
- (void)checkForCachedToken;
- (void)getUserInfo;
- (NSString *)getAccessToken;
- (int)getAge;
@end