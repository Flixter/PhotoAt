//
//  PACheckInViewController.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PACheckInViewController.h"
#import "CustomRatingView.h"
#import "PAFacebookManager.h"
#import "PAParseManager.h"

#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f

@interface PACheckInViewController ()

@end

@implementation PACheckInViewController


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

- (void)viewDidLoad
{
    
    // Custom initialization
    self.currentLocation = [CLLocation new];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    //TOOD PODOBRI GO OVA!
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [super viewDidLoad];
	[self setUpViews];
}

-(void)upload
{
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.ISOcountryCode;
         NSString *countryName = myPlacemark.country;
         NSLog(@"My country code: %@ and countryName: %@", countryCode, countryName);
         
         NSNumber* rating = [[NSNumber alloc] initWithFloat:self.customRatingView.userRating/20];
         [[PAParseManager parseManager] checkInWithComment:[self.comment text] checkInPlace:[[self.checkIn titleLabel] text] Image:[self.takenImage image] userRating:rating Longitude:self.longitude Latitude:self.latitude countryName:countryName];
         
     }];

}

-(void)clearController
{
    //Clear the images rating comments etc from the view !
}

-(void)setUpViews{
    
    
    self.takenImage = [UIImageView new];
    UIView* rView = [UIView new];
    self.checkIn = [UIButton new];
    self.comment    = [[UITextField alloc]init];
    
    [self.view addSubview: self.takenImage];
    [self.view addSubview: self.checkIn];
    [self.view addSubview: self.comment];
    [self.view addSubview:rView];
    
    
    [rView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
        make.top.equalTo(self.takenImage.mas_bottom);
        make.left.equalTo(self.view);
    }];
    
    //TODO Calculate half
    self.customRatingView = [[CustomRatingView alloc] initWithFrame:CGRectMake(80, 0, kStarViewWidth+kLeftPadding, kStarViewHeight) andRating:0 withLabel:NO animated:YES];
    [rView addSubview: self.customRatingView];
    
    self.comment.placeholder = @"Leave a comment for this place";
    self.comment.delegate = self;
    [self.comment setReturnKeyType:UIReturnKeyDone];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useCamera)];
    singleTap.numberOfTapsRequired = 1;
    self.takenImage.userInteractionEnabled = YES;
    [self.takenImage addGestureRecognizer:singleTap];
    [self.takenImage setBackgroundColor:[UIColor grayColor]];
    [self.takenImage setImage:[UIImage imageNamed:@"ic_camera"]];
    [self.takenImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.7);
        make.top.equalTo(self.comment.mas_bottom);
        make.left.equalTo(self.view);
    }];
    
    //Setup CheckIn Button
    [self.checkIn setTitle:@"Select Place to check in" forState:UIControlStateNormal];
    [self.checkIn setBackgroundColor:[UIColor blueColor]];
    [self.checkIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
        make.top.equalTo(rView.mas_bottom);
        make.left.equalTo(self.view);
    }];
    [self.checkIn addTarget:self action:@selector(presentNearByPlaces)
           forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)chooseImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate= self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)presentNearByPlaces{
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.delegate = self;
    placePickerController.title = @"Nearby Places";
    placePickerController.radiusInMeters = 1000;
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(self. self.currentLocation.coordinate.latitude, self. self.currentLocation.coordinate.longitude);
    [placePickerController loadData];
    [self presentViewController:placePickerController animated:YES completion:nil];
}

-(void)facebookViewControllerCancelWasPressed:(id)sender{
    NSLog(@"CANCEL");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)facebookViewControllerDoneWasPressed:(id)sender{
    NSLog(@"Done");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.takenImage.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker{
    
    NSLog(@"Location Selected :%@",placePicker.selection);
    
    if(placePicker.selection.name){
        [self.checkIn setTitle:placePicker.selection.name forState:UIControlStateNormal];
        self.longitude =[placePicker.selection.location.longitude floatValue];
        self.latitude =[placePicker.selection.location.latitude floatValue];
    }else{
        [self.checkIn setTitle:@"Select Place to check in" forState:UIControlStateNormal];
        self.longitude = 0;
        self.latitude  = 0;
    }
}

- (void)useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
}

-(void)keyboardWillShow {

}

-(void)keyboardWillHide {

}

@end
