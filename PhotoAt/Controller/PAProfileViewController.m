//
//  PAProfileViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAProfileViewController.h"
#import "PAAppDelegate.h"
#import "SavedCheckIns.h"



@interface PAProfileViewController ()

@end

@implementation PAProfileViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserHeaderView) name:UserFacebookInfoUpdate object:nil];
    }
    return self;
}

- (void)dealloc
{
 [[NSNotificationCenter defaultCenter] removeObserver:self name:UserFacebookInfoUpdate object:nil];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupConstraints];
    [[PAFacebookManager facebookManager]getUserInfo];
    PAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [appDelegate getAllSavedPlaces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupViews{
    
    self.profileView = [[UIImageView alloc]init];
    self.profileView.backgroundColor = [UIColor redColor];
    self.profileView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileView.clipsToBounds = YES;
    [self.view addSubview:self.profileView];
    
    self.profilePicImageView = [[UIImageView alloc]init];
    self.profilePicImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profilePicImageView.clipsToBounds = YES;
    self.profilePicImageView.backgroundColor = [UIColor redColor];
    self.profilePicImageView.layer.cornerRadius = 40.0;
    self.profilePicImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePicImageView.layer.borderWidth = 2;
    [self.view addSubview:self.profilePicImageView];
    
    self.userStatsView = [[UIView alloc]init];
    self.userStatsView.backgroundColor = [UIColor whiteColor];
    self.userStatsView.alpha = 0.7;
    [self.view addSubview:self.userStatsView];
    
    self.tableView = [UITableView new];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profilePicImageView.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)refresh
{
    PAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchedRecordsArray = [appDelegate getAllSavedPlaces];
    [self.tableView reloadData];
}

- (void)setupConstraints{
    
    [self.profileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@150);
    }];
    
    [self.profilePicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.top.equalTo(self.profileView).with.offset(15);
        make.left.equalTo(self.profileView).with.offset(25);
    }];
    
    [self.userStatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.profileView.mas_bottom);
        make.height.equalTo(@40);
        make.left.equalTo(self.view);
    }];
}

- (void)updateUserHeaderView{
    // self.sideMenuHeaderView.userProfileName.text = [[PAFacebookManager facebookManager]userName];
    NSString* userProfilePicThumUrl = [[PAFacebookManager facebookManager] userProfilePicUrl];
    NSString* userCoverPicUrl = [[PAFacebookManager facebookManager] userCoverPicUrl];
    [self loadProfilePicThumblWithURL:userProfilePicThumUrl];
    [self loadCoverPicThumblWithURL:userCoverPicUrl];
}


- (void)loadProfilePicThumblWithURL:(NSString *)url{
    
    __weak UIImageView* weakSelf = self.profilePicImageView;
    self.profilePicImageView.image = nil;
    
    
    [ self.profilePicImageView setImageWithURLRequest:[[PAServiceProvider sharedProvider] imageRequestForURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakSelf.image = image;
        NSLog(@"User profile pic updated");
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"User profile pic failed to update");
    }];
    
}

- (void)loadCoverPicThumblWithURL:(NSString *)url{
    
    __weak UIImageView* weakSelf = self.profileView;
    self.profileView.image = nil;
    
    
    [ self.profileView setImageWithURLRequest:[[PAServiceProvider sharedProvider] imageRequestForURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakSelf.image = image;
        NSLog(@"User cover pic updated");
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"User cover pic failed to update");
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedRecordsArray count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    SavedCheckIns * obj = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ \n %@ star rating",obj.placeName,obj.placeRating];
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel sizeToFit];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SavedCheckIns * obj = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    
    PAMapViewViewController* mapPlaceVC = [[PAMapViewViewController alloc] initWithPlace:obj];
    UINavigationController* navCOntroller = [[UINavigationController alloc] initWithRootViewController:mapPlaceVC];
    [self.navigationController presentViewController:navCOntroller animated:YES completion:nil];
    // implement table itme on click listener!
}


@end
