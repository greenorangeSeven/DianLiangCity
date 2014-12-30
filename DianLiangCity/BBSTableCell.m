//
//  BBSTableCell.m
//  NanNIng
//
//  Created by Seven on 14-9-11.
//  Copyright (c) 2014年 greenorange. All rights reserved.
//

#import "BBSTableCell.h"
#import "ImgCell.h"

@implementation BBSTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BBSTableCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
    self.imgCollectionView.dataSource = self;
    self.imgCollectionView.delegate = self;
    [self.imgCollectionView registerClass:[ImgCell class] forCellWithReuseIdentifier:@"ImgCell"];
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
    if ([self.photos count] == 0)
    {
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (NSString *d in self.imgArray ) {
            MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:d]];
            [photos addObject:photo];
        }
        self.photos = photos;
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = YES;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
    //    browser.wantsFullScreenLayout = YES;//是否全屏
    [browser setCurrentPhotoIndex:[indexPath row]];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:browser animated:YES];
}

//MWPhotoBrowserDelegate委托事件
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
@end
