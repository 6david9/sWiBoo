//
//  CBAppDelegate.h
//  sWiBoo
//
//  Created by ly on 10/16/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBStartViewController;
@interface CBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) CBStartViewController *viewController;
@property (readonly, strong, nonatomic) SinaWeibo *weibo;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveWeibo;
- (void)restoreWeibo;
- (void)logoutWeibo;

@end
