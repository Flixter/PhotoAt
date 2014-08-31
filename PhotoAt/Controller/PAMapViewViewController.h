//
//  PAMapViewViewController.h
//  PhotoAt
//
//  Created by Viktor on 8/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse-iOS-SDK/Parse.h>
#import "SavedCheckIns.h"

@interface PAMapViewViewController : UIViewController
<
MKMapViewDelegate
>

- (id)initWithPlace:(SavedCheckIns*)currentPlace;

@property (nonatomic, retain) MKMapView* mapView;

@end
