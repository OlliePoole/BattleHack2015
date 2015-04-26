//
//  AppDelegate.m
//  BattleHack2015
//
//  Created by Oliver Poole on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "AppDelegate.h"
#import "EstimoteSDK.h"

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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://vast-crag-4177.herokuapp.com/insert"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *payload = @"{\"id\" : \"1\", \"lat\" : \"51.5114602\", \"long\" : \"-0.0822526\", \"time\" : \"1430031000\", \"bucket\" : \"002\", \"amount\" : \"3.00\"}";
    
  //  NSString *body = [NSString stringWithFormat:@"id=%@&lat=%@&long=]
    
    [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    }];
    
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
