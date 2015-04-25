//
//  AppDelegate.m
//  BattleHack2015
//
//  Created by Oliver Poole on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "AppDelegate.h"
#import "EstimoteSDK.h"
#include <stdlib.h>

@interface AppDelegate () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) CLBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic) BOOL sentNotification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [application setStatusBarHidden:YES];

    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    NSArray *epochs = @[@"1459357692",
                        @"1410068506",
                        @"1441366191",
                        @"1459210602",
                        @"1419672200",
                        @"1423887970",
                        @"1398254102",
                        @"1445668844",
                        @"1408527606",
                        @"1450957512",
                        @"1401027672",
                        @"1407936503",
                        @"1451783305",
                        @"1459763935",
                        @"1436451776",
                        @"1420812179",
                        @"1436141944",
                        @"1421984572",
                        @"1424610774",
                        @"1456838851",
                        @"1407984125",
                        @"1450265923",
                        @"1413696596",
                        @"1429374323",
                        @"1418673733",
                        @"1408315867",
                        @"1446225259",
                        @"1441490114",
                        @"1440656089",
                        @"1416994987",
                        @"1398571757",
                        @"1429839308",
                        @"1450902955",
                        @"1407702951",
                        @"1414000476",
                        @"1430578803",
                        @"1458622637",
                        @"1405249875",
                        @"1439636011",
                        @"1443867978",
                        @"1456474581",
                        @"1407108627",
                        @"1438797642",
                        @"1446855826",
                        @"1436579210",
                        @"1458535080",
                        @"1402490296",
                        @"1408288764",
                        @"1419192511",
                        @"1425274885",
                        @"1438707641",
                        @"1459169356"];
    
    NSArray *lats = @[@"51.51368",
                      @"51.510822",
                      @"51.517099",
                      @"51.513576",
                      @"51.507987",
                      @"51.313062"];
    
    NSArray *longs = @[@"-0.089017",
                       @"-0.224487",
                       @"-0.0853041",
                       @"-0.097925",
                       @"-0.096938",
                       @"-0.113246"];
    
    int r = arc4random_uniform(6);
    
    for (NSUInteger x = 0; x < epochs.count; x++) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://vast-crag-4177.herokuapp.com/insert"]];
        [request setHTTPMethod:@"POST"];
        
        NSString *body = [NSString stringWithFormat:@"id=%lu&lat=%@&long=-%@&time=%@&bucket=0%lu&amount=%d", x + 5, lats[r], longs[r], epochs[x], (unsigned long)x, r];
        
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response;
        NSError *error;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    }
    
    
    
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    [self.beaconManager requestAlwaysAuthorization];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                                major:10072
                                                                minor:5050
                                                           identifier:@"RegionIdentifier"];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];


    return YES;
}

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        
        NSUUID *uuid = [[NSUUID  alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
        
        for (CLBeacon *beacon in beacons) {
            
            if ([self isUUID:beacon.proximityUUID equalToUUID:uuid]) {
                if (!self.sentNotification) {
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    
                    NSDate *now = [NSDate date];
                    NSDate *dateToFire = [now dateByAddingTimeInterval:1];
                    
                    localNotification.fireDate = dateToFire;
                    localNotification.alertBody = @"Prince's Trust collectors near you!";
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    localNotification.applicationIconBadgeNumber = 1; // increment
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    self.sentNotification = YES;
                }
            }
        }
    }
}

-(BOOL)isUUID:(NSUUID*)uuid1 equalToUUID:(NSUUID*)uuid2
{
    return [uuid1 isEqual:uuid2];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
