//
//  FieldDetailViewController.m
//  DelightCity
//
//  Created by Jia Xiaochao on 14-7-3.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "FieldDetailViewController.h"
#import "BackButton.h"
#import "MWPhotoBrowser.h"
#import "ImgCell.h"

@interface FieldDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
{
    UserInfo *userInfo;
}
@property (nonatomic) BOOL isCollect;
@end

@implementation FieldDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItems = [BackButton rightButton:self action:@selector(pinglunAction:) title:@"评论"];
    self.navigationItem.leftBarButtonItems = [BackButton leftButton:self action:@selector(backAction:) image:@"back_bg"];
    self.imgCollectionView.dataSource = self;
    self.imgCollectionView.delegate = self;
    [self.imgCollectionView registerClass:[ImgCell class] forCellWithReuseIdentifier:@"ImgCell"];
    userInfo = [[UserModel Instance] getUserInfo];
    samplePopupViewController = [[BBSReplyView alloc] initWithNibName:@"BBSReplyView" bundle:nil];
    samplePopupViewController.parentView = self;
    samplePopupViewController.type = [NSNumber numberWithInt:2];
    samplePopupViewController.noticStr = @"FieldDetailUpdate";
    
    [self initBBS];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initBBS) name:@"FieldDetailUpdate" object:nil];
}

- (void)initBBS
{
    //内容
    self.contentLb.text = self.bbs.content;
    CGRect contentLb = self.contentLb.frame;
    self.contentLb.frame = CGRectMake(contentLb.origin.x, contentLb.origin.y, contentLb.size.width, self.bbs.contentHeight -10);
    if ([self.bbs.thumb count] > 0)
    {
        self.imgCollectionView.hidden = NO;
        double size = self.bbs.thumb.count / 3;
        if(size < 1)
            size = 0;
        int thumbHeight = 62;
        thumbHeight += size * 62;
        self.imgCollectionView.frame = CGRectMake(self.imgCollectionView.frame.origin.x, self.contentLb.frame.origin.y + self.contentLb.frame.size.height, self.imgCollectionView.frame.size.width, thumbHeight);
        
        self.timeView.frame = CGRectMake(self.timeView.frame .origin.x, self.imgCollectionView.frame.origin.y + self.imgCollectionView.frame.size.height + 2, self.timeView.frame.size.width, self.timeView.frame.size.height);
        
        self.imgArray = self.bbs.thumb;
        //[self.imgCollectionView reloadData];
    }
    else
    {
        self.imgCollectionView.hidden = YES;
        self.timeView.frame = CGRectMake(self.timeView.frame .origin.x, self.contentLb.frame.origin.y + self.contentLb.frame.size.height + 2, self.timeView.frame.size.width, self.timeView.frame.size.height);
    }
    
    //评论
    self.replyLb.attributedText = self.bbs.reply_str;
    NSString *replysStr = [NSString stringWithString:self.bbs.reply_str.string];
    if (replysStr != nil && [replysStr isEqualToString:@""] == NO)
    {
        self.replyLb.frame = CGRectMake(self.replyLb.frame .origin.x, self.replyLb.frame.origin.y, self.replyLb.frame.size.width, self.bbs.replyHeight -10);
        self.replyView.frame = CGRectMake(self.replyView.frame .origin.x, self.timeView.frame.origin.y + self.timeView.frame.size.height + 2, self.replyView.frame.size.width, self.replyLb.frame.size.height);
        self.replyView.hidden = NO;
    }
    else
    {
        self.replyView.hidden = YES;
    }
    
    //时间
    self.timeLb.text = self.bbs.timeStr;
    NSString *nickname = @"匿名用户";
    if (self.bbs.nickname != nil && [self.bbs.nickname isEqualToString:@""] == NO)
    {
        nickname = self.bbs.nickname;
    }
    else if (self.bbs.nickname != nil && [self.bbs.name isEqualToString:@""] == NO)
    {
        nickname = self.bbs.name;
    }
    
    //昵称
    self.nickNameLb.text = nickname;
    
    NSString *userid = [NSString stringWithFormat:@"%i",userInfo.id];
    
    //删除按钮
    if (self.bbs.customer_id != nil && [userid isEqualToString:self.bbs.customer_id])
    {
        self.delBtn.hidden = NO;
    }
    else
    {
        self.delBtn.hidden = YES;
    }
    
    //头像
    if (self.bbs.imgData)
    {
        self.facePic.image = self.bbs.imgData;
    }
    else
    {
        if ([self.bbs.avatar isEqualToString:@""])
        {
            self.bbs.imgData = [UIImage imageNamed:@"userface"];
        }
        else
        {
            NSData * imageData = [_iconCache getImage:[TQImageCache parseUrlForCacheName:self.bbs.avatar]];
            if (imageData)
            {
                self.bbs.imgData = [UIImage imageWithData:imageData];
                self.facePic.image = self.bbs.imgData;
            }
            else
            {
                
            }
        }
    }
    
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.replyView.frame.origin.y + self.replyView.frame.size.height);
}

- (void)pinglunAction:(id)sender
{
    samplePopupViewController.bbs = self.bbs;
    [self presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
    }];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 中间我的小区列表显示函数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCell" forIndexPath:indexPath];
    if (!cell)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ImgCell" owner:self options:nil];
        for (NSObject *o in objects)
        {
            if ([o isKindOfClass:[ImgCell class]])
            {
                cell = (ImgCell *)o;
                break;
            }
        }
    }
    NSString *imgURL = [self.imgArray objectAtIndex:[indexPath row]];
    
    cell.imgView.tag = indexPath.row;
    [cell setImg:imgURL];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 50);
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
    //    if (self.imgArray && [self.imgArray count] > 0)
    //    {
    //        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    //        browser.displayActionButton = YES;
    //        self.navigationController.navigationBar.hidden = NO;
    //        [self.navigationController pushViewController:browser animated:YES];
    //    }
}

//MWPhotoBrowserDelegate委托事件
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imgArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.imgArray.count)
        return [self.imgArray objectAtIndex:index];
    return nil;
}

@end
