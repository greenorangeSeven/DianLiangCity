//
//  TTPlaceHolderTextView.h
//  EWalking
//
//  Created by Ma Jianglin on 9/15/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
