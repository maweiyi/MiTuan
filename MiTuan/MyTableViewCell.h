//
//  MyTableViewCell.h
//  MiTuan
//
//  Created by wangZL on 15-4-15.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangPinModel.h"

@interface MyTableViewCell : UITableViewCell

//@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UILabel *lable;
@property (strong, nonatomic)  UILabel *lableDes;
@property (strong, nonatomic)  UILabel *lablePrice;
@property (strong, nonatomic)  UILabel *lableAdd;
@property(strong,nonatomic)UILabel *lableYuanPrice;
-(void)setImageView:(NSData *)data;
-(void)setModel:(ShangPinModel *)model;
@end
