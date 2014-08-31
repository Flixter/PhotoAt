//
//  CustomRatingView.h
//  PhotoAt
//
//  Created by Finki Finki on 28.4.14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRatingView : UIView
- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated;

@property float userRating;

@end