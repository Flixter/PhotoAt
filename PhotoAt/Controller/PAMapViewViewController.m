//
//  PAMapViewViewController.m
//  PhotoAt
//
//  Created by Viktor on 8/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAMapViewViewController.h"

@interface PAMapViewViewController ()

@end

@implementation PAMapViewViewController

- (id)initWithPlace:(SavedCheckIns *)currentPlace
{
    self = [super init];
    if (self) {
        self.mapView = [MKMapView new];
        [self.view addSubview:self.mapView];
        
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
        NSNumber* latitude = currentPlace.latitude;
        NSNumber* longitude = currentPlace.longitude;
        region.center.latitude = [latitude doubleValue];
        region.center.longitude = [longitude doubleValue];
        region.span.longitudeDelta = 0.01f;
        region.span.latitudeDelta = 0.01f;
        [self.mapView setRegion:region animated:YES];
        
        MKPointAnnotation *point = [MKPointAnnotation new];
        point.coordinate = region.center;
        point.title = currentPlace.placeName;
        [self.mapView addAnnotation:point];
        
        //Add back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(didSelectMenu)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    return self;
}

- (void)didSelectMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
