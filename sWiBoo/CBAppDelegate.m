//
//  CBAppDelegate.m
//  sWiBoo
//
//  Created by ly on 10/16/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBAppDelegate.h"

#import "CBStartViewController.h"

@implementation CBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize viewController = _viewController;
@synthesize weibo = _weibo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[CBStartViewController alloc] initWithNibName:@"CBStartViewController" bundle:nil];
    self.viewController.managedObjectContext = [self managedObjectContext];
    self.viewController.appDelegate = self;
    self.viewController.weibo = [self weibo];
    [self restoreWeibo];
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveWeibo];
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self restoreWeibo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self restoreWeibo];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Sina Weibo
- (SinaWeibo *)weibo
{
    if (_weibo != nil)
        return _weibo;
    
    NSAssert(self.viewController != nil, @"必须先初始化self.viewController");
    _weibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kRedirectURL andDelegate:self.viewController];
    
    return _weibo;
}

- (void)saveWeibo
{
    SinaWeibo *weibo = self.weibo;
    
    if (weibo != nil) {
        NSDictionary *weiboDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        [weiboDict setValue:weibo.userID forKey:@"userID"];
        [weiboDict setValue:weibo.accessToken forKey:@"accessToken"];
        [weiboDict setValue:weibo.expirationDate forKey:@"expirationDate"];
        [weiboDict setValue:weibo.refreshToken forKey:@"refreshToken"];
        [weiboDict setValue:weibo.ssoCallbackScheme forKey:@"ssoCallbackScheme"];
        
        // 保存微博登录信息
        [[NSUserDefaults standardUserDefaults] setValue:weiboDict forKey:@"weibo"];
    }
}

- (void)restoreWeibo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    SinaWeibo *weibo = self.weibo;
    
    if (weibo != nil) {
        NSDictionary *weiboDict = (NSDictionary *)[[NSUserDefaults standardUserDefaults] valueForKey:@"weibo"];
        
        if (weiboDict != nil) {
            weibo.userID = [weiboDict valueForKey:@"userID"];
            weibo.accessToken = [weiboDict valueForKey:@"accessToken"];
            weibo.expirationDate = [weiboDict valueForKey:@"expirationDate"];
            weibo.refreshToken = [weiboDict valueForKey:@"refreshToken"];
            weibo.ssoCallbackScheme = [weiboDict valueForKey:@"ssoCallbackScheme"];
        } 
    }
}

- (void)logoutWeibo
{
    self.weibo.userID = nil;
    self.weibo.accessToken = nil;
    self.weibo.expirationDate = nil;
    self.weibo.refreshToken = nil;
    self.weibo.ssoCallbackScheme = nil;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sWiBoo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sWiBoo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
