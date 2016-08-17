//
//  ZCWaterFlowLayout.m
//  PUBULIU
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 United Network Services Ltd. of Shenzhen City. All rights reserved.
//

#import "ZCWaterFlowLayout.h"

/** 默认的列数 */
static const NSInteger ZCDefaultColumnCount = 3;
/** 默认的每一列之间的距离 */
static const NSInteger ZCDeflaultColumnMargin = 10;
/** 默认的每一行之间的距离 */
static const NSInteger ZCDeflaultRowMargin = 10;
/** 默认的边缘间距 */
static const UIEdgeInsets ZCDeflaultEdgeInsets = {10,10,10,10};

@interface ZCWaterFlowLayout()
/** 存放所有cell的布局属性 */
@property (nonatomic,strong)NSMutableArray *attrsArray;
/** 存放所有列的的当前高度 */
@property (nonatomic,strong)NSMutableArray *columnHeights;
/** 内容高度 */
@property (nonatomic,assign)CGFloat contentHeight;
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation ZCWaterFlowLayout
#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }
    return ZCDeflaultRowMargin;
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }
    return ZCDeflaultColumnMargin;
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    }
    return ZCDefaultColumnCount;
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }
    return ZCDeflaultEdgeInsets;
}

#pragma mark - 懒加载

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 *  初始化
 */

- (void)prepareLayout
{
    [super prepareLayout];
    self.contentHeight = 0;
    [self.columnHeights removeAllObjects];
    for (NSInteger i=0; i<self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }

    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i=0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  cell 排布
 */

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 *  返回indexpath位置cell对应的布局属性
 */

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    CGFloat W = (collectionViewW-self.edgeInsets.left-self.edgeInsets.right-(self.columnCount-1)*self.columnMargin)/self.columnCount;
    CGFloat h = [self.delegate waterflowlayout:self heightForItemAtIndex:indexPath.item itemWidth:W];
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i<self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight>columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left+destColumn*(W+self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y!=self.edgeInsets.top) {
        y+=self.rowMargin;
    }
    attrs.frame  = CGRectMake(x, y, W, h);
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight<columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight+self.edgeInsets.bottom);
}









@end
