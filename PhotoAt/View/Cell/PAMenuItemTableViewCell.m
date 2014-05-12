//
//  PAMenuItemTableViewCell.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAMenuItemTableViewCell.h"

@implementation PAMenuItemTableViewCell

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
    
    self.menuIconImageView = [[UIImageView alloc] init];
    self.menuIconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.menuIconImageView];
    
    self.menuTitleLabel = [[UILabel alloc] init];
    self.menuTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.menuTitleLabel.textColor = kMenuItemTitleTextColor;
    self.menuTitleLabel.backgroundColor = [UIColor clearColor];
    self.menuTitleLabel.font = [UIFont fontWithName:kFontName size:20];
    
    [self.contentView addSubview:self.menuTitleLabel];
    
    
    [self.menuIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(30);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    [self.menuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.menuIconImageView.mas_right).with.offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@35);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        
    }];

}

@end
