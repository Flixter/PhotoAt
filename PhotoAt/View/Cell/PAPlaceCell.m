//
//  PAPlaceCell.m
//  PhotoAt
//
//  Created by Viktor on 8/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAPlaceCell.h"

@implementation PAPlaceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupViews{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.placeImage = [[UIImageView alloc] init];
    self.placeImage.contentMode = UIViewContentModeScaleToFill;
    self.placeImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.placeImage];
    
    
    self.semiTransparentView = [[UIView alloc]init];
    self.semiTransparentView.backgroundColor = [UIColor grayColor];
    self.semiTransparentView.alpha = 0.6;
    [self.contentView addSubview:self.semiTransparentView];
    
    self.placeTitleLabel = [[UILabel alloc] init];
    self.placeTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.placeTitleLabel.textColor = [UIColor whiteColor];
    self.placeTitleLabel.backgroundColor = [UIColor clearColor];
    self.placeTitleLabel.font = [UIFont fontWithName:kFontName size:18];
    self.placeTitleLabel.text = @"Etno Bure Restoran";
    [self.contentView addSubview:self.placeTitleLabel];
    
    
    [self.placeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@150);
    }];
    [self.semiTransparentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.placeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.semiTransparentView.mas_top).with.offset(5);
        make.width.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
    }];
    
}

@end
