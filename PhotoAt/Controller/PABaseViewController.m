//
//  PABaseViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PABaseViewController.h"

@interface PABaseViewController ()

@property (nonatomic, strong) UIButton* menuButton;

@end

@implementation PABaseViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //Custom back button for iOS 6
    if (![Util isGreaterOrEqualToiOS7] && self.navigationController.viewControllers.count > 1) {
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0, 0.0, 40, 33);
        [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    //If it is root view controller show the left menu icon
    if (self.navigationController.viewControllers.count == 1) {
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.menuButton setBackgroundImage:[UIImage imageNamed:@"btn_navigation"] forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(didSelectMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.menuButton setFrame:CGRectMake(0.0, 0.0, 40, 33)];
        UIBarButtonItem* menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
        self.navigationItem.leftBarButtonItem = menuButtonItem;
    }
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupViews];
    [self setupConstraints];
    
}
#pragma mark - setup views

- (void)setupViews
{
    
}

- (void)setupConstraints
{
    
}

#pragma mark - action methods

//Custom back button action for iOS 6.0
-(void)onBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ControllerDidPressedMenuNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
