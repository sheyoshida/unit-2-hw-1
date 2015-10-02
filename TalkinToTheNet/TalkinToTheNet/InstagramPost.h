//
//  InstagramPost.h
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/28/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPost : NSObject

@property (nonatomic) NSArray *tags;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSDictionary *caption;
@property (nonatomic) NSString *imageURL;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
