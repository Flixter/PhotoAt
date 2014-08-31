//
//  PASideMenuContainerViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PASideMenuContainerViewController.h"
#import "PABaseNavigationViewController.h"
#import "PAHomeViewController.h"
#import "PAProfileViewController.h"
#import "PASettingsViewController.h"
#import "PACheckInViewController.h"
#import "PAMenuHeaderView.h"
#import "PAMenuItem.h"
#import "PAMenuItemTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define SIDE_MENU_OFFSET ([UIScreen mainScreen].bounds.size.width * 0.85)

@interface PASideMenuContainerViewController ()

//Holding instace of the menu view controllers
@property (nonatomic, strong) NSArray* viewControllers;
//Holding instance of the current visible Controller
@property (nonatomic, strong) UINavigationController* visibleController;
//Index of the current visible controller, default to -1 (none of the controller is shown)
@property (nonatomic) NSUInteger currentSelectIndex;

//Keeping track if the menu is visible or not
@property (nonatomic) BOOL isMenuVisible;

//Menu items of class @GGMenuItem
@property (nonatomic, strong) NSMutableArray* menuItems;

//Displaying the current selected controller view
@property (nonatomic, strong) UIView* containerView;

@property (nonatomic, strong) UITableView* sideMenuTableView;

@property (nonatomic, strong) PAMenuHeaderView* sideMenuHeaderView;

//Used for animation of the containerView
@property (nonatomic, strong) MASConstraint* containerLeftConstraint;


@property (nonatomic) BOOL statusBarHidden;

//Used for gesture recognizers
@property (nonatomic, strong) UIView* gestureView;

//Used for iOS 7 to have a nice status bar movement
@property (nonatomic, strong) UIView* snapshotView;

@end

@implementation PASideMenuContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuItems = [[NSMutableArray alloc]init];
        self.currentSelectIndex = -1;
        self.isMenuVisible = NO;
        self.statusBarHidden = NO;
        //Assign the notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedOnMenu) name:ControllerDidPressedMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableHeaderView) name:UserFacebookInfoUpdate object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkinUploaded) name:CheckinUploadedNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    //Dealoc the notification for avoiding issues
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ControllerDidPressedMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserFacebookInfoUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CheckinUploadedNotification object:nil];
}

- (void)loadView{
    UIView *view = [[UIView alloc]init];
    self.view = view;
    self.view.backgroundColor = kPrimaryAppColor;
    
    self.sideMenuTableView = [[UITableView alloc] init];
    self.sideMenuTableView.delegate = self;
    self.sideMenuTableView.dataSource = self;
    self.sideMenuTableView.showsHorizontalScrollIndicator = NO;
    self.sideMenuTableView.showsVerticalScrollIndicator = NO;
    self.sideMenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sideMenuTableView.backgroundColor = [UIColor clearColor];

    if(![Util isDeviceScreenBigerThanThreeFiveInches]){
        [self.sideMenuTableView setContentInset:UIEdgeInsetsMake(57, 0, 0, 0)];
    }
    
    [self.view addSubview:self.sideMenuTableView];
    
    if([Util isDeviceScreenBigerThanThreeFiveInches]){
        //Using frame because header view cannot be set with auto layout
        //constraints
        //Only the height is set the x y and width are used from the table view itself
        self.sideMenuHeaderView = [[PAMenuHeaderView alloc]initWithFrame:
                                 CGRectMake(0.0, 0.0, 0.0, 183.0)];
        self.sideMenuTableView.tableHeaderView = self.sideMenuHeaderView;
    }
    
    self.containerView = [[UIView alloc]init];
    [self.view addSubview:self.containerView];
    
    self.gestureView = [[UIView alloc]init];
    self.gestureView.backgroundColor = [UIColor clearColor];
    //Setting gestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didTapOnMainView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didPanTheMainView:)];
    [self.gestureView addGestureRecognizer:tapGesture];
    [self.gestureView addGestureRecognizer:panGesture];
   
    //Setting auto-laout constraints
    [self.sideMenuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@SIDE_MENU_OFFSET);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        self.containerLeftConstraint = make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.width.equalTo(self.view.mas_width).with.offset(0);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //Make the bezier path shadow after the views are drawn
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(-6, 0);
    self.containerView.layer.shadowOpacity =  0.6f;
    self.containerView.layer.shadowRadius = 4.0;
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:0.0].CGPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    [self initControllers];
    [self initMenuItems];
    
    //Load the default view controller
    [self showControllerAtIndex:0];
}
- (void)checkinUploaded
{
    [self showControllerAtIndex:0];
}

#pragma - Container setup methods

- (void)initControllers
{
    
    //Alloc and init View controllers Titles
    PAHomeViewController* homeViewController = [[PAHomeViewController alloc] init];
    homeViewController.title = homeScreenTitle;
    PAProfileViewController* userViewController = [[PAProfileViewController alloc] init];
    userViewController.title = profileScreenTitle;
    PASettingsViewController* settingsViewController = [[PASettingsViewController alloc] init];
    settingsViewController.title = settingsScreenTitle;
    PACheckInViewController* checkInViewController = [[PACheckInViewController alloc] init];
    checkInViewController.title = checkInScreenTitle;
    
    PABaseNavigationViewController* homeNavigationController = [[PABaseNavigationViewController alloc] initWithRootViewController:homeViewController];
    
    PABaseNavigationViewController* userNavigationController = [[PABaseNavigationViewController alloc] initWithRootViewController:userViewController];
    
    PABaseNavigationViewController* settingsNavigationController = [[PABaseNavigationViewController alloc] initWithRootViewController:settingsViewController];
    
    PABaseNavigationViewController* checkInlNavigationController = [[PABaseNavigationViewController alloc] initWithRootViewController:checkInViewController];

    
    self.viewControllers = @[homeNavigationController,
                             userNavigationController,
                             settingsNavigationController,
                             checkInlNavigationController];
}

