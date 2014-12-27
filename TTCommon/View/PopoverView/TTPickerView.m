//
//  TTPickerView.m
//  TravelGuide
//
//  Created by ZhangChuntao on 12/28/12.
//  Copyright (c) 2012 Ma Jianglin. All rights reserved.
//

#import "TTPickerView.h"
#import "UIImageView+WebCache.h"
#import "TTPickerCell.h"

#define kMarginVertical     1.0f
#define kTopLevelTableViewWidth     122
#define kContentViewCornorWidth     5


@interface TTPickerView()

@property(nonatomic, strong) UIButton *backgroundButton;
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;

@end

@implementation TTPickerView

- (void)dismissPopoverAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.alpha = 0;
                         self.backgroundButton.alpha = 0;
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             [self removeFromSuperview];
                             [self.backgroundButton removeFromSuperview];
                         }
                     }];
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    if (self.backgroundButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [button addTarget:self action:@selector(dismissPopoverAnimated:) forControlEvents:UIControlEventTouchDown];
        self.backgroundButton = button;
    }
    
    self.backgroundButton.frame = view.bounds;
    self.backgroundButton.alpha = 0;
    self.alpha = 0;
    self.hidden = NO;
    [view addSubview:self.backgroundButton];
    [view addSubview:self];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.backgroundButton.alpha = 1;
                         self.alpha = 1;
                     }];
    
    if (self.selectedIndexPath == nil)
    {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.tableView1 reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
    UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        cell.selected = YES;
    }
    
    if (self.numberOfComponents == 2)
    {
        [self.tableView2 reloadData];
        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:self.selectedIndexPath.row inSection:0];
        UITableViewCell *cell2 = [self.tableView2 cellForRowAtIndexPath:indexPath2];
        if (cell2)
        {
            cell2.selected = YES;
        }
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _numberOfComponents = 1;
        
        self.tableView1 = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView1.dataSource = self;
        self.tableView1.delegate = self;
        self.tableView1.showsVerticalScrollIndicator = NO;
        self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView1];
        
        self.hidden = YES;
    }
    return self;
}

- (void)setNumberOfComponents:(int)n
{
    _numberOfComponents = n;
    if (_numberOfComponents > 1)
    {
        CGRect rect = self.bounds;
        rect.origin.x = kTopLevelTableViewWidth;
        rect.size.width -= kTopLevelTableViewWidth;
        
        self.tableView2 = [[UITableView alloc] initWithFrame:rect];
        self.tableView2.dataSource = self;
        self.tableView2.delegate = self;
        self.tableView2.showsVerticalScrollIndicator = NO;
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView2];
    }
}

#pragma - UITableViewDataSource

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    if (tableView == self.tableView1)
    {
        numberOfRows = [self.dataSource numberOfSectionsInPickerView:self];
    }
    else
    {
        numberOfRows = [self.dataSource pickerView:self numberOfRowsInSection:_selectedIndexPath.section];
    }
    
    return numberOfRows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView1)
    {
        static NSString *TTPickerCellIdentifier = @"TTPickerCell";
        TTPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:TTPickerCellIdentifier];
        if (cell == nil)
        {
            NSArray *array = [[UINib nibWithNibName:@"TTPickerCell" bundle:nil] instantiateWithOwner:nil options:nil];
            cell = [array objectAtIndex:0];
        }
        
        cell.nameLabel.text = [self.dataSource pickerView:self titleForSection:indexPath.row];
        NSString *icon = [self.dataSource pickerView:self iconForSection:indexPath.row];
        if (icon)
        {
            [cell.iconView setImageWithURL:[NSURL URLWithString:icon]];
        }
        else
        {
            CGRect rect = cell.nameLabel.frame;
            rect.origin.x = 25;
            cell.nameLabel.frame = rect;
        }
        
//        if (indexPath.row == self.selectedIndexPath.section)
//        {
//            cell.selected = YES;
//        }
        
        return cell;
    }
    else if(tableView == self.tableView2)
    {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.indentationLevel = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
//        if (indexPath.row == self.selectedIndexPath.row)
//        {
//            cell.selected = YES;
//        }
        
        cell.textLabel.text = [self.dataSource pickerView:self titleForRow:indexPath.row inSection:self.selectedIndexPath.section];
        
        return cell;
    }
    
    return nil;
}


#pragma - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView1)
    {
        if (self.selectedIndexPath.section != indexPath.row)
        {
            //取消上个选中状态
            NSIndexPath *deselectIndexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
            UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:deselectIndexPath];
            cell.selected = NO;
            
            
            self.selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:indexPath.row];
            
            //如果2级分类有数据
            int num = [self.dataSource pickerView:self numberOfRowsInSection:self.selectedIndexPath.section];
            if (self.numberOfComponents == 2 && num > 0)
            {
                [self.tableView2 reloadData];
            }
            else
            {
                [self.delegate pickerView:self didSelectAtIndexPath:self.selectedIndexPath];
            }
        }
    }
    else
    {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectedIndexPath.section];
        [self.delegate pickerView:self didSelectAtIndexPath:self.selectedIndexPath];
    }
}



@end
