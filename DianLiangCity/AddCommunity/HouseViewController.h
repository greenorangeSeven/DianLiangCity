//
//  HouseViewController.h
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

@interface HouseViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) Community *selectComm;
@property (weak, nonatomic) IBOutlet UILabel *commNameTitle;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *idCardField;

@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *buildField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *doorField;
@property (weak, nonatomic) IBOutlet UIView *areaChoiseView;
@property (weak, nonatomic) IBOutlet UIView *buildChoiseView;
@property (weak, nonatomic) IBOutlet UIView *unitChoiseView;
@property (weak, nonatomic) IBOutlet UIView *cardChoiseView;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
@end
