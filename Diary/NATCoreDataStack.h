//
//  NATCoreDataStack.h
//  Diary
//
//  Created by Noah Teshu on 10/4/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NATCoreDataStack : NSObject

+(instancetype)defaultStack;

//all of these properties are readonly, can only be accessed from application delegate
//privately, they are read and write
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
