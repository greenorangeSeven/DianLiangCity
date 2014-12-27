//
//  TTHighlightView.m
//  ReadTV
//
//  Created by Ma Jianglin on 11/7/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTHighlightView.h"


@implementation TTHighlightView

- (void)setHighlightForLocation:(CGPoint)point
{
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view setHighlighted:YES];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView*)view;
            [imageView.layer setOpacity:0.8];
        }
    }
}

- (void)setHighlightDisable
{
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view setHighlighted:NO];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView*)view;
            [imageView.layer setOpacity:1.0];
        }
    }
}

- (void)setNormalState:(BOOL)cancelled
{
    if (!cancelled)
    {
        if ([self.target respondsToSelector:self.action])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
        }
    }
    [self performSelector:@selector(setHighlightDisable) withObject:nil afterDelay:0.1];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
	if ([touch view] == self)
    {
        CGPoint point = [touch locationInView:self];
        [self setHighlightForLocation:point];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if ([touch view] == self)
	{
		CGPoint point = [touch locationInView:self];
        if (!CGRectContainsPoint(self.bounds, point))
        {
            [self setNormalState:YES];
        }
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
	
	if ([touch view] == self)
	{
        CGPoint point = [touch locationInView:self];
        BOOL cancelled = !CGRectContainsPoint(self.bounds, point);
        [self setNormalState:cancelled];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setNormalState:YES];
}

@end
