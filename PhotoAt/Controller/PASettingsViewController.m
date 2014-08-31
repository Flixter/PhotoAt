//
//  PASettingsViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PASettingsViewController.h"

@interface PASettingsViewController ()

@end

@implementation PASettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager=[[CLLocationManager alloc] init];
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.headingFilter = 1;
	self.locationManager.delegate=self;
	[self.locationManager startUpdatingHeading];
	// Do any additional setup after loading the view.
    
    // Custom initialization
    self.compassImage = [UIImageView new];
    [self.view addSubview:self.compassImage];
    [self.compassImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
        make.center.equalTo(self.view);
    }];
    [self.compassImage setImage:[UIImage imageNamed:@"Compass"]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	// Convert Degree to Radian and move the needle
	float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
	float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
	CABasicAnimation *theAnimation;
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
	theAnimation.toValue=[NSNumber numberWithFloat:newRad];
	theAnimation.duration = 0.5f;
	[self.compassImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
	self.compassImage.transform = CGAffineTransformMakeRotation(newRad);
	NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
