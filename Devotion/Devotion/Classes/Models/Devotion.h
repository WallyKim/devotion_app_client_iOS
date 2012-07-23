//
//  Devotion.h
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 22..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Devotion : NSObject

@property (nonatomic, retain) NSString* pStrCategoryId;
@property (nonatomic, retain) NSDictionary* pDicDevotion;

+ (Devotion*)sharedObject;

@end
