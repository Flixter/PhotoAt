//
//  PAFacebookManager.m
//  PhotoAt
//
//  Created by Viktor on 5/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAFacebookManager.h"

@implementation PAFacebookManager

-(id)init{
    self = [super init];
    
    if (self) {
        
        [FBLoginView class];
        
        self.permissions = [[NSArray alloc]initWithObjects:@"basic_info",@"user_photos",@"user_birthday",@"user_about_me",@"user_location",@"public_profile",@"user_friends", nil];
    }
    return self;
}


+ (id)facebookManager{
    
    static PAFacebookManager* facebookManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        facebookManager = [[self alloc]init];
    });
    return facebookManager;
}

- (void)checkForCachedToken{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSessionWithUI:NO];
    }
}

- (void)attemptToLogIn{
    [self openSessionWithUI:YES];
}

- (void)logOutUser{
    // If the session state is any of the two "open" states
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        [FBSession.activeSession closeAndClearTokenInformation];
        
    }
}


-(void)openSessionWithUI:(BOOL)showUI{
    [FBSession openActiveSessionWithReadPermissions:self.permissions
                                       allowLoginUI:showUI
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
         [self getUserInfo];
     }];
    
}
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)isUserLoggedIn{
    
    return FBSession.activeSession.isOpen;
}

- (void) userLoggedIn{
    [[NSNotificationCenter defaultCenter] postNotificationName:UserSucessfullyLogedIn object:nil];
}

- (void) userLoggedOut{
    //TODO LogOutUser
}

- (void)showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle{
    //TODO SHOW alert!
}

- (int)getAge{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString* date = [DateFormatter stringFromDate:[NSDate date]];
    NSArray *todayDateArray = [date componentsSeparatedByString:@"/"];
    NSArray *bornDateArray  = [_dateBorn componentsSeparatedByString:@"/"];
    int yearsDiff = [[todayDateArray objectAtIndex:2] intValue] - [[bornDateArray objectAtIndex:2] intValue];
    int monthDiff = [[todayDateArray objectAtIndex:0] intValue] - [[bornDateArray objectAtIndex:0] intValue];
    int daysDiff  = [[todayDateArray objectAtIndex:1] intValue] - [[bornDateArray objectAtIndex:1] intValue];
    if(monthDiff <= 0){
        if(daysDiff < 0)
            return yearsDiff - 1;
    }
    return yearsDiff;
}

- (void)getUserInfo{
    //    /* make the API call */
    //    [FBRequestConnection startWithGraphPath:@"/me"
    //                                 parameters:nil
    //                                 HTTPMethod:@"GET"
    //                          completionHandler:^(
    //                                              FBRequestConnection *connection,
    //                                              id result,
    //                                              NSError *error
    //                                              ) {
    //                              self.userName = [result objectForKey:@"name"];
    //                              NSDictionary *locatioNDict = [result objectForKey:@"location"];
    //                              self.country  = [locatioNDict objectForKey:@"name"];
    //                              self.dateBorn = [result objectForKey:@"birthday"];
    //                              self.gender   = [result objectForKey:@"gender"];
    //                              NSLog(@"Name: %@ , Country: %@, Birthday: %@, Gender: %@",self.userName,self.country,self.dateBorn,self.gender);
    //
    //                          }];
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            NSLog(@"Loading Facebook info failed with error: %@",error);
        }   else {
            NSLog(@"Facebook data loaded sucessfully! ");
            self.userName = [FBuser name];
            self.userProfilePicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser username]];
            [self getCoverPhoto];
        }
    }];
    
}

- (void)getCoverPhoto{
    [FBRequestConnection startWithGraphPath:@"me?fields=cover"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if(error){
                                  NSLog(@"Failed to load cover photo");
                              }else{
                                  NSDictionary *locatioNDict = [result objectForKey:@"cover"];
                                  self.userCoverPicUrl = [locatioNDict objectForKey:@"source"];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:UserFacebookInfoUpdate object:nil];
                              }
                          }];
    
}

