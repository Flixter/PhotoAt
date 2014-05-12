//
//  PAMenuItem.h
//  PhotoAt
//
//  Created by Viktor on 5/10/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAMenuItem : NSObject

// Used when the menu items is initialized from json dictionary from the /Resources/menuItems.json file.
- (id)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* selectedImageName;

@end
