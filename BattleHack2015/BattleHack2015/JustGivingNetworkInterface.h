//
//  JustGivingNetworkInterface.h
//  BattleHack2015
//
//  Created by george mcdonnell on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Charity.h"

@interface JustGivingNetworkInterface : NSObject


/*
 *  Uri /{appId}/v1/charity/{charityId}
 *  Verb GET
 *  Auth No
 */
+ (void)getCharityWithId:(NSString *)charityID withSuccessBlock:(void (^)(Charity *charity))success withFailureBlock:(void (^)(NSError *error))failure;

/*
 *  Uri /{appId}/v1/charity/{charityId}/donations
 *  Verb GET
 *  Auth No
 */

+ (void)getDonationsForCharityWithId:(NSString *)charityID withSuccessBlock:(void (^)(NSArray *donations))success withFailureBlock:(void (^)(NSError *error))failure;

@end
