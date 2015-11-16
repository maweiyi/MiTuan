//
//  ShangPinViewController.h
//  MiTuan
//
//  Created by wangZL on 15-4-16.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPAppDelegate.h"

@interface ShangPinViewController : UIViewController
@property(nonatomic,copy)NSString *dealID;

-(instancetype)initWithID:(NSString *)dealID;
@end
