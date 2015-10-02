//
//  DetailTableViewCell.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "Colours.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.captionLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    self.captionLabel.textColor = [[UIColor linenColor]darken:0.25f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
