//
//  HouseViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-6-26.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "HouseViewController.h"
#import "ChoiseIdentityViewController.h"
#import "CArea.h"
#import "CBuild.h"
#import "CUnit.h"
#import "HouseNumber.h"
#import "BackButton.h"
#import "NSString+STRegex.h"
#import "LoginViewController.h"

@interface HouseViewController ()
{
    int selectAreaIndex;
    int selectbuildIndex;
    int selectUnitIndex;
    int selectdoorIndex;
}
@property (nonatomic, strong) NSArray *fieldArray;

@property (nonatomic, strong) UIPickerView *areaPicker;
@property (nonatomic, strong) UIPickerView *buildingPicker;
@property (nonatomic, strong) UIPickerView *unitPicker;
@property (nonatomic, strong) UIPickerView *doorPicker;

@end

@implementation HouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectAreaIndex = -1;
    selectbuildIndex = -1;
    selectUnitIndex = -1;
    selectdoorIndex = -1;
    
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(verifyAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction) image:@"back_bg"];
    self.commNameTitle.text = self.selectComm.title;
    self.fieldArray = @[self.nameField, self.phoneField, self.idCardField, self.areaField, self.unitField, self.buildField,self.doorField];
    self.areaPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.areaPicker.showsSelectionIndicator = YES;
	self.areaPicker.delegate = self;
	self.areaPicker.dataSource = self;
    self.areaField.inputView = self.areaPicker;
    self.areaField.tag = 111;
    
    self.buildingPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.buildingPicker.showsSelectionIndicator = YES;
	self.buildingPicker.delegate = self;
	self.buildingPicker.dataSource = self;
    self.buildField.inputView = self.buildingPicker;
    self.buildField.tag = 112;
    
    self.unitPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.unitPicker.showsSelectionIndicator = YES;
	self.unitPicker.delegate = self;
	self.unitPicker.dataSource = self;
    self.unitField.inputView = self.unitPicker;
    self.unitField.tag = 113;
    
    self.doorPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.doorPicker.showsSelectionIndicator = YES;
	self.doorPicker.delegate = self;
	self.doorPicker.dataSource = self;
    self.doorField.inputView = self.doorPicker;
    self.doorField.tag = 114;
}
- (void)backAction
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)verifyAction:(id)sender
{
    UserModel *userMode = [UserModel Instance];
    //判断是否已经登录
    if([userMode isLogin])
    {
        [self doValidateComm];
    }
    else
    {
        [Tool showCustomHUD:@"请先登录" andView:self.view andImage:nil andAfterDelay:1.2];
        LoginViewController *manager = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        manager.isValidated = true;
        [self.navigationController pushViewController:manager animated:YES];
    }
}

