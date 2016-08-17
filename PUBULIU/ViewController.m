//
//  ViewController.m
//  PUBULIU
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 United Network Services Ltd. of Shenzhen City. All rights reserved.
//

#import "ViewController.h"
#import "ZCWaterFlowLayout.h"
#import "ZCShop.h"
#import "ZCShopCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
@interface ViewController ()<UICollectionViewDataSource,ZCWaterFlowLayoutDelegate>
@property (nonatomic,strong) NSMutableArray *shops;
@property (nonatomic,weak) UICollectionView *collectionView;
@end

@implementation ViewController
static NSString *const ZCShopID = @"shop";
- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [self setupRefresh];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupLayout
{
    ZCWaterFlowLayout *layout = [[ZCWaterFlowLayout alloc]init];
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZCShopCell class]) bundle:nil] forCellWithReuseIdentifier:ZCShopID];
    self.collectionView = collectionView;
}
- (void)setupRefresh
{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];

    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ZCShop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ZCShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
}
#pragma mark collectionview代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZCShopID forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

#pragma mark - <ZCWaterFlowlayoutDelegate>

- (CGFloat)waterflowlayout:(ZCWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    ZCShop *shop = self.shops[index];
    return itemWidth*shop.h/shop.w;
}

- (CGFloat)columnCountInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout
{
    if (self.shops.count<=50) {
        return 2;
    }
    return 3;
}

- (CGFloat)rowMarginInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout
{
    return 20;
}

- (UIEdgeInsets )edgeInsetsInWaterflowLayout:(ZCWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 20, 30, 10);
}




@end
