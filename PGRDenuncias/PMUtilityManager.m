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

+(NSString *) getErrorInfoWithError: (NSError*) error inMethod: (SEL)method inClass: (NSString *)classStr{
    return [NSString stringWithFormat:@"%@ (%@): %@", classStr, NSStringFromSelector(method),error.description];
}

@end
