//
//  MyCollectionViewCell.h
//  MiTuan
//
//  Created by wangZL on 15/4/24.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageRating;
@property (weak, nonatomic) IBOutlet UILabel *addLable;

@end
