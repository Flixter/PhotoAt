//
//  PAHomeViewController.h
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PABaseViewController.h"
#import "PAPlaceCell.h"
#import "PAParseManager.h"
#import "PASinglePlaceViewController.h"

@interface PAHomeViewController : PABaseViewController
<UITableViewDataSource,
UITableViewDelegate,PAParseManagerPostsDelegate,CLLocationManagerDelegate>

@property (nonatomic, retain) UITableView* placesTable;
@property (nonatomic, retain) NSArray* placesArray;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* currentLocation;
@end
