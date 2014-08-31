//
//  PAProfileCell.m
//  PhotoAt
//
//  Created by Viktor on 8/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAProfileCell.h"

@implementation PAProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setupView
{
    
}

@end
