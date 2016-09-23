//
//  User+CoreDataProperties.h
//  CoreData
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 fuxinto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userAge;
@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *userSex;
@property (nullable, nonatomic, retain) NSDate *userDate;

@end

NS_ASSUME_NONNULL_END
