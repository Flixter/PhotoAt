//
//  PACheckInViewController.h
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PABaseViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CustomRatingView.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface PACheckInViewController : PABaseViewController <FBPlacePickerDelegate, FBViewControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
@property BOOL newMedia;

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* currentLocation;
@property (nonatomic, retain) UIButton* checkIn;
@property float longitude;
@property float latitude;
@property (nonatomic, retain) UIImageView* takenImage;
@property (nonatomic, retain) UITextField* comment;
@property (nonatomic, retain) CustomRatingView* customRatingView;

@end



