//
//  DetailViewController.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailViewController.h"
#import "InstagramPost.h"
#import "Colours.h"
#import "DetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


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

@property (nonatomic) NSArray *colorArray;
@property (nonatomic) NSInteger currIndexColor;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.titleLabel.text = self.dataPassed.restaurantName;
    self.addressLabel.text = self.dataPassed.restaurantAddress;
    self.detailsLabel.text = self.dataPassed.restaurantDistance;
    
    // use cool Color open source files
    self.currIndexColor = 0;
    UIColor *color = [UIColor snowColor];
    self.colorArray = [color colorSchemeOfType:ColorSchemeMonochromatic];
    
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.titleLabel.textColor = [color darken:0.60f];
    self.addressLabel.textColor = [color darken:0.50f];
    self.detailsLabel.textColor = [color darken:0.50f];
    
    // add .xib for custom tableviewcell
    UINib *nib = [UINib nibWithNibName:@"DetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"InstagramCellIdentifier"];
    
    // tableview adjusts to cell size
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40.0;
    
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
    // edit for custom cell
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCellIdentifier" forIndexPath:indexPath];     InstagramPost *post = self.instagramPosts[indexPath.row];

// for original tableviewcells:
//    cell.textLabel.text = post.username;
//    cell.detailTextLabel.text = post.caption[@"text"];

    cell.captionLabel.text = post.caption[@"text"];
    
    NSURL *url = [NSURL URLWithString:post.imageURL];
    [cell.userMediaImageView sd_setImageWithURL:url
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.userMediaImageView.image = image;
    }];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor clearColor]]; // keep tableview cell color from changing back to white
    cell.textLabel.textColor = [[UIColor linenColor]darken:0.50f];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:24];
    cell.detailTextLabel.textColor = [[UIColor linenColor]darken:0.25f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
}

@end
