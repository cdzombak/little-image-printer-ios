//
//  DPZDataManager.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

// This is far, far from a robust Core Data stack. I don't have time to redo the whole thing, and luckily this class is good enough for this application. --CDZ Mar 3, 2014

#import "DPZDataManager.h"

@interface DPZDataManager ()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readwrite, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DPZDataManager

#pragma mark - Core Data

- (id)getAllFromFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSArray *matches = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return matches;
}

- (id)getOneFromFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSArray *matches = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return [matches firstObject];
}

- (id)insertNewObjectForEntityForName:(NSString *)name
{
    NSManagedObjectContext *context = [self managedObjectContext];
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
}

- (NSFetchRequest *)newFetchRequestForEntityNamed:(NSString *)name
{
    NSEntityDescription *entity = [self entityForName:name];
    return [self newFetchRequestForEntity:entity];
}

- (NSFetchRequest *)newFetchRequestForEntity:(NSEntityDescription *)entity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    return  fetchRequest;
}

- (NSEntityDescription *)entityForName:(NSString *)name
{
    return [NSEntityDescription entityForName:name inManagedObjectContext:[self managedObjectContext]];
}

- (NSManagedObject *)loadObjectWithId:(NSManagedObjectID *)moId
{
    return [self.managedObjectContext objectRegisteredForID:moId];
}

- (void)deleteObject:(NSManagedObject *)object
{
    if (object)
    {
        [self.managedObjectContext deleteObject:object];
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LittleImagePrinter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LittleImagePrinter"];
    
    NSError *error = nil;
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                             NSInferMappingModelAutomaticallyOption: @YES};
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        [self fatalError:error];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    
    return _managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    [self saveContext:managedObjectContext];
}

- (void)saveContext:(NSManagedObjectContext *)managedObjectContext
{
    NSError *error = nil;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            [self fatalError:error];
        }
    }
}

#pragma mark - Error Handling (or not)

- (void)fatalError:(NSError *)error
{
    [self errorAlertWithTitle:@"Error" message:NSLocalizedString(@"A serious error occured and Little Photo Printer cannot continue.", nil)];
    NSLog(@"Fatal error %@, %@", error, [error userInfo]);
    abort();
}

- (void)errorAlertWithTitle:(NSString *)title message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"Okay. 😢"
                          otherButtonTitles:nil]
         show];
    });
}

@end
