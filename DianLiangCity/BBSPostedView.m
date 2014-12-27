//
//  BBSPostedView.m
//  NanNIng
//
//  Created by Seven on 14-9-14.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BBSPostedView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "VPImageCropperViewController.h"
#import "RepairImgCell.h"
#import "BackButton.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface BBSPostedView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>
{
    NSMutableArray *imageArray;
}
@end

@implementation BBSPostedView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"论坛发帖";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction) image:@"back_bg"];
        self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(submitBBS) title:@"发布"];
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.imgCollectionView.dataSource = self;
    self.imgCollectionView.delegate = self;
    [self.imgCollectionView registerClass:[RepairImgCell class] forCellWithReuseIdentifier:@"RepairImgCell"];
    imageArray = [NSMutableArray array];
    [imageArray addObject:[UIImage imageNamed:@"添加社区"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImg:) name:@"deleteImg" object:nil];
    [self reSizeCollectionView];
}
- (void)submitBBS
{
    [self.view resignFirstResponder];
    NSString *contentStr = self.contentTextField.text;
    if(contentStr.length <= 0)
    {
        [Tool showCustomHUD:@"请输入内容" andView:self.view andImage:nil andAfterDelay:1.2f];
        return;
    }
    if([[UserModel Instance] isNetworkRunning])
    {
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        NSString *url = [NSString stringWithFormat:@"%@%@", api_base_url, api_add_shequgj_subject];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setPostValue:api_key forKey:@"APPKey"];
        [request setPostValue:contentStr forKey:@"content"];
        [request setPostValue:[NSString stringWithFormat:@"%i",self.commData.id] forKey:@"cid"];
        [request setPostValue:[NSString stringWithFormat:@"%i",userInfo.id] forKey:@"userid"];
        
        if (imageArray != nil && imageArray.count > 1)
        {
            for(int i = 1; i < imageArray.count; ++i)
            {
                UIImage *picimage = [imageArray objectAtIndex:i];
                [request addData:UIImageJPEGRepresentation(picimage, 0.75f) withFileName:[NSString stringWithFormat:@"img%i.jpg",i] andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"thumb%i",i]];
            }
        }
        request.delegate = self;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestSubmit:)];
        [request startAsynchronous];
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"正在发布" andView:self.view andHUD:request.hud];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"帖子发布失败" andView:self.view andImage:nil andAfterDelay:1.2];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *codedDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSNumber *status = [codedDic objectForKey:@"status"];
    if(status.intValue == 1)
    {
        [Tool showCustomHUD:@"发布成功" andView:self.view andImage:nil andAfterDelay:1.2];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [Tool showCustomHUD:@"帖子发布失败,请重试" andView:self.view andImage:nil andAfterDelay:1.2];
    }
}

- (void)reSizeCollectionView
{
    //这里根据小区个数自动调整高度
    int size = (imageArray.count)/3;
    
    int height = size * 70 + 120;
    
    float x = self.imgCollectionView.frame.origin.x;
    float y = self.imgCollectionView.frame.origin.y;
    float width = self.imgCollectionView.frame.size.width;
    
    //调整面板高度
    self.imgCollectionView.frame = CGRectMake(x, y, width, height);
    
    float xx = self.imgCollectionView.frame.origin.x;
    float yy = self.imgCollectionView.frame.origin.y;
    float wwidth = self.imgCollectionView.frame.size.width;
    
    //调整网格布局高度
    self.imgCollectionView.frame = CGRectMake(xx, yy, wwidth, height-20);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.imgCollectionView.frame.origin.y + self.imgCollectionView.frame.size.height + 50);
}

//删除图片(notification,在RepairImgCell中的deleteBtn触发)
- (void)deleteImg:(NSNotification *) notification
{
    NSDictionary *dict = [notification userInfo];
    NSNumber *number = [dict objectForKey:@"index"];
    int index = number.intValue;
    if(imageArray && index < imageArray.count)
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"是否删除该图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alerView.tag = index;
        [alerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果是点击的删除按钮则删除图片
    if(buttonIndex == 1)
    {
        [imageArray removeObjectAtIndex:alertView.tag];
        [self.imgCollectionView reloadData];
    }
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)submitAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RepairListViewControllerReloadTableView" object:@"add"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 图片集合
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RepairImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RepairImgCell" forIndexPath:indexPath];
    if (!cell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RepairImgCell" owner:self options:nil];
        for (NSObject *o in objects)
        {
            if ([o isKindOfClass:[RepairImgCell class]])
            {
                cell = (RepairImgCell *)o;
                break;
            }
        }
    }
    UIImage *image = [imageArray objectAtIndex:[indexPath row]];
    [cell bindImg:(UIImage *)image andIndex:indexPath.row];
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85, 85);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int indexRow = [indexPath row];
    if(indexRow == 0)
    {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        choiceSheet.tag = 0;
        [choiceSheet showInView:self.view];
    }
}

#pragma mark - 选择图片相关
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [imageArray addObject:editedImage];
        [self.imgCollectionView reloadData];
        [self reSizeCollectionView];
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

@end
