//
//  OwnerFieldCell.m
//  DianLiangCity
//
//  Created by mac on 14-12-23.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "OwnerFieldCell.h"
#import "ImgCell.h"

@implementation OwnerFieldCell

- (void)bindData:(BBSModel *)bbsModel
{
    self.summary_label.text = bbsModel.content;
    self.nick_label.text = bbsModel.nickname;
    self.time_label.text = [Tool TimestampToDateStr:bbsModel.timeStr andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
    [self.comment_size_label setTitle:[NSString stringWithFormat:@"%i",bbsModel.reply_list.count] forState:UIControlStateNormal];
    if(bbsModel.thumb && bbsModel.thumb.count > 0)
    {
        self.imgArray = bbsModel.thumb;
        self.img_collection.hidden = NO;
        [self.img_collection reloadData];
        double size = self.imgArray.count / 3;
        if(size < 1)
            size = 0;
        int thumbHeight = 62;
        thumbHeight += size * 62;
        self.img_collection.frame = CGRectMake(self.img_collection.frame.origin.x, self.img_collection.frame.origin.y, self.img_collection.frame.size.width, thumbHeight);
    }
    else
    {
        self.img_collection.frame = CGRectMake(self.img_collection.frame.origin.x, self.img_collection.frame.origin.y, self.img_collection.frame.size.width, 0);
        self.img_collection.hidden = YES;
    }
}

//- (void) updateConstraints
//{
//    if(self.imgArray && self.imgArray.count > 0)
//    {
//        
//    }
//    [super updateConstraints];
//}

- (void)awakeFromNib
{
    self.img_collection.dataSource = self;
    self.img_collection.delegate = self;
    [self.img_collection registerClass:[ImgCell class] forCellWithReuseIdentifier:@"ImgCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
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
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.imgArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.imgArray.count)
        return [self.imgArray objectAtIndex:index];
    return nil;
}

@end