- (void)doValidateComm
{
    UserInfo *info = [[UserModel Instance] getUserInfo];
    NSString *nameStr = self.nameField.text;
    NSString *phoneStr = self.phoneField.text;
    NSString *idCardStr = self.idCardField.text;
    NSString *areStr = self.areaField.text;
    NSString *buildStr = self.buildField.text;
    NSString *unitStr = self.unitField.text;
    NSString *doorStr = self.doorField.text;
    
    if(nameStr.length <= 0)
    {
        [Tool showCustomHUD:@"请输入姓名" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(areStr.length <= 0)
    {
        [Tool showCustomHUD:@"请选择区域" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(buildStr.length <= 0)
    {
        [Tool showCustomHUD:@"请选择楼栋" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(unitStr.length <= 0)
    {
        [Tool showCustomHUD:@"请选择单元" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(doorStr.length <= 0)
    {
        [Tool showCustomHUD:@"请选择门牌号" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(![phoneStr isValidPhoneNum])
    {
        [Tool showCustomHUD:@"请输入正确的手机号码" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    if(idCardStr.length < 4)
    {
        [Tool showCustomHUD:@"请输入身份证后4位" andView:self.view andImage:nil andAfterDelay:1.5];
        return;
    }
    NSString *regUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_valid];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:regUrl]];
    
    [request setUseCookiePersistence:NO];
    [request setPostValue:api_key forKey:@"APPKey"];
    //1代表户主认证
    [request setPostValue:@"1" forKey:@"pro"];
    [request setPostValue:[NSString stringWithFormat:@"%i",self.selectComm.id] forKey:@"cid"];
    [request setPostValue:nameStr forKey:@"name"];
    [request setPostValue:phoneStr forKey:@"tel"];
    [request setPostValue:idCardStr forKey:@"card_id"];
    [request setPostValue:areStr forKey:@"area"];
    [request setPostValue:buildStr forKey:@"build"];
    [request setPostValue:unitStr forKey:@"units"];
    [request setPostValue:doorStr forKey:@"house_number"];
    [request setPostValue:[NSString stringWithFormat:@"%i",info.id] forKey:@"userid"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestOK:)];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [request startAsynchronous];
    [Tool showHUD:@"正在提交认证数据" andView:self.view andHUD:request.hud];
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    UserInfo *info = [[UserModel Instance] getUserInfo];
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSLog(@"the status:%@",request.responseString);
    if([request.responseString isEqualToString:@"success"])
    {
        self.selectComm.customer_pro = 1;
        self.selectComm.areaList = nil;
        EGOCache *cache = [EGOCache globalCache];
        NSString *name = [NSString stringWithFormat:@"mycommunity%i",info.id];
        NSMutableArray *commDatas = (NSMutableArray *)[cache objectForKey:name];
        if(!commDatas && commDatas.count <= 0)
        {
            commDatas = [[NSMutableArray alloc] init];
        }
        for(Community *comm in commDatas)
        {
            if(comm.id == self.selectComm.id && comm.customer_pro==1)
            {
                [Tool showCustomHUD:@"您已经添加了该社区,不能重复添加" andView:self.view andImage:nil andAfterDelay:1.5];
                return;
            }
        }
        [commDatas addObject:self.selectComm];
        [cache setObjectForSync:commDatas forKey:name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyComm" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"认证失败,您可能重复认证了." andView:self.view andImage:nil andAfterDelay:1.5];
    }
}


- (IBAction)backgroundTap:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.idCardField resignFirstResponder];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.inputAccessoryView == nil)
    {
        textField.inputAccessoryView = [self keyboardToolBar:textField.tag];
    }
}

- (UIToolbar *)keyboardToolBar:(int)fieldIndex
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.tag = fieldIndex;
    doneButton.title = @"完成";
    doneButton.style = UIBarButtonItemStyleDone;
    doneButton.action = @selector(doneClicked:);
    doneButton.target = self;

    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    return toolBar;
}

- (void)doneClicked:(UITextField *)sender
{
    if(sender.tag == self.areaField.tag)
    {
        if(self.selectComm.areaList && self.selectComm.areaList.count > 0)
        {
            if(selectAreaIndex == -1)
                selectAreaIndex = 0;
            CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
            self.areaField.text = area.areaName;
            
            self.buildField.text = @"";
            self.unitField.text = @"";
            self.doorField.text = @"";
            selectbuildIndex = -1;
            selectUnitIndex = -1;
            selectdoorIndex = -1;
            [self.buildingPicker reloadAllComponents];
        }
    }
    else if(sender.tag == self.buildField.tag)
    {
        if(selectAreaIndex != -1)
        {
            CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
            if(area.buildList && area.buildList.count > 0)
            {
                if(selectbuildIndex == -1)
                    selectbuildIndex = 0;
                CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
                self.buildField.text = build.buildName;
                self.unitField.text = @"";
                self.doorField.text = @"";
                selectUnitIndex = -1;
                selectdoorIndex = -1;
                [self.unitPicker reloadAllComponents];
                [self.doorPicker reloadAllComponents];
            }
        }
    }
    else if(sender.tag == self.unitField.tag)
    {
        if(selectAreaIndex != -1 && selectbuildIndex != -1)
        {
            CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
            CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
            if(build.uintList && build.uintList.count > 0)
            {
                if(selectUnitIndex == -1)
                    selectUnitIndex = 0;
                CUnit *unit = [build.uintList objectAtIndex:selectUnitIndex];
                self.unitField.text = unit.unitName;
                self.doorField.text = @"";
                selectdoorIndex = -1;
                [self.doorPicker reloadAllComponents];
            }
            
        }
    }
    else if(sender.tag == self.doorField.tag)
    {
        if(selectAreaIndex != -1 && selectbuildIndex != -1 && selectUnitIndex != -1)
        {
            CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
            CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
            CUnit *unit = [build.uintList objectAtIndex:selectUnitIndex];
            if(unit.houseList && unit.houseList.count > 0)
            {
                if(selectdoorIndex == -1)
                    selectdoorIndex = 0;
                HouseNumber *houseNumber = [unit.houseList objectAtIndex:selectdoorIndex];
                self.doorField.text = houseNumber.house_number;
            }
        }
    }
    for (UITextField *field in self.fieldArray)
    {
        [field resignFirstResponder];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.areaPicker)
    {
        return [self.selectComm.areaList count];
    }
    else if (pickerView == self.buildingPicker)
    {
        if(selectAreaIndex == -1)
            return 0;
        CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
        return [area.buildList count];
    }
    else if (pickerView == self.unitPicker)
    {
        if(selectbuildIndex == -1)
            return 0;
        CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
        CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
        return [build.uintList count];
    }
    else if (pickerView == self.doorPicker)
    {
        if(selectUnitIndex == -1)
            return 0;
        CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
        CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
        CUnit *unit = [build.uintList objectAtIndex:selectUnitIndex];
        return [unit.houseList count];
    }

    return 0;
}

#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.areaPicker)
    {
        CArea *area = [self.selectComm.areaList objectAtIndex:row];
        return area.areaName;
    }
    else if (pickerView == self.buildingPicker)
    {
        CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
        CBuild *build = [area.buildList objectAtIndex:row];
        return build.buildName;
    }
    else if (pickerView == self.unitPicker)
    {
        CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
        CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
        CUnit *unit = [build.uintList objectAtIndex:row];
        return unit.unitName;
    }
    else if (pickerView == self.doorPicker)
    {
        CArea *area = [self.selectComm.areaList objectAtIndex:selectAreaIndex];
        CBuild *build = [area.buildList objectAtIndex:selectbuildIndex];
        CUnit *unit = [build.uintList objectAtIndex:selectUnitIndex];
        HouseNumber *houseNumber = [unit.houseList objectAtIndex:row];
        return houseNumber.house_number;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (thePickerView == self.areaPicker)
    {
        selectAreaIndex = row;
    }
    else if (thePickerView == self.buildingPicker)
    {
        if(selectAreaIndex != -1)
        {
            selectbuildIndex = row;
        }
    }
    else if (thePickerView == self.unitPicker)
    {
        if(selectAreaIndex != -1 && selectbuildIndex != -1)
        {
            selectUnitIndex = row;
        }
    }
    else if (thePickerView == self.doorPicker)
    {
        if(selectAreaIndex != -1 && selectbuildIndex != -1 && selectUnitIndex != -1)
        {
            selectdoorIndex = row;
        }
    }
}

@end