- (void)getUserFriendsList{
    
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:nil HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result, NSError *error) {
                              if (error) {
                                  NSLog(@"Failed to load user friend list with error %@",error);
                              } else {
                                  if([[result objectForKey:@"data"] count] > 20)
                                      self.isUserSpammer = NO;
                                  else
                                      self.isUserSpammer = YES;
                              }
                          }];
    
}

#pragma Getting Photo Albums


//- (void)loadAlbumsNames:(ArrayCallback)callbackWithArray{
//
//    NSMutableArray *albumArray = [[NSMutableArray alloc]init];
//    [FBRequestConnection startWithGraphPath:@"me/albums?limit=100"
//                                 parameters:nil HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result, NSError *error) {
//                              if (error) {
//                                  callbackWithArray(NULL,error);
//                              } else {
//                                  for (NSDictionary *anAlbum in [result objectForKey:@"data"]) {
//                                      DAFBAlbum* album = [[DAFBAlbum alloc]init];
//                                      album.albumName       = [anAlbum objectForKey:@"name"];
//                                      album.albumPhotoCount = (NSNumber*)[anAlbum objectForKey:@"count"];
//                                      album.coverPhotoID    = [anAlbum objectForKey:@"cover_photo"];
//                                      album.albumID         = [anAlbum objectForKey:@"id"];
//                                      [albumArray addObject:album];
//                                  }
//
//                                  callbackWithArray(albumArray,NULL);
//                              }
//                          }];
//
//}

//- (void)loadAlbumPhotos:(DAFBAlbum *)album callback:(SuccessCallback)successCallback{
//    if([album.albumPhotoCount intValue] == album.albumURLs.count)
//        return;
//    NSString* graphPath;
//    if(album.nextPage)
//        graphPath = [NSString stringWithFormat:@"%@/photos?limit=100&after=%@",album.albumID,album.nextPage];
//    else
//        graphPath = [NSString stringWithFormat:@"%@/photos?limit=100",album.albumID];
//    [FBRequestConnection startWithGraphPath:graphPath
//                                 parameters:nil HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result, NSError *error) {
//                              if (error) {
//                                  successCallback(NULL,error);
//                              } else {
//                                  for (NSDictionary *anAlbum in [result objectForKey:@"data"]) {
//                                      NSString* sourceLink = [anAlbum objectForKey:@"source"];
//                                      NSString* thumbnLink = [anAlbum objectForKey:@"picture"];
//                                      DAFBPhoto* photo = [[DAFBPhoto alloc]initWithPhotoThumbUrl:thumbnLink photoSourceUrl:sourceLink];
//                                      [album.albumURLs addObject:photo];
//                                  }
//                                  NSDictionary* paging = [result objectForKey:@"paging"];
//                                  NSString* next = [paging objectForKey:@"next"];
//
//                                  NSLog(@"next: %@",next);
//                                  if(next){
//                                      NSDictionary* cursor = [paging objectForKey:@"cursors"];
//                                      NSString* after = [cursor objectForKey:@"after"];
//                                      album.nextPage = after;
//                                      NSLog(@"next: %@",after);
//                                  }else{
//                                      album.nextPage = nil;
//                                  }
//                                  successCallback(album ,NULL);
//                              }
//                          }];
//}

//- (void)loadProfilePictures:(SuccessCallback)successCallback{
//    [self loadAlbumsNames:^(NSMutableArray *result, NSError *error) {
//        for(DAFBAlbum *album in result){
//            if([album.albumName  isEqual: @"Profile Pictures"]){
//                [self loadAlbumPhotos:album callback:^(DAFBAlbum *album, NSError *error) {
//                    successCallback(album ,NULL);
//                }];
//            }
//        }
//    }];
//}

-(NSString *)getAccessToken{
    return [[[FBSession activeSession] accessTokenData] accessToken];
}

#pragma Handling Session Stat Changing
// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}



@end
