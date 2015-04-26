//
//  Donation.h
//  BattleHack2015
//
//  Created by george mcdonnell on 26/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Donation : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userImageURL;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *giftAid;

- (instancetype)initWithUsername:(NSString *)userName userImageURL:(NSString *)userImageURL date:(NSString *)date message:(NSString *)message amount:(NSString *)amount giftAid:(NSString *)giftAid;

@end
