//
//  SubHomeSerchView.m
//  MiTuan
//
//  Created by wangZL on 15-4-11.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "SubHomeSerchView.h"

#define WINDOW_WEIGHT [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation SubHomeSerchView
//{
//    BMKMapView *_mapView;
//    BMKMapManager *_manager;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//view高40
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatBackground];
        
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
-(void)creatBackground{
    self.userInteractionEnabled = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 6, 260, 26)];
    [self addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 225, 26)];
    label.text = @"输入商家、分类或商圈";
    label.textColor = [UIColor lightGrayColor];
     label.userInteractionEnabled = YES;
   
   
    [view addSubview:label];
 
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 22, 22)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"search_green" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [searchBtn setImage:image forState:UIControlStateNormal];
    [view addSubview:searchBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    [view addSubview:btn];
    [btn addTarget:self action:@selector(Tiao) forControlEvents:UIControlEventTouchUpInside];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
}
-(void)Tiao{
    NSLog(@"aaaa");
    self.Tiaozhuan();
}


@end
