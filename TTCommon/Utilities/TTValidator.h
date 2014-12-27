//
//  TTValidator.h
//  TravelGuide
//
//  Created by Ma Jianglin on 12/16/12.
//  Copyright (c) 2012 Ma Jianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTValidator : NSObject

+ (BOOL) isValidEmailAddress:(NSString*)str;

+ (BOOL) isValidMobileNumber:(NSString*)str;

@end
