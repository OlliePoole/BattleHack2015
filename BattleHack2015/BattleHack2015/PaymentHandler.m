//
//  PaymentHandler.m
//  BattleHack2015
//
//  Created by Oliver Poole on 4/26/15.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "PaymentHandler.h"

@interface PaymentHandler ()

@property (nonatomic, strong) Braintree *braintree;
@property (nonatomic, strong) BTPaymentProvider *provider;
@property (strong, nonatomic) NSString *clientToken;

@end

@implementation PaymentHandler

+ (instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void)fetchClientTokenWithResponse:(void (^)(BOOL))response
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://vast-crag-4177.herokuapp.com/client_token"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            self.clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.braintree = [Braintree braintreeWithClientToken:self.clientToken];
            
            response(YES);
        } else {
            response(NO);
        }
    }];
}

#pragma mark - BTDropInViewControllerDelegate

- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod
{
    NSString *nonce = paymentMethod.nonce;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://vast-crag-4177.herokuapp.com/purchases"]];
    [request setHTTPMethod:@"POST"];
    NSString *body = [NSString stringWithFormat:@"payment-method-nonce=%@", nonce];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            if ([self.delegate respondsToSelector:@selector(paymentProcessComplete)]) {
                [self.delegate paymentProcessComplete];
            }
        }
    }];
}

- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController
{
    //TODO: Do something useful here
}

- (void)dropInViewControllerWillComplete:(BTDropInViewController *)viewController
{
    //TODO: Do something useful here
}

- (BTDropInViewController *)dropInViewController
{
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    
    [dropInViewController setSummaryTitle:[NSString stringWithFormat:@"Donation to %@", self.charityName]];
    [dropInViewController setDisplayAmount:[NSString stringWithFormat:@"%f", self.paymentAmount]];
    [dropInViewController setCallToActionText:@"Donate"];
    [dropInViewController setDelegate:self];
    
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    
    return dropInViewController;
}

@end
