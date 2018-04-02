//
//  GoodsChooseView.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsChooseView.h"
#import "UIView+GoodView.h"
#import "GoodsChooseCell.h"

#define SCREEN [UIScreen mainScreen].bounds.size
NSString * const GoodsChooseCellIdentifier = @"GoodsChooseCellIdentifier";
@interface GoodsChooseView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic, strong) NSMutableArray * selectedArray;
@property(nonatomic, strong) NSArray * showArray;
@end
@implementation GoodsChooseView
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:[self getCollectionViewFrame] collectionViewLayout: [self getCollectionViewLayout]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
    }
    return _collectionView;
}
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (CGRect)getCollectionViewFrame{
    
    return CGRectZero;
}
- (UICollectionViewLayout *)getCollectionViewLayout{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return collectionViewLayout;
    
}
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)showArray {
    self=[super initWithFrame:frame];
    if (self) {

       self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.showArray = showArray;
       [self uiConfiguer];
    }
    return self;
}


- (void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsChooseCell class]) bundle:nil] forCellWithReuseIdentifier:GoodsChooseCellIdentifier];
}
-(void)uiConfiguer{
    _bageView= [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN.height, SCREEN.width, 260)];
    //    _bageView.backgroundColor=[UIColor colorWithRed: arc4random_uniform(256)/255.0f green: arc4random_uniform(256)/255.0f blue: arc4random_uniform(256)/255.0f alpha:1];
    _bageView.backgroundColor = UIColorFromHex(0XF2F2F2);
    _bageView.userInteractionEnabled=YES;
    [self addSubview:_bageView];
    
    UIButton * cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 5, 40, 30)];
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromHex(0x4893F6) forState:UIControlStateNormal];
    [_bageView addSubview:cancelBtn];
    
    UIButton * completeBtn=[[UIButton alloc]initWithFrame:CGRectMake( SCREEN.width-50, 5, 40, 30)];
    [completeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:UIColorFromHex(0x4893F6) forState:UIControlStateNormal];
    [_bageView addSubview:completeBtn];
     [self registerCell];
    self.collectionView.frame = CGRectMake(0, completeBtn.bottom+5, SCREEN.width, _bageView.height-completeBtn.bottom-5);
    [self.bageView addSubview:self.collectionView];
   
}

- (void)show {
    self.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bageView.top =SCREEN.height-self.bageView.height;
    }];
    [self.collectionView reloadData];
}
- (void)dismis {
    [UIView animateWithDuration:0.3 animations:^{
        self.bageView.top=SCREEN.height;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)btnClicked:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self dismis];
    } else {
        if (self.chooseBlock) {
            self.chooseBlock(self.selectedArray);
            [self dismis];
        }
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.showArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =nil;
    
    GoodsChooseCell * tempCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GoodsChooseCellIdentifier forIndexPath:indexPath];
    [tempCell setupGoodsInfo:self.showArray[indexPath.row]];
    cell = tempCell;
    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN.width/4, 44);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){SCREEN.width,0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){SCREEN.width,0};
}




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor greenColor];
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        //        NSLog(@"-------------执行拷贝-------------");
        [_collectionView performBatchUpdates:^{
            
            //         [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        NSLog(@"-------------执行粘贴-------------");
    }
}

@end
