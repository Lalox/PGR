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
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[NSString stringWithFormat:@"%@ (%@): %@", classStr, NSStringFromSelector(method),error.description]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [errorAlert show];
}

@end
