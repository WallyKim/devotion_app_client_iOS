//
//  AppDelegate.h
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 14..
//  Copyright (c) 2012년 NewPerson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainCategoryViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) MainCategoryViewController* m_pMainCategoryViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
