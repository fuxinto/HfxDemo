//
//  Book+CoreDataProperties.h
//  CoreData
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 fuxinto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bookName;
@property (nullable, nonatomic, retain) NSNumber *bookPrice;

@end

NS_ASSUME_NONNULL_END
