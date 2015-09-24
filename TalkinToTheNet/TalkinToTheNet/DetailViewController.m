//
//  DetailViewController.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.navigationItem.title = self.dataPassed.restaurantName;
    self.titleLabel.text = self.dataPassed.restaurantName;
    self.addressLabel.text = self.dataPassed.restaurantAddress;
    // self.detailsLabel.text = self.dataPassed.restaurantDistance;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
