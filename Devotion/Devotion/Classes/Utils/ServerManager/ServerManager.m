//
//  ServerManager.m
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 19..
//  Copyright (c) 2012년 NewPerson. All rights reserved.
//

#import "ServerManager.h"

static NSString* kAPIBaseURL = @"http://devotion.herokuapp.com/";
//static NSString* kAPIBaseURL = @"http://0.0.0.0:3000/";
//static NSString* kAPIBaseURL = @"http://169.254.151.147:3000/";

@interface ServerManager()

- (ServerRequest*)openUrl:(NSString *)url
                   params:(NSMutableDictionary *)params
               httpMethod:(NSString *)httpMethod
                 delegate:(id<ServerRequestDelegate>)delegate;

@end

@implementation ServerManager

@synthesize request;

- (void)dealloc
{
    [request release];
    
    [super dealloc];
}

- (ServerRequest *)openUrl:(NSString *)url
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)httpMethod
                  delegate:(id<ServerRequestDelegate>)delegate
{
    [request release];
    
    request = [[ServerRequest getRequestWithParams:params
                                        httpMethod:httpMethod
                                          delegate:delegate
                                        requestURL:url] retain];
    [request connect];
    
    return self.request;
}

- (ServerRequest *)getRequestVersionWithDelegate:(id<ServerRequestDelegate>)delegate
{
    NSString* strRequestURL = [kAPIBaseURL stringByAppendingString:@"version.json"];
    NSLog(@"%@", strRequestURL);
    
    return [self openUrl:strRequestURL
                  params:nil
              httpMethod:@"GET"
                delegate:delegate];
}

- (ServerRequest *)getRequestCategoryWithDelegate:(id<ServerRequestDelegate>)delegate
{
    NSString* strRequestURL = [kAPIBaseURL stringByAppendingString:@"users/1.json"];
    NSLog(@"%@", strRequestURL);
    
    return [self openUrl:strRequestURL
                  params:nil
              httpMethod:@"GET"
                delegate:delegate];
}

- (ServerRequest *)getRequestDevotionListWithDelegate:(id<ServerRequestDelegate>)delegate
                                                  pID:(NSString *)pID
{
    NSString* strRequestURL = [kAPIBaseURL stringByAppendingString:[NSString stringWithFormat:@"categories/%@.json", pID]];
    NSLog(@"%@", strRequestURL);
    
    return [self openUrl:strRequestURL
                  params:nil
              httpMethod:@"GET"
                delegate:delegate];
}

@end
