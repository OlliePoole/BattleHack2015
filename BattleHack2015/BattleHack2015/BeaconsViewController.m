//
//  ESTProximityDemoVC.m
//  Examples
//
//  Created by Grzegorz Krukiewicz-Gacek on 17.03.2014.
//  Copyright (c) 2014 Estimote. All rights reserved.
//

#import "BeaconsViewController.h"
#import "EstimoteSDK.h"

@interface BeaconsViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) CLBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *zoneLabel;

@property (nonatomic) BOOL sentNotification;

@end

@implementation BeaconsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Proximity Demo";
    
    
    
    /*
     * BeaconManager setup.
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    [self.beaconManager requestAlwaysAuthorization];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                                major:10072
                                                                minor:5050
                                                           identifier:@"RegionIdentifier"];
    
   // self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"D0D3FA86-CA76-45EC-9BD9-6AF46CA7FF172"] identifier:@"Region"];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    [super viewDidDisappear:animated];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0)
    {
        
        CLBeacon *firstBeacon = [beacons firstObject];
        
        NSUUID *uuid = [[NSUUID  alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
        
        for (CLBeacon *beacon in beacons) {
            
            if ([self isUUID:beacon.proximityUUID equalToUUID:uuid]) {
                if (!self.sentNotification) {
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    
                    NSDate *now = [NSDate date];
                    NSDate *dateToFire = [now dateByAddingTimeInterval:1];
                    
                    localNotification.fireDate = dateToFire;
                    localNotification.alertBody = @"Prince's trust collectors near you!";
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    localNotification.applicationIconBadgeNumber = 1; // increment
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    self.sentNotification = YES;
                }
                
                
            }
        }
        
        self.zoneLabel.text     = [self textForProximity:firstBeacon.proximity];
        self.imageView.image    = [self imageForProximity:firstBeacon.proximity];
    }
}

-(BOOL)isUUID:(NSUUID*)uuid1 equalToUUID:(NSUUID*)uuid2
{
    return [uuid1 isEqual:uuid2];
}

#pragma mark -

- (NSString *)textForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return @"Far";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}

- (UIImage *)imageForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return [UIImage imageNamed:@"far_image"];
            break;
        case CLProximityNear:
            return [UIImage imageNamed:@"near_image"];
            break;
        case CLProximityImmediate:
            return [UIImage imageNamed:@"immediate_image"];
            break;
            
        default:
            return [UIImage imageNamed:@"unknown_image"];
            break;
    }
}

@end
