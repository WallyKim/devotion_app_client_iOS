//
//  ServerManager.h
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 19..
//  Copyright (c) 2012년 NewPerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"

@interface ServerManager : NSObject

@property (nonatomic, retain) ServerRequest* request;

- (ServerRequest *)getRequestCategoryWithDelegate:(id<ServerRequestDelegate>)delegate;

- (ServerRequest *)getRequestDevotionListWithDelegate:(id<ServerRequestDelegate>)delegate
                                                  pID:(NSString *)pID;

@end
