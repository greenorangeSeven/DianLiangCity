//
//  TTPageControl.m
//  CustomUIKit
//
//  Created by Ma Jianglin on 11-6-27.
//  Copyright 2011 Totem. All rights reserved.
//

#import "TTPageControl.h"


@interface TTPageControl (Private)
- (void) updateDots;
@end


@implementation TTPageControl

/** override to update dots */
- (void) setCurrentPage:(NSInteger)currentPage
{
	[super setCurrentPage:currentPage];
	
	// update dot views
	[self updateDots];
}

/** override to update dots */
- (void) updateCurrentPageDisplay
{
	[super updateCurrentPageDisplay];
	
	// update dot views
	[self updateDots];
}

/** Override setImageNormal */
- (void) setImageNormal:(UIImage*)image
{
	_imageNormal = image;
	
	// update dot views
	[self updateDots];
}

/** Override setImageCurrent */
- (void) setImageCurrent:(UIImage*)image
{
	_imageCurrent = image;
	
	// update dot views
	[self updateDots];
}

/** Override to fix when dots are directly clicked */
- (void) endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event 
{
	[super endTrackingWithTouch:touch withEvent:event];
	
	[self updateDots];
}

//#pragma mark - (Private)
//
//- (void) updateDots
//{
//	if(mImageCurrent || mImageNormal)
//	{
//		// Get subviews
//		NSArray* dotViews = self.subviews;
//		for(int i = 0; i < dotViews.count; ++i)
//		{
//			UIImageView* dot = [dotViews objectAtIndex:i];
//			// Set image
//			dot.image = (i == self.currentPage) ? mImageCurrent : mImageNormal;
//		}
//	}
//}


/** Override to fix calculation of optimal size */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	CGSize size = CGSizeMake((_imageCurrent.size.width/2 * pageCount) + (10.0f * (pageCount - 1)), 36.0f);
	return size;
}

#pragma mark – (Private)
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) dot.image = _imageCurrent;
        else dot.image = _imageNormal;
    }
}

- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    return dot;
}

@end
