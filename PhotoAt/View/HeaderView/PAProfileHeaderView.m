//
//  PAProfileHeaderView.m
//  PhotoAt
//
//  Created by Viktor on 5/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAProfileHeaderView.h"

@implementation PAProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.userProfileImageView = [[UIImageView alloc] init];
    self.userProfileImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userProfileImageView.backgroundColor = [UIColor redColor];
    self.userProfileImageView.layer.cornerRadius = 50.0;
    self.userProfileImageView.clipsToBounds = YES;
    self.userProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userProfileImageView.layer.borderWidth = 4;
    [self addSubview:self.userProfileImageView];
    
    self.userProfileName = [[UILabel alloc] init];
    self.userProfileName.textAlignment = NSTextAlignmentCenter;
    self.userProfileName.textColor = kAppNameTextColor;
    self.userProfileName.numberOfLines = 0;
    self.userProfileName.backgroundColor = [UIColor clearColor];
    self.userProfileName.font = [UIFont fontWithName:kFontName size:20];
    
    
    
    
    [self addSubview:self.userProfileName];
    
    //Setting auto-laout constraints
    [self.userProfileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self).with.offset(25);
    }];
    
    [self.userProfileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userProfileImageView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@44);
    }];
    
    
}


@end
