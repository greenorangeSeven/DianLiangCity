//
//  NSString+Chinese.m
//  TTCommon
//
//  Created by Ma Jianglin on 5/9/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "NSString+Chinese.h"

@implementation NSString(Chinese)

- (NSString*)stringByTruncateTailForChineseCharacterToLength:(NSUInteger)newLength
{
    int i, l = 0, a = 0, b = 0;
    unichar c;
    
    int length = self.length;
    for(i = 0; i < length; i++)
    {
        c = [self characterAtIndex:i];

        if(isblank(c))
        {
            b++;
        }
        else if(isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }

        if (i >= newLength)
        {
            int total = l+(int)ceilf((float)(a+b)/2.0);
            if (total > newLength)
            {
                return [self substringToIndex:i];
            }
        }
    }
    
    return self;
}

#define HANZI_START 19968
#define HANZI_COUNT 20902

- (BOOL)hasChineseCharacter
{
    unichar c;
    
    for (int i = 0; i < [self length]; i++)
    {
        c = [self characterAtIndex:i];
        
        if(isblank(c) || isascii(c))
        {
            
        }
        else
        {
            return YES;
        }
        
    }
    
    return NO;
}

- (NSUInteger)lengthForChineseCharacter
{
    int i, length = self.length, l = 0, a = 0, b = 0;
    
    unichar c;
    
    for(i = 0; i < length; i++)
    {
        c = [self characterAtIndex:i];
        
        if(isblank(c))
        {
            b++;
        }
        else if(isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
    }
    
    if( a == 0 && l == 0)
    {
        return 0;
    }
    
    length = l+(int)ceilf((float)(a+b)/2.0);
    
    //    NSLog(@"length=%d",length);
    return length;
}

@end
