//
//  PABaseNavigationViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PABaseNavigationViewController.h"

@interface PABaseNavigationViewController ()

@end

@implementation PABaseNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([Util isGreaterOrEqualToiOS7]) {
        [self.navigationBar setTintColor:kPrimaryAppColor];
    }else
    {
        [self.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
