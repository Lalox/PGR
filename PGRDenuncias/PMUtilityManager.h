//
//  PMUtilityManager.h
//  PGRDenuncias
//
//  Created by Planet Media on 18/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface PMUtilityManager : NSObject

//Get path for a given file name
+(NSURL *)getPathWithName: (NSString*)name;

//Display UIAlertView with error description
+(void) getErrorInfoWithError: (NSError*) error inMethod: (SEL)method inClass: (NSString *)classStr;

//Check internet connection
+(BOOL) isThereInternetAccess;

@end
