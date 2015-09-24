//
//  LocationViewController.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "LocationViewController.h"
#import "DetailViewController.h"
#import "FourSquareSearchResult.h"
#import "APIManager.h"

@interface LocationViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) NSArray *distance;
@property (nonatomic) FourSquareSearchResult *businessDetails;

@end

@implementation LocationViewController

#pragma mark - View setup
- (void)viewDidLoad {
    [super viewDidLoad];

    // connect the delegate(s)
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.searchTextField.delegate = self;
}

#pragma mark - Instagram API Request
- (void)makeNewInstagramAPIRequestWithSearchTerm: (NSString *)searchTerm // pass instagram search term
                                    callbackBlock:(void(^)())block { // call block
   block();
}

#pragma mark - FourSquare API Request
- (void)makeNewFourSquareAPIRequestWithSearchTerm: (NSString *)searchTerm // pass four square search term
                                    callbackBlock:(void(^)())block { // call block
    
    // search terms via url
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=M1KDUWRS5OBWUNQCXHHF23TAUEG2YOB0RXGBSP0LBVRCX2XL&client_secret=FWTAPZOJ4UBPUXX2R5Q1D5F3X0HXMCSMERWL4DJFW3UA33YX&v=20150919&ll=40.7,-74&query=%@", searchTerm];
    
    // &ll=40.7,-74 = latitude/longitude
    
    // encode url strings (so you can search for more than one word with spaces!)
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"%@", encodedString); // test it!
    
    // convert urlString to url
    NSURL *url = [NSURL URLWithString:encodedString];
    
    // make the request
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:nil];

           // NSLog(@"%@", json); // log dictionary
            
            NSArray *venues = [[json objectForKey:@"response"] objectForKey:@"venues"];
            
          // NSLog(@"%@", venues);
            
            self.searchResults = [[NSMutableArray alloc]init]; // initialize storage for array
            
            for (NSDictionary *venue in venues) { // create loop
                
                NSString *venueName = [venue objectForKey:@"name"]; // grab specific info from dictionary
                NSString *venueLocation = [venue objectForKey:@"location"];
                
                NSString *address = [venueLocation valueForKey:@"address"];
                NSString *city = [venueLocation valueForKey:@"city"];
                
                NSString *distance = [venueLocation valueForKey:@"distance"];   // get the distance then learn how to sort it...
              // NSLog(@"%@", distance);

// include businesses without full address info:
//                if (address == nil) {
//                    address = @"";
//                }
//                if (city == nil) {
//                    city = @"";
//                }
//                if (distance == nil) {
//                    distance = @"";
//                }
                
                FourSquareSearchResult *resultsObject = [[FourSquareSearchResult alloc]init];
                
                resultsObject.restaurantName = venueName;
                resultsObject.restaurantAddress = [NSString stringWithFormat:@"%@, %@", address, city];
                resultsObject.restaurantDistance = distance;
                
                [self.searchResults addObject:resultsObject];
                
                //NSLog(@"%@", self.searchResults);
            }
            block();
        }
    }];
}

#pragma mark - textField method
- (BOOL)textFieldShouldReturn:(UITextField *)textField { // when return button on keyboard is pressed...
    
    [self.view endEditing:YES]; // end editing + dismiss keyboard
    
    [self makeNewFourSquareAPIRequestWithSearchTerm:textField.text callbackBlock:^{ //make an API request
        
        [self.listTableView reloadData]; // reload table data
    }];
    return YES;
}

#pragma mark - tableView setup

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    FourSquareSearchResult *currentResult = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResult.restaurantName;
    cell.detailTextLabel.text = currentResult.restaurantAddress;
    
    return cell;
}

#pragma mark - prepareForSegue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  //  if ([segue.identifier isEqualToString:@"showDetailViewControllerIdentifier"]) { // reference segue title
    
        NSIndexPath *myIndexPath = [self.listTableView indexPathForSelectedRow];
        FourSquareSearchResult *dataToPass = self.searchResults[myIndexPath.row];
        DetailViewController *dvc = segue.destinationViewController; // referene to dvc
        dvc.dataPassed = dataToPass;
    }


@end
