//
//  CityViewController.h
//  MiTuan
//
//  Created by wangZL on 15-4-13.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
#import "DPAppDelegate.h"

typedef void(^CitySetBlock)(CityModel *model,NSArray *arr);
@interface CityViewController : UIViewController

@property(nonatomic,copy)CitySetBlock cityBlock;
@end
