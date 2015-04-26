//
//  JustGivingViewController.m
//  BattleHack2015
//
//  Created by george mcdonnell on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "JustGivingViewController.h"
#import "JustGivingNetworkInterface.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DonationTableViewCell.h"
#import "Donation.h"
#import "UIImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "PaymentHandler.h"
#import <Braintree/Braintree.h>

NSString *PRINCES_TRUST_ID = @"130521";
NSString *HELP_FOR_HEROS_ID = @"183396";

@interface JustGivingViewController () <UITableViewDataSource, UITableViewDelegate, PaymentHandlerDelegate>

@property (strong, nonatomic) NSArray *donations;

// UI elements

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *donationsTableView;
@property (weak, nonatomic) IBOutlet UILabel *charityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *charityIconImageView;
@property (weak, nonatomic) IBOutlet UITextView *shortDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *longDescriptionTextView;

@property (strong, nonatomic) UIImage *originalLogo;
@property (strong, nonatomic) UIImage *blurredLogo;

@property (nonatomic) BOOL charityLogoIsBlurred;

@property (weak, nonatomic) IBOutlet UIView *fadeAboveView;
@property (weak, nonatomic) IBOutlet UIView *fadeBelowView;

@property (weak, nonatomic) IBOutlet UIButton *donateButton;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *panels;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *coin;

@end

@implementation JustGivingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 2 * 2 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    
    [self.coin.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *justGivingURL = [NSURL URLWithString:@"https://api.justgiving.com/c314e457/v1/charity/search?q=HelpForHeroes"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:justGivingURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
    
    self.donateButton.layer.cornerRadius = 5.0f;
    self.donateButton.layer.masksToBounds = YES;

    
   // NSString *body = [NSString stringWithFormat:@"q=%@", @"Oxfam"];
    
   // [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (!connectionError) {
//            NSError *localError;
//            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
//            
//            
//        } else {
//            
//        }
//    }];
   // self.blurView.tintColor = [UIColor whiteColor];
   // self.blurView.blurRadius = 50;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.fadeAboveView.bounds];

    self.fadeAboveView.layer.masksToBounds = NO;
    self.fadeAboveView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.fadeAboveView.layer.shadowOffset = CGSizeMake(0.0f, -15.0f);
    self.fadeAboveView.layer.shadowRadius = 20;
    self.fadeAboveView.layer.shadowOpacity = 1.0f;
    self.fadeAboveView.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *upperShadowPath = [UIBezierPath bezierPathWithRect:self.fadeBelowView.bounds];
    
    self.fadeBelowView.layer.masksToBounds = NO;
    self.fadeBelowView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.fadeBelowView.layer.shadowOffset = CGSizeMake(0.0f, 50.0f);
    self.fadeBelowView.layer.shadowRadius = 20;
    self.fadeBelowView.layer.shadowOpacity = 1.0f;
    self.fadeBelowView.layer.shadowPath = upperShadowPath.CGPath;
    
    for (UIView *panel in self.panels) {
        panel.layer.cornerRadius = 3.0f;
        panel.layer.masksToBounds = YES;
        
        panel.layer.shadowColor = [UIColor blackColor].CGColor;
        panel.layer.shadowOpacity = 0.3f;
        panel.layer.shadowOffset = CGSizeMake(0, 1.0f);
        panel.layer.shadowRadius = 2.0f;
        panel.layer.masksToBounds = NO;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:panel.bounds];
        panel.layer.shadowPath = path.CGPath;
    }
    
    
    [JustGivingNetworkInterface getCharityWithId:PRINCES_TRUST_ID withSuccessBlock:^(Charity *charity) {
        self.charityNameLabel.text = charity.name;
        self.shortDescriptionTextView.text = charity.shortDescription;
        self.longDescriptionTextView.text = charity.longDescription;
        
        [self.charityIconImageView sd_setImageWithURL:[NSURL URLWithString:charity.logoURL]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        [self.charityIconImageView sd_setImageWithURL:[NSURL URLWithString:charity.logoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:0.5 animations:^{
                self.charityIconImageView.image = image;
                self.originalLogo = image;
                self.blurredLogo = [UIImageEffects imageByApplyingBlurToImage:image withRadius:20 tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
            }];
        }];
        
       
        
        [JustGivingNetworkInterface getDonationsForCharityWithId:PRINCES_TRUST_ID withSuccessBlock:^(NSArray *donations) {
            self.donations = donations;
            [self.donationsTableView reloadData];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"Failed to load donations");
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.loadingView.alpha = 0;
        }];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"Failed to load charity");
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Donation *donation = self.donations[indexPath.row];
    DonationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DonationTableViewCell"];
    cell.donaterNameLabel.text = donation.userName;
    cell.donateDateLabel.text = donation.date;
    
    cell.donaterImageView.layer.cornerRadius = cell.donaterImageView.frame.size.width / 2;
    cell.donaterImageView.layer.masksToBounds = YES;
    [cell.donaterImageView sd_setImageWithURL:[NSURL URLWithString:donation.userImageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.messageTextView.text = donation.message;
    
    cell.donationPriceLabel.text = donation.amount;
    cell.giftAidLabel.text = donation.giftAid;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.donations.count;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 20 && !self.charityLogoIsBlurred) {
        self.charityLogoIsBlurred = YES;
        //[UIView animateWithDuration:0.5 animations:^{
            [UIView transitionWithView:self.charityIconImageView
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.charityIconImageView.image = self.blurredLogo;
                            } completion:nil];
       // }];
    } else if (scrollView.contentOffset.y < 20 && self.charityLogoIsBlurred) {
        self.charityLogoIsBlurred = NO;
        //[UIView animateWithDuration:0.5 animations:^{
            [UIView transitionWithView:self.charityIconImageView
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.charityIconImageView.image = self.originalLogo;
                            } completion:nil];
      //  }];
    }
}

#pragma mark - Button Interactions

- (IBAction)donateButtonSelected:(id)sender
{
    [PaymentHandler sharedInstance].delegate = self;
    [[PaymentHandler sharedInstance] fetchClientTokenWithResponse:^(BOOL success) {
        if (success) {
            [self presentViewController:[[PaymentHandler sharedInstance] dropInViewController] animated:YES completion:NULL];
        }
    }];
}

#pragma mark - PaymentHandler

- (void)paymentProcessComplete
{
    [self dismissViewControllerAnimated:[[PaymentHandler sharedInstance] dropInViewController] completion:^{
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThanksViewController"];
        
        //[navVC pushViewController:viewController animated:YES];
        [self presentViewController:viewController animated:YES completion:NULL];
    }];
}


@end
