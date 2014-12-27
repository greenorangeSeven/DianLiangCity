//
//  TTValidator.m
//  TravelGuide
//
//  Created by Ma Jianglin on 12/16/12.
//  Copyright (c) 2012 Ma Jianglin. All rights reserved.
//

#import "TTValidator.h"

@implementation TTValidator

+ (BOOL) isValidEmailAddress:(NSString*)candidate
{
    if (candidate == nil || candidate.length == 0)
    {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) isValidMobileNumber:(NSString*)string
{
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypePhoneNumber
                                                               error:&error];
    NSUInteger numberOfMatches = [detector numberOfMatchesInString:string
                                                           options:0
                                                             range:NSMakeRange(0, [string length])];
    return numberOfMatches > 0;
}

@end
