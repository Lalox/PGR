//
//  PMUtilityManager.m
//  PGRDenuncias
//
//  Created by Planet Media on 18/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMUtilityManager.h"

@implementation PMUtilityManager

+(NSURL *) getPathWithName: (NSString*)name{
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               name,
                               nil];
    return [NSURL fileURLWithPathComponents:pathComponents];
}

+(void) getErrorInfoWithError: (NSError*) error inMethod: (SEL)method inClass: (NSString *)classStr{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:(@"Error") value:@"Error" table:nil] message:[NSString stringWithFormat:@"%@ (%@): %@", classStr, NSStringFromSelector(method),error.description]  delegate:self cancelButtonTitle:[[NSBundle mainBundle] localizedStringForKey:(@"OK") value:@"Aceptar" table:nil] otherButtonTitles:nil];
    [errorAlert show];
}

+(BOOL) isThereInternetAccess{
    Reachability *hostReach = [Reachability reachabilityWithHostName: @"www.google.com"];
    
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSLog(@"WWAN/3G");
            return YES;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"WIFI");
            return YES;
            break;
        }
        case NotReachable:
        {
            NSLog(@"NO Internet");
            return NO;
            break;
        }
    }
    return YES;
}

@end
