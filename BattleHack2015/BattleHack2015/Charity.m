//
//  Charity.m
//  BattleHack2015
//
//  Created by george mcdonnell on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "Charity.h"

@implementation Charity

- (instancetype)initWithCharityID:(NSString *)charityID name:(NSString *)name shortDescription:(NSString *)shortDescription longDescription:(NSString *)longDescription logoURL:(NSString *)logoURL
{
    self = [super init];
    if (self) {
        self.charityID = charityID;
        self.name = name;
        self.shortDescription = shortDescription;
        self.longDescription = longDescription;
        self.logoURL = logoURL;
    }
    return self;
}

@end
