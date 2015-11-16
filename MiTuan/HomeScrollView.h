//
//  HomeScrollView.h
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModelOne.h"
#import "DPAppDelegate.h"
#import "AFNetworking.h"

typedef void(^BLOCKCA)(NSString *);
@interface HomeScrollView : UIScrollView
{
    
    NSManagedObjectContext *_context;
}
@property(nonatomic,strong)NSMutableArray *strArr;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,copy)BLOCKCA block;
@end