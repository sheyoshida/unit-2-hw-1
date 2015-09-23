//
//  APIManager.h
//  LearnAPI
//
//  Created by Shena Yoshida on 9/20/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

// public method:
+ (void)GETRequestWithURL:(NSURL *)URL // + makes it a class method, we don't have to alloc init it!
        completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

// completionHandler = block
@end
