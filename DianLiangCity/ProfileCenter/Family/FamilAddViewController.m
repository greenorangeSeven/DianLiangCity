//
//  FamilAddViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-8.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "FamilAddViewController.h"

@interface FamilAddViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UserModel *userModel;
    int cid;
    NSString *relation;
    NSString *commTitle;
}

@property (nonatomic) NSArray *relationArray;
@property (nonatomic) NSMutableArray *commArray;

@property (nonatomic, strong) UIPickerView *relationPicker;
@property (nonatomic, strong) UIPickerView *comPicker;

@end

@implementation FamilAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    userModel = [UserModel Instance];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitAction:) title:@"提交"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.relationArray = @[@"丈夫", @"妻子", @"儿子", @"女儿", @"姐妹", @"租客"];
    
    self.relationPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.relationPicker.showsSelectionIndicator = YES;
    self.relationPicker.delegate = self;
    self.relationPicker.dataSource = self;
    self.relationTextField.inputView = self.relationPicker;
    self.relationPicker.tag = 111;
    
    self.comPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.comPicker.showsSelectionIndicator = YES;
    self.comPicker.delegate = self;
    self.comPicker.dataSource = self;
    self.commTextField.inputView = self.comPicker;
    self.comPicker.tag = 112;
}


-(void)submitAction:(id)sender
{
    NSString *nameStr = self.nameTextField.text;
    NSString *phoneStr = self.phoneNumberTextField.text;
    NSString *relationStr = self.relationTextField.text;
    NSString *commStr = self.commTextField.text;
    
    if (nameStr.length <= 0) {
        [self showToast:@"请输入姓名"];
        return;
    }
    if (phoneStr.length != 11)
    {
        [self showToast:@"请输入手机号"];
        return;
    }
    if (relationStr.length <= 0) {
        [self showToast:@"请选择与户主关系"];
        return;
    }
    if (commStr.length <= 0) {
        [self showToast:@"请选择所在社区"];
        return;
    }
    [self showToast:@"邀请码已发送"];
    if (userModel.isNetworkRunning && userModel.isLogin)
    {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",api_base_url,api_add_family_member];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setPostValue:api_key forKey:@"APPKey"];
        [request setPostValue:nameStr forKey:@"name"];
        [request setPostValue:phoneStr forKey:@"tel"];
        [request setPostValue:relationStr forKey:@"relations"];
        [request setPostValue:[NSString stringWithFormat:@"%i",cid] forKey:@"cid"];
        [request setPostValue:[NSString stringWithFormat:@"%i",[userModel getUserInfo].id] forKey:@"userid"];
        [request setPostValue:[NSString stringWithFormat:@"%i",[Tool getRandomNumber:100000 to:999999]] forKey:@"invite_code"];

        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestOK:)];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [request startAsynchronous];
        [Tool showHUD:@"正在加载" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
   [Tool showCustomHUD:@"成员添加失败,请重试" andView:self.view andImage:nil andAfterDelay:1.5];
}

- (void)requestOK:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:YES];
    }
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"添加成功" andView:self.view andImage:nil andAfterDelay:1.2];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"成员添加失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
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
    if(relation.length > 0)
    {
        self.relationTextField.text = relation;
    }
    else
    {
        if([self.relationTextField isFirstResponder])
        {
            relation = [self.relationArray objectAtIndex:0];
            self.relationTextField.text = relation;
        }
    }
    if(commTitle.length > 0)
    {
        self.commTextField.text = commTitle;
    }
    else
    {
        if([self.commTextField isFirstResponder])
        {
            Community *comm = [self.commArray objectAtIndex:0];
            cid = comm.id;
            commTitle = comm.title;
             self.commTextField.text = commTitle;
        }
    }
    
    [self.relationTextField resignFirstResponder];
    [self.commTextField resignFirstResponder];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Picker Data Source Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.relationPicker)
    {
        return [self.relationArray count];
    }
    else if (pickerView == self.comPicker)
    {
        
        return [userModel.validateComms count];
    }
    return 0;
}

#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.relationPicker)
    {
        NSString *relationStr = [self.relationArray objectAtIndex:row];
        return relationStr;
    }
    else if (pickerView == self.comPicker)
    {
        Community *comm = [userModel.validateComms objectAtIndex:row];
        return comm.title;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (thePickerView == self.relationPicker)
    {
        relation = [self.relationArray objectAtIndex:row];
    }
    else if (thePickerView == self.comPicker)
    {
        Community *comm = [userModel.validateComms objectAtIndex:row];
        cid = comm.id;
        commTitle = comm.title;
    }
}

@end
