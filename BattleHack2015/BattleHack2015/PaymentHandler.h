//
//  PaymentHandler.h
//  BattleHack2015
//
//  Created by Oliver Poole on 4/26/15.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Braintree/Braintree.h>

@protocol PaymentHandlerDelegate <NSObject>

@required
- (void)paymentProcessComplete;

@end

@interface PaymentHandler : NSObject <BTDropInViewControllerDelegate>

+ (instancetype)sharedInstance;
- (BTDropInViewController *)dropInViewController;
- (void)fetchClientTokenWithResponse:(void (^)(BOOL success))response;

@property (nonatomic, weak) id<PaymentHandlerDelegate> delegate;
@property (nonatomic, strong) NSString *charityName;
@property (nonatomic) CGFloat paymentAmount;

@end
