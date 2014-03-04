//
//  DPZDataManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

// This is far, far from a robust Core Data stack. I don't have time to redo the whole thing, and luckily this class is good enough for this application. --CDZ Mar 3, 2014

@interface DPZDataManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)getAllFromFetchRequest:(NSFetchRequest *)fetchRequest;
- (id)getOneFromFetchRequest:(NSFetchRequest *)fetchRequest;
- (id)insertNewObjectForEntityForName:(NSString *)name;
- (NSFetchRequest *)newFetchRequestForEntityNamed:(NSString *)name;
- (NSFetchRequest *)newFetchRequestForEntity:(NSEntityDescription *)entity;
- (NSEntityDescription *)entityForName:(NSString *)name;
- (NSManagedObject *)loadObjectWithId:(NSManagedObjectID *)moId;
- (void)deleteObject:(NSManagedObject *)object;
- (void)saveContext;

@end
