//
//  PAHomeViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAHomeViewController.h"

@interface PAHomeViewController ()
@property (nonatomic, strong) UIButton* refreshButton;

@end

@implementation PAHomeViewController

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    [self fetchPlaces];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        // Custom initialization
        self.currentLocation = [CLLocation new];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        [self fetchPlaces];
    }
    return self;
}

- (void)fetchPlaces
{
    PAParseManager* parseManager = [PAParseManager parseManager];
    parseManager.postsFetchedDelegate = self;
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             [parseManager fetchPlaces];
             return;
         }
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.ISOcountryCode;
         NSString *countryName = myPlacemark.country;
         NSLog(@"My country code: %@ and countryName: %@", countryCode, countryName);
         
         [parseManager fetchPlacesForCountry:countryName];
     }];
}

- (void)didFinishFetchingPosts:(NSArray *)posts
{
    self.placesArray = posts;
    [self.placesTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self fetchPlaces];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupConstraints];
}


- (void)setupViews
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchPlaces)];
    self.navigationItem.rightBarButtonItem = button;
    
    
    self.placesTable = [UITableView new];
    self.placesTable.delegate = self;
    self.placesTable.dataSource = self;
    self.placesArray = [NSArray new];
    [self.view addSubview:self.placesTable];
    
}
- (void)setupConstraints
{
    [self.placesTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.placesArray count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    
    PAPlaceCell* cell = [[PAPlaceCell alloc]init];
    if (cell == nil)
        cell = [[PAPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    PFObject* picturesObject = [self.placesArray objectAtIndex:indexPath.row];
    cell.placeTitleLabel.text = [NSString stringWithFormat:@"%@ \n %@ star rating", picturesObject[picturesCheckIn], picturesObject[picturesRating]];
    cell.placeTitleLabel.numberOfLines = 2;
    [cell.placeTitleLabel sizeToFit];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject* picturesObject = [self.placesArray objectAtIndex:indexPath.row];
    
    PASinglePlaceViewController* singlePlaceVC = [[PASinglePlaceViewController alloc] initWithPlace:picturesObject];
    UINavigationController* navCOntroller = [[UINavigationController alloc] initWithRootViewController:singlePlaceVC];
    [self.navigationController presentViewController:navCOntroller animated:YES completion:nil];
   // implement table itme on click listener!
}
@end
