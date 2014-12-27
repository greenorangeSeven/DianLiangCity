//
//  NSString_Chinese.h
//  TTCommon
//
//  Created by Ma Jianglin on 5/9/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//汉字计数和截断，常用于微博

@interface NSString (Chinese)

//字符串按汉字长度做尾截断
- (NSString*)stringByTruncateTailForChineseCharacterToLength:(NSUInteger)newLength;

//字符串汉字长度，常用于微博计数
- (NSUInteger)lengthForChineseCharacter;

- (BOOL)hasChineseCharacter;

@end
