//
//  DonationTableViewCell.m
//  BattleHack2015
//
//  Created by george mcdonnell on 26/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "DonationTableViewCell.h"

@implementation DonationTableViewCell

- (void)drawRect:(CGRect)rect
{
    self.backView.layer.cornerRadius = 3.0f;
    self.backView.layer.masksToBounds = YES;
    
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowOpacity = 0.3f;
    self.backView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.backView.layer.shadowRadius = 2.0f;
    self.backView.layer.masksToBounds = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.backView.bounds];
    self.backView.layer.shadowPath = path.CGPath;
}

@end
