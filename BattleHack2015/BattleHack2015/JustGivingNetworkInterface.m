
//
//  JustGivingNetworkInterface.m
//  BattleHack2015
//
//  Created by george mcdonnell on 25/04/2015.
//  Copyright (c) 2015 Team George & Ollie. All rights reserved.
//

#import "JustGivingNetworkInterface.h"
#import "Donation.h"

NSString *baseURL = @"https://api.justgiving.com/c314e457/v1/";

@implementation JustGivingNetworkInterface

+ (void)getCharityWithId:(NSString *)charityID withSuccessBlock:(void (^)(Charity *))success withFailureBlock:(void (^)(NSError *))failure
{
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@charity/%@", baseURL, charityID];
    NSURL *endPointURL = [NSURL URLWithString:apiEndpoint];
    
    NSMutableURLRequest *requestForCharity = [NSMutableURLRequest requestWithURL:endPointURL];
    
    [requestForCharity setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:requestForCharity queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *localError;
            NSDictionary *charityData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            NSString *charityName = charityData[@"name"];
            NSString *shortDescription = [NSString stringWithFormat:@"We %@ to %@", charityData[@"impactStatementWhat"], charityData[@"impactStatementWhy"]];
            NSString *longDescription = charityData[@"description"];
            NSString *logoURL = charityData[@"logoAbsoluteUrl"];
            
            Charity *charity = [[Charity alloc] initWithCharityID:charityID name:charityName shortDescription:shortDescription longDescription:longDescription logoURL:logoURL];
            
            success(charity);
        } else {
            failure(connectionError);
        }
    }];
}

+ (void)getDonationsForCharityWithId:(NSString *)charityID withSuccessBlock:(void (^)(NSArray *donations))success withFailureBlock:(void (^)(NSError *error))failure
{
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@charity/%@/donations", baseURL, charityID];
    
    NSURL *endPointURL = [NSURL URLWithString:apiEndpoint];
    
    NSMutableURLRequest *requestForDonations = [NSMutableURLRequest requestWithURL:endPointURL];
    
    [requestForDonations setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:requestForDonations queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *localError;
            NSDictionary *charityDonations = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError][@"donations"];
            NSMutableArray *donations = [[NSMutableArray alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd MMMM yyyy";
            
            for (NSDictionary *charityDonation in charityDonations) {
                NSString *userName = charityDonation[@"donorDisplayName"];
                NSString *userImageURL = charityDonation[@"imageUrl"];
                NSString *message = charityDonation[@"message"];
    
                NSString *amount;
                NSString *giftAid;
                if ([charityDonation[@"amount"] isKindOfClass:[NSNumber class]]) {
                    BOOL isDecimal = [[charityDonation[@"amount"] stringValue] containsString:@"."];
                    amount = (isDecimal) ? [NSString stringWithFormat:@"£%@",[charityDonation[@"amount"] stringValue]]
                    : [NSString stringWithFormat:@"£%@.00",[charityDonation[@"amount"] stringValue]];
                    giftAid = [NSString stringWithFormat:@"Gift Aid: £%@",[charityDonation[@"estimatedTaxReclaim"] stringValue]];

                }
                
                NSString *epochDate = [charityDonation[@"donationDate"] substringWithRange:NSMakeRange(6, 10)];
                NSTimeInterval epochTimeInterval = [epochDate doubleValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:epochTimeInterval];
                NSString *formattedDate = [dateFormatter stringFromDate:date];
                
                NSMutableString *tempDate = [[NSMutableString alloc]initWithString:formattedDate];
                NSRange firstSpaceRange = [tempDate rangeOfString:@" "];
                NSRange dayRange = NSMakeRange(0, firstSpaceRange.location);
                
                NSInteger day = [[tempDate substringWithRange:dayRange] integerValue];
                switch (day) {
                    case 1:
                    case 21:
                    case 31:
                        [tempDate insertString:@"st" atIndex:dayRange.location + dayRange.length];
                        break;
                    case 2:
                    case 22:
                        [tempDate insertString:@"nd" atIndex:dayRange.location + dayRange.length];
                        break;
                    case 3:
                    case 23:
                        [tempDate insertString:@"rd" atIndex:dayRange.location + dayRange.length];
                        break;
                    default:
                        [tempDate insertString:@"th" atIndex:dayRange.location + dayRange.length];
                        break;
                }
                
                formattedDate = tempDate;
                
                Donation *donation = [[Donation alloc] initWithUsername:userName userImageURL:userImageURL date:formattedDate message:message amount:amount giftAid:giftAid];
                [donations addObject:donation];
            }
            
            success(donations);
        } else {
            failure(connectionError);
        }
    }];
}

+ (void)getSuggestedCharitiesWithGroupCategory:(NSString *)groupCategory withSucessBlock:(void (^)(NSArray *))success withFailureBlock:(void (^)(NSError *))failure
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@charity/search?q=%@", baseURL, groupCategory]]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (success) {
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *jsonCharities = json[@"charitySearchResults"];
            
            NSMutableArray *parsedCharities = [[NSMutableArray alloc] init];
            
            for (NSDictionary *charityData in jsonCharities) {
                NSString *charityID = charityData[@"charityId"];
                NSString *charityName = charityData[@"name"];
                NSString *shortDescription = [NSString stringWithFormat:@"We %@ to %@", charityData[@"impactStatementWhat"], charityData[@"impactStatementWhy"]];
                NSString *longDescription = charityData[@"description"];
                NSString *logoURL = charityData[@"logoAbsoluteUrl"];
                NSString *category = charityData[@"categories"][0];
                [[NSUserDefaults standardUserDefaults] setObject:category forKey:@"Category"];
                
                Charity *charity = [[Charity alloc] initWithCharityID:charityID name:charityName shortDescription:shortDescription longDescription:longDescription logoURL:logoURL];
                
                [parsedCharities addObject:charity];
                
                if ([charityData isEqual:[jsonCharities lastObject]]) {
                    success(parsedCharities);
                }
            }
        } else {
            failure(nil);
        }
        
    }];
}

@end
