//
//  PASettingsViewController.h
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PABaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface PASettingsViewController : PABaseViewController
<CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) UIImageView* compassImage;

@end
