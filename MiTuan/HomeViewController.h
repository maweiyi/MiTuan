//
//  HomeViewController.h
//  MiTuan
//
//  Created by wangZL on 15-4-10.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "SDRefresh.h"
@interface HomeViewController : UIViewController
@property(nonatomic,copy)NSString *cityID;
@property(nonatomic,copy)NSString *cityName;

//作为下拉刷新的控件
//@property(nonatomic,strong)MJRefreshHeaderView *headView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//作为上拉加载的控件
@property (nonatomic,strong)MJRefreshFooterView *footView;
@end
