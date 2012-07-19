//
//  ServerRequest.h
//  Devotion
//
//  Created by Kim Woong-Ki on 12. 7. 19..
//  Copyright (c) 2012년 NewPerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@class ASIFormDataRequest;

@protocol ServerRequestDelegate;

@interface ServerRequest : NSObject

@property (nonatomic, retain) NSString* strURL;
@property (nonatomic, retain) NSString* strHttpMethod;
@property (nonatomic, retain) NSMutableDictionary* mDicParams;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) NSMutableData* mDataResponse;

@property (nonatomic, assign) id<ServerRequestDelegate> delegate;
@property (nonatomic, retain) ASIHTTPRequest* httpRequest;
@property (nonatomic, retain) ASIFormDataRequest* formDataRequest;

+ (ServerRequest*)getRequestWithParams:(NSMutableDictionary *)params
                            httpMethod:(NSString *)httpMethod
                              delegate:(id<ServerRequestDelegate>)delegate
                            requestURL:(NSString *)url;

- (BOOL)loading;

- (void)connect;

@end

@protocol ServerRequestDelegate <NSObject>

@optional

- (void)requestDevotion:(ServerRequest *)request didReceiveResponse:(NSURLResponse *)response;

- (void)requestDevotion:(ServerRequest *)request didReceiveDataPercent:(float)receiveDataPercent;

- (void)requestDevotion:(ServerRequest *)request didSendedDataPercent:(float)sendedDataPercent;

- (void)requestDevotion:(ServerRequest *)request didFailWithError:(NSError *)error;

- (void)requestDevotion:(ServerRequest *)request didLoad:(id)result;

@end
