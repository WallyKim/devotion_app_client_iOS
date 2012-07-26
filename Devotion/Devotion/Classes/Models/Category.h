//
//  Category.h
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 26..
//  Copyright (c) 2012년 KG Mobilians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * guide;
@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * user_id;

@end
