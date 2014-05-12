//
//  PAProfileViewController.h
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PABaseViewController.h"


@interface PAProfileViewController : PABaseViewController

@property (nonatomic, retain) UIImageView* profileView;
@property (nonatomic, retain) UIImageView* profilePicImageView;
@property (nonatomic, retain) UILabel* userName;

@property (nonatomic, retain) UIView* userStatsView;
@property (nonatomic, retain) UILabel* userCountriesVisited;
@property (nonatomic, retain) UILabel* userCitiesVisited;
@property (nonatomic, retain) UILabel* userPlacesVisited;



@end
