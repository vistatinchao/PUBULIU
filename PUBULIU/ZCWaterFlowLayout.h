//
//  ZCWaterFlowLayout.h
//  PUBULIU
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 United Network Services Ltd. of Shenzhen City. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCWaterFlowLayout;
@protocol ZCWaterFlowLayoutDelegate<NSObject>
@required
- (CGFloat)waterflowlayout:(ZCWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)columnCountInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout;

@end
@interface ZCWaterFlowLayout : UICollectionViewLayout
@property (nonatomic,weak)id<ZCWaterFlowLayoutDelegate>delegate;

@end
