//
//  DonationTableViewCell.h
//  BattleHack2015
//
//  Created by george mcdonnell on 26/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *donaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *donaterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *donateDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *donationPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftAidLabel;



@end
