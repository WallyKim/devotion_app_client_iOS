//
//  Devotion.m
//  Devotion
//
//  Created by Woong-Ki Kim on 12. 7. 22..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Devotion.h"

@implementation Devotion

@synthesize pStrCategoryId;
@synthesize pDicDevotion;

static Devotion *sharedObject = nil;

+ (Devotion *)sharedObject
{
    @synchronized(self)
    {
        if (sharedObject == nil)
        {
            sharedObject = [[self alloc] init];
        }
    }
    
    return sharedObject;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedObject == nil)
        {
            sharedObject = [super allocWithZone:zone];
            return sharedObject;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

@end
