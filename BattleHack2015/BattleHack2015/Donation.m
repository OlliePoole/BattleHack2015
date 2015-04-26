//
//  Donation.m
//  BattleHack2015
//
//  Created by george mcdonnell on 26/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "Donation.h"

@implementation Donation

- (instancetype)initWithUsername:(NSString *)userName userImageURL:(NSString *)userImageURL date:(NSString *)date message:(NSString *)message amount:(NSString *)amount giftAid:(NSString *)giftAid
{
    self = [super init];
    if (self) {
        self.userName = userName;
        self.userImageURL = userImageURL;
        self.date = date;
        self.message = message;
        self.amount = amount;
        self.giftAid = giftAid;
    }
    return self;
}

@end
