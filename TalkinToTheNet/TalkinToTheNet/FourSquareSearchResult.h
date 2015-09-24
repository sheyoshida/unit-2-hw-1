//
//  FourSquareSearchResult.h
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareSearchResult : NSObject

@property (nonatomic) NSString *restaurantName;
@property (nonatomic) NSString *restaurantAddress;
@property (nonatomic) NSString *restaurantDistance;
@property (nonatomic) NSString *restaurantPhoneNumber;
@property (nonatomic) NSString *restaruantTwitterHandle;
@property (nonatomic) NSString *restaurantDelivery;

@end
