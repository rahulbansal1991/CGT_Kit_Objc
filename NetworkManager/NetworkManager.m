//
//  NetworkManager.m
//  CGT_Kit_Objc
//
//  Created by RB on 26/04/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

static NSMutableArray *networkQueue = nil;

+ (NSMutableArray *) getNetworkQueue{
    if(networkQueue != nil)
        return networkQueue;
    networkQueue =  [[NSMutableArray alloc]init];
    return networkQueue;
}

+ (void)cancelAllRunningNetworkOperations{
    for (AFHTTPRequestOperation *operation in [self getNetworkQueue]){
        @try {
            [operation cancel];
            [networkQueue removeObject:operation];
        }
        @catch (NSException *exception) {
            NSLog(@"Error while cancelling the operation");
        }
        @finally {
            
        }
    }
}

+ (void)executePostWithUrl:(NSString*)url
             andParameters:(NSDictionary*)parameters
                andHeaders:(NSDictionary*)headers
andAuthorizationHeaderUser:(NSString*)user
andAuthrozationHeaderPassword:(NSString*)password
        withSuccessHandler:(RequestSuccess)success
        withFailureHandler:(RequestFail)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager securityPolicy]setAllowInvalidCertificates:YES];
    [[manager requestSerializer]setAuthorizationHeaderFieldWithUsername:user password:password];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;

    operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if ([operation isCancelled])
        {
            return;
        }
      
        [[self getNetworkQueue] removeObject:operation];
        
        bool apiSuccess = YES;
        success(operation, responseObject, apiSuccess);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if ([operation isCancelled])
        {
            return;
        }
        
        failure(operation, error);
    } autoRetry:REQUEST_RETRY_AFTER_TIMEOUT retryInterval:REQUEST_TIMEOUT_INTERVAL];
    
    [[self getNetworkQueue] addObject:operation];
}

+ (void)executePostWithUrl:(NSString*)url
             andParameters:(NSDictionary*)parameters
                andHeaders:(NSDictionary*)headers
                  andImage:(UIImage*)image
               andImageTag:(NSString*)image_tag
 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
        withSuccessHandler:(RequestSuccess)success
        withFailureHandler:(RequestFail)failure
{
    if (![self isDataConnectionAvailable])
    {
        NSLog(@"No data connection is available");

        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    
    if (!image)
    {
        NSLog(@"No image");
        
        failure(nil, [[NSError alloc]initWithDomain:@"Image nil" code:0 userInfo:@{}]);
        return;
    }
    
    if (!image_tag)
    {
        NSLog(@"No image_tag");
        
        failure(nil, [[NSError alloc]initWithDomain:@"Image_tag nil" code:0 userInfo:@{}]);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // hack to allow 'text/plain' content-type to work
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    AFHTTPRequestOperation *operation;

    NSData *imageData = UIImageJPEGRepresentation(image, IMAGE_COMPRESSION_QUALITY);
    
    operation = [manager POST:url parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([operation isCancelled]){
            return;
        }
        
        [formData appendPartWithFormData:imageData name:image_tag];

        //do not put image inside parameters dictionary as I did, but append it!
//        [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);

        [[self getNetworkQueue] removeObject:operation];

        success(operation, responseObject, YES);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([operation isCancelled]){
            return;
        }
        
        [[self getNetworkQueue] removeObject:operation];
        
        NSLog(@"failure %@ - %@", operation, error);
        if(![operation isEqual:nil] & ![error isEqual:nil]){
            failure(operation, error);
        }
    } autoRetry:REQUEST_RETRY_AFTER_TIMEOUT retryInterval:REQUEST_TIMEOUT_INTERVAL];
    
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executePostWithUrl:(NSString*)url
             andParameters:(NSDictionary*)parameters
                andHeaders:(NSDictionary*)headers
        withSuccessHandler:(RequestSuccess)success
        withFailureHandler:(RequestFail)failure
{
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");

        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    NSLog(@"Executing post request for %@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;

    operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        if ([operation isCancelled]){
            return;
        }
        [[self getNetworkQueue]removeObject:operation];
        NSLog(@"success %@ - %@", operation, responseObject);
        
        bool apiSuccess = YES;
        success(operation, responseObject, apiSuccess);
    }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([operation isCancelled]){
            return;
        }
        NSLog(@"failure %@ - %@", operation, error);
        [[self getNetworkQueue]removeObject:operation];
        
        if(![operation isEqual:nil] & ![error isEqual:nil]){
            failure(operation, error);
        }
    } autoRetry:REQUEST_RETRY_AFTER_TIMEOUT retryInterval:REQUEST_TIMEOUT_INTERVAL];
    
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executePutWithUrl:(NSString*)url
            andParameters:(NSDictionary*)parameters
               andHeaders:(NSDictionary*)headers
       withSuccessHandler:(RequestSuccess)success
       withFailureHandler:(RequestFail)failure
{
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");

        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;

    operation = [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([operation isCancelled]){
            return;
        }
        [[self getNetworkQueue]removeObject:operation];
        NSLog(@"success %@ - %@", operation, responseObject);
        
        bool apiSuccess = [[responseObject objectForKey:@"success"] isEqual:@YES];
        success(operation, responseObject, apiSuccess);
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        if ([operation isCancelled]){
            return;
        }
        [[self getNetworkQueue]removeObject:operation];
        
        NSLog(@"failure %@ - %@", operation, error);
        if(![operation isEqual:nil] & ![error isEqual:nil]){
            failure(operation, error);
        }
    } autoRetry:REQUEST_RETRY_AFTER_TIMEOUT retryInterval:REQUEST_TIMEOUT_INTERVAL];
    
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executeGetWithUrl:(NSString*)url
            andParameters:(NSDictionary*)parameters
               andHeaders:(NSDictionary*)headers
       withSuccessHandler:(RequestSuccess)success
       withFailureHandler:(RequestFail)failure
{
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");

        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    // if failure is nil then its an indication to handle it with default flow that is showing message
    // in alert dialog
    AFHTTPRequestOperation *operation;

    operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        if ([operation isCancelled]){
            return;
        }
        [[self getNetworkQueue]removeObject:operation];
        NSLog(@"success %@ - %@", operation, responseObject);
        bool apiSuccess = YES;
        success(operation, responseObject, apiSuccess);
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([operation isCancelled]){
            return;
        }
        [[self getNetworkQueue]removeObject:operation];
        NSLog(@"failure %@ - %@", operation, error);
        if(![operation isEqual:nil] & ![error isEqual:nil]){
            @try {
                if(failure)
                    failure(operation, error);
                
            }
            @catch (NSException *exception) {
                NSLog(@"exception handling timeout %@",exception);
            }
        }
    } autoRetry:REQUEST_RETRY_AFTER_TIMEOUT retryInterval:REQUEST_TIMEOUT_INTERVAL];

    [[self getNetworkQueue]addObject:operation];
}

+ (BOOL)isDataConnectionAvailable {
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}

@end