- (void)initMenuItems
{
    //Alloc and init menu items
    NSString* menuItemsFilename = [[NSBundle mainBundle] pathForResource:@"menuItems" ofType:@"json"];
    NSData* menuItemsJSONData = [[NSData alloc] initWithContentsOfFile:menuItemsFilename];
    
    NSError* error = nil;
    NSArray* menuItemsJSON = [NSJSONSerialization JSONObjectWithData:menuItemsJSONData options:0 error:&error];
    
    for (NSDictionary* menuItemDictionary in menuItemsJSON) {
        PAMenuItem* menuItem = [[PAMenuItem alloc] initWithDictionary:menuItemDictionary];
        [self.menuItems addObject:menuItem];
    }
}


-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapOnMainView:(UITapGestureRecognizer*)tapGesture
{
    [self handleMenuVisibility];
}

- (void)didPanTheMainView:(UIPanGestureRecognizer*)panGesture
{
    CGPoint point = [panGesture translationInView:self.view];
    double newOffset = SIDE_MENU_OFFSET + point.x;
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (point.x < 0) {
            if (newOffset >= 0) {
                self.containerLeftConstraint.offset = newOffset;
                [self.view layoutIfNeeded];
            }
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded ||
               panGesture.state == UIGestureRecognizerStateCancelled) {
        if (newOffset <  SIDE_MENU_OFFSET/2) {
            self.isMenuVisible = YES;
        } else {
            self.isMenuVisible = NO;
        }
        [self handleMenuVisibility];
        [UIView animateWithDuration:0.15 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Managment of container views

- (void)didSelectedOnMenu
{
    [self handleMenuVisibility];
}


// Close the menu if it is already open and vice versa.
- (void)handleMenuVisibility
{
    //If the side menu is not shown, open the the side menu
    if (!self.isMenuVisible) {
        self.containerLeftConstraint.with.offset(SIDE_MENU_OFFSET);
    }else
    {
        //Closing the side menu
        self.containerLeftConstraint.with.offset(0);
    }
    
    [self handleStatusBarVisibility];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.isMenuVisible = !self.isMenuVisible;
        
    }];
}

- (void)handleStatusBarVisibility
{
    if(!self.isMenuVisible)
    {
        
        //If the gesture view is present the user is using the pan gesture to open the side menu, there is not need to add the gesture again.
        if (![self.gestureView superview]) {
            
            [self.containerView addSubview:self.gestureView];
            [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.containerView);
            }];
            
            //Hiding status bar only for iOS 7
            if ([[UIScreen mainScreen] respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
                self.snapshotView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
                [self.gestureView addSubview:self.snapshotView];
                [self.snapshotView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.gestureView);
                }];
                self.statusBarHidden = YES;
                [self setNeedsStatusBarAppearanceUpdate];
            }
        }
        
    }else
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
            self.statusBarHidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            [self.snapshotView removeFromSuperview];
        }
        
        [self.gestureView removeFromSuperview];
    }
}


- (void)showControllerAtIndex:(NSInteger)index
{
    //Don't load the same controller if it is already visible
    if (index != self.currentSelectIndex) {
        
        UINavigationController* controllerForDisplaying = self.viewControllers[index];
        
        self.currentSelectIndex = index;
        
        [self.visibleController willMoveToParentViewController:nil];
        [self.visibleController.view removeFromSuperview];
        [self.visibleController removeFromParentViewController];
        self.visibleController = nil;
        
        [self addChildViewController:controllerForDisplaying];
        
        [self.containerView addSubview:controllerForDisplaying.view];
        
        
        [controllerForDisplaying.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView);
        }];
        
        [controllerForDisplaying didMoveToParentViewController:self];
        
        self.visibleController = controllerForDisplaying;
    }
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"menuCellIdentifier";
    
    PAMenuItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[PAMenuItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    PAMenuItem* menuItem = self.menuItems[indexPath.row];
    
    cell.menuTitleLabel.text = menuItem.title;
    
    if (self.currentSelectIndex == indexPath.row) {
        cell.menuIconImageView.image = [UIImage imageNamed:menuItem.selectedImageName];
        cell.menuTitleLabel.textColor = kMenuItemTitleSelectedTextColor;
    }else
    {
        cell.menuIconImageView.image = [UIImage imageNamed:menuItem.imageName];
        cell.menuTitleLabel.textColor = kMenuItemTitleTextColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleMenuVisibility];
    [self showControllerAtIndex:indexPath.row];
    [self.sideMenuTableView reloadData];
}

- (void)updateTableHeaderView{
    self.sideMenuHeaderView.userProfileName.text = [[PAFacebookManager facebookManager]userName];
    NSString* userProfilePicThumUrl = [[PAFacebookManager facebookManager] userProfilePicUrl];
    [self loadProfilePicThumblWithURL:userProfilePicThumUrl];
}

- (void)loadProfilePicThumblWithURL:(NSString *)url{
    
    __weak PAMenuHeaderView* weakSelf = self.sideMenuHeaderView;
    self.sideMenuHeaderView.userProfileImageView.image = nil;
    
    
    [ self.sideMenuHeaderView.userProfileImageView setImageWithURLRequest:[[PAServiceProvider sharedProvider] imageRequestForURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakSelf.userProfileImageView.image = image;
        NSLog(@"User profile pic updated");
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"User profile pic not updated");
    }];
    
}



@end
