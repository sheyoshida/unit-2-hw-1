//
//  DetailTableViewCell.m
//  TalkinToTheNet
//
//  Created by Shena Yoshida on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "Colours.h"
#import <pop/POP.h>


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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        [self.captionLabel pop_addAnimation:scaleAnimation forKey:nil];
        
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 20.f;
        [self.captionLabel pop_addAnimation:sprintAnimation forKey:nil];
    }
}

@end
