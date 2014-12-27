//
//  TTPickerView.h
//  TravelGuide
//
//  Created by ZhangChuntao on 12/28/12.
//  Copyright (c) 2012 Ma Jianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTPickerViewDataSource;
@protocol TTPickerViewDelegate;

@interface TTPickerView: UIView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) int numberOfComponents;  //选择控件由多少个部分组成，默认是1
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@property(nonatomic,assign) id<TTPickerViewDataSource>dataSource;
@property(nonatomic,assign) id<TTPickerViewDelegate>delegate;

- (void)dismissPopoverAnimated:(BOOL)animated;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;

@end




@protocol TTPickerViewDataSource<NSObject>

@required
- (NSInteger)numberOfSectionsInPickerView:(TTPickerView*)pickerView;
- (NSString*)pickerView:(TTPickerView*)pickerView titleForSection:(NSInteger)section;

@optional
- (NSString*)pickerView:(TTPickerView*)pickerView iconForSection:(NSInteger)section;
- (NSInteger)pickerView:(TTPickerView*)pickerView numberOfRowsInSection:(NSInteger)section;
- (NSString*)pickerView:(TTPickerView*)pickerView titleForRow:(NSInteger)row inSection:(NSInteger)section;

@end



@protocol TTPickerViewDelegate<NSObject>
@optional

- (void)pickerView:(TTPickerView *)pickerView didSelectAtIndexPath:(NSIndexPath*)indexPath;

@end

