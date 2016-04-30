//
//  NetworkManager.h
//  CGT_Kit_Objc
//
//  Created by RB on 26/04/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Reachability/Reachability.h>
#import "AFHTTPRequestOperationManager+AutoRetry.h"
#import "AFHTTPSessionManager+AutoRetry.h"


// Global Configuration
#define REQUEST_TIMEOUT_INTERVAL ((int) 30)
#define REQUEST_RETRY_AFTER_TIMEOUT ((int) 2)
#define IMAGE_COMPRESSION_QUALITY ((float) 1)

typedef void (^RequestSuccess)(AFHTTPRequestOperation *request, id data, bool status);
typedef void (^RequestFail)(AFHTTPRequestOperation *request, NSError *error);

@interface NetworkManager : NSObject

+ (void)cancelAllRunningNetworkOperations;

+ (void)executePostWithUrl:(NSString*)url
             andParameters:(NSDictionary*)parameters
                andHeaders:(NSDictionary*)headers
                  andImage:(UIImage*)image
               andImageTag:(NSString*)image_tag
 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
        withSuccessHandler:(RequestSuccess)success
        withFailureHandler:(RequestFail)failure;

+ (void)executePostWithUrl:(NSString*)url
             andParameters:(NSDictionary*)parameters
                andHeaders:(NSDictionary*)headers
        withSuccessHandler:(RequestSuccess)success
        withFailureHandler:(RequestFail)failure;

+ (void)executePostWithUrl:(NSString*)url
             andParameters:(NSDictionary*)parameters
                andHeaders:(NSDictionary*)headers
andAuthorizationHeaderUser:(NSString *)user
andAuthrozationHeaderPassword:(NSString*)password
        withSuccessHandler:(RequestSuccess)success
        withFailureHandler:(RequestFail)failure;

+ (void)executePutWithUrl:(NSString*)url
            andParameters:(NSDictionary*)parameters
               andHeaders:(NSDictionary*)headers
       withSuccessHandler:(RequestSuccess)success withFailureHandler:(RequestFail)failure;

+ (void)executeGetWithUrl:(NSString*)url
            andParameters:(NSDictionary*)parameters
               andHeaders:(NSDictionary*)headers
       withSuccessHandler:(RequestSuccess)success
       withFailureHandler:(RequestFail)failure;

@end
