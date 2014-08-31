//
//  PASinglePlaceViewController.m
//  PhotoAt
//
//  Created by Viktor on 8/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PASinglePlaceViewController.h"

@interface PASinglePlaceViewController ()

@end

@implementation PASinglePlaceViewController
- (id)initWithPlace:(PFObject*)place
{
    self = [super init];
    if (self) {
        
        self.currentPlace = place;
        
        // Custom initialization
        //Setup the MAP
        self.mapView = [MKMapView new];
        [self.view addSubview:self.mapView];
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.equalTo(@200);
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top);
        }];
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        NSNumber* latitude = place[picturesLatitude];
        NSNumber* longitude = place[picturesLongitude];
        region.center.latitude = [latitude doubleValue];
        region.center.longitude = [longitude doubleValue];
        region.span.longitudeDelta = 0.01f;
        region.span.latitudeDelta = 0.01f;
        [self.mapView setRegion:region animated:YES];
        
        MKPointAnnotation *point = [MKPointAnnotation new];
        point.coordinate = region.center;
        point.title = place[picturesCheckIn];
        [self.mapView addAnnotation:point];
        
        
        //set the table
        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mapView.mas_bottom);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.view.mas_height);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        //Add back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(didSelectMenu)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        //Save button
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Place to visit" style: UIBarButtonItemStyleBordered target:self action:@selector(savePlace)];
        self.navigationItem.rightBarButtonItem = saveButton;
        
        
        [self fetchForPlace];
    }
    return self;
}

-(void)viewDidLoad
{
    //1
    PAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;
}

-(void)savePlace
{
    SavedCheckIns * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"SavedCheckIns"
                                                             inManagedObjectContext:self.managedObjectContext];
    
    NSNumber* latitude = self.currentPlace[picturesLatitude];
    NSNumber* longitude = self.currentPlace[picturesLongitude];
    newEntry.latitude = latitude;
    newEntry.longitude = longitude;
    newEntry.placeName = self.currentPlace[picturesCheckIn];
    newEntry.placeRating = self.currentPlace[picturesRating];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
}




- (void)didSelectMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchForPlace
{
    PAParseManager* parseManager = [PAParseManager parseManager];
    parseManager.postsFetchedDelegate = self;
    [parseManager fetchPlacesForPlace:self.currentPlace];
}

- (void)didFinishFetchingPosts:(NSArray *)posts
{
    
    self.picturesArray = posts;
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.picturesArray count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    
    PAPlaceCell* cell = [[PAPlaceCell alloc]init];
    if (cell == nil)
        cell = [[PAPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    PFObject* picturesObject = [self.picturesArray objectAtIndex:indexPath.row];
    cell.placeTitleLabel.text = [NSString stringWithFormat:@"%@: %@", picturesObject[picturesOwner], picturesObject[picturesComment]];
    
    //Place the image
    PFFile *userImageFile = picturesObject[picturesPicture];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.placeImage.image = image;
        }
    }];
    return cell;
}


@end
