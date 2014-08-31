//
//  SavedCheckIns.h
//  PhotoAt
//
//  Created by Viktor on 8/11/14.
//  Copyright (c) 2014 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedCheckIns : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSNumber * placeRating;

@end
