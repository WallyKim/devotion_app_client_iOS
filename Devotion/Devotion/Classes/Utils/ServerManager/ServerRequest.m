//
//  ServerRequest.m
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 19..
//  Copyright (c) 2012년 NewPerson. All rights reserved.
//

#import "ServerRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "JSON.h"

static const NSTimeInterval kTimeoutInterval = 300.0;
static NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORh";

@implementation ServerRequest

@synthesize delegate;
@synthesize strURL;
@synthesize strHttpMethod;
@synthesize mDicParams;
@synthesize connection;
@synthesize mDataResponse;

@synthesize httpRequest;
@synthesize formDataRequest;

- (void)dealloc
{
    self.strURL = nil;
    self.strHttpMethod = nil;
    self.mDicParams = nil;
    self.connection = nil;
    self.mDataResponse = nil;
    
    [formDataRequest setDelegate:nil];
	[formDataRequest setUploadProgressDelegate:nil];
	[formDataRequest cancel];
	[formDataRequest release];
    
    [httpRequest clearDelegatesAndCancel];
    [httpRequest release];
        
    [super dealloc];
}

+ (ServerRequest *)getRequestWithParams:(NSMutableDictionary *)params 
                             httpMethod:(NSString *)httpMethod 
                               delegate:(id<ServerRequestDelegate>)delegate 
                             requestURL:(NSString *)url
{
    ServerRequest* request = [[[ServerRequest alloc] init] autorelease];
    request.delegate = delegate;
    request.strURL = url;
    request.strHttpMethod = httpMethod;
    request.mDicParams = params;
    request.connection = nil;
    request.mDataResponse = nil;
    
    return request;
}

- (BOOL)loading
{
    return !!self.connection;
}

- (void)connect
{
    if ([self.strHttpMethod isEqualToString:@"GET"])
    {
        [httpRequest cancel];
        
        self.httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.strURL]];
        self.httpRequest.delegate = self;
        
        [self.httpRequest startAsynchronous];
    }
    else if ([self.strHttpMethod isEqualToString:@"POST"])
    {
        [formDataRequest cancel];
        
        [self setFormDataRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.strURL]]];
        [formDataRequest setRequestMethod:self.strHttpMethod];
        
        [formDataRequest setPostFormat:ASIURLEncodedPostFormat];
        
        for (id key in [self.mDicParams keyEnumerator])
        {            
            [formDataRequest setPostValue:[self.mDicParams valueForKey:key] forKey:key];
        }
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        [formDataRequest setShouldContinueWhenAppEntersBackground:YES];
#endif
        [formDataRequest setUploadProgressDelegate:self];
        [formDataRequest setDelegate:self];
        [formDataRequest setDidFailSelector:@selector(uploadFailed:)];
        [formDataRequest setDidFinishSelector:@selector(uploadFinished:)];
        [formDataRequest setTimeOutSeconds:kTimeoutInterval];
        
        [formDataRequest startAsynchronous];    
    }
    else if ([self.strHttpMethod isEqualToString:@"PUT"])
    {
        
    }
}

- (void)handleWithResponseData:(NSData *)data
{
    if ([self.delegate respondsToSelector:@selector(requestDevotion:didLoad:)] || 
        [self.delegate respondsToSelector:@selector(requestDevotion:didFailWithError:)])
    {
        id result = [self parseJsonWithResponseData:data];
        
        [self.delegate requestDevotion:self didLoad:result];
    }
}

- (id)parseJsonWithResponseData:(NSData *)data
{
    NSString* strResponseData = [[[NSString alloc] initWithData:data 
                                                       encoding:NSUTF8StringEncoding] autorelease];
    
    SBJSON *jsonParser = [[SBJSON new] autorelease];
    id result = [jsonParser objectWithString:strResponseData];    
    
    NSLog(@"%@", result);
    
    return result;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response
{
    mDataResponse = [[NSMutableData alloc] init];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection 
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self handleWithResponseData:self.mDataResponse];
    
    self.mDataResponse = nil;
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    self.mDataResponse = nil;
    self.connection = nil;
    
    if ([self.delegate respondsToSelector:@selector(requestDevotion:didFailWithError:)])
        [self.delegate requestDevotion:self didFailWithError:error];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)uploadFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[request error] localizedDescription]]);
    NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[request error]]);
    
    if ([self.delegate respondsToSelector:@selector(requestDevotion:didFailWithError:)])
        [self.delegate requestDevotion:self didFailWithError:[request error]];
}

- (void)uploadFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [NSString stringWithFormat:@"Finished uploading %llu bytes of data",[request postLength]]); 
    NSLog(@"%@", [NSString stringWithFormat:@"Finished uploading : %@", [request responseString]]); 
    
    [self handleWithResponseData:[request responseData]];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    
#if false
    // Clear out the old notification before scheduling a new one.
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > 0)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Create a new notification
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    if (notification) {
		[notification setFireDate:[NSDate date]];
		[notification setTimeZone:[NSTimeZone defaultTimeZone]];
		[notification setRepeatInterval:0];
		[notification setSoundName:@"alarmsound.caf"];
		[notification setAlertBody:@"Boom!\r\n\r\nUpload is finished!"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
#endif
    
#endif
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //    NSString *responseString = [request responseString];
    //    NSLog(@"%@", responseString);
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
//    NSLog(@"%@", responseData);
    
    [self handleWithResponseData:responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000    
    //    NSLog(@"%@", error.debugDescription);
#endif
}

@end
