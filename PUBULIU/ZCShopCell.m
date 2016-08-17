//
//  ZCShopCell.m
//  PUBULIU
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 United Network Services Ltd. of Shenzhen City. All rights reserved.
//

#import "ZCShopCell.h"
#import "ZCShop.h"
#import "UIImageView+WebCache.h"
@interface ZCShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
@implementation ZCShopCell

- (void)setShop:(ZCShop *)shop
{
    _shop = shop;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img]];
    self.priceLabel.text = shop.price;
}

@end
