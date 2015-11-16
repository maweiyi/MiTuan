//
//  MyTableViewCell.m
//  MiTuan
//
//  Created by wangZL on 15-4-15.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "MyTableViewCell.h"


@implementation MyTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
//        backImage.image = [UIImage imageNamed:@"背景图.png"];
//        [self.contentView addSubview:backImage];

        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 130)];
       // backView.image = [UIImage imageNamed:@"cellBjing4.jpeg"];
        backView.image = [UIImage imageNamed:@"cell1.jpg"];
        [self.contentView addSubview:backView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 136, 113)];
        imageView.tag = 10000;
        imageView.layer.cornerRadius = 25;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:imageView];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(146, 8, 160, 30)];
        self.lable.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.lable];
        
        self.lableDes = [[UILabel alloc] initWithFrame:CGRectMake(146, 43, 200, 35)];
        self.lableDes.font = [UIFont systemFontOfSize:12];
        self.lableDes.numberOfLines = 2;
        self.lableDes.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.lableDes];
        
        self.lablePrice = [[UILabel alloc] initWithFrame:CGRectMake(140, 82, 42, 34)];
        self.lablePrice.font = [UIFont systemFontOfSize:18];
        self.lablePrice.textColor = [UIColor colorWithRed:3/255.0 green:101/255.0 blue:151/255.0 alpha:1.0];
        self.lablePrice.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lablePrice];
        
        self.lableAdd = [[UILabel alloc] initWithFrame:CGRectMake(251, 82, 129, 34)];
        self.lableAdd.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.lableAdd];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(184, 87, 23, 27)];
        lable.font = [UIFont systemFontOfSize:12];
        lable.text = @"元";
        [self.contentView addSubview:lable];
        
        self.lableYuanPrice = [[UILabel alloc] initWithFrame:CGRectMake(207, 92, 30, 25)];
        self.lableYuanPrice.font = [UIFont systemFontOfSize:12];
        self.lableYuanPrice.textColor = [UIColor grayColor];
        self.lableYuanPrice.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lableYuanPrice];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(210, 104.5, 24, 1)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        [self.contentView addSubview:view];
    }
    return self;
}

-(void)setModel:(ShangPinModel *)model{
    [self setImageView:model.image];
    self.lable.text = model.title;
    self.lableAdd.text = model.address;
    self.lablePrice.text = model.currentPrice;
    self.lableDes.text = model.descri;
    self.lableYuanPrice.text = model.purchase_date;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImageView:(NSData *)data{
    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:10000];
    imageView.image = [UIImage imageWithData:data];
}


@end
