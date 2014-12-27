//
//  TTSystemService.h
//  EBCCard
//
//  Created by Ma Jianglin on 3/21/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSystemService : NSObject

+(TTSystemService*)sharedService;

- (void)openURL:(NSString*)urlString;

- (void)callTelephone:(NSString*)number;

- (void)sendEmailTo:(NSArray*)emailAddresses withSubject:(NSString*)subject andMessageBody:(NSString*)emailBody;

- (void)sendMessageTo:(NSArray*)phoneNumbers withMessageBody:(NSString*)messageBody;

@end
