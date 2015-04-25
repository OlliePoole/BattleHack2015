//
//  Charity.h
//  BattleHack2015
//
//  Created by george mcdonnell on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Charity : NSObject

@property (strong, nonatomic) NSString *charityID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shortDescription;
@property (strong, nonatomic) NSString *longDescription;
@property (strong, nonatomic) NSString *logoURL;

- (instancetype)initWithCharityID:(NSString *)charityID name:(NSString *)name shortDescription:(NSString *)shortDescription longDescription:(NSString *)longDescription logoURL:(NSString *)logoURL;

@end
