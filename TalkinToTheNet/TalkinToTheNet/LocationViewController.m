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
#import "Colours.h"
#import <pop/POP.h>

@interface LocationViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIButton *pizzaButton;
@property (nonatomic) NSMutableArray *searchResults;

@property (nonatomic) NSArray *colorArray;
@property (nonatomic) NSInteger currIndexColor;

@end

@implementation LocationViewController

#pragma mark - View setup
- (void)viewDidLoad {
    [super viewDidLoad];

    // connect the delegate(s)
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.searchTextField.delegate = self;
    
    // use cool Color open source files
    self.currIndexColor = 0;
    UIColor *color = [UIColor snowColor];
    self.colorArray = [color colorSchemeOfType:ColorSchemeMonochromatic];
    
    self.view.backgroundColor = color;
    
    self.searchTextField.backgroundColor = [UIColor ghostWhiteColor];
    self.searchTextField.textColor = [color darken:0.50f];
  
    self.listTableView.backgroundColor = color;
    self.listTableView.separatorColor = [color darken:0.25f];
}

#pragma mark - ANIMATE PIZZA!!!

- (void)animatePizzaButton {
    
    POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    
    spin.fromValue = @(M_PI / 4);
    spin.toValue = @(5);
    spin.springBounciness = 5;
    spin.velocity = @(1);
    
    [self.pizzaButton.layer pop_addAnimation:spin forKey:nil];
}


#pragma mark - FourSquare API Request
- (void)makeNewFourSquareAPIRequestWithSearchTerm: (NSString *)searchTerm // pass four square search term
                                    callbackBlock:(void(^)())block { // call block
    
    // search terms via url
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=M1KDUWRS5OBWUNQCXHHF23TAUEG2YOB0RXGBSP0LBVRCX2XL&client_secret=FWTAPZOJ4UBPUXX2R5Q1D5F3X0HXMCSMERWL4DJFW3UA33YX&v=20150919&ll=40.7,-74&query=%@", searchTerm];
    
    // encode url strings (so you can search for more than one word with spaces!)
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
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
            
          //  NSLog(@"%@", venues);
            
            self.searchResults = [[NSMutableArray alloc]init]; // initialize storage for array
            
            for (NSDictionary *venue in venues) { // create loop
                
                NSString *venueName = [venue objectForKey:@"name"]; // grab specific info from dictionary
                NSString *venueLocation = [venue objectForKey:@"location"];
                
                NSString *address = [venueLocation valueForKey:@"address"];
                NSString *city = [venueLocation valueForKey:@"city"];
                NSString *state = [venueLocation valueForKey:@"state"];
               
                NSString *distance = [venueLocation valueForKey:@"distance"];   // get the distance
               
                // convert string into double to calculate miles
                double distanceConvertedToDouble = [distance doubleValue];
                double metersInAMile = 1609.34;
                double distanceInMiles = distanceConvertedToDouble / metersInAMile;
                
                // then convert it back to a string...
                NSString *stringInMiles = [NSString stringWithFormat:@"%.2f", distanceInMiles];
                
                // include all results, even the ones with missing addresses
                if (address == nil){
                    address = @"";
                }
                if (city == nil){
                    city = @"";
                }
                
                FourSquareSearchResult *resultsObject = [[FourSquareSearchResult alloc]init];
                
                resultsObject.restaurantName = venueName;
                resultsObject.restaurantAddress = [NSString stringWithFormat:@"%@, %@, %@", address, city, state];
                resultsObject.restaurantDistance = [NSString stringWithFormat:@"distance: %@ miles", stringInMiles];
                //resultsObject.restaurantSearchTerm = self.searchWords;
                
                [self.searchResults addObject:resultsObject];
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
        
        [self animatePizzaButton]; // animate pizza
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
    
    // animate table cells
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    sprintAnimation.springBounciness = 20.f;
    [cell.textLabel pop_addAnimation:sprintAnimation forKey:nil];
    [cell.detailTextLabel pop_addAnimation:sprintAnimation forKey:nil];
    
    // other table cell setup
    FourSquareSearchResult *currentResult = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResult.restaurantName;
    cell.detailTextLabel.text = currentResult.restaurantDistance;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor clearColor]]; // keep tableview cell color from changing back to white
    cell.textLabel.textColor = [[UIColor linenColor]darken:0.50f];
    cell.detailTextLabel.textColor = [[UIColor linenColor]darken:0.25f];
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
