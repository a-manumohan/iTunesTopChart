//
//  AppDelegate.m
//  iTunesTopChart
//
//  Created by manuMohan on 06/06/13.
//  Copyright (c) 2013 manuMohan. All rights reserved.
//

#import "AppDelegate.h"

#import "SongsListViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = managedObjectContext_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;
@synthesize managedObjectModel = managedObjectModel_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[SongsListViewController alloc] initWithNibName:@"SongsListViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 
 Returns the managed object context for the application.
 
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 
 */

- (NSManagedObjectContext *)managedObjectContext

{
    
    if (managedObjectContext_ != nil)
        
    {
        
        return managedObjectContext_;
        
    }
    
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
        
    {
        
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
        
    }
    
    return managedObjectContext_;
    
}



/**
 
 Returns the managed object model for the application.
 
 If the model doesn't already exist, it is created from the application's model.
 
 */

- (NSManagedObjectModel *)managedObjectModel

{
    
    if (managedObjectModel_ != nil)
        
    {
        
        return managedObjectModel_;
        
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"asiModel" withExtension:@"momd"];
    
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return managedObjectModel_;
    
}



/**
 
 Returns the persistent store coordinator for the application.
 
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator

{
    
    if (persistentStoreCoordinator_ != nil)
        
    {
        
        return persistentStoreCoordinator_;
        
    }
    
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"asiModel.sqlite"];
    
    
    
    NSError *error = nil;
    
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        
    {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
    
    
    
    return persistentStoreCoordinator_;
    
}


/**
 
 Returns the URL to the application's Documents directory.
 
 */

- (NSURL *)applicationDocumentsDirectory

{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}
@end

