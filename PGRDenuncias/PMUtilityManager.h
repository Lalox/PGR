//
//  PMUtilityManager.h
//  PGRDenuncias
//
//  Created by Planet Media on 18/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMUtilityManager : NSObject

+(NSURL *)getPathWithName: (NSString*)name;
+(void) getErrorInfoWithError: (NSError*) error inMethod: (SEL)method inClass: (NSString *)classStr;

@end
