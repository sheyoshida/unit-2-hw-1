//
//  APIManager.m
//  LearnAPI
//
//  Created by Shena Yoshida on 9/20/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (void)GETRequestWithURL:(NSURL *)URL // + makes it a class method, we don't have to alloc init it! 
        completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    // access the shared session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // create a data task to execute a api request. By default this happens on a background thread
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // moving back to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(data, response, error);
        });
    }];
    
    
    // kickoff the task
    [task resume];
    
}

@end
