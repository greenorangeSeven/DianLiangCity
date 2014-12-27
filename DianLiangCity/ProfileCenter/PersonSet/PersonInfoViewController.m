//
//  PersonInfoViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-7.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "BackButton.h"
#include "AppDelegate.h"
#import "NickNameViewController.h"
#import "OwnerCertificationViewController.h"
#import "ChangePasswordViewController.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface PersonInfoViewController ()<UIActionSheetDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>
{
    UIImage *avatorImg;
}

@end

@implementation PersonInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    if(userInfo.nickname.length > 0)
    {
        self.nickNameLabel.text = userInfo.nickname;
    }
    else
    {
        self.nickNameLabel.text = @"暂未设置昵称,点击进行设置";
    }
    
    if(userInfo.avatar.length > 0)
    {
        [self.avatarImageView setPlaceholderImage:[UIImage imageNamed:@"userface"]];
        self.avatarImageView.imageURL = [NSURL URLWithString:userInfo.avatar];
    }
    else
    {
        [self.avatarImageView setImage:[UIImage imageNamed:@"userface"]];
    }
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setNickNameStr:(NSString *)nickNameStr
{
    self.nickNameLabel.text = nickNameStr;
}

-(void)setIdentityStr:(NSString *)identityStr
{
    _identityStr = identityStr;
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 75;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"从手机照片选择", nil];
            [actionSheet showInView:SharedAppDelegate.window];
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
    }
}

- (void)submitAvatar
{
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_upload_avatar];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setPostValue:api_key forKey:@"APPKey"];
    [request setPostValue:userInfo.tel forKey:@"tel"];
    
    [request addData:UIImageJPEGRepresentation(avatorImg, 0.75f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"thumb"];
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在上传头像" andView:self.view andHUD:request.hud];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"头像上传失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSLog(@"the status:%@",request.responseString);
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"上传成功" andView:self.view andImage:nil andAfterDelay:1.2];
        NSString *avatar = [codedDic objectForKey:@"avatar"];
        if(avatar.length > 0)
        {
            UserInfo *userInfo = [[UserModel Instance] getUserInfo];
            userInfo.avatar = avatar;
            [[UserModel Instance] setUserInfo:userInfo];
            self.avatarImageView.imageURL = [NSURL URLWithString:avatar];
        }
    }
    else
    {
        [Tool showCustomHUD:@"上传失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

#pragma mark - 选择图片相关
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        avatorImg = editedImage;
        [self submitAvatar];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0)
    {
        if (buttonIndex == 0)
        {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        } else if (buttonIndex == 1)
        {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable])
            {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark 缩放图片
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    if ([destination isKindOfClass:[NickNameViewController class]])
    {
        [destination setValue:self.nickNameLabel.text forKey:@"nickNameStr"];
    }
    if ([destination isKindOfClass:[ChangePasswordViewController class]])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        if (path.row == 2)
        {
            [destination setValue:@"修改密码" forKey:@"title"];
        }
        else
        {
            [destination setValue:@"修改支付密码" forKey:@"title"];
        }
    }
}

@end
