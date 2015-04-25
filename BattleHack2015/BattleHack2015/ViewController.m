//
//  ViewController.m
//  BattleHack2015
//
//  Created by Oliver Poole on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "ViewController.h"
#import <Braintree/Braintree.h>


@interface ViewController () <BTPaymentMethodCreationDelegate, BTDropInViewControllerDelegate>

@property (nonatomic, strong) Braintree *braintree;
@property (nonatomic, strong) BTPaymentProvider *provider;
@property (strong, nonatomic) NSString *clientToken;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    // TODO: Switch this URL to your own authenticated API
//    NSURL *clientTokenURL = [NSURL URLWithString:@"https://braintree-sample-merchant.herokuapp.com/client_token"];
//    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
//    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
//    
//    [NSURLConnection
//     sendAsynchronousRequest:clientTokenRequest
//     queue:[NSOperationQueue mainQueue]
//     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//         // TODO: Handle errors in [(NSHTTPURLResponse *)response statusCode] and connectionError
//         NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         
//         // Initialize `Braintree` once per checkout session
//         [Braintree
//          setupWithClientToken:clientToken
//          completion:^(Braintree *braintree, NSError *error) {
//              UIViewController *dropin = [braintree dropInViewControllerWithDelegate:self];
//              [self presentViewController:[[UINavigationController alloc] initWithRootViewController:dropin]
//                                 animated:YES
//                               completion:nil];
//          }];
//     }];
    
    self.clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI4ZWVmM2Y5Yzk4ZTI1Yjg4N2YyY2RlYjdlZGUzODlhYjBiN2MyMmQ1ZWE1ODdhZDQ2OWQzMDQ3MDZjMWI5ZTM2fGNyZWF0ZWRfYXQ9MjAxNS0wNC0yNVQxNDozNToxMi4yODQ1ODUwMzMrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQiLCJtZXJjaGFudEFjY291bnRJZCI6InN0Y2gybmZkZndzenl0dzUiLCJjdXJyZW5jeUlzb0NvZGUiOiJVU0QifSwiY29pbmJhc2VFbmFibGVkIjp0cnVlLCJjb2luYmFzZSI6eyJjbGllbnRJZCI6IjExZDI3MjI5YmE1OGI1NmQ3ZTNjMDFhMDUyN2Y0ZDViNDQ2ZDRmNjg0ODE3Y2I2MjNkMjU1YjU3M2FkZGM1OWIiLCJtZXJjaGFudEFjY291bnQiOiJjb2luYmFzZS1kZXZlbG9wbWVudC1tZXJjaGFudEBnZXRicmFpbnRyZWUuY29tIiwic2NvcGVzIjoiYXV0aG9yaXphdGlvbnM6YnJhaW50cmVlIHVzZXIiLCJyZWRpcmVjdFVybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tL2NvaW5iYXNlL29hdXRoL3JlZGlyZWN0LWxhbmRpbmcuaHRtbCJ9LCJtZXJjaGFudElkIjoiZGNwc3B5MmJyd2RqcjNxbiIsInZlbm1vIjoib2ZmbGluZSIsImFwcGxlUGF5Ijp7InN0YXR1cyI6Im1vY2siLCJjb3VudHJ5Q29kZSI6IlVTIiwiY3VycmVuY3lDb2RlIjoiVVNEIiwibWVyY2hhbnRJZGVudGlmaWVyIjoibWVyY2hhbnQuY29tLmJyYWludHJlZXBheW1lbnRzLm1pY2tleXJlaXNzLkR1YWxBcHBsZVBheS5icmFpbnRyZWUiLCJzdXBwb3J0ZWROZXR3b3JrcyI6WyJ2aXNhIiwibWFzdGVyY2FyZCIsImFtZXgiXX19";

    [Braintree setupWithClientToken:self.clientToken completion:^(Braintree *braintree, NSError *error) {
        self.braintree = braintree;
        self.provider = [self.braintree paymentProviderWithDelegate:self];
        self.provider.paymentSummaryItems = @[
                                              [PKPaymentSummaryItem summaryItemWithLabel:@"COMPANY NAME" amount:[NSDecimalNumber decimalNumberWithString:@"1"]]
                                              ];
    }];

    
    
}

- (IBAction)pay:(id)sender
{
    [Braintree setupWithClientToken:self.clientToken completion:^(Braintree *braintree, NSError *error) {
        BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
        // This is where you might want to customize your Drop in. (See below.)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                              target:self
                                                                                                              action:@selector(userDidCancelPayment)];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
        [self presentViewController:navigationController
                           animated:YES
                         completion:nil];

    }];

}

- (IBAction)tappedApplePay {
    [self.provider createPaymentMethod:BTPaymentProviderTypeApplePay];
}

- (void)paymentMethodCreator:(id)sender requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentMethodCreator:(id)sender requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentMethodCreator:(id)sender didCreatePaymentMethod:(BTPaymentMethod *)paymentMethod {
    if ([paymentMethod isKindOfClass:[BTApplePayPaymentMethod class]]) {
        BTApplePayPaymentMethod *applePayPaymentMethod = (BTApplePayPaymentMethod *)paymentMethod;
        // Send payment information to your server:
        //   - applePayPaymentMethod.nonce
        //   - applePayPaymentMethod.shippingAddress
        //   - applePayPaymentMethod.billingAddress
        //   - applePayPaymentMethod.shippingMethod
        // Clean up any UI now that the payment is complete
    } else if ([paymentMethod isKindOfClass:[BTPayPalPaymentMethod class]]) {
        BTPayPalPaymentMethod *paypalPaymentMethod = (BTPayPalPaymentMethod *)paymentMethod;
        
    }
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
