//
//  DetailViewController.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailViewController.h"
#import "InstagramPost.h"


@interface DetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *instagramPosts;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.titleLabel.text = self.dataPassed.restaurantName;
    self.addressLabel.text = self.dataPassed.restaurantAddress;
    self.detailsLabel.text = self.dataPassed.restaurantDistance;
    
    [self fetchInstagramData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - fetchInstagramData

- (void)fetchInstagramData {
    
   NSString *tagName = [self.dataPassed.restaurantName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tagNameWithoutCharacter = [tagName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", tagNameWithoutCharacter];
    
    NSURL *instagramURL = [NSURL URLWithString:url]; // create url
    
      NSLog(@"this is my url: %@", instagramURL); // test it! it works! 
    
    [APIManager GETRequestWithURL:instagramURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       
        NSLog(@"JSON %@", json);
            
        NSArray *results = json[@"data"];
        
        NSLog(@"RESULTS: %@", results);
        
        self.instagramPosts = [[NSMutableArray alloc] init]; // create/reset array
        
        for (NSDictionary *result in results) {
            
            // create new post from json
            InstagramPost *post = [[InstagramPost alloc] initWithJSON:result];
            
            // add post to array
            [self.instagramPosts addObject:post];
        }
        
        [self.tableView reloadData];
        }
        }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instagramPosts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCellIdentifier" forIndexPath:indexPath];
    InstagramPost *post = self.instagramPosts[indexPath.row];
    cell.textLabel.text = post.username;
    cell.detailTextLabel.text = post.caption[@"text"];
    return cell;
}

@end
