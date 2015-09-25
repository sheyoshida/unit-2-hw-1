//
//  DetailViewController.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailViewController.h"
#import "APIManager.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@property (nonatomic) NSString *searchResults;
@property (nonatomic) IBOutlet UILabel *instagramLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = self.dataPassed.restaurantName;
    self.addressLabel.text = self.dataPassed.restaurantAddress;
    self.detailsLabel.text = self.dataPassed.restaurantDistance;
    
    [self makeNewInstagramAPIRequestWithSearchTerm: self.dataPassed.restaurantSearchTerm callbackBlock:^{
        [self.instagramLabel reloadInputViews];
    }];
    
}

#pragma mark - Instagram API Request
- (void) makeNewInstagramAPIRequestWithSearchTerm: (NSString *)searchTerm
                                    callbackBlock:(void(^)())block {

    
    // search terms via url
     NSString *instagramURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", searchTerm];
    
    NSString *encodedString = [instagramURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // encode string so that it can support more than one word
    
    NSLog(@"my second api url: %@", encodedString); // test it
    
    NSURL *url2 = [NSURL URLWithString:encodedString]; // convert to url
    
    [APIManager GETRequestWithURL:url2 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *venues = [[json objectForKey:@"data"] objectForKey:@"link"];
            
            NSLog(@"%@", venues);
            
        }
        block();
    }];
}



@end
