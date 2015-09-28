//
//  InstagramPost.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/28/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "InstagramPost.h"

@implementation InstagramPost

- (instancetype)initWithJSON:(NSDictionary *)json {
    // If you need to overwrite initialize, this is the code you need
    if (self = [super init]) {
        
        self.tags = json[@"tags"];
        
        //self.commentCount = [[[json objectForKey:@"comments"] objectForKey:@"count"] integerValue];
        self.commentCount = [json [@"comments"][@"count"] integerValue];
        self.likeCount = [json [@"likes"][@"count"] integerValue];
        self.caption = json[@"caption"];
        self.username = json[@"user"][@"username"];
        self.fullName = json[@"user"][@"full_name"];
        
        return self;
    }
    return nil;
}

@end
