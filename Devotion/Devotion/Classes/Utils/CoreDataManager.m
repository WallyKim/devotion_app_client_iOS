//
//  CoreDataManager.m
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 26..
//  Copyright (c) 2012년 KG Mobilians. All rights reserved.
//

#import "CoreDataManager.h"
#import "Category.h"

@implementation CoreDataManager

+ (BOOL)saveTableWithData:(NSArray *)arrData 
                  toTable:(NSString *)tableName 
     managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    for (int i =0; i< [arrData count]; i++) {
        
        Category* newCategory = (Category *)[NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:managedObjectContext];
        
        NSDictionary* pDicTemp = (NSDictionary *)[arrData objectAtIndex:i];
        
        [newCategory setCategory_id:[[pDicTemp objectForKey:@"id"] stringValue]];
        [newCategory setTitle:[pDicTemp objectForKey:@"title"]];
        [newCategory setGuide:[pDicTemp objectForKey:@"guide"]];
        [newCategory setUser_id:[[pDicTemp objectForKey:@"user_id"] stringValue]];
        [newCategory setCreated_at:[pDicTemp objectForKey:@"created_at"]];
        [newCategory setUpdated_at:[pDicTemp objectForKey:@"updated_at"]];
        
        NSError* error;
        if (![managedObjectContext save:&error])
        {
            NSLog(@"failed insert data!");
            return FALSE;
        }
    }
    
    return TRUE;
}

+ (BOOL)deleteTableWithData:(NSFetchedResultsController *)fetchedResultsController
       managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    for (Category* tempCategory in [fetchedResultsController fetchedObjects]) {
        NSManagedObject* tempObject = tempCategory;
        [managedObjectContext deleteObject:tempObject];
    }
    
    NSError* error;
    if ([managedObjectContext hasChanges])
    {
        if (![managedObjectContext save:&error])
        {
            NSLog(@"failed delete data!");
            return FALSE;
        }
    }
    
    return TRUE;
}

@end
