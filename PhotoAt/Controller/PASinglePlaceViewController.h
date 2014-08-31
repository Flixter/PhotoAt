//
//  PASinglePlaceViewController.h
//  PhotoAt
//
//  Created by Viktor on 8/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAParseManager.h"
#import "PABaseViewController.h"
#import <MapKit/MapKit.h>
#import "PAPlaceCell.h"
#import <CoreData/CoreData.h>
#import "SavedCheckIns.h"
#import "PAAppDelegate.h"



@interface PASinglePlaceViewController : PABaseViewController
<
MKMapViewDelegate,
PAParseManagerPostsDelegate,
UITableViewDataSource,
UITableViewDelegate
>

- (id)initWithPlace:(PFObject*)place;

@property (nonatomic, retain) PFObject* currentPlace;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSArray* picturesArray;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;





@end
