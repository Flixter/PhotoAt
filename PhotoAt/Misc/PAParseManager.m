//
//  PAParseManager.m
//  PhotoAt
//
//  Created by Viktor on 8/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAParseManager.h"
#import "PAFacebookManager.h"

@implementation PAParseManager

-(id)init{
    self = [super init];
    if(self){
        [Parse setApplicationId:parseId
                      clientKey:parseClientKey];
    }
    return self;
}

+ (id)parseManager{
    
    static PAParseManager* parseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parseManager = [[self alloc]init];
    });
    return parseManager;
}

- (void)fetchPlacesForPlace:(PFObject*) place
{
    PFQuery *query = [PFQuery queryWithClassName:picturesClass];
    [query whereKey:picturesCheckIn equalTo:place[picturesCheckIn]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            [self.postsFetchedDelegate didFinishFetchingPosts:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)checkInWithComment:(NSString *)commentText checkInPlace:(NSString *)checkInPlce Image:(UIImage *)image userRating:(NSNumber*) rating Longitude:(float) longitude Latitude:(float)latitude countryName:(NSString *)countryName
{
    PFObject *picturesObject = [PFObject objectWithClassName:picturesClass];
    //TODO change to id
    picturesObject[picturesOwner]   = [[PAFacebookManager facebookManager] userName];
    picturesObject[picturesComment] = commentText;
    picturesObject[picturesCheckIn] = checkInPlce;
    picturesObject[picturesRating] =  rating;
    picturesObject[picturesCountry] = countryName;
    NSNumber* longitudeNumber = [[NSNumber alloc] initWithFloat:longitude];
    NSNumber* latitudeNumber  = [[NSNumber alloc] initWithFloat:latitude];
    picturesObject[picturesLongitude] = longitudeNumber;
    picturesObject[picturesLatitude]  = latitudeNumber;
    NSData* data = UIImageJPEGRepresentation(image,0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // Save the image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            [picturesObject setObject:imageFile forKey:picturesPicture];
            
            [picturesObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [picturesObject saveEventually];
                    NSLog(@"Saved");
                    [[NSNotificationCenter defaultCenter] postNotificationName:CheckinUploadedNotification object:nil];
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];

}


- (void)fetchPlacesForCountry:(NSString*) country
{
    PFQuery *query = [PFQuery queryWithClassName:picturesClass];
    if(country)
    [query whereKey:picturesCountry equalTo:country];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            
            NSMutableArray* mutableArray = [[NSMutableArray alloc ]initWithArray:objects];
            
            [self.postsFetchedDelegate didFinishFetchingPosts:[[NSSet setWithArray:mutableArray] allObjects]];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)fetchPlaces
{
    
    PFQuery *query = [PFQuery queryWithClassName:picturesClass];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            
            NSMutableArray* mutableArray = [[NSMutableArray alloc ]initWithArray:objects];
            
            [self.postsFetchedDelegate didFinishFetchingPosts:[[NSSet setWithArray:mutableArray] allObjects]];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)createPushNotification
{
//TOOD: Implement Push Notification!
}

@end
