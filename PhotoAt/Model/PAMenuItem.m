//
//  PAMenuItem.m
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import "PAMenuItem.h"

@implementation PAMenuItem

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        self.title = dictionary[@"title"];
        self.imageName = dictionary[@"imageName"];
        self.selectedImageName = dictionary[@"imageNameSelected"];
    }
    
    return self;
}

@end
