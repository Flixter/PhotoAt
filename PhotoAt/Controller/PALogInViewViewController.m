//
//  PALogInViewViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PALogInViewViewController.h"

#import "PASideMenuContainerViewController.h"

@interface PALogInViewViewController ()

@end

@implementation PALogInViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
              [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucessfulllLogIn) name:UserSucessfullyLogedIn object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews{
    self.fbLoginButton = [[UIButton alloc]init];
    [self.fbLoginButton setTitle:connectWithFB forState:UIControlStateNormal];
    [self.fbLoginButton setBackgroundColor:[UIColor blueColor]];
    [self.fbLoginButton addTarget:self action:@selector(fbLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fbLoginButton];
    [self.fbLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.1);
        make.center.equalTo(self.view).with.offset(10);
    }];

}
- (void)setupConstraints{



}

- (void)fbLoginButtonClick{
 [[PAFacebookManager facebookManager] attemptToLogIn];
}

- (void)sucessfulllLogIn{
    PASideMenuContainerViewController* sideMenuViewController = [[PASideMenuContainerViewController alloc] init];
    PABaseNavigationViewController* navigaionController = [[PABaseNavigationViewController alloc]initWithRootViewController:sideMenuViewController];
    [self presentViewController:navigaionController animated:YES completion:nil];
}
@end
