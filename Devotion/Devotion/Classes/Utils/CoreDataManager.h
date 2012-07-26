//
//  CoreDataManager.h
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 26..
//  Copyright (c) 2012년 KG Mobilians. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

+ (BOOL)saveTableWithData:(NSArray *)arrData 
                  toTable:(NSString *)tableName 
     managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (BOOL)deleteTableWithData:(NSFetchedResultsController *)fetchedResultsController
            managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
