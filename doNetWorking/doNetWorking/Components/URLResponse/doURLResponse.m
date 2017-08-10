//
//  doURLResponse.m
//  doNetWorking
//
//  Created by yangzhen10 on 2017/8/7.
//  Copyright © 2017年 bj-m-206398a. All rights reserved.
//

#import "doURLResponse.h"

@interface doURLResponse()
@property (nonatomic,assign,readwrite) doURLResponseStatus status;
@property (nonatomic,copy,readwrite) NSString *contentString;
@property (nonatomic,copy,readwrite) id content;
@property (nonatomic,strong,readwrite) NSURLRequest *request;
@property (nonatomic,assign,readwrite) NSInteger requestId;
@property (nonatomic,strong,readwrite) NSData *responseData;
@property (nonatomic,assign,readwrite) BOOL isCache;
@property (nonatomic,strong,readwrite) NSError *error;
@end

@implementation doURLResponse
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(doURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.isCache = NO;
        self.error = nil;
    }
    return self;
}
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.isCache = NO;
        self.error = error;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        }else{
            self.content = nil;
        }
    }
    return self;
}
- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}
- (doURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        doURLResponseStatus result = doURLResponseStatusErrorNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = doURLResponseStatusErrorTimeout;
        }
        return result;
    } else {
        return doURLResponseStatusSuccess;
    }
}
@end
