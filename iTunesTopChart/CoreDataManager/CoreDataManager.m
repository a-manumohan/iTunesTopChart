//
//  CoreDataManager.m
//  ios_test
//
//  Created by manuMohan on 2/15/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

static CoreDataManager *sharedManager = nil;
@implementation CoreDataManager

- (id)init{
    self = [super init];
    if(self != nil){
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        context = delegate.managedObjectContext;
    }
    return self;
}

+ (CoreDataManager *)sharedInstance{
    if(sharedManager == nil){
        sharedManager = [[CoreDataManager alloc] init];
    }
    return sharedManager;
}

- (void)storeObject:(NSDictionary *)object intoEntity:(NSString *)entity{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
    NSEnumerator *keyEnumerator = object.keyEnumerator;
    NSString *key = nil;
    while ((key = keyEnumerator.nextObject) != nil) {
        
        [managedObject setValue:[object valueForKey:key] forKey:key];
    }
    NSError *error;
    if(![context save:&error]){
        NSLog(@"%@",@"Could not save to persistance");
    }
}

- (NSArray *)fetchAllDataFromEntity:(NSString *)entity{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    NSError *error;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    if(error != nil){
        return nil;
    }
    return resultArray;
}
@end
